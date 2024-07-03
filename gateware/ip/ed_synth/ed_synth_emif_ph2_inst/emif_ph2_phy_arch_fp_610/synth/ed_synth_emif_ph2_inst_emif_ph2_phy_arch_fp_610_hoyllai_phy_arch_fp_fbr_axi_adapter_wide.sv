// (C) 2001-2024 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



`ifndef PHY_ARCH_FP_INTERFACE
   `include "phy_arch_fp_interface.svh"
`endif

`ifndef ZERO_PAD_PORT
`define ZERO_PAD_PORT(IP_PORT_WIDTH, PHYS_SIG_WIDTH, ip_port)                       \
        (   (IP_PORT_WIDTH >= PHYS_SIG_WIDTH)                                       \
          ? ip_port[(PHYS_SIG_WIDTH-1):0]                                           \
          : {'0,ip_port[(IP_PORT_WIDTH-1):0]})
`endif

module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_fbr_axi_adapter_wide #(
      parameter PORT_AXI_AXADDR_WIDTH     = 1,
      parameter PORT_AXI_AXBURST_WIDTH    = 1,
      parameter PORT_AXI_AXID_WIDTH       = 1,
      parameter PORT_AXI_AXLEN_WIDTH      = 1,
      parameter PORT_AXI_AXSIZE_WIDTH     = 1,
      parameter PORT_AXI_AXUSER_WIDTH     = 1,
      parameter PORT_AXI_AXQOS_WIDTH      = 1,
      parameter PORT_AXI_AXCACHE_WIDTH    = 1,
      parameter PORT_AXI_AXPROT_WIDTH     = 1,
      parameter PORT_AXI_DATA_WIDTH       = 1,
      parameter PORT_AXI_STRB_WIDTH       = 1,
      parameter PORT_AXI_USER_WIDTH       = 1,
      parameter PORT_AXI_ID_WIDTH         = 1,
      parameter PORT_AXI_RESP_WIDTH       = 1,
      parameter INTF_CORE_TO_FAHMC_WIDTH  = 1,
      parameter INTF_FAHMC_TO_CORE_WIDTH  = 1,
      parameter INTF_CORE_TO_FALANE_WIDTH = 1,
      parameter INTF_FALANE_TO_CORE_WIDTH = 1,
      parameter INTF_CORE_TO_FAAXI_WIDTH  = 1,
      parameter INTF_FAAXI_TO_CORE_WIDTH  = 1,

      localparam RDFIFO_DATA_WIDTH        = 266,
      localparam RDFIFO_PTR_WIDTH         = 5,
      localparam WRESPFIFO_DATA_WIDTH     = 9,
      localparam WRESPFIFO_PTR_WIDTH      = 5

) (
   // Fabric-facing AXI-Compliant interface
   input  logic                                fbr_aclk,
   input  logic                                fbr_arst_n,
   AXI_BUS.Subordinate                                         fbr_axi_intf,
   // Internal interface to the periphery
   input  logic    [INTF_FAHMC_TO_CORE_WIDTH-1:0]              fahmc_to_core,
   output logic    [INTF_CORE_TO_FAHMC_WIDTH-1:0]              core_to_fahmc,

   input  logic    [3:0][INTF_FALANE_TO_CORE_WIDTH-1:0]        falane_to_core,
   output logic    [3:0][INTF_CORE_TO_FALANE_WIDTH-1:0]        core_to_falane

);
   timeunit 1ns;
   timeprecision 1ps;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_hmc::*;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_p2c_hmc::*;
   localparam WS = 0;

   AXI_BUS #( 
      .PORT_AXI_AXADDR_WIDTH  (40),
      .PORT_AXI_AXID_WIDTH    (8),
      .PORT_AXI_AXBURST_WIDTH (2),
      .PORT_AXI_AXLEN_WIDTH   (8),
      .PORT_AXI_AXSIZE_WIDTH  (4),
      .PORT_AXI_AXUSER_WIDTH  (4),
      .PORT_AXI_DATA_WIDTH    (256),
      .PORT_AXI_STRB_WIDTH    (32),
      .PORT_AXI_RESP_WIDTH    (2),
      .PORT_AXI_ID_WIDTH      (7),
      .PORT_AXI_USER_WIDTH    (4),
      .PORT_AXI_AXQOS_WIDTH   (2)
   ) internal_axi_intf();

   wire                                                        w_rdfifo_clock;
   wire                                                        w_rdfifo_aclr;
   wire                                                        w_rdfifo_sclr;
   wire            [RDFIFO_DATA_WIDTH-1:0]                     w_rdfifo_data;
   wire                                                        w_rdfifo_wrreq;
   wire                                                        w_rdfifo_rdreq;
   wire            [RDFIFO_DATA_WIDTH-1:0]                     w_rdfifo_q;
   wire            [RDFIFO_PTR_WIDTH-1:0]                      w_rdfifo_usedw;
   wire                                                        w_rdfifo_empty;
   wire                                                        w_rdfifo_full;
   wire                                                        w_rdfifo_almost_empty;
   wire                                                        w_rdfifo_almost_full;
   wire            [255:  0]                                   w_rdfifo_q_rdata;
   wire            [PORT_AXI_ID_WIDTH-1:0]                     w_rdfifo_q_rid;
   wire                                                        w_rdfifo_q_rlast;
   wire            [PORT_AXI_RESP_WIDTH-1:0]                   w_rdfifo_q_rresp;
   wire            [PORT_AXI_USER_WIDTH-1:0]                   w_rdfifo_q_ruser;

   wire                                                        w_wrespfifo_clock;
   wire                                                        w_wrespfifo_aclr;
   wire                                                        w_wrespfifo_sclr;
   wire            [WRESPFIFO_DATA_WIDTH-1:0]                  w_wrespfifo_data;
   wire                                                        w_wrespfifo_wrreq;
   wire                                                        w_wrespfifo_rdreq;
   wire            [WRESPFIFO_DATA_WIDTH-1:0]                  w_wrespfifo_q;
   wire            [WRESPFIFO_PTR_WIDTH-1:0]                   w_wrespfifo_usedw;
   wire                                                        w_wrespfifo_empty;
   wire                                                        w_wrespfifo_full;
   wire                                                        w_wrespfifo_almost_empty;
   wire                                                        w_wrespfifo_almost_full;
   wire            [  6:  0]                                   w_wrespfifo_q_bid;
   wire            [  1:  0]                                   w_wrespfifo_q_bresp;

   reg             [  3:  0]                                   r_wfifo_credit_ctr;
   reg             [  3:  0]                                   r_awfifo_credit_ctr;
   reg             [  3:  0]                                   r_arfifo_credit_ctr;

   reg             [  5:  0]                                   r_rdfifo_token;
   reg             [  5:  0]                                   r_wrespfifo_token;


   assign internal_axi_intf.awready             = fahmc_to_core[ 23: 23]; 
   assign internal_axi_intf.wready              = fahmc_to_core[ 22: 22]; 
   assign internal_axi_intf.bid[6:0]            = fahmc_to_core[ 21: 15]; 
   assign internal_axi_intf.bresp[1:0]          = fahmc_to_core[ 14: 13]; 
   assign internal_axi_intf.bvalid              = fahmc_to_core[ 12: 12]; 
   assign internal_axi_intf.arready             = fahmc_to_core[ 11: 11]; 
   assign internal_axi_intf.rid[6:0]            = fahmc_to_core[ 10:  4]; 
   assign internal_axi_intf.rvalid              = fahmc_to_core[  3:  3]; 
   assign internal_axi_intf.rlast               = fahmc_to_core[  2:  2]; 
   assign internal_axi_intf.rresp[1:0]          = fahmc_to_core[  1:  0]; 

   generate
      if (WS == 0) begin: falane_to_core_wide
         assign internal_axi_intf.rdata[255:160]      = falane_to_core[1][95: 0];
         assign internal_axi_intf.rdata[159: 64]      = falane_to_core[2][95: 0];
         assign internal_axi_intf.rdata[ 63:  0]      = falane_to_core[3][95:32];
      end: falane_to_core_wide 
      else if (WS == 1) begin: falane_to_core_slim
         assign internal_axi_intf.rdata[255:160]      = falane_to_core[2][95: 0];
         assign internal_axi_intf.rdata[159: 64]      = falane_to_core[1][95: 0];
         assign internal_axi_intf.rdata[ 63:  0]      = falane_to_core[0][95:32];
      end: falane_to_core_slim
      else begin: falane_to_core_error
      end: falane_to_core_error
   endgenerate

   generate
      if (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_hmc::IS_USED[WS])
      begin : gen_fbr_axi_adapt_outputs
         assign core_to_fahmc[167:141]    = {27{1'b0}};                           
         assign core_to_fahmc[140:101]    = internal_axi_intf.araddr[39:0];       
         assign core_to_fahmc[100: 94]    = internal_axi_intf.arlen[6:0];         
         assign core_to_fahmc[ 93: 91]    = internal_axi_intf.arsize[2:0];        
         assign core_to_fahmc[ 90: 89]    = internal_axi_intf.arburst[1:0];       
         assign core_to_fahmc[ 88: 88]    = internal_axi_intf.arlock;             
         assign core_to_fahmc[ 87: 86]    = internal_axi_intf.arqos[1:0];         
         assign core_to_fahmc[ 85: 82]    = internal_axi_intf.aruser[3:0];        
         assign core_to_fahmc[ 81: 81]    = internal_axi_intf.arvalid;            
         assign core_to_fahmc[ 80: 80]    = internal_axi_intf.rready;             
         assign core_to_fahmc[ 79: 79]    = internal_axi_intf.awlen[7];                  
         assign core_to_fahmc[ 78: 78]    = internal_axi_intf.arlen[7];                  
         assign core_to_fahmc[ 77: 71]    = internal_axi_intf.awid[6:0];          
         assign core_to_fahmc[ 70: 31]    = internal_axi_intf.awaddr[39:0];       
         assign core_to_fahmc[ 30: 24]    = internal_axi_intf.awlen[6:0];         
         assign core_to_fahmc[ 23: 21]    = internal_axi_intf.awsize[2:0];        
         assign core_to_fahmc[ 20: 19]    = internal_axi_intf.awburst[1:0];       
         assign core_to_fahmc[ 18: 18]    = internal_axi_intf.awlock;             
         assign core_to_fahmc[ 17: 16]    = internal_axi_intf.awqos[1:0];         
         assign core_to_fahmc[ 15: 12]    = internal_axi_intf.awuser[3:0];        
         assign core_to_fahmc[ 11: 11]    = internal_axi_intf.awvalid;            
         assign core_to_fahmc[ 10: 10]    = internal_axi_intf.wvalid;             
         assign core_to_fahmc[  9:  9]    = internal_axi_intf.wlast;              
         assign core_to_fahmc[  8:  8]    = internal_axi_intf.bready;             
         assign core_to_fahmc[  7:  0]    = internal_axi_intf.arid[7:0];          

         if (WS == 0) begin: core_to_falane_wide
            assign core_to_falane[3][95:0]   = {internal_axi_intf.wdata[63:0],internal_axi_intf.wstrb[31:0]};
            assign core_to_falane[2][95:0]   = internal_axi_intf.wdata[159: 64];
            assign core_to_falane[1][95:0]   = internal_axi_intf.wdata[255:160];
            assign core_to_falane[0][95:0]   = {96{1'b0}};
         end: core_to_falane_wide
         else if (WS == 1) begin: core_to_falane_slim
            assign core_to_falane[0][95:0]   = {internal_axi_intf.wdata[63:0],internal_axi_intf.wstrb[31:0]};
            assign core_to_falane[1][95:0]   = internal_axi_intf.wdata[159: 64];
            assign core_to_falane[2][95:0]   = internal_axi_intf.wdata[255:160];
            assign core_to_falane[3][95:0]   = {96{1'b0}};
         end: core_to_falane_slim
         else begin: core_to_falane_error
         end: core_to_falane_error
      end
      else
      begin : gen_fbr_axi_adapt_tieoffs
         assign core_to_fahmc             = '0;
         assign core_to_falane[3][95:0]   = '0;
         assign core_to_falane[2][95:0]   = '0;
         assign core_to_falane[1][95:0]   = '0;
         assign core_to_falane[0][95:0]   = '0;
      end
   endgenerate
   
   assign core_to_falane[3][INTF_CORE_TO_FALANE_WIDTH-1:96]   = '0;
   assign core_to_falane[2][INTF_CORE_TO_FALANE_WIDTH-1:96]   = '0;
   assign core_to_falane[1][INTF_CORE_TO_FALANE_WIDTH-1:96]   = '0;
   assign core_to_falane[0][INTF_CORE_TO_FALANE_WIDTH-1:96]   = '0;


   assign w_rdfifo_clock            = fbr_aclk;
   assign w_rdfifo_aclr             = 1'b0;
   assign w_rdfifo_sclr             =~fbr_arst_n;
   assign w_rdfifo_data[265:265]    = internal_axi_intf.rlast;
   assign w_rdfifo_data[264:263]    = internal_axi_intf.rresp[1:0];
   assign w_rdfifo_data[262:256]    = internal_axi_intf.rid[6:0];
   assign w_rdfifo_data[255:  0]    = internal_axi_intf.rdata[255:0];
   assign w_rdfifo_wrreq            = internal_axi_intf.rvalid & r_rdfifo_token[3];
   assign w_rdfifo_rdreq            = fbr_axi_intf.rready & fbr_axi_intf.rvalid;
   assign w_rdfifo_q_rlast          = w_rdfifo_q[265:265];
   assign w_rdfifo_q_rresp[1:0]     = w_rdfifo_q[264:263];
   assign w_rdfifo_q_rid[6:0]       = w_rdfifo_q[262:256];
   assign w_rdfifo_q_rdata[255:0]   = w_rdfifo_q[255:  0];

   assign w_wrespfifo_clock         = fbr_aclk;
   assign w_wrespfifo_aclr          = 1'b0;
   assign w_wrespfifo_sclr          =~fbr_arst_n;
   assign w_wrespfifo_data[8:7]     = internal_axi_intf.bresp[1:0];
   assign w_wrespfifo_data[6:0]     = internal_axi_intf.bid[6:0];
   assign w_wrespfifo_wrreq         = internal_axi_intf.bvalid & r_wrespfifo_token[3];
   assign w_wrespfifo_rdreq         = fbr_axi_intf.bready & fbr_axi_intf.bvalid;
   assign w_wrespfifo_q_bresp[1:0]  = w_wrespfifo_q[8:7];
   assign w_wrespfifo_q_bid[6:0]    = w_wrespfifo_q[6:0];


   assign internal_axi_intf.awvalid             = fbr_axi_intf.awvalid & fbr_axi_intf.awready;
   assign internal_axi_intf.awid[6:0]           = `ZERO_PAD_PORT(PORT_AXI_AXID_WIDTH,    7, fbr_axi_intf.awid);
   assign internal_axi_intf.awaddr[39:0]        = `ZERO_PAD_PORT(PORT_AXI_AXADDR_WIDTH, 40, fbr_axi_intf.awaddr);
   assign internal_axi_intf.awlen[7:0]          = `ZERO_PAD_PORT(PORT_AXI_AXLEN_WIDTH,   8, fbr_axi_intf.awlen);
   assign internal_axi_intf.awsize[2:0]         = `ZERO_PAD_PORT(PORT_AXI_AXSIZE_WIDTH,  3, fbr_axi_intf.awsize);
   assign internal_axi_intf.awburst[1:0]        = `ZERO_PAD_PORT(PORT_AXI_AXBURST_WIDTH, 2, fbr_axi_intf.awburst);
   assign internal_axi_intf.awlock              = fbr_axi_intf.awlock;
   assign internal_axi_intf.awuser[3:0]         = `ZERO_PAD_PORT(PORT_AXI_AXUSER_WIDTH,  4, fbr_axi_intf.awuser);
   assign internal_axi_intf.awqos[1:0]          = fbr_axi_intf.awqos[3:2];
   assign internal_axi_intf.arvalid             = fbr_axi_intf.arvalid & fbr_axi_intf.arready;
   assign internal_axi_intf.arid[7:0]           = `ZERO_PAD_PORT(PORT_AXI_AXID_WIDTH,    8, fbr_axi_intf.arid);
   assign internal_axi_intf.araddr[39:0]        = `ZERO_PAD_PORT(PORT_AXI_AXADDR_WIDTH, 40, fbr_axi_intf.araddr);
   assign internal_axi_intf.arlen[7:0]          = `ZERO_PAD_PORT(PORT_AXI_AXLEN_WIDTH,   8, fbr_axi_intf.arlen);
   assign internal_axi_intf.arsize[2:0]         = `ZERO_PAD_PORT(PORT_AXI_AXSIZE_WIDTH,  3, fbr_axi_intf.arsize);
   assign internal_axi_intf.arburst[1:0]        = `ZERO_PAD_PORT(PORT_AXI_AXBURST_WIDTH, 2, fbr_axi_intf.arburst);
   assign internal_axi_intf.arlock              = fbr_axi_intf.arlock;
   assign internal_axi_intf.aruser[3:0]         = `ZERO_PAD_PORT(PORT_AXI_AXUSER_WIDTH,  4, fbr_axi_intf.aruser);
   assign internal_axi_intf.arqos[1:0]          = fbr_axi_intf.arqos[3:2];
   assign internal_axi_intf.wvalid              = fbr_axi_intf.wvalid & fbr_axi_intf.wready;
   assign internal_axi_intf.wdata[255:0]        = `ZERO_PAD_PORT(PORT_AXI_DATA_WIDTH,  256, fbr_axi_intf.wdata);
   assign internal_axi_intf.wstrb[31:0]         = `ZERO_PAD_PORT(PORT_AXI_STRB_WIDTH,   32, fbr_axi_intf.wstrb);
   assign internal_axi_intf.wlast               = fbr_axi_intf.wlast;
   assign internal_axi_intf.bready              =~w_wrespfifo_almost_full;
   assign internal_axi_intf.rready              =~w_rdfifo_almost_full;

   generate
      if (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_p2c_hmc::IS_USED[WS])
      begin : gen_axi_outputs
         assign fbr_axi_intf.awready               = internal_axi_intf.awready & ((r_awfifo_credit_ctr[3:0] == 0) ? 1'b0 : 1'b1);
         assign fbr_axi_intf.arready               = internal_axi_intf.arready & ((r_arfifo_credit_ctr[3:0] == 0) ? 1'b0 : 1'b1);
         assign fbr_axi_intf.wready                = internal_axi_intf.wready & ((r_wfifo_credit_ctr[3:0] == 0) ? 1'b0 : 1'b1);
         assign fbr_axi_intf.bvalid                =~w_wrespfifo_empty;
         assign fbr_axi_intf.bid                   = `ZERO_PAD_PORT(PORT_AXI_ID_WIDTH,      7, w_wrespfifo_q_bid);
         assign fbr_axi_intf.bresp                 = `ZERO_PAD_PORT(PORT_AXI_RESP_WIDTH,    2, w_wrespfifo_q_bresp);
         assign fbr_axi_intf.rvalid                =~w_rdfifo_empty;
         assign fbr_axi_intf.rid                   = `ZERO_PAD_PORT(PORT_AXI_ID_WIDTH,      7, w_rdfifo_q_rid);
         assign fbr_axi_intf.rresp                 = `ZERO_PAD_PORT(PORT_AXI_RESP_WIDTH,    2, w_rdfifo_q_rresp);
         assign fbr_axi_intf.ruser                 = '0;
         assign fbr_axi_intf.rlast                 = w_rdfifo_q_rlast;
         assign fbr_axi_intf.rdata                 = `ZERO_PAD_PORT(PORT_AXI_DATA_WIDTH,  256, w_rdfifo_q_rdata);
      end
      else
      begin : gen_axi_tieoffs
         assign fbr_axi_intf.awready               = '0;
         assign fbr_axi_intf.arready               = '0;
         assign fbr_axi_intf.wready                = '0;
         assign fbr_axi_intf.bvalid                = '0;
         assign fbr_axi_intf.bid                   = '0;
         assign fbr_axi_intf.bresp                 = '0;
         assign fbr_axi_intf.rvalid                = '0;
         assign fbr_axi_intf.rid                   = '0;
         assign fbr_axi_intf.rresp                 = '0;
         assign fbr_axi_intf.ruser                 = '0;
         assign fbr_axi_intf.rlast                 = '0;
         assign fbr_axi_intf.rdata                 = '0;
      end
   endgenerate

   generate
      if (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_p2c_hmc::IS_USED[WS] || ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_hmc::IS_USED[WS])
      begin : gen_skid_buffers
         scfifo
         #(
            .lpm_width(RDFIFO_DATA_WIDTH),
            .lpm_widthu(RDFIFO_PTR_WIDTH),
            .lpm_numwords(32),
            .lpm_showahead("ON"),
            .lpm_type("scfifo"),
            .intended_device_family("Agilex"),
            .underflow_checking("OFF"),
            .overflow_checking("OFF"),
            .allow_rwcycle_when_full("OFF"),
            .use_eab("ON"),
            .add_ram_output_register("ON"),
            .almost_full_value(26),
            .almost_empty_value(2),
            .maximum_depth(0),
            .enable_ecc("FALSE")
         )
         inst_rdfifo
         (
            .clock(w_rdfifo_clock),
            .aclr(w_rdfifo_aclr),
            .sclr(w_rdfifo_sclr),
            .data(w_rdfifo_data),
            .wrreq(w_rdfifo_wrreq),
            .rdreq(w_rdfifo_rdreq),
            .q(w_rdfifo_q),
            .usedw(w_rdfifo_usedw),
            .empty(w_rdfifo_empty),
            .full(w_rdfifo_full),
            .almost_empty(w_rdfifo_almost_empty),
            .almost_full(w_rdfifo_almost_full)
         );

         scfifo
         #(
            .lpm_width(WRESPFIFO_DATA_WIDTH),
            .lpm_widthu(WRESPFIFO_PTR_WIDTH),
            .lpm_numwords(32),
            .lpm_showahead("ON"),
            .lpm_type("scfifo"),
            .intended_device_family("Agilex"),
            .underflow_checking("OFF"),
            .overflow_checking("OFF"),
            .allow_rwcycle_when_full("OFF"),
            .use_eab("ON"),
            .add_ram_output_register("ON"),
            .almost_full_value(26),
            .almost_empty_value(2),
            .maximum_depth(0),
            .enable_ecc("FALSE")
         )
         inst_wrespfifo
         (
            .clock(w_wrespfifo_clock),
            .aclr(w_wrespfifo_aclr),
            .sclr(w_wrespfifo_sclr),
            .data(w_wrespfifo_data),
            .wrreq(w_wrespfifo_wrreq),
            .rdreq(w_wrespfifo_rdreq),
            .q(w_wrespfifo_q),
            .usedw(w_wrespfifo_usedw),
            .empty(w_wrespfifo_empty),
            .full(w_wrespfifo_full),
            .almost_empty(w_wrespfifo_almost_empty),
            .almost_full(w_wrespfifo_almost_full)
         );
      end
      else
      begin : gen_no_fifos
      end
   endgenerate



   always_ff @(posedge fbr_aclk)
   begin
      if (fbr_arst_n == 1'b0)
      begin
         r_wfifo_credit_ctr[3:0]  <= 4'h0;
         r_awfifo_credit_ctr[3:0] <= 4'h0;
         r_arfifo_credit_ctr[3:0] <= 4'h0;
      end
      else
      begin
         if (internal_axi_intf.wready == 1'b1)
         begin
            r_wfifo_credit_ctr[3:0] <= 4'd3;
         end
         else
         begin
            if (r_wfifo_credit_ctr[3:0] != 4'h0)
            begin
               r_wfifo_credit_ctr[3:0] <= r_wfifo_credit_ctr[3:0] - 4'h1;
            end
         end

         if (internal_axi_intf.awready == 1'b1)
         begin
            r_awfifo_credit_ctr[3:0] <= 4'd3;
         end
         else
         begin
            if (r_awfifo_credit_ctr[3:0] != 4'h0)
            begin
               r_awfifo_credit_ctr[3:0] <= r_awfifo_credit_ctr[3:0] - 4'h1;
            end
         end

         if (internal_axi_intf.arready == 1'b1)
         begin
            r_arfifo_credit_ctr[3:0] <= 4'd3;
         end
         else
         begin
            if (r_arfifo_credit_ctr[3:0] != 4'h0)
            begin
               r_arfifo_credit_ctr[3:0] <= r_arfifo_credit_ctr[3:0] - 4'h1;
            end
         end
      end
   end

   always_ff @(posedge fbr_aclk)
   begin
      r_rdfifo_token[5:0]    <= {r_rdfifo_token[4:0],    (fbr_arst_n & (~w_rdfifo_almost_full))};
      r_wrespfifo_token[5:0] <= {r_wrespfifo_token[4:0], (fbr_arst_n & (~w_wrespfifo_almost_full))};
   end

endmodule

`ifdef ZERO_PAD_PORT
`undef ZERO_PAD_PORT
`endif


