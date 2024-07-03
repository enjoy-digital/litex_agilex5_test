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



module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_pa #(

   parameter ID                               = 0,

   localparam PORT_PHY_GPIO_D_WIDTH            = 12,
   localparam PORT_PHY_DATA_WIDTH              = 48,
   localparam PORT_PHY_RDDATA_VALID_WIDTH      = 2,
   localparam PORT_PHY_RANK_WIDTH              = 4,
   localparam PORT_PHY_DATA_EN_WIDTH           = 2,
   localparam PORT_PHY_WR_DQS_EN_WIDTH         = 2,
   localparam PORT_PHY_SUPPRESSION_WIDTH       = 12,

   localparam PORT_HMC_DATA_WIDTH              = 96,
   localparam PORT_HMC_RDDATA_VALID_WIDTH      = 4,
   localparam PORT_HMC_RANK_WIDTH              = 8,
   localparam PORT_HMC_DATA_EN_WIDTH           = 4,
   localparam PORT_HMC_WR_DQS_EN_WIDTH         = 4,

   localparam PORT_FA_GPIO_D_WIDTH             = 5,
   localparam PORT_FA_DATA_WIDTH               = 96,
   localparam PORT_FA_RDDATA_VALID_WIDTH       = 4,
   localparam PORT_FA_RANK_WIDTH               = 4,
   localparam PORT_FA_DATA_EN_WIDTH            = 4,
   localparam PORT_FA_WR_DQS_EN_WIDTH          = 4,
   localparam PORT_FA_MIPI_LP_DOUT_WIDTH       = 10,

   localparam PORT_SEQ_DATA_WIDTH              = 96,
   localparam PORT_SEQ_RANK_WIDTH              = 8,
   localparam PORT_SEQ_DATA_EN_WIDTH           = 4,
   localparam PORT_SEQ_WR_DQS_EN_WIDTH         = 4,
   localparam PORT_SEQ_SUPPRESSION_WIDTH       = 12,
   localparam PORT_RB_SEQ_SEQ_BASE_ADDR_WIDTH  = 11,

   localparam INTF_BC_TO_PA_WIDTH          = 2*PORT_PHY_RDDATA_VALID_WIDTH,
   localparam INTF_PA_TO_BC_WIDTH          = 2*PORT_PHY_RANK_WIDTH +
                                             2*PORT_PHY_DATA_EN_WIDTH +
                                             2*PORT_PHY_WR_DQS_EN_WIDTH +
                                             PORT_PHY_SUPPRESSION_WIDTH +
                                             2, 
   localparam INTF_PLL_TO_PA_WIDTH         = 2,
   localparam INTF_SEQ_TO_PA_WIDTH         = 2*PORT_SEQ_RANK_WIDTH +
                                             2*PORT_SEQ_DATA_EN_WIDTH +
                                             PORT_SEQ_SUPPRESSION_WIDTH +
                                             PORT_SEQ_WR_DQS_EN_WIDTH +
                                             PORT_SEQ_DATA_WIDTH +
                                             1,
   localparam INTF_PA_TO_SEQ_WIDTH  = PORT_HMC_DATA_WIDTH +
                                      PORT_HMC_RDDATA_VALID_WIDTH +
                                             4 + 
                                             PORT_RB_SEQ_SEQ_BASE_ADDR_WIDTH,
   localparam INTF_FALANE_TO_PA_ONE_WIDTH  = 2*PORT_FA_RANK_WIDTH +
                                             2*PORT_FA_DATA_EN_WIDTH +
                                             PORT_FA_WR_DQS_EN_WIDTH +
                                             PORT_FA_DATA_WIDTH,
   localparam INTF_FALANE_TO_PA_WIDTH      = INTF_FALANE_TO_PA_ONE_WIDTH,
   localparam INTF_PA_TO_FALANE_WIDTH      = PORT_FA_DATA_WIDTH +
                                             PORT_FA_RDDATA_VALID_WIDTH +
                                             1,
   localparam INTF_HMC_TO_PA_WIDTH         = 2*PORT_HMC_RANK_WIDTH +
                                             2*PORT_HMC_DATA_EN_WIDTH +
                                             2*PORT_HMC_WR_DQS_EN_WIDTH +
                                             PORT_HMC_DATA_WIDTH
                                             + 3, 
   localparam INTF_PA_TO_HMC_WIDTH         = PORT_HMC_DATA_WIDTH + PORT_HMC_RDDATA_VALID_WIDTH,
   localparam INTF_BUFFS_TO_PA_WIDTH       = 12,
   localparam INTF_B_TO_PA_WIDTH           = PORT_PHY_DATA_WIDTH+1,
   localparam INTF_PA_TO_B_WIDTH           = PORT_PHY_DATA_WIDTH
                                             +1 
) (
   input  logic [INTF_BC_TO_PA_WIDTH-1:0]          bc_to_pa,
   output logic [INTF_PA_TO_BC_WIDTH-1:0]          pa_to_bc,

   input  logic [INTF_BUFFS_TO_PA_WIDTH-1:0]       buffs_to_pa,

   input  logic [INTF_B_TO_PA_WIDTH-1:0]           b_to_pa,
   output logic [INTF_PA_TO_B_WIDTH-1:0]           pa_to_b,

   input  logic [INTF_HMC_TO_PA_WIDTH-1:0]         hmc_to_pa,
   output logic [INTF_PA_TO_HMC_WIDTH-1:0]         pa_to_hmc,

   input  logic [INTF_FALANE_TO_PA_WIDTH-1:0]      falane_to_pa,
   output logic [INTF_PA_TO_FALANE_WIDTH-1:0]      pa_to_falane,

   input  logic [INTF_SEQ_TO_PA_WIDTH-1:0]         seq_to_pa,
   output logic [INTF_PA_TO_SEQ_WIDTH-1:0]         pa_to_seq,

   input  logic [INTF_PLL_TO_PA_WIDTH-1:0]         pll_to_pa

);
   timeunit 1ns;
   timeprecision 1ps;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_pa::*;

   logic    [PORT_PHY_RDDATA_VALID_WIDTH-1:0]           i_phy2pa_rddata_valid_lower;
   logic    [PORT_PHY_RDDATA_VALID_WIDTH-1:0]           i_phy2pa_rddata_valid_upper;
   logic                                                i_rxfwd_clk;
   logic    [PORT_PHY_RANK_WIDTH-1:0]                   o_pa2phy_rd_rank;
   logic    [PORT_PHY_DATA_EN_WIDTH-1:0]                o_pa2phy_rddata_en;
   logic    [PORT_PHY_WR_DQS_EN_WIDTH-1:0]              o_pa2phy_wr_dqs0_en;
   logic    [PORT_PHY_WR_DQS_EN_WIDTH-1:0]              o_pa2phy_wr_dqs1_en;
   logic    [PORT_PHY_RANK_WIDTH-1:0]                   o_pa2phy_wr_rank;
   logic    [PORT_PHY_DATA_EN_WIDTH-1:0]                o_pa2phy_wrdata_en;
   logic    [PORT_PHY_SUPPRESSION_WIDTH-1:0]            o_pa2phy_suppression;
   logic                                                o_pa2phy_rxanalogen;
   logic                                                o_pa2phy_txanalogen;

   logic    [PORT_PHY_DATA_WIDTH-1:0]                   i_phy2pa_rddata;
   logic    [PORT_PHY_GPIO_D_WIDTH-1:0]                 i_alert_gpio_din;
   logic    [PORT_PHY_DATA_WIDTH-1:0]                   o_pa2phy_wrdata;
   logic    [PORT_PHY_GPIO_D_WIDTH-1:0]                 o_pa2phy_gpio_dout_sel;

   logic    [PORT_HMC_RANK_WIDTH-1:0]                   i_hmc2pa_rd_rank;
   logic    [PORT_HMC_DATA_EN_WIDTH-1:0]                i_hmc2pa_rddata_en;
   logic    [PORT_HMC_WR_DQS_EN_WIDTH-1:0]              i_hmc2pa_wr_dqs0_en;
   logic    [PORT_HMC_WR_DQS_EN_WIDTH-1:0]              i_hmc2pa_wr_dqs1_en;
   logic    [PORT_HMC_RANK_WIDTH-1:0]                   i_hmc2pa_wr_rank;
   logic    [PORT_HMC_DATA_WIDTH-1:0]                   i_hmc2pa_wrdata;
   logic    [PORT_HMC_DATA_EN_WIDTH-1:0]                i_hmc2pa_wrdata_en;
   logic                                                i_hmc2pa_rxanalogen;
   logic                                                i_hmc2pa_txanalogen;
   logic    [PORT_HMC_DATA_WIDTH-1:0]                   o_pa2hmc_rddata;
   logic    [PORT_HMC_RDDATA_VALID_WIDTH-1:0]           o_pa2hmc_rddata_valid;

   logic    [PORT_FA_GPIO_D_WIDTH-1:0]                  i_fa2pa_gpio_dout_sel;
   logic    [PORT_FA_RANK_WIDTH-1:0]                    i_fa2pa_rd_rank;
   logic    [PORT_FA_DATA_EN_WIDTH-1:0]                 i_fa2pa_rddata_en;
   logic    [PORT_FA_WR_DQS_EN_WIDTH-1:0]               i_fa2pa_wr_dqs_en;
   logic    [PORT_FA_RANK_WIDTH-1:0]                    i_fa2pa_wr_rank;
   logic    [PORT_FA_DATA_WIDTH-1:0]                    i_fa2pa_wrdata;
   logic    [PORT_FA_DATA_EN_WIDTH-1:0]                 i_fa2pa_wrdata_en;
   logic    [PORT_FA_MIPI_LP_DOUT_WIDTH-1:0]            i_fa2pa_mipi_lp_dout;
   logic    [PORT_FA_DATA_WIDTH-1:0]                    o_pa2fa_rddata;
   logic    [PORT_FA_RDDATA_VALID_WIDTH-1:0]            o_pa2fa_rddata_valid;
   logic                                                o_rxfwd_clk;
   logic    [PORT_FA_MIPI_LP_DOUT_WIDTH-1:0]            o_mipi_lp_dout;

   logic    [PORT_SEQ_RANK_WIDTH-1:0]                   i_seq2pa_rd_rank;
   logic    [PORT_SEQ_DATA_EN_WIDTH-1:0]                i_seq2pa_rddata_en;
   logic                                                i_seq2pa_seq_en;
   logic    [PORT_SEQ_SUPPRESSION_WIDTH-1:0]            i_seq2pa_suppression;
   logic    [PORT_SEQ_WR_DQS_EN_WIDTH-1:0]              i_seq2pa_wr_dqs_en;
   logic    [PORT_SEQ_RANK_WIDTH-1:0]                   i_seq2pa_wr_rank;
   logic    [PORT_SEQ_DATA_WIDTH-1:0]                   i_seq2pa_wrdata;
   logic    [PORT_SEQ_DATA_EN_WIDTH-1:0]                i_seq2pa_wrdata_en;
   logic                                                o_rb_pa2seq_ddr_lane_mode;
   logic                                                o_rb_pa2seq_if_sel;
   logic                                                o_rb_pa2seq_phy_clk_en;
   logic                                                o_rb_pa2seq_rate_conv_en;
   logic    [PORT_RB_SEQ_SEQ_BASE_ADDR_WIDTH-1:0]       o_rb_pa2seq_seq_base_addr;

   logic                                                i_ctr2pa_dram_clock_disable;
   logic                                                o_pa2phy_dram_clock_disable;

   logic                                                i_phy_clk_hr;
   logic                                                i_phyclk_sync;

   // Assign Wires to Interfaces

   assign {i_phy_clk_hr, i_phyclk_sync} = pll_to_pa;

   assign {i_seq2pa_seq_en,
           i_seq2pa_wrdata,
           i_seq2pa_wrdata_en,
           i_seq2pa_wr_dqs_en,
           i_seq2pa_rddata_en,
           i_seq2pa_wr_rank,
           i_seq2pa_rd_rank,
           i_seq2pa_suppression} = seq_to_pa;
   assign pa_to_seq = {o_pa2hmc_rddata,
                       o_pa2hmc_rddata_valid,
                       o_rb_pa2seq_if_sel,
                       o_rb_pa2seq_phy_clk_en,
                       o_rb_pa2seq_rate_conv_en,
                       o_rb_pa2seq_ddr_lane_mode,
                       o_rb_pa2seq_seq_base_addr};

   logic [INTF_FALANE_TO_PA_ONE_WIDTH-1:0] nc_falane_to_pa;
   assign {
           i_fa2pa_wrdata_en,
           i_fa2pa_wr_dqs_en,
           i_fa2pa_rddata_en,
           i_fa2pa_wr_rank,
           i_fa2pa_rd_rank,
           i_fa2pa_wrdata} = falane_to_pa;

   assign pa_to_falane = {o_pa2fa_rddata_valid, o_pa2fa_rddata, o_rxfwd_clk};

   assign {i_hmc2pa_rd_rank,
           i_hmc2pa_rddata_en,
           i_hmc2pa_wr_dqs0_en,
           i_hmc2pa_wr_dqs1_en,
           i_hmc2pa_wr_rank,
           i_hmc2pa_wrdata,
           i_hmc2pa_wrdata_en,
           i_ctr2pa_dram_clock_disable,
           i_hmc2pa_rxanalogen,
           i_hmc2pa_txanalogen} = hmc_to_pa;

   assign pa_to_hmc = {o_pa2hmc_rddata, o_pa2hmc_rddata_valid};

   assign i_alert_gpio_din = buffs_to_pa;
   assign {i_phy2pa_rddata, i_rxfwd_clk} = b_to_pa;
   assign pa_to_b = {o_pa2phy_wrdata,o_pa2phy_dram_clock_disable};

   assign {i_phy2pa_rddata_valid_lower, i_phy2pa_rddata_valid_upper} = bc_to_pa;
   assign pa_to_bc = {o_pa2phy_rd_rank,
                           o_pa2phy_rddata_en,
                           o_pa2phy_wr_dqs0_en,
                           o_pa2phy_wr_dqs1_en,
                           o_pa2phy_wr_rank,
                           o_pa2phy_wrdata_en,
                           o_pa2phy_suppression,
                           o_pa2phy_rxanalogen,
                           o_pa2phy_txanalogen};

   generate 
      if (IS_USED[ID]) begin : gen_used_pa
         tennm_phy_adaptor # (
            .base_address               (BASE_ADDRESS[ID]),
            .controller                 (CONTROLLER[ID]),
            .ddr_lane_mode              (DDR_LANE_MODE[ID]),
            .mipi_func                  (MIPI_FUNC[ID]),
            .pin0_swizzle               (PIN0_SWIZZLE[ID]),
            .pin1_swizzle               (PIN1_SWIZZLE[ID]),
            .pin2_swizzle               (PIN2_SWIZZLE[ID]),
            .pin3_swizzle               (PIN3_SWIZZLE[ID]),
            .pin8_swizzle               (PIN8_SWIZZLE[ID]),
            .pin9_swizzle               (PIN9_SWIZZLE[ID]),
            .pin10_swizzle              (PIN10_SWIZZLE[ID]),
            .pin11_swizzle              (PIN11_SWIZZLE[ID]),
            .rate_conv                  (RATE_CONV[ID])
         ) pa (
            .i_ctr2pa_dram_clock_disable(i_ctr2pa_dram_clock_disable),
            .o_pa2phy_dram_clock_disable(o_pa2phy_dram_clock_disable),

            .i_phy2pa_rddata_valid      (i_phy2pa_rddata_valid_lower), 
            .o_pa2phy_rd_rank           (o_pa2phy_rd_rank),
            .o_pa2phy_rddata_en         (o_pa2phy_rddata_en),
            .o_pa2phy_suppression       (o_pa2phy_suppression),
            .o_pa2phy_rxanalogen        (o_pa2phy_rxanalogen),
            .o_pa2phy_txanalogen        (o_pa2phy_txanalogen),
            .o_pa2phy_wr_dqs0_en        (o_pa2phy_wr_dqs0_en), 
            .o_pa2phy_wr_dqs1_en        (o_pa2phy_wr_dqs1_en), 
            .o_pa2phy_wr_rank           (o_pa2phy_wr_rank),
            .o_pa2phy_wrdata_en         (o_pa2phy_wrdata_en),
            .i_phy2pa_rddata            (i_phy2pa_rddata),
            .i_alert_gpio_din           (i_alert_gpio_din),
            .o_pa2phy_wrdata            (o_pa2phy_wrdata),
            .o_pa2phy_gpio_dout_sel     (o_pa2phy_gpio_dout_sel),
            .i_hmc2pa_rd_rank           (i_hmc2pa_rd_rank),
            .i_hmc2pa_rddata_en         (i_hmc2pa_rddata_en),
            .i_hmc2pa_rxanalogen        (i_hmc2pa_rxanalogen),
            .i_hmc2pa_txanalogen        (i_hmc2pa_txanalogen),
            .i_hmc2pa_wr_dqs0_en        (i_hmc2pa_wr_dqs0_en),
            .i_hmc2pa_wr_dqs1_en        (i_hmc2pa_wr_dqs1_en),
            .i_hmc2pa_wr_rank           (i_hmc2pa_wr_rank),
            .i_hmc2pa_wrdata            (i_hmc2pa_wrdata),
            .i_hmc2pa_wrdata_en         (i_hmc2pa_wrdata_en),
            .o_pa2hmc_rddata            (o_pa2hmc_rddata),
            .o_pa2hmc_rddata_valid      (o_pa2hmc_rddata_valid),
            .i_fa2pa_gpio_dout_sel      (i_fa2pa_gpio_dout_sel),
            .i_fa2pa_rd_rank            (i_fa2pa_rd_rank),
            .i_fa2pa_rddata_en          (i_fa2pa_rddata_en),
            .i_fa2pa_wr_dqs_en          (i_fa2pa_wr_dqs_en),
            .i_fa2pa_wr_rank            (i_fa2pa_wr_rank),
            .i_fa2pa_wrdata             (i_fa2pa_wrdata),
            .i_fa2pa_wrdata_en          (i_fa2pa_wrdata_en),
            .i_fa2pa_mipi_lp_dout       (), 
            .o_pa2fa_rddata             (o_pa2fa_rddata),
            .o_pa2fa_rddata_valid       (o_pa2fa_rddata_valid),
            .o_rxfwd_clk                (o_rxfwd_clk),
            .i_seq2pa_rd_rank           (i_seq2pa_rd_rank),
            .i_seq2pa_rddata_en         (i_seq2pa_rddata_en),
            .i_seq2pa_seq_en            (i_seq2pa_seq_en),
            .i_seq2pa_suppression       (i_seq2pa_suppression),
            .i_seq2pa_wr_dqs_en         (i_seq2pa_wr_dqs_en),
            .i_seq2pa_wr_rank           (i_seq2pa_wr_rank),
            .i_seq2pa_wrdata            (i_seq2pa_wrdata),
            .i_seq2pa_wrdata_en         (i_seq2pa_wrdata_en),
            .o_rb_pa2seq_ddr_lane_mode  (o_rb_pa2seq_ddr_lane_mode),
            .o_rb_pa2seq_if_sel         (o_rb_pa2seq_if_sel),
            .o_rb_pa2seq_phy_clk_en     (o_rb_pa2seq_phy_clk_en),
            .o_rb_pa2seq_rate_conv_en   (o_rb_pa2seq_rate_conv_en),
            .o_rb_pa2seq_seq_base_addr  (o_rb_pa2seq_seq_base_addr),
            .o_mipi_lp_dout             (), 
            .i_phy_clk_hr               (i_phy_clk_hr),
            .i_phyclk_sync              (i_phyclk_sync)
         );

      end else begin : gen_unused_pa
         assign o_pa2phy_rd_rank             = '0;
         assign o_pa2phy_rddata_en           = '0;
         assign o_pa2phy_suppression         = '0;
         assign o_pa2phy_rxanalogen          = '0;
         assign o_pa2phy_txanalogen          = '0;
         assign o_pa2phy_wr_dqs0_en          = '0;
         assign o_pa2phy_wr_dqs1_en          = '0;
         assign o_pa2phy_wr_rank             = '0;
         assign o_pa2phy_wrdata_en           = '0;
         assign o_pa2phy_wrdata              = '0;
         assign o_pa2phy_gpio_dout_sel       = '0;
         assign o_pa2hmc_rddata              = '0;
         assign o_pa2hmc_rddata_valid        = '0;
         assign o_pa2fa_rddata               = '0;
         assign o_pa2fa_rddata_valid         = '0;
         assign o_rxfwd_clk                  = '0;
         assign o_rb_pa2seq_ddr_lane_mode    = '0;
         assign o_rb_pa2seq_if_sel           = '0;
         assign o_rb_pa2seq_phy_clk_en       = '0;
         assign o_rb_pa2seq_rate_conv_en     = '0;
         assign o_rb_pa2seq_seq_base_addr    = '0;
         assign o_mipi_lp_dout               = '0;
         assign o_pa2phy_dram_clock_disable  = '0;
      end
   endgenerate
endmodule


