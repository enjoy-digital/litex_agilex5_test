                 __   _ __      _  __    ___       _ __         ____    ______        __
                / /  (_) /____ | |/_/___/ _ |___ _(_) /____ __ / __/___/_  __/__ ___ / /_
               / /__/ / __/ -_)>  </___/ __ / _ `/ / / -_) \ //__ \/___// / / -_|_-</ __/
              /____/_/\__/\__/_/|_|   /_/ |_\_, /_/_/\__/_\_\/____/    /_/  \__/___/\__/
                                           /___/
                        Initial Test/Support of LiteX on Altera Agilex5 FPGAs.
                             Developed by Enjoy-Digital for Altera.

[> Intro
--------

This project aims to integrate and test LiteX support on Agilex5 FPGAs, with the objective of
booting various Linux-capable SoCs. Different CPUs already supported by LiteX will be evaluated,
and resource usage will be compared across different FPGA architectures.

To facilitate Linux testing and demonstrate the use of additional LiteX cores and peripherals,
support for the following board peripherals will be added:
- LPDDR4 EMIF integration as an AXI-4 DRAM controller.
- LiteSDCard support.
- LiteEth support.

<p align="center"><img src="doc/architecture.png"></p>


[> Configs/Resource Usage
-------------------------

#### [> Linux capable SoC, 1 CPU @ 220MHz, LPDDR4, SDCard and Ethernet

| CPU Name           | soc.json                                                                  | .sof                                                                                                          | tftpboot                                                                                   | Resource Usage Report                                                                                                 |  ALMs  | RAMs  | DSPs |
|--------------------|---------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|--------|-------|------|
| Vexriscv-32-bit    | [soc.json](https://github.com/user-attachments/files/16850904/soc.json)   | [sof](https://github.com/user-attachments/files/16850900/intel_agilex5e_065b_premium_devkit_platform.sof.zip) | [tftpboot](https://github.com/user-attachments/files/16850905/tftpboot_vexriscv.zip)       | [fit.rpt](https://github.com/user-attachments/files/16886368/intel_agilex5e_065b_premium_devkit_platform.fit.rpt.txt) | 11,510 |  146  |   7  |
| NaxRiscv-32-bit    | [soc.json](https://github.com/user-attachments/files/16850971/soc.json)   | [sof](https://github.com/user-attachments/files/16850968/intel_agilex5e_065b_premium_devkit_platform.sof.zip) | [tftpboot](https://github.com/user-attachments/files/16850972/tftpboot_naxriscv_32.zip)    | [fit.rpt](https://github.com/user-attachments/files/16886426/intel_agilex5e_065b_premium_devkit_platform.fit.rpt.txt) | 28,772 |  237  |   7  |
| VexiiRiscv-32-bit  | [soc.json](https://github.com/user-attachments/files/16851016/soc.json)   | [sof](https://github.com/user-attachments/files/16851010/intel_agilex5e_065b_premium_devkit_platform.sof.zip) | [tftpboot](https://github.com/user-attachments/files/16851017/tftpboot_vexiiriscv_32.zip)  | [fit.rpt](https://github.com/user-attachments/files/16886475/intel_agilex5e_065b_premium_devkit_platform.fit.rpt.tx)  |  9,528 |  178  |   2  |
| VexiiRiscv-64-bit  | [soc.json](https://github.com/user-attachments/files/16851184/soc.json)   | [sof](https://github.com/user-attachments/files/16851178/intel_agilex5e_065b_premium_devkit_platform.sof.zip) | [tftpboot](https://github.com/user-attachments/files/16851185/tftpboot_vexiiriscv_64.zip)  | [fit.rpt](https://github.com/user-attachments/files/16886586/intel_agilex5e_065b_premium_devkit_platform.fit.rpt.txt) | 11,426 |  181  |   8  |

[> Getting started
------------------

#### [> Installing LiteX:

Install LiteX by following the instructions provided on the LiteX Wiki:

[LiteX Installation Instructions](https://github.com/enjoy-digital/litex/wiki/Installation)

#### [> Installing the RISC-V toolchain for the Soft-CPU:

To install the RISC-V toolchain, follow the manual installation steps or use the instructions from
the LiteX Wiki:

```bash
./litex_setup.py --gcc=riscv
```

#### [> Cloning the Repository

Clone the project repository with all its submodules using the following command:

```bash git clone git@github.com:enjoy-digital/litex_agilex_test.git --recursive ```

#### [> Ethernet fix

Go to LiteX repository to apply `fix_phy_rx_clk_transition.patch`

```bash
cd /LITEX_TOOLS_DIR/litex
patch -p1 < /somewhere/litex_agilex_test/fix_phy_rx_clk_transition.patch
# Re-install litex in ~/.local
pip3 install --user -e .
```

[> Build the Basic SoC
----------------------

### [> Build Commands


- `--cpu-type`       : Allow selecting LiteX CPU (ex vexriscv, vexriscv_smp, picorv32, etc...)
- `--with-spi-sdcard`: Enable SDCARD support in SPI mode (can't be used at the same time as `--with-sdcard`)
- `--with-sdcard`    : Enable SDCARD support in SDCARD mode (can't be used at the same time as `--with-spi-sdcard`)
- `--with-ethernet`  : Enable ethernet support. `--eth-ip` may be used to change default board IP and `--remote-ip` must be
  adapted to the host computer IP

### [> Standard Build

**Basic mode (vexriscv CPU, BRAM):**

```bash
./altera_agilex5e_065b_premium_devkit.py --build --integrated-main-ram-size=1024
```

<p align="center"><img src="doc/litex_bios_main_ram_bram.png"></p>

**DR mode (vexriscv CPU, DDR):**

```bash
./altera_agilex5e_065b_premium_devkit.py --build
```

<p align="center"><img src="doc/litex_bios_main_ram_lpddr.png"></p>

#### [> Note on booting firmware/image

In the following sections, GNU/Linux is booted using either *serialboot* or with *sdcardboot*.

- *serialboot*: this method involves booting through UART. It allows the firmware to be loaded over a serial connection,
  which is often used for initial development and debugging.
- *sdcardboot*: this method uses an SD card to store all the necessary files for booting. It is a convenient and portable
  option, especially for deploying the system in different environments.

For a detailed explanation of all the booting options provided by LiteX, including step-by-step instructions and additional
methods, please refer to the
[Load Aplication Code To CPU](https://github.com/enjoy-digital/litex/wiki/Load-Application-Code-To-CPU) page on the LiteX
wiki. This resource will give you a comprehensive understanding of how to load and execute application code on your CPU.

[> Build the Linux SoCs and Images
----------------------------------

This repository provides a script, called `make.py`, that can build the gateware and the software components (using *buildroot* for software).

### [> Usage

To run the script, use the following command:
```bash
./make.py --config=CONFIG --build-gateware --build --generate-dtb --copy-images [--prepare-tftp] [--rootfs=xxxx] [--soc-json=somewhere/soc.json] \
    [--eth-ip] [--remote-ip]
