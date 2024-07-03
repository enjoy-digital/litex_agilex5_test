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

(*altera_attribute= {"-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF"} *)
module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_hmc_wide #(

   parameter ID               = 0,
   parameter AXI4_ADDR_WIDTH  = 0,
   parameter AXI4_DATA_WIDTH  = 0,

   localparam PORT_REGIFHADDR_WIDTH  = 16,
   localparam PORT_REGIFHBURST_WIDTH = 3,
   localparam PORT_REGIFHSIZE_WIDTH  = 3,
   localparam PORT_REGIFHTRANS_WIDTH = 2,
   localparam PORT_REGIFHDATA_WIDTH  = 32,
   localparam PORT_REGIFHRESP_WIDTH  = 2,

   localparam PORT_AXI_AXADDR_WIDTH  = AXI4_ADDR_WIDTH,
   localparam PORT_AXI_AXBURST_WIDTH = 2,
   localparam PORT_AXI_AXID_WIDTH    = 7,
   localparam PORT_AXI_AXLEN_WIDTH   = 8,
   localparam PORT_AXI_AXQOS_WIDTH   = 2,
   localparam PORT_AXI_AXSIZE_WIDTH  = 3,
   localparam PORT_AXI_AXUSER_WIDTH  = 4,
   localparam PORT_AXI_DATA_WIDTH    = AXI4_DATA_WIDTH,
   localparam PORT_AXI_STRB_WIDTH    = AXI4_DATA_WIDTH/8,
   localparam PORT_AXI_ID_WIDTH      = PORT_AXI_AXID_WIDTH,
   localparam PORT_AXI_RESP_WIDTH    = 2,
   localparam PORT_AXI_USER_WIDTH    = 32,

   localparam PORT_AXI_NOC_AXUSER_WIDTH = 14,

   localparam PORT_PHYMUX_PHYADAPT_DATA_WIDTH       = 96,
   localparam PORT_PHYMUX_PHYADAPT_DATA_VALID_WIDTH = 4,
   localparam PORT_PHYMUX_PHYADAPT_RANK_WIDTH       = 8,
   localparam PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH    = 4,
   localparam PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH  = 4,
   localparam PORT_SIM_PARAM_TABLE_WIDTH            = 16384,

   localparam INTF_FAHMC_TO_HMC_WIDTH = 168,
   localparam INTF_HMC_TO_FAHMC_WIDTH = 32,
   localparam INTF_FAHMC_TO_CORE_WIDTH =  28 + 8 +
                                          2*PORT_AXI_AXADDR_WIDTH +
                                          2*PORT_AXI_AXLEN_WIDTH +
                                          2*PORT_AXI_AXSIZE_WIDTH +
                                          2*PORT_AXI_AXBURST_WIDTH +
                                          2*PORT_AXI_AXQOS_WIDTH +
                                          2*PORT_AXI_AXUSER_WIDTH +
                                          2*PORT_AXI_AXID_WIDTH,

   localparam INTF_HMC_TO_FALANE_WIDTH = 100,
   localparam INTF_FALANE_TO_HMC_WIDTH = 116,

   localparam INTF_HMC_TO_IOSSM_WIDTH = PORT_REGIFHDATA_WIDTH+
                                        PORT_REGIFHRESP_WIDTH+
                                        2,
   localparam INTF_IOSSM_TO_HMC_WIDTH = PORT_REGIFHADDR_WIDTH +
                                        PORT_REGIFHBURST_WIDTH +
                                        PORT_REGIFHSIZE_WIDTH +
                                        PORT_REGIFHTRANS_WIDTH +
                                        PORT_REGIFHDATA_WIDTH +
                                        5 + 1 + 4,

   localparam INTF_OTHER_HMC_WIDTH = 2,
   
   localparam INTF_LS_TO_HMC_WIDTH = 2,

   localparam INTF_HMC_TO_PA_WIDTH = 2*PORT_PHYMUX_PHYADAPT_RANK_WIDTH +
                                     2*PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH +
                                     2*PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH +
                                     PORT_PHYMUX_PHYADAPT_DATA_WIDTH +
                                     3 , 
   localparam INTF_PA_TO_HMC_WIDTH = PORT_PHYMUX_PHYADAPT_DATA_WIDTH +
                                     PORT_PHYMUX_PHYADAPT_DATA_VALID_WIDTH,

   localparam INTF_PLL_TO_HMC_WIDTH = 2
) (
   output       logic [3:0][INTF_HMC_TO_FALANE_WIDTH-1:0] hmc_to_falane,
   input        logic [3:0][INTF_FALANE_TO_HMC_WIDTH-1:0] falane_to_hmc,

   output       logic [INTF_HMC_TO_FAHMC_WIDTH-1:0]       hmc_to_fahmc,
   input        logic [INTF_FAHMC_TO_HMC_WIDTH-1:0]       fahmc_to_hmc,

   AXI_BUS.Subordinate                                    fanoc_hmc_axi_intf,

   output       logic [INTF_HMC_TO_IOSSM_WIDTH-1:0]       hmc_to_iossm,
   input        logic [INTF_IOSSM_TO_HMC_WIDTH-1:0]       iossm_to_hmc,
   input        logic                                     iossm_to_hmc_rst_n,

   output       logic [INTF_OTHER_HMC_WIDTH-1:0]          to_other_hmc,
   input        logic [INTF_OTHER_HMC_WIDTH-1:0]          from_other_hmc,

   input        logic [INTF_PLL_TO_HMC_WIDTH-1:0]         pll_to_hmc,

   output       logic                                     hmc_to_core,
   input        logic                                     core_to_hmc,

   output       logic [INTF_HMC_TO_PA_WIDTH-1:0]          hmc_to_pa0,
   input        logic [INTF_PA_TO_HMC_WIDTH-1:0]          pa0_to_hmc,

   output       logic [INTF_HMC_TO_PA_WIDTH-1:0]          hmc_to_pa1,
   input        logic [INTF_PA_TO_HMC_WIDTH-1:0]          pa1_to_hmc,

   output       logic [INTF_HMC_TO_PA_WIDTH-1:0]          hmc_to_pa2,
   input        logic [INTF_PA_TO_HMC_WIDTH-1:0]          pa2_to_hmc,

   output       logic [INTF_HMC_TO_PA_WIDTH-1:0]          hmc_to_pa3,
   input        logic [INTF_PA_TO_HMC_WIDTH-1:0]          pa3_to_hmc,

   output       logic [INTF_HMC_TO_PA_WIDTH-1:0]          hmc_to_pa4,
   input        logic [INTF_PA_TO_HMC_WIDTH-1:0]          pa4_to_hmc,

   output       logic [INTF_HMC_TO_PA_WIDTH-1:0]          hmc_to_pa5,
   input        logic [INTF_PA_TO_HMC_WIDTH-1:0]          pa5_to_hmc,

   output       logic [INTF_HMC_TO_PA_WIDTH-1:0]          hmc_to_pa6,
   input        logic [INTF_PA_TO_HMC_WIDTH-1:0]          pa6_to_hmc,

   output       logic [INTF_HMC_TO_PA_WIDTH-1:0]          hmc_to_pa7,
   input        logic [INTF_PA_TO_HMC_WIDTH-1:0]          pa7_to_hmc,

   output       logic [PORT_SIM_PARAM_TABLE_WIDTH-1:0]    o_sim_param_table
);
   timeunit 1ns;
   timeprecision 1ps;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_hmc_wide::*;

   AXI_BUS #( 
      .PORT_AXI_AXADDR_WIDTH  (40),
      .PORT_AXI_AXID_WIDTH    (7),
      .PORT_AXI_AXBURST_WIDTH (2),
      .PORT_AXI_AXLEN_WIDTH   (8),
      .PORT_AXI_AXSIZE_WIDTH  (3),
      .PORT_AXI_AXUSER_WIDTH  (4),
      .PORT_AXI_DATA_WIDTH    (256),
      .PORT_AXI_STRB_WIDTH    (32),
      .PORT_AXI_RESP_WIDTH    (2),
      .PORT_AXI_ID_WIDTH      (7),
      .PORT_AXI_USER_WIDTH    (4),
      .PORT_AXI_AXQOS_WIDTH   (2)
   ) internal_axi_intf();

   logic                                                i_fbr_axi_aclk;
   logic                                                i_fbr_dfi_init_complete;
   logic                                                i_fbr_mc_clk_en;
   logic                                                i_mc_rst_n;
   logic    [PORT_REGIFHADDR_WIDTH-1:0]                 i_regifhaddr;
   logic    [PORT_REGIFHBURST_WIDTH-1:0]                i_regifhburst;
   logic                                                i_regifhclk;
   logic                                                i_regifhready;
   logic                                                i_regifhresetn;
   logic                                                i_regifhselx;
   logic    [PORT_REGIFHSIZE_WIDTH-1:0]                 i_regifhsize;
   logic    [PORT_REGIFHTRANS_WIDTH-1:0]                i_regifhtrans;
   logic    [PORT_REGIFHDATA_WIDTH-1:0]                 i_regifhwdata;
   logic                                                i_regifhwrite;
   logic                                                o_mc_irq;
   logic    [PORT_REGIFHDATA_WIDTH-1:0]                 o_regifhrdata;
   logic                                                o_regifhreadyout;
   logic    [PORT_REGIFHRESP_WIDTH-1:0]                 o_regifhresp;
   logic                                                o_noc_axi_aclk;
   logic                                                i_dfi_init_complete_in;
   logic                                                o_dfi_init_complete_out;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       i_phymux_phyadapt0_rddata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_VALID_WIDTH-1:0] i_phymux_phyadapt0_rddata_valid;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt0_rd_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt0_rddata_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt0_wr_dqs0_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt0_wr_dqs1_en;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt0_wr_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       o_phymux_phyadapt0_wrdata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt0_wrdata_en;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       i_phymux_phyadapt1_rddata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_VALID_WIDTH-1:0] i_phymux_phyadapt1_rddata_valid;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt1_rd_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt1_rddata_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt1_wr_dqs0_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt1_wr_dqs1_en;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt1_wr_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       o_phymux_phyadapt1_wrdata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt1_wrdata_en;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       i_phymux_phyadapt2_rddata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_VALID_WIDTH-1:0] i_phymux_phyadapt2_rddata_valid;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt2_rd_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt2_rddata_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt2_wr_dqs0_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt2_wr_dqs1_en;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt2_wr_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       o_phymux_phyadapt2_wrdata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt2_wrdata_en;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       i_phymux_phyadapt3_rddata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_VALID_WIDTH-1:0] i_phymux_phyadapt3_rddata_valid;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt3_rd_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt3_rddata_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt3_wr_dqs0_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt3_wr_dqs1_en;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt3_wr_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       o_phymux_phyadapt3_wrdata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt3_wrdata_en;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       i_phymux_phyadapt4_rddata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_VALID_WIDTH-1:0] i_phymux_phyadapt4_rddata_valid;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt4_rd_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt4_rddata_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt4_wr_dqs0_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt4_wr_dqs1_en;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt4_wr_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       o_phymux_phyadapt4_wrdata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt4_wrdata_en;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       i_phymux_phyadapt5_rddata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_VALID_WIDTH-1:0] i_phymux_phyadapt5_rddata_valid;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt5_rd_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt5_rddata_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt5_wr_dqs0_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt5_wr_dqs1_en;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt5_wr_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       o_phymux_phyadapt5_wrdata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt5_wrdata_en;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       i_phymux_phyadapt6_rddata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_VALID_WIDTH-1:0] i_phymux_phyadapt6_rddata_valid;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt6_rd_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt6_rddata_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt6_wr_dqs0_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt6_wr_dqs1_en;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt6_wr_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       o_phymux_phyadapt6_wrdata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt6_wrdata_en;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       i_phymux_phyadapt7_rddata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_VALID_WIDTH-1:0] i_phymux_phyadapt7_rddata_valid;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt7_rd_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt7_rddata_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt7_wr_dqs0_en;
   logic    [PORT_PHYMUX_PHYADAPT_WR_DQS_EN_WIDTH-1:0]  o_phymux_phyadapt7_wr_dqs1_en;
   logic    [PORT_PHYMUX_PHYADAPT_RANK_WIDTH-1:0]       o_phymux_phyadapt7_wr_rank;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_WIDTH-1:0]       o_phymux_phyadapt7_wrdata;
   logic    [PORT_PHYMUX_PHYADAPT_DATA_EN_WIDTH-1:0]    o_phymux_phyadapt7_wrdata_en;
   logic                                                i_mc_clk;
   logic                                                i_mc_clk_sync;
   logic                                                i_mc_clk_en_in;
   logic                                                i_mc_clk_en_in_from_iossm;
   logic                                                i_mc_clk_en_in_from_other_mc;
   logic                                                o_mc_clk_en_out;
   logic                                                o_phyadapt0_dram_clock_disable;
   logic                                                o_phyadapt1_dram_clock_disable;
   logic                                                o_phyadapt2_dram_clock_disable;
   logic                                                o_phyadapt3_dram_clock_disable;
   logic                                                o_phyadapt4_dram_clock_disable;
   logic                                                o_phyadapt5_dram_clock_disable;
   logic                                                o_phyadapt6_dram_clock_disable;
   logic                                                o_phyadapt7_dram_clock_disable;
   logic                                                o_phyadapt0_rxanalogen;
   logic                                                o_phyadapt1_rxanalogen;
   logic                                                o_phyadapt2_rxanalogen;
   logic                                                o_phyadapt3_rxanalogen;
   logic                                                o_phyadapt4_rxanalogen;
   logic                                                o_phyadapt5_rxanalogen;
   logic                                                o_phyadapt6_rxanalogen;
   logic                                                o_phyadapt7_rxanalogen;
   logic                                                o_phyadapt0_txanalogen;
   logic                                                o_phyadapt1_txanalogen;
   logic                                                o_phyadapt2_txanalogen;
   logic                                                o_phyadapt3_txanalogen;
   logic                                                o_phyadapt4_txanalogen;
   logic                                                o_phyadapt5_txanalogen;
   logic                                                o_phyadapt6_txanalogen;
   logic                                                o_phyadapt7_txanalogen;

   // handle hmc_clk_out
   generate
      if (IS_USED)
         assign hmc_to_core = {o_noc_axi_aclk};
      else
         assign hmc_to_core = 1'b0;
   endgenerate

   logic [INTF_HMC_TO_FALANE_WIDTH-1:0] hmc_to_falane_3;
   logic [INTF_HMC_TO_FALANE_WIDTH-1:0] hmc_to_falane_2;
   logic [INTF_HMC_TO_FALANE_WIDTH-1:0] hmc_to_falane_1;
   logic [INTF_HMC_TO_FALANE_WIDTH-1:0] hmc_to_falane_0;

   logic [INTF_FALANE_TO_HMC_WIDTH-1:0] falane_to_hmc_3;
   logic [INTF_FALANE_TO_HMC_WIDTH-1:0] falane_to_hmc_2;
   logic [INTF_FALANE_TO_HMC_WIDTH-1:0] falane_to_hmc_1;
   logic [INTF_FALANE_TO_HMC_WIDTH-1:0] falane_to_hmc_0;
   logic fa_to_hmc__slim_fbr_dfi_init_complete;
   logic fa_to_hmc__slim_fbr_mc_clk_en;        
   logic fa_to_hmc__wide_fbr_dfi_init_complete;
   logic fa_to_hmc__wide_fbr_mc_clk_en;                                         


   assign hmc_to_falane = {hmc_to_falane_3,hmc_to_falane_2,hmc_to_falane_1,hmc_to_falane_0};
   assign {falane_to_hmc_3,falane_to_hmc_2,falane_to_hmc_1,falane_to_hmc_0} = falane_to_hmc;

   generate
      if (BASE_ADDRESS == 0) begin: falane_to_hmc_wide
         assign {internal_axi_intf.wdata[63:0], internal_axi_intf.wstrb} = falane_to_hmc_3[95:0];
         assign {internal_axi_intf.wdata[159:64]}                        = falane_to_hmc_2[95:0];
         assign {internal_axi_intf.wdata[255:160]}                       = falane_to_hmc_1[95:0];

         assign hmc_to_falane_3 = {internal_axi_intf.rdata[63:0],{32{1'b0}}};
         assign hmc_to_falane_2 = {internal_axi_intf.rdata[159:64]};
         assign hmc_to_falane_1 = {internal_axi_intf.rdata[255:160]};
         assign hmc_to_falane_0 = {INTF_HMC_TO_FALANE_WIDTH{1'b0}};
      end: falane_to_hmc_wide 

      else if (BASE_ADDRESS == 1) begin: falane_to_hmc_slim
         assign {internal_axi_intf.wdata[63:0], internal_axi_intf.wstrb} = falane_to_hmc_0[95:0];
         assign {internal_axi_intf.wdata[159:64]}                        = falane_to_hmc_1[95:0];
         assign {internal_axi_intf.wdata[255:160]}                       = falane_to_hmc_2[95:0];

         assign hmc_to_falane_0 = {internal_axi_intf.rdata[63:0],{32{1'b0}}};
         assign hmc_to_falane_1 = {internal_axi_intf.rdata[159:64]};
         assign hmc_to_falane_2 = {internal_axi_intf.rdata[255:160]};
         assign hmc_to_falane_3 = {INTF_HMC_TO_FALANE_WIDTH{1'b0}};
      end
      else begin: falane_to_hmc_error
      end: falane_to_hmc_error
   endgenerate

   assign hmc_to_fahmc[INTF_HMC_TO_FAHMC_WIDTH-1:24] = '0             ; 
   assign hmc_to_fahmc[ 23: 23] = internal_axi_intf.awready           ; 
   assign hmc_to_fahmc[ 22: 22] = internal_axi_intf.wready            ; 
   assign hmc_to_fahmc[ 21: 15] = internal_axi_intf.bid[6:0]          ; 
   assign hmc_to_fahmc[ 14: 13] = internal_axi_intf.bresp[1:0]        ; 
   assign hmc_to_fahmc[ 12: 12] = internal_axi_intf.bvalid            ; 
   assign hmc_to_fahmc[ 11: 11] = internal_axi_intf.arready           ; 
   assign hmc_to_fahmc[ 10:  4] = internal_axi_intf.rid[6:0]          ; 
   assign hmc_to_fahmc[  3:  3] = internal_axi_intf.rvalid            ; 
   assign hmc_to_fahmc[  2:  2] = internal_axi_intf.rlast             ; 
   assign hmc_to_fahmc[  1:  0] = internal_axi_intf.rresp[1:0]        ; 



   assign i_fbr_axi_aclk = core_to_hmc;

   logic [28:0] hmc_c2p_nc_0;


   assign  internal_axi_intf.araddr[39:0] = fahmc_to_hmc[140:101];          
   assign  internal_axi_intf.arlen[6:0]   = fahmc_to_hmc[100: 94];          
   assign  internal_axi_intf.arsize[2:0]  = fahmc_to_hmc[ 93: 91];          
   assign  internal_axi_intf.arburst[1:0] = fahmc_to_hmc[ 90: 89];          
   assign  internal_axi_intf.arlock       = fahmc_to_hmc[ 88: 88];          
   assign  internal_axi_intf.arqos[1:0]   = fahmc_to_hmc[ 87: 86];          
   assign  internal_axi_intf.aruser[3:0]  = fahmc_to_hmc[ 85: 82];          
   assign  internal_axi_intf.arvalid      = fahmc_to_hmc[ 81: 81];          
   assign  internal_axi_intf.rready       = fahmc_to_hmc[ 80: 80];          
   assign  internal_axi_intf.awid[6:0]    = fahmc_to_hmc[ 77: 71];          
   assign  internal_axi_intf.awaddr[39:0] = fahmc_to_hmc[ 70: 31];          
   assign  internal_axi_intf.awlen[6:0]   = fahmc_to_hmc[ 30: 24];          
   assign  internal_axi_intf.awsize[2:0]  = fahmc_to_hmc[ 23: 21];          
   assign  internal_axi_intf.awburst[1:0] = fahmc_to_hmc[ 20: 19];          
   assign  internal_axi_intf.awlock       = fahmc_to_hmc[ 18: 18];          
   assign  internal_axi_intf.awqos[1:0]   = fahmc_to_hmc[ 17: 16];          
   assign  internal_axi_intf.awuser[3:0]  = fahmc_to_hmc[ 15: 12];          
   assign  internal_axi_intf.awvalid      = fahmc_to_hmc[ 11: 11];          
   assign  internal_axi_intf.wvalid       = fahmc_to_hmc[ 10: 10];          
   assign  internal_axi_intf.wlast        = fahmc_to_hmc[  9:  9];          
   assign  internal_axi_intf.bready       = fahmc_to_hmc[  8:  8];          
   assign  internal_axi_intf.arid[6:0]    = fahmc_to_hmc[  6:  0];          
   assign  internal_axi_intf.arlen[7]     = 1'b0;
   assign  internal_axi_intf.awlen[7]     = 1'b0;

   assign hmc_to_iossm = {o_mc_irq,
                          o_regifhrdata,
                          o_regifhreadyout,
                          o_regifhresp};
   assign i_mc_rst_n = iossm_to_hmc_rst_n;
   assign {i_regifhaddr,
           i_regifhburst,
           i_regifhclk,
           i_regifhready,
           i_regifhresetn,
           i_regifhselx,
           i_regifhsize,
           i_regifhtrans,
           i_regifhwdata,
           i_regifhwrite,
           i_mc_clk_en_in_from_iossm,
           fa_to_hmc__slim_fbr_dfi_init_complete,
           fa_to_hmc__slim_fbr_mc_clk_en,        
           fa_to_hmc__wide_fbr_dfi_init_complete,
           fa_to_hmc__wide_fbr_mc_clk_en                                         
           } = iossm_to_hmc;

   assign to_other_hmc = {o_dfi_init_complete_out,
                          o_mc_clk_en_out};
   assign {i_dfi_init_complete_in,
           i_mc_clk_en_in_from_other_mc} = from_other_hmc;

   generate
      if (ID==0) begin 
         assign i_mc_clk_en_in = i_mc_clk_en_in_from_iossm;
         assign i_fbr_dfi_init_complete = fa_to_hmc__wide_fbr_dfi_init_complete;
         assign i_fbr_mc_clk_en = fa_to_hmc__wide_fbr_mc_clk_en;
      end else begin 
         assign i_mc_clk_en_in = i_mc_clk_en_in_from_other_mc;
         assign i_fbr_dfi_init_complete = fa_to_hmc__slim_fbr_dfi_init_complete;
         assign i_fbr_mc_clk_en = fa_to_hmc__slim_fbr_mc_clk_en;
      end
   endgenerate

   generate
      if (BASE_ADDRESS == 0) begin: hmc_to_pa_wide
         assign hmc_to_pa0 = {o_phymux_phyadapt0_rd_rank,
                              o_phymux_phyadapt0_rddata_en,
                              o_phymux_phyadapt0_wr_dqs0_en,
                              o_phymux_phyadapt0_wr_dqs1_en,
                              o_phymux_phyadapt0_wr_rank,
                              o_phymux_phyadapt0_wrdata,
                              o_phymux_phyadapt0_wrdata_en,
                              o_phyadapt0_dram_clock_disable,
                              o_phyadapt0_rxanalogen,
                              o_phyadapt0_txanalogen};
         assign {i_phymux_phyadapt0_rddata,
                 i_phymux_phyadapt0_rddata_valid} = pa0_to_hmc;

         assign hmc_to_pa1 = {o_phymux_phyadapt1_rd_rank,
                              o_phymux_phyadapt1_rddata_en,
                              o_phymux_phyadapt1_wr_dqs0_en,
                              o_phymux_phyadapt1_wr_dqs1_en,
                              o_phymux_phyadapt1_wr_rank,
                              o_phymux_phyadapt1_wrdata,
                              o_phymux_phyadapt1_wrdata_en,
                              o_phyadapt1_dram_clock_disable,
                              o_phyadapt1_rxanalogen,
                              o_phyadapt1_txanalogen};
         assign {i_phymux_phyadapt1_rddata,
                 i_phymux_phyadapt1_rddata_valid} = pa1_to_hmc;

         assign hmc_to_pa2 = {o_phymux_phyadapt2_rd_rank,
                              o_phymux_phyadapt2_rddata_en,
                              o_phymux_phyadapt2_wr_dqs0_en,
                              o_phymux_phyadapt2_wr_dqs1_en,
                              o_phymux_phyadapt2_wr_rank,
                              o_phymux_phyadapt2_wrdata,
                              o_phymux_phyadapt2_wrdata_en,
                              o_phyadapt2_dram_clock_disable,
                              o_phyadapt2_rxanalogen,
                              o_phyadapt2_txanalogen};
         assign {i_phymux_phyadapt2_rddata,
                 i_phymux_phyadapt2_rddata_valid} = pa2_to_hmc;

         assign hmc_to_pa3 = {o_phymux_phyadapt3_rd_rank,
                              o_phymux_phyadapt3_rddata_en,
                              o_phymux_phyadapt3_wr_dqs0_en,
                              o_phymux_phyadapt3_wr_dqs1_en,
                              o_phymux_phyadapt3_wr_rank,
                              o_phymux_phyadapt3_wrdata,
                              o_phymux_phyadapt3_wrdata_en,
                              o_phyadapt3_dram_clock_disable,
                              o_phyadapt3_rxanalogen,
                              o_phyadapt3_txanalogen};
         assign {i_phymux_phyadapt3_rddata,
                 i_phymux_phyadapt3_rddata_valid} = pa3_to_hmc;

         assign hmc_to_pa4 = {o_phymux_phyadapt4_rd_rank,
                              o_phymux_phyadapt4_rddata_en,
                              o_phymux_phyadapt4_wr_dqs0_en,
                              o_phymux_phyadapt4_wr_dqs1_en,
                              o_phymux_phyadapt4_wr_rank,
                              o_phymux_phyadapt4_wrdata,
                              o_phymux_phyadapt4_wrdata_en,
                              o_phyadapt4_dram_clock_disable,
                              o_phyadapt4_rxanalogen,
                              o_phyadapt4_txanalogen};
         assign {i_phymux_phyadapt4_rddata,
                 i_phymux_phyadapt4_rddata_valid} = pa4_to_hmc;

         assign hmc_to_pa5 = {o_phymux_phyadapt5_rd_rank,
                              o_phymux_phyadapt5_rddata_en,
                              o_phymux_phyadapt5_wr_dqs0_en,
                              o_phymux_phyadapt5_wr_dqs1_en,
                              o_phymux_phyadapt5_wr_rank,
                              o_phymux_phyadapt5_wrdata,
                              o_phymux_phyadapt5_wrdata_en,
                              o_phyadapt5_dram_clock_disable,
                              o_phyadapt5_rxanalogen,
                              o_phyadapt5_txanalogen};
         assign {i_phymux_phyadapt5_rddata,
                 i_phymux_phyadapt5_rddata_valid} = pa5_to_hmc;

         assign hmc_to_pa6 = {o_phymux_phyadapt6_rd_rank,
                              o_phymux_phyadapt6_rddata_en,
                              o_phymux_phyadapt6_wr_dqs0_en,
                              o_phymux_phyadapt6_wr_dqs1_en,
                              o_phymux_phyadapt6_wr_rank,
                              o_phymux_phyadapt6_wrdata,
                              o_phymux_phyadapt6_wrdata_en,
                              o_phyadapt6_dram_clock_disable,
                              o_phyadapt6_rxanalogen,
                              o_phyadapt6_txanalogen};
         assign {i_phymux_phyadapt6_rddata,
                 i_phymux_phyadapt6_rddata_valid} = pa6_to_hmc;

         assign hmc_to_pa7 = {o_phymux_phyadapt7_rd_rank,
                              o_phymux_phyadapt7_rddata_en,
                              o_phymux_phyadapt7_wr_dqs0_en,
                              o_phymux_phyadapt7_wr_dqs1_en,
                              o_phymux_phyadapt7_wr_rank,
                              o_phymux_phyadapt7_wrdata,
                              o_phymux_phyadapt7_wrdata_en,
                              o_phyadapt7_dram_clock_disable,
                              o_phyadapt7_rxanalogen,
                              o_phyadapt7_txanalogen};
         assign {i_phymux_phyadapt7_rddata,
                 i_phymux_phyadapt7_rddata_valid} = pa7_to_hmc;
      end: hmc_to_pa_wide

      else if (BASE_ADDRESS == 1) begin: hmc_to_pa_slim
         assign hmc_to_pa0 = 'h0;
         assign {i_phymux_phyadapt4_rddata,
                 i_phymux_phyadapt4_rddata_valid} = 'h0;

         assign hmc_to_pa1 = 'h0;
         assign {i_phymux_phyadapt5_rddata,
                 i_phymux_phyadapt5_rddata_valid} = 'h0;

         assign hmc_to_pa2 = 'h0;           
         assign {i_phymux_phyadapt6_rddata,
                 i_phymux_phyadapt6_rddata_valid} = 'h0;

         assign hmc_to_pa3 = 'h0;           
         assign {i_phymux_phyadapt7_rddata,
                 i_phymux_phyadapt7_rddata_valid} = 'h0;

         assign hmc_to_pa4 = {o_phymux_phyadapt0_rd_rank,
                              o_phymux_phyadapt0_rddata_en,
                              o_phymux_phyadapt0_wr_dqs0_en,
                              o_phymux_phyadapt0_wr_dqs1_en,
                              o_phymux_phyadapt0_wr_rank,
                              o_phymux_phyadapt0_wrdata,
                              o_phymux_phyadapt0_wrdata_en,
                              o_phyadapt0_dram_clock_disable,
                              o_phyadapt0_rxanalogen,
                              o_phyadapt0_txanalogen};
         assign {i_phymux_phyadapt0_rddata,
                 i_phymux_phyadapt0_rddata_valid} = pa4_to_hmc;

         assign hmc_to_pa5 = {o_phymux_phyadapt1_rd_rank,
                              o_phymux_phyadapt1_rddata_en,
                              o_phymux_phyadapt1_wr_dqs0_en,
                              o_phymux_phyadapt1_wr_dqs1_en,
                              o_phymux_phyadapt1_wr_rank,
                              o_phymux_phyadapt1_wrdata,
                              o_phymux_phyadapt1_wrdata_en,
                              o_phyadapt1_dram_clock_disable,
                              o_phyadapt1_rxanalogen,
                              o_phyadapt1_txanalogen};
         assign {i_phymux_phyadapt1_rddata,
                 i_phymux_phyadapt1_rddata_valid} = pa5_to_hmc;

         assign hmc_to_pa6 = {o_phymux_phyadapt2_rd_rank,
                              o_phymux_phyadapt2_rddata_en,
                              o_phymux_phyadapt2_wr_dqs0_en,
                              o_phymux_phyadapt2_wr_dqs1_en,
                              o_phymux_phyadapt2_wr_rank,
                              o_phymux_phyadapt2_wrdata,
                              o_phymux_phyadapt2_wrdata_en,
                              o_phyadapt2_dram_clock_disable,
                              o_phyadapt2_rxanalogen,
                              o_phyadapt2_txanalogen};
         assign {i_phymux_phyadapt2_rddata,
                 i_phymux_phyadapt2_rddata_valid} = pa6_to_hmc;

         assign hmc_to_pa7 = {o_phymux_phyadapt3_rd_rank,
                              o_phymux_phyadapt3_rddata_en,
                              o_phymux_phyadapt3_wr_dqs0_en,
                              o_phymux_phyadapt3_wr_dqs1_en,
                              o_phymux_phyadapt3_wr_rank,
                              o_phymux_phyadapt3_wrdata,
                              o_phymux_phyadapt3_wrdata_en,
                              o_phyadapt3_dram_clock_disable,
                              o_phyadapt3_rxanalogen,
                              o_phyadapt3_txanalogen};
         assign {i_phymux_phyadapt3_rddata,
                 i_phymux_phyadapt3_rddata_valid} = pa7_to_hmc;
      end: hmc_to_pa_slim 
      else begin: hmc_to_pa_error
      end: hmc_to_pa_error

   endgenerate

   assign {i_mc_clk, i_mc_clk_sync} = pll_to_hmc;


   generate
      if (IS_USED & IS_DUMMY_SLIM) begin : gen_tennm_dummy 
         tennm_hmc # (
            .base_address                                         (BASE_ADDRESS),
            .ctlr_axi_bus_config                                  (CTLR_AXI_BUS_CONFIG),
            .ctlr_bist_config                                     (CTLR_BIST_CONFIG),
            .ctlr_calibration                                     (CTLR_CALIBRATION),
            .ctlr_calibration_dfs_1                               (CTLR_CALIBRATION_DFS_1),
            .ctlr_calibration_dfs_2                               (CTLR_CALIBRATION_DFS_2),
            .ctlr_datapath_ecc_config                             (CTLR_DATAPATH_ECC_CONFIG),
            .ctlr_datapath_ecc_config_dfs_1                       (CTLR_DATAPATH_ECC_CONFIG_DFS_1),
            .ctlr_datapath_ecc_config_dfs_2                       (CTLR_DATAPATH_ECC_CONFIG_DFS_2),
            .ctlr_dfi_config                                      (CTLR_DFI_CONFIG),
            .ctlr_dfi_config_dfs_1                                (CTLR_DFI_CONFIG_DFS_1),
            .ctlr_dfi_config_dfs_2                                (CTLR_DFI_CONFIG_DFS_2),
            .ctlr_dfi_low_power_config                            (CTLR_DFI_LOW_POWER_CONFIG),
            .ctlr_dfi_low_power_config_dfs_1                      (CTLR_DFI_LOW_POWER_CONFIG_DFS_1),
            .ctlr_dfi_low_power_config_dfs_2                      (CTLR_DFI_LOW_POWER_CONFIG_DFS_2),
            .ctlr_dfi_phy_master_config                           (CTLR_DFI_PHY_MASTER_CONFIG),
            .ctlr_dfs_config                                      (CTLR_DFS_CONFIG),
            .ctlr_dfs_config_dfs_1                                (CTLR_DFS_CONFIG_DFS_1),
            .ctlr_dfs_config_dfs_2                                (CTLR_DFS_CONFIG_DFS_2),
            .ctlr_ecc_scrub_config                                (CTLR_ECC_SCRUB_CONFIG),
            .ctlr_init_method                                     (CTLR_INIT_METHOD),
            .ctlr_interrupt_config                                (CTLR_INTERRUPT_CONFIG),
            .ctlr_low_power_config                                (CTLR_LOW_POWER_CONFIG),
            .ctlr_maintenance_task_config                         (CTLR_MAINTENANCE_TASK_CONFIG),
            .ctlr_maintenance_task_config_dfs_1                   (CTLR_MAINTENANCE_TASK_CONFIG_DFS_1),
            .ctlr_maintenance_task_config_dfs_2                   (CTLR_MAINTENANCE_TASK_CONFIG_DFS_2),
            .ctlr_mem_dynamic_timing_config                       (CTLR_MEM_DYNAMIC_TIMING_CONFIG),
            .ctlr_mem_dynamic_timing_config_dfs_1                 (CTLR_MEM_DYNAMIC_TIMING_CONFIG_DFS_1),
            .ctlr_mem_dynamic_timing_config_dfs_2                 (CTLR_MEM_DYNAMIC_TIMING_CONFIG_DFS_2),
            .ctlr_mem_host_board_config                           (CTLR_MEM_HOST_BOARD_CONFIG),
            .ctlr_mem_host_board_config_dfs_1                     (CTLR_MEM_HOST_BOARD_CONFIG_DFS_1),
            .ctlr_mem_host_board_config_dfs_2                     (CTLR_MEM_HOST_BOARD_CONFIG_DFS_2),
            .ctlr_mem_mode_register_config                        (CTLR_MEM_MODE_REGISTER_CONFIG),
            .ctlr_mem_mode_register_config_dfs_1                  (CTLR_MEM_MODE_REGISTER_CONFIG_DFS_1),
            .ctlr_mem_mode_register_config_dfs_2                  (CTLR_MEM_MODE_REGISTER_CONFIG_DFS_2),
            .ctlr_mem_physical_config                             (CTLR_MEM_PHYSICAL_CONFIG),
            .ctlr_mem_rdimm_config                                (CTLR_MEM_RDIMM_CONFIG),
            .ctlr_mem_rdimm_config_dfs_1                          (CTLR_MEM_RDIMM_CONFIG_DFS_1),
            .ctlr_mem_rdimm_config_dfs_2                          (CTLR_MEM_RDIMM_CONFIG_DFS_2),
            .ctlr_misc_config                                     (CTLR_MISC_CONFIG),
            .ctlr_performance_config                              (CTLR_PERFORMANCE_CONFIG),
            .ctlr_performance_config_dfs_1                        (CTLR_PERFORMANCE_CONFIG_DFS_1),
            .ctlr_performance_config_dfs_2                        (CTLR_PERFORMANCE_CONFIG_DFS_2),
            .ctlr_phy_physical_config                             (CTLR_PHY_PHYSICAL_CONFIG),
            .ctlr_ppr_config                                      (CTLR_PPR_CONFIG),
            .ctlr_refresh_config                                  (CTLR_REFRESH_CONFIG),
            .ctlr_sys_bus_timing_config                           (CTLR_SYS_BUS_TIMING_CONFIG),
            .ctlr_sys_bus_timing_config_dfs_1                     (CTLR_SYS_BUS_TIMING_CONFIG_DFS_1),
            .ctlr_sys_bus_timing_config_dfs_2                     (CTLR_SYS_BUS_TIMING_CONFIG_DFS_2),
            .ctlr_sys_odt_config                                  (CTLR_SYS_ODT_CONFIG),
            .ctlr_sys_odt_config_dfs_1                            (CTLR_SYS_ODT_CONFIG_DFS_1),
            .ctlr_sys_odt_config_dfs_2                            (CTLR_SYS_ODT_CONFIG_DFS_2),
            .ctlr_sys_phys_addr_config                            (CTLR_SYS_PHYS_ADDR_CONFIG),
            .ctlr_zq_cal_config                                   (CTLR_ZQ_CAL_CONFIG),
            .ctlr_zq_cal_config_dfs_1                             (CTLR_ZQ_CAL_CONFIG_DFS_1),
            .ctlr_zq_cal_config_dfs_2                             (CTLR_ZQ_CAL_CONFIG_DFS_2),
            .ecc_mode                                             (ECC_MODE),
            .scrambler_mode                                       (SCRAMBLER_MODE),
            .lp5_write_link_ecc                                   (LP5_WRITE_LINK_ECC),
            .axi_pipeline_cnt                                     (AXI_PIPELINE_CNT),
            .enable_fabric_port                                   (1'b1),
            .enable_noc_ports                                     (1'b0),
            .fabric_clocking_ratio                                (FABRIC_CLOCKING_RATIO),
            .fabric_port_width                                    (FABRIC_PORT_WIDTH),
            .lockstep_config                                      (LOCKSTEP_CONFIG),
            .mem_ac_scheme                                        (MEM_AC_SCHEME),
            .mem_databus_width                                    (MEM_DATABUS_WIDTH),
            .mem_dfs_profiles                                     (MEM_DFS_PROFILES),
            .mem_dfs_1_freq_mhz                                   (MEM_DFS_FREQ_MHZ[0]),
            .mem_dfs_2_freq_mhz                                   (MEM_DFS_FREQ_MHZ[1]),
            .mem_freq_hz                                          (MEM_FREQ_HZ),
            .mem_protocol                                         (MEM_PROTOCOL),
            .mem_topology                                         (MEM_TOPOLOGY),
            .param_table                                          (PARAM_TABLE)
         ) hmc (
            .i_dfi_init_complete_in           (i_dfi_init_complete_in),
            .i_fbr_axi_aclk                   (i_fbr_axi_aclk),
            .i_fbr_mc_clk_en                  (i_fbr_mc_clk_en),
            .i_mc_clk                         (i_mc_clk),
            .i_mc_clk_sync                    (i_mc_clk_sync),
            .i_mc_clk_en_in                   (i_mc_clk_en_in),
            .i_mc_rst_n                       (i_mc_rst_n),
            .i_regifhaddr                     (i_regifhaddr),
            .i_regifhburst                    (i_regifhburst),
            .i_regifhclk                      (i_regifhclk),
            .i_regifhready                    (i_regifhready),
            .i_regifhresetn                   (i_regifhresetn),
            .i_regifhselx                     (i_regifhselx),
            .i_regifhsize                     (i_regifhsize),
            .i_regifhtrans                    (i_regifhtrans),
            .i_regifhwdata                    (i_regifhwdata),
            .i_regifhwrite                    (i_regifhwrite),
            .o_dfi_init_complete_out          (o_dfi_init_complete_out),
            .o_mc_clk_en_out                  (o_mc_clk_en_out),
            .o_mc_irq                         (o_mc_irq),
            .o_regifhrdata                    (o_regifhrdata),
            .o_regifhreadyout                 (o_regifhreadyout),
            .o_regifhresp                     (o_regifhresp),
            .o_sim_param_table                (o_sim_param_table)
         );  
         
         assign internal_axi_intf.arready        = '0;
         assign internal_axi_intf.awready        = '0;
         assign internal_axi_intf.bid            = '0;
         assign internal_axi_intf.bresp          = '0;
         assign internal_axi_intf.bvalid         = '0;
         assign internal_axi_intf.rdata          = '0;
         assign internal_axi_intf.rid            = '0;
         assign internal_axi_intf.rlast          = '0;
         assign internal_axi_intf.rresp          = '0;
         assign internal_axi_intf.rvalid         = '0;
         assign internal_axi_intf.wready         = '0;
         assign o_noc_axi_aclk                   = '0;
         assign fanoc_hmc_axi_intf.arready       = '0;
         assign fanoc_hmc_axi_intf.awready       = '0;
         assign fanoc_hmc_axi_intf.bid           = '0;
         assign fanoc_hmc_axi_intf.bresp         = '0;
         assign fanoc_hmc_axi_intf.bvalid        = '0;
         assign fanoc_hmc_axi_intf.rdata         = '0;
         assign fanoc_hmc_axi_intf.rid           = '0;
         assign fanoc_hmc_axi_intf.rlast         = '0;
         assign fanoc_hmc_axi_intf.rresp         = '0;
         assign fanoc_hmc_axi_intf.ruser         = '0;
         assign fanoc_hmc_axi_intf.rvalid        = '0;
         assign fanoc_hmc_axi_intf.wready        = '0;
         assign o_phymux_phyadapt0_rd_rank       = '0;
         assign o_phymux_phyadapt0_rddata_en     = '0;
         assign o_phymux_phyadapt0_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt0_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt0_wr_rank       = '0;
         assign o_phymux_phyadapt0_wrdata        = '0;
         assign o_phymux_phyadapt0_wrdata_en     = '0;
         assign o_phymux_phyadapt1_rd_rank       = '0;
         assign o_phymux_phyadapt1_rddata_en     = '0;
         assign o_phymux_phyadapt1_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt1_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt1_wr_rank       = '0;
         assign o_phymux_phyadapt1_wrdata        = '0;
         assign o_phymux_phyadapt1_wrdata_en     = '0;
         assign o_phymux_phyadapt2_rd_rank       = '0;
         assign o_phymux_phyadapt2_rddata_en     = '0;
         assign o_phymux_phyadapt2_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt2_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt2_wr_rank       = '0;
         assign o_phymux_phyadapt2_wrdata        = '0;
         assign o_phymux_phyadapt2_wrdata_en     = '0;
         assign o_phymux_phyadapt3_rd_rank       = '0;
         assign o_phymux_phyadapt3_rddata_en     = '0;
         assign o_phymux_phyadapt3_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt3_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt3_wr_rank       = '0;
         assign o_phymux_phyadapt3_wrdata        = '0;
         assign o_phymux_phyadapt3_wrdata_en     = '0;
         assign o_phyadapt0_dram_clock_disable   = '0;
         assign o_phyadapt1_dram_clock_disable   = '0;
         assign o_phyadapt2_dram_clock_disable   = '0;
         assign o_phyadapt3_dram_clock_disable   = '0;
         assign o_phyadapt0_rxanalogen           = '0;
         assign o_phyadapt1_rxanalogen           = '0;
         assign o_phyadapt2_rxanalogen           = '0;
         assign o_phyadapt3_rxanalogen           = '0;
         assign o_phyadapt0_txanalogen           = '0;
         assign o_phyadapt1_txanalogen           = '0;
         assign o_phyadapt2_txanalogen           = '0;
         assign o_phyadapt3_txanalogen           = '0;
         
      end else if (IS_USED) begin : gen_tennm_wide 
         tennm_hmc # (
            .base_address                                         (BASE_ADDRESS),
            .ctlr_axi_bus_config                                  (CTLR_AXI_BUS_CONFIG),
            .ctlr_bist_config                                     (CTLR_BIST_CONFIG),
            .ctlr_calibration                                     (CTLR_CALIBRATION),
            .ctlr_calibration_dfs_1                               (CTLR_CALIBRATION_DFS_1),
            .ctlr_calibration_dfs_2                               (CTLR_CALIBRATION_DFS_2),
            .ctlr_datapath_ecc_config                             (CTLR_DATAPATH_ECC_CONFIG),
            .ctlr_datapath_ecc_config_dfs_1                       (CTLR_DATAPATH_ECC_CONFIG_DFS_1),
            .ctlr_datapath_ecc_config_dfs_2                       (CTLR_DATAPATH_ECC_CONFIG_DFS_2),
            .ctlr_dfi_config                                      (CTLR_DFI_CONFIG),
            .ctlr_dfi_config_dfs_1                                (CTLR_DFI_CONFIG_DFS_1),
            .ctlr_dfi_config_dfs_2                                (CTLR_DFI_CONFIG_DFS_2),
            .ctlr_dfi_low_power_config                            (CTLR_DFI_LOW_POWER_CONFIG),
            .ctlr_dfi_low_power_config_dfs_1                      (CTLR_DFI_LOW_POWER_CONFIG_DFS_1),
            .ctlr_dfi_low_power_config_dfs_2                      (CTLR_DFI_LOW_POWER_CONFIG_DFS_2),
            .ctlr_dfi_phy_master_config                           (CTLR_DFI_PHY_MASTER_CONFIG),
            .ctlr_dfs_config                                      (CTLR_DFS_CONFIG),
            .ctlr_dfs_config_dfs_1                                (CTLR_DFS_CONFIG_DFS_1),
            .ctlr_dfs_config_dfs_2                                (CTLR_DFS_CONFIG_DFS_2),
            .ctlr_ecc_scrub_config                                (CTLR_ECC_SCRUB_CONFIG),
            .ctlr_init_method                                     (CTLR_INIT_METHOD),
            .ctlr_interrupt_config                                (CTLR_INTERRUPT_CONFIG),
            .ctlr_low_power_config                                (CTLR_LOW_POWER_CONFIG),
            .ctlr_maintenance_task_config                         (CTLR_MAINTENANCE_TASK_CONFIG),
            .ctlr_maintenance_task_config_dfs_1                   (CTLR_MAINTENANCE_TASK_CONFIG_DFS_1),
            .ctlr_maintenance_task_config_dfs_2                   (CTLR_MAINTENANCE_TASK_CONFIG_DFS_2),
            .ctlr_mem_dynamic_timing_config                       (CTLR_MEM_DYNAMIC_TIMING_CONFIG),
            .ctlr_mem_dynamic_timing_config_dfs_1                 (CTLR_MEM_DYNAMIC_TIMING_CONFIG_DFS_1),
            .ctlr_mem_dynamic_timing_config_dfs_2                 (CTLR_MEM_DYNAMIC_TIMING_CONFIG_DFS_2),
            .ctlr_mem_host_board_config                           (CTLR_MEM_HOST_BOARD_CONFIG),
            .ctlr_mem_host_board_config_dfs_1                     (CTLR_MEM_HOST_BOARD_CONFIG_DFS_1),
            .ctlr_mem_host_board_config_dfs_2                     (CTLR_MEM_HOST_BOARD_CONFIG_DFS_2),
            .ctlr_mem_mode_register_config                        (CTLR_MEM_MODE_REGISTER_CONFIG),
            .ctlr_mem_mode_register_config_dfs_1                  (CTLR_MEM_MODE_REGISTER_CONFIG_DFS_1),
            .ctlr_mem_mode_register_config_dfs_2                  (CTLR_MEM_MODE_REGISTER_CONFIG_DFS_2),
            .ctlr_mem_physical_config                             (CTLR_MEM_PHYSICAL_CONFIG),
            .ctlr_mem_rdimm_config                                (CTLR_MEM_RDIMM_CONFIG),
            .ctlr_mem_rdimm_config_dfs_1                          (CTLR_MEM_RDIMM_CONFIG_DFS_1),
            .ctlr_mem_rdimm_config_dfs_2                          (CTLR_MEM_RDIMM_CONFIG_DFS_2),
            .ctlr_misc_config                                     (CTLR_MISC_CONFIG),
            .ctlr_performance_config                              (CTLR_PERFORMANCE_CONFIG),
            .ctlr_performance_config_dfs_1                        (CTLR_PERFORMANCE_CONFIG_DFS_1),
            .ctlr_performance_config_dfs_2                        (CTLR_PERFORMANCE_CONFIG_DFS_2),
            .ctlr_phy_physical_config                             (CTLR_PHY_PHYSICAL_CONFIG),
            .ctlr_ppr_config                                      (CTLR_PPR_CONFIG),
            .ctlr_refresh_config                                  (CTLR_REFRESH_CONFIG),
            .ctlr_sys_bus_timing_config                           (CTLR_SYS_BUS_TIMING_CONFIG),
            .ctlr_sys_bus_timing_config_dfs_1                     (CTLR_SYS_BUS_TIMING_CONFIG_DFS_1),
            .ctlr_sys_bus_timing_config_dfs_2                     (CTLR_SYS_BUS_TIMING_CONFIG_DFS_2),
            .ctlr_sys_odt_config                                  (CTLR_SYS_ODT_CONFIG),
            .ctlr_sys_odt_config_dfs_1                            (CTLR_SYS_ODT_CONFIG_DFS_1),
            .ctlr_sys_odt_config_dfs_2                            (CTLR_SYS_ODT_CONFIG_DFS_2),
            .ctlr_sys_phys_addr_config                            (CTLR_SYS_PHYS_ADDR_CONFIG),
            .ctlr_zq_cal_config                                   (CTLR_ZQ_CAL_CONFIG),
            .ctlr_zq_cal_config_dfs_1                             (CTLR_ZQ_CAL_CONFIG_DFS_1),
            .ctlr_zq_cal_config_dfs_2                             (CTLR_ZQ_CAL_CONFIG_DFS_2),
            .ecc_mode                                             (ECC_MODE),
            .scrambler_mode                                       (SCRAMBLER_MODE),
            .lp5_write_link_ecc                                   (LP5_WRITE_LINK_ECC),
            .axi_pipeline_cnt                                     (AXI_PIPELINE_CNT),
            .enable_fabric_port                                   (ENABLE_FABRIC_PORT),
            .enable_noc_ports                                     (ENABLE_NOC_PORTS),
            .fabric_clocking_ratio                                (FABRIC_CLOCKING_RATIO),
            .fabric_port_width                                    (FABRIC_PORT_WIDTH),
            .lockstep_config                                      (LOCKSTEP_CONFIG),
            .mem_ac_scheme                                        (MEM_AC_SCHEME),
            .mem_databus_width                                    (MEM_DATABUS_WIDTH),
            .mem_dfs_profiles                                     (MEM_DFS_PROFILES),
            .mem_dfs_1_freq_mhz                                   (MEM_DFS_FREQ_MHZ[0]),
            .mem_dfs_2_freq_mhz                                   (MEM_DFS_FREQ_MHZ[1]),
            .mem_freq_hz                                          (MEM_FREQ_HZ),
            .mem_protocol                                         (MEM_PROTOCOL),
            .mem_topology                                         (MEM_TOPOLOGY),
            .param_table                                          (PARAM_TABLE)
         ) hmc (
            .i_dfi_init_complete_in           (i_dfi_init_complete_in),
            .i_fbr_axi_aclk                   (i_fbr_axi_aclk),
            .i_fbr_axi_araddr                 (internal_axi_intf.araddr),
            .i_fbr_axi_arburst                (internal_axi_intf.arburst),
            .i_fbr_axi_arid                   (internal_axi_intf.arid),
            .i_fbr_axi_arlen                  (internal_axi_intf.arlen),
            .i_fbr_axi_arlock                 (internal_axi_intf.arlock),
            .i_fbr_axi_arqos                  (internal_axi_intf.arqos),
            .i_fbr_axi_arsize                 (internal_axi_intf.arsize),
            .i_fbr_axi_aruser                 (internal_axi_intf.aruser),
            .i_fbr_axi_arvalid                (internal_axi_intf.arvalid),
            .i_fbr_axi_awaddr                 (internal_axi_intf.awaddr),
            .i_fbr_axi_awburst                (internal_axi_intf.awburst),
            .i_fbr_axi_awid                   (internal_axi_intf.awid),
            .i_fbr_axi_awlen                  (internal_axi_intf.awlen),
            .i_fbr_axi_awlock                 (internal_axi_intf.awlock),
            .i_fbr_axi_awqos                  (internal_axi_intf.awqos),
            .i_fbr_axi_awsize                 (internal_axi_intf.awsize),
            .i_fbr_axi_awuser                 (internal_axi_intf.awuser),
            .i_fbr_axi_awvalid                (internal_axi_intf.awvalid),
            .i_fbr_axi_bready                 (internal_axi_intf.bready),
            .i_fbr_axi_rready                 (internal_axi_intf.rready),
            .i_fbr_axi_wdata                  (internal_axi_intf.wdata),
            .i_fbr_axi_wlast                  (internal_axi_intf.wlast),
            .i_fbr_axi_wstrb                  (internal_axi_intf.wstrb),
            .i_fbr_axi_wvalid                 (internal_axi_intf.wvalid),
            .i_fbr_dfi_init_complete          (i_fbr_dfi_init_complete),
            .i_fbr_mc_clk_en                  (i_fbr_mc_clk_en),
            .i_mc_clk                         (i_mc_clk),
            .i_mc_clk_sync                    (i_mc_clk_sync),
            .i_mc_clk_en_in                   (i_mc_clk_en_in),
            .i_mc_rst_n                       (i_mc_rst_n),
            .i_noc_axi_araddr                 (fanoc_hmc_axi_intf.araddr),
            .i_noc_axi_arburst                (fanoc_hmc_axi_intf.arburst),
            .i_noc_axi_arid                   (fanoc_hmc_axi_intf.arid),
            .i_noc_axi_arlen                  (fanoc_hmc_axi_intf.arlen),
            .i_noc_axi_arlock                 (fanoc_hmc_axi_intf.arlock),
            .i_noc_axi_arqos                  (fanoc_hmc_axi_intf.arqos),
            .i_noc_axi_arsize                 (fanoc_hmc_axi_intf.arsize),
            .i_noc_axi_aruser                 (fanoc_hmc_axi_intf.aruser),
            .i_noc_axi_arvalid                (fanoc_hmc_axi_intf.arvalid),
            .i_noc_axi_awaddr                 (fanoc_hmc_axi_intf.awaddr),
            .i_noc_axi_awburst                (fanoc_hmc_axi_intf.awburst),
            .i_noc_axi_awid                   (fanoc_hmc_axi_intf.awid),
            .i_noc_axi_awlen                  (fanoc_hmc_axi_intf.awlen),
            .i_noc_axi_awlock                 (fanoc_hmc_axi_intf.awlock),
            .i_noc_axi_awqos                  (fanoc_hmc_axi_intf.awqos),
            .i_noc_axi_awsize                 (fanoc_hmc_axi_intf.awsize),
            .i_noc_axi_awuser                 (fanoc_hmc_axi_intf.awuser),
            .i_noc_axi_awvalid                (fanoc_hmc_axi_intf.awvalid),
            .i_noc_axi_bready                 (fanoc_hmc_axi_intf.bready),
            .i_noc_axi_rready                 (fanoc_hmc_axi_intf.rready),
            .i_noc_axi_wdata                  (fanoc_hmc_axi_intf.wdata),
            .i_noc_axi_wlast                  (fanoc_hmc_axi_intf.wlast),
            .i_noc_axi_wstrb                  (fanoc_hmc_axi_intf.wstrb),
            .i_noc_axi_wuser                  (fanoc_hmc_axi_intf.wuser[31:0]),
            .i_noc_axi_wvalid                 (fanoc_hmc_axi_intf.wvalid),
            .i_phymux_phyadapt0_rddata        (i_phymux_phyadapt0_rddata),
            .i_phymux_phyadapt0_rddata_valid  (i_phymux_phyadapt0_rddata_valid),
            .i_phymux_phyadapt1_rddata        (i_phymux_phyadapt1_rddata),
            .i_phymux_phyadapt1_rddata_valid  (i_phymux_phyadapt1_rddata_valid),
            .i_phymux_phyadapt2_rddata        (i_phymux_phyadapt2_rddata),
            .i_phymux_phyadapt2_rddata_valid  (i_phymux_phyadapt2_rddata_valid),
            .i_phymux_phyadapt3_rddata        (i_phymux_phyadapt3_rddata),
            .i_phymux_phyadapt3_rddata_valid  (i_phymux_phyadapt3_rddata_valid),
            .i_phymux_phyadapt4_rddata        (i_phymux_phyadapt4_rddata),
            .i_phymux_phyadapt4_rddata_valid  (i_phymux_phyadapt4_rddata_valid),
            .i_phymux_phyadapt5_rddata        (i_phymux_phyadapt5_rddata),
            .i_phymux_phyadapt5_rddata_valid  (i_phymux_phyadapt5_rddata_valid),
            .i_phymux_phyadapt6_rddata        (i_phymux_phyadapt6_rddata),
            .i_phymux_phyadapt6_rddata_valid  (i_phymux_phyadapt6_rddata_valid),
            .i_phymux_phyadapt7_rddata        (i_phymux_phyadapt7_rddata),
            .i_phymux_phyadapt7_rddata_valid  (i_phymux_phyadapt7_rddata_valid),
            .i_regifhaddr                     (i_regifhaddr),
            .i_regifhburst                    (i_regifhburst),
            .i_regifhclk                      (i_regifhclk),
            .i_regifhready                    (i_regifhready),
            .i_regifhresetn                   (i_regifhresetn),
            .i_regifhselx                     (i_regifhselx),
            .i_regifhsize                     (i_regifhsize),
            .i_regifhtrans                    (i_regifhtrans),
            .i_regifhwdata                    (i_regifhwdata),
            .i_regifhwrite                    (i_regifhwrite),
            .o_dfi_init_complete_out          (o_dfi_init_complete_out),
            .o_fbr_axi_arready                (internal_axi_intf.arready),
            .o_fbr_axi_awready                (internal_axi_intf.awready),
            .o_fbr_axi_bid                    (internal_axi_intf.bid),
            .o_fbr_axi_bresp                  (internal_axi_intf.bresp),
            .o_fbr_axi_bvalid                 (internal_axi_intf.bvalid),
            .o_fbr_axi_rdata                  (internal_axi_intf.rdata),
            .o_fbr_axi_rid                    (internal_axi_intf.rid),
            .o_fbr_axi_rlast                  (internal_axi_intf.rlast),
            .o_fbr_axi_rresp                  (internal_axi_intf.rresp),
            .o_fbr_axi_rvalid                 (internal_axi_intf.rvalid),
            .o_fbr_axi_wready                 (internal_axi_intf.wready),
            .o_mc_clk_en_out                  (o_mc_clk_en_out),
            .o_mc_irq                         (o_mc_irq),
            .o_noc_axi_aclk                   (o_noc_axi_aclk),
            .o_noc_axi_arready                (fanoc_hmc_axi_intf.arready),
            .o_noc_axi_awready                (fanoc_hmc_axi_intf.awready),
            .o_noc_axi_bid                    (fanoc_hmc_axi_intf.bid),
            .o_noc_axi_bresp                  (fanoc_hmc_axi_intf.bresp),
            .o_noc_axi_bvalid                 (fanoc_hmc_axi_intf.bvalid),
            .o_noc_axi_rdata                  (fanoc_hmc_axi_intf.rdata),
            .o_noc_axi_rid                    (fanoc_hmc_axi_intf.rid),
            .o_noc_axi_rlast                  (fanoc_hmc_axi_intf.rlast),
            .o_noc_axi_rresp                  (fanoc_hmc_axi_intf.rresp),
            .o_noc_axi_ruser                  (fanoc_hmc_axi_intf.ruser[31:0]),
            .o_noc_axi_rvalid                 (fanoc_hmc_axi_intf.rvalid),
            .o_noc_axi_wready                 (fanoc_hmc_axi_intf.wready),
            .o_phymux_phyadapt0_rd_rank       (o_phymux_phyadapt0_rd_rank),
            .o_phymux_phyadapt0_rddata_en     (o_phymux_phyadapt0_rddata_en),
            .o_phymux_phyadapt0_wr_dqs0_en    (o_phymux_phyadapt0_wr_dqs0_en),
            .o_phymux_phyadapt0_wr_dqs1_en    (o_phymux_phyadapt0_wr_dqs1_en),
            .o_phymux_phyadapt0_wr_rank       (o_phymux_phyadapt0_wr_rank),
            .o_phymux_phyadapt0_wrdata        (o_phymux_phyadapt0_wrdata),
            .o_phymux_phyadapt0_wrdata_en     (o_phymux_phyadapt0_wrdata_en),
            .o_phymux_phyadapt1_rd_rank       (o_phymux_phyadapt1_rd_rank),
            .o_phymux_phyadapt1_rddata_en     (o_phymux_phyadapt1_rddata_en),
            .o_phymux_phyadapt1_wr_dqs0_en    (o_phymux_phyadapt1_wr_dqs0_en),
            .o_phymux_phyadapt1_wr_dqs1_en    (o_phymux_phyadapt1_wr_dqs1_en),
            .o_phymux_phyadapt1_wr_rank       (o_phymux_phyadapt1_wr_rank),
            .o_phymux_phyadapt1_wrdata        (o_phymux_phyadapt1_wrdata),
            .o_phymux_phyadapt1_wrdata_en     (o_phymux_phyadapt1_wrdata_en),
            .o_phymux_phyadapt2_rd_rank       (o_phymux_phyadapt2_rd_rank),
            .o_phymux_phyadapt2_rddata_en     (o_phymux_phyadapt2_rddata_en),
            .o_phymux_phyadapt2_wr_dqs0_en    (o_phymux_phyadapt2_wr_dqs0_en),
            .o_phymux_phyadapt2_wr_dqs1_en    (o_phymux_phyadapt2_wr_dqs1_en),
            .o_phymux_phyadapt2_wr_rank       (o_phymux_phyadapt2_wr_rank),
            .o_phymux_phyadapt2_wrdata        (o_phymux_phyadapt2_wrdata),
            .o_phymux_phyadapt2_wrdata_en     (o_phymux_phyadapt2_wrdata_en),
            .o_phymux_phyadapt3_rd_rank       (o_phymux_phyadapt3_rd_rank),
            .o_phymux_phyadapt3_rddata_en     (o_phymux_phyadapt3_rddata_en),
            .o_phymux_phyadapt3_wr_dqs0_en    (o_phymux_phyadapt3_wr_dqs0_en),
            .o_phymux_phyadapt3_wr_dqs1_en    (o_phymux_phyadapt3_wr_dqs1_en),
            .o_phymux_phyadapt3_wr_rank       (o_phymux_phyadapt3_wr_rank),
            .o_phymux_phyadapt3_wrdata        (o_phymux_phyadapt3_wrdata),
            .o_phymux_phyadapt3_wrdata_en     (o_phymux_phyadapt3_wrdata_en),
            .o_phymux_phyadapt4_rd_rank       (o_phymux_phyadapt4_rd_rank),
            .o_phymux_phyadapt4_rddata_en     (o_phymux_phyadapt4_rddata_en),
            .o_phymux_phyadapt4_wr_dqs0_en    (o_phymux_phyadapt4_wr_dqs0_en),
            .o_phymux_phyadapt4_wr_dqs1_en    (o_phymux_phyadapt4_wr_dqs1_en),
            .o_phymux_phyadapt4_wr_rank       (o_phymux_phyadapt4_wr_rank),
            .o_phymux_phyadapt4_wrdata        (o_phymux_phyadapt4_wrdata),
            .o_phymux_phyadapt4_wrdata_en     (o_phymux_phyadapt4_wrdata_en),
            .o_phymux_phyadapt5_rd_rank       (o_phymux_phyadapt5_rd_rank),
            .o_phymux_phyadapt5_rddata_en     (o_phymux_phyadapt5_rddata_en),
            .o_phymux_phyadapt5_wr_dqs0_en    (o_phymux_phyadapt5_wr_dqs0_en),
            .o_phymux_phyadapt5_wr_dqs1_en    (o_phymux_phyadapt5_wr_dqs1_en),
            .o_phymux_phyadapt5_wr_rank       (o_phymux_phyadapt5_wr_rank),
            .o_phymux_phyadapt5_wrdata        (o_phymux_phyadapt5_wrdata),
            .o_phymux_phyadapt5_wrdata_en     (o_phymux_phyadapt5_wrdata_en),
            .o_phymux_phyadapt6_rd_rank       (o_phymux_phyadapt6_rd_rank),
            .o_phymux_phyadapt6_rddata_en     (o_phymux_phyadapt6_rddata_en),
            .o_phymux_phyadapt6_wr_dqs0_en    (o_phymux_phyadapt6_wr_dqs0_en),
            .o_phymux_phyadapt6_wr_dqs1_en    (o_phymux_phyadapt6_wr_dqs1_en),
            .o_phymux_phyadapt6_wr_rank       (o_phymux_phyadapt6_wr_rank),
            .o_phymux_phyadapt6_wrdata        (o_phymux_phyadapt6_wrdata),
            .o_phymux_phyadapt6_wrdata_en     (o_phymux_phyadapt6_wrdata_en),
            .o_phymux_phyadapt7_rd_rank       (o_phymux_phyadapt7_rd_rank),
            .o_phymux_phyadapt7_rddata_en     (o_phymux_phyadapt7_rddata_en),
            .o_phymux_phyadapt7_wr_dqs0_en    (o_phymux_phyadapt7_wr_dqs0_en),
            .o_phymux_phyadapt7_wr_dqs1_en    (o_phymux_phyadapt7_wr_dqs1_en),
            .o_phymux_phyadapt7_wr_rank       (o_phymux_phyadapt7_wr_rank),
            .o_phymux_phyadapt7_wrdata        (o_phymux_phyadapt7_wrdata),
            .o_phymux_phyadapt7_wrdata_en     (o_phymux_phyadapt7_wrdata_en),
            .o_phyadapt0_dram_clock_disable   (o_phyadapt0_dram_clock_disable),
            .o_phyadapt1_dram_clock_disable   (o_phyadapt1_dram_clock_disable),
            .o_phyadapt2_dram_clock_disable   (o_phyadapt2_dram_clock_disable),
            .o_phyadapt3_dram_clock_disable   (o_phyadapt3_dram_clock_disable),
            .o_phyadapt4_dram_clock_disable   (o_phyadapt4_dram_clock_disable),
            .o_phyadapt5_dram_clock_disable   (o_phyadapt5_dram_clock_disable),
            .o_phyadapt6_dram_clock_disable   (o_phyadapt6_dram_clock_disable),            
            .o_phyadapt7_dram_clock_disable   (o_phyadapt7_dram_clock_disable),
            .o_phyadapt0_rxanalogen           (o_phyadapt0_rxanalogen),
            .o_phyadapt1_rxanalogen           (o_phyadapt1_rxanalogen),
            .o_phyadapt2_rxanalogen           (o_phyadapt2_rxanalogen),
            .o_phyadapt3_rxanalogen           (o_phyadapt3_rxanalogen),
            .o_phyadapt4_rxanalogen           (o_phyadapt4_rxanalogen),
            .o_phyadapt5_rxanalogen           (o_phyadapt5_rxanalogen),
            .o_phyadapt6_rxanalogen           (o_phyadapt6_rxanalogen),
            .o_phyadapt7_rxanalogen           (o_phyadapt7_rxanalogen),
            .o_phyadapt0_txanalogen           (o_phyadapt0_txanalogen),
            .o_phyadapt1_txanalogen           (o_phyadapt1_txanalogen),
            .o_phyadapt2_txanalogen           (o_phyadapt2_txanalogen),
            .o_phyadapt3_txanalogen           (o_phyadapt3_txanalogen),
            .o_phyadapt4_txanalogen           (o_phyadapt4_txanalogen),
            .o_phyadapt5_txanalogen           (o_phyadapt5_txanalogen),
            .o_phyadapt6_txanalogen           (o_phyadapt6_txanalogen),
            .o_phyadapt7_txanalogen           (o_phyadapt7_txanalogen),
            .o_regifhrdata                    (o_regifhrdata),
            .o_regifhreadyout                 (o_regifhreadyout),
            .o_regifhresp                     (o_regifhresp),
            .o_sim_param_table                (o_sim_param_table)
         );
     
        if(ENABLE_NOC_PORTS==0) begin: tie_off_noc
            assign fanoc_hmc_axi_intf.ruser[63:32]  = '0;
        end

      end else begin : gen_hmc_tieoff
         assign o_dfi_init_complete_out          = '0;
         assign internal_axi_intf.arready        = '0;
         assign internal_axi_intf.awready        = '0;
         assign internal_axi_intf.bid            = '0;
         assign internal_axi_intf.bresp          = '0;
         assign internal_axi_intf.bvalid         = '0;
         assign internal_axi_intf.rdata          = '0;
         assign internal_axi_intf.rid            = '0;
         assign internal_axi_intf.rlast          = '0;
         assign internal_axi_intf.rresp          = '0;
         assign internal_axi_intf.rvalid         = '0;
         assign internal_axi_intf.wready         = '0;
         assign o_mc_clk_en_out                  = '1;
         assign o_mc_irq                         = '0;
         assign o_noc_axi_aclk                   = '0;
         assign fanoc_hmc_axi_intf.arready       = '0;
         assign fanoc_hmc_axi_intf.awready       = '0;
         assign fanoc_hmc_axi_intf.bid           = '0;
         assign fanoc_hmc_axi_intf.bresp         = '0;
         assign fanoc_hmc_axi_intf.bvalid        = '0;
         assign fanoc_hmc_axi_intf.rdata         = '0;
         assign fanoc_hmc_axi_intf.rid           = '0;
         assign fanoc_hmc_axi_intf.rlast         = '0;
         assign fanoc_hmc_axi_intf.rresp         = '0;
         assign fanoc_hmc_axi_intf.ruser         = '0;
         assign fanoc_hmc_axi_intf.rvalid        = '0;
         assign fanoc_hmc_axi_intf.wready        = '0;
         assign o_phymux_phyadapt0_rd_rank       = '0;
         assign o_phymux_phyadapt0_rddata_en     = '0;
         assign o_phymux_phyadapt0_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt0_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt0_wr_rank       = '0;
         assign o_phymux_phyadapt0_wrdata        = '0;
         assign o_phymux_phyadapt0_wrdata_en     = '0;
         assign o_phymux_phyadapt1_rd_rank       = '0;
         assign o_phymux_phyadapt1_rddata_en     = '0;
         assign o_phymux_phyadapt1_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt1_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt1_wr_rank       = '0;
         assign o_phymux_phyadapt1_wrdata        = '0;
         assign o_phymux_phyadapt1_wrdata_en     = '0;
         assign o_phymux_phyadapt2_rd_rank       = '0;
         assign o_phymux_phyadapt2_rddata_en     = '0;
         assign o_phymux_phyadapt2_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt2_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt2_wr_rank       = '0;
         assign o_phymux_phyadapt2_wrdata        = '0;
         assign o_phymux_phyadapt2_wrdata_en     = '0;
         assign o_phymux_phyadapt3_rd_rank       = '0;
         assign o_phymux_phyadapt3_rddata_en     = '0;
         assign o_phymux_phyadapt3_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt3_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt3_wr_rank       = '0;
         assign o_phymux_phyadapt3_wrdata        = '0;
         assign o_phymux_phyadapt3_wrdata_en     = '0;
         assign o_phymux_phyadapt4_rd_rank       = '0;
         assign o_phymux_phyadapt4_rddata_en     = '0;
         assign o_phymux_phyadapt4_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt4_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt4_wr_rank       = '0;
         assign o_phymux_phyadapt4_wrdata        = '0;
         assign o_phymux_phyadapt4_wrdata_en     = '0;
         assign o_phymux_phyadapt5_rd_rank       = '0;
         assign o_phymux_phyadapt5_rddata_en     = '0;
         assign o_phymux_phyadapt5_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt5_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt5_wr_rank       = '0;
         assign o_phymux_phyadapt5_wrdata        = '0;
         assign o_phymux_phyadapt5_wrdata_en     = '0;
         assign o_phymux_phyadapt6_rd_rank       = '0;
         assign o_phymux_phyadapt6_rddata_en     = '0;
         assign o_phymux_phyadapt6_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt6_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt6_wr_rank       = '0;
         assign o_phymux_phyadapt6_wrdata        = '0;
         assign o_phymux_phyadapt6_wrdata_en     = '0;
         assign o_phymux_phyadapt7_rd_rank       = '0;
         assign o_phymux_phyadapt7_rddata_en     = '0;
         assign o_phymux_phyadapt7_wr_dqs0_en    = '0;
         assign o_phymux_phyadapt7_wr_dqs1_en    = '0;
         assign o_phymux_phyadapt7_wr_rank       = '0;
         assign o_phymux_phyadapt7_wrdata        = '0;
         assign o_phymux_phyadapt7_wrdata_en     = '0;
         assign o_phyadapt0_dram_clock_disable   = '0;
         assign o_phyadapt1_dram_clock_disable   = '0;
         assign o_phyadapt2_dram_clock_disable   = '0;
         assign o_phyadapt3_dram_clock_disable   = '0;
         assign o_phyadapt4_dram_clock_disable   = '0;
         assign o_phyadapt5_dram_clock_disable   = '0;
         assign o_phyadapt6_dram_clock_disable   = '0;
         assign o_phyadapt7_dram_clock_disable   = '0;
         assign o_phyadapt0_rxanalogen           = '0;
         assign o_phyadapt1_rxanalogen           = '0;
         assign o_phyadapt2_rxanalogen           = '0;
         assign o_phyadapt3_rxanalogen           = '0;
         assign o_phyadapt4_rxanalogen           = '0;
         assign o_phyadapt5_rxanalogen           = '0;
         assign o_phyadapt6_rxanalogen           = '0;
         assign o_phyadapt7_rxanalogen           = '0;
         assign o_phyadapt0_txanalogen           = '0;
         assign o_phyadapt1_txanalogen           = '0;
         assign o_phyadapt2_txanalogen           = '0;
         assign o_phyadapt3_txanalogen           = '0;
         assign o_phyadapt4_txanalogen           = '0;
         assign o_phyadapt5_txanalogen           = '0;
         assign o_phyadapt6_txanalogen           = '0;
         assign o_phyadapt7_txanalogen           = '0;
         assign o_regifhrdata                    = '0;
         assign o_regifhreadyout                 = '1;
         assign o_regifhresp                     = '0;
         assign o_sim_param_table                = '0;
      end
   endgenerate

   assign fanoc_hmc_axi_intf.buser          = '0;


endmodule


