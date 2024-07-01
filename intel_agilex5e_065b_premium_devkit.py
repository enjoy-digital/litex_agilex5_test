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

from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *
from litex.soc.cores.led import LedChaser

# CRG ----------------------------------------------------------------------------------------------

class _CRG(LiteXModule):
    def __init__(self, platform, sys_clk_freq):
        self.rst    = Signal()
        self.cd_sys = ClockDomain()
        self.cd_por = ClockDomain()

        # # #

        # Clk / Rst
        clk100 = platform.request("clk100")
        rst_n  = platform.request("user_btn", 0)

        # Clocking
        self.comb += self.cd_sys.clk.eq(clk100)
        platform.add_period_constraint(self.cd_sys.clk, 1e9/sys_clk_freq)

        # Power on reset
        por_count = Signal(16, reset=2**16-1)
        por_done  = Signal()
        self.comb += por_done.eq(por_count == 0)
        self.comb += self.cd_por.clk.eq(self.cd_sys.clk)
        self.sync.por += If(~por_done, por_count.eq(por_count - 1))
        self.specials += [
            AsyncResetSynchronizer(self.cd_por, ~rst_n),
            AsyncResetSynchronizer(self.cd_sys, ~por_done | self.rst)
        ]

# BaseSoC ------------------------------------------------------------------------------------------

class BaseSoC(SoCCore):
    def __init__(self, sys_clk_freq=100e6, with_led_chaser=True, **kwargs):
        platform = Platform()

        # CRG --------------------------------------------------------------------------------------
        self.crg = _CRG(platform, sys_clk_freq)

        # SoCCore ----------------------------------------------------------------------------------
        SoCCore.__init__(self, platform, sys_clk_freq, ident="LiteX SoC on Agilex5E 065B", **kwargs)

        # Leds -------------------------------------------------------------------------------------
        if with_led_chaser:
            self.leds = LedChaser(
                pads         = platform.request_all("user_led"),
                sys_clk_freq = sys_clk_freq)

# Build --------------------------------------------------------------------------------------------

def main():
    from litex.build.parser import LiteXArgumentParser
    parser = LiteXArgumentParser(platform=Platform, description="LiteX SoC on LiteX SoC on Agilex5E 065B.")
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

