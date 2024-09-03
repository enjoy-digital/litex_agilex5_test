#!/usr/bin/env python3

#
# This file is part of LiteX-Boards.
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause

from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer

from litex.build.generic_platform import *
from litex.build.io import DifferentialInput

from litex.gen import *

from intel_agilex5e_065b_premium_devkit_platform import Platform, _sdcard_io

from litex.soc.integration.soc      import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.cores.led import LedChaser

from litescope import LiteScopeAnalyzer

from gateware.agilex5_lpddr4_wrapper import Agilex5LPDDR4Wrapper
from gateware.gmii_to_rgmii.gmii_to_rgmii import GMIIToRGMII
from gateware.intel_agilex_pll import AgilexPLL
from gateware.por_rgmii_pll.por_rgmii_pll import PorRGMIIPLL
from gateware.main_pll.main_pll import MainPLL
from gateware.agilex_rgmii import *

# CRG ----------------------------------------------------------------------------------------------

class _CRG(LiteXModule):
    def __init__(self, platform, sys_clk_freq,
        with_lpddr         = True,
        with_ethernet      = False,
        with_iopll_wrapper = False,
        ):
        self.rst          = Signal()
        self.cd_sys       = ClockDomain()
        self.cd_por       = ClockDomain()
        self.lpddr_rst    = Signal()

        # # #

        # Clk / Rst
        clk100        = platform.request("clk100")
        rst_n         = platform.request("user_btn", 0)

        # Power on reset
        ninit_done = Signal()
        self.specials += Instance("altera_agilex_config_reset_release_endpoint", o_conf_reset = ninit_done)

        por_count = Signal(16, reset=2**16-1)
        por_done  = Signal()
        self.comb += por_done.eq(por_count == 0)
        self.comb += self.cd_por.clk.eq(clk100)
        self.sync.por += If(~por_done, por_count.eq(por_count - 1))
        self.specials += AsyncResetSynchronizer(self.cd_por, ~rst_n | ninit_done)

        # PLL
        clk100m = Signal()
        clk220m = Signal()
        if not with_iopll_wrapper:
            self.mainPLL = MainPLL(platform, clk100, ninit_done | ~rst_n)
            self.comb += clk220m.eq(self.mainPLL.clk220m),
        else:
            self.mainPLL = AgilexPLL()
            self.comb += self.mainPLL.reset.eq(ninit_done | ~rst_n)
            self.mainPLL.register_clkin(clk100, 100e6)

            self.comb += clk220m.eq(self.mainPLL.clko[1])

        self.comb += self.cd_sys.clk.eq(clk220m),
        self.specials += AsyncResetSynchronizer(self.cd_sys, ~self.mainPLL.locked | ~por_done | self.rst | self.lpddr_rst),

        platform.add_period_constraint(self.cd_sys.clk, 1e9/sys_clk_freq)
        platform.add_period_constraint(clk100, 1e9/100e6)

        if with_lpddr:
            # LPDDR4
            self.cd_lpddr     = ClockDomain()
            self.cd_lpddr_cfg = ClockDomain()
            lpddr_refclk      = platform.request("lpddr_refclk")
            lpddr_refclk_se   = Signal()
            self.specials += DifferentialInput(lpddr_refclk.p, lpddr_refclk.n, lpddr_refclk_se)
            # LPDDR4 core Clk/Reset
            self.comb     += [
                self.cd_lpddr.clk.eq(lpddr_refclk_se),
                self.cd_lpddr.rst.eq(ninit_done)
            ]

            # LPDDR4 configuration interface Clk/Reset
            lpddr_cfg_rst = Signal()
            if not with_iopll_wrapper:
                self.comb += clk100m.eq(self.mainPLL.clk100m),
            else:
                self.comb += clk100m.eq(self.mainPLL.clko[0])

            self.comb += [
                self.cd_lpddr_cfg.clk.eq(clk100m),
                self.cd_lpddr_cfg.rst.eq(~lpddr_cfg_rst)
            ]
            self.specials += [
                Instance("altera_std_synchronizer_nocut",
                    p_depth     = 3,
                    p_rst_value = 0,
                    i_clk       = ClockSignal("lpddr_cfg"),
                    i_reset_n   = Constant(1, 1),
                    i_din       = ~ninit_done & self.mainPLL.locked & ~self.rst & por_done,
                    o_dout      = lpddr_cfg_rst,
                ),
            ]
            platform.add_period_constraint(self.cd_lpddr_cfg.clk, 1e9/100e6)

        if with_ethernet:
            pll_ref_clk        = platform.request("hvio6d_clk125")
            self.cd_eth_refclk = ClockDomain()
            self.comb += self.cd_eth_refclk.clk.eq(pll_ref_clk)
            self.specials += AsyncResetSynchronizer(self.cd_eth_refclk, ~por_done | ninit_done)
        #    self.rgmii_pll = PorRGMIIPLL(platform, pll_ref_clk, ~rst_n)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq=220e6,
        with_analyzer   = False,
        with_ethernet   = False,
        eth_ip          = "192.168.1.50",
        remote_ip       = None,
        eth_dynamic_ip  = False,
        with_led_chaser = True,
        with_spi_sdcard = False,
        with_sdcard     = False,
        with_crossbar   = False,
        **kwargs):
        platform = Platform()

        # CRG --------------------------------------------------------------------------------------
        with_lpddr   = (kwargs.get("integrated_main_ram_size", 0) == 0)
        #with_lpddr = True
        # According to ref design lpddr usr_clk is 116.625e6 (ie same frequency as refclk)
        #sys_clk_freq = {True: 116.625e6, False: sys_clk_freq}[with_lpddr]
        self.crg     = _CRG(platform, sys_clk_freq, with_lpddr, with_ethernet)

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq, ident="LiteX SoC on Agilex5E 065B", **kwargs)

        # LPDDR4 -----------------------------------------------------------------------------------
        if with_lpddr:
            data_width = {True: 64, False: 32}[hasattr(self.cpu, "add_memory_buses") and with_crossbar]
            self.lpddr = Agilex5LPDDR4Wrapper(platform, pads=platform.request("lpddr4"),
                data_width    = data_width,
                with_crossbar = with_crossbar)

            self.comb += self.crg.lpddr_rst.eq(~self.lpddr.cal_done)

            # Add SDRAM region.
            main_ram_region = SoCRegion(
                origin = self.mem_map.get("main_ram", None),
                size   = 1 * GB,
                mode   = "rwx")
            self.bus.add_region("main_ram", main_ram_region)

            if with_crossbar:
                self.lpddr.set_master_region(self.bus.regions["main_ram"])
                # Add CPU's direct memory buses (if not already declared) --------------------------
                if hasattr(self.cpu, "add_memory_buses"):
                    self.cpu.add_memory_buses(
                        address_width = 32,
                        data_width    = data_width,
                    )
                if len(self.cpu.memory_buses):
                    for mem_bus in self.cpu.memory_buses:
                        self.lpddr.axi_crossbar.add_slave(s_axi=mem_bus)

                self.main_ram_axi = axi.AXIInterface(
                    data_width    = data_width,
                    address_width = 32,
                    id_width      = 7,
                    aw_user_width = 4,
                    w_user_width  = 64,
                    b_user_width  = 0,
                    ar_user_width = 4,
                    r_user_width  = 64,
                )

                self.bus.add_slave(name="main_ram", slave=self.main_ram_axi)

                self.lpddr.axi_crossbar.add_slave(s_axi  = self.main_ram_axi)
            else:
                self.bus.add_slave(name="main_ram", slave=self.lpddr.bus)

            if with_analyzer:
                main_ram_bus = self.lpddr.bus_256b
                analyzer_signals_w = [
                    main_ram_bus.aw,
                    main_ram_bus.w,
                    main_ram_bus.b,
                ]
                analyzer_signals_r = [
                    main_ram_bus.ar,
                    main_ram_bus.r,
                ]

                self.analyzer_w = LiteScopeAnalyzer(analyzer_signals_w,
                    depth        = 128,
                    clock_domain = "sys",
                    register     = True,
                    csr_csv      = "analyzer_w.csv"
                )

                self.analyzer_r = LiteScopeAnalyzer(analyzer_signals_r,
                    depth        = 128,
                    clock_domain = "sys",
                    register     = True,
                    csr_csv      = "analyzer_r.csv"
                )

        # SDCard -----------------------------------------------------------------------------------
        if with_spi_sdcard or with_sdcard:
            platform.add_extension(_sdcard_io)
            if with_spi_sdcard:
                self.add_spi_sdcard()
            else:
                self.add_sdcard()

        # Ethernet ---------------------------------------------------------------------------------
        if with_ethernet:
            self.add_constant("ETH_PHY_RX_CLOCK_TRANSITION") # change RX Clk transition

            #self.ethphy = GMIIToRGMII(platform,
            self.ethphy = LiteEthPHYRGMII(platform,
                clock_pads = self.platform.request("eth_clocks", 2),
                pads       = self.platform.request("eth", 2))
            self.add_ethernet(
                phy            = self.ethphy,
                dynamic_ip     = eth_dynamic_ip,
                local_ip       = eth_ip,
                remote_ip      = remote_ip,
                software_debug = False)

            self.comb += platform.request("user_btn").eq(self.ethphy.rx.rx_ctl1)

        # Leds -------------------------------------------------------------------------------------
        if with_led_chaser:
            self.leds = LedChaser(
                pads         = platform.request_all("user_led"),
                sys_clk_freq = sys_clk_freq)

