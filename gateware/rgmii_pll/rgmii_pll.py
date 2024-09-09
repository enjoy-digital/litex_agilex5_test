#
# This file is part of LiteX-Agilex5-Test.
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause

import os
from shutil import which
import subprocess

from migen import *

from litex.gen import *

from gateware.agilex5_common import generate_quartus_ip

# RGMII PLL ----------------------------------------------------------------------------------------

class RGMIIPLL(LiteXModule):
    def __init__(self, platform):
        self.platform       = platform
        self.eth_tx         = Signal()
        self.eth_tx_delayed = Signal()
        self.locked         = Signal()
        self.clkin          = Signal()
        self.reset          = Signal()

        # # #

        self.specials += Instance("rgmii_pll",
            # Input Clk/Reset.
            i_refclk   = self.clkin,
            i_rst      = self.reset,

            # Locked.
            o_locked   = self.locked,

            # Output clk
            o_outclk_0 = self.eth_tx,
            o_outclk_1 = self.eth_tx_delayed,
        )
        self.add_sources(platform=platform)

    def add_sources(self, platform):
        ip_name  = "rgmii_pll"
        curr_dir = os.path.abspath(os.path.dirname(__file__))
        ip_file  = os.path.join(curr_dir, ip_name + ".ip")
        generate_quartus_ip(self.platform, ip_name, curr_dir, ip_file)
