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


module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_byte_ctrl #(

   parameter ID                                              = 0,

   localparam PORT_PHYCTRL_RXDFE_T0_WIDTH                     = 5,
   localparam PORT_PHYCTRL_RXDFE_T1_WIDTH                     = 4,
   localparam PORT_PHYCTRL_RXDFE_T2_WIDTH                     = 4,
   localparam PORT_PHYCTRL_RXDFE_T3_WIDTH                     = 3,
   localparam PORT_PHYCTRL_MIPI_CTRL_WIDTH                    = 5,
   localparam PORT_PHYCTRL_MIPI_DIFF_EN_WIDTH                 = 5,
   localparam PORT_PHYCTRL_MIPI_DPHYLPRXEN_WIDTH              = 5,

   localparam PORT_PHYCTRL_DQSMODE_WIDTH                      = 2,
   localparam PORT_PHYCTRL_ODT_SEG_ROTATE_WIDTH               = 2,
   localparam PORT_PHYCTRL_TX_CTRL_WIDTH                      = 2,
   localparam PORT_PHYCTRL_TX_PICODE_WIDTH                    = 4,
   localparam PORT_PHYCTRL_BYTE_TX_CTRL_WIDTH                 = 32,
   localparam PORT_PHYCTRL_DQOVRDDATA_WIDTH                   = 12,
   localparam PORT_PHYCTRL_DQOVRDMODEEN_WIDTH                 = 12,
   localparam PORT_PHYCTRL_FIFO_READ_ENABLE_WIDTH             = 2,
   localparam PORT_PHYCTRL_BYTE_RX_CTRL_WIDTH                 = 32,
   localparam PORT_PHYCTRL_TX_CLKPI_WIDTH                     = 12,
   localparam PORT_PHYCTRL_SDLL_DQS_WIDTH                     = 6,
   localparam PORT_PHYCTRL_AVBB_AVL_ADDRESS_WIDTH             = 22,
   localparam PORT_PHYCTRL_AVBB_AVL_DATA_WIDTH                = 32,
   localparam PORT_PHYCTRL_RX_SENSEAMPEN_WIDTH                = 12,
   localparam PORT_PHYCTRL_TX_MODECTRL_WIDTH                  = 3,

   localparam PORT_PHYCTRL_DATA_WIDTH                         = 48,

   localparam PORT_PHYCTRL_RDDATA_VALID_WIDTH                 = 2,
   localparam PORT_PHYCTRL_RANK_WIDTH                         = 4,
   localparam PORT_PHYCTRL_RDDATA_EN_WIDTH                    = 2,
   localparam PORT_PHYCTRL_WR_DQS_EN_WIDTH                    = 2,
   localparam PORT_PHYCTRL_WRDATA_EN_WIDTH                    = 2,
   localparam PORT_PHYCTRL_PA_SIDEBAND_WIDTH                  = 12,

   localparam PORT_PHYCTRL_DCC_CNT_WIDTH                      = 17,

   localparam PORT_PHYCTRL_ODTEN_WIDTH                        = 12,
   localparam PORT_PHYCTRL_DFEMUXOUT_WIDTH                    = 12,
   localparam PORT_PHYCTRL_RCVENMUXOUT_WIDTH                  = 12,
   localparam PORT_PHYCTRL_RX_D0CBEN_WIDTH                    = 2,
   localparam PORT_PHYCTRL_RX_D0DRVSEL_WIDTH                  = 4,

   localparam PORT_PHYCTRL_RXFIFO_AVM_PIPSTAGE_WIDTH          = 2,
   localparam PORT_PHYCTRL_RXFIFO_SPARE_WIDTH                 = 14,
   localparam PORT_PHYCTRL_PARKCLK_WIDTH                      = 3,

   localparam INTF_BC_TO_B_WIDTH                              = PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                PORT_PHYCTRL_TX_PICODE_WIDTH +
                                                                1  +
                                                                PORT_PHYCTRL_FIFO_READ_ENABLE_WIDTH +
                                                                PORT_PHYCTRL_FIFO_READ_ENABLE_WIDTH +
                                                                1 +
                                                                PORT_PHYCTRL_BYTE_TX_CTRL_WIDTH +
                                                                PORT_PHYCTRL_BYTE_RX_CTRL_WIDTH +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                PORT_PHYCTRL_TX_CLKPI_WIDTH +
                                                                PORT_PHYCTRL_SDLL_DQS_WIDTH +
                                                                PORT_PHYCTRL_SDLL_DQS_WIDTH +
                                                                PORT_PHYCTRL_SDLL_DQS_WIDTH +
                                                                PORT_PHYCTRL_SDLL_DQS_WIDTH +
                                                                PORT_PHYCTRL_RX_SENSEAMPEN_WIDTH +
                                                                PORT_PHYCTRL_SDLL_DQS_WIDTH +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                PORT_PHYCTRL_SDLL_DQS_WIDTH +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                PORT_PHYCTRL_DQSMODE_WIDTH +
                                                                PORT_PHYCTRL_ODT_SEG_ROTATE_WIDTH +
                                                                PORT_PHYCTRL_ODT_SEG_ROTATE_WIDTH  +
                                                                PORT_PHYCTRL_ODTEN_WIDTH +
                                                                PORT_PHYCTRL_ODTEN_WIDTH +
                                                                PORT_PHYCTRL_ODTEN_WIDTH +
                                                                PORT_PHYCTRL_DQOVRDDATA_WIDTH +
                                                                PORT_PHYCTRL_DQOVRDMODEEN_WIDTH +
                                                                PORT_PHYCTRL_RDDATA_EN_WIDTH +
                                                                PORT_PHYCTRL_RX_D0CBEN_WIDTH  +
                                                                PORT_PHYCTRL_RX_D0DRVSEL_WIDTH +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                PORT_PHYCTRL_RCVENMUXOUT_WIDTH +
                                                                PORT_PHYCTRL_RCVENMUXOUT_WIDTH +
                                                                PORT_PHYCTRL_DFEMUXOUT_WIDTH +
                                                                PORT_PHYCTRL_DFEMUXOUT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_DCC_CNT_WIDTH +
                                                                PORT_PHYCTRL_RXFIFO_AVM_PIPSTAGE_WIDTH +
                                                                1 +
                                                                PORT_PHYCTRL_RXFIFO_SPARE_WIDTH +
                                                                0,
   localparam INTF_B_TO_BC_WIDTH                              = PORT_PHYCTRL_AVBB_AVL_DATA_WIDTH +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                PORT_PHYCTRL_RXDFE_T0_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T0_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T1_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T1_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T2_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T2_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T3_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T3_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T0_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T0_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T1_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T1_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T2_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T2_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T3_WIDTH +
                                                                PORT_PHYCTRL_RXDFE_T3_WIDTH +
                                                                PORT_PHYCTRL_MIPI_CTRL_WIDTH +
                                                                PORT_PHYCTRL_MIPI_DIFF_EN_WIDTH +
                                                                PORT_PHYCTRL_MIPI_DPHYLPRXEN_WIDTH +
                                                                PORT_PHYCTRL_TX_MODECTRL_WIDTH +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                1 +
                                                                PORT_PHYCTRL_DATA_WIDTH,
   localparam INTF_SEQ_AVBB_INTF_WIDTH                        = PORT_PHYCTRL_AVBB_AVL_ADDRESS_WIDTH + PORT_PHYCTRL_AVBB_AVL_DATA_WIDTH + 4,
   localparam INTF_BC_TO_PA_WIDTH                             = 2*PORT_PHYCTRL_RDDATA_VALID_WIDTH,
   localparam INTF_PA_TO_BC_WIDTH                             = 2*PORT_PHYCTRL_RANK_WIDTH + 
                                                                PORT_PHYCTRL_RDDATA_EN_WIDTH + 
                                                                2*PORT_PHYCTRL_WR_DQS_EN_WIDTH + 
                                                                PORT_PHYCTRL_WRDATA_EN_WIDTH + 
                                                                PORT_PHYCTRL_PA_SIDEBAND_WIDTH +
                                                                2, 
   localparam INTF_PLL_TO_BC_WIDTH                            = 4,
   localparam INTF_BC_TO_SEQ_WIDTH                            = PORT_PHYCTRL_AVBB_AVL_DATA_WIDTH

) (
   input     logic    [INTF_SEQ_AVBB_INTF_WIDTH-1:0]              seq_avbb,
   output    logic    [INTF_BC_TO_SEQ_WIDTH-1:0]                  bc_to_seq,

   output    logic    [1:0]                                       bc_to_bc_x16_out,
   input     logic    [1:0]                                       bc_to_bc_x16_in,

   output    logic    [INTF_BC_TO_B_WIDTH-1:0]                    bc_to_b,
   input     logic    [INTF_B_TO_BC_WIDTH-1:0]                    b_to_bc,

   output    logic    [INTF_BC_TO_PA_WIDTH-1:0]                   bc_to_pa,
   input     logic    [INTF_PA_TO_BC_WIDTH-1:0]                   pa_to_bc,

   input     logic    [INTF_PLL_TO_BC_WIDTH-1:0]                  pll_to_bc
);
   timeunit 1ns;
   timeprecision 1ps;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_byte_ctrl::*;

   logic    [PORT_PHYCTRL_RXDFE_T0_WIDTH-1:0]                     i_DDRCrRxEQRank01_RxDFETap0Rank0;
   logic    [PORT_PHYCTRL_RXDFE_T0_WIDTH-1:0]                     i_DDRCrRxEQRank01_RxDFETap0Rank1;
   logic    [PORT_PHYCTRL_RXDFE_T1_WIDTH-1:0]                     i_DDRCrRxEQRank01_RxDFETap1Rank0;
   logic    [PORT_PHYCTRL_RXDFE_T1_WIDTH-1:0]                     i_DDRCrRxEQRank01_RxDFETap1Rank1;
   logic    [PORT_PHYCTRL_RXDFE_T2_WIDTH-1:0]                     i_DDRCrRxEQRank01_RxDFETap2Rank0;
   logic    [PORT_PHYCTRL_RXDFE_T2_WIDTH-1:0]                     i_DDRCrRxEQRank01_RxDFETap2Rank1;
   logic    [PORT_PHYCTRL_RXDFE_T3_WIDTH-1:0]                     i_DDRCrRxEQRank01_RxDFETap3Rank0;
   logic    [PORT_PHYCTRL_RXDFE_T3_WIDTH-1:0]                     i_DDRCrRxEQRank01_RxDFETap3Rank1;
   logic    [PORT_PHYCTRL_RXDFE_T0_WIDTH-1:0]                     i_DDRCrRxEQRank23_RxDFETap0Rank2;
   logic    [PORT_PHYCTRL_RXDFE_T0_WIDTH-1:0]                     i_DDRCrRxEQRank23_RxDFETap0Rank3;
   logic    [PORT_PHYCTRL_RXDFE_T1_WIDTH-1:0]                     i_DDRCrRxEQRank23_RxDFETap1Rank2;
   logic    [PORT_PHYCTRL_RXDFE_T1_WIDTH-1:0]                     i_DDRCrRxEQRank23_RxDFETap1Rank3;
   logic    [PORT_PHYCTRL_RXDFE_T2_WIDTH-1:0]                     i_DDRCrRxEQRank23_RxDFETap2Rank2;
   logic    [PORT_PHYCTRL_RXDFE_T2_WIDTH-1:0]                     i_DDRCrRxEQRank23_RxDFETap2Rank3;
   logic    [PORT_PHYCTRL_RXDFE_T3_WIDTH-1:0]                     i_DDRCrRxEQRank23_RxDFETap3Rank2;
   logic    [PORT_PHYCTRL_RXDFE_T3_WIDTH-1:0]                     i_DDRCrRxEQRank23_RxDFETap3Rank3;
   logic    [PORT_PHYCTRL_MIPI_CTRL_WIDTH-1:0]                    i_mipi_rb_rxdly_direct_ctrl;
   logic    [PORT_PHYCTRL_MIPI_DIFF_EN_WIDTH-1:0]                 i_mipi_rx_diff_en;
   logic    [PORT_PHYCTRL_MIPI_DPHYLPRXEN_WIDTH-1:0]              i_mipi_rx_dphylprxen;
   logic                                                          i_pa_2_phytop_rx_analog_en;
   logic                                                          i_pa_2_phytop_tx_analog_en;
   logic                                                          i_phyctrl_cr_iamca_00;
   logic                                                          i_phyctrl_cr_iamca_01;
   logic                                                          i_phyctrl_cr_iamca_02;
   logic                                                          i_phyctrl_cr_iamca_03;
   logic                                                          i_phyctrl_cr_iamca_04;
   logic                                                          i_phyctrl_cr_iamca_05;
   logic                                                          i_phyctrl_cr_iamca_06;
   logic                                                          i_phyctrl_cr_iamca_07;
   logic                                                          i_phyctrl_cr_iamca_08;
   logic                                                          i_phyctrl_cr_iamca_09;
   logic                                                          i_phyctrl_cr_iamca_10;
   logic                                                          i_phyctrl_cr_iamca_11;
   logic                                                          i_phyctrl_io_pad_doe_0;
   logic                                                          i_phyctrl_io_pad_doe_1;
   logic                                                          i_phyctrl_io_pad_doe_2;
   logic                                                          i_phyctrl_io_pad_doe_3;
   logic                                                          i_phyctrl_io_pad_doe_4;
   logic                                                          i_phyctrl_io_pad_doe_5;
   logic                                                          i_phyctrl_io_pad_doe_6;
   logic                                                          i_phyctrl_io_pad_doe_7;
   logic                                                          i_phyctrl_io_pad_doe_8;
   logic                                                          i_phyctrl_io_pad_doe_9;
   logic                                                          i_phyctrl_io_pad_doe_10;
   logic                                                          i_phyctrl_io_pad_doe_11;
   logic    [PORT_PHYCTRL_PA_SIDEBAND_WIDTH-1:0]                  i_phyctrl_pa_sideband;
   logic                                                          i_phyctrl_phy_clk;
   logic                                                          i_phyctrl_phyclk_sync;
   logic                                                          i_phyctrl_pll_lock;
   logic                                                          i_phyctrl_pllvcoclk;
   logic    [PORT_PHYCTRL_RANK_WIDTH-1:0]                         i_phyctrl_rd_rank;
   logic    [PORT_PHYCTRL_RDDATA_EN_WIDTH-1:0]                    i_phyctrl_rddata_en;
   logic                                                          i_phyctrl_rx_dqs_amp_p5;
   logic                                                          i_phyctrl_rx_dqs_amp_p7;
   logic                                                          i_phyctrl_rx_dqs_n4;
   logic                                                          i_phyctrl_rx_dqs_n6;
   logic                                                          i_phyctrl_rx_dqs_p4;
   logic                                                          i_phyctrl_rx_dqs_p6;
   logic                                                          i_phyctrl_sdll0_dqsnin_x16_clk;
   logic                                                          i_phyctrl_sdll0_dqspin_x16_clk;
   logic                                                          i_phyctrl_sdll1_dqsnin_x16_clk;
   logic                                                          i_phyctrl_sdll1_dqspin_x16_clk;
   logic    [PORT_PHYCTRL_DATA_WIDTH-1:0]                         i_phyctrl_tx_wr_data_pl;
   logic    [PORT_PHYCTRL_WR_DQS_EN_WIDTH-1:0]                    i_phyctrl_wr_dqs0_en;
   logic    [PORT_PHYCTRL_WR_DQS_EN_WIDTH-1:0]                    i_phyctrl_wr_dqs1_en;
   logic    [PORT_PHYCTRL_RANK_WIDTH-1:0]                         i_phyctrl_wr_rank;
   logic    [PORT_PHYCTRL_WRDATA_EN_WIDTH-1:0]                    i_phyctrl_wrdata_en;
   logic                                                          i_rx_x16dqsn_p4;
   logic                                                          i_rx_x16dqsp_p4;
   logic                                                          i_rxdphylprxen_0;
   logic                                                          i_rxdphylprxen_1;
   logic                                                          i_rxdphylprxen_2;
   logic                                                          i_rxdphylprxen_3;
   logic                                                          i_rxdphylprxen_4;
   logic                                                          i_rxdphylprxen_5;
   logic                                                          i_rxdphylprxen_6;
   logic                                                          i_rxdphylprxen_7;
   logic                                                          i_rxdphylprxen_8;
   logic                                                          i_rxdphylprxen_9;
   logic                                                          i_rxdphylprxen_10;
   logic                                                          i_rxdphylprxen_11;
   logic                                                          i_rxlvdien_0;
   logic                                                          i_rxlvdien_1;
   logic                                                          i_rxlvdien_2;
   logic                                                          i_rxlvdien_3;
   logic                                                          i_rxlvdien_4;
   logic                                                          i_rxlvdien_5;
   logic                                                          i_rxlvdien_6;
   logic                                                          i_rxlvdien_7;
   logic                                                          i_rxlvdien_8;
   logic                                                          i_rxlvdien_9;
   logic                                                          i_rxlvdien_10;
   logic                                                          i_rxlvdien_11;
   logic                                                          i_rzq_en;
   logic    [PORT_PHYCTRL_TX_MODECTRL_WIDTH-1:0]                  i_tx_modectrl_4;
   logic                                                          rxnpathenable_0;
   logic                                                          rxnpathenable_1;
   logic                                                          rxnpathenable_2;
   logic                                                          rxnpathenable_3;
   logic                                                          rxnpathenable_4;
   logic                                                          rxnpathenable_5;
   logic                                                          rxnpathenable_6;
   logic                                                          rxnpathenable_7;
   logic                                                          rxnpathenable_8;
   logic                                                          rxnpathenable_9;
   logic                                                          rxnpathenable_10;
   logic                                                          rxnpathenable_11;
   logic                                                          rxppathenable_0;
   logic                                                          rxppathenable_1;
   logic                                                          rxppathenable_2;
   logic                                                          rxppathenable_3;
   logic                                                          rxppathenable_4;
   logic                                                          rxppathenable_5;
   logic                                                          rxppathenable_6;
   logic                                                          rxppathenable_7;
   logic                                                          rxppathenable_8;
   logic                                                          rxppathenable_9;
   logic                                                          rxppathenable_10;
   logic                                                          rxppathenable_11;
                                                                  
                                                                  
   logic    [PORT_PHYCTRL_DQSMODE_WIDTH-1:0]                      o_io12phyctrl_dqsmode;
   logic    [PORT_PHYCTRL_ODT_SEG_ROTATE_WIDTH-1:0]               o_n0_odt_seg_rotate_en;
   logic    [PORT_PHYCTRL_ODT_SEG_ROTATE_WIDTH-1:0]               o_n1_odt_seg_rotate_en;
   logic    [PORT_PHYCTRL_ODTEN_WIDTH-1:0]                        o_odt_en;
   logic    [PORT_PHYCTRL_ODTEN_WIDTH-1:0]                        o_odt_parken;
   logic    [PORT_PHYCTRL_ODTEN_WIDTH-1:0]                        o_odt_parken_dqsn;
   logic    [PORT_PHYCTRL_BYTE_RX_CTRL_WIDTH-1:0]                 o_phyctrl_byte_rx_ctrl;
   logic    [PORT_PHYCTRL_BYTE_TX_CTRL_WIDTH-1:0]                 o_phyctrl_byte_tx_ctrl;
   logic                                                          o_phyctrl_ckx16dqsn_to_bottom;
   logic                                                          o_phyctrl_ckx16dqsn_to_top;
   logic                                                          o_phyctrl_ckx16dqsp_to_bottom;
   logic                                                          o_phyctrl_ckx16dqsp_to_top;
   logic    [PORT_PHYCTRL_DQOVRDDATA_WIDTH-1:0]                   o_phyctrl_ddrcrcmdbustrain_ddrdqovrddata;
   logic    [PORT_PHYCTRL_DQOVRDMODEEN_WIDTH-1:0]                 o_phyctrl_ddrcrcmdbustrain_ddrdqovrdmodeen;
   logic                                                          o_phyctrl_ddrcrdatacontrol0_enodtrotation;
   logic                                                          o_phyctrl_ddrcrdatacontrol4_unmatchedrx;
   logic    [PORT_PHYCTRL_DFEMUXOUT_WIDTH-1:0]                    o_phyctrl_dfemuxout_0;
   logic    [PORT_PHYCTRL_DFEMUXOUT_WIDTH-1:0]                    o_phyctrl_dfemuxout_1;
   logic                                                          o_phyctrl_fifo_pack_select;
   logic    [PORT_PHYCTRL_FIFO_READ_ENABLE_WIDTH-1:0]             o_phyctrl_fifo_read_enable_lower;
   logic    [PORT_PHYCTRL_FIFO_READ_ENABLE_WIDTH-1:0]             o_phyctrl_fifo_read_enable_upper;
   logic                                                          o_phyctrl_gated_rx_phy_clk;
   logic                                                          o_phyctrl_gated_tx_phy_clk;
   logic                                                          o_phyctrl_o_occ_phy_clk;
   logic                                                          o_phyctrl_phyclk_notgated;
   logic    [PORT_PHYCTRL_RCVENMUXOUT_WIDTH-1:0]                  o_phyctrl_rcvenmuxout_0;
   logic    [PORT_PHYCTRL_RCVENMUXOUT_WIDTH-1:0]                  o_phyctrl_rcvenmuxout_1;
   logic    [PORT_PHYCTRL_RDDATA_EN_WIDTH-1:0]                    o_phyctrl_rddata_en_dly;
   logic    [PORT_PHYCTRL_RDDATA_VALID_WIDTH-1:0]                 o_phyctrl_rddata_valid_lower;
   logic    [PORT_PHYCTRL_RDDATA_VALID_WIDTH-1:0]                 o_phyctrl_rddata_valid_upper;
   logic    [PORT_PHYCTRL_RX_D0CBEN_WIDTH-1:0]                    o_phyctrl_rx_d0cben;
   logic    [PORT_PHYCTRL_RX_D0DRVSEL_WIDTH-1:0]                  o_phyctrl_rx_d0drvsel;
   logic    [PORT_PHYCTRL_RX_SENSEAMPEN_WIDTH-1:0]                o_phyctrl_rx_senseampen;
   logic    [PORT_PHYCTRL_RXFIFO_AVM_PIPSTAGE_WIDTH-1:0]          o_phyctrl_rxfifo_rb_avm_wr_pipestage;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                     o_phyctrl_sdll0_dqsn;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                     o_phyctrl_sdll0_dqsp;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                     o_phyctrl_sdll0_rx_d0pienable;
   logic                                                          o_phyctrl_sdll0_rx_d0rcvenpre;
   logic                                                          o_phyctrl_sdll0_rx_d0reset;
   logic                                                          o_phyctrl_sdll0_rx_d0sdlparkvalue;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                     o_phyctrl_sdll1_dqsn;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                     o_phyctrl_sdll1_dqsp;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                     o_phyctrl_sdll1_rx_d0pienable;
   logic                                                          o_phyctrl_sdll1_rx_d0rcvenpre;
   logic                                                          o_phyctrl_sdll1_rx_d0reset;
   logic                                                          o_phyctrl_sdll1_rx_d0sdlparkvalue;
   logic                                                          o_phyctrl_trainreset;
   logic    [PORT_PHYCTRL_TX_CLKPI_WIDTH-1:0]                     o_phyctrl_tx_clkpi;
   logic                                                          o_phyctrl_tx_clkrefdivby2;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode0;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode1;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode2;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode3;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode4;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode5;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode6;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode7;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode8;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode9;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode10;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                    o_phyctrl_tx_picode11;
   logic                                                          o_phyctrl_u_io12phyctrl_logic_o_phy_clk_gated;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wr_dqs_en4;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wr_dqs_en4_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wr_dqs_en5;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wr_dqs_en5_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wr_dqs_en6;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wr_dqs_en6_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wr_dqs_en7;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wr_dqs_en7_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en0;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en0_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en1;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en1_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en2;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en2_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en3;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en3_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en8;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en8_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en9;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en9_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en10;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en10_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en11;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                      o_phyctrl_wrdata_en11_del;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_00_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_01_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_02_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_03_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_04_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_05_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_06_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_07_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_08_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_09_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_10_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                      o_phyctrl_X1CounterDCCPin_11_DCCCount;
   logic                                                          o_rxfifo_skew;
   logic    [PORT_PHYCTRL_RXFIFO_SPARE_WIDTH-1:0]                 o_rxfifo_spare;
   logic    [PORT_PHYCTRL_PARKCLK_WIDTH-1:0]                      o_phyctrl_parkclk_to_rxtop_n0_pl1;
   logic    [PORT_PHYCTRL_PARKCLK_WIDTH-1:0]                      o_phyctrl_parkclk_to_rxtop_n1_pl1;
   logic                                                          o_phyctrl_trainreset_vcoclk_sync_n;
   logic                                                          o_phyctrl_vcoclk_compactive_gated;


   logic    [PORT_PHYCTRL_AVBB_AVL_ADDRESS_WIDTH-1:0]             i_phyctrl_avbb_avl_in_avm_address;
   logic                                                          i_phyctrl_avbb_avl_in_avm_read;
   logic    [PORT_PHYCTRL_AVBB_AVL_DATA_WIDTH-1:0]                i_phyctrl_avbb_avl_in_avm_readdata;
   logic                                                          i_phyctrl_avbb_avl_in_avm_write;
   logic    [PORT_PHYCTRL_AVBB_AVL_DATA_WIDTH-1:0]                i_phyctrl_avbb_avl_in_avm_writedata;
   logic                                                          i_phyctrl_avbb_avl_in_clk;
   logic                                                          i_phyctrl_avbb_avl_in_rst_n;
   logic    [PORT_PHYCTRL_AVBB_AVL_DATA_WIDTH-1:0]                o_phyctrl_avbb_avl_out_avm_readdata;


   assign bc_to_bc_x16_out = {o_phyctrl_ckx16dqsn_to_bottom,o_phyctrl_ckx16dqsp_to_bottom};
   

   // Assign Wires to Interfaces
   //outputs
   assign bc_to_b = {      o_phyctrl_wrdata_en0,                           
                           o_phyctrl_wrdata_en1,                           
                           o_phyctrl_wrdata_en2,                           
                           o_phyctrl_wrdata_en3,                           
                           o_phyctrl_wr_dqs_en4,                           
                           o_phyctrl_wr_dqs_en5,                           
                           o_phyctrl_wr_dqs_en6,                           
                           o_phyctrl_wr_dqs_en7,                           
                           o_phyctrl_wrdata_en8,                           
                           o_phyctrl_wrdata_en9,                           
                           o_phyctrl_wrdata_en10,                          
                           o_phyctrl_wrdata_en11,                          
                           o_phyctrl_wrdata_en0_del,                       
                           o_phyctrl_wrdata_en1_del,                       
                           o_phyctrl_wrdata_en2_del,                       
                           o_phyctrl_wrdata_en3_del,                       
                           o_phyctrl_wr_dqs_en4_del,                       
                           o_phyctrl_wr_dqs_en5_del,                       
                           o_phyctrl_wr_dqs_en6_del,                       
                           o_phyctrl_wr_dqs_en7_del,                       
                           o_phyctrl_wrdata_en8_del,                       
                           o_phyctrl_wrdata_en9_del,                       
                           o_phyctrl_wrdata_en10_del,                      
                           o_phyctrl_wrdata_en11_del,                      
                           o_phyctrl_tx_picode0,                           
                           o_phyctrl_tx_picode1,                           
                           o_phyctrl_tx_picode2,                           
                           o_phyctrl_tx_picode3,                           
                           o_phyctrl_tx_picode4,                           
                           o_phyctrl_tx_picode5,                           
                           o_phyctrl_tx_picode6,                           
                           o_phyctrl_tx_picode7,                           
                           o_phyctrl_tx_picode8,                           
                           o_phyctrl_tx_picode9,                           
                           o_phyctrl_tx_picode10,                          
                           o_phyctrl_tx_picode11,                          
                           o_phyctrl_fifo_pack_select,                     
                           o_phyctrl_fifo_read_enable_lower,               
                           o_phyctrl_fifo_read_enable_upper,               
                           o_phyctrl_trainreset,                           
                           o_phyctrl_byte_tx_ctrl,                         
                           o_phyctrl_byte_rx_ctrl,                         
                           o_phyctrl_gated_tx_phy_clk,                     
                           o_phyctrl_gated_rx_phy_clk,                     
                           o_phyctrl_tx_clkrefdivby2,                      
                           o_phyctrl_tx_clkpi,                             
                           o_phyctrl_sdll0_dqsp,                           
                           o_phyctrl_sdll0_dqsn,                           
                           o_phyctrl_sdll1_dqsp,                           
                           o_phyctrl_sdll1_dqsn,                           
                           o_phyctrl_rx_senseampen,                        
                           o_phyctrl_sdll0_rx_d0pienable,                  
                           o_phyctrl_sdll0_rx_d0rcvenpre,                  
                           o_phyctrl_sdll0_rx_d0reset,                     
                           o_phyctrl_sdll1_rx_d0pienable,                  
                           o_phyctrl_sdll1_rx_d0rcvenpre,                  
                           o_phyctrl_sdll1_rx_d0reset,                     
                           o_io12phyctrl_dqsmode,                          
                           o_n0_odt_seg_rotate_en,                         
                           o_n1_odt_seg_rotate_en,                         
                           o_odt_en,                                       
                           o_odt_parken,                                   
                           o_odt_parken_dqsn,                              
                           o_phyctrl_ddrcrcmdbustrain_ddrdqovrddata,       
                           o_phyctrl_ddrcrcmdbustrain_ddrdqovrdmodeen,     
                           o_phyctrl_rddata_en_dly,                        
                           o_phyctrl_rx_d0cben,                            
                           o_phyctrl_rx_d0drvsel,                          
                           o_phyctrl_ddrcrdatacontrol0_enodtrotation,      
                           o_phyctrl_ddrcrdatacontrol4_unmatchedrx,        
                           o_phyctrl_o_occ_phy_clk,                        
                           o_phyctrl_u_io12phyctrl_logic_o_phy_clk_gated,  
                           o_phyctrl_phyclk_notgated,                      
                           o_phyctrl_rcvenmuxout_0,                        
                           o_phyctrl_rcvenmuxout_1,                        
                           o_phyctrl_dfemuxout_0,                          
                           o_phyctrl_dfemuxout_1,                          
                           o_phyctrl_X1CounterDCCPin_00_DCCCount,          
                           o_phyctrl_X1CounterDCCPin_01_DCCCount,          
                           o_phyctrl_X1CounterDCCPin_02_DCCCount,          
                           o_phyctrl_X1CounterDCCPin_03_DCCCount,          
                           o_phyctrl_X1CounterDCCPin_04_DCCCount,          
                           o_phyctrl_X1CounterDCCPin_05_DCCCount,          
                           o_phyctrl_X1CounterDCCPin_06_DCCCount,          
                           o_phyctrl_X1CounterDCCPin_07_DCCCount,          
                           o_phyctrl_X1CounterDCCPin_08_DCCCount,          
                           o_phyctrl_X1CounterDCCPin_09_DCCCount,          
                           o_phyctrl_X1CounterDCCPin_10_DCCCount,          
                           o_phyctrl_X1CounterDCCPin_11_DCCCount,          
                           o_phyctrl_rxfifo_rb_avm_wr_pipestage,           
                           o_rxfifo_skew,                                  
                           o_rxfifo_spare,                                 
                           o_phyctrl_sdll0_rx_d0sdlparkvalue,
            o_phyctrl_sdll1_rx_d0sdlparkvalue
                           };

   assign bc_to_pa = {o_phyctrl_rddata_valid_lower, o_phyctrl_rddata_valid_upper};
   assign bc_to_seq = o_phyctrl_avbb_avl_out_avm_readdata;

   assign { i_phyctrl_avbb_avl_in_avm_readdata,          
            i_phyctrl_rx_dqs_p4,                         
            i_phyctrl_rx_dqs_n4,                         
            i_phyctrl_rx_dqs_amp_p5,                     
            i_phyctrl_rx_dqs_p6,                         
            i_phyctrl_rx_dqs_n6,                         
            i_phyctrl_rx_dqs_amp_p7,                     
            i_rx_x16dqsp_p4,                             
            i_rx_x16dqsn_p4,                             
            i_rxdphylprxen_0,                            
            i_rxdphylprxen_1,                            
            i_rxdphylprxen_2,                            
            i_rxdphylprxen_3,                            
            i_rxdphylprxen_4,                            
            i_rxdphylprxen_5,                            
            i_rxdphylprxen_6,                            
            i_rxdphylprxen_7,                            
            i_rxdphylprxen_8,                            
            i_rxdphylprxen_9,                            
            i_rxdphylprxen_10,                           
            i_rxdphylprxen_11,                           
            i_rxlvdien_0,                                
            i_rxlvdien_1,                                
            i_rxlvdien_2,                                
            i_rxlvdien_3,                                
            i_rxlvdien_4,                                
            i_rxlvdien_5,                                
            i_rxlvdien_6,                                
            i_rxlvdien_7,                                
            i_rxlvdien_8,                                
            i_rxlvdien_9,                                
            i_rxlvdien_10,                               
            i_rxlvdien_11,                               
            rxppathenable_0,                             
            rxppathenable_1,                             
            rxppathenable_2,                             
            rxppathenable_3,                             
            rxppathenable_4,                             
            rxppathenable_5,                             
            rxppathenable_6,                             
            rxppathenable_7,                             
            rxppathenable_8,                             
            rxppathenable_9,                             
            rxppathenable_10,                            
            rxppathenable_11,                            
            rxnpathenable_0,                             
            rxnpathenable_1,                             
            rxnpathenable_2,                             
            rxnpathenable_3,                             
            rxnpathenable_4,                             
            rxnpathenable_5,                             
            rxnpathenable_6,                             
            rxnpathenable_7,                             
            rxnpathenable_8,                             
            rxnpathenable_9,                             
            rxnpathenable_10,                            
            rxnpathenable_11,                            
            i_DDRCrRxEQRank01_RxDFETap0Rank0,            
            i_DDRCrRxEQRank01_RxDFETap0Rank1,            
            i_DDRCrRxEQRank01_RxDFETap1Rank0,            
            i_DDRCrRxEQRank01_RxDFETap1Rank1,            
            i_DDRCrRxEQRank01_RxDFETap2Rank0,            
            i_DDRCrRxEQRank01_RxDFETap2Rank1,            
            i_DDRCrRxEQRank01_RxDFETap3Rank0,            
            i_DDRCrRxEQRank01_RxDFETap3Rank1,            
            i_DDRCrRxEQRank23_RxDFETap0Rank2,            
            i_DDRCrRxEQRank23_RxDFETap0Rank3,            
            i_DDRCrRxEQRank23_RxDFETap1Rank2,            
            i_DDRCrRxEQRank23_RxDFETap1Rank3,            
            i_DDRCrRxEQRank23_RxDFETap2Rank2,            
            i_DDRCrRxEQRank23_RxDFETap2Rank3,            
            i_DDRCrRxEQRank23_RxDFETap3Rank2,            
            i_DDRCrRxEQRank23_RxDFETap3Rank3,            
            i_mipi_rb_rxdly_direct_ctrl,                 
            i_mipi_rx_diff_en,                           
            i_mipi_rx_dphylprxen,                        
            i_tx_modectrl_4,                             
            i_phyctrl_io_pad_doe_11,
            i_phyctrl_io_pad_doe_10,
            i_phyctrl_io_pad_doe_9,
            i_phyctrl_io_pad_doe_8,
            i_phyctrl_io_pad_doe_7,
            i_phyctrl_io_pad_doe_6,
            i_phyctrl_io_pad_doe_5,
            i_phyctrl_io_pad_doe_4,
            i_phyctrl_io_pad_doe_3,
            i_phyctrl_io_pad_doe_2,
            i_phyctrl_io_pad_doe_1,
            i_phyctrl_io_pad_doe_0,
            i_phyctrl_cr_iamca_11,
            i_phyctrl_cr_iamca_10,
            i_phyctrl_cr_iamca_09,
            i_phyctrl_cr_iamca_08,
            i_phyctrl_cr_iamca_07,
            i_phyctrl_cr_iamca_06,
            i_phyctrl_cr_iamca_05,
            i_phyctrl_cr_iamca_04,
            i_phyctrl_cr_iamca_03,
            i_phyctrl_cr_iamca_02,
            i_phyctrl_cr_iamca_01,
            i_phyctrl_cr_iamca_00,
            i_phyctrl_tx_wr_data_pl
            } = b_to_bc;


   assign { i_phyctrl_avbb_avl_in_rst_n,
            i_phyctrl_avbb_avl_in_clk,
            i_phyctrl_avbb_avl_in_avm_write,
            i_phyctrl_avbb_avl_in_avm_read,
            i_phyctrl_avbb_avl_in_avm_address,
            i_phyctrl_avbb_avl_in_avm_writedata} = seq_avbb;


   assign { i_phyctrl_rd_rank,
            i_phyctrl_rddata_en,
            i_phyctrl_wr_dqs0_en,
            i_phyctrl_wr_dqs1_en,
            i_phyctrl_wr_rank,
            i_phyctrl_wrdata_en,
            i_phyctrl_pa_sideband,
            i_pa_2_phytop_rx_analog_en,
            i_pa_2_phytop_tx_analog_en} = pa_to_bc;

   assign { i_phyctrl_phy_clk, i_phyctrl_phyclk_sync, i_phyctrl_pllvcoclk, i_phyctrl_pll_lock} = pll_to_bc;

   assign { i_phyctrl_sdll1_dqsnin_x16_clk,
            i_phyctrl_sdll1_dqspin_x16_clk } = '0; 

