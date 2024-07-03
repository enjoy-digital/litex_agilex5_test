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


module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_byte #(

   parameter ID                                               = 0,


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











   localparam PORT_PHY_TX_CTRL_WIDTH                          = 2,
   localparam PORT_PHY_TX_PICODE_WIDTH                        = 4,
   localparam PORT_PHY_BYTE_TX_CTRL_WIDTH                     = 32,
   localparam PORT_PHY_FIFO_READ_ENABLE_WIDTH                 = 2,
   localparam PORT_PHY_BYTE_RX_CTRL_WIDTH                     = 32,
   localparam PORT_PHY_TX_CLKPI_WIDTH                         = 12,
   localparam PORT_PHY_SDLL_DQS_WIDTH                         = 6,
   localparam PORT_PHY_AVBB_AVL_ADDRESS_WIDTH                 = 22,
   localparam PORT_PHY_AVBB_AVL_DATA_WIDTH                    = 32,
   localparam PORT_PHY_RX_SENSEAMPEN_WIDTH                    = 12,

   localparam PORT_IO_PHY_PAD_SIG_WIDTH                       = 12,
   localparam PORT_O_PHY_PAD_DOE_WIDTH                        = 12,

   localparam PORT_PHY_GPIO_D_WIDTH                           = 12,
   localparam PORT_PHY_DATA_WIDTH                             = 48,

   localparam INTF_PA_TO_B_WIDTH = PORT_PHY_DATA_WIDTH+1,
   localparam INTF_B_TO_PA_WIDTH = PORT_PHY_DATA_WIDTH+1,
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
                                                                PORT_PHYCTRL_DQOVRDDATA_WIDTH +
                                                                PORT_PHYCTRL_DQOVRDMODEEN_WIDTH +
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
   localparam INTF_SEQ_AVBB_INTF_WIDTH                        = PORT_PHY_AVBB_AVL_ADDRESS_WIDTH + PORT_PHY_AVBB_AVL_DATA_WIDTH + 4,
   localparam INTF_B_TO_BUFFS_WIDTH                           = PORT_IO_PHY_PAD_SIG_WIDTH + PORT_O_PHY_PAD_DOE_WIDTH,
   localparam INTF_BUFFS_TO_B_WIDTH                           = PORT_IO_PHY_PAD_SIG_WIDTH


) (
   input     logic    [INTF_SEQ_AVBB_INTF_WIDTH-1:0]            seq_avbb,

   input     logic    [INTF_BC_TO_B_WIDTH-1:0]                  bc_to_b,
   output    logic    [INTF_B_TO_BC_WIDTH-1:0]                  b_to_bc,

   input     wire     [INTF_BUFFS_TO_B_WIDTH-1:0]               buffs_to_b,
   output    wire     [INTF_B_TO_BUFFS_WIDTH-1:0]               b_to_buffs,

   input    logic     [INTF_PA_TO_B_WIDTH-1:0]                  pa_to_b,
   output   logic     [INTF_B_TO_PA_WIDTH-1:0]                  b_to_pa
);
   timeunit 1ns;
   timeprecision 1ps;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_byte::*;

   // Declare wires
   logic    [PORT_PHYCTRL_DQSMODE_WIDTH-1:0]                    i_dqsmode;
   logic    [PORT_PHYCTRL_ODT_SEG_ROTATE_WIDTH-1:0]             i_n0_odt_seg_rotate_en;
   logic    [PORT_PHYCTRL_ODT_SEG_ROTATE_WIDTH-1:0]             i_n1_odt_seg_rotate_en;
   logic    [PORT_PHYCTRL_ODTEN_WIDTH-1:0]                      i_odt_en;
   logic    [PORT_PHYCTRL_ODTEN_WIDTH-1:0]                      i_odt_parken;
   logic    [PORT_PHYCTRL_ODTEN_WIDTH-1:0]                      i_odt_parken_dqsn;
   logic    [PORT_PHYCTRL_BYTE_RX_CTRL_WIDTH-1:0]               i_phy_byte_rx_ctrl;
   logic    [PORT_PHYCTRL_BYTE_TX_CTRL_WIDTH-1:0]               i_phy_byte_tx_ctrl;
   logic    [PORT_PHYCTRL_DQOVRDDATA_WIDTH-1:0]                 i_phy_ddrcrcmdbustrain_ddrdqovrddata;
   logic    [PORT_PHYCTRL_DQOVRDMODEEN_WIDTH-1:0]               i_phy_ddrcrcmdbustrain_ddrdqovrdmodeen;
   logic                                                        i_phy_ddrcrdatacontrol0_enodtrotation;
   logic                                                        i_phy_ddrcrdatacontrol4_unmatchedrx;
   logic                                                        i_phy_dfi_dram_clock_disable;
   logic                                                        i_phy_fifo_pack_select;
   logic    [PORT_PHYCTRL_FIFO_READ_ENABLE_WIDTH-1:0]           i_phy_fifo_read_enable_lower;
   logic    [PORT_PHYCTRL_FIFO_READ_ENABLE_WIDTH-1:0]           i_phy_fifo_read_enable_upper;
   logic    [PORT_PHY_GPIO_D_WIDTH-1:0]                         i_phy_gpio_dout;
   logic    [PORT_PHY_GPIO_D_WIDTH-1:0]                         i_phy_gpio_dout_sel;
   logic    [PORT_PHY_GPIO_D_WIDTH-1:0]                         i_phy_gpio_oe;
   logic                                                        i_phy_occ_phy_clk;
   logic                                                        i_phy_phy_clk_gated;
   logic                                                        i_phy_phy_reset_n;
   logic    [PORT_PHYCTRL_RDDATA_EN_WIDTH-1:0]                  i_phy_rddata_en_dly;
   logic    [PORT_PHYCTRL_RX_D0CBEN_WIDTH-1:0]                  i_phy_rx_d0cben;
   logic    [PORT_PHYCTRL_RX_D0DRVSEL_WIDTH-1:0]                i_phy_rx_d0drvsel;
   logic    [PORT_PHYCTRL_DFEMUXOUT_WIDTH-1:0]                  i_phy_rx_dfemuxout_0;
   logic    [PORT_PHYCTRL_DFEMUXOUT_WIDTH-1:0]                  i_phy_rx_dfemuxout_1;
   logic    [PORT_PHYCTRL_RCVENMUXOUT_WIDTH-1:0]                i_phy_rx_rcvenmuxout_0;
   logic    [PORT_PHYCTRL_RCVENMUXOUT_WIDTH-1:0]                i_phy_rx_rcvenmuxout_1;
   logic    [PORT_PHYCTRL_RX_SENSEAMPEN_WIDTH-1:0]              i_phy_rx_senseampen;
   logic                                                        i_phy_rxclk_gated;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                   i_phy_sdll0_dqsn;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                   i_phy_sdll0_dqsp;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                   i_phy_sdll0_rx_d0pienable;
   logic                                                        i_phy_sdll0_rx_d0rcvenpre;
   logic                                                        i_phy_sdll0_rx_d0reset;
   logic                                                        i_phy_sdll0_rx_d0sdlparkvalue;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                   i_phy_sdll1_dqsn;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                   i_phy_sdll1_dqsp;
   logic    [PORT_PHYCTRL_SDLL_DQS_WIDTH-1:0]                   i_phy_sdll1_rx_d0pienable;
   logic                                                        i_phy_sdll1_rx_d0rcvenpre;
   logic                                                        i_phy_sdll1_rx_d0reset;
   logic                                                        i_phy_sdll1_rx_d0sdlparkvalue;
   logic                                                        i_phy_trainreset;
   logic    [PORT_PHYCTRL_TX_CLKPI_WIDTH-1:0]                   i_phy_tx_clkpi;
   logic                                                        i_phy_tx_clkrefdivby2;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode0;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode1;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode2;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode3;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode4;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode5;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode6;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode7;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode8;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode9;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode10;
   logic    [PORT_PHYCTRL_TX_PICODE_WIDTH-1:0]                  i_phy_tx_picode11;
   logic    [PORT_PHYCTRL_DATA_WIDTH-1:0]                       i_phy_tx_wr_data;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wr_dqs_en4;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wr_dqs_en4_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wr_dqs_en5;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wr_dqs_en5_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wr_dqs_en6;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wr_dqs_en6_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wr_dqs_en7;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wr_dqs_en7_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en0;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en0_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en1;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en1_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en2;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en2_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en3;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en3_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en8;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en8_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en9;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en9_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en10;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en10_del;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en11;
   logic    [PORT_PHYCTRL_TX_CTRL_WIDTH-1:0]                    i_phy_tx_wrdata_en11_del;
   logic                                                        i_phy_txclk_gated;
   logic                                                        i_phyclk_notgated;
   logic    [PORT_PHYCTRL_RXFIFO_AVM_PIPSTAGE_WIDTH-1:0]        i_rxfifo_rb_avm_wr_pipestage;
   logic                                                        i_rxfifo_skew;
   logic    [PORT_PHYCTRL_RXFIFO_SPARE_WIDTH-1:0]               i_rxfifo_spare;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_00_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_01_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_02_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_03_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_04_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_05_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_06_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_07_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_08_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_09_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_10_DCCCount;
   logic    [PORT_PHYCTRL_DCC_CNT_WIDTH-1:0]                    i_X1CounterDCCPin_11_DCCCount;
   logic    [PORT_IO_PHY_PAD_SIG_WIDTH-1:0]                     io_phy_pad_sig_bidir_in;
   logic    [PORT_PHYCTRL_PARKCLK_WIDTH-1:0]                    i_phy_parkclk_to_rxtop_n0_pl1;
   logic    [PORT_PHYCTRL_PARKCLK_WIDTH-1:0]                    i_phy_parkclk_to_rxtop_n1_pl1;
   logic                                                        i_phy_trainreset_vcoclk_sync_n;
   logic                                                        i_phy_vcoclk_compactive_gated;


   logic    [PORT_IO_PHY_PAD_SIG_WIDTH-1:0]                     io_phy_pad_sig_bidir_out;
   logic    [PORT_PHYCTRL_RXDFE_T0_WIDTH-1:0]                   o_DDRCrRxEQRank01_RxDFETap0Rank0;
   logic    [PORT_PHYCTRL_RXDFE_T0_WIDTH-1:0]                   o_DDRCrRxEQRank01_RxDFETap0Rank1;
   logic    [PORT_PHYCTRL_RXDFE_T1_WIDTH-1:0]                   o_DDRCrRxEQRank01_RxDFETap1Rank0;
   logic    [PORT_PHYCTRL_RXDFE_T1_WIDTH-1:0]                   o_DDRCrRxEQRank01_RxDFETap1Rank1;
   logic    [PORT_PHYCTRL_RXDFE_T2_WIDTH-1:0]                   o_DDRCrRxEQRank01_RxDFETap2Rank0;
   logic    [PORT_PHYCTRL_RXDFE_T2_WIDTH-1:0]                   o_DDRCrRxEQRank01_RxDFETap2Rank1;
   logic    [PORT_PHYCTRL_RXDFE_T3_WIDTH-1:0]                   o_DDRCrRxEQRank01_RxDFETap3Rank0;
   logic    [PORT_PHYCTRL_RXDFE_T3_WIDTH-1:0]                   o_DDRCrRxEQRank01_RxDFETap3Rank1;
   logic    [PORT_PHYCTRL_RXDFE_T0_WIDTH-1:0]                   o_DDRCrRxEQRank23_RxDFETap0Rank2;
   logic    [PORT_PHYCTRL_RXDFE_T0_WIDTH-1:0]                   o_DDRCrRxEQRank23_RxDFETap0Rank3;
   logic    [PORT_PHYCTRL_RXDFE_T1_WIDTH-1:0]                   o_DDRCrRxEQRank23_RxDFETap1Rank2;
   logic    [PORT_PHYCTRL_RXDFE_T1_WIDTH-1:0]                   o_DDRCrRxEQRank23_RxDFETap1Rank3;
   logic    [PORT_PHYCTRL_RXDFE_T2_WIDTH-1:0]                   o_DDRCrRxEQRank23_RxDFETap2Rank2;
   logic    [PORT_PHYCTRL_RXDFE_T2_WIDTH-1:0]                   o_DDRCrRxEQRank23_RxDFETap2Rank3;
   logic    [PORT_PHYCTRL_RXDFE_T3_WIDTH-1:0]                   o_DDRCrRxEQRank23_RxDFETap3Rank2;
   logic    [PORT_PHYCTRL_RXDFE_T3_WIDTH-1:0]                   o_DDRCrRxEQRank23_RxDFETap3Rank3;
   logic                                                        o_from_phy_rx_x16dqsn_p4;
   logic                                                        o_from_phy_rx_x16dqsp_p4;
   logic    [PORT_PHYCTRL_MIPI_CTRL_WIDTH-1:0]                  o_mipi_rb_rxdly_direct_ctrl;
   logic    [PORT_PHYCTRL_MIPI_DIFF_EN_WIDTH-1:0]               o_mipi_rx_diff_en;
   logic    [PORT_PHYCTRL_MIPI_DPHYLPRXEN_WIDTH-1:0]            o_mipi_rx_dphylprxen;
   logic    [PORT_PHY_DATA_WIDTH-1:0]                           o_phy_core_data;
   logic                                                        o_phy_cr_iamca_00;
   logic                                                        o_phy_cr_iamca_01;
   logic                                                        o_phy_cr_iamca_02;
   logic                                                        o_phy_cr_iamca_03;
   logic                                                        o_phy_cr_iamca_04;
   logic                                                        o_phy_cr_iamca_05;
   logic                                                        o_phy_cr_iamca_06;
   logic                                                        o_phy_cr_iamca_07;
   logic                                                        o_phy_cr_iamca_08;
   logic                                                        o_phy_cr_iamca_09;
   logic                                                        o_phy_cr_iamca_10;
   logic                                                        o_phy_cr_iamca_11;
   logic    [PORT_PHY_GPIO_D_WIDTH-1:0]                         o_phy_gpio_din;
   logic                                                        o_phy_io_pad_doe_0;
   logic                                                        o_phy_io_pad_doe_1;
   logic                                                        o_phy_io_pad_doe_2;
   logic                                                        o_phy_io_pad_doe_3;
   logic                                                        o_phy_io_pad_doe_4;
   logic                                                        o_phy_io_pad_doe_5;
   logic                                                        o_phy_io_pad_doe_6;
   logic                                                        o_phy_io_pad_doe_7;
   logic                                                        o_phy_io_pad_doe_8;
   logic                                                        o_phy_io_pad_doe_9;
   logic                                                        o_phy_io_pad_doe_10;
   logic                                                        o_phy_io_pad_doe_11;
   logic                                                        o_phy_rx_dqs_amp_p5;
   logic                                                        o_phy_rx_dqs_amp_p7;
   logic                                                        o_phy_rx_dqs_n4;
   logic                                                        o_phy_rx_dqs_n6;
   logic                                                        o_phy_rx_dqs_p4;
   logic                                                        o_phy_rx_dqs_p6;
   logic                                                        o_phy_rx_fwdclk;
   logic    [PORT_PHYCTRL_DATA_WIDTH-1:0]                       o_phy_tx_wr_data_pl;
   logic                                                        o_rxdphylprxen_0;
   logic                                                        o_rxdphylprxen_1;
   logic                                                        o_rxdphylprxen_2;
   logic                                                        o_rxdphylprxen_3;
   logic                                                        o_rxdphylprxen_4;
   logic                                                        o_rxdphylprxen_5;
   logic                                                        o_rxdphylprxen_6;
   logic                                                        o_rxdphylprxen_7;
   logic                                                        o_rxdphylprxen_8;
   logic                                                        o_rxdphylprxen_9;
   logic                                                        o_rxdphylprxen_10;
   logic                                                        o_rxdphylprxen_11;
   logic                                                        o_rxlvdien_0;
   logic                                                        o_rxlvdien_1;
   logic                                                        o_rxlvdien_2;
   logic                                                        o_rxlvdien_3;
   logic                                                        o_rxlvdien_4;
   logic                                                        o_rxlvdien_5;
   logic                                                        o_rxlvdien_6;
   logic                                                        o_rxlvdien_7;
   logic                                                        o_rxlvdien_8;
   logic                                                        o_rxlvdien_9;
   logic                                                        o_rxlvdien_10;
   logic                                                        o_rxlvdien_11;
   logic                                                        o_rzq_en;
   logic    [PORT_PHYCTRL_TX_MODECTRL_WIDTH-1:0]                o_tx_modectrl_4;
   logic                                                        rxnpathenable_0;
   logic                                                        rxnpathenable_1;
   logic                                                        rxnpathenable_2;
   logic                                                        rxnpathenable_3;
   logic                                                        rxnpathenable_4;
   logic                                                        rxnpathenable_5;
   logic                                                        rxnpathenable_6;
   logic                                                        rxnpathenable_7;
   logic                                                        rxnpathenable_8;
   logic                                                        rxnpathenable_9;
   logic                                                        rxnpathenable_10;
   logic                                                        rxnpathenable_11;
   logic                                                        rxppathenable_0;
   logic                                                        rxppathenable_1;
   logic                                                        rxppathenable_2;
   logic                                                        rxppathenable_3;
   logic                                                        rxppathenable_4;
   logic                                                        rxppathenable_5;
   logic                                                        rxppathenable_6;
   logic                                                        rxppathenable_7;
   logic                                                        rxppathenable_8;
   logic                                                        rxppathenable_9;
   logic                                                        rxppathenable_10;
   logic                                                        rxppathenable_11;

   logic    [PORT_PHY_AVBB_AVL_ADDRESS_WIDTH-1:0]               i_phy_avbb_avl_in_avm_address;
   logic                                                        i_phy_avbb_avl_in_avm_read;
   logic                                                        i_phy_avbb_avl_in_avm_write;
   logic    [PORT_PHY_AVBB_AVL_DATA_WIDTH-1:0]                  i_phy_avbb_avl_in_avm_writedata;
   logic                                                        i_phy_avbb_avl_in_clk;
   logic                                                        i_phy_avbb_avl_in_rst_n;
   logic    [PORT_PHY_AVBB_AVL_DATA_WIDTH-1:0]                  o_phy_avbb_avl_out_avm_readdata;

   // Assign Wires to Interfaces
   //inputs
   assign { i_phy_tx_wrdata_en0,
            i_phy_tx_wrdata_en1,
            i_phy_tx_wrdata_en2,
            i_phy_tx_wrdata_en3,
            i_phy_tx_wr_dqs_en4,
            i_phy_tx_wr_dqs_en5,
            i_phy_tx_wr_dqs_en6,
            i_phy_tx_wr_dqs_en7,
            i_phy_tx_wrdata_en8,
            i_phy_tx_wrdata_en9,
            i_phy_tx_wrdata_en10,
            i_phy_tx_wrdata_en11,
            i_phy_tx_wrdata_en0_del, i_phy_tx_wrdata_en1_del, i_phy_tx_wrdata_en2_del, i_phy_tx_wrdata_en3_del, i_phy_tx_wr_dqs_en4_del, i_phy_tx_wr_dqs_en5_del, i_phy_tx_wr_dqs_en6_del, i_phy_tx_wr_dqs_en7_del, i_phy_tx_wrdata_en8_del, i_phy_tx_wrdata_en9_del, i_phy_tx_wrdata_en10_del, i_phy_tx_wrdata_en11_del,
            i_phy_tx_picode0, i_phy_tx_picode1, i_phy_tx_picode2, i_phy_tx_picode3, i_phy_tx_picode4, i_phy_tx_picode5, i_phy_tx_picode6, i_phy_tx_picode7, i_phy_tx_picode8, i_phy_tx_picode9, i_phy_tx_picode10, i_phy_tx_picode11,
            i_phy_fifo_pack_select, i_phy_fifo_read_enable_lower, i_phy_fifo_read_enable_upper,
            i_phy_trainreset,
            i_phy_byte_tx_ctrl, i_phy_byte_rx_ctrl,
            i_phy_txclk_gated, i_phy_rxclk_gated,
            i_phy_tx_clkrefdivby2, i_phy_tx_clkpi,
            i_phy_sdll0_dqsp, i_phy_sdll0_dqsn,
            i_phy_sdll1_dqsp, i_phy_sdll1_dqsn,
            i_phy_rx_senseampen,
            i_phy_sdll0_rx_d0pienable, i_phy_sdll0_rx_d0rcvenpre, i_phy_sdll0_rx_d0reset, 
            i_phy_sdll1_rx_d0pienable, i_phy_sdll1_rx_d0rcvenpre, i_phy_sdll1_rx_d0reset,
            i_dqsmode,
            i_n0_odt_seg_rotate_en,
            i_n1_odt_seg_rotate_en,
            i_odt_en,
            i_odt_parken,
            i_odt_parken_dqsn,
            i_phy_ddrcrcmdbustrain_ddrdqovrddata,
            i_phy_ddrcrcmdbustrain_ddrdqovrdmodeen,           
            i_phy_rddata_en_dly,
            i_phy_rx_d0cben,
            i_phy_rx_d0drvsel,
            i_phy_ddrcrdatacontrol0_enodtrotation,
            i_phy_ddrcrdatacontrol4_unmatchedrx,
            i_phy_occ_phy_clk,
            i_phy_phy_clk_gated,
            i_phyclk_notgated, 
            i_phy_rx_rcvenmuxout_0,
            i_phy_rx_rcvenmuxout_1,
            i_phy_rx_dfemuxout_0,
            i_phy_rx_dfemuxout_1,
            i_X1CounterDCCPin_00_DCCCount,
            i_X1CounterDCCPin_01_DCCCount,
            i_X1CounterDCCPin_02_DCCCount,
            i_X1CounterDCCPin_03_DCCCount,
            i_X1CounterDCCPin_04_DCCCount,
            i_X1CounterDCCPin_05_DCCCount,
            i_X1CounterDCCPin_06_DCCCount,
            i_X1CounterDCCPin_07_DCCCount,
            i_X1CounterDCCPin_08_DCCCount,
            i_X1CounterDCCPin_09_DCCCount,
            i_X1CounterDCCPin_10_DCCCount,
            i_X1CounterDCCPin_11_DCCCount,
            i_rxfifo_rb_avm_wr_pipestage,
            i_rxfifo_skew,
            i_rxfifo_spare,
            i_phy_sdll0_rx_d0sdlparkvalue,
            i_phy_sdll1_rx_d0sdlparkvalue
            } = bc_to_b;

   assign { i_phy_avbb_avl_in_rst_n,
            i_phy_avbb_avl_in_clk,
            i_phy_avbb_avl_in_avm_write,
            i_phy_avbb_avl_in_avm_read,
            i_phy_avbb_avl_in_avm_address,
            i_phy_avbb_avl_in_avm_writedata} = seq_avbb;

   assign {i_phy_tx_wr_data,i_phy_dfi_dram_clock_disable} = pa_to_b;

   always_comb begin
      
      io_phy_pad_sig_bidir_in[11:8] = buffs_to_b[11:8];
      io_phy_pad_sig_bidir_in[   6] = buffs_to_b[   6];
      io_phy_pad_sig_bidir_in[ 4:0] = buffs_to_b[ 4:0];


      if (PIN_RX_USAGE[ID*12+5] == "PIN5_RX_USAGE_DQS")
      begin
         // synthesis translate_off
         io_phy_pad_sig_bidir_in[5] = (buffs_to_b[4] ===1'bz) ? 1'bz : !buffs_to_b[4];
         // synthesis translate_on
      end
      else
      begin
         io_phy_pad_sig_bidir_in[5] = buffs_to_b[5];
      end

      if (PIN_RX_USAGE[ID*12+7] == "PIN7_RX_USAGE_DQS")
      begin
         // synthesis translate_off
         io_phy_pad_sig_bidir_in[7] = (buffs_to_b[6] ===1'bz) ? 1'bz : !buffs_to_b[6];
         // synthesis translate_on
      end
      else
      begin
         io_phy_pad_sig_bidir_in[7] = buffs_to_b[7];
      end
   end
   
   assign b_to_bc = {o_phy_avbb_avl_out_avm_readdata,
                     o_phy_rx_dqs_p4,
                     o_phy_rx_dqs_n4,
                     o_phy_rx_dqs_amp_p5,
                     o_phy_rx_dqs_p6,
                     o_phy_rx_dqs_n6,
                     o_phy_rx_dqs_amp_p7,
                     o_from_phy_rx_x16dqsp_p4,
                     o_from_phy_rx_x16dqsn_p4,
                     o_rxdphylprxen_0,                            
                     o_rxdphylprxen_1,                            
                     o_rxdphylprxen_2,                            
                     o_rxdphylprxen_3,                            
                     o_rxdphylprxen_4,                            
                     o_rxdphylprxen_5,                            
                     o_rxdphylprxen_6,                            
                     o_rxdphylprxen_7,                            
                     o_rxdphylprxen_8,                            
                     o_rxdphylprxen_9,                            
                     o_rxdphylprxen_10,                           
                     o_rxdphylprxen_11,                           
                     o_rxlvdien_0,                                
                     o_rxlvdien_1,                                
                     o_rxlvdien_2,                                
                     o_rxlvdien_3,                                
                     o_rxlvdien_4,                                
                     o_rxlvdien_5,                                
                     o_rxlvdien_6,                                
                     o_rxlvdien_7,                                
                     o_rxlvdien_8,                                
                     o_rxlvdien_9,                                
                     o_rxlvdien_10,                               
                     o_rxlvdien_11,                               
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
                     o_DDRCrRxEQRank01_RxDFETap0Rank0,            
                     o_DDRCrRxEQRank01_RxDFETap0Rank1,            
                     o_DDRCrRxEQRank01_RxDFETap1Rank0,            
                     o_DDRCrRxEQRank01_RxDFETap1Rank1,            
                     o_DDRCrRxEQRank01_RxDFETap2Rank0,            
                     o_DDRCrRxEQRank01_RxDFETap2Rank1,            
                     o_DDRCrRxEQRank01_RxDFETap3Rank0,            
                     o_DDRCrRxEQRank01_RxDFETap3Rank1,            
                     o_DDRCrRxEQRank23_RxDFETap0Rank2,            
                     o_DDRCrRxEQRank23_RxDFETap0Rank3,            
                     o_DDRCrRxEQRank23_RxDFETap1Rank2,            
                     o_DDRCrRxEQRank23_RxDFETap1Rank3,            
                     o_DDRCrRxEQRank23_RxDFETap2Rank2,            
                     o_DDRCrRxEQRank23_RxDFETap2Rank3,            
                     o_DDRCrRxEQRank23_RxDFETap3Rank2,            
                     o_DDRCrRxEQRank23_RxDFETap3Rank3,            
                     o_mipi_rb_rxdly_direct_ctrl,                 
                     o_mipi_rx_diff_en,                           
                     o_mipi_rx_dphylprxen,                        
                     o_tx_modectrl_4,                             
                     o_phy_io_pad_doe_11,
                     o_phy_io_pad_doe_10,
                     o_phy_io_pad_doe_9,
                     o_phy_io_pad_doe_8,
                     o_phy_io_pad_doe_7,
                     o_phy_io_pad_doe_6,
                     o_phy_io_pad_doe_5,
                     o_phy_io_pad_doe_4,
                     o_phy_io_pad_doe_3,
                     o_phy_io_pad_doe_2,
                     o_phy_io_pad_doe_1,
                     o_phy_io_pad_doe_0,
                     o_phy_cr_iamca_11,
                     o_phy_cr_iamca_10,
                     o_phy_cr_iamca_09,
                     o_phy_cr_iamca_08,
                     o_phy_cr_iamca_07,
                     o_phy_cr_iamca_06,
                     o_phy_cr_iamca_05,
                     o_phy_cr_iamca_04,
                     o_phy_cr_iamca_03,
                     o_phy_cr_iamca_02,
                     o_phy_cr_iamca_01,
                     o_phy_cr_iamca_00,
                     o_phy_tx_wr_data_pl
                     };

   assign b_to_pa = {o_phy_core_data, o_phy_rx_fwdclk};

   assign b_to_buffs = {io_phy_pad_sig_bidir_out,
                        o_phy_io_pad_doe_11,
                        o_phy_io_pad_doe_10,
                        o_phy_io_pad_doe_9,
                        o_phy_io_pad_doe_8,
                        o_phy_io_pad_doe_7,
                        o_phy_io_pad_doe_6,
                        o_phy_io_pad_doe_5,
                        o_phy_io_pad_doe_4,
                        o_phy_io_pad_doe_3,
                        o_phy_io_pad_doe_2,
                        o_phy_io_pad_doe_1,
                        o_phy_io_pad_doe_0};

`define byte_pinXY_diff_params(X,Y)                                                              \
            .pin``X````Y``_diff_bus_hold              (PIN_DIFF_BUS_HOLD       [ID*6+``X``/2]),  \
            .pin``X````Y``_diff_io_standard           (PIN_DIFF_IO_STANDARD    [ID*6+``X``/2]),  \
            .pin``X````Y``_diff_rx_equalization       (PIN_DIFF_RX_EQUALIZATION[ID*6+``X``/2]),  \
            .pin``X````Y``_diff_rzq_id                (PIN_DIFF_RZQ_ID         [ID*6+``X``/2]),  \
            .pin``X````Y``_diff_schmitt_trigger       (PIN_DIFF_SCHMITT_TRIGGER[ID*6+``X``/2]),  \
            .pin``X````Y``_diff_termination           (PIN_DIFF_TERMINATION    [ID*6+``X``/2]),  \
            .pin``X````Y``_diff_usage_mode            (PIN_DIFF_USAGE_MODE     [ID*6+``X``/2]),  \
            .pin``X````Y``_diff_vref                  (PIN_DIFF_VREF           [ID*6+``X``/2]),  \
            .pin``X````Y``_diff_weak_pull_down        (PIN_DIFF_WEAK_PULL_DOWN [ID*6+``X``/2]),  \
            .pin``X````Y``_diff_weak_pull_up          (PIN_DIFF_WEAK_PULL_UP   [ID*6+``X``/2]),  
`define byte_pinX_params(X)                                                                  \
            .pin``X``_direction                   (PIN_DIRECTION             [ID*12+``X``]), \
            .pin``X``_pcomp                       (PIN_PCOMP                 [ID*12+``X``]), \
            .pin``X``_rx_bus_hold                 (PIN_RX_BUS_HOLD           [ID*12+``X``]), \
            .pin``X``_rx_equalization             (PIN_RX_EQUALIZATION       [ID*12+``X``]), \
            .pin``X``_rx_gpio                     (PIN_RX_GPIO               [ID*12+``X``]), \
            .pin``X``_rx_io_standard              (PIN_RX_IO_STANDARD        [ID*12+``X``]), \
            .pin``X``_rx_rzq_id                   (PIN_RX_RZQ_ID             [ID*12+``X``]), \
            .pin``X``_rx_sampler_mode             (PIN_RX_SAMPLER_MODE       [ID*12+``X``]), \
            .pin``X``_rx_schmitt_trigger          (PIN_RX_SCHMITT_TRIGGER    [ID*12+``X``]), \
            .pin``X``_rx_termination              (PIN_RX_TERMINATION        [ID*12+``X``]), \
            .pin``X``_rx_usage                    (PIN_RX_USAGE              [ID*12+``X``]), \
            .pin``X``_rx_usage_mode               (PIN_RX_USAGE_MODE         [ID*12+``X``]), \
            .pin``X``_rx_vref                     (PIN_RX_VREF               [ID*12+``X``]), \
            .pin``X``_rx_weak_pull_down           (PIN_RX_WEAK_PULL_DOWN     [ID*12+``X``]), \
            .pin``X``_rx_weak_pull_up             (PIN_RX_WEAK_PULL_UP       [ID*12+``X``]), \
            .pin``X``_tx_equalization             (PIN_TX_EQUALIZATION       [ID*12+``X``]), \
            .pin``X``_tx_io_standard              (PIN_TX_IO_STANDARD        [ID*12+``X``]), \
            .pin``X``_tx_open_drain               (PIN_TX_OPEN_DRAIN         [ID*12+``X``]), \
            .pin``X``_tx_rate                     (PIN_TX_RATE               [ID*12+``X``]), \
            .pin``X``_tx_rzq_id                   (PIN_TX_RZQ_ID             [ID*12+``X``]), \
            .pin``X``_tx_slew_rate                (PIN_TX_SLEW_RATE          [ID*12+``X``]), \
            .pin``X``_tx_termination              (PIN_TX_TERMINATION        [ID*12+``X``]), \
            .pin``X``_tx_usage                    (PIN_TX_USAGE              [ID*12+``X``]), \
            .pin``X``_tx_usage_mode               (PIN_TX_USAGE_MODE         [ID*12+``X``]), 

   generate 
      if (IS_USED[ID]) begin : gen_used_byte
         tennm_byte # (
            .base_address                     (BASE_ADDRESS[ID]),
            `byte_pinXY_diff_params(0,1)
            `byte_pinXY_diff_params(2,3)
            `byte_pinXY_diff_params(4,5)
            `byte_pinXY_diff_params(6,7)
            `byte_pinXY_diff_params(8,9)
            `byte_pinXY_diff_params(10,11)
            `byte_pinX_params(0)
            `byte_pinX_params(1)
            `byte_pinX_params(2)
            `byte_pinX_params(3)
            `byte_pinX_params(4)
            `byte_pinX_params(5)
            `byte_pinX_params(6)
            `byte_pinX_params(7)
            `byte_pinX_params(8)
            `byte_pinX_params(9)
            `byte_pinX_params(10)
            `byte_pinX_params(11)
            .rx_serializer_rate               (RX_SERIALIZER_RATE[ID]),
            .tx_serializer_rate               (TX_SERIALIZER_RATE[ID])
         ) u_byte (

            .i_dqsmode(i_dqsmode),                                                        
            .i_n0_odt_seg_rotate_en(i_n0_odt_seg_rotate_en),                              
            .i_n1_odt_seg_rotate_en(i_n1_odt_seg_rotate_en),                              
            .i_odt_en(i_odt_en),                                                          
            .i_odt_parken(i_odt_parken),                                                  
            .i_odt_parken_dqsn(i_odt_parken_dqsn),                                        
            .i_phy_avbb_avl_in_avm_address(i_phy_avbb_avl_in_avm_address),                
            .i_phy_avbb_avl_in_avm_read(i_phy_avbb_avl_in_avm_read),                      
            .i_phy_avbb_avl_in_avm_write(i_phy_avbb_avl_in_avm_write),                    
            .i_phy_avbb_avl_in_avm_writedata(i_phy_avbb_avl_in_avm_writedata),            
            .i_phy_avbb_avl_in_clk(i_phy_avbb_avl_in_clk),                                
            .i_phy_avbb_avl_in_rst_n(i_phy_avbb_avl_in_rst_n),                            
            .i_phy_byte_rx_ctrl(i_phy_byte_rx_ctrl),                                      
            .i_phy_byte_tx_ctrl(i_phy_byte_tx_ctrl),                                      
            .i_phy_ddrcrcmdbustrain_ddrdqovrddata(i_phy_ddrcrcmdbustrain_ddrdqovrddata),  
            .i_phy_ddrcrcmdbustrain_ddrdqovrdmodeen(i_phy_ddrcrcmdbustrain_ddrdqovrdmodeen), 
            .i_phy_ddrcrdatacontrol0_enodtrotation(i_phy_ddrcrdatacontrol0_enodtrotation),
            .i_phy_ddrcrdatacontrol4_unmatchedrx(i_phy_ddrcrdatacontrol4_unmatchedrx),    
            .i_phy_dfi_dram_clock_disable(i_phy_dfi_dram_clock_disable),                  
            .i_phy_fifo_read_enable_lower(i_phy_fifo_read_enable_lower),                  
            .i_phy_fifo_read_enable_upper(i_phy_fifo_read_enable_upper),                  
            .i_phy_gpio_dout(i_phy_gpio_dout),                                            
            .i_phy_gpio_dout_sel(i_phy_gpio_dout_sel),                                    
            .i_phy_gpio_oe(i_phy_gpio_oe),                                                
            .i_phy_occ_phy_clk(i_phy_occ_phy_clk),                                        
            .i_phy_phy_clk_gated(i_phy_phy_clk_gated),                                    
            .i_phy_phy_reset_n(i_phy_phy_reset_n),                                        
            .i_phy_rddata_en_dly(i_phy_rddata_en_dly),                                    
            .i_phy_rx_d0cben(i_phy_rx_d0cben),                                            
            .i_phy_rx_d0drvsel(i_phy_rx_d0drvsel),                                        
            .i_phy_rx_dfemuxout_0(i_phy_rx_dfemuxout_0),                                  
            .i_phy_rx_dfemuxout_1(i_phy_rx_dfemuxout_1),                                  
            .i_phy_rx_rcvenmuxout_0(i_phy_rx_rcvenmuxout_0),                              
            .i_phy_rx_rcvenmuxout_1(i_phy_rx_rcvenmuxout_1),                              
            .i_phy_rx_senseampen(i_phy_rx_senseampen),                                    
            .i_phy_rxclk_gated(i_phy_rxclk_gated),                                        
            .i_phy_sdll0_dqsn(i_phy_sdll0_dqsn),                                          
            .i_phy_sdll0_dqsp(i_phy_sdll0_dqsp),                                          
            .i_phy_sdll0_rx_d0pienable(i_phy_sdll0_rx_d0pienable),                        
            .i_phy_sdll0_rx_d0rcvenpre(i_phy_sdll0_rx_d0rcvenpre),                        
            .i_phy_sdll0_rx_d0reset(i_phy_sdll0_rx_d0reset),                              
            .i_phy_sdll1_dqsn(i_phy_sdll1_dqsn),                                          
            .i_phy_sdll1_dqsp(i_phy_sdll1_dqsp),                                          
            .i_phy_sdll1_rx_d0pienable(i_phy_sdll1_rx_d0pienable),                        
            .i_phy_sdll1_rx_d0rcvenpre(i_phy_sdll1_rx_d0rcvenpre),                        
            .i_phy_sdll1_rx_d0reset(i_phy_sdll1_rx_d0reset),                              
            .i_phy_trainreset(i_phy_trainreset),                                          
            .i_phy_tx_clkpi(i_phy_tx_clkpi),                                              
            .i_phy_tx_clkrefdivby2(i_phy_tx_clkrefdivby2),                                
            .i_phy_tx_picode0(i_phy_tx_picode0),                                          
            .i_phy_tx_picode1(i_phy_tx_picode1),                                          
            .i_phy_tx_picode2(i_phy_tx_picode2),                                          
            .i_phy_tx_picode3(i_phy_tx_picode3),                                          
            .i_phy_tx_picode4(i_phy_tx_picode4),                                          
            .i_phy_tx_picode5(i_phy_tx_picode5),                                          
            .i_phy_tx_picode6(i_phy_tx_picode6),                                          
            .i_phy_tx_picode7(i_phy_tx_picode7),                                          
            .i_phy_tx_picode8(i_phy_tx_picode8),                                          
            .i_phy_tx_picode9(i_phy_tx_picode9),                                          
            .i_phy_tx_picode10(i_phy_tx_picode10),                                        
            .i_phy_tx_picode11(i_phy_tx_picode11),                                        
            .i_phy_tx_wr_data(i_phy_tx_wr_data),                                          
            .i_phy_tx_wr_dqs_en4(i_phy_tx_wr_dqs_en4),                                    
            .i_phy_tx_wr_dqs_en4_del(i_phy_tx_wr_dqs_en4_del),                            
            .i_phy_tx_wr_dqs_en5(i_phy_tx_wr_dqs_en5),                                    
            .i_phy_tx_wr_dqs_en5_del(i_phy_tx_wr_dqs_en5_del),                            
            .i_phy_tx_wr_dqs_en6(i_phy_tx_wr_dqs_en6),                                    
            .i_phy_tx_wr_dqs_en6_del(i_phy_tx_wr_dqs_en6_del),                            
            .i_phy_tx_wr_dqs_en7(i_phy_tx_wr_dqs_en7),                                    
            .i_phy_tx_wr_dqs_en7_del(i_phy_tx_wr_dqs_en7_del),                            
            .i_phy_tx_wrdata_en0(i_phy_tx_wrdata_en0),                                    
            .i_phy_tx_wrdata_en0_del(i_phy_tx_wrdata_en0_del),                            
            .i_phy_tx_wrdata_en1(i_phy_tx_wrdata_en1),                                    
            .i_phy_tx_wrdata_en1_del(i_phy_tx_wrdata_en1_del),                            
            .i_phy_tx_wrdata_en2(i_phy_tx_wrdata_en2),                                    
            .i_phy_tx_wrdata_en2_del(i_phy_tx_wrdata_en2_del),                            
            .i_phy_tx_wrdata_en3(i_phy_tx_wrdata_en3),                                    
            .i_phy_tx_wrdata_en3_del(i_phy_tx_wrdata_en3_del),                            
            .i_phy_tx_wrdata_en8(i_phy_tx_wrdata_en8),                                    
            .i_phy_tx_wrdata_en8_del(i_phy_tx_wrdata_en8_del),                            
            .i_phy_tx_wrdata_en9(i_phy_tx_wrdata_en9),                                    
            .i_phy_tx_wrdata_en9_del(i_phy_tx_wrdata_en9_del),                            
            .i_phy_tx_wrdata_en10(i_phy_tx_wrdata_en10),                                  
            .i_phy_tx_wrdata_en10_del(i_phy_tx_wrdata_en10_del),                          
            .i_phy_tx_wrdata_en11(i_phy_tx_wrdata_en11),                                  
            .i_phy_tx_wrdata_en11_del(i_phy_tx_wrdata_en11_del),                          
            .i_phy_txclk_gated(i_phy_txclk_gated),                                        
            .i_phyclk_notgated(i_phyclk_notgated),                                        
            .i_rxfifo_rb_avm_wr_pipestage(i_rxfifo_rb_avm_wr_pipestage),                  
            .i_rxfifo_skew(i_rxfifo_skew),                                                
            .i_rxfifo_spare(i_rxfifo_spare),                                              
            .i_X1CounterDCCPin_00_DCCCount(i_X1CounterDCCPin_00_DCCCount),                
            .i_X1CounterDCCPin_01_DCCCount(i_X1CounterDCCPin_01_DCCCount),                
            .i_X1CounterDCCPin_02_DCCCount(i_X1CounterDCCPin_02_DCCCount),                
            .i_X1CounterDCCPin_03_DCCCount(i_X1CounterDCCPin_03_DCCCount),                
            .i_X1CounterDCCPin_04_DCCCount(i_X1CounterDCCPin_04_DCCCount),                
            .i_X1CounterDCCPin_05_DCCCount(i_X1CounterDCCPin_05_DCCCount),                
            .i_X1CounterDCCPin_06_DCCCount(i_X1CounterDCCPin_06_DCCCount),                
            .i_X1CounterDCCPin_07_DCCCount(i_X1CounterDCCPin_07_DCCCount),                
            .i_X1CounterDCCPin_08_DCCCount(i_X1CounterDCCPin_08_DCCCount),                
            .i_X1CounterDCCPin_09_DCCCount(i_X1CounterDCCPin_09_DCCCount),                
            .i_X1CounterDCCPin_10_DCCCount(i_X1CounterDCCPin_10_DCCCount),                
            .i_X1CounterDCCPin_11_DCCCount(i_X1CounterDCCPin_11_DCCCount),                
            .i_phy_sdll0_rx_d0sdlparkvalue(i_phy_sdll0_rx_d0sdlparkvalue),
            .i_phy_sdll1_rx_d0sdlparkvalue(i_phy_sdll1_rx_d0sdlparkvalue),
            .io_phy_pad_sig_bidir_in(io_phy_pad_sig_bidir_in),                            
            .io_phy_pad_sig_bidir_out(io_phy_pad_sig_bidir_out),                          
            .o_DDRCrRxEQRank01_RxDFETap0Rank0(o_DDRCrRxEQRank01_RxDFETap0Rank0),          
            .o_DDRCrRxEQRank01_RxDFETap0Rank1(o_DDRCrRxEQRank01_RxDFETap0Rank1),          
            .o_DDRCrRxEQRank01_RxDFETap1Rank0(o_DDRCrRxEQRank01_RxDFETap1Rank0),          
            .o_DDRCrRxEQRank01_RxDFETap1Rank1(o_DDRCrRxEQRank01_RxDFETap1Rank1),          
            .o_DDRCrRxEQRank01_RxDFETap2Rank0(o_DDRCrRxEQRank01_RxDFETap2Rank0),          
            .o_DDRCrRxEQRank01_RxDFETap2Rank1(o_DDRCrRxEQRank01_RxDFETap2Rank1),          
            .o_DDRCrRxEQRank01_RxDFETap3Rank0(o_DDRCrRxEQRank01_RxDFETap3Rank0),          
            .o_DDRCrRxEQRank01_RxDFETap3Rank1(o_DDRCrRxEQRank01_RxDFETap3Rank1),          
            .o_DDRCrRxEQRank23_RxDFETap0Rank2(o_DDRCrRxEQRank23_RxDFETap0Rank2),          
            .o_DDRCrRxEQRank23_RxDFETap0Rank3(o_DDRCrRxEQRank23_RxDFETap0Rank3),          
            .o_DDRCrRxEQRank23_RxDFETap1Rank2(o_DDRCrRxEQRank23_RxDFETap1Rank2),          
            .o_DDRCrRxEQRank23_RxDFETap1Rank3(o_DDRCrRxEQRank23_RxDFETap1Rank3),          
            .o_DDRCrRxEQRank23_RxDFETap2Rank2(o_DDRCrRxEQRank23_RxDFETap2Rank2),          
            .o_DDRCrRxEQRank23_RxDFETap2Rank3(o_DDRCrRxEQRank23_RxDFETap2Rank3),          
            .o_DDRCrRxEQRank23_RxDFETap3Rank2(o_DDRCrRxEQRank23_RxDFETap3Rank2),          
            .o_DDRCrRxEQRank23_RxDFETap3Rank3(o_DDRCrRxEQRank23_RxDFETap3Rank3),          
            .o_from_phy_rx_x16dqsn_p4(o_from_phy_rx_x16dqsn_p4),                          
            .o_from_phy_rx_x16dqsp_p4(o_from_phy_rx_x16dqsp_p4),                          
            .o_mipi_rb_rxdly_direct_ctrl(o_mipi_rb_rxdly_direct_ctrl),                    
            .o_mipi_rx_diff_en(o_mipi_rx_diff_en),                                        
            .o_mipi_rx_dphylprxen(o_mipi_rx_dphylprxen),                                  
            .o_phy_avbb_avl_out_avm_readdata(o_phy_avbb_avl_out_avm_readdata),            
            .o_phy_core_data(o_phy_core_data),                                            
            .o_phy_cr_iamca_00(o_phy_cr_iamca_00),                                        
            .o_phy_cr_iamca_01(o_phy_cr_iamca_01),                                        
            .o_phy_cr_iamca_02(o_phy_cr_iamca_02),                                        
            .o_phy_cr_iamca_03(o_phy_cr_iamca_03),                                        
            .o_phy_cr_iamca_04(o_phy_cr_iamca_04),                                        
            .o_phy_cr_iamca_05(o_phy_cr_iamca_05),                                        
            .o_phy_cr_iamca_06(o_phy_cr_iamca_06),                                        
            .o_phy_cr_iamca_07(o_phy_cr_iamca_07),                                        
            .o_phy_cr_iamca_08(o_phy_cr_iamca_08),                                        
            .o_phy_cr_iamca_09(o_phy_cr_iamca_09),                                        
            .o_phy_cr_iamca_10(o_phy_cr_iamca_10),                                        
            .o_phy_cr_iamca_11(o_phy_cr_iamca_11),                                        
            .o_phy_gpio_din(o_phy_gpio_din),                                              
            .o_phy_io_pad_doe_0(o_phy_io_pad_doe_0),                                      
            .o_phy_io_pad_doe_1(o_phy_io_pad_doe_1),                                      
            .o_phy_io_pad_doe_2(o_phy_io_pad_doe_2),                                      
            .o_phy_io_pad_doe_3(o_phy_io_pad_doe_3),                                      
            .o_phy_io_pad_doe_4(o_phy_io_pad_doe_4),                                      
            .o_phy_io_pad_doe_5(o_phy_io_pad_doe_5),                                      
            .o_phy_io_pad_doe_6(o_phy_io_pad_doe_6),                                      
            .o_phy_io_pad_doe_7(o_phy_io_pad_doe_7),                                      
            .o_phy_io_pad_doe_8(o_phy_io_pad_doe_8),                                      
            .o_phy_io_pad_doe_9(o_phy_io_pad_doe_9),                                      
            .o_phy_io_pad_doe_10(o_phy_io_pad_doe_10),                                    
            .o_phy_io_pad_doe_11(o_phy_io_pad_doe_11),                                    
            .o_phy_rx_dqs_amp_p5(o_phy_rx_dqs_amp_p5),                                    
            .o_phy_rx_dqs_amp_p7(o_phy_rx_dqs_amp_p7),                                    
            .o_phy_rx_dqs_n4(o_phy_rx_dqs_n4),                                            
            .o_phy_rx_dqs_n6(o_phy_rx_dqs_n6),                                            
            .o_phy_rx_dqs_p4(o_phy_rx_dqs_p4),                                            
            .o_phy_rx_dqs_p6(o_phy_rx_dqs_p6),                                            
            .o_phy_rx_fwdclk(o_phy_rx_fwdclk),                                            
            .o_phy_tx_wr_data_pl(o_phy_tx_wr_data_pl),                                    
            .o_rxdphylprxen_0(o_rxdphylprxen_0),                                          
            .o_rxdphylprxen_1(o_rxdphylprxen_1),                                          
            .o_rxdphylprxen_2(o_rxdphylprxen_2),                                          
            .o_rxdphylprxen_3(o_rxdphylprxen_3),                                          
            .o_rxdphylprxen_4(o_rxdphylprxen_4),                                          
            .o_rxdphylprxen_5(o_rxdphylprxen_5),                                          
            .o_rxdphylprxen_6(o_rxdphylprxen_6),                                          
            .o_rxdphylprxen_7(o_rxdphylprxen_7),                                          
            .o_rxdphylprxen_8(o_rxdphylprxen_8),                                          
            .o_rxdphylprxen_9(o_rxdphylprxen_9),                                          
            .o_rxdphylprxen_10(o_rxdphylprxen_10),                                        
            .o_rxdphylprxen_11(o_rxdphylprxen_11),                                        
            .o_rxlvdien_0(o_rxlvdien_0),                                                  
            .o_rxlvdien_1(o_rxlvdien_1),                                                  
            .o_rxlvdien_2(o_rxlvdien_2),                                                  
            .o_rxlvdien_3(o_rxlvdien_3),                                                  
            .o_rxlvdien_4(o_rxlvdien_4),                                                  
            .o_rxlvdien_5(o_rxlvdien_5),                                                  
            .o_rxlvdien_6(o_rxlvdien_6),                                                  
            .o_rxlvdien_7(o_rxlvdien_7),                                                  
            .o_rxlvdien_8(o_rxlvdien_8),                                                  
            .o_rxlvdien_9(o_rxlvdien_9),                                                  
            .o_rxlvdien_10(o_rxlvdien_10),                                                
            .o_rxlvdien_11(o_rxlvdien_11),                                                
            .o_rzq_en(o_rzq_en),                                                          
            .o_tx_modectrl_4(o_tx_modectrl_4),                                            
            .rxnpathenable_0(rxnpathenable_0),                                            
            .rxnpathenable_1(rxnpathenable_1),                                            
            .rxnpathenable_2(rxnpathenable_2),                                            
            .rxnpathenable_3(rxnpathenable_3),                                            
            .rxnpathenable_4(rxnpathenable_4),                                            
            .rxnpathenable_5(rxnpathenable_5),                                            
            .rxnpathenable_6(rxnpathenable_6),                                            
            .rxnpathenable_7(rxnpathenable_7),                                            
            .rxnpathenable_8(rxnpathenable_8),                                            
            .rxnpathenable_9(rxnpathenable_9),                                            
            .rxnpathenable_10(rxnpathenable_10),                                          
            .rxnpathenable_11(rxnpathenable_11),                                          
            .rxppathenable_0(rxppathenable_0),                                            
            .rxppathenable_1(rxppathenable_1),                                            
            .rxppathenable_2(rxppathenable_2),                                            
            .rxppathenable_3(rxppathenable_3),                                            
            .rxppathenable_4(rxppathenable_4),                                            
            .rxppathenable_5(rxppathenable_5),                                            
            .rxppathenable_6(rxppathenable_6),                                            
            .rxppathenable_7(rxppathenable_7),                                            
            .rxppathenable_8(rxppathenable_8),                                            
            .rxppathenable_9(rxppathenable_9),                                            
            .rxppathenable_10(rxppathenable_10),                                          
            .rxppathenable_11(rxppathenable_11)                                           
         );

      end else begin : gen_unused_byte
         assign io_phy_pad_sig_bidir_out               = '0;
         assign o_DDRCrRxEQRank01_RxDFETap0Rank0       = '0;
         assign o_DDRCrRxEQRank01_RxDFETap0Rank1       = '0;
         assign o_DDRCrRxEQRank01_RxDFETap1Rank0       = '0;
         assign o_DDRCrRxEQRank01_RxDFETap1Rank1       = '0;
         assign o_DDRCrRxEQRank01_RxDFETap2Rank0       = '0;
         assign o_DDRCrRxEQRank01_RxDFETap2Rank1       = '0;
         assign o_DDRCrRxEQRank01_RxDFETap3Rank0       = '0;
         assign o_DDRCrRxEQRank01_RxDFETap3Rank1       = '0;
         assign o_DDRCrRxEQRank23_RxDFETap0Rank2       = '0;
         assign o_DDRCrRxEQRank23_RxDFETap0Rank3       = '0;
         assign o_DDRCrRxEQRank23_RxDFETap1Rank2       = '0;
         assign o_DDRCrRxEQRank23_RxDFETap1Rank3       = '0;
         assign o_DDRCrRxEQRank23_RxDFETap2Rank2       = '0;
         assign o_DDRCrRxEQRank23_RxDFETap2Rank3       = '0;
         assign o_DDRCrRxEQRank23_RxDFETap3Rank2       = '0;
         assign o_DDRCrRxEQRank23_RxDFETap3Rank3       = '0;
         assign o_from_phy_rx_x16dqsn_p4               = '0;
         assign o_from_phy_rx_x16dqsp_p4               = '0;
         assign o_mipi_rb_rxdly_direct_ctrl            = '0;
         assign o_mipi_rx_diff_en                      = '0;
         assign o_mipi_rx_dphylprxen                   = '0;
         assign o_phy_avbb_avl_out_avm_readdata        = '0;
         assign o_phy_core_data                        = '0;
         assign o_phy_gpio_din                         = '0;
         assign o_phy_cr_iamca_00                      = '0;
         assign o_phy_cr_iamca_01                      = '0;
         assign o_phy_cr_iamca_02                      = '0;
         assign o_phy_cr_iamca_03                      = '0;
         assign o_phy_cr_iamca_04                      = '0;
         assign o_phy_cr_iamca_05                      = '0;
         assign o_phy_cr_iamca_06                      = '0;
         assign o_phy_cr_iamca_07                      = '0;
         assign o_phy_cr_iamca_08                      = '0;
         assign o_phy_cr_iamca_09                      = '0;
         assign o_phy_cr_iamca_10                      = '0;
         assign o_phy_cr_iamca_11                      = '0;
         assign o_phy_io_pad_doe_0                     = '0;
         assign o_phy_io_pad_doe_1                     = '0;
         assign o_phy_io_pad_doe_2                     = '0;
         assign o_phy_io_pad_doe_3                     = '0;
         assign o_phy_io_pad_doe_4                     = '0;
         assign o_phy_io_pad_doe_5                     = '0;
         assign o_phy_io_pad_doe_6                     = '0;
         assign o_phy_io_pad_doe_7                     = '0;
         assign o_phy_io_pad_doe_8                     = '0;
         assign o_phy_io_pad_doe_9                     = '0;
         assign o_phy_io_pad_doe_10                    = '0;
         assign o_phy_io_pad_doe_11                    = '0;
         assign o_phy_rx_dqs_amp_p5                    = '0;
         assign o_phy_rx_dqs_amp_p7                    = '0;
         assign o_phy_rx_dqs_n4                        = '0;
         assign o_phy_rx_dqs_n6                        = '0;
         assign o_phy_rx_dqs_p4                        = '0;
         assign o_phy_rx_dqs_p6                        = '0;
         assign o_phy_rx_fwdclk                        = '0;
         assign o_phy_tx_wr_data_pl                    = '0;
         assign o_rxdphylprxen_0                       = '0;
         assign o_rxdphylprxen_1                       = '0;
         assign o_rxdphylprxen_2                       = '0;
         assign o_rxdphylprxen_3                       = '0;
         assign o_rxdphylprxen_4                       = '0;
         assign o_rxdphylprxen_5                       = '0;
         assign o_rxdphylprxen_6                       = '0;
         assign o_rxdphylprxen_7                       = '0;
         assign o_rxdphylprxen_8                       = '0;
         assign o_rxdphylprxen_9                       = '0;
         assign o_rxdphylprxen_10                      = '0;
         assign o_rxdphylprxen_11                      = '0;
         assign o_rxlvdien_0                           = '0;
         assign o_rxlvdien_1                           = '0;
         assign o_rxlvdien_2                           = '0;
         assign o_rxlvdien_3                           = '0;
         assign o_rxlvdien_4                           = '0;
         assign o_rxlvdien_5                           = '0;
         assign o_rxlvdien_6                           = '0;
         assign o_rxlvdien_7                           = '0;
         assign o_rxlvdien_8                           = '0;
         assign o_rxlvdien_9                           = '0;
         assign o_rxlvdien_10                          = '0;
         assign o_rxlvdien_11                          = '0;
         assign o_rzq_en                               = '0;
         assign o_tx_modectrl_4                        = '0;
         assign rxnpathenable_0                        = '0;
         assign rxnpathenable_1                        = '0;
         assign rxnpathenable_2                        = '0;
         assign rxnpathenable_3                        = '0;
         assign rxnpathenable_4                        = '0;
         assign rxnpathenable_5                        = '0;
         assign rxnpathenable_6                        = '0;
         assign rxnpathenable_7                        = '0;
         assign rxnpathenable_8                        = '0;
         assign rxnpathenable_9                        = '0;
         assign rxnpathenable_10                       = '0;
         assign rxnpathenable_11                       = '0;
         assign rxppathenable_0                        = '0;
         assign rxppathenable_1                        = '0;
         assign rxppathenable_2                        = '0;
         assign rxppathenable_3                        = '0;
         assign rxppathenable_4                        = '0;
         assign rxppathenable_5                        = '0;
         assign rxppathenable_6                        = '0;
         assign rxppathenable_7                        = '0;
         assign rxppathenable_8                        = '0;
         assign rxppathenable_9                        = '0;
         assign rxppathenable_10                       = '0;
         assign rxppathenable_11                       = '0;
      end
   endgenerate

   // synthesis translate_off
   assign i_phy_gpio_oe = '0;
   // synthesis translate_on
   
endmodule


