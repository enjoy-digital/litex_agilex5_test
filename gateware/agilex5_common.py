#
# This file is part of LiteX-Agilex5-Test.
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause

import os
import subprocess
from shutil import which

# FIXME: Should be directly integrated in LiteX and done during the build, not during design elaboration.

def generate_quartus_ip(platform, ip_name, curr_dir, ip_file=None):
    """
    Generate Quartus or Platform Designer (Qsys) IP files using the appropriate tool and add them to the platform.

    Parameters:
    platform -- The platform where the IP is being added.
    ip_name -- The name of the IP to generate.
    curr_dir -- The directory where the IP files reside.
    ip_file -- Optional: The full path to the IP file to be added to the platform.
    """
    if not ip_file:
        # Default to standard Quartus .ip file.
        ip_file = os.path.join(curr_dir, ip_name + ".ip")

    platform.add_ip(ip_file)

    # Determine if the IP file is for Qsys based on its extension.
    if ip_file.endswith(".qsys"):
        if which("qsys-generate") is None:
            raise OSError("Unable to find qsys-generate. Please add Quartus to your $PATH.")

        # Generate the Platform Designer IP synthesis files.
        ret = subprocess.run(f"qsys-generate --synthesis {ip_file}", shell=True)
        if ret.returncode != 0:
            raise OSError(f"Error occurred during qsys-generate for {ip_name}.")
    elif ip_file.endswith(".ip"):
        if which("quartus_ipgenerate") is None:
            raise OSError("Unable to find Quartus toolchain. Please add Quartus to your $PATH.")

        # Step 1: Generate project files for the IP.
        command = f"quartus_ipgenerate --generate_project_ip_files {ip_name}"
        ret = subprocess.run(command, shell=True)
        if ret.returncode != 0:
            raise OSError(f"Error occurred during Quartus's project generation for {ip_name}.")

        # Step 2: Generate the IP files for synthesis.
        command = f"quartus_ipgenerate --generate_ip_file --synthesis=verilog --clear_ip_generation_dirs --ip_file={ip_file} {ip_name} --set=family=\"Agilex 5\""
        ret = subprocess.run(command, shell=True)
        if ret.returncode != 0:
            raise OSError(f"Error occurred during Quartus's IP file generation for {ip_name}.")
    else:
        raise ValueError(f"Unsupported IP file extension: {ip_file}")
