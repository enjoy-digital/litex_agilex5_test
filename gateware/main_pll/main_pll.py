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

    def do_finalize(self):

        curr_dir = os.path.abspath(os.path.dirname(__file__))
        ip_name = "main_pll"
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
