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

from litex.gen import *

from intel_agilex5e_065b_premium_devkit_platform import Platform

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
            self.comb     += self.cd_lpddr.clk.eq(platform.request("lpddr_refclk").p)
            self.specials += AsyncResetSynchronizer(self.cd_lpddr, ~por_done | self.rst)
        else:
            self.comb += self.cd_sys.clk.eq(clk100)
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
        **kwargs):
        platform = Platform()

        # CRG --------------------------------------------------------------------------------------
        with_lpddr   = (kwargs.get("integrated_main_ram_size", 0) == 0)
        # According to ref design lpddr usr_clk is 116.625e6 (ie same frequency as refclk)
        sys_clk_freq = {True: 116.625e6, False: sys_clk_freq}[with_lpddr]
        self.crg   = _CRG(platform, sys_clk_freq, with_lpddr, with_ethernet)

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq, ident="LiteX SoC on Agilex5E 065B", **kwargs)

        # LPDDR4 -----------------------------------------------------------------------------------
        if with_lpddr:
            self.lpddr = Agilex5LPDDR4Wrapper(platform, pads=platform.request("lpddr4"))
            # Add SDRAM region.
            main_ram_region = SoCRegion(
                origin = self.mem_map.get("main_ram", None),
                size   = 1 * GB,
                mode   = "rwx")
            self.bus.add_region("main_ram", main_ram_region)

            self.bus.add_slave(name="main_ram", slave=self.lpddr.bus)

            if with_analyzer:
                main_ram_bus = self.bus.slaves["main_ram"]
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
        if with_spi_sdcard:
            platform.add_extension([
                ("spisdcard", 0, # FIXME: arbitrary choice
                    Subsignal("clk",  Pins(f"j9:7")),
                    Subsignal("mosi", Pins(f"j9:3")),
                    Subsignal("cs_n", Pins(f"j9:4")),
                    Subsignal("miso", Pins(f"j9:6")),
                    IOStandard("3.3V LVCMOS"),
                ),
            ])
            self.add_spi_sdcard()

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
    parser.add_target_argument("--with-spi-sdcard", action="store_true",       help="Enable SPI-mode SDCard support.")
    parser.add_target_argument("--with-ethernet",   action="store_true",       help="Enable Ethernet support.")
    parser.add_target_argument("--eth-ip",          default="192.168.1.50",    help="Ethernet/Etherbone IP address.")
    parser.add_target_argument("--remote-ip",       default="192.168.1.100",   help="Remote IP address of TFTP server.")
    parser.add_target_argument("--eth-dynamic-ip",  action="store_true",       help="Enable dynamic Ethernet IP addresses setting.")

    parser.set_defaults(synth_tool="quartus_syn")
    parser.set_defaults(bus_standard="axi")

    # soc.json default path
    parser.set_defaults(soc_json = "build/intel_agilex5e_065b_premium_devkit_platform/soc.json")
    args = parser.parse_args()

    soc = BaseSoC(
        sys_clk_freq    = args.sys_clk_freq,
        with_analyzer   = args.with_analyzer,
        with_ethernet   = args.with_ethernet,
        eth_ip          = args.eth_ip,
        remote_ip       = args.remote_ip,
        eth_dynamic_ip  = args.eth_dynamic_ip,
        with_spi_sdcard = args.with_spi_sdcard,
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

