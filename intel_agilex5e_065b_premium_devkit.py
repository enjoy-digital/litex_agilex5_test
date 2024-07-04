#!/usr/bin/env python3

#
# This file is part of LiteX-Boards.
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause

from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer

from litex.gen import *

from intel_agilex5e_065b_premium_devkit_platform import Platform

from litex.soc.integration.soc      import *
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.cores.led import LedChaser

from gateware.agilex5_lpddr4_wrapper import Agilex5LPDDR4Wrapper

# CRG ----------------------------------------------------------------------------------------------

class _CRG(LiteXModule):
    def __init__(self, platform, sys_clk_freq, with_lpddr=True):
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

        platform.add_period_constraint(self.cd_sys.clk, 1e9/sys_clk_freq)

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq=100e6, with_led_chaser=True, **kwargs):
        platform = Platform()

        # CRG --------------------------------------------------------------------------------------
        with_lpddr   = (kwargs.get("integrated_main_ram_size", 0) == 0)
        # According to ref design lpddr usr_clk is 116.625e6 (ie same frequency as refclk)
        sys_clk_freq = {True: 116.625e6, False: sys_clk_freq}[with_lpddr]
        self.crg   = _CRG(platform, sys_clk_freq, with_lpddr)

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

        # Leds -------------------------------------------------------------------------------------
        if with_led_chaser:
            self.leds = LedChaser(
                pads         = platform.request_all("user_led"),
                sys_clk_freq = sys_clk_freq)

# Build --------------------------------------------------------------------------------------------

def main():
    from litex.build.parser import LiteXArgumentParser
    parser = LiteXArgumentParser(platform=Platform, description="LiteX SoC on LiteX SoC on Agilex5E 065B.")
    parser.set_defaults(synth_tool="quartus_syn")
    parser.add_target_argument("--sys-clk-freq", default=100e6, type=float, help="System clock frequency.")

    # soc.json default path
    parser.set_defaults(soc_json = "build/intel_agilex5e_065b_premium_devkit_platform/soc.json")
    args = parser.parse_args()

    soc = BaseSoC(
        sys_clk_freq = args.sys_clk_freq,
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

