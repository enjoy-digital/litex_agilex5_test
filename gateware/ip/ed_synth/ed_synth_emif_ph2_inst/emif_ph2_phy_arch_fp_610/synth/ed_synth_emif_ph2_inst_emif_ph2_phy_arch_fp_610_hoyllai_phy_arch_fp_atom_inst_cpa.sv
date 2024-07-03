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



module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_cpa #(

   localparam PORT_O_AVL_READDATA_WIDTH = 32,
   localparam PORT_I_AVL_ADDRESS_WIDTH = 22,
   localparam PORT_I_AVL_WRITEDATA_WIDTH = 32,
   localparam PORT_I_VCO8PH_WIDTH = 8,

   localparam INTF_PLL_TO_CPA_WIDTH = PORT_I_VCO8PH_WIDTH + 3,
   localparam INTF_SEQ_AVBB_WIDTH   = PORT_I_AVL_ADDRESS_WIDTH + PORT_I_AVL_WRITEDATA_WIDTH + 4,
   localparam INTF_CPA_TO_SEQ_WIDTH = PORT_O_AVL_READDATA_WIDTH
) (

   input logic                                  usr_async_clk,
   output logic [INTF_CPA_TO_SEQ_WIDTH-1:0]     cpa_to_seq,
   output logic                                 cpa_to_falane,
   output logic                                 cpa_to_fahmc,

   output logic                                 cpa_clock,
   output logic                                 cpa_locked,

   input  logic [INTF_PLL_TO_CPA_WIDTH-1:0]  pll_to_cpa,
   input  logic [INTF_SEQ_AVBB_WIDTH-1:0]    seq_avbb


);
   timeunit 1ns;
   timeprecision 1ps;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_cpa::*;

   logic                                     o_core_clk_out;
   logic    [PORT_O_AVL_READDATA_WIDTH-1:0]  o_avl_readdata;
   logic                                     o_lock;
   logic                                     i_phyclk;
   logic                                     i_phyclk_sync;
   logic    [PORT_I_VCO8PH_WIDTH-1:0]        i_vco8ph;
   logic                                     i_pll_lock;
   logic                                     i_avl_clk;
   logic                                     i_avl_rst_n;
   logic                                     i_avl_write;
   logic                                     i_avl_read;
   logic    [PORT_I_AVL_ADDRESS_WIDTH-1:0]   i_avl_address;
   logic    [PORT_I_AVL_WRITEDATA_WIDTH-1:0] i_avl_writedata;

   logic                                     w_core_clk_in;

   assign {i_phyclk, i_phyclk_sync, i_vco8ph, i_pll_lock} = pll_to_cpa;

   assign {i_avl_rst_n,
           i_avl_clk,
           i_avl_write,
           i_avl_read,
           i_avl_address,
           i_avl_writedata} = seq_avbb;

   tennm_clkgen # (
      .base_address              (BASE_ADDRESS),
      .feedback_dly_sel          (FEEDBACK_DLY_SEL),
      .feedback_dly_steps        (FEEDBACK_DLY_STEPS),
      .phy_clk_div               (PHY_CLK_DIV),
      .protocol_mode             (PROTOCOL_MODE),
      .vco_clk_div_exponent      (VCO_CLK_DIV_EXPONENT),
      .vco_clk_div_mantissa      (VCO_CLK_DIV_MANTISSA),
      .vco_clk_freq              (VCO_CLK_FREQ)
   ) cpa (
      .o_avl_readdata            (o_avl_readdata),
      .o_core_clk_out            (o_core_clk_out),
      .i_phyclk                  (i_phyclk),
      .i_phyclk_sync             (i_phyclk_sync),
      .i_vco8ph                  (i_vco8ph),
      .o_lock                    (o_lock),
      .i_avl_clk                 (i_avl_clk),
      .i_avl_rst_n               (i_avl_rst_n),
      .i_avl_write               (i_avl_write),
      .i_avl_read                (i_avl_read),
      .i_avl_address             (i_avl_address),
      .i_avl_writedata           (i_avl_writedata),
      .i_pll_lock                (i_pll_lock),
      .i_core_clk_in             (w_core_clk_in)
   );

   generate
      if (IS_USED) begin: g_sync_mode
         assign w_core_clk_in = o_core_clk_out;

         assign cpa_to_seq    = o_avl_readdata;
         assign cpa_to_falane = o_core_clk_out;
         assign cpa_to_fahmc  = o_core_clk_out;
         assign cpa_clock     = o_core_clk_out;
         assign cpa_locked    = o_lock;

      end else begin : g_async_noc_mode
         assign w_core_clk_in =  usr_async_clk;

         assign cpa_to_seq    = o_avl_readdata;
         assign cpa_to_falane = usr_async_clk;
         assign cpa_to_fahmc  = usr_async_clk;
         assign cpa_clock     = usr_async_clk;
         assign cpa_locked    = o_lock;

      end
   endgenerate
   
endmodule


