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


[> Building the Gateware
------------------------

### [> Build Commands

- `--with-spi-sdcard`: enable SDCARD support in SPI mode (can't be used at the same time as `--with-sdcard`)
- `--with-sdcard`: enable SDCARD support in SDCARD mode (can't be used at the same time as `--with-spi-sdcard`)
- `--with-ethernet`: enable ethernet support. `--eth-ip` may be used to change default board IP and `--remote-ip` must be
  adapted to the host computer IP

### [> Standard Build

Basic mode (vexriscv CPU, BRAM):
```bash
./intel_agilex5e_065b_premium_devkit.py --build --integrated-main-ram-size=1024
```

DDR mode (vexriscv CPU, DDR):
```bash
./intel_agilex5e_065b_premium_devkit.py --build
```
