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

from litex.gen import *

from litex.soc.interconnect import axi

class Agilex5LPDDR4Wrapper(LiteXModule):
    def __init__(self, platform, pads):

        self.bus      = axi.AXIInterface(data_width=256, address_width=32, id_width=7)
        self.cal_done = Signal()

        # # #

        # EMIF LPDDR4 Clock Domain.
        # -------------------------
        self.cd_lpddr_usr = ClockDomain()

        self.ip_params = dict()

        self.ip_params.update(
            # EMIF Module reference clock.
            # ----------------------------
            i_ref_clk_i_clk               = ClockSignal("lpddr"),
            i_core_init_n_i_reset_n       = ResetSignal("lpddr"),
            # EMIF Module usr clk output.
            # ---------------------------
            o_usr_clk_o_clk               = ClockSignal("lpddr_usr"),
            o_usr_rst_n_o_reset_n         = ResetSignal("lpddr_usr"),

            # AXIL Driver Clk/Rst (Calibration).
            i_axil_driver_clk_i_clk       = ClockSignal("sys"),
            i_axil_driver_rst_n_i_reset_n = ResetSignal("sys"),

            # MEM AXI Lite Clk/Rst (Calibration).
            i_s0_axil_clk_i_clk           = ClockSignal("sys"),
            i_s0_axil_rst_n_i_reset_n     = ResetSignal("sys"),

            # MEM Cal Done.
            o_cal_done_rst_n_reset_n      = self.cal_done,

            # AXI ar.
            i_s0_axi4_arid                = self.bus.ar.id,
            i_s0_axi4_araddr              = self.bus.ar.addr,
            i_s0_axi4_arlen               = self.bus.ar.len,
            i_s0_axi4_arsize              = self.bus.ar.size,
            i_s0_axi4_arburst             = self.bus.ar.burst,
            i_s0_axi4_arlock              = self.bus.ar.lock,
            i_s0_axi4_arprot              = self.bus.ar.prot,
            i_s0_axi4_arvalid             = self.bus.ar.valid,
            i_s0_axi4_aruser              = self.bus.ar.user,
            o_s0_axi4_arready             = self.bus.ar.ready,
            i_s0_axi4_arqos               = self.bus.ar.qos,

            # AXI r.
            o_s0_axi4_rid                 = self.bus.r.id,
            o_s0_axi4_rdata               = self.bus.r.data,
            o_s0_axi4_rresp               = self.bus.r.resp,
            o_s0_axi4_rlast               = self.bus.r.last,
            o_s0_axi4_ruser               = self.bus.r.user,
            i_s0_axi4_rready              = self.bus.r.ready,
            o_s0_axi4_rvalid              = self.bus.r.valid,

            # AXI aw.
            i_s0_axi4_awid                = self.bus.aw.id,
            i_s0_axi4_awaddr              = self.bus.aw.addr,
            i_s0_axi4_awlen               = self.bus.aw.len,
            i_s0_axi4_awsize              = self.bus.aw.size,
            i_s0_axi4_awburst             = self.bus.aw.burst,
            i_s0_axi4_awlock              = self.bus.aw.lock,
            i_s0_axi4_awprot              = self.bus.aw.prot,
            i_s0_axi4_awvalid             = self.bus.aw.valid,
            i_s0_axi4_awuser              = self.bus.aw.user,
            o_s0_axi4_awready             = self.bus.aw.ready,
            i_s0_axi4_awqos               = self.bus.aw.qos,

            # AXI w.
            i_s0_axi4_wdata               = self.bus.w.data,
            i_s0_axi4_wstrb               = self.bus.w.strb,
            i_s0_axi4_wlast               = self.bus.w.last,
            i_s0_axi4_wvalid              = self.bus.w.valid,
            i_s0_axi4_wuser               = self.bus.w.user,
            o_s0_axi4_wready              = self.bus.w.ready,

            # AXI b.
            i_s0_axi4_bready              = self.bus.b.ready,
            o_s0_axi4_bid                 = self.bus.b.id,
            o_s0_axi4_bresp               = self.bus.b.resp,
            o_s0_axi4_bvalid              = self.bus.b.valid,

            # RAM port
            o_mem_mem_ck_t                = pads.clk_p,
            o_mem_mem_ck_c                = pads.clk_n,
            o_mem_mem_cke                 = pads.cke,
            o_mem_mem_reset_n             = pads.reset_n,
            o_mem_mem_cs                  = pads.cs,
            o_mem_mem_ca                  = pads.ca,
            io_mem_mem_dq                 = pads.dq,
            io_mem_mem_dqs_t              = pads.dqs_p,
            io_mem_mem_dqs_c              = pads.dqs_n,
            io_mem_mem_dmi                = pads.dmi,
            i_oct_oct_rzqin               = pads.rzq,
        )

        self.specials += Instance("ed_synth", **self.ip_params)

        curr_dir = os.path.abspath(os.path.dirname(__file__))
        qsys_file = os.path.join(curr_dir, "ed_synth.qsys")
        platform.add_ip(qsys_file)
        platform.add_ip(os.path.join(curr_dir, "ip/ed_synth/ed_synth_emif_ph2_inst.ip"))
        platform.add_ip(os.path.join(curr_dir, "ip/ed_synth/ed_synth_axil_driver_0.ip"))

        if which("qsys-edit") is None:
            msg = "Unable to find Quartus toolchain, please:\n"
            msg += "- Add Quartus toolchain to your $PATH."
            raise OSError(msg)

        command = f"qsys-generate --synthesis {qsys_file}"

        ret = subprocess.run(command, shell=True)
        if ret.returncode != 0:
            raise OSError("Error occured during Quartus's script execution.")
