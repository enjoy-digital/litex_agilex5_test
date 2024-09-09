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
        self.sink     = axi.AXIInterface(data_width= 32, address_width=32, id_width=4)
        self.source   = axi.AXIInterface(data_width=256, address_width=32, id_width=4)

        # AXI Cache Core Instance.
        self.specials += Instance("l2_cache",
            # Clk / Reset
            i_clk_i = ClockSignal("sys"),
            i_rst_i = ResetSignal("sys"),

            # Debug.
            i_dbg_mode_i    = Constant(0, 1),

            # Sink AXI
            # --------

            # AXI aw.
            i_inport_awid_i     = self.sink.aw.id,
            i_inport_awaddr_i   = self.sink.aw.addr,
            i_inport_awlen_i    = self.sink.aw.len,
            i_inport_awburst_i  = self.sink.aw.burst,
            i_inport_awvalid_i  = self.sink.aw.valid,
            o_inport_awready_o  = self.sink.aw.ready,
            i_inport_awsize_i   = self.sink.aw.size,
            # missing lock, prot, user, qos

            # AXI w.
            i_inport_wdata_i    = self.sink.w.data,
            i_inport_wstrb_i    = self.sink.w.strb,
            i_inport_wlast_i    = self.sink.w.last,
            i_inport_wvalid_i   = self.sink.w.valid,
            o_inport_wready_o   = self.sink.w.ready,
            # missing user

            # AXI ar.
            i_inport_arid_i     = self.sink.ar.id,
            i_inport_araddr_i   = self.sink.ar.addr,
            i_inport_arlen_i    = self.sink.ar.len,
            i_inport_arburst_i  = self.sink.ar.burst,
            i_inport_arvalid_i  = self.sink.ar.valid,
            o_inport_arready_o  = self.sink.ar.ready,
            i_inport_arsize_i   = self.sink.ar.size,
            # missing lock, prot, user, qos

            # AXI r.
            o_inport_rdata_o    = self.sink.r.data,
            o_inport_rresp_o    = self.sink.r.resp,
            o_inport_rlast_o    = self.sink.r.last,
            i_inport_rready_i   = self.sink.r.ready,
            o_inport_rvalid_o   = self.sink.r.valid,
            # missing user, id

            # AXI b.
            i_inport_bready_i   = self.sink.b.ready,
            o_inport_bid_o      = self.sink.b.id,
            o_inport_bresp_o    = self.sink.b.resp,
            o_inport_bvalid_o   = self.sink.b.valid,

            # Source AXI
            # --------

            # AXI aw.
            o_outport_awid_o    = self.source.aw.id,
            o_outport_awaddr_o  = self.source.aw.addr,
            o_outport_awlen_o   = self.source.aw.len,
            o_outport_awburst_o = self.source.aw.burst,
            o_outport_awvalid_o = self.source.aw.valid,
            i_outport_awready_i = self.source.aw.ready,
            # missing size, lock, prot, user, qos

            # AXI w.
            o_outport_wdata_o   = self.source.w.data,
            o_outport_wstrb_o   = self.source.w.strb,
            o_outport_wlast_o   = self.source.w.last,
            o_outport_wvalid_o  = self.source.w.valid,
            i_outport_wready_i  = self.source.w.ready,
            # missing user

            # AXI ar.
            o_outport_arid_o    = self.source.ar.id,
            o_outport_araddr_o  = self.source.ar.addr,
            o_outport_arlen_o   = self.source.ar.len,
            o_outport_arburst_o = self.source.ar.burst,
            o_outport_arvalid_o = self.source.ar.valid,
            i_outport_arready_i = self.source.ar.ready,
            # missing size, lock, prot, user, qos

            # AXI r.
            i_outport_rid_i     = self.source.r.id,
            i_outport_rdata_i   = self.source.r.data,
            i_outport_rresp_i   = self.source.r.resp,
            i_outport_rlast_i   = self.source.r.last,
            o_outport_rready_o  = self.source.r.ready,
            i_outport_rvalid_i  = self.source.r.valid,
            # missing user

            # AXI b.
            o_outport_bready_o  = self.source.b.ready,
            i_outport_bid_i     = self.source.b.id,
            i_outport_bresp_i   = self.source.b.resp,
            i_outport_bvalid_i  = self.source.b.valid,
        )
        self.add_sources(platform=platform)

    def add_sources(self, platform):
        # If core_axi_cache is not already present, clone it.
        if not os.path.exists("core_axi_cache"):
            os.system("git clone https://github.com/ultraembedded/core_axi_cache")
        rtl_dir = os.path.join(os.path.abspath(os.path.dirname(__file__)), "core_axi_cache", "src_v")
        platform.add_source_dir(path=rtl_dir)
