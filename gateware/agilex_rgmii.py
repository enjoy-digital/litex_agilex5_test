#
# This file is part of LiteX.
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause

# See.
# https://www.intel.com/content/www/us/en/docs/programmable/683130/22-3/fpga-gmii-to-rgmii-converter-core-interface.html

from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer

from litex.gen import *

from liteeth.common import *
from liteeth.phy.common import *

from gateware.rgmii_pll.rgmii_pll import RGMIIPLL

# LiteEth PHY RGMII TX -----------------------------------------------------------------------------

class LiteEthPHYRGMIITX(LiteXModule):
    def __init__(self, pads):
        self.sink      = sink = stream.Endpoint(eth_phy_description(8))

        # # #

        tx_ctl_obuf  = Signal()
        tx_data_obuf = Signal(4)

        self.specials += [
            Instance("tennm_ph2_ddio_out",
                p_mode      = "MODE_DDR",
                p_asclr_ena = "ASCLR_ENA_NONE",
                p_sclr_ena  = "SCLR_ENA_NONE",
                o_dataout   = tx_ctl_obuf,
                i_datainlo  = sink.valid,
                i_datainhi  = sink.valid,
                i_clk       = ClockSignal("eth_tx"),
                i_ena       = Constant(1, 1),
                i_areset    = Constant(1, 1),
                i_sreset    = Constant(1, 1),
            ),
            Instance("tennm_ph2_io_obuf",
                p_open_drain = "OPEN_DRAIN_OFF",
                i_i          = tx_ctl_obuf,
                o_o          = pads.tx_ctl,
            ),
        ]


        for i in range(4):
            self.specials += [
                Instance("tennm_ph2_ddio_out",
                    p_mode      = "MODE_DDR",
                    p_asclr_ena = "ASCLR_ENA_NONE",
                    p_sclr_ena  = "SCLR_ENA_NONE",
                    o_dataout   = tx_data_obuf[i],
                    i_datainlo  = sink.data[i],
                    i_datainhi  = sink.data[4+i],
                    i_clk       = ClockSignal("eth_tx"),
                    i_ena       = Constant(1, 1),
                    i_areset    = Constant(1, 1),
                    i_sreset    = Constant(1, 1),
                ),
                Instance("tennm_ph2_io_obuf",
                    p_open_drain = "OPEN_DRAIN_OFF",
                    i_i          = tx_data_obuf[i],
                    o_o          = pads.tx_data[i],
                ),
            ]

        self.sync += sink.ready.eq(1)

# LiteEthPHYRGMII RX -----------------------------------------------------------------------------------

class LiteEthPHYRGMIIRX(LiteXModule):
    def __init__(self, pads, rx_delay=2e-9, iodelay_clk_freq=200e6):
        self.source    = source = stream.Endpoint(eth_phy_description(8))

        # # #

        assert iodelay_clk_freq in [200e6, 300e6, 400e6]
        iodelay_tap_average = 1 / (2*32 * iodelay_clk_freq)
        rx_delay_taps = round(rx_delay / iodelay_tap_average)
        assert rx_delay_taps < 32, "Exceeded ODELAYE2 max value: {} >= 32".format(rx_delay_taps)

        rx_ctl_ibuf    = Signal()
        rx_ctl_idelay  = Signal()
        rx_ctl         = Signal()
        rx_data_ibuf   = Signal(4)
        rx_data_idelay = Signal(4)
        rx_data        = Signal(8)

        self.specials += [
            Instance("tennm_ph2_io_ibuf",
                p_bus_hold = "BUS_HOLD_OFF",
                i_i        = pads.rx_ctl,
                o_o        = rx_ctl_ibuf,
            ),
            Instance("tennm_ph2_ddio_in",
                p_mode      = "MODE_DDR_W_DLY",
                p_asclr_ena = "ASCLR_ENA_NONE",
                p_sclr_ena  = "SCLR_ENA_NONE",
                i_ena       = Constant(1, 1),
                i_areset    = Constant(1, 1),
                i_sreset    = Constant(0, 1),
                i_datain    = rx_ctl_ibuf,
                i_clk       = ClockSignal("eth_rx"),
                o_regouthi  = rx_ctl,
                o_regoutlo  = Open(),
            ),
        ]

        for i in range(4):
            self.specials += [
                Instance("tennm_ph2_io_ibuf",
                    p_bus_hold = "BUS_HOLD_OFF",
                    i_i        = pads.rx_data[i],
                    o_o        = rx_data_ibuf[i],
                ),
                Instance("tennm_ph2_ddio_in",
                    p_mode      = "MODE_DDR_W_DLY",
                    p_asclr_ena = "ASCLR_ENA_NONE",
                    p_sclr_ena  = "SCLR_ENA_NONE",
                    i_ena       = Constant(1, 1),
                    i_areset    = Constant(1, 1),
                    i_sreset    = Constant(0, 1),
                    i_datain    = rx_data_ibuf[i],
                    i_clk       = ClockSignal("eth_rx"),
                    o_regouthi  = rx_data[i],
                    o_regoutlo  = rx_data[i+4],
                ),
            ]

        rx_ctl_d = Signal()
        self.sync += rx_ctl_d.eq(rx_ctl)

        last = Signal()
        self.comb += last.eq(~rx_ctl & rx_ctl_d)
        self.sync += [
            source.valid.eq(rx_ctl),
            source.data.eq(rx_data)
        ]
        self.comb += source.last.eq(last)

