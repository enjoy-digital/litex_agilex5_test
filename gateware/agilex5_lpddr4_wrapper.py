#
# This file is part of LiteX-Agilex5-Test.
#
# Copyright (c) 2024 Enjoy-Digital <enjoy-digital.fr>
#
# SPDX-License-Identifier: BSD-2-Clause

import os
from shutil import which, copyfile
import subprocess

from migen import *

from litex.build import tools

from litex.gen import *

from litex.soc.interconnect import axi
from litex.soc.interconnect.csr import *

# Agilex5 LPDDR4 Wrapper ---------------------------------------------------------------------------

class Agilex5LPDDR4Wrapper(LiteXModule):
    def __init__(self, platform, pads):
        self.bus = bus = axi.AXIInterface(
            data_width    = 256,
            address_width = 32,
            id_width      = 7,
            aw_user_width = 4,
            w_user_width  = 64,
            b_user_width  = 0,
            ar_user_width = 4,
            r_user_width  = 64,
        )
        self._status = CSRStatus(description="EMIF LDDR4 Status.", fields=[
            CSRField("cal_done",   size=1, offset=0, description="EMIF LPDDR4 calibration done."),
        ])

        self._control = CSRStorage(description="EMIF LPDDR4 Control.", fields=[
            CSRField("reset", size=1, offset=0, description="EMIF LPDDR4 Controler reset.", values=[
                ("``0b0``", "Normal operation."),
                ("``0b1``", "Reset state."),
            ]),
        ])

        # # #

        # Signals.
        # --------
        self.cal_done = Signal()
        self.comb += self._status.fields.cal_done.eq(self.cal_done)

        # EMIF LPDDR4 IP Core.
        # --------------------
        self.specials += Instance("ed_synth",
            # Clks/Rsts.
            # ----------

            # EMIF reference clock.
            i_ref_clk_i_clk               = ClockSignal("lpddr"),
            i_core_init_n_i_reset_n       = ~ResetSignal("lpddr"),

            # EMIF usr clk input.
            i_usr_async_clk_i_clk         = ClockSignal("sys"),
            o_usr_rst_n_o_reset_n         = Open(),

            # AXIL Driver Clk/Rst (Calibration).
            i_axil_driver_clk_i_clk       = ClockSignal("lpddr_cfg"),
            i_axil_driver_rst_n_i_reset_n = ~ResetSignal("lpddr_cfg"),

            # MEM AXI Lite Clk/Rst (Calibration).
            i_s0_axil_clk_i_clk           = ClockSignal("lpddr_cfg"),
            i_s0_axil_rst_n_i_reset_n     = ~ResetSignal("lpddr_cfg"),

            # Status.
            # -------
            o_cal_done_rst_n_reset_n      = self.cal_done,

            # AXI Interface.
            # --------------

            # AR Channel.
            i_s0_axi4_arid                = bus.ar.id,
            i_s0_axi4_araddr              = bus.ar.addr,
            i_s0_axi4_arlen               = bus.ar.len,
            i_s0_axi4_arsize              = bus.ar.size,
            i_s0_axi4_arburst             = bus.ar.burst,
            i_s0_axi4_arlock              = bus.ar.lock,
            i_s0_axi4_arprot              = bus.ar.prot,
            i_s0_axi4_arvalid             = bus.ar.valid,
            i_s0_axi4_aruser              = bus.ar.user,
            o_s0_axi4_arready             = bus.ar.ready,
            i_s0_axi4_arqos               = bus.ar.qos,

            # R Channel.
            o_s0_axi4_rid                 = bus.r.id,
            o_s0_axi4_rdata               = bus.r.data,
            o_s0_axi4_rresp               = bus.r.resp,
            o_s0_axi4_rlast               = bus.r.last,
            o_s0_axi4_ruser               = bus.r.user,
            i_s0_axi4_rready              = bus.r.ready,
            o_s0_axi4_rvalid              = bus.r.valid,

            # AW Channel.
            i_s0_axi4_awid                = bus.aw.id,
            i_s0_axi4_awaddr              = bus.aw.addr,
            i_s0_axi4_awlen               = bus.aw.len,
            i_s0_axi4_awsize              = bus.aw.size,
            i_s0_axi4_awburst             = bus.aw.burst,
            i_s0_axi4_awlock              = bus.aw.lock,
            i_s0_axi4_awprot              = bus.aw.prot,
            i_s0_axi4_awvalid             = bus.aw.valid,
            i_s0_axi4_awuser              = bus.aw.user,
            o_s0_axi4_awready             = bus.aw.ready,
            i_s0_axi4_awqos               = bus.aw.qos,

            # W Channel.
            i_s0_axi4_wdata               = bus.w.data,
            i_s0_axi4_wstrb               = bus.w.strb,
            i_s0_axi4_wlast               = bus.w.last,
            i_s0_axi4_wvalid              = bus.w.valid,
            i_s0_axi4_wuser               = bus.w.user,
            o_s0_axi4_wready              = bus.w.ready,

            # B Channel.
            i_s0_axi4_bready              = bus.b.ready,
            o_s0_axi4_bid                 = bus.b.id,
            o_s0_axi4_bresp               = bus.b.resp,
            o_s0_axi4_bvalid              = bus.b.valid,

            # Physical LPDDR4 Interface.
            # --------------------------
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
        self.add_sources(platform=platform)

    def add_sources(self, platform):
        # Paths/Files.
        curr_dir  = os.path.abspath(os.path.dirname(__file__))
        ip_dir    = os.path.join(curr_dir, "ip", "ed_synth")
        ip_src    = os.path.join(ip_dir, "ed_synth_emif_ph2_inst_template.ip")
        ip_dst    = os.path.join(ip_dir, "ed_synth_emif_ph2_inst.ip")
        qsys_file = os.path.join(curr_dir, "ed_synth.qsys")

        # Avoid hardcoded path to QORS file.
        copyfile(ip_src, ip_dst)
        tools.replace_in_file(ip_dst, "QPRS_PATH", curr_dir)

        # Add IP to project.
        platform.add_ip(qsys_file)
        platform.add_ip(ip_dst)
        platform.add_ip(os.path.join(curr_dir, "ip/ed_synth/ed_synth_axil_driver_0.ip"))

        # Synthetize IP. CHECKME/FIXME: Avoid doing it here but move the the build if possible.
        if which("qsys-edit") is None:
            msg = "Unable to find Quartus toolchain, please:\n"
            msg += "- Add Quartus toolchain to your $PATH."
            raise OSError(msg)

        ret = subprocess.run(f"qsys-generate --synthesis {qsys_file}", shell=True)
        if ret.returncode != 0:
            raise OSError("Error occured during Quartus's script execution.")
