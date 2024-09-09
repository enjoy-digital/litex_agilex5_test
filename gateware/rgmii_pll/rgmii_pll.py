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

    def do_finalize(self):

        curr_dir = os.path.abspath(os.path.dirname(__file__))
        ip_name = "rgmii_pll"
        ip_file = os.path.join(curr_dir, ip_name + ".ip")
        self.platform.add_ip(ip_file)

        if which("quartus_ipgenerate") is None:
            msg = "Unable to find Quartus toolchain, please:\n"
            msg += "- Add Quartus toolchain to your $PATH."
            raise OSError(msg)

        # To works correctly quartus_ipgenerate needs two steps

        # 1. generates a project
        command = f"--generate_project_ip_files  {ip_name}"
        ret = subprocess.run(f"quartus_ipgenerate {command}", shell=True)
        if ret.returncode != 0:
            raise OSError("Error occured during Quartus's script execution.")

        # 2. generates the IP files
        command = f"--generate_ip_file --synthesis=verilog --clear_ip_generation_dirs --ip_file={ip_file} {ip_name} --set=family=\"Agilex 5\""

        ret = subprocess.run(f"quartus_ipgenerate {command}", shell=True)
        if ret.returncode != 0:
            raise OSError("Error occured during Quartus's script execution.")
