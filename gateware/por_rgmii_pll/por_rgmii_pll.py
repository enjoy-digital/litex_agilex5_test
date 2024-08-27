#
# This file is part of LiteX.
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause

import os
from shutil import which
import subprocess

from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer

from liteeth.phy.gmii_mii import *

from litex.gen import *

from litex.soc.interconnect import axi
from litex.soc.interconnect.csr import *


class PorRGMIIPLL(LiteXModule):

    def __init__(self, platform, clock_pad, reset_pad):
        self.platform = platform

        self.cd_rgmii_clk250 = ClockDomain()
        self.cd_rgmii_clk125 = ClockDomain()
        self.cd_rgmii_clk25  = ClockDomain()
        self.cd_rgmii_clk2_5 = ClockDomain()
        self.cd_pll_clk100   = ClockDomain()

        # # #

        locked = Signal()

        self.specials += Instance("porRGMIIPLL",
            # Input Clk/Reset.
            i_refclk     = clock_pad,
            i_rst        = reset_pad,

            # Locked.
            o_locked     = locked,

            # Output clk
            o_outclk_0 = ClockSignal("pll_clk100"),
            o_outclk_1 = ClockSignal("rgmii_clk250"),
            o_outclk_2 = ClockSignal("rgmii_clk125"),
            o_outclk_3 = ClockSignal("rgmii_clk25"),
            o_outclk_4 = ClockSignal("rgmii_clk2_5"),
        )

        self.specials += [
            AsyncResetSynchronizer(self.cd_pll_clk100,   ~locked),
            AsyncResetSynchronizer(self.cd_rgmii_clk250, ~locked),
            AsyncResetSynchronizer(self.cd_rgmii_clk125, ~locked),
            AsyncResetSynchronizer(self.cd_rgmii_clk25,  ~locked),
            AsyncResetSynchronizer(self.cd_rgmii_clk2_5, ~locked),
        ]

    def do_finalize(self):

        curr_dir = os.path.abspath(os.path.dirname(__file__))
        ip_name = "por_rgmii_pll"
        ip_file = os.path.join(curr_dir, ip_name + ".ip")
        self.platform.add_ip(ip_file)

        if which("quartus_ipgenerate") is None:
            msg = "Unable to find Quartus toolchain, please:\n"
            msg += "- Add Quartus toolchain to your $PATH."
            raise OSError(msg)

        # To works correctly quartus_ipgenerate needs two steps

        # 1. generates a project
        command = f"--generate_project_ip_files  {ip_name}"
        ret = subprocess.run(f"quartus_ipgenerate {command}", shell=True)
        if ret.returncode != 0:
            raise OSError("Error occured during Quartus's script execution.")

        # 2. generates the IP files
        command = f"--generate_ip_file --synthesis=verilog --clear_ip_generation_dirs --ip_file={ip_file} {ip_name} --set=family=\"Agilex 5\""

        ret = subprocess.run(f"quartus_ipgenerate {command}", shell=True)
        if ret.returncode != 0:
            raise OSError("Error occured during Quartus's script execution.")