```

**Options**

- `--config=CONFIG`: specifies the Configuration to use. **CONFIG** must be one of the following:
  - **vexriscv**,
  - **naxriscv_32**,
  - **vexiiriscv_32**
  - **vexiiriscv_64**
- `--build-gateware`: builds first the gateware. The (`--config` argument is required when using this option
- `--build`: clones, configures and builds the root filesystem image, the bootloader and the kernel using *buildroot*
- `--generate-dtb`: converts the *soc.json* to *soc.dts* and produces the *soc.dtb*
- `--copy-images`: copy boot images (devicetree, boot.json, ...) from *images* to *build_CPU_VERSION/images*
- `--prepare-tftp`: copy images required by a netboot from *images* to */tftpboot/* directory
- `--rootfs` (optional, default: *ram0*): specifies the root filesystem. The user can select between a ramdisk (*ram0*) or the second SDCard partition (*mmcblk0p2*)
- `--soc-json`: provides the path to the *soc.json*.This option is only required when `--build-gateware` is not used
- `--eth-ip`: configure SoC IP address (default: *192.168.1.50*)
- `--remote-ip`: specify host computer IP address (default: *192.168.1.100*)

[> Boot Linux from Serial
-------------------------

Once both the gateware and software have been successfully built, all required files are present in *images* directory:
- *boot.json*
- *Image*
- *rootfs.cpio*
- *soc.dtb*
- *opensbi.bin*

To boot using `serialboot` use the following command:
```bash
litex_term /dev/ttyUSB1 --image images/boot.json
```

*NOTE:* with the default UART baudrate, downloading all files takes time: to reduce this delay `--uart-baudrate` must be
used with a value like `1000000`.

[> Boot Linux from SDCard
-------------------------

Once both the gateware and software have been successfully built, an image named *sdcard.img* will be generated and
located in *images* sub-directory. To write this image to the SDCard, use the following command:

 ```bash
 sudo dd if=images/sdcard.img of=/dev/sdXXX bs=4M status=progress
 ```

 **WARNING: using `dd` with the wrong device may erase the hard driver content. Ensure you have correctly identified the SDCard device before executing this command.**

[> Boot Linux from Network (tftp)
---------------------------------

Once both the gateware and software have been successfully built (with `--copy-images --prepare-tftp`), */tftpboot/* directory contains *boot.json*, *opensbi.bin*, *rootfs.cpio* and *soc.dtb* files.

To boot using `netboot` use the following command:
```bash
litex_term /dev/ttyUSB1
```

*NOTE:* if host computer is configured with an IP different than *192.168.1.100*, `--remote-ip` must be provided to change default value. If local network isn't *192.168.1.xx* both `--eth-ip` and `--remote-ip` must
be provided to change default values.
