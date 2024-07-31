[> Intro
--------

This project aims to integrate and test LiteX support on Agilex5 FPGAs, with the objective of
booting various Linux-capable SoCs. Different CPUs already supported by LiteX will be evaluated,
and resource usage will be compared across different FPGA architectures.

To facilitate Linux testing and demonstrate the use of additional LiteX cores and peripherals,
support for the following board peripherals will be added:
- LPDDR4 EMIF integration as an AXI-4 DRAM controller
- LiteSDCard support
- LiteEth support

[> Getting started
------------------

#### [> Installing LiteX:

Install LiteX by following the instructions provided on the LiteX Wiki:

[LiteX Installation Instructions](https://github.com/enjoy-digital/litex/wiki/Installation)

[LiteX AXI Verilog Test](https://github.com/enjoy-digital/litex_verilog_axi_test) must also be installed:

```bash
git clone --recursive https://github.com/enjoy-digital/litex_verilog_axi_test
cd litex_verilog_axi_test
pip3 install --user -e .
```

#### [> Installing the RISC-V toolchain for the Soft-CPU:

To install the RISC-V toolchain, follow the manual installation steps or use the instructions from
the LiteX Wiki:

```bash
./litex_setup.py --gcc=riscv
```

#### [> Cloning the Repository

Clone the project repository with all its submodules using the following command:

```bash git clone git@github.com:enjoy-digital/litex_agilex_test.git --recursive ```


[> Build the Gateware
---------------------

### [> Build Commands

- `--with-spi-sdcard`: enable SDCARD support in SPI mode (can't be used at the same time as `--with-sdcard`)
- `--with-sdcard`: enable SDCARD support in SDCARD mode (can't be used at the same time as `--with-spi-sdcard`)
- `--with-ethernet`: enable ethernet support. `--eth-ip` may be used to change default board IP and `--remote-ip` must be
  adapted to the host computer IP

### [> Standard Build

**Basic mode (vexriscv CPU, BRAM):**

```bash
./intel_agilex5e_065b_premium_devkit.py --build --integrated-main-ram-size=1024
```

![LiteX bios with BRAM](figs/litex_bios_main_ram_bram.png)

**DR mode (vexriscv CPU, DDR):**

```bash
./intel_agilex5e_065b_premium_devkit.py --build
```

![LiteX bios with LPDDR](figs/litex_bios_main_ram_lpddr.png)

[> Build the Linux Image
------------------------

This repository provides a script, called `make.py`, that can build the gateware and the software components (using *buildroot* for software).

### [> Usage

To run the script, use the following command:
```bash
./make.py --cpu-type=CPU_TYPE --build-gateware --build --generate-dtb [--rootfs=xxxx] [--soc-json=somewhere/soc.json]
```

**Options**

- `--cpu-type=CPU_TYPE`: specifies the CPU to use. **CPU_TYPE** must be one of the following:
  - **vexriscv**,
  - **naxriscv_32**,
  - **vexiiriscv_32**
  - **vexiiriscv_64**
- `--build-gateware`: builds first the gateware. The (`--cpu-type` argument is required when using this option
- `--build`: clones, configures and builds the root filesystem image, the bootloader and the kernel using *buildroot*
- `--generate-dtb`: converts the *soc.json* to *soc.dts* and produces the *soc.dtb*
- `--rootfs` (optional, default: *ram0*): specifies the root filesystem. The user can select between a ramdisk (*ram0*) or the second SDCard partition (*mmcblk0p2*)
- `--soc-json`: provides the path to the *soc.json*.This option is only required when `--build-gateware` is not used

[> Boot Linux from Serial
-------------------------

TODO

[> Boot Linux from SDCard
-------------------------

Once both the gateware and software have been successfully built, an image named *sdcard.img* will be generated and
located in *images* sub-directory. To write this image to the SDCard, use the following command:

 ```bash
 sudo dd if=images/sdcard.img of=/dev/sdXXX bs=4M status=progress
 ```

 **WARNING: using `dd` with the wrong device may erase the hard driver content. Ensure you have correctly identified the SDCard device before executing this command.**