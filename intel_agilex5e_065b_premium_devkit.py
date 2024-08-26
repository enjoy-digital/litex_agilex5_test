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
from gateware.porRGMIIPLL.porRGMIIPLL import PorRGMIIPLL

# CRG ----------------------------------------------------------------------------------------------

class _CRG(LiteXModule):
    def __init__(self, platform, sys_clk_freq, with_lpddr=True, with_ethernet=False):
        self.rst      = Signal()
        self.cd_sys   = ClockDomain()
        self.cd_por   = ClockDomain()
        self.cd_lpddr = ClockDomain()

        # # #

        # Clk / Rst
        clk100        = platform.request("clk100")
        rst_n         = platform.request("user_btn", 0)


        # Power on reset
        por_count = Signal(16, reset=2**16-1)
        por_done  = Signal()
        self.comb += por_done.eq(por_count == 0)
        self.comb += self.cd_por.clk.eq(clk100)
        self.sync.por += If(~por_done, por_count.eq(por_count - 1))
        self.specials += AsyncResetSynchronizer(self.cd_por, ~rst_n),

        # Clocking
        if with_lpddr:
            self.comb     += self.cd_sys.clk.eq(ClockSignal("lpddr_usr"))
            self.specials += AsyncResetSynchronizer(self.cd_sys, ResetSignal("lpddr_usr"))
            # LPDDR4
            lpddr_refclk    = platform.request("lpddr_refclk")
            lpddr_refclk_se = Signal()
            self.specials += DifferentialInput(lpddr_refclk.p, lpddr_refclk.n, lpddr_refclk_se)
            self.comb     += self.cd_lpddr.clk.eq(lpddr_refclk_se)
            self.specials += AsyncResetSynchronizer(self.cd_lpddr, ~por_done | self.rst)
        else:
            self.comb     += self.cd_sys.clk.eq(clk100)
            self.specials += AsyncResetSynchronizer(self.cd_sys, ~por_done | self.rst)

        if with_ethernet:
            pll_ref_clk    = platform.request("hvio6d_clk125")
            self.rgmii_pll = PorRGMIIPLL(platform, pll_ref_clk, ~rst_n)

        platform.add_period_constraint(self.cd_sys.clk, 1e9/sys_clk_freq)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq=100e6,
        with_analyzer   = False,
        with_ethernet   = False,
        eth_ip          = "192.168.1.50",
        remote_ip       = None,
        eth_dynamic_ip  = False,
        with_led_chaser = True,
        with_spi_sdcard = False,
        with_sdcard     = False,
        with_crossbar   = False,
        with_l2_cache   = False,
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
                data_width          = data_width,
                with_crossbar       = with_crossbar,
                direct_axiinterface = False,
                with_l2_cache       = with_l2_cache)
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
            self.ethphy = GMIIToRGMII(platform,
                clock_pads = self.platform.request("eth_clocks", 2),
                pads       = self.platform.request("eth", 2))
            self.add_ethernet(phy=self.ethphy, dynamic_ip=eth_dynamic_ip, local_ip=eth_ip, remote_ip=remote_ip)

        # Leds -------------------------------------------------------------------------------------
        if with_led_chaser:
            self.leds = LedChaser(
                pads         = platform.request_all("user_led"),
                sys_clk_freq = sys_clk_freq)

# Build --------------------------------------------------------------------------------------------

def main():
    from litex.build.parser import LiteXArgumentParser
    parser = LiteXArgumentParser(platform=Platform, description="LiteX SoC on LiteX SoC on Agilex5E 065B.")
    parser.add_target_argument("--sys-clk-freq",    default=100e6, type=float, help="System clock frequency.")
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

