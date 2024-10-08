#!/usr/bin/env python3

#
# This file is part of LiteX-Agilex5-Test
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause

from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer

from litex.build.generic_platform import *
from litex.build.io import DifferentialInput

from litex.gen import *

from altera_agilex5e_065b_premium_devkit_platform import Platform, _sdcard_io

from litex.soc.integration.soc      import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder  import *
from litex.soc.cores.led            import LedChaser

from gateware.main_pll.main_pll       import MainPLL
from gateware.agilex5_lpddr4_wrapper  import Agilex5LPDDR4Wrapper
from gateware.axi_l2_cache            import AXIL2Cache
from gateware.agilex5_pll             import Agilex5PLL
from gateware.agilex5_rgmii           import *

from litescope import LiteScopeAnalyzer

# CRG ----------------------------------------------------------------------------------------------

class _CRG(LiteXModule):
    def __init__(self, platform, sys_clk_freq,
        with_lpddr4        = True,
        with_ethernet      = False,
        with_iopll_wrapper = False,
        ):
        self.rst          = Signal()
        self.cd_sys       = ClockDomain()
        self.cd_por       = ClockDomain()
        self.lpddr_rst    = Signal()

        # # #

        # Clk / Rst
        clk100 = platform.request("clk100")
        rst_n  = platform.request("user_btn", 0)

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
            self.mainPLL = Agilex5PLL()
            self.comb += self.mainPLL.reset.eq(ninit_done | ~rst_n)
            self.mainPLL.register_clkin(clk100, 100e6)

            self.comb += clk220m.eq(self.mainPLL.clko[1])

        self.comb += self.cd_sys.clk.eq(clk220m)
        self.specials += AsyncResetSynchronizer(self.cd_sys, ~self.mainPLL.locked | ~por_done | self.rst | self.lpddr_rst),

        platform.add_period_constraint(self.cd_sys.clk, 1e9/sys_clk_freq)
        platform.add_period_constraint(clk100, 1e9/100e6)

        if with_lpddr4:
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
            pll_ref_clk        = platform.request("clk125")
            self.cd_eth_refclk = ClockDomain()
            self.comb += self.cd_eth_refclk.clk.eq(pll_ref_clk)
            self.specials += AsyncResetSynchronizer(self.cd_eth_refclk, ~por_done | ninit_done)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq=220e6,
        with_ethernet        = False,
        eth_ip               = "192.168.1.50",
        remote_ip            = None,
        eth_dynamic_ip       = False,
        with_led_chaser      = True,
        with_spi_sdcard      = False,
        with_sdcard          = False,
        with_lpddr4_analyzer = False,
        **kwargs):
        # Platform ---------------------------------------------------------------------------------
        platform = Platform()

        # Parameters -------------------------------------------------------------------------------
        with_lpddr4 = (kwargs.get("integrated_main_ram_size", 0) == 0)

        # CRG --------------------------------------------------------------------------------------
        self.crg = _CRG(platform, sys_clk_freq, with_lpddr4, with_ethernet)

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq, ident="LiteX SoC on Agilex5E 065B", **kwargs)

        # LPDDR4 -----------------------------------------------------------------------------------
        if with_lpddr4:
            # Add LPDDR4 IP.
            self.lpddr = Agilex5LPDDR4Wrapper(platform, pads=platform.request("lpddr4"))
            self.comb += self.crg.lpddr_rst.eq(~self.lpddr.cal_done)

            # Add AXI L2 Cache.
            self.l2_cache = AXIL2Cache(platform)

            # Add LPDDR4 region.
            main_ram_region = SoCRegion(
                origin = self.mem_map.get("main_ram", None),
                size   = 1 * GB,
                mode   = "rwx")
            self.bus.add_region("main_ram", main_ram_region)

            # Connect L2 Cache and LPDDR4 IP to SoC: SoC -> L2 Cache -> LPDDR4.
            self.bus.add_slave(name="main_ram", slave=self.l2_cache.s_axi)
            self.comb += self.l2_cache.m_axi.connect(self.lpddr.bus)

        # SDCard -----------------------------------------------------------------------------------
        if with_spi_sdcard or with_sdcard:
            platform.add_extension(_sdcard_io)
            if with_spi_sdcard:
                self.add_spi_sdcard()
            else:
                self.add_sdcard()

        # Ethernet ---------------------------------------------------------------------------------
        if with_ethernet:
            self.add_constant("ETH_PHY_RX_CLOCK_TRANSITION") # Change RX Clk transition.
            self.ethphy = LiteEthPHYRGMII(platform,
                clock_pads = self.platform.request("eth_clocks", 2),
                pads       = self.platform.request("eth", 2))
            self.add_ethernet(
                phy            = self.ethphy,
                dynamic_ip     = eth_dynamic_ip,
                local_ip       = eth_ip,
                remote_ip      = remote_ip,
                full_memory_we = True,
                software_debug = False)

            self.comb += platform.request("user_btn").eq(self.ethphy.rx.rx_ctl1)

        # Leds -------------------------------------------------------------------------------------
        if with_led_chaser:
            self.leds = LedChaser(
                pads         = platform.request_all("user_led"),
                sys_clk_freq = sys_clk_freq)

        # Analyzer ---------------------------------------------------------------------------------
        if with_lpddr4_analyzer:
              analyzer_signals_w = [
                  self.lpddr.bus.aw,
                  self.lpddr.bus.w,
                  self.lpddr.bus.b,
              ]
              analyzer_signals_r = [
                  self.lpddr.bus.ar,
                  self.lpddr.bus.r,
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
    parser.set_defaults(output_dir="build/altera_agilex5e_065b_premium_devkit_platform")

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

