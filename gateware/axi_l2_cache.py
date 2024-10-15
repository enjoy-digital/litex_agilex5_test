#!/usr/bin/env python3

#
# This file is part of LiteX-Agilex5-Test.
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause
#
# LiteX wrapper around UltraEmbedded's AXI Cache core.

import os

from litex.gen import *

from litex.soc.interconnect import axi

# AXI L2 Cache -------------------------------------------------------------------------------------

class AXIL2Cache(LiteXModule):
    def __init__(self, platform):
        self.s_axi = s_axi = axi.AXIInterface(data_width= 32, address_width=32, id_width=4)
        self.m_axi = m_axi = axi.AXIInterface(data_width=256, address_width=32, id_width=4)

        # AXI Cache Core Instance.
        self.specials += Instance("l2_cache",
            # Clk / Rst.
            i_clk_i             = ClockSignal("sys"),
            i_rst_i             = ResetSignal("sys"),

            # Debug.
            i_dbg_mode_i        = Constant(0, 1),

            # AXI Slave Interface.
            # --------------------

            # AW (no lock, prot, user, qos).
            i_inport_awid_i     = s_axi.aw.id,
            i_inport_awaddr_i   = s_axi.aw.addr,
            i_inport_awlen_i    = s_axi.aw.len,
            i_inport_awburst_i  = s_axi.aw.burst,
            i_inport_awvalid_i  = s_axi.aw.valid,
            o_inport_awready_o  = s_axi.aw.ready,
            i_inport_awsize_i   = s_axi.aw.size,

            # W (no user).
            i_inport_wdata_i    = s_axi.w.data,
            i_inport_wstrb_i    = s_axi.w.strb,
            i_inport_wlast_i    = s_axi.w.last,
            i_inport_wvalid_i   = s_axi.w.valid,
            o_inport_wready_o   = s_axi.w.ready,

            # AR (no lock, prot, user, qos).
            i_inport_arid_i     = s_axi.ar.id,
            i_inport_araddr_i   = s_axi.ar.addr,
            i_inport_arlen_i    = s_axi.ar.len,
            i_inport_arburst_i  = s_axi.ar.burst,
            i_inport_arvalid_i  = s_axi.ar.valid,
            o_inport_arready_o  = s_axi.ar.ready,
            i_inport_arsize_i   = s_axi.ar.size,

            # R (no user, id).
            o_inport_rdata_o    = s_axi.r.data,
            o_inport_rresp_o    = s_axi.r.resp,
            o_inport_rlast_o    = s_axi.r.last,
            i_inport_rready_i   = s_axi.r.ready,
            o_inport_rvalid_o   = s_axi.r.valid,

            # B.
            i_inport_bready_i   = s_axi.b.ready,
            o_inport_bid_o      = s_axi.b.id,
            o_inport_bresp_o    = s_axi.b.resp,
            o_inport_bvalid_o   = s_axi.b.valid,

            # AXI Master Interface.
            # ---------------------

            # AW (no size, lock, prot, user, qos).
            o_outport_awid_o    = m_axi.aw.id,
            o_outport_awaddr_o  = m_axi.aw.addr,
            o_outport_awlen_o   = m_axi.aw.len,
            o_outport_awburst_o = m_axi.aw.burst,
            o_outport_awvalid_o = m_axi.aw.valid,
            i_outport_awready_i = m_axi.aw.ready,

            # W (no user).
            o_outport_wdata_o   = m_axi.w.data,
            o_outport_wstrb_o   = m_axi.w.strb,
            o_outport_wlast_o   = m_axi.w.last,
            o_outport_wvalid_o  = m_axi.w.valid,
            i_outport_wready_i  = m_axi.w.ready,

            # AR (no size, lock, prot, user, qos).
            o_outport_arid_o    = m_axi.ar.id,
            o_outport_araddr_o  = m_axi.ar.addr,
            o_outport_arlen_o   = m_axi.ar.len,
            o_outport_arburst_o = m_axi.ar.burst,
            o_outport_arvalid_o = m_axi.ar.valid,
            i_outport_arready_i = m_axi.ar.ready,

            # R (no user).
            i_outport_rid_i     = m_axi.r.id,
            i_outport_rdata_i   = m_axi.r.data,
            i_outport_rresp_i   = m_axi.r.resp,
            i_outport_rlast_i   = m_axi.r.last,
            o_outport_rready_o  = m_axi.r.ready,
            i_outport_rvalid_i  = m_axi.r.valid,

            # B.
            o_outport_bready_o  = m_axi.b.ready,
            i_outport_bid_i     = m_axi.b.id,
            i_outport_bresp_i   = m_axi.b.resp,
            i_outport_bvalid_i  = m_axi.b.valid,
        )
        self.add_sources(platform=platform)

    def add_sources(self, platform):
        # If core_axi_cache is not already present, clone it.
        if not os.path.exists("core_axi_cache"):
            os.system("git clone https://github.com/ultraembedded/core_axi_cache")
        rtl_dir = os.path.join(os.path.abspath("core_axi_cache"), "src_v")
        platform.add_source_dir(path=rtl_dir)