# Build --------------------------------------------------------------------------------------------

def main():
    from litex.build.parser import LiteXArgumentParser
    parser = LiteXArgumentParser(platform=Platform, description="LiteX SoC on LiteX SoC on Agilex5E 065B.")
    parser.add_target_argument("--sys-clk-freq",    default=220e6, type=float, help="System clock frequency.")
    parser.add_target_argument("--with-analyzer",   action="store_true",       help="Enable liteScope to probe LPDDR4 AXI.")
    sdopts = parser.target_group.add_mutually_exclusive_group()
    sdopts.add_argument("--with-spi-sdcard",        action="store_true",       help="Enable SPI-mode SDCard support.")
    sdopts.add_argument("--with-sdcard",            action="store_true",       help="Enable SDCard support.")
    parser.add_target_argument("--with-ethernet",   action="store_true",       help="Enable Ethernet support.")
    parser.add_target_argument("--eth-ip",          default="192.168.1.50",    help="Ethernet/Etherbone IP address.")
    parser.add_target_argument("--remote-ip",       default="192.168.1.100",   help="Remote IP address of TFTP server.")
    parser.add_target_argument("--eth-dynamic-ip",  action="store_true",       help="Enable dynamic Ethernet IP addresses setting.")

    parser.set_defaults(synth_tool="quartus_syn")
    parser.set_defaults(bus_standard="axi")
    parser.set_defaults(output_dir="build/intel_agilex5e_065b_premium_devkit_platform")

    # soc.json default path
    args = parser.parse_args()
    args.soc_json = f"{args.output_dir}/soc.json"

    soc = BaseSoC(
        sys_clk_freq    = args.sys_clk_freq,
        with_analyzer   = args.with_analyzer,
        with_ethernet   = args.with_ethernet,
        eth_ip          = args.eth_ip,
        remote_ip       = args.remote_ip,
        eth_dynamic_ip  = args.eth_dynamic_ip,
        with_spi_sdcard = args.with_spi_sdcard,
        with_sdcard     = args.with_sdcard,
        **parser.soc_argdict
    )

    builder = Builder(soc, **parser.builder_argdict)
    if args.build:
        builder.build(**parser.toolchain_argdict)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(builder.get_bitstream_filename(mode="sram"))

if __name__ == "__main__":
    main()

