#
# This file is part of LiteX-Agilex5-Test.
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause

import os
import subprocess
from shutil import which

from migen import *

from litex.gen import *

from gateware.agilex5_common import generate_quartus_ip

# Main PLL -----------------------------------------------------------------------------------------

class MainPLL(LiteXModule):
    def __init__(self, platform, clock_pad, reset_pad):
        self.platform = platform

        self.clk100m  = Signal()
        self.clk220m  = Signal()
        self.locked   = Signal()

        # # #

        self.specials += Instance("main_pll",
            # Input Clk/Reset.
            i_refclk   = clock_pad,
            i_rst      = reset_pad,

            # Locked.
            o_locked   = self.locked,

            # Output clk
            o_outclk_0 = self.clk220m,
            o_outclk_1 = self.clk100m,
        )
        self.add_sources(platform=platform)

    def add_sources(self, platform):
        ip_name  = "main_pll"
        curr_dir = os.path.abspath(os.path.dirname(__file__))
        ip_file  = os.path.join(curr_dir, ip_name + ".ip")
        generate_quartus_ip(platform, ip_name, curr_dir, ip_file)