`define byte_ctrl_pinX_params(X)                                                             \
            .pin``X``_rx_coarse_delay             (PIN_RX_COARSE_DELAY       [ID*12+``X``]), \
            .pin``X``_rx_fine_delay               (PIN_RX_FINE_DELAY         [ID*12+``X``]), \
            .pin``X``_rx_usage                    (PIN_RX_USAGE              [ID*12+``X``]), \
            .pin``X``_tx_coarse_delay             (PIN_TX_COARSE_DELAY       [ID*12+``X``]), \
            .pin``X``_tx_fine_delay               (PIN_TX_FINE_DELAY         [ID*12+``X``]), \
            .pin``X``_tx_usage                    (PIN_TX_USAGE              [ID*12+``X``]),


   generate 
      if (IS_USED[ID]) begin : gen_used_byte_ctrl
         // synthesis translate_off
         //Note: Unmatched -> 2 UIs (in ps)
         localparam int MDELAY = (TX_USAGE_MODE[ID] == "TX_USAGE_MODE_LPDDR5") ? 0 :
                                 (RX_SAMPLER_MODE[ID] == "RX_SAMPLER_MODE_UNMATCHED_HIGH_COMMON_MODE") ? (1000000 / (VCO_FREQ[ID]/1000000)) : 
                                 (RX_SAMPLER_MODE[ID] == "RX_SAMPLER_MODE_UNMATCHED_LOW_COMMON_MODE")  ? (1000000 / (VCO_FREQ[ID]/1000000)) : 0;
         defparam u_byte_ctrl.sim_mdelay_value_ps = MDELAY;
         // synthesis translate_on

         tennm_byte_control # (
            .base_address                                         (BASE_ADDRESS[ID]),
            .lfifo_value                                          (LFIFO_VALUE[ID]),
            `byte_ctrl_pinX_params(0)
            `byte_ctrl_pinX_params(1)
            `byte_ctrl_pinX_params(2)
            `byte_ctrl_pinX_params(3)
            `byte_ctrl_pinX_params(4)
            `byte_ctrl_pinX_params(5)
            `byte_ctrl_pinX_params(6)
            `byte_ctrl_pinX_params(7)
            `byte_ctrl_pinX_params(8)
            `byte_ctrl_pinX_params(9)
            `byte_ctrl_pinX_params(10)
            `byte_ctrl_pinX_params(11)
            .outputenable_to_wrfifo_offset                        (OUTPUTENABLE_TO_WRFIFO_OFFSET[ID]),
            .rcven_coarse_delay                                   (RCVEN_COARSE_DELAY[ID]),
            .rcven_fine_delay                                     (RCVEN_FINE_DELAY[ID]),
            .rcven_to_read_valid_offset                           (RCVEN_TO_READ_VALID_OFFSET[ID]),
            .reset_auto_release                                   (RESET_AUTO_RELEASE[ID]),
            .rx_burst_length                                      (RX_BURST_LENGTH[ID]),
            .rx_clock_source                                      (RX_CLOCK_SOURCE[ID]),
            .rx_io_standard                                       (RX_IO_STANDARD[ID]),
            .rx_sampler_mode                                      (RX_SAMPLER_MODE[ID]),
            .rx_self_calibration                                  (RX_SELF_CALIBRATION[ID]),
            .rx_serializer_rate                                   (RX_SERIALIZER_RATE[ID]),
            .rx_usage_mode                                        (RX_USAGE_MODE[ID]),
            .tx_io_standard                                       (TX_IO_STANDARD[ID]),
            .tx_preamble                                          (TX_PREAMBLE[ID]),
            .tx_serializer_rate                                   (TX_SERIALIZER_RATE[ID]),
            .tx_usage_mode                                        (TX_USAGE_MODE[ID]),
            .vco_freq                                             (VCO_FREQ[ID]),
            .vfifo_value                                          (VFIFO_VALUE[ID])
         ) u_byte_ctrl (
            .i_DDRCrRxEQRank01_RxDFETap0Rank0                     (i_DDRCrRxEQRank01_RxDFETap0Rank0),
            .i_DDRCrRxEQRank01_RxDFETap0Rank1                     (i_DDRCrRxEQRank01_RxDFETap0Rank1),
            .i_DDRCrRxEQRank01_RxDFETap1Rank0                     (i_DDRCrRxEQRank01_RxDFETap1Rank0),
            .i_DDRCrRxEQRank01_RxDFETap1Rank1                     (i_DDRCrRxEQRank01_RxDFETap1Rank1),
            .i_DDRCrRxEQRank01_RxDFETap2Rank0                     (i_DDRCrRxEQRank01_RxDFETap2Rank0),
            .i_DDRCrRxEQRank01_RxDFETap2Rank1                     (i_DDRCrRxEQRank01_RxDFETap2Rank1),
            .i_DDRCrRxEQRank01_RxDFETap3Rank0                     (i_DDRCrRxEQRank01_RxDFETap3Rank0),
            .i_DDRCrRxEQRank01_RxDFETap3Rank1                     (i_DDRCrRxEQRank01_RxDFETap3Rank1),
            .i_DDRCrRxEQRank23_RxDFETap0Rank2                     (i_DDRCrRxEQRank23_RxDFETap0Rank2),
            .i_DDRCrRxEQRank23_RxDFETap0Rank3                     (i_DDRCrRxEQRank23_RxDFETap0Rank3),
            .i_DDRCrRxEQRank23_RxDFETap1Rank2                     (i_DDRCrRxEQRank23_RxDFETap1Rank2),
            .i_DDRCrRxEQRank23_RxDFETap1Rank3                     (i_DDRCrRxEQRank23_RxDFETap1Rank3),
            .i_DDRCrRxEQRank23_RxDFETap2Rank2                     (i_DDRCrRxEQRank23_RxDFETap2Rank2),
            .i_DDRCrRxEQRank23_RxDFETap2Rank3                     (i_DDRCrRxEQRank23_RxDFETap2Rank3),
            .i_DDRCrRxEQRank23_RxDFETap3Rank2                     (i_DDRCrRxEQRank23_RxDFETap3Rank2),
            .i_DDRCrRxEQRank23_RxDFETap3Rank3                     (i_DDRCrRxEQRank23_RxDFETap3Rank3),
            .i_mipi_rb_rxdly_direct_ctrl                          (i_mipi_rb_rxdly_direct_ctrl),
            .i_mipi_rx_diff_en                                    (i_mipi_rx_diff_en),
            .i_mipi_rx_dphylprxen                                 (i_mipi_rx_dphylprxen),
            .i_pa_2_phytop_rx_analog_en                           (i_pa_2_phytop_rx_analog_en),
            .i_pa_2_phytop_tx_analog_en                           (i_pa_2_phytop_tx_analog_en),
            .i_phyctrl_avbb_avl_in_avm_address                    (i_phyctrl_avbb_avl_in_avm_address),
            .i_phyctrl_avbb_avl_in_avm_read                       (i_phyctrl_avbb_avl_in_avm_read),
            .i_phyctrl_avbb_avl_in_avm_readdata                   (i_phyctrl_avbb_avl_in_avm_readdata),
            .i_phyctrl_avbb_avl_in_avm_write                      (i_phyctrl_avbb_avl_in_avm_write),
            .i_phyctrl_avbb_avl_in_avm_writedata                  (i_phyctrl_avbb_avl_in_avm_writedata),
            .i_phyctrl_avbb_avl_in_clk                            (i_phyctrl_avbb_avl_in_clk),
            .i_phyctrl_avbb_avl_in_rst_n                          (i_phyctrl_avbb_avl_in_rst_n),
            .i_phyctrl_cr_iamca_00                                (i_phyctrl_cr_iamca_00),
            .i_phyctrl_cr_iamca_01                                (i_phyctrl_cr_iamca_01),
            .i_phyctrl_cr_iamca_02                                (i_phyctrl_cr_iamca_02),
            .i_phyctrl_cr_iamca_03                                (i_phyctrl_cr_iamca_03),
            .i_phyctrl_cr_iamca_04                                (i_phyctrl_cr_iamca_04),
            .i_phyctrl_cr_iamca_05                                (i_phyctrl_cr_iamca_05),
            .i_phyctrl_cr_iamca_06                                (i_phyctrl_cr_iamca_06),
            .i_phyctrl_cr_iamca_07                                (i_phyctrl_cr_iamca_07),
            .i_phyctrl_cr_iamca_08                                (i_phyctrl_cr_iamca_08),
            .i_phyctrl_cr_iamca_09                                (i_phyctrl_cr_iamca_09),
            .i_phyctrl_cr_iamca_10                                (i_phyctrl_cr_iamca_10),
            .i_phyctrl_cr_iamca_11                                (i_phyctrl_cr_iamca_11),
            .i_phyctrl_io_pad_doe_0                               (i_phyctrl_io_pad_doe_0),
            .i_phyctrl_io_pad_doe_1                               (i_phyctrl_io_pad_doe_1),
            .i_phyctrl_io_pad_doe_2                               (i_phyctrl_io_pad_doe_2),
            .i_phyctrl_io_pad_doe_3                               (i_phyctrl_io_pad_doe_3),
            .i_phyctrl_io_pad_doe_4                               (i_phyctrl_io_pad_doe_4),
            .i_phyctrl_io_pad_doe_5                               (i_phyctrl_io_pad_doe_5),
            .i_phyctrl_io_pad_doe_6                               (i_phyctrl_io_pad_doe_6),
            .i_phyctrl_io_pad_doe_7                               (i_phyctrl_io_pad_doe_7),
            .i_phyctrl_io_pad_doe_8                               (i_phyctrl_io_pad_doe_8),
            .i_phyctrl_io_pad_doe_9                               (i_phyctrl_io_pad_doe_9),
            .i_phyctrl_io_pad_doe_10                              (i_phyctrl_io_pad_doe_10),
            .i_phyctrl_io_pad_doe_11                              (i_phyctrl_io_pad_doe_11),
            .i_phyctrl_pa_sideband                                (i_phyctrl_pa_sideband),
            .i_phyctrl_phy_clk                                    (i_phyctrl_phy_clk),
            .i_phyctrl_phyclk_sync                                (i_phyctrl_phyclk_sync),
            .i_phyctrl_pll_lock                                   (i_phyctrl_pll_lock),
            .i_phyctrl_pllvcoclk                                  (i_phyctrl_pllvcoclk),
            .i_phyctrl_rd_rank                                    (i_phyctrl_rd_rank),
            .i_phyctrl_rddata_en                                  (i_phyctrl_rddata_en),
            .i_phyctrl_rx_dqs_amp_p5                              (i_phyctrl_rx_dqs_amp_p5),
            .i_phyctrl_rx_dqs_amp_p7                              (i_phyctrl_rx_dqs_amp_p7),
            .i_phyctrl_rx_dqs_n4                                  (i_phyctrl_rx_dqs_n4),
            .i_phyctrl_rx_dqs_n6                                  (i_phyctrl_rx_dqs_n6),
            .i_phyctrl_rx_dqs_p4                                  (i_phyctrl_rx_dqs_p4),
            .i_phyctrl_rx_dqs_p6                                  (i_phyctrl_rx_dqs_p6),
            .i_phyctrl_sdll0_dqsnin_x16_clk                       (i_phyctrl_sdll0_dqsnin_x16_clk),
            .i_phyctrl_sdll0_dqspin_x16_clk                       (i_phyctrl_sdll0_dqspin_x16_clk),
            .i_phyctrl_sdll1_dqsnin_x16_clk                       (i_phyctrl_sdll1_dqsnin_x16_clk),
            .i_phyctrl_sdll1_dqspin_x16_clk                       (i_phyctrl_sdll1_dqspin_x16_clk),
            .i_phyctrl_tx_wr_data_pl                              (i_phyctrl_tx_wr_data_pl),
            .i_phyctrl_wr_dqs0_en                                 (i_phyctrl_wr_dqs0_en),
            .i_phyctrl_wr_dqs1_en                                 (i_phyctrl_wr_dqs1_en),
            .i_phyctrl_wr_rank                                    (i_phyctrl_wr_rank),
            .i_phyctrl_wrdata_en                                  (i_phyctrl_wrdata_en),
            .i_rx_x16dqsn_p4                                      (i_rx_x16dqsn_p4),
            .i_rx_x16dqsp_p4                                      (i_rx_x16dqsp_p4),
            .i_rxdphylprxen_0                                     (i_rxdphylprxen_0),
            .i_rxdphylprxen_1                                     (i_rxdphylprxen_1),
            .i_rxdphylprxen_2                                     (i_rxdphylprxen_2),
            .i_rxdphylprxen_3                                     (i_rxdphylprxen_3),
            .i_rxdphylprxen_4                                     (i_rxdphylprxen_4),
            .i_rxdphylprxen_5                                     (i_rxdphylprxen_5),
            .i_rxdphylprxen_6                                     (i_rxdphylprxen_6),
            .i_rxdphylprxen_7                                     (i_rxdphylprxen_7),
            .i_rxdphylprxen_8                                     (i_rxdphylprxen_8),
            .i_rxdphylprxen_9                                     (i_rxdphylprxen_9),
            .i_rxdphylprxen_10                                    (i_rxdphylprxen_10),
            .i_rxdphylprxen_11                                    (i_rxdphylprxen_11),
            .i_rxlvdien_0                                         (i_rxlvdien_0),
            .i_rxlvdien_1                                         (i_rxlvdien_1),
            .i_rxlvdien_2                                         (i_rxlvdien_2),
            .i_rxlvdien_3                                         (i_rxlvdien_3),
            .i_rxlvdien_4                                         (i_rxlvdien_4),
            .i_rxlvdien_5                                         (i_rxlvdien_5),
            .i_rxlvdien_6                                         (i_rxlvdien_6),
            .i_rxlvdien_7                                         (i_rxlvdien_7),
            .i_rxlvdien_8                                         (i_rxlvdien_8),
            .i_rxlvdien_9                                         (i_rxlvdien_9),
            .i_rxlvdien_10                                        (i_rxlvdien_10),
            .i_rxlvdien_11                                        (i_rxlvdien_11),
            .i_rzq_en                                             (i_rzq_en),
            .i_tx_modectrl_4                                      (i_tx_modectrl_4),
            .rxnpathenable_0                                      (rxnpathenable_0),
            .rxnpathenable_1                                      (rxnpathenable_1),
            .rxnpathenable_2                                      (rxnpathenable_2),
            .rxnpathenable_3                                      (rxnpathenable_3),
            .rxnpathenable_4                                      (rxnpathenable_4),
            .rxnpathenable_5                                      (rxnpathenable_5),
            .rxnpathenable_6                                      (rxnpathenable_6),
            .rxnpathenable_7                                      (rxnpathenable_7),
            .rxnpathenable_8                                      (rxnpathenable_8),
            .rxnpathenable_9                                      (rxnpathenable_9),
            .rxnpathenable_10                                     (rxnpathenable_10),
            .rxnpathenable_11                                     (rxnpathenable_11),
            .rxppathenable_0                                      (rxppathenable_0),
            .rxppathenable_1                                      (rxppathenable_1),
            .rxppathenable_2                                      (rxppathenable_2),
            .rxppathenable_3                                      (rxppathenable_3),
            .rxppathenable_4                                      (rxppathenable_4),
            .rxppathenable_5                                      (rxppathenable_5),
            .rxppathenable_6                                      (rxppathenable_6),
            .rxppathenable_7                                      (rxppathenable_7),
            .rxppathenable_8                                      (rxppathenable_8),
            .rxppathenable_9                                      (rxppathenable_9),
            .rxppathenable_10                                     (rxppathenable_10),
            .rxppathenable_11                                     (rxppathenable_11),

            .o_io12phyctrl_dqsmode                                (o_io12phyctrl_dqsmode),
            .o_n0_odt_seg_rotate_en                               (o_n0_odt_seg_rotate_en),
            .o_n1_odt_seg_rotate_en                               (o_n1_odt_seg_rotate_en),
            .o_odt_en                                             (o_odt_en),
            .o_odt_parken                                         (o_odt_parken),
            .o_odt_parken_dqsn                                    (o_odt_parken_dqsn),
            .o_phyctrl_avbb_avl_out_avm_readdata                  (o_phyctrl_avbb_avl_out_avm_readdata),
            .o_phyctrl_byte_rx_ctrl                               (o_phyctrl_byte_rx_ctrl),
            .o_phyctrl_byte_tx_ctrl                               (o_phyctrl_byte_tx_ctrl),
            .o_phyctrl_ddrcrcmdbustrain_ddrdqovrddata             (o_phyctrl_ddrcrcmdbustrain_ddrdqovrddata),
            .o_phyctrl_ddrcrcmdbustrain_ddrdqovrdmodeen           (o_phyctrl_ddrcrcmdbustrain_ddrdqovrdmodeen),
            .o_phyctrl_ckx16dqsn_to_bottom                        (o_phyctrl_ckx16dqsn_to_bottom),
            .o_phyctrl_ckx16dqsn_to_top                           (o_phyctrl_ckx16dqsn_to_top),
            .o_phyctrl_ckx16dqsp_to_bottom                        (o_phyctrl_ckx16dqsp_to_bottom),
            .o_phyctrl_ckx16dqsp_to_top                           (o_phyctrl_ckx16dqsp_to_top),
            .o_phyctrl_ddrcrdatacontrol0_enodtrotation            (o_phyctrl_ddrcrdatacontrol0_enodtrotation),
            .o_phyctrl_ddrcrdatacontrol4_unmatchedrx              (o_phyctrl_ddrcrdatacontrol4_unmatchedrx),
            .o_phyctrl_dfemuxout_0                                (o_phyctrl_dfemuxout_0),
            .o_phyctrl_dfemuxout_1                                (o_phyctrl_dfemuxout_1),
            .o_phyctrl_fifo_pack_select                           (o_phyctrl_fifo_pack_select),
            .o_phyctrl_fifo_read_enable_lower                     (o_phyctrl_fifo_read_enable_lower),
            .o_phyctrl_fifo_read_enable_upper                     (o_phyctrl_fifo_read_enable_upper),
            .o_phyctrl_gated_rx_phy_clk                           (o_phyctrl_gated_rx_phy_clk),
            .o_phyctrl_gated_tx_phy_clk                           (o_phyctrl_gated_tx_phy_clk),
            .o_phyctrl_o_occ_phy_clk                              (o_phyctrl_o_occ_phy_clk),
            .o_phyctrl_phyclk_notgated                            (o_phyctrl_phyclk_notgated),
            .o_phyctrl_rcvenmuxout_0                              (o_phyctrl_rcvenmuxout_0),
            .o_phyctrl_rcvenmuxout_1                              (o_phyctrl_rcvenmuxout_1),
            .o_phyctrl_rddata_en_dly                              (o_phyctrl_rddata_en_dly),
            .o_phyctrl_rddata_valid_lower                         (o_phyctrl_rddata_valid_lower),
            .o_phyctrl_rddata_valid_upper                         (o_phyctrl_rddata_valid_upper),
            .o_phyctrl_rx_d0cben                                  (o_phyctrl_rx_d0cben),
            .o_phyctrl_rx_d0drvsel                                (o_phyctrl_rx_d0drvsel),
            .o_phyctrl_rx_senseampen                              (o_phyctrl_rx_senseampen),
            .o_phyctrl_rxfifo_rb_avm_wr_pipestage                 (o_phyctrl_rxfifo_rb_avm_wr_pipestage),
            .o_phyctrl_sdll0_dqsn                                 (o_phyctrl_sdll0_dqsn),
            .o_phyctrl_sdll0_dqsp                                 (o_phyctrl_sdll0_dqsp),
            .o_phyctrl_sdll0_rx_d0pienable                        (o_phyctrl_sdll0_rx_d0pienable),
            .o_phyctrl_sdll0_rx_d0rcvenpre                        (o_phyctrl_sdll0_rx_d0rcvenpre),
            .o_phyctrl_sdll0_rx_d0reset                           (o_phyctrl_sdll0_rx_d0reset),
            .o_phyctrl_sdll1_dqsn                                 (o_phyctrl_sdll1_dqsn),
            .o_phyctrl_sdll1_dqsp                                 (o_phyctrl_sdll1_dqsp),
            .o_phyctrl_sdll1_rx_d0pienable                        (o_phyctrl_sdll1_rx_d0pienable),
            .o_phyctrl_sdll1_rx_d0rcvenpre                        (o_phyctrl_sdll1_rx_d0rcvenpre),
            .o_phyctrl_sdll1_rx_d0reset                           (o_phyctrl_sdll1_rx_d0reset),
            .o_phyctrl_trainreset                                 (o_phyctrl_trainreset),
            .o_phyctrl_tx_clkpi                                   (o_phyctrl_tx_clkpi),
            .o_phyctrl_tx_clkrefdivby2                            (o_phyctrl_tx_clkrefdivby2),
            .o_phyctrl_tx_picode0                                 (o_phyctrl_tx_picode0),
            .o_phyctrl_tx_picode1                                 (o_phyctrl_tx_picode1),
            .o_phyctrl_tx_picode2                                 (o_phyctrl_tx_picode2),
            .o_phyctrl_tx_picode3                                 (o_phyctrl_tx_picode3),
            .o_phyctrl_tx_picode4                                 (o_phyctrl_tx_picode4),
            .o_phyctrl_tx_picode5                                 (o_phyctrl_tx_picode5),
            .o_phyctrl_tx_picode6                                 (o_phyctrl_tx_picode6),
            .o_phyctrl_tx_picode7                                 (o_phyctrl_tx_picode7),
            .o_phyctrl_tx_picode8                                 (o_phyctrl_tx_picode8),
            .o_phyctrl_tx_picode9                                 (o_phyctrl_tx_picode9),
            .o_phyctrl_tx_picode10                                (o_phyctrl_tx_picode10),
            .o_phyctrl_tx_picode11                                (o_phyctrl_tx_picode11),
            .o_phyctrl_u_io12phyctrl_logic_o_phy_clk_gated        (o_phyctrl_u_io12phyctrl_logic_o_phy_clk_gated),
            .o_phyctrl_wr_dqs_en4                                 (o_phyctrl_wr_dqs_en4),
            .o_phyctrl_wr_dqs_en4_del                             (o_phyctrl_wr_dqs_en4_del),
            .o_phyctrl_wr_dqs_en5                                 (o_phyctrl_wr_dqs_en5),
            .o_phyctrl_wr_dqs_en5_del                             (o_phyctrl_wr_dqs_en5_del),
            .o_phyctrl_wr_dqs_en6                                 (o_phyctrl_wr_dqs_en6),
            .o_phyctrl_wr_dqs_en6_del                             (o_phyctrl_wr_dqs_en6_del),
            .o_phyctrl_wr_dqs_en7                                 (o_phyctrl_wr_dqs_en7),
            .o_phyctrl_wr_dqs_en7_del                             (o_phyctrl_wr_dqs_en7_del),
            .o_phyctrl_wrdata_en0                                 (o_phyctrl_wrdata_en0),
            .o_phyctrl_wrdata_en0_del                             (o_phyctrl_wrdata_en0_del),
            .o_phyctrl_wrdata_en1                                 (o_phyctrl_wrdata_en1),
            .o_phyctrl_wrdata_en1_del                             (o_phyctrl_wrdata_en1_del),
            .o_phyctrl_wrdata_en2                                 (o_phyctrl_wrdata_en2),
            .o_phyctrl_wrdata_en2_del                             (o_phyctrl_wrdata_en2_del),
            .o_phyctrl_wrdata_en3                                 (o_phyctrl_wrdata_en3),
            .o_phyctrl_wrdata_en3_del                             (o_phyctrl_wrdata_en3_del),
            .o_phyctrl_wrdata_en8                                 (o_phyctrl_wrdata_en8),
            .o_phyctrl_wrdata_en8_del                             (o_phyctrl_wrdata_en8_del),
            .o_phyctrl_wrdata_en9                                 (o_phyctrl_wrdata_en9),
            .o_phyctrl_wrdata_en9_del                             (o_phyctrl_wrdata_en9_del),
            .o_phyctrl_wrdata_en10                                (o_phyctrl_wrdata_en10),
            .o_phyctrl_wrdata_en10_del                            (o_phyctrl_wrdata_en10_del),
            .o_phyctrl_wrdata_en11                                (o_phyctrl_wrdata_en11),
            .o_phyctrl_wrdata_en11_del                            (o_phyctrl_wrdata_en11_del),
            .o_phyctrl_X1CounterDCCPin_00_DCCCount                (o_phyctrl_X1CounterDCCPin_00_DCCCount),
            .o_phyctrl_X1CounterDCCPin_01_DCCCount                (o_phyctrl_X1CounterDCCPin_01_DCCCount),
            .o_phyctrl_X1CounterDCCPin_02_DCCCount                (o_phyctrl_X1CounterDCCPin_02_DCCCount),
            .o_phyctrl_X1CounterDCCPin_03_DCCCount                (o_phyctrl_X1CounterDCCPin_03_DCCCount),
            .o_phyctrl_X1CounterDCCPin_04_DCCCount                (o_phyctrl_X1CounterDCCPin_04_DCCCount),
            .o_phyctrl_X1CounterDCCPin_05_DCCCount                (o_phyctrl_X1CounterDCCPin_05_DCCCount),
            .o_phyctrl_X1CounterDCCPin_06_DCCCount                (o_phyctrl_X1CounterDCCPin_06_DCCCount),
            .o_phyctrl_X1CounterDCCPin_07_DCCCount                (o_phyctrl_X1CounterDCCPin_07_DCCCount),
            .o_phyctrl_X1CounterDCCPin_08_DCCCount                (o_phyctrl_X1CounterDCCPin_08_DCCCount),
            .o_phyctrl_X1CounterDCCPin_09_DCCCount                (o_phyctrl_X1CounterDCCPin_09_DCCCount),
            .o_phyctrl_X1CounterDCCPin_10_DCCCount                (o_phyctrl_X1CounterDCCPin_10_DCCCount),
            .o_phyctrl_X1CounterDCCPin_11_DCCCount                (o_phyctrl_X1CounterDCCPin_11_DCCCount),
            .o_rxfifo_skew                                        (o_rxfifo_skew),
            .o_rxfifo_spare                                       (o_rxfifo_spare),
            .o_phyctrl_sdll0_rx_d0sdlparkvalue(o_phyctrl_sdll0_rx_d0sdlparkvalue),
            .o_phyctrl_sdll1_rx_d0sdlparkvalue(o_phyctrl_sdll1_rx_d0sdlparkvalue)
         );


      end else begin : gen_unused_byte_ctrl
         assign o_io12phyctrl_dqsmode                          = '0;
         assign o_n0_odt_seg_rotate_en                         = '0;
         assign o_n1_odt_seg_rotate_en                         = '0;
         assign o_odt_en                                       = '0;
         assign o_odt_parken                                   = '0;
         assign o_odt_parken_dqsn                              = '0;
         assign o_phyctrl_byte_rx_ctrl                         = '0;
         assign o_phyctrl_byte_tx_ctrl                         = '0;
         assign o_phyctrl_ddrcrcmdbustrain_ddrdqovrddata       = '0;
         assign o_phyctrl_ddrcrcmdbustrain_ddrdqovrdmodeen     = '0;
         assign o_phyctrl_ckx16dqsn_to_bottom                  = '0;
         assign o_phyctrl_ckx16dqsn_to_top                     = '0;
         assign o_phyctrl_ckx16dqsp_to_bottom                  = '0;
         assign o_phyctrl_ckx16dqsp_to_top                     = '0;
         assign o_phyctrl_ddrcrdatacontrol0_enodtrotation      = '0;
         assign o_phyctrl_ddrcrdatacontrol4_unmatchedrx        = '0;
         assign o_phyctrl_dfemuxout_0                          = '0;
         assign o_phyctrl_dfemuxout_1                          = '0;
         assign o_phyctrl_fifo_pack_select                     = '0;
         assign o_phyctrl_fifo_read_enable_lower               = '0;
         assign o_phyctrl_fifo_read_enable_upper               = '0;
         assign o_phyctrl_gated_rx_phy_clk                     = '0;
         assign o_phyctrl_gated_tx_phy_clk                     = '0;
         assign o_phyctrl_o_occ_phy_clk                        = '0;
         assign o_phyctrl_phyclk_notgated                      = '0;
         assign o_phyctrl_rcvenmuxout_0                        = '0;
         assign o_phyctrl_rcvenmuxout_1                        = '0;
         assign o_phyctrl_rddata_en_dly                        = '0;
         assign o_phyctrl_rddata_valid_lower                   = '0;
         assign o_phyctrl_rddata_valid_upper                   = '0;
         assign o_phyctrl_rx_d0cben                            = '0;
         assign o_phyctrl_rx_d0drvsel                          = '0;
         assign o_phyctrl_rx_senseampen                        = '0;
         assign o_phyctrl_rxfifo_rb_avm_wr_pipestage           = '0;
         assign o_phyctrl_sdll0_dqsn                           = '0;
         assign o_phyctrl_sdll0_dqsp                           = '0;
         assign o_phyctrl_sdll0_rx_d0pienable                  = '0;
         assign o_phyctrl_sdll0_rx_d0rcvenpre                  = '0;
         assign o_phyctrl_sdll0_rx_d0reset                     = '0;
         assign o_phyctrl_sdll1_dqsn                           = '0;
         assign o_phyctrl_sdll1_dqsp                           = '0;
         assign o_phyctrl_sdll1_rx_d0pienable                  = '0;
         assign o_phyctrl_sdll1_rx_d0rcvenpre                  = '0;
         assign o_phyctrl_sdll1_rx_d0reset                     = '0;
         assign o_phyctrl_trainreset                           = '0;
         assign o_phyctrl_tx_clkpi                             = '0;
         assign o_phyctrl_tx_clkrefdivby2                      = '0;
         assign o_phyctrl_tx_picode0                           = '0;
         assign o_phyctrl_tx_picode1                           = '0;
         assign o_phyctrl_tx_picode2                           = '0;
         assign o_phyctrl_tx_picode3                           = '0;
         assign o_phyctrl_tx_picode4                           = '0;
         assign o_phyctrl_tx_picode5                           = '0;
         assign o_phyctrl_tx_picode6                           = '0;
         assign o_phyctrl_tx_picode7                           = '0;
         assign o_phyctrl_tx_picode8                           = '0;
         assign o_phyctrl_tx_picode9                           = '0;
         assign o_phyctrl_tx_picode10                          = '0;
         assign o_phyctrl_tx_picode11                          = '0;
         assign o_phyctrl_u_io12phyctrl_logic_o_phy_clk_gated  = '0;
         assign o_phyctrl_wr_dqs_en4                           = '0;
         assign o_phyctrl_wr_dqs_en4_del                       = '0;
         assign o_phyctrl_wr_dqs_en5                           = '0;
         assign o_phyctrl_wr_dqs_en5_del                       = '0;
         assign o_phyctrl_wr_dqs_en6                           = '0;
         assign o_phyctrl_wr_dqs_en6_del                       = '0;
         assign o_phyctrl_wr_dqs_en7                           = '0;
         assign o_phyctrl_wr_dqs_en7_del                       = '0;
         assign o_phyctrl_wrdata_en0                           = '0;
         assign o_phyctrl_wrdata_en0_del                       = '0;
         assign o_phyctrl_wrdata_en1                           = '0;
         assign o_phyctrl_wrdata_en1_del                       = '0;
         assign o_phyctrl_wrdata_en2                           = '0;
         assign o_phyctrl_wrdata_en2_del                       = '0;
         assign o_phyctrl_wrdata_en3                           = '0;
         assign o_phyctrl_wrdata_en3_del                       = '0;
         assign o_phyctrl_wrdata_en8                           = '0;
         assign o_phyctrl_wrdata_en8_del                       = '0;
         assign o_phyctrl_wrdata_en9                           = '0;
         assign o_phyctrl_wrdata_en9_del                       = '0;
         assign o_phyctrl_wrdata_en10                          = '0;
         assign o_phyctrl_wrdata_en10_del                      = '0;
         assign o_phyctrl_wrdata_en11                          = '0;
         assign o_phyctrl_wrdata_en11_del                      = '0;
         assign o_phyctrl_X1CounterDCCPin_00_DCCCount          = '0;
         assign o_phyctrl_X1CounterDCCPin_01_DCCCount          = '0;
         assign o_phyctrl_X1CounterDCCPin_02_DCCCount          = '0;
         assign o_phyctrl_X1CounterDCCPin_03_DCCCount          = '0;
         assign o_phyctrl_X1CounterDCCPin_04_DCCCount          = '0;
         assign o_phyctrl_X1CounterDCCPin_05_DCCCount          = '0;
         assign o_phyctrl_X1CounterDCCPin_06_DCCCount          = '0;
         assign o_phyctrl_X1CounterDCCPin_07_DCCCount          = '0;
         assign o_phyctrl_X1CounterDCCPin_08_DCCCount          = '0;
         assign o_phyctrl_X1CounterDCCPin_09_DCCCount          = '0;
         assign o_phyctrl_X1CounterDCCPin_10_DCCCount          = '0;
         assign o_phyctrl_X1CounterDCCPin_11_DCCCount          = '0;
         assign o_rxfifo_skew                                  = '0;
         assign o_rxfifo_spare                                 = '0;
         assign o_phyctrl_avbb_avl_out_avm_readdata            = '0;
         assign o_phyctrl_sdll0_rx_d0sdlparkvalue              = '0;
         assign o_phyctrl_sdll1_rx_d0sdlparkvalue              = '0;
         assign o_phyctrl_parkclk_to_rxtop_n0_pl1              = '0;
         assign o_phyctrl_parkclk_to_rxtop_n1_pl1              = '0;
         assign o_phyctrl_trainreset_vcoclk_sync_n             = '0;
         assign o_phyctrl_vcoclk_compactive_gated              = '0;




      end
   endgenerate
         
endmodule