# LiteEthPHYRGMII CRG ----------------------------------------------------------------------------------

class LiteEthPHYRGMIICRG(LiteXModule):
    def __init__(self, platform, clock_pads, pads, with_hw_init_reset, tx_delay=2e-9, hw_reset_cycles=256):
        self._reset    = CSRStorage()

        # # #

        # RX clock.
        self.cd_eth_rx = ClockDomain()
        self.comb += self.cd_eth_rx.clk.eq(clock_pads.rx)

        # TX clock.
        self.cd_eth_tx = ClockDomain()
        self.cd_eth_tx_delayed = ClockDomain(reset_less=True)
        tx_phase = 125e6*tx_delay*360
        assert tx_phase < 360
        self.pll = pll = RGMIIPLL(platform)
        self.comb += pll.clkin.eq(ClockSignal("eth_rx"))
        self.comb += self.cd_eth_tx.clk.eq(pll.eth_tx)
        self.comb += self.cd_eth_tx_delayed.clk.eq(pll.eth_tx_delayed)

        eth_tx_clk_obuf = Signal()
        self.specials += [
            Instance("tennm_ph2_ddio_out",
                p_mode      = "MODE_DDR",
                p_asclr_ena = "ASCLR_ENA_NONE",
                p_sclr_ena  = "SCLR_ENA_NONE",
                o_dataout   = eth_tx_clk_obuf,
                i_datainlo  = 1,
                i_datainhi  = 0,
                i_clk       = ClockSignal("eth_tx_delayed"),
                i_ena       = Constant(1, 1),
                i_areset    = Constant(1, 1),
                i_sreset    = Constant(1, 1),
            ),
            Instance("tennm_ph2_io_obuf",
                p_open_drain = "OPEN_DRAIN_OFF",
                i_i          = eth_tx_clk_obuf,
                o_o          = clock_pads.tx,
            ),
        ]

        # Reset
        self.reset = reset = Signal()
        if with_hw_init_reset:
            self.hw_reset = LiteEthPHYHWReset(cycles=hw_reset_cycles)
            self.comb += reset.eq(self._reset.storage | self.hw_reset.reset)
        else:
            self.comb += reset.eq(self._reset.storage)
        if hasattr(pads, "rst_n"):
            self.comb += pads.rst_n.eq(~reset)
        self.specials += [
            AsyncResetSynchronizer(self.cd_eth_tx, reset),
            AsyncResetSynchronizer(self.cd_eth_rx, reset),
        ]

class LiteEthPHYRGMII(LiteXModule):
    dw          = 8
    tx_clk_freq = 125e6
    rx_clk_freq = 125e6

    def __init__(self, platform, clock_pads, pads, with_hw_init_reset=True, tx_delay=2e-9, rx_delay=2e-9,
        iodelay_clk_freq=200e6, hw_reset_cycles=256):
        self.crg      = LiteEthPHYRGMIICRG(platform, clock_pads, pads, with_hw_init_reset, tx_delay, hw_reset_cycles)
        self.tx       = ClockDomainsRenamer("eth_rx")(LiteEthPHYRGMIITX(pads))
        self.rx       = ClockDomainsRenamer("eth_rx")(LiteEthPHYRGMIIRX(pads, rx_delay, iodelay_clk_freq))
        self.sink, self.source = self.tx.sink, self.rx.source

        if hasattr(pads, "mdc"):
            self.mdio = LiteEthPHYMDIO(pads)
