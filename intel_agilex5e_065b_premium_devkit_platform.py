#
# This file is part of LiteX-Boards.
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause

from litex.build.altera            import AlteraPlatform
from litex.build.altera.programmer import USBBlaster
from litex.build.generic_platform  import Pins, IOStandard, Subsignal, Misc

# IOs ----------------------------------------------------------------------------------------------

_io = [

    # Clk
    ("clk100",     0, Pins("D8"),    IOStandard("3.3-V LVCMOS")), # SI5332 OUT4
    ("sys_clk100", 0, Pins("BF111"), IOStandard("3.3-V LVCMOS")), # SI5332 OUT5

    # Serial
    ("serial", 0,
        Subsignal("rx", Pins("CJ2")),
        Subsignal("tx", Pins("CK4")),
        IOStandard("3.3-V LVCMOS"),
    ),

    # Leds
    ("user_led", 0, Pins("BM59"), IOStandard("1.1 V")),
    ("user_led", 0, Pins("BH59"), IOStandard("1.1 V")),
    ("user_led", 0, Pins("BH62"), IOStandard("1.1 V")),
    ("user_led", 0, Pins("BK59"), IOStandard("1.1 V")),

    # Switches
    ("user_sw", 0, Pins("CH12"), IOStandard("3.3-V LVCMOS")),
    ("user_sw", 1, Pins("BU22"), IOStandard("3.3-V LVCMOS")),
    ("user_sw", 2, Pins("BW19"), IOStandard("3.3-V LVCMOS")),
    ("user_sw", 3, Pins("BH28"), IOStandard("3.3-V LVCMOS")),

    # Buttons
    ("user_btn", 0, Pins("BK31"), IOStandard("3.3-V LVCMOS")),
    ("user_btn", 1, Pins("BP22"), IOStandard("3.3-V LVCMOS")),
    ("user_btn", 2, Pins("BK28"), IOStandard("3.3-V LVCMOS")),
    ("user_btn", 3, Pins("BR22"), IOStandard("3.3-V LVCMOS")),

    # LPDDR4
    ("lpddr_refclk", 0,
        Subsignal("p", Pins("BW78"), IOStandard("1.1V TRUE DIFFERENTIAL SIGNALING")),
        Subsignal("n", Pins("CA78"), IOStandard("1.1V TRUE DIFFERENTIAL SIGNALING")),
    ),
    ("lpddr4", 0, # FIXME: IOStandard
        Subsignal("clk_p",   Pins("BM81")),
        Subsignal("clk_n",   Pins("BP81")),
        Subsignal("cke",     Pins("BR81")),
        Subsignal("reset_n", Pins("BH92")),
        Subsignal("cs",      Pins("BR78")),
        Subsignal("ca",      Pins("BR89 BU89 BR92 BU92 BW89 CA89")),
        Subsignal("dq",      Pins(
            "CA71 CC71 CH71 CF71 CH62 CF62 CH59 CF59",
            "BR59 BU59 BW59 CA59 BU71 BU69 BR71 BR69",
            "CC92 CF92 CA92 CH92 CC81 CF78 CH78 CA81",
            "CL82 CK80 CK76 CL76 CK97 CL97 CK94 CL91"),
        ),
        Subsignal("dqs_p",   Pins("CH69 BW69 CH89 CL88")),
        Subsignal("dqs_n",   Pins("CF69 CA69 CF89 CK88")),
        Subsignal("dmi",     Pins("CA62 BU62 CF81 CK85")),
        Subsignal("rzq",     Pins("BH89")),
    ),

    # SGMII Clock (88E2110 SGMII Enet1)
    ("eth_clocks", 0,
        Subsignal("p", Pins("AT120"), IOStandard("LVDS")),
        Subsignal("n", Pins("AT115"), IOStandard("LVDS")),
    ),

    # SGMII Ethernet (88E2110 SGMII Enet1)
    ("eth", 0,
        Subsignal("int_n", Pins("BK118")),
        Subsignal("rst_n", Pins("BM118")),
        Subsignal("mdio",  Pins("BM112")),
        Subsignal("mdc",   Pins("BP112")),
        Subsignal("rx_p",  Pins("AK135")),
        Subsignal("rx_n",  Pins("AK133")),
        Subsignal("tx_p",  Pins("AL129")),
        Subsignal("tx_n",  Pins("AL126")),
    ),

    # SFP
    ("sfp", 0,
        Subsignal("clk_p", Pins("BC29")),
        Subsignal("clk_n", Pins("BC25")),
        Subsignal("rx_p",  Pins("BN1")),
        Subsignal("rx_n",  Pins("BN3")),
        Subsignal("tx_p",  Pins("BL7")),
        Subsignal("tx_n",  Pins("BL10")),
    ),
    ("sfp_rx", 0,
        Subsignal("p",     Pins("BN1")),
        Subsignal("n",     Pins("BN3")),
    ),
    ("sfp_tx", 0,
        Subsignal("p",     Pins("BL7")),
        Subsignal("n",     Pins("BL10")),
    ),
    ("sfp_tx_disable_n", 0, Pins("AU10")),
    ("sfp0_ctl", 0,
        Subsignal("prsntn",        Pins("BF32")),
        Subsignal("tx_fault",      Pins("BE25")),
        Subsignal("rx_los",        Pins("BE29")),
        Subsignal("rs0",           Pins("BE21")),
        Subsignal("rs1",           Pins("BE43")),
        Subsignal("link_act_ledn", Pins("BR19")),
        IOStandard("3.3-V LVCMOS"),
    ),

    ("qsfp", 0,
        Subsignal("clk_p",  Pins("BB120")),
        Subsignal("clk_n",  Pins("BB115")),
        Subsignal("rx_p",   Pins("BV135 BN135 BJ135 BF135")),
        Subsignal("rx_n",   Pins("BV133 BN133 BJ133 BF133")),
        Subsignal("tx_p",   Pins("BY129 BT129 BL129 BG129")),
        Subsignal("tx_n",   Pins("BY126 BT126 BL126 BG126")),
    ),
]

# Connectors ---------------------------------------------------------------------------------------

_connectors = [
           # VCC                                         GND
    ("j9", " --- BU31 BU28 BM28 BP31 BF21 BR28 BM31 BR31 ---"),
]

# Platform -----------------------------------------------------------------------------------------

class Platform(AlteraPlatform):
    default_clk_name   = "clk100"
    default_clk_period = 1e9/100e6

    def __init__(self, toolchain="quartus"):
        AlteraPlatform.__init__(self, "A5ED065BB32AE6SR0", _io, _connectors, toolchain=toolchain)

    def do_finalize(self, fragment):
        AlteraPlatform.do_finalize(self, fragment)
        self.add_period_constraint(self.lookup_request("clk100", loose=True), 1e9/100e6)
