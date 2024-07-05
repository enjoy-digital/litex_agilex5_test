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

# GMIIToRGMII TX -----------------------------------------------------------------------------------

class GMIIToRGMIITX(LiteXModule):
    def __init__(self, pads):
        self.sink      = sink = stream.Endpoint(eth_phy_description(8))
        self.ip_params = dict()

        # # #

        self.ip_params.update(
            # GMII Tx Interface.
            # ------------------
            i_hps_gmii_mac_txd_o     = sink.data,
            i_hps_gmii_mac_txen      = sink.valid,
            i_hps_gmii_mac_txer      = 0,

            # RGMII Tx Interface.
            # -------------------
            o_phy_rgmii_rgmii_txd    = pads.tx_data,
            o_phy_rgmii_rgmii_tx_ctl = pads.tx_ctl,
        )

        self.sync += sink.ready.eq(1)

# GMIIToRGMII RX -----------------------------------------------------------------------------------

class GMIIToRGMIIRX(LiteXModule):
    def __init__(self, pads):
        self.source    = source = stream.Endpoint(eth_phy_description(8))
        self.ip_params = dict()

        # # #

        dv_d = Signal()

        self.ip_params.update(
            # GMII Rx Interface.
            # ------------------
            o_hps_gmii_mac_rxdv      = source.valid,
            o_hps_gmii_mac_rxer      = Open(),
            o_hps_gmii_mac_rxd       = source.data,

            # RGMII Rx Interface.
            # -------------------
            i_phy_rgmii_rgmii_rxd    = pads.rx_data,
            i_phy_rgmii_rgmii_rx_ctl = pads.rx_ctl,
        )

        self.sync += dv_d.eq(source.valid)
        self.comb += source.last.eq(~source.valid & dv_d)

# GMIIToRGMII CRG ----------------------------------------------------------------------------------

class GMIIToRGMIICRG(LiteXModule):
    def __init__(self, clock_pads, pads):
        self._reset    = CSRStorage()

        self.ip_params = dict()

        # # #
        self.cd_eth_rx = ClockDomain()
        self.cd_eth_tx = ClockDomain()

        self.ip_params.update(
            # GMII Tx Clk/Rst.
            # ----------------
            i_hps_gmii_mac_tx_clk_o  = ClockSignal("eth_tx"),
            o_hps_gmii_mac_tx_clk_i  = Open(), # FIXME: check
            i_hps_gmii_mac_rst_tx_n  = ResetSignal("eth_tx"),

            # GMII Rx Clk/Rst.
            # ----------------
            o_hps_gmii_mac_rx_clk    = ClockSignal("eth_rx"),
            i_hps_gmii_mac_rst_rx_n  = ~ResetSignal("eth_rx"),

            # RGMII Rx Clk.
            # -------------------
            i_phy_rgmii_rgmii_rx_clk = clock_pads.rx,
            # RGMII Tx Clk.
            # -------------------
            o_phy_rgmii_rgmii_tx_clk = clock_pads.tx,
        )

        # Reset
        self.specials += [
            AsyncResetSynchronizer(self.cd_eth_rx, self._reset.storage),
            AsyncResetSynchronizer(self.cd_eth_tx, self._reset.storage),
        ]

class GMIIToRGMII(LiteXModule):
    dw          = 8
    tx_clk_freq = 125e6
    rx_clk_freq = 125e6

    def __init__(self, platform, clock_pads, pads):
        self.model = False
        self.crg   = GMIIToRGMIICRG(clock_pads, pads)
        self.tx    = ClockDomainsRenamer("eth_rx")(GMIIToRGMIITX(pads))
        self.rx    = ClockDomainsRenamer("eth_rx")(GMIIToRGMIIRX(pads))
        self.sink, self.source = self.tx.sink, self.rx.source

        # # #

        # EMIF LPDDR4 Clock Domain.
        # -------------------------
        self.ip_params = dict()

        self.ip_params.update(
            # Clk/Reset.
            # ----------
            i_pll_250m_tx_clock_clk     = 0,
            i_pll_125m_tx_clock_clk     = 0,
            i_pll_25m_clock_clk         = 0,
            i_pll_2_5m_clock_clk        = 0,
            i_locked_pll_250m_tx_export = 0,
            i_peri_reset_reset          = 0,
            i_peri_clock_clk            = 0,

            # GMII Control Interface.
            # -----------------------
            i_hps_gmii_mac_speed        = Constant(0, 3),
            o_hps_gmii_mac_col          = Open(),
            o_hps_gmii_mac_crs          = Open(),
            **self.crg.ip_params,
            **self.tx.ip_params,
            **self.rx.ip_params,
        )

    def do_finalize(self):
        self.specials += Instance("gmii_to_rgmii", **self.ip_params)

        curr_dir = os.path.abspath(os.path.dirname(__file__))
        ip_name = "gmii_to_rgmii"
        ip_file = os.path.join(curr_dir, ip_name + ".ip")
        platform.add_ip(ip_file)

        if which("quartus_ipgenerate") is None:
            msg = "Unable to find Quartus toolchain, please:\n"
            msg += "- Add Quartus toolchain to your $PATH."
            raise OSError(msg)

        # To works correctly quartus_ipgenerate needs two steps

        # 1. generates a project
        command = f"--generate_project_ip_files  gmii_to_rgmii"
        ret = subprocess.run(f"quartus_ipgenerate {command}", shell=True)
        if ret.returncode != 0:
            raise OSError("Error occured during Quartus's script execution.")

        # 2. generates the IP files
        command = f"--generate_ip_file --synthesis=verilog --clear_ip_generation_dirs --ip_file={ip_file} {ip_name} --set=family=\"Agilex 5\""

        ret = subprocess.run(f"quartus_ipgenerate {command}", shell=True)
        if ret.returncode != 0:
            raise OSError("Error occured during Quartus's script execution.")
