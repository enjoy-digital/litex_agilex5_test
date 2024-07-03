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

// altera message_off 16788
module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_top #(

   // ======= Calibration IP Intf parameters ==========
   // --------------- CALIP to EMIF -------------------
   // CALIP to EMIF -- calbus
   localparam PORT_CALBUS_ADDRESS_WIDTH        = 22,
   localparam PORT_CALBUS_DATA_WIDTH           = 32,
   localparam INTF_CALBUS_BROADCAST_WIDTH      = PORT_CALBUS_ADDRESS_WIDTH + PORT_CALBUS_DATA_WIDTH + 4,

   // CALIP to EMIF -- SEQ to PA (SEQ_CFG)
   localparam PORT_SEQ_CFG_DATA_WIDTH        = 96,
   localparam PORT_SEQ_CFG_DATA_EN_WIDTH     = 4,
   localparam PORT_SEQ_CFG_RANK_WIDTH        = 8,
   localparam PORT_SEQ_CFG_SUPPRESSION_WIDTH = 12,
   localparam PORT_SEQ_CFG_WR_DQS_EN_WIDTH   = 4,
   localparam INTF_SEQ_CFG_M2S_WIDTH         = PORT_SEQ_CFG_DATA_WIDTH 
                                               + PORT_SEQ_CFG_WR_DQS_EN_WIDTH 
                                               + 2*PORT_SEQ_CFG_DATA_EN_WIDTH 
                                               + 2*PORT_SEQ_CFG_RANK_WIDTH 
                                               + PORT_SEQ_CFG_SUPPRESSION_WIDTH 
                                               + 1, 

   // CALIP to EMIF -- MC Register Interface
   localparam PORT_MC_REGIF_ADDR_WIDTH        = 16,
   localparam PORT_MC_REGIF_DATA_WIDTH        = 32,
   localparam PORT_MC_REGIF_SIZE_WIDTH        = 3,
   localparam PORT_MC_REGIF_BURST_WIDTH       = 3,
   localparam PORT_MC_REGIF_TRANS_WIDTH       = 2,
   localparam INTF_MC_REGIF_M2S_WIDTH         = PORT_MC_REGIF_ADDR_WIDTH 
                                                + PORT_MC_REGIF_DATA_WIDTH 
                                                + PORT_MC_REGIF_SIZE_WIDTH 
                                                + PORT_MC_REGIF_BURST_WIDTH 
                                                + PORT_MC_REGIF_TRANS_WIDTH 
                                                + 5,

   // CALIP to EMIF -- I3C to PA
   localparam INTF_DDR5_I3C_M2S_WIDTH         = 4, //scl,sda_pp,sda_tx,sda_dr_en
   // CALIP to EMIF
   localparam INTF_CALIP_TO_EMIF_WIDTH        = 3*INTF_CALBUS_BROADCAST_WIDTH 
                                                + 8*INTF_SEQ_CFG_M2S_WIDTH  
                                                + 3 + 4
                                                + INTF_MC_REGIF_M2S_WIDTH 
                                                + INTF_DDR5_I3C_M2S_WIDTH,

   // --------------- EMIF to CALIP -------------------
   // EMIF to CALIP -- calbus
   localparam INTF_CALBUS_RESPONSE_WIDTH       = PORT_CALBUS_DATA_WIDTH,

   // EMIF to CALIP -- PA to SEQ (SEQ_CFG)
   localparam PORT_SEQ_CFG_RDDATA_VALID_WIDTH = 4,
   localparam PORT_SEQ_CFG_RB_BASE_ADDRESS_WIDTH = 11,
   localparam INTF_SEQ_CFG_S2M_WIDTH         = PORT_SEQ_CFG_DATA_WIDTH 
                                                 + PORT_SEQ_CFG_RDDATA_VALID_WIDTH
                                                 + PORT_SEQ_CFG_RB_BASE_ADDRESS_WIDTH 
                                                 + 4, 


   // EMIF to CALIP -- MC Register Interface
   localparam PORT_MC_REGIF_RESP_WIDTH        = 2,
   localparam INTF_MC_REGIF_S2M_WIDTH         = 2*PORT_MC_REGIF_DATA_WIDTH 
                                                + 2*PORT_MC_REGIF_RESP_WIDTH 
                                                + 4, 

   // EMIF to CALIP -- I3C to PA
   localparam INTF_DDR5_I3C_S2M_WIDTH         = 1,

   // EMIF to CALIP
   localparam INTF_EMIF_TO_CALIP_WIDTH        = 10*INTF_CALBUS_RESPONSE_WIDTH 
                                                + 8*INTF_SEQ_CFG_S2M_WIDTH 
                                                + INTF_MC_REGIF_S2M_WIDTH 
                                                + INTF_DDR5_I3C_S2M_WIDTH 
                                                + 2, 
   localparam PARAM_TABLE_WIDTH               = 16384,

   // ======= Mem Intf parameters ==========
   //TODO: for now this only captures DDR4,DDR5,LPDDR5 params; extend this to include all techs
   parameter MEM_CK_T_WIDTH            =  1,
   parameter MEM_CK_C_WIDTH            =  1,
   parameter MEM_CKE_WIDTH             =  1,
   parameter MEM_ODT_WIDTH             =  1,
   parameter MEM_CS_N_WIDTH            =  1,
   parameter MEM_CHIP_ID_WIDTH         =  0,
   parameter MEM_A_WIDTH               =  17,
   parameter MEM_BANK_ADDR_WIDTH       =  2,
   parameter MEM_BANK_GROUP_ADDR_WIDTH =  2,
   parameter MEM_ACT_N_WIDTH           =  1,
   parameter MEM_PAR_WIDTH             =  1,
   parameter MEM_LBS_WIDTH             =  1,
   parameter MEM_LBD_WIDTH             =  1,
   parameter MEM_ALERT_N_WIDTH         =  1,
   parameter MEM_RESET_N_WIDTH         =  1,
   parameter MEM_DQ_WIDTH              =  1,
   parameter MEM_DQS_T_WIDTH           =  1,
   parameter MEM_DQS_C_WIDTH           =  1,
   parameter MEM_DBI_N_WIDTH           =  1,
   parameter MEM_BURST_ADDR_WIDTH      =  1,
   parameter MEM_CAI_WIDTH             =  1,
   parameter MEM_CA_WIDTH              =  1,
   parameter MEM_CK_WIDTH              =  1,
   parameter MEM_COL_ADDR_WIDTH        =  1,
   parameter MEM_CS_WIDTH              =  1,
   parameter MEM_DMI_WIDTH             =  1,
   parameter MEM_DM_N_WIDTH            =  1,
   parameter MEM_MAX_BA_WIDTH          =  1,
   parameter MEM_MAX_BG_WIDTH          =  1,
   parameter MEM_MIR_WIDTH             =  1,
   parameter MEM_ODT_CA_WIDTH          =  1,
   parameter MEM_RDQS_T_WIDTH          =  1,
   parameter MEM_RDQS_C_WIDTH          =  1,
   parameter MEM_ROW_ADDR_WIDTH        =  1,
   parameter MEM_TDQS_C_WIDTH          =  1,
   parameter MEM_TDQS_T_WIDTH          =  1,
   parameter MEM_TEN_WIDTH             =  1,
   parameter MEM_VERBOSE               =  1,
   parameter MEM_WCK_T_WIDTH           =  1,
   parameter MEM_WCK_C_WIDTH           =  1,
   parameter OCT_RZQIN_WIDTH           =  1,
   parameter I3C_SCL_WIDTH             =  1,
   parameter I3C_SDA_WIDTH             =  1,

   // ======= IP parameters =======
   parameter PHY_I3C_EN                = "",
   parameter AXI4_ADDR_WIDTH           = 1,
   parameter AXI4_DATA_WIDTH           = 1,
   parameter AXI4_USER_DATA_ENABLE     = 1,
   parameter AXI4_AXUSER_WIDTH         = 1,
   parameter PHY_MEMCLK_FREQ_MHZ_INT   = "",
   parameter SLIM_BL_EN                = 8'hf0,
   parameter PHY_NOC_EN                = "",
   parameter MEM_NUM_CHANNELS_PER_IO96 = 1,
   parameter LS_MEM_DQ_WIDTH           = 0,

   // ======= Control AXI parameters ==========
   //TODO: Pass in calculated values for PORT_AXI_ID_WIDTH, PORT_AXI_RESP_WIDTH
   
   localparam PORT_AXI_AXADDR_WIDTH    = AXI4_ADDR_WIDTH,
   localparam PORT_AXI_AXBURST_WIDTH   = 2,
   localparam PORT_AXI_AXLEN_WIDTH     = 8,
   localparam PORT_AXI_AXQOS_WIDTH     = 4,
   localparam PORT_AXI_AXSIZE_WIDTH    = 3,
   localparam PORT_AXI_AXID_WIDTH      = 7,
   localparam PORT_AXI_AXUSER_WIDTH    = AXI4_AXUSER_WIDTH, 
   localparam PORT_AXI_AXCACHE_WIDTH   = 4,
   localparam PORT_AXI_AXPROT_WIDTH    = 3,

   localparam PORT_AXI_DATA_WIDTH      = AXI4_DATA_WIDTH,
   localparam PORT_AXI_STRB_WIDTH      = AXI4_DATA_WIDTH/8,
   localparam PORT_AXI_ID_WIDTH        = PORT_AXI_AXID_WIDTH,
   localparam PORT_AXI_RESP_WIDTH      = 2,
   localparam PORT_AXI_USER_WIDTH      = 64,
   localparam PORT_AXI_NOC_USER_WIDTH  = 32,
   localparam PORT_AXI_S0_USER_WIDTH   = PHY_NOC_EN ? PORT_AXI_NOC_USER_WIDTH : PORT_AXI_USER_WIDTH,

   localparam PORT_MEM_DQ_WIDTH        = LS_MEM_DQ_WIDTH == 0 ? MEM_DQ_WIDTH : LS_MEM_DQ_WIDTH,
   localparam PORT_MEM_DQS_T_WIDTH     = LS_MEM_DQ_WIDTH == 0 ? MEM_DQS_T_WIDTH : (LS_MEM_DQ_WIDTH / (MEM_DQ_WIDTH / MEM_DQS_T_WIDTH)),
   localparam PORT_MEM_DQS_C_WIDTH     = LS_MEM_DQ_WIDTH == 0 ? MEM_DQS_C_WIDTH : (LS_MEM_DQ_WIDTH / (MEM_DQ_WIDTH / MEM_DQS_C_WIDTH)),
   localparam PORT_MEM_DBI_N_WIDTH     = (LS_MEM_DQ_WIDTH == 0 || MEM_DBI_N_WIDTH < 1) ? MEM_DBI_N_WIDTH : (LS_MEM_DQ_WIDTH / (MEM_DQ_WIDTH / MEM_DBI_N_WIDTH)),
   
   
   localparam MEM_C_WIDTH  = MEM_CHIP_ID_WIDTH,
   localparam MEM_BA_WIDTH = MEM_BANK_ADDR_WIDTH,
   localparam MEM_BG_WIDTH = MEM_BANK_GROUP_ADDR_WIDTH

) (
   // Reference clock going to PLL
   input logic                                                 ref_clk_0,
   
   // Core init signal going into EMIF. Used to generate the reset signal on the core-EMIF interface in fabric modes.
   input logic                                                 core_init_n_0,

   // User clock going to core (for PHY + hard controller interfaces)
   output logic                                                usr_clk_0,

   // User reset signal going to core (for PHY + hard controller interfaces)
   output logic                                                usr_rst_n_0,

   // In case of ASYNC mode, the user will drive the async clock. The same clock also is driven as output to usr_clk
   input  logic                                                usr_async_clk_0,

   // In case of NOC mode, this clock is used for the TNIU
   output logic                                                noc_aclk_0,
   output logic                                                noc_aclk_1,
   output logic                                                noc_rst_n_0,
   output logic                                                noc_rst_n_1,

   input  logic    [PORT_AXI_AXADDR_WIDTH-1:0]                 s0_axi4_araddr,
   input  logic    [PORT_AXI_AXBURST_WIDTH-1:0]                s0_axi4_arburst,
   input  logic    [PORT_AXI_AXID_WIDTH-1:0]                   s0_axi4_arid,
   input  logic    [PORT_AXI_AXLEN_WIDTH-1:0]                  s0_axi4_arlen,
   input  logic                                                s0_axi4_arlock,
   input  logic    [PORT_AXI_AXQOS_WIDTH-1:0]                  s0_axi4_arqos,
   input  logic    [PORT_AXI_AXSIZE_WIDTH-1:0]                 s0_axi4_arsize,
   input  logic    [PORT_AXI_AXUSER_WIDTH-1:0]                 s0_axi4_aruser,
   input  logic                                                s0_axi4_arvalid,
   input  logic    [PORT_AXI_AXCACHE_WIDTH-1:0]                s0_axi4_arcache,
   input  logic    [PORT_AXI_AXPROT_WIDTH-1:0]                 s0_axi4_arprot,
   input  logic    [PORT_AXI_AXADDR_WIDTH-1:0]                 s0_axi4_awaddr,
   input  logic    [PORT_AXI_AXBURST_WIDTH-1:0]                s0_axi4_awburst,
   input  logic    [PORT_AXI_AXID_WIDTH-1:0]                   s0_axi4_awid,
   input  logic    [PORT_AXI_AXLEN_WIDTH-1:0]                  s0_axi4_awlen,
   input  logic                                                s0_axi4_awlock,
   input  logic    [PORT_AXI_AXQOS_WIDTH-1:0]                  s0_axi4_awqos,
   input  logic    [PORT_AXI_AXSIZE_WIDTH-1:0]                 s0_axi4_awsize,
   input  logic    [PORT_AXI_AXUSER_WIDTH-1:0]                 s0_axi4_awuser,
   input  logic                                                s0_axi4_awvalid,
   input  logic    [PORT_AXI_AXCACHE_WIDTH-1:0]                s0_axi4_awcache,
   input  logic    [PORT_AXI_AXPROT_WIDTH-1:0]                 s0_axi4_awprot,
   input  logic                                                s0_axi4_bready,
   input  logic                                                s0_axi4_rready,
   input  logic    [PORT_AXI_DATA_WIDTH-1:0]                   s0_axi4_wdata,
   input  logic                                                s0_axi4_wlast,
   input  logic    [PORT_AXI_STRB_WIDTH-1:0]                   s0_axi4_wstrb,
   input  logic    [PORT_AXI_S0_USER_WIDTH-1:0]                s0_axi4_wuser,
   input  logic                                                s0_axi4_wvalid,
   output logic                                                s0_axi4_arready,
   output logic                                                s0_axi4_awready,
   output logic    [PORT_AXI_ID_WIDTH-1:0]                     s0_axi4_bid,
   output logic    [PORT_AXI_RESP_WIDTH-1:0]                   s0_axi4_bresp,
   output logic                                                s0_axi4_bvalid,
   output logic    [PORT_AXI_DATA_WIDTH-1:0]                   s0_axi4_rdata,
   output logic    [PORT_AXI_ID_WIDTH-1:0]                     s0_axi4_rid,
   output logic                                                s0_axi4_rlast,
   output logic    [PORT_AXI_RESP_WIDTH-1:0]                   s0_axi4_rresp,
   output logic    [PORT_AXI_S0_USER_WIDTH-1:0]                s0_axi4_ruser,
   output logic                                                s0_axi4_rvalid,
   output logic                                                s0_axi4_wready,

   // AXI4 Interface - Channel 1 
   input  logic    [PORT_AXI_AXADDR_WIDTH-1:0]                 s1_axi4_araddr,
   input  logic    [PORT_AXI_AXBURST_WIDTH-1:0]                s1_axi4_arburst,
   input  logic    [PORT_AXI_AXID_WIDTH-1:0]                   s1_axi4_arid,
   input  logic    [PORT_AXI_AXLEN_WIDTH-1:0]                  s1_axi4_arlen,
   input  logic                                                s1_axi4_arlock,
   input  logic    [PORT_AXI_AXQOS_WIDTH-1:0]                  s1_axi4_arqos,
   input  logic    [PORT_AXI_AXSIZE_WIDTH-1:0]                 s1_axi4_arsize,
   input  logic    [PORT_AXI_AXUSER_WIDTH-1:0]                 s1_axi4_aruser,
   input  logic                                                s1_axi4_arvalid,
   input  logic    [PORT_AXI_AXCACHE_WIDTH-1:0]                s1_axi4_arcache,
   input  logic    [PORT_AXI_AXPROT_WIDTH-1:0]                 s1_axi4_arprot,
   input  logic    [PORT_AXI_AXADDR_WIDTH-1:0]                 s1_axi4_awaddr,
   input  logic    [PORT_AXI_AXBURST_WIDTH-1:0]                s1_axi4_awburst,
   input  logic    [PORT_AXI_AXID_WIDTH-1:0]                   s1_axi4_awid,
   input  logic    [PORT_AXI_AXLEN_WIDTH-1:0]                  s1_axi4_awlen,
   input  logic                                                s1_axi4_awlock,
   input  logic    [PORT_AXI_AXQOS_WIDTH-1:0]                  s1_axi4_awqos,
   input  logic    [PORT_AXI_AXSIZE_WIDTH-1:0]                 s1_axi4_awsize,
   input  logic    [PORT_AXI_AXUSER_WIDTH-1:0]                 s1_axi4_awuser,
   input  logic                                                s1_axi4_awvalid,
   input  logic    [PORT_AXI_AXCACHE_WIDTH-1:0]                s1_axi4_awcache,
   input  logic    [PORT_AXI_AXPROT_WIDTH-1:0]                 s1_axi4_awprot,
   input  logic                                                s1_axi4_bready,
   input  logic                                                s1_axi4_rready,
   input  logic    [PORT_AXI_DATA_WIDTH-1:0]                   s1_axi4_wdata,
   input  logic                                                s1_axi4_wlast,
   input  logic    [PORT_AXI_STRB_WIDTH-1:0]                   s1_axi4_wstrb,
   input  logic    [PORT_AXI_USER_WIDTH-1:0]                   s1_axi4_wuser,
   input  logic                                                s1_axi4_wvalid,
   output logic                                                s1_axi4_arready,
   output logic                                                s1_axi4_awready,
   output logic    [PORT_AXI_ID_WIDTH-1:0]                     s1_axi4_bid,
   output logic    [PORT_AXI_RESP_WIDTH-1:0]                   s1_axi4_bresp,
   output logic                                                s1_axi4_bvalid,
   output logic    [PORT_AXI_DATA_WIDTH-1:0]                   s1_axi4_rdata,
   output logic    [PORT_AXI_ID_WIDTH-1:0]                     s1_axi4_rid,
   output logic                                                s1_axi4_rlast,
   output logic    [PORT_AXI_RESP_WIDTH-1:0]                   s1_axi4_rresp,
   output logic    [PORT_AXI_USER_WIDTH-1:0]                   s1_axi4_ruser,
   output logic                                                s1_axi4_rvalid,
   output logic                                                s1_axi4_wready,

   // CALIP Interface
   input  logic    [INTF_CALIP_TO_EMIF_WIDTH-1:0]              calbus_0,
   output logic    [INTF_EMIF_TO_CALIP_WIDTH-1:0]              calbus_readdata_0,
   output logic    [2*PARAM_TABLE_WIDTH-1:0]                   calbus_param_table_0,

   // Memory Interface
   //TODO: for now this only captures DDR4,DDR5,LPDDR5 mem intf ports; extend this to include all techs
   // MEM Interface - Channel 0 
   output      logic [MEM_CK_T_WIDTH-1:0]                   mem_ck_t_0,
   output      logic [MEM_CK_C_WIDTH-1:0]                   mem_ck_c_0,
   output      logic [MEM_CKE_WIDTH-1:0]                    mem_cke_0,
   output      logic [MEM_ODT_WIDTH-1:0]                    mem_odt_0,
   output      logic [MEM_CS_N_WIDTH-1:0]                   mem_cs_n_0,
   output      logic [MEM_C_WIDTH-1:0]                      mem_c_0,
   output      logic [MEM_A_WIDTH-1:0]                      mem_a_0,
   output      logic [MEM_BA_WIDTH-1:0]                     mem_ba_0,
   output      logic [MEM_BG_WIDTH-1:0]                     mem_bg_0,
   output      logic [MEM_ACT_N_WIDTH-1:0]                  mem_act_n_0,
   output      logic [MEM_PAR_WIDTH-1:0]                    mem_par_0,
   input       logic [MEM_ALERT_N_WIDTH-1:0]                mem_alert_n_0,
   output      logic [MEM_RESET_N_WIDTH-1:0]                mem_reset_n_0,
   inout  tri  logic [PORT_MEM_DQ_WIDTH-1:0]                mem_dq_0,
   inout  tri  logic [PORT_MEM_DQS_T_WIDTH-1:0]             mem_dqs_t_0,
   inout  tri  logic [PORT_MEM_DQS_C_WIDTH-1:0]             mem_dqs_c_0,
   inout  tri  logic [PORT_MEM_DBI_N_WIDTH-1:0]             mem_dbi_n_0,
   output      logic [MEM_CA_WIDTH-1:0]                     mem_ca_0,
   output      logic [MEM_DM_N_WIDTH-1:0]                   mem_dm_n_0,
   output      logic [MEM_CS_WIDTH-1:0]                     mem_cs_0,
   output      logic [MEM_WCK_T_WIDTH-1:0]                  mem_wck_t_0,
   output      logic [MEM_WCK_C_WIDTH-1:0]                  mem_wck_c_0,
   inout  tri  logic [MEM_RDQS_T_WIDTH-1:0]                 mem_rdqs_t_0,
   inout  tri  logic [MEM_RDQS_C_WIDTH-1:0]                 mem_rdqs_c_0,
   inout  tri  logic [MEM_DMI_WIDTH-1:0]                    mem_dmi_0,
   input       logic [OCT_RZQIN_WIDTH-1:0]                  oct_rzqin_0,

   // MEM Interface - Channel 1 
   output      logic [MEM_CK_T_WIDTH-1:0]                   mem_ck_t_1,
   output      logic [MEM_CK_C_WIDTH-1:0]                   mem_ck_c_1,
   output      logic [MEM_CKE_WIDTH-1:0]                    mem_cke_1,
   output      logic [MEM_ODT_WIDTH-1:0]                    mem_odt_1,
   output      logic [MEM_CS_N_WIDTH-1:0]                   mem_cs_n_1,
   output      logic [MEM_C_WIDTH-1:0]                      mem_c_1,
   output      logic [MEM_A_WIDTH-1:0]                      mem_a_1,
   output      logic [MEM_BA_WIDTH-1:0]                     mem_ba_1,
   output      logic [MEM_BG_WIDTH-1:0]                     mem_bg_1,
   output      logic [MEM_ACT_N_WIDTH-1:0]                  mem_act_n_1,
   output      logic [MEM_PAR_WIDTH-1:0]                    mem_par_1,
   input       logic [MEM_ALERT_N_WIDTH-1:0]                mem_alert_n_1,
   output      logic [MEM_RESET_N_WIDTH-1:0]                mem_reset_n_1,
   inout  tri  logic [PORT_MEM_DQ_WIDTH-1:0]                mem_dq_1,
   inout  tri  logic [PORT_MEM_DQS_T_WIDTH-1:0]             mem_dqs_t_1,
   inout  tri  logic [PORT_MEM_DQS_C_WIDTH-1:0]             mem_dqs_c_1,
   inout  tri  logic [PORT_MEM_DBI_N_WIDTH-1:0]             mem_dbi_n_1,
   output      logic [MEM_CA_WIDTH-1:0]                     mem_ca_1,
   output      logic [MEM_DM_N_WIDTH-1:0]                   mem_dm_n_1,
   output      logic [MEM_CS_WIDTH-1:0]                     mem_cs_1,
   output      logic [MEM_WCK_T_WIDTH-1:0]                  mem_wck_t_1,
   output      logic [MEM_WCK_C_WIDTH-1:0]                  mem_wck_c_1,
   inout  tri  logic [MEM_RDQS_T_WIDTH-1:0]                 mem_rdqs_t_1,
   inout  tri  logic [MEM_RDQS_C_WIDTH-1:0]                 mem_rdqs_c_1,
   inout  tri  logic [MEM_DMI_WIDTH-1:0]                    mem_dmi_1,
   input       logic [OCT_RZQIN_WIDTH-1:0]                  oct_rzqin_1,

   // LBD/LBS Interfaces
   input       logic [MEM_LBD_WIDTH-1:0]                    mem_lbd_0,
   input       logic [MEM_LBS_WIDTH-1:0]                    mem_lbs_0,
   // Lockstep Interface
   input       logic                                        ls_usr_clk_0,
   input       logic                                        ls_usr_rst_n_0,

   // I3C Interface
   output      logic                                        i3c_scl_0,
   inout  tri  logic                                        i3c_sda_0
);
   timeunit 1ns;
   timeprecision 1ps;

   // HW description localparams
   localparam NUM_BYTES_IN_IO96 = 8;
   localparam NUM_HMC_IN_IO96 = 2;

   localparam INTF_SEQ_AVBB_INTF_WIDTH = 58 ;
   localparam INTF_PERIPH_TO_SEQ_WIDTH = 32 ;
   localparam INTF_PLL_TO_BC_WIDTH = 4;
   localparam INTF_PLL_TO_CPA_WIDTH = 11;
   localparam INTF_PLL_TO_HMC_WIDTH = 2;
   localparam INTF_PLL_TO_PA_WIDTH = 2;
   localparam INTF_PLL_TO_FA_WIDTH = 2;
   localparam INTF_PLL_TO_SEQ_WIDTH = PORT_CALBUS_DATA_WIDTH + 2;
   localparam INTF_PLL_TO_CORE_WIDTH = 8;

   localparam INTF_FAHMC_TO_CORE_WIDTH = 32 ;
   localparam INTF_FAHMC_TO_HMC_WIDTH = 168 ;
   localparam INTF_CORE_TO_FAHMC_WIDTH = 168 ;
   localparam INTF_HMC_TO_FAHMC_WIDTH = 32 ;
   localparam INTF_FALANE_TO_CORE_WIDTH = 100 ;
   localparam INTF_FALANE_TO_HMC_WIDTH = 116 ;
   localparam INTF_FALANE_TO_PA_WIDTH = 116 ;
   localparam INTF_PA_TO_FALANE_WIDTH = 101 ;
   localparam INTF_HMC_TO_FALANE_WIDTH = 100 ;
   localparam INTF_CORE_TO_FALANE_WIDTH = 116 ;
   localparam INTF_HMC_TO_IOSSM_WIDTH = PORT_MC_REGIF_DATA_WIDTH+
                                        PORT_MC_REGIF_RESP_WIDTH+
                                        2;
   localparam INTF_IOSSM_TO_HMC_WIDTH = PORT_MC_REGIF_ADDR_WIDTH +
                                        PORT_MC_REGIF_BURST_WIDTH +
                                        PORT_MC_REGIF_SIZE_WIDTH +
                                        PORT_MC_REGIF_TRANS_WIDTH +
                                        PORT_MC_REGIF_DATA_WIDTH +
                                        5 + 1 + 4;
   localparam INTF_OTHER_HMC_WIDTH = 2;
   localparam INTF_HMC_TO_PA_WIDTH = 131 ;
   localparam INTF_PA_TO_HMC_WIDTH = 100 ;
   localparam INTF_BC_TO_B_WIDTH = 583 ;
   localparam INTF_B_TO_BC_WIDTH = 242 ;
   localparam INTF_BC_TO_PA_WIDTH = 4 ;
   localparam INTF_PA_TO_BC_WIDTH = 30 ;
   localparam INTF_B_TO_PA_WIDTH = 48+1 ;
   localparam INTF_PA_TO_B_WIDTH = 48+1 ;
   localparam INTF_CORE_TO_PLL_WIDTH = 20 ;
   localparam INTF_BUFFS_TO_B_WIDTH = 12 ;
   localparam INTF_B_TO_BUFFS_WIDTH = 24 ;

   localparam INTF_SEQ_TO_PA_WIDTH  = 2*PORT_SEQ_CFG_RANK_WIDTH +
                                      2*PORT_SEQ_CFG_DATA_EN_WIDTH +
                                      PORT_SEQ_CFG_SUPPRESSION_WIDTH +
                                      PORT_SEQ_CFG_WR_DQS_EN_WIDTH +
                                      PORT_SEQ_CFG_DATA_WIDTH +
                                      1;
                      
   localparam INTF_PA_TO_SEQ_WIDTH  = PORT_SEQ_CFG_DATA_WIDTH +
                                      PORT_SEQ_CFG_RDDATA_VALID_WIDTH +
                                      4 + 
                                      PORT_SEQ_CFG_RB_BASE_ADDRESS_WIDTH;


    localparam [1:0] MC_USED = { ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_hmc_slim::IS_USED == 1 && ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_hmc_slim::IS_DUMMY_SLIM == 0,
                                 ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_hmc_wide::IS_USED == 1};
    
    localparam LOCKSTEP_SECONDARY =  ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_hmc_wide::LOCKSTEP_CONFIG == "LOCKSTEP_CONFIG_SECONDARY";


   // Define all atom interfaces
   logic  [INTF_SEQ_AVBB_INTF_WIDTH-1:0]                                         seq_avbb;
   logic  [INTF_SEQ_AVBB_INTF_WIDTH-1:0]                                         seq_to_pll_avbb;
   logic  [INTF_SEQ_AVBB_INTF_WIDTH-1:0]                                         seq_to_cpa_avbb;
   logic  [7:0][INTF_SEQ_TO_PA_WIDTH-1:0]                                        seq_to_pa;
   logic  [7:0][INTF_PERIPH_TO_SEQ_WIDTH-1:0]                                    bc_to_seq;
   logic  [INTF_PERIPH_TO_SEQ_WIDTH-1:0]                                         cpa_to_seq;
   logic  [7:0][INTF_PA_TO_SEQ_WIDTH-1:0]                                        pa_to_seq;
   logic  [INTF_PLL_TO_SEQ_WIDTH-1:0]                                            pll_to_seq;

   logic  [INTF_PLL_TO_FA_WIDTH-1:0]                                             pll_to_falane;
   logic  [INTF_PLL_TO_BC_WIDTH-1:0]                                             pll_to_bc;
   logic  [INTF_PLL_TO_CPA_WIDTH-1:0]                                            pll_to_cpa;
   logic  [INTF_PLL_TO_HMC_WIDTH-1:0]                                            pll_to_hmc;
   logic  [INTF_PLL_TO_PA_WIDTH-1:0]                                             pll_to_pa;
   logic  [INTF_PLL_TO_CORE_WIDTH-1:0]                                           pll_to_core;

   logic  [1:0][INTF_FAHMC_TO_CORE_WIDTH-1:0]                                    fahmc_to_core;
   logic                                                                         cpa_to_fahmc;
   logic  [1:0][INTF_CORE_TO_FAHMC_WIDTH-1:0]                                    core_to_fahmc;
   logic  [INTF_PLL_TO_FA_WIDTH-1:0]                                             pll_to_fahmc;

   logic  [INTF_PLL_TO_FA_WIDTH-1:0]                                             pll_to_fanoc;

   logic  [7:0][INTF_FALANE_TO_CORE_WIDTH-1:0]                                   falane_to_core;
   logic  [1:0][3:0][INTF_FALANE_TO_HMC_WIDTH-1:0]                               falane_to_hmc; 
   logic  [1:0][3:0][INTF_HMC_TO_FALANE_WIDTH-1:0]                               hmc_to_falane; 
   logic                                                                         cpa_to_falane;
   logic  [7:0][INTF_CORE_TO_FALANE_WIDTH-1:0]                                   core_to_falane;

   logic  [1:0][INTF_HMC_TO_IOSSM_WIDTH-1:0]                                     hmc_to_iossm;
   logic  [INTF_IOSSM_TO_HMC_WIDTH-1:0]                                          iossm_to_hmc;
   logic  [1:0]                                                                  iossm_to_hmc_rst_n;
   logic  [1:0][INTF_OTHER_HMC_WIDTH-1:0]                                        other_hmc;
   logic  [NUM_HMC_IN_IO96-1:0][NUM_BYTES_IN_IO96-1:0][INTF_HMC_TO_PA_WIDTH-1:0] hmc_to_pa;
   logic  [NUM_HMC_IN_IO96-1:0][NUM_BYTES_IN_IO96-1:0][INTF_PA_TO_HMC_WIDTH-1:0] pa_to_hmc;
   logic                                                                         core_to_hmc;

   logic  [INTF_CORE_TO_PLL_WIDTH-1:0]                                           core_to_pll;
   logic  [NUM_BYTES_IN_IO96-1:0][INTF_BUFFS_TO_B_WIDTH-1:0]                     buffs_to_b;
   logic  [NUM_BYTES_IN_IO96-1:0][INTF_BUFFS_TO_B_WIDTH-1:0]                     buffs_to_pa_alert_n;
   logic  [NUM_BYTES_IN_IO96-1:0][INTF_B_TO_BUFFS_WIDTH-1:0]                     b_to_buffs;
   logic  [INTF_DDR5_I3C_M2S_WIDTH-1:0]                                          iossm_to_buffs_i3c;
   logic  [INTF_DDR5_I3C_S2M_WIDTH-1:0]                                          buffs_to_iossm_i3c;

   logic                                                                         cpa_locked;
   logic [1:0]                                                                   hmc_to_fanoc;
   logic [1:0]                                                                   fanoc_to_core;
   
   logic usr_rst_n_0_int;
   altera_std_synchronizer_nocut #(
      .depth      (3),
      .rst_value  (0)
   ) lock_sync_inst (
      .clk        (usr_clk_0),
      .reset_n    (core_init_n_0),
      .din        (cpa_locked),
      .dout       (usr_rst_n_0_int)
   );
   assign usr_rst_n_0 = LOCKSTEP_SECONDARY ? ls_usr_rst_n_0 : usr_rst_n_0_int;
   assign {noc_rst_n_1, noc_rst_n_0} = 2'b11;

   assign { seq_avbb           ,
            seq_to_pll_avbb    ,
            seq_to_cpa_avbb    ,
            iossm_to_hmc       ,
            iossm_to_buffs_i3c ,
            seq_to_pa          ,
            iossm_to_hmc_rst_n } = calbus_0;

   assign calbus_readdata_0 =   { bc_to_seq   ,
                                  cpa_to_seq    ,
                                  pll_to_seq    ,
                                  pa_to_seq     ,
                                  hmc_to_iossm  ,
                                  buffs_to_iossm_i3c};


   AXI_BUS #( 
      .PORT_AXI_AXADDR_WIDTH  (PORT_AXI_AXADDR_WIDTH ),
      .PORT_AXI_AXID_WIDTH    (PORT_AXI_AXID_WIDTH   ),
      .PORT_AXI_AXBURST_WIDTH (PORT_AXI_AXBURST_WIDTH),
      .PORT_AXI_AXLEN_WIDTH   (PORT_AXI_AXLEN_WIDTH  ),
      .PORT_AXI_AXSIZE_WIDTH  (PORT_AXI_AXSIZE_WIDTH ),
      .PORT_AXI_AXUSER_WIDTH  (PORT_AXI_AXUSER_WIDTH ),
      .PORT_AXI_DATA_WIDTH    (PORT_AXI_DATA_WIDTH   ),
      .PORT_AXI_STRB_WIDTH    (PORT_AXI_STRB_WIDTH   ),
      .PORT_AXI_RESP_WIDTH    (PORT_AXI_RESP_WIDTH   ),
      .PORT_AXI_ID_WIDTH      (PORT_AXI_ID_WIDTH     ),
      .PORT_AXI_USER_WIDTH    (PORT_AXI_S0_USER_WIDTH),
      .PORT_AXI_AXQOS_WIDTH   (PORT_AXI_AXQOS_WIDTH  ),
      .PORT_AXI_AXCACHE_WIDTH (PORT_AXI_AXCACHE_WIDTH),
      .PORT_AXI_AXPROT_WIDTH  (PORT_AXI_AXPROT_WIDTH)
   ) core_fanoc_axi_intf [1:0](),
     fanoc_hmc_axi_intf [1:0](),
     fbr_axi_adapter_intf [1:0]();
   

   generate
      if (PHY_NOC_EN) begin : noc_en
         assign noc_aclk_0      = (MC_USED[0] == 1'b1) ? fanoc_to_core[0] : fanoc_to_core[1]; 
         assign s0_axi4_ruser   = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].ruser   : core_fanoc_axi_intf[1].ruser;
         assign s0_axi4_rdata   = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].rdata   : core_fanoc_axi_intf[1].rdata;
         assign s0_axi4_arready = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].arready : core_fanoc_axi_intf[1].arready;
         assign s0_axi4_awready = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].awready : core_fanoc_axi_intf[1].awready;
         assign s0_axi4_bid     = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].bid     : core_fanoc_axi_intf[1].bid;
         assign s0_axi4_bresp   = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].bresp   : core_fanoc_axi_intf[1].bresp;
         assign s0_axi4_bvalid  = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].bvalid  : core_fanoc_axi_intf[1].bvalid;
         assign s0_axi4_rid     = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].rid     : core_fanoc_axi_intf[1].rid;
         assign s0_axi4_rlast   = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].rlast   : core_fanoc_axi_intf[1].rlast;
         assign s0_axi4_rresp   = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].rresp   : core_fanoc_axi_intf[1].rresp;
         assign s0_axi4_rvalid  = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].rvalid  : core_fanoc_axi_intf[1].rvalid;
         assign s0_axi4_wready  = (MC_USED[0] == 1'b1) ? core_fanoc_axi_intf[0].wready  : core_fanoc_axi_intf[1].wready;

         assign noc_aclk_1      = fanoc_to_core[1];
         assign s1_axi4_ruser   = core_fanoc_axi_intf[1].ruser;
         assign s1_axi4_rdata   = core_fanoc_axi_intf[1].rdata;
         assign s1_axi4_arready = core_fanoc_axi_intf[1].arready;
         assign s1_axi4_awready = core_fanoc_axi_intf[1].awready;
         assign s1_axi4_bid     = core_fanoc_axi_intf[1].bid;
         assign s1_axi4_bresp   = core_fanoc_axi_intf[1].bresp;
         assign s1_axi4_bvalid  = core_fanoc_axi_intf[1].bvalid;
         assign s1_axi4_rid     = core_fanoc_axi_intf[1].rid;
         assign s1_axi4_rlast   = core_fanoc_axi_intf[1].rlast;
         assign s1_axi4_rresp   = core_fanoc_axi_intf[1].rresp;
         assign s1_axi4_rvalid  = core_fanoc_axi_intf[1].rvalid;
         assign s1_axi4_wready  = core_fanoc_axi_intf[1].wready;

         assign core_fanoc_axi_intf[0].wstrb = s0_axi4_wstrb;
         assign core_fanoc_axi_intf[0].wdata = s0_axi4_wdata;
         assign core_fanoc_axi_intf[1].wdata = (MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_wdata : s0_axi4_wdata;
         assign core_fanoc_axi_intf[1].wstrb = (MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_wstrb : s0_axi4_wstrb;

         for (genvar i0 = 0; i0 < 2; ++i0) begin : intf
            assign core_fanoc_axi_intf[i0].awid    = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awid          : s0_axi4_awid;
            assign core_fanoc_axi_intf[i0].awaddr  = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awaddr        : s0_axi4_awaddr;
            assign core_fanoc_axi_intf[i0].awlen   = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awlen         : s0_axi4_awlen;
            assign core_fanoc_axi_intf[i0].awsize  = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awsize        : s0_axi4_awsize;
            assign core_fanoc_axi_intf[i0].awburst = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awburst       : s0_axi4_awburst;
            assign core_fanoc_axi_intf[i0].awlock  = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awlock        : s0_axi4_awlock;
            assign core_fanoc_axi_intf[i0].awqos   = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awqos[3:2]    : s0_axi4_awqos[3:2];
            assign core_fanoc_axi_intf[i0].awcache = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awcache       : s0_axi4_awcache;
            assign core_fanoc_axi_intf[i0].awuser  = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awuser        : s0_axi4_awuser;
            assign core_fanoc_axi_intf[i0].awvalid = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awvalid       : s0_axi4_awvalid;
            assign core_fanoc_axi_intf[i0].wlast   = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_wlast         : s0_axi4_wlast;
            assign core_fanoc_axi_intf[i0].wuser   = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_wuser         : s0_axi4_wuser;
            assign core_fanoc_axi_intf[i0].wvalid  = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_wvalid        : s0_axi4_wvalid;
            assign core_fanoc_axi_intf[i0].bready  = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_bready        : s0_axi4_bready;
            assign core_fanoc_axi_intf[i0].arid    = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arid          : s0_axi4_arid;
            assign core_fanoc_axi_intf[i0].araddr  = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_araddr        : s0_axi4_araddr;
            assign core_fanoc_axi_intf[i0].arlen   = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arlen         : s0_axi4_arlen;
            assign core_fanoc_axi_intf[i0].arsize  = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arsize        : s0_axi4_arsize;
            assign core_fanoc_axi_intf[i0].arburst = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arburst       : s0_axi4_arburst;
            assign core_fanoc_axi_intf[i0].arlock  = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arlock        : s0_axi4_arlock;
            assign core_fanoc_axi_intf[i0].arqos   = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arqos[3:2]    : s0_axi4_arqos[3:2];
            assign core_fanoc_axi_intf[i0].aruser  = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_aruser        : s0_axi4_aruser;
            assign core_fanoc_axi_intf[i0].arvalid = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arvalid       : s0_axi4_arvalid;
            assign core_fanoc_axi_intf[i0].rready  = (i0 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_rready        : s0_axi4_rready;

            assign fbr_axi_adapter_intf[i0].awvalid = '0;
            assign fbr_axi_adapter_intf[i0].arvalid = '0;
            assign fbr_axi_adapter_intf[i0].wvalid = '0;
         end
      end
      else begin : noc_dis
         assign fbr_axi_adapter_intf[0].wdata = s0_axi4_wdata;
         assign fbr_axi_adapter_intf[1].wdata = (MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_wdata :
                                                (MC_USED == 2'b11)               ?  { { (PORT_AXI_DATA_WIDTH - 120) { 1'b0 } }, 
                                                                                         s0_axi4_wuser[63:56], 8'h0, s0_axi4_wuser[55:48], 
                                                                                   8'h0, s0_axi4_wuser[47:40], 8'h0, s0_axi4_wuser[39:32],
                                                                                   8'h0, s0_axi4_wuser[31:24], 8'h0, s0_axi4_wuser[23:16],
                                                                                   8'h0, s0_axi4_wuser[15:8],  8'h0, s0_axi4_wuser[7:0] }
                                                                                 :  s0_axi4_wdata;
         logic [15:0] w_slim_wstrb;
         assign w_slim_wstrb = { s0_axi4_wstrb[28], s0_axi4_wstrb[28], s0_axi4_wstrb[24], s0_axi4_wstrb[24],
                                 s0_axi4_wstrb[20], s0_axi4_wstrb[20], s0_axi4_wstrb[16], s0_axi4_wstrb[16],
                                 s0_axi4_wstrb[12], s0_axi4_wstrb[12], s0_axi4_wstrb[ 8], s0_axi4_wstrb[ 8],
                                 s0_axi4_wstrb[ 4], s0_axi4_wstrb[ 4], s0_axi4_wstrb[ 0], s0_axi4_wstrb[ 0] };
                                 
         assign fbr_axi_adapter_intf[0].wstrb = s0_axi4_wstrb;
         assign fbr_axi_adapter_intf[1].wstrb = (MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_wstrb :
                                                                                  ( MC_USED == 2'b11 ? ( PORT_AXI_STRB_WIDTH > 16 ? {'0 , w_slim_wstrb } :
                                                                                                         w_slim_wstrb[PORT_AXI_STRB_WIDTH-1:0] )
                                                                                                     : s0_axi4_wstrb );
                                                    
         assign fbr_axi_adapter_intf[0].awsize  = s0_axi4_awsize;
         assign fbr_axi_adapter_intf[1].awsize  = (MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awsize : 
                                                  (MC_USED == 2'b11)               ? s0_axi4_awsize - 1'b1 : s0_axi4_awsize;
         assign fbr_axi_adapter_intf[0].arsize  = s0_axi4_arsize;
         assign fbr_axi_adapter_intf[1].arsize  = (MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arsize : 
                                                  (MC_USED == 2'b11)               ? s0_axi4_arsize - 1'b1 : s0_axi4_arsize;
         
         assign s0_axi4_ruser = (MEM_NUM_CHANNELS_PER_IO96 == 1 && MC_USED == 2'b11) ? 
                                                   { fbr_axi_adapter_intf[1].rdata[119:112], fbr_axi_adapter_intf[1].rdata[103:96],
                                                     fbr_axi_adapter_intf[1].rdata[87:80],   fbr_axi_adapter_intf[1].rdata[71:64],
                                                     fbr_axi_adapter_intf[1].rdata[55:48],   fbr_axi_adapter_intf[1].rdata[39:32],
                                                     fbr_axi_adapter_intf[1].rdata[23:16],   fbr_axi_adapter_intf[1].rdata[7:0] }
                                                   : MC_USED[0] == 1'b1 ? fbr_axi_adapter_intf[0].ruser : fbr_axi_adapter_intf[1].ruser;
         assign s0_axi4_rdata   = (MC_USED[0] == 1'b1) ? fbr_axi_adapter_intf[0].rdata   : fbr_axi_adapter_intf[1].rdata;
         assign s0_axi4_arready = (MC_USED[0] == 1'b1) ? fbr_axi_adapter_intf[0].arready : fbr_axi_adapter_intf[1].arready;
         assign s0_axi4_awready = (MC_USED[0] == 1'b1) ? fbr_axi_adapter_intf[0].awready : fbr_axi_adapter_intf[1].awready;
         assign s0_axi4_bid     = (MC_USED[0] == 1'b1) ? fbr_axi_adapter_intf[0].bid     : fbr_axi_adapter_intf[1].bid;
         assign s0_axi4_bresp   = (MC_USED[0] == 1'b1) ? fbr_axi_adapter_intf[0].bresp   : fbr_axi_adapter_intf[1].bresp;
         assign s0_axi4_bvalid  = (MC_USED[0] == 1'b1) ? fbr_axi_adapter_intf[0].bvalid  : fbr_axi_adapter_intf[1].bvalid;
         assign s0_axi4_rid     = (MC_USED[0] == 1'b1) ? fbr_axi_adapter_intf[0].rid     : fbr_axi_adapter_intf[1].rid;
         assign s0_axi4_rlast   = (MC_USED[0] == 1'b1) ? fbr_axi_adapter_intf[0].rlast   : fbr_axi_adapter_intf[1].rlast;
         assign s0_axi4_rresp   = (MC_USED[0] == 1'b1) ? fbr_axi_adapter_intf[0].rresp   : fbr_axi_adapter_intf[1].rresp;
         assign s0_axi4_rvalid  = (MEM_NUM_CHANNELS_PER_IO96 == 1 && MC_USED == 2'b11) ?  fbr_axi_adapter_intf[0].rvalid & fbr_axi_adapter_intf[1].rvalid :
                                  (MC_USED[0] == 1'b1) ? fbr_axi_adapter_intf[0].rvalid  : fbr_axi_adapter_intf[1].rvalid;
         assign s0_axi4_wready  = (MC_USED[0] == 1'b1) ? fbr_axi_adapter_intf[0].wready  : fbr_axi_adapter_intf[1].wready;
         
         assign s1_axi4_ruser   = fbr_axi_adapter_intf[1].ruser;
         assign s1_axi4_rdata   = fbr_axi_adapter_intf[1].rdata;
         assign s1_axi4_arready = fbr_axi_adapter_intf[1].arready;
         assign s1_axi4_awready = fbr_axi_adapter_intf[1].awready;
         assign s1_axi4_bid     = fbr_axi_adapter_intf[1].bid;
         assign s1_axi4_bresp   = fbr_axi_adapter_intf[1].bresp;
         assign s1_axi4_bvalid  = fbr_axi_adapter_intf[1].bvalid;
         assign s1_axi4_rid     = fbr_axi_adapter_intf[1].rid;
         assign s1_axi4_rlast   = fbr_axi_adapter_intf[1].rlast;
         assign s1_axi4_rresp   = fbr_axi_adapter_intf[1].rresp;
         assign s1_axi4_rvalid  = fbr_axi_adapter_intf[1].rvalid;
         assign s1_axi4_wready  = fbr_axi_adapter_intf[1].wready;

         for (genvar i1 = 0; i1 < 2; ++i1) begin : intf
            assign fbr_axi_adapter_intf[i1].awid    = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awid        : s0_axi4_awid;
            assign fbr_axi_adapter_intf[i1].awaddr  = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awaddr      : s0_axi4_awaddr;
            assign fbr_axi_adapter_intf[i1].awlen   = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awlen       : s0_axi4_awlen;
            assign fbr_axi_adapter_intf[i1].awburst = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awburst     : s0_axi4_awburst;
            assign fbr_axi_adapter_intf[i1].awlock  = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awlock      : s0_axi4_awlock;
            assign fbr_axi_adapter_intf[i1].awqos   = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awqos       : s0_axi4_awqos;
            assign fbr_axi_adapter_intf[i1].awcache = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awcache     : s0_axi4_awcache;
            assign fbr_axi_adapter_intf[i1].awuser  = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awuser      : s0_axi4_awuser;
            assign fbr_axi_adapter_intf[i1].awvalid = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_awvalid     : s0_axi4_awvalid;
            assign fbr_axi_adapter_intf[i1].wlast   = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_wlast       : s0_axi4_wlast;
            assign fbr_axi_adapter_intf[i1].wvalid  = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_wvalid      : s0_axi4_wvalid;
            assign fbr_axi_adapter_intf[i1].bready  = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_bready      : s0_axi4_bready;
            assign fbr_axi_adapter_intf[i1].arid    = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arid        : s0_axi4_arid;
            assign fbr_axi_adapter_intf[i1].araddr  = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_araddr      : s0_axi4_araddr;
            assign fbr_axi_adapter_intf[i1].arlen   = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arlen       : s0_axi4_arlen;
            assign fbr_axi_adapter_intf[i1].arburst = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arburst     : s0_axi4_arburst;
            assign fbr_axi_adapter_intf[i1].arlock  = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arlock      : s0_axi4_arlock;
            assign fbr_axi_adapter_intf[i1].arqos   = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arqos       : s0_axi4_arqos;
            assign fbr_axi_adapter_intf[i1].aruser  = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_aruser      : s0_axi4_aruser;
            assign fbr_axi_adapter_intf[i1].arvalid = (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_arvalid     : s0_axi4_arvalid;
            assign fbr_axi_adapter_intf[i1].rready  = (MEM_NUM_CHANNELS_PER_IO96 == 1 && MC_USED == 2'b11) ? s0_axi4_rready & s0_axi4_rvalid :
                                                        (i1 == 1 && MEM_NUM_CHANNELS_PER_IO96 == 2) ? s1_axi4_rready      : s0_axi4_rready;

            assign core_fanoc_axi_intf[i1].awvalid = '0;
            assign core_fanoc_axi_intf[i1].arvalid = '0;
            assign core_fanoc_axi_intf[i1].wvalid = '0;
         end
      end
   endgenerate


   assign core_to_hmc = usr_clk_0; 
   ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_bufs_mem # (
      .MEM_NUM_CHANNELS_PER_IO96 (MEM_NUM_CHANNELS_PER_IO96),
      .LOCKSTEP_SECONDARY        (LOCKSTEP_SECONDARY ),
      .MEM_CK_T_WIDTH            (MEM_CK_T_WIDTH     ),
      .MEM_CK_C_WIDTH            (MEM_CK_C_WIDTH     ),
      .MEM_CKE_WIDTH             (MEM_CKE_WIDTH      ),
      .MEM_ODT_WIDTH             (MEM_ODT_WIDTH      ),
      .MEM_CS_N_WIDTH            (MEM_CS_N_WIDTH     ),
      .MEM_C_WIDTH               (MEM_C_WIDTH        ),
      .MEM_A_WIDTH               (MEM_A_WIDTH        ),
      .MEM_BA_WIDTH              (MEM_BA_WIDTH       ),
      .MEM_BG_WIDTH              (MEM_BG_WIDTH       ),
      .MEM_ACT_N_WIDTH           (MEM_ACT_N_WIDTH    ),
      .MEM_PAR_WIDTH             (MEM_PAR_WIDTH      ),
      .MEM_LBS_WIDTH             (MEM_LBS_WIDTH      ),
      .MEM_LBD_WIDTH             (MEM_LBD_WIDTH      ),
      .MEM_ALERT_N_WIDTH         (MEM_ALERT_N_WIDTH  ),
      .MEM_RESET_N_WIDTH         (MEM_RESET_N_WIDTH  ),
      .MEM_DQ_WIDTH              (PORT_MEM_DQ_WIDTH       ),
      .MEM_DQS_T_WIDTH           (PORT_MEM_DQS_T_WIDTH    ),
      .MEM_DQS_C_WIDTH           (PORT_MEM_DQS_C_WIDTH    ),
      .MEM_DBI_N_WIDTH           (PORT_MEM_DBI_N_WIDTH    ),
      .MEM_CA_WIDTH              (MEM_CA_WIDTH       ),
      .MEM_DM_N_WIDTH            (MEM_DM_N_WIDTH     ),
      .MEM_WCK_T_WIDTH           (MEM_WCK_T_WIDTH    ),
      .MEM_WCK_C_WIDTH           (MEM_WCK_C_WIDTH    ),
      .MEM_CS_WIDTH              (MEM_CS_WIDTH       ),
      .OCT_RZQIN_WIDTH           (OCT_RZQIN_WIDTH    ),
      .MEM_RDQS_T_WIDTH          (MEM_RDQS_T_WIDTH   ),
      .MEM_RDQS_C_WIDTH          (MEM_RDQS_C_WIDTH   ),
      .MEM_DMI_WIDTH             (MEM_DMI_WIDTH      ) 
   ) wrapper_bufs_mem (
      .*
   );

   generate
      if (PHY_I3C_EN) begin : i3c
         ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_bufs_i3c # (
            .INTF_DDR5_I3C_M2S_WIDTH (INTF_DDR5_I3C_M2S_WIDTH),
            .INTF_DDR5_I3C_S2M_WIDTH (INTF_DDR5_I3C_S2M_WIDTH),
            .I3C_SCL_WIDTH           (I3C_SCL_WIDTH),
            .I3C_SDA_WIDTH           (I3C_SDA_WIDTH)
         ) wrapper_bufs_i3c (
            .i3c_scl    (i3c_scl_0),
            .i3c_sda    (i3c_sda_0),
            .*
         );
      end
      else begin : i3c_tieoff
        assign buffs_to_iossm_i3c = '0;
        assign i3c_scl_0 = '0;
      end

   endgenerate

   logic [7:0][1:0]  bc_to_bc  ;
   generate
      genvar i;
      for (i = 0; i < NUM_BYTES_IN_IO96; ++i) begin: gen_byte_conns
         logic [INTF_FALANE_TO_PA_WIDTH-1:0]    falane_to_pa ;
         logic [INTF_PA_TO_FALANE_WIDTH-1:0]    pa_to_falane ;
         logic [INTF_BC_TO_B_WIDTH-1:0]         bc_to_b      ;
         logic [INTF_B_TO_BC_WIDTH-1:0]         b_to_bc      ;
         logic [INTF_BC_TO_PA_WIDTH-1:0]        bc_to_pa     ;
         logic [INTF_PA_TO_BC_WIDTH-1:0]        pa_to_bc     ;
         logic [INTF_B_TO_PA_WIDTH-1:0]         b_to_pa      ;
         logic [INTF_PA_TO_B_WIDTH-1:0]         pa_to_b      ;
         logic [INTF_PA_TO_HMC_WIDTH-1:0]       pa_to_mc     ;
         logic [INTF_HMC_TO_PA_WIDTH-1:0]       mc_to_pa     ;

         ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_byte # (
            .ID(i)
         ) wrapper_byte (
            .b_to_buffs   (b_to_buffs[i]),
            .buffs_to_b   (buffs_to_b[i]),
            .*
         );

         ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_byte_ctrl # (
            .ID(i)
         ) wrapper_byte_ctrl (
            .bc_to_seq (bc_to_seq[i]),
            .bc_to_bc_x16_out (bc_to_bc[i]),
            .bc_to_bc_x16_in  (bc_to_bc[(i+7)%8]),
            .*
         );
         
        if(SLIM_BL_EN[i] == 1'b0)
        begin: wide_byte_pa
            assign mc_to_pa = hmc_to_pa[0][i];
        end
        else
        begin: slim_byte_pa
            assign mc_to_pa = hmc_to_pa[1][i];
        end
        
        assign pa_to_hmc[0][i] = pa_to_mc;
        assign pa_to_hmc[1][i] = pa_to_mc;

        ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_pa # (
            .ID(i)
        ) wrapper_pa (
            .hmc_to_pa (mc_to_pa), 
            .pa_to_hmc (pa_to_mc), 
            .seq_to_pa (seq_to_pa[i]),
            .pa_to_seq (pa_to_seq[i]),
            .buffs_to_pa(buffs_to_pa_alert_n[i]),
            .*
        );

        ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_fa_lane # (
            .ID(i)
         ) wrapper_falane (
            .cpa_to_falane(cpa_to_falane),
            .pll_to_falane   (pll_to_falane   ),
            .core_to_falane  (core_to_falane[i]),
            .falane_to_core  (falane_to_core[i]),
            .pa_to_falane    (pa_to_falane    ), 
            .falane_to_pa    (falane_to_pa    ),
            .hmc_to_falane (hmc_to_falane[i/4][i%4]),
            .falane_to_hmc (falane_to_hmc[i/4][i%4])
         );

         // synthesis translate_off
         //Hack to remove later once CFE RTL/Quartus atoms expose 
         if (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_byte_ctrl::IS_USED[i] && ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_byte::IS_USED[i]) begin

            assign wrapper_byte.i_phy_gpio_dout_sel[11:0]                                                  = wrapper_pa.gen_used_pa.pa.o_pa2phy_gpio_dout_sel;
                                                                                                           
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_datatrainfeedback_dqsnparklovohcode  = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_datatrainfeedback_dqsnparklovohcode;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_datatrainfeedback_dqsnparklowvoh     = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_datatrainfeedback_dqsnparklowvoh;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_dcd_ter_en                               = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_dcd_ter_en;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_from_sdll0_o_dcdsawl_clk                 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_from_sdll0_o_dcdsawl_clk;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_from_sdll1_o_dcdsawl_clk                 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_from_sdll1_o_dcdsawl_clk;
            assign wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.i_rx_rxdqsampresult     = wrapper_byte.gen_used_byte.u_byte.io12phy_inst.o_rx_rxdqsampresult;
            assign wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.i_DCCXtalkControl_RunDCC       = wrapper_byte.gen_used_byte.u_byte.io12phy_inst.o_DCCXtalkControl_RunDCC       ;
            assign wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.i_DCCXtalkControl_SelMeasPoint = wrapper_byte.gen_used_byte.u_byte.io12phy_inst.o_DCCXtalkControl_SelMeasPoint ;
            assign wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.i_DCCXtalkControl_DCCSamples   = wrapper_byte.gen_used_byte.u_byte.io12phy_inst.o_DCCXtalkControl_DCCSamples   ;


            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_00 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_00;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_01 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_01;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_02 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_02;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_03 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_03;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_04 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_04;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_05 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_05;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_06 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_06;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_07 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_07;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_08 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_08;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_09 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_09;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_10 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_10;
            assign wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_11 = wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.o_phyctrl_calib_count_11;


            initial begin
               #1ns;
               release wrapper_byte.i_phy_gpio_dout_sel[11:0];
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_datatrainfeedback_dqsnparklovohcode;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_datatrainfeedback_dqsnparklowvoh;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_dcd_ter_en;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_from_sdll0_o_dcdsawl_clk;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_from_sdll1_o_dcdsawl_clk;
               release wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.i_rx_rxdqsampresult;
               release wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.i_DCCXtalkControl_RunDCC;
               release wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.i_DCCXtalkControl_SelMeasPoint;
               release wrapper_byte_ctrl.gen_used_byte_ctrl.u_byte_ctrl.io12phyctrl_inst.i_DCCXtalkControl_DCCSamples;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_00;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_01;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_02;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_03;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_04;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_05;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_06;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_07;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_08;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_09;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_10;
               release wrapper_byte.gen_used_byte.u_byte.io12phy_inst.i_phy_calib_count_11;
            end

         end
         // synthesis translate_on
      end
   endgenerate

   logic [1:0][PARAM_TABLE_WIDTH-1:0]  o_sim_param_table;
   logic [1:0][INTF_FAHMC_TO_HMC_WIDTH-1:0]  fahmc_to_hmc;
   logic [1:0][INTF_HMC_TO_FAHMC_WIDTH-1:0]  hmc_to_fahmc;
   assign calbus_param_table_0 = o_sim_param_table;

   ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_hmc_wide # (
      .ID(0),
      .AXI4_ADDR_WIDTH(AXI4_ADDR_WIDTH),
      .AXI4_DATA_WIDTH(256)  
   ) wrapper_hmc_wide (
      .pa7_to_hmc  (pa_to_hmc[0][7]),
      .pa6_to_hmc  (pa_to_hmc[0][6]),
      .pa5_to_hmc  (pa_to_hmc[0][5]),
      .pa4_to_hmc  (pa_to_hmc[0][4]),
      .pa3_to_hmc  (pa_to_hmc[0][3]),
      .pa2_to_hmc  (pa_to_hmc[0][2]),
      .pa1_to_hmc  (pa_to_hmc[0][1]),
      .pa0_to_hmc  (pa_to_hmc[0][0]),
      .hmc_to_core (hmc_to_fanoc[0]),
      .hmc_to_pa7  (hmc_to_pa[0][7]),
      .hmc_to_pa6  (hmc_to_pa[0][6]),
      .hmc_to_pa5  (hmc_to_pa[0][5]),
      .hmc_to_pa4  (hmc_to_pa[0][4]),
      .hmc_to_pa3  (hmc_to_pa[0][3]),
      .hmc_to_pa2  (hmc_to_pa[0][2]),
      .hmc_to_pa1  (hmc_to_pa[0][1]),
      .hmc_to_pa0  (hmc_to_pa[0][0]),
      .hmc_to_iossm (hmc_to_iossm[0]),
      .hmc_to_falane (hmc_to_falane[0]),
      .falane_to_hmc (falane_to_hmc[0]),
      .hmc_to_fahmc (hmc_to_fahmc[0]),
      .fahmc_to_hmc (fahmc_to_hmc[0]),
      .fanoc_hmc_axi_intf (fanoc_hmc_axi_intf[0]),
      .iossm_to_hmc (iossm_to_hmc),
      .iossm_to_hmc_rst_n (iossm_to_hmc_rst_n[0]),
      .to_other_hmc   (other_hmc[0]),
      .from_other_hmc (other_hmc[1]),
      .o_sim_param_table(o_sim_param_table[0]),
      .*
   );

   ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_hmc_slim # (
      .ID(1),
      .AXI4_ADDR_WIDTH(AXI4_ADDR_WIDTH),
      .AXI4_DATA_WIDTH((MEM_NUM_CHANNELS_PER_IO96 == 1 && MC_USED == 2'b11) ? 128 : PORT_AXI_DATA_WIDTH)
   ) wrapper_hmc_slim (
      .pa7_to_hmc  (pa_to_hmc[1][7]),
      .pa6_to_hmc  (pa_to_hmc[1][6]),
      .pa5_to_hmc  (pa_to_hmc[1][5]),
      .pa4_to_hmc  (pa_to_hmc[1][4]),
      .pa3_to_hmc  (pa_to_hmc[1][3]),
      .pa2_to_hmc  (pa_to_hmc[1][2]),
      .pa1_to_hmc  (pa_to_hmc[1][1]),
      .pa0_to_hmc  (pa_to_hmc[1][0]),
      .hmc_to_core (hmc_to_fanoc[1]),
      .hmc_to_pa7  (hmc_to_pa[1][7]),
      .hmc_to_pa6  (hmc_to_pa[1][6]),
      .hmc_to_pa5  (hmc_to_pa[1][5]),
      .hmc_to_pa4  (hmc_to_pa[1][4]),
      .hmc_to_pa3  (hmc_to_pa[1][3]),
      .hmc_to_pa2  (hmc_to_pa[1][2]),
      .hmc_to_pa1  (hmc_to_pa[1][1]),
      .hmc_to_pa0  (hmc_to_pa[1][0]),
      .hmc_to_iossm (hmc_to_iossm[1]),
      .hmc_to_falane (hmc_to_falane[1]),
      .falane_to_hmc (falane_to_hmc[1]),
      .hmc_to_fahmc (hmc_to_fahmc[1]),
      .fahmc_to_hmc (fahmc_to_hmc[1]),
      .fanoc_hmc_axi_intf (fanoc_hmc_axi_intf[1]),
      .iossm_to_hmc (iossm_to_hmc),   
      .iossm_to_hmc_rst_n (iossm_to_hmc_rst_n[1]),
      .to_other_hmc   (other_hmc[1]),
      .from_other_hmc (other_hmc[0]),
      .o_sim_param_table(o_sim_param_table[1]),
      .*
   );

   ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_fa_hmc # (
      .ID(0)
   ) wrapper_fahmc_wide (
      .core_to_fahmc             (core_to_fahmc[0]),
      .fahmc_to_core             (fahmc_to_core[0]),
      .hmc_to_fahmc              (hmc_to_fahmc[0]),
      .fahmc_to_hmc              (fahmc_to_hmc[0]),
      .*
   );

   ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_fa_noc # (
      .ID(0)
   ) wrapper_fanoc_wide (
      .core_fanoc_axi_intf       (core_fanoc_axi_intf[0]),
      .fanoc_hmc_axi_intf        (fanoc_hmc_axi_intf[0]),
      .pll_to_fanoc              (pll_to_fanoc),
      .hmc_to_fanoc              (hmc_to_fanoc[0]),
      .fanoc_to_core             (fanoc_to_core[0])
   );

   ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_fa_hmc # (
      .ID(1)
   ) wrapper_fahmc_slim (
      .core_to_fahmc             (core_to_fahmc[1]),
      .fahmc_to_core             (fahmc_to_core[1]),
      .hmc_to_fahmc              (hmc_to_fahmc[1]),
      .fahmc_to_hmc              (fahmc_to_hmc[1]),
      .*
   );

   ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_fa_noc # (
      .ID(1)
   ) wrapper_fanoc_slim (
      .core_fanoc_axi_intf       (core_fanoc_axi_intf[1]),
      .fanoc_hmc_axi_intf        (fanoc_hmc_axi_intf[1]),
      .pll_to_fanoc              (pll_to_fanoc),
      .hmc_to_fanoc              (hmc_to_fanoc[1]),
      .fanoc_to_core             (fanoc_to_core[1])
   );

   wire pll_rst_n;
   assign pll_rst_n = 1'b1;

   ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_pll # (
   ) wrapper_pll (
      .ref_clk    (ref_clk_0),
      .rst_n      (pll_rst_n),
      .seq_avbb   (seq_to_pll_avbb),
      .*
   );
   assign core_to_pll = '0;

   ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_cpa # (
   ) wrapper_cpa (
      .seq_avbb      (seq_to_cpa_avbb),
      .cpa_clock     (usr_clk_0),
      .cpa_locked    (cpa_locked),
      .usr_async_clk (LOCKSTEP_SECONDARY ? ls_usr_clk_0 : usr_async_clk_0),
      .*
   );

   ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_fbr_axi_adapter_wide # (
      .PORT_AXI_AXADDR_WIDTH     (PORT_AXI_AXADDR_WIDTH    ),
      .PORT_AXI_AXBURST_WIDTH    (PORT_AXI_AXBURST_WIDTH   ),
      .PORT_AXI_AXID_WIDTH       (PORT_AXI_AXID_WIDTH      ),
      .PORT_AXI_AXLEN_WIDTH      (PORT_AXI_AXLEN_WIDTH     ),
      .PORT_AXI_AXSIZE_WIDTH     (PORT_AXI_AXSIZE_WIDTH    ),
      .PORT_AXI_AXUSER_WIDTH     (PORT_AXI_AXUSER_WIDTH    ),
      .PORT_AXI_DATA_WIDTH       (PORT_AXI_DATA_WIDTH      ),
      .PORT_AXI_STRB_WIDTH       (PORT_AXI_STRB_WIDTH      ),
      .PORT_AXI_USER_WIDTH       (PORT_AXI_USER_WIDTH      ),
      .PORT_AXI_ID_WIDTH         (PORT_AXI_ID_WIDTH        ),
      .PORT_AXI_RESP_WIDTH       (PORT_AXI_RESP_WIDTH      ),
      .INTF_CORE_TO_FAHMC_WIDTH  (INTF_CORE_TO_FAHMC_WIDTH ),
      .INTF_FAHMC_TO_CORE_WIDTH  (INTF_FAHMC_TO_CORE_WIDTH ),
      .INTF_CORE_TO_FALANE_WIDTH (INTF_CORE_TO_FALANE_WIDTH),
      .INTF_FALANE_TO_CORE_WIDTH (INTF_FALANE_TO_CORE_WIDTH)
   ) fbr_axi_adapter_wide (
      .fbr_aclk                  (usr_clk_0                ),
      .fbr_arst_n                (usr_rst_n_0              ),
      .core_to_fahmc             (core_to_fahmc[0]        ),
      .fahmc_to_core             (fahmc_to_core[0]        ),
      .core_to_falane            (core_to_falane[3:0]     ),
      .falane_to_core            (falane_to_core[3:0]     ),
      .fbr_axi_intf              (fbr_axi_adapter_intf[0] )
   );

   ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_fbr_axi_adapter_slim # (
      .PORT_AXI_AXADDR_WIDTH     (PORT_AXI_AXADDR_WIDTH    ),
      .PORT_AXI_AXBURST_WIDTH    (PORT_AXI_AXBURST_WIDTH   ),
      .PORT_AXI_AXID_WIDTH       (PORT_AXI_AXID_WIDTH      ),
      .PORT_AXI_AXLEN_WIDTH      (PORT_AXI_AXLEN_WIDTH     ),
      .PORT_AXI_AXSIZE_WIDTH     (PORT_AXI_AXSIZE_WIDTH    ),
      .PORT_AXI_AXUSER_WIDTH     (PORT_AXI_AXUSER_WIDTH    ),
      .PORT_AXI_DATA_WIDTH       (PORT_AXI_DATA_WIDTH      ),
      .PORT_AXI_STRB_WIDTH       (PORT_AXI_STRB_WIDTH      ),
      .PORT_AXI_USER_WIDTH       (PORT_AXI_USER_WIDTH      ),
      .PORT_AXI_ID_WIDTH         (PORT_AXI_ID_WIDTH        ),
      .PORT_AXI_RESP_WIDTH       (PORT_AXI_RESP_WIDTH      ),
      .INTF_CORE_TO_FAHMC_WIDTH  (INTF_CORE_TO_FAHMC_WIDTH ),
      .INTF_FAHMC_TO_CORE_WIDTH  (INTF_FAHMC_TO_CORE_WIDTH ),
      .INTF_CORE_TO_FALANE_WIDTH (INTF_CORE_TO_FALANE_WIDTH),
      .INTF_FALANE_TO_CORE_WIDTH (INTF_FALANE_TO_CORE_WIDTH)
   ) fbr_axi_adapter_slim (
      .fbr_aclk                  (usr_clk_0                ),
      .fbr_arst_n                (usr_rst_n_0              ),
      .core_to_fahmc             (core_to_fahmc[1]        ),
      .fahmc_to_core             (fahmc_to_core[1]        ),
      .core_to_falane            (core_to_falane[7:4]     ),
      .falane_to_core            (falane_to_core[7:4]     ),
      .fbr_axi_intf              (fbr_axi_adapter_intf[1] )
   );
   
endmodule



