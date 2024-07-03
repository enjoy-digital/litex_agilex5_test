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


///////////////////////////////////////////////////////////////////////////////
// This module forms the calibration IP that is responsible for calibrating 
// or reconfiguring IPs like EMIF, PHYLite and PLLs. It also provides interface 
// for any user calibration/reconfiguration IPs or debug IPs
///////////////////////////////////////////////////////////////////////////////
//                                                                                                               
//                                                                                                               
//    AXI-L via   -------------<->----------------------.
//      NOC            ________     _________     ______|________      ________________ 
//                     |      |     |       |     |             |     |               |
//                     |      |-<->-|  FA   |-<->-|             |     |               |-<->-PERIPH0       
//                     |      |     |_______|     |             |     |               |                   
//    AXI-L to    -<->-| GB   |      _______      |   IOSSM     |-<->-|    SEQ        |-<->-PERIPH1       
//     fabric          |      |     |       |     |             |     |               |                   
//                     |      |-<->-|  FA   |-<->-|             |     |               |-<->-PLL0,PLL1,PLL2                   
//                     |______|     |_______|     |_____________|     |_______________|      
//                                                                                                               
//                                                                                                               

`define declare_pa_signals(X) \
      logic           seq_to_pa``X``__en               ; \
      logic [95:0]    seq_to_pa``X``__wrdata           ; \
      logic [ 3:0]    seq_to_pa``X``__wrdata_en        ; \
      logic [ 3:0]    seq_to_pa``X``__wr_dqs_en        ; \
      logic [ 3:0]    seq_to_pa``X``__rddata_en        ; \
      logic [ 7:0]    seq_to_pa``X``__wr_rank          ; \
      logic [ 7:0]    seq_to_pa``X``__rd_rank          ; \
      logic [11:0]    seq_to_pa``X``__suppression      ; \
      logic [95:0]    periph0_pa``X``_to_seq__rddata            , periph1_pa``X``_to_seq__rddata           ; \
      logic [ 3:0]    periph0_pa``X``_to_seq__rddata_valid      , periph1_pa``X``_to_seq__rddata_valid     ; \
      logic           periph0_pa``X``_to_seq__rb_if_sel         , periph1_pa``X``_to_seq__rb_if_sel        ; \
      logic           periph0_pa``X``_to_seq__rb_phy_clk_en     , periph1_pa``X``_to_seq__rb_phy_clk_en    ; \
      logic           periph0_pa``X``_to_seq__rb_rate_conv_en   , periph1_pa``X``_to_seq__rb_rate_conv_en  ; \
      logic           periph0_pa``X``_to_seq__rb_ddr_lane_mode  , periph1_pa``X``_to_seq__rb_ddr_lane_mode ; \
      logic [10:0]    periph0_pa``X``_to_seq__rb_base_address   , periph1_pa``X``_to_seq__rb_base_address  ;

`define connect_pa(X) \
      .o_seq_en_``X``                             (seq_to_pa``X``__en               ), \
      .o_seq_wrdata_``X``                         (seq_to_pa``X``__wrdata           ), \
      .o_seq_wrdata_en_``X``                      (seq_to_pa``X``__wrdata_en        ), \
      .o_seq_wr_dqs_en_``X``                      (seq_to_pa``X``__wr_dqs_en        ), \
      .o_seq_rddata_en_``X``                      (seq_to_pa``X``__rddata_en        ), \
      .o_seq_wr_rank_``X``                        (seq_to_pa``X``__wr_rank          ), \
      .o_seq_rd_rank_``X``                        (seq_to_pa``X``__rd_rank          ), \
      .o_seq_suppression_``X``                    (seq_to_pa``X``__suppression      ), \
      .i_seq_rddata_``X``                         (periph0_pa``X``_to_seq__rddata            | periph1_pa``X``_to_seq__rddata           ), \
      .i_seq_rddata_valid_``X``                   (periph0_pa``X``_to_seq__rddata_valid      | periph1_pa``X``_to_seq__rddata_valid     ), \
      .i_rb_if_sel_pa``X``                        (                                            periph1_pa``X``_to_seq__rb_if_sel        ), \
      .i_rb_phy_clk_en_pa``X``                    (periph0_pa``X``_to_seq__rb_phy_clk_en     | periph1_pa``X``_to_seq__rb_phy_clk_en    ), \
      .i_rb_rate_conv_en_pa``X``                  (periph0_pa``X``_to_seq__rb_rate_conv_en   | periph1_pa``X``_to_seq__rb_rate_conv_en  ), \
      .i_rb_ddr_lane_mode_pa``X``                 (periph0_pa``X``_to_seq__rb_ddr_lane_mode  | periph1_pa``X``_to_seq__rb_ddr_lane_mode ), \
      .i_rb_base_address_pa``X``                  (periph0_pa``X``_to_seq__rb_base_address   | periph1_pa``X``_to_seq__rb_base_address  ),

// altera message_off 16788
module ed_synth_emif_ph2_inst_emif_ph2_cal_arch_fp_410_7vxea4y_cal_arch_fp_top #(

   parameter NUM_CALBUS_PERIPHS = 1,
   parameter NUM_CALBUS_PLLS    = 1,
   localparam PARAM_TABLE_WIDTH = 16384,
   parameter bit [  16384-1:0] PARAMETER_TABLE_0     = 0,
   parameter bit [  16384-1:0] PARAMETER_TABLE_1     = 0,
   parameter PORT_AXIL_ADDRESS_WIDTH = 32,
   localparam PORT_AXIL_DATA_WIDTH = 32,
   parameter PORT_M_AXIL_ENABLE = 0
   
) (

   output [1341:0]  periph_calbus_0,
   input  [1314:0]  periph_calbus_readdata_0,
   input  [2*PARAM_TABLE_WIDTH-1:0] periph_calbus_param_table_0,

   output [1341:0]  periph_calbus_1,
   input  [1314:0]  periph_calbus_readdata_1,
   input  [2*PARAM_TABLE_WIDTH-1:0] periph_calbus_param_table_1,

   output [ 57:0]   pll_calbus_0,
   input  [ 31:0]   pll_calbus_readdata_0,

   output [ 57:0]   pll_calbus_1,
   input  [ 31:0]   pll_calbus_readdata_1,

   output [ 57:0]   pll_calbus_2,
   input  [ 31:0]   pll_calbus_readdata_2,
   
   input  [7:0]     ls_to_cal,
   output [7:0]     ls_from_cal,
   input            fbr_c2f_rst_n,
//// User/Debug Interface via NoC
   input                                tniul_rst_n      ,
   output                               s0_noc_axi4lite_clk     ,
   output                               s0_noc_axi4lite_rst_n   ,
   input  [PORT_AXIL_ADDRESS_WIDTH-1:0] s0_noc_axi4lite_awaddr  ,
   input                                s0_noc_axi4lite_awvalid ,
   output                               s0_noc_axi4lite_awready ,
   input  [PORT_AXIL_ADDRESS_WIDTH-1:0] s0_noc_axi4lite_araddr  ,
   input                                s0_noc_axi4lite_arvalid ,
   output                               s0_noc_axi4lite_arready ,
   input  [PORT_AXIL_DATA_WIDTH-1:0]     s0_noc_axi4lite_wdata   ,
   input                                 s0_noc_axi4lite_wvalid  ,
   output                                s0_noc_axi4lite_wready  ,
   output [1:0]                          s0_noc_axi4lite_rresp   ,
   output [PORT_AXIL_DATA_WIDTH-1:0]     s0_noc_axi4lite_rdata   ,
   output                                s0_noc_axi4lite_rvalid  ,
   input                                 s0_noc_axi4lite_rready  ,
   output [1:0]                          s0_noc_axi4lite_bresp   ,
   output                                s0_noc_axi4lite_bvalid  ,
   input                                 s0_noc_axi4lite_bready  ,
   input  [2:0]                          s0_noc_axi4lite_awprot  ,
   input  [2:0]                          s0_noc_axi4lite_arprot  ,
   input  [(PORT_AXIL_DATA_WIDTH/8)-1:0] s0_noc_axi4lite_wstrb   ,

//// User/Debug Interface directy to Fabric
   input                                 s0_axi4lite_clk     ,
   input                                 s0_axi4lite_rst_n   ,
   input   [PORT_AXIL_ADDRESS_WIDTH-1:0] s0_axi4lite_awaddr  ,
   input                                 s0_axi4lite_awvalid ,
   output                                s0_axi4lite_awready ,
   input   [PORT_AXIL_ADDRESS_WIDTH-1:0] s0_axi4lite_araddr  ,
   input                                 s0_axi4lite_arvalid ,
   output                                s0_axi4lite_arready ,
   input   [PORT_AXIL_DATA_WIDTH-1:0]    s0_axi4lite_wdata   ,
   input                                 s0_axi4lite_wvalid  ,
   output                                s0_axi4lite_wready  ,
   output   [1:0]                        s0_axi4lite_rresp   ,
   output  [PORT_AXIL_DATA_WIDTH-1:0]    s0_axi4lite_rdata   ,
   output                                s0_axi4lite_rvalid  ,
   input                                 s0_axi4lite_rready  ,
   output   [1:0]                        s0_axi4lite_bresp   ,
   output                                s0_axi4lite_bvalid  ,
   input                                 s0_axi4lite_bready  ,
   
//// User Interface directy from Fabric (M)
   output                                m0_axi4lite_clk     ,
   output                                m0_axi4lite_rst_n   ,
   output  [PORT_AXIL_ADDRESS_WIDTH-1:0] m0_axi4lite_awaddr  ,
   output                                m0_axi4lite_awvalid ,
   input                                 m0_axi4lite_awready ,
   output  [PORT_AXIL_ADDRESS_WIDTH-1:0] m0_axi4lite_araddr  ,
   output                                m0_axi4lite_arvalid ,
   input                                 m0_axi4lite_arready ,
   output   [PORT_AXIL_DATA_WIDTH-1:0]    m0_axi4lite_wdata   ,
   output                                m0_axi4lite_wvalid  ,
   input                                 m0_axi4lite_wready  ,
   input    [1:0]                        m0_axi4lite_rresp   ,
   input   [PORT_AXIL_DATA_WIDTH-1:0]    m0_axi4lite_rdata   ,
   input                                 m0_axi4lite_rvalid  ,
   output                                m0_axi4lite_rready  ,
   input    [1:0]                        m0_axi4lite_bresp   ,
   input                                 m0_axi4lite_bvalid  ,
   output                                m0_axi4lite_bready  ,
   output [2:0]                          m0_axi4lite_awprot  ,
   output [2:0]                          m0_axi4lite_arprot  ,
   output [(PORT_AXIL_DATA_WIDTH/8)-1:0] m0_axi4lite_wstrb   ,
   

   input  [2:0]                          s0_axi4lite_awprot  ,
   input  [2:0]                          s0_axi4lite_arprot  ,
   input  [(PORT_AXIL_DATA_WIDTH/8)-1:0] s0_axi4lite_wstrb   


   // Core IRQ signals
   //TODO: Enable the s0_irq port.

);
   timeunit 1ns;
   timeprecision 1ps;

   logic        iossm_to_seq__avl_rstn     ;
   logic        iossm_to_seq__avl_clk      ;
   logic        iossm_to_seq__avl_write    ;
   logic        iossm_to_seq__avl_read     ;
   logic [21:0] iossm_to_seq__avl_address  ;
   logic [31:0] iossm_to_seq__avl_writedata;
   wire  [31:0] seq_to_iossm__avl_readdata ;

   logic        seq_to_comp__avl_rstn      ;
   logic        seq_to_comp__avl_clk       ;
   logic        seq_to_comp__avl_write     ;
   logic        seq_to_comp__avl_read      ;
   logic [21:0] seq_to_comp__avl_address   ;
   logic [31:0] seq_to_comp__avl_writedata ;
   wire  [31:0] comp_to_seq__avl_readdata  ;

   logic        seq_to_periph__avl_rstn      ;
   logic        seq_to_periph__avl_clk       ;
   logic        seq_to_periph__avl_write     ;
   logic        seq_to_periph__avl_read      ;
   logic [21:0] seq_to_periph__avl_address   ;
   logic [31:0] seq_to_periph__avl_writedata ;
   wire  [31:0] periph0_to_seq__avl_readdata_lane0 , periph1_to_seq__avl_readdata_lane0;
   wire  [31:0] periph0_to_seq__avl_readdata_lane1 , periph1_to_seq__avl_readdata_lane1;
   wire  [31:0] periph0_to_seq__avl_readdata_lane2 , periph1_to_seq__avl_readdata_lane2;
   wire  [31:0] periph0_to_seq__avl_readdata_lane3 , periph1_to_seq__avl_readdata_lane3;
   wire  [31:0] periph0_to_seq__avl_readdata_lane4 , periph1_to_seq__avl_readdata_lane4;
   wire  [31:0] periph0_to_seq__avl_readdata_lane5 , periph1_to_seq__avl_readdata_lane5;
   wire  [31:0] periph0_to_seq__avl_readdata_lane6 , periph1_to_seq__avl_readdata_lane6;
   wire  [31:0] periph0_to_seq__avl_readdata_lane7 , periph1_to_seq__avl_readdata_lane7;
   logic        seq_to_pll__avl_rstn     ;
   logic        seq_to_pll__avl_clk      ;
   logic        seq_to_pll__avl_write    ;
   logic        seq_to_pll__avl_read     ;
   logic [21:0] seq_to_pll__avl_address  ;
   logic [31:0] seq_to_pll__avl_writedata;
   wire  [31:0] pll0_to_seq__avl_readdata , periph0_to_seq__avl_readdata_pll ;
   wire  [31:0] pll1_to_seq__avl_readdata , periph1_to_seq__avl_readdata_pll ;
   wire  [31:0] pll2_to_seq__avl_readdata ;
   logic        seq_to_ckgen__avl_rstn     ;
   logic        seq_to_ckgen__avl_clk      ;
   logic        seq_to_ckgen__avl_write    ;
   logic        seq_to_ckgen__avl_read     ;
   logic [21:0] seq_to_ckgen__avl_address  ;
   logic [31:0] seq_to_ckgen__avl_writedata;
   wire  [31:0] periph0_to_seq__avl_readdata_ckgen , periph1_to_seq__avl_readdata_ckgen ;
   logic        periph0_to_seq__phy_clk;
   logic        periph0_to_seq__phy_clksync;
   logic        periph1_to_seq__phy_clk;
   logic        periph1_to_seq__phy_clksync;
   `declare_pa_signals(0)
   `declare_pa_signals(1)
   `declare_pa_signals(2)
   `declare_pa_signals(3)
   `declare_pa_signals(4)
   `declare_pa_signals(5)
   `declare_pa_signals(6)
   `declare_pa_signals(7)
 
   logic        periph0_mc0_to_iossm__irq  ;
   logic        periph0_mc1_to_iossm__irq  ;
   logic        periph1_mc0_to_iossm__irq  ;
   logic        periph1_mc1_to_iossm__irq  ;
   logic        iossm_to_mc0__rst_n        ;
   logic        iossm_to_mc1__rst_n        ;
   logic        iossm_to_mc__clk_en_in     ;
   logic        iossm_to_mc__hclk          ;
   logic        iossm_to_mc__hresetn       ;
   logic [15:0] iossm_to_mc__haddr         ;
   logic [31:0] iossm_to_mc__hwdata        ;
   logic [2:0]  iossm_to_mc__hsize         ;
   logic [2:0]  iossm_to_mc__hburst        ;
   logic [1:0]  iossm_to_mc__htrans        ;
   logic        iossm_to_mc__hsel          ;
   logic        iossm_to_mc__hready        ;
   logic        iossm_to_mc__hwrite        ;
   logic [31:0] periph0_mc0_to_iossm__hrdata    ;
   logic [1:0]  periph0_mc0_to_iossm__hresp     ;
   logic        periph0_mc0_to_iossm__hready    ;
   logic [31:0] periph0_mc1_to_iossm__hrdata    ;
   logic [1:0]  periph0_mc1_to_iossm__hresp     ;
   logic        periph0_mc1_to_iossm__hready    ;
   logic [31:0] periph1_mc0_to_iossm__hrdata    ;
   logic [1:0]  periph1_mc0_to_iossm__hresp     ;
   logic        periph1_mc0_to_iossm__hready    ;
   logic [31:0] periph1_mc1_to_iossm__hrdata    ;
   logic [1:0]  periph1_mc1_to_iossm__hresp     ;
   logic        periph1_mc1_to_iossm__hready    ;
   logic        iossm_to_pa__i3c_scl       ;
   logic        iossm_to_pa__i3c_sda_pp    ;
   logic        iossm_to_pa__i3c_sda_tx    ;
   logic        iossm_to_pa__i3c_sda_dr_en_n ;
   logic        periph0_pa_to_iossm__i3c_sda_rx    ;
   logic        periph1_pa_to_iossm__i3c_sda_rx    ;
   
   logic        [39:0] to_fa_ssm_c2p      ;
   logic        [39:0] from_fa_ssm_c2p      ;
   logic        [19:0] to_fa_ssm_p2c      ;
   logic        [19:0] from_fa_ssm_p2c      ;

   logic fa_to_hmc__slim_fbr_dfi_init_complete;
   logic fa_to_hmc__slim_fbr_mc_clk_en;
   logic fa_to_hmc__wide_fbr_dfi_init_complete;
   logic fa_to_hmc__wide_fbr_mc_clk_en;
   logic fa_to_seq__seq_cmd_sync;
   logic [30:0] iofbradapt_ssm_c2p;
   logic [5:0] gb_ssm_c2p;
   
   logic seq_to_fa__seq_cmd_sync;
   logic [1:0] cpa_to_fa__lock; 
   logic [7:0] iofbradapt_ssm_p2c;

   logic [1:0] cpa_lock;        
   logic [2:0] dummy_unused;    
   logic [4:0] fa_2_gb_p2c; 



   logic        i_phy_clk_fr   ; 
   logic        i_phy_clk_sync ;   
   logic        i_core_clk     ;

   assign s0_noc_axi4lite_rst_n = tniul_rst_n;

   altera_emif_cal_gearbox_bidir #(
      .AXI_ADDR_WIDTH(PORT_AXIL_ADDRESS_WIDTH),
      .AXI_DATA_WIDTH(PORT_AXIL_DATA_WIDTH)
   ) inst_gearbox (
      .axi_clk(s0_axi4lite_clk),
      .axi_rst_n(s0_axi4lite_rst_n),
      .c2f_rst_n(PORT_M_AXIL_ENABLE ? fbr_c2f_rst_n : s0_axi4lite_rst_n),

   // AXI-L S INF
      .axi_awvalid(s0_axi4lite_awvalid),
      .axi_awready(s0_axi4lite_awready),
      .axi_awaddr(s0_axi4lite_awaddr),

      .axi_arvalid(s0_axi4lite_arvalid),
      .axi_arready(s0_axi4lite_arready),
      .axi_araddr(s0_axi4lite_araddr),

      .axi_wvalid(s0_axi4lite_wvalid),
      .axi_wready(s0_axi4lite_wready),
      .axi_wdata(s0_axi4lite_wdata),

      .axi_rvalid(s0_axi4lite_rvalid),
      .axi_rready(s0_axi4lite_rready),
      .axi_rresp(s0_axi4lite_rresp),
      .axi_rdata(s0_axi4lite_rdata),

      .axi_bvalid(s0_axi4lite_bvalid),
      .axi_bready(s0_axi4lite_bready),
      .axi_bresp(s0_axi4lite_bresp),

    // AXI-L M INF
      .m_axi_awvalid(m0_axi4lite_awvalid),
      .m_axi_awready(m0_axi4lite_awready),
      .m_axi_awaddr(m0_axi4lite_awaddr),

      .m_axi_arvalid(m0_axi4lite_arvalid),
      .m_axi_arready(m0_axi4lite_arready),
      .m_axi_araddr(m0_axi4lite_araddr),

      .m_axi_wvalid(m0_axi4lite_wvalid),
      .m_axi_wready(m0_axi4lite_wready),
      .m_axi_wdata(m0_axi4lite_wdata),

      .m_axi_rvalid(m0_axi4lite_rvalid),
      .m_axi_rready(m0_axi4lite_rready),
      .m_axi_rresp(m0_axi4lite_rresp),
      .m_axi_rdata(m0_axi4lite_rdata),

      .m_axi_bvalid(m0_axi4lite_bvalid),
      .m_axi_bready(m0_axi4lite_bready),
      .m_axi_bresp(m0_axi4lite_bresp),

    // IOSSM C2P/P2C Interface
      .ssm_c2p(gb_ssm_c2p), //[4:0]
      .ssm_p2c(fa_2_gb_p2c[4:0]) 
   ); 
   
   assign m0_axi4lite_awprot = '0;
   assign m0_axi4lite_arprot = '0;
   assign m0_axi4lite_wstrb = { (PORT_AXIL_DATA_WIDTH/8) {1'b1} }; 

   assign i_phy_clk_fr = periph0_to_seq__phy_clk;
   assign i_phy_clk_sync = periph0_to_seq__phy_clksync;

   stdfn_inst_fa_c2p_ssm #(
      .IS_USED(1),
      .SSM_C2P_DATA_MODE("SSM_C2P_DATA_MODE_BYPASS"),
      .FA_CORE_PERIPH_CLK_SEL_DATA_MODE("FA_CORE_PERIPH_CLK_SEL_DATA_MODE_CORECLK"),
      .SSM_P2C_DATA_MODE("SSM_P2C_DATA_MODE_BYPASS")
   )
   u_ssm_fa (
      .i_core_clk     (ls_to_cal[5]),    
      .i_ssm_c2p      (to_fa_ssm_c2p ),  
      .o_ssm_c2p      (from_fa_ssm_c2p), 
      .i_phy_clk_fr   (i_phy_clk_fr),  
      .i_phy_clk_sync (i_phy_clk_sync), 
      .i_ssm_p2c      (to_fa_ssm_p2c), 
      .o_ssm_p2c      (from_fa_ssm_p2c) 
   );

    
    assign to_fa_ssm_c2p = {    4'h0,               
                                ls_to_cal[4:0],   
                                25'h0,              
                                gb_ssm_c2p          
                           };

    assign { fa_to_hmc__slim_fbr_dfi_init_complete,     
             fa_to_hmc__slim_fbr_mc_clk_en,             
             fa_to_hmc__wide_fbr_dfi_init_complete,     
             fa_to_hmc__wide_fbr_mc_clk_en,             
             fa_to_seq__seq_cmd_sync,                   
             iofbradapt_ssm_c2p                         
             } = from_fa_ssm_c2p[35:0];

    assign to_fa_ssm_p2c = {    9'h0,                       
                                seq_to_fa__seq_cmd_sync,    
                                cpa_to_fa__lock,            
                                iofbradapt_ssm_p2c          
                           };
    
    assign { ls_from_cal[0],  
             cpa_lock,          
             dummy_unused,      
             fa_2_gb_p2c        
             } = from_fa_ssm_p2c[10:0];
    assign ls_from_cal[7:1] = '0;

   ed_synth_emif_ph2_inst_emif_ph2_cal_arch_fp_410_7vxea4y_stdfn_inst_iossm #(
   ) u_iossm (
      .iofbradapt_ssm_p2c               (iofbradapt_ssm_p2c), 
      .iofbradapt_ssm_c2p               (iofbradapt_ssm_c2p), 
      .c2p_clk                          (s0_axi4lite_clk),  

       .axil_clk                         (s0_noc_axi4lite_clk    ),
       .axil_wready                      (s0_noc_axi4lite_wready ),
       .axil_rvalid                      (s0_noc_axi4lite_rvalid ),
       .axil_rresp                       (s0_noc_axi4lite_rresp  ),
       .axil_rdata                       (s0_noc_axi4lite_rdata  ),
       .axil_bvalid                      (s0_noc_axi4lite_bvalid ),
       .axil_bresp                       (s0_noc_axi4lite_bresp  ),
       .axil_awready                     (s0_noc_axi4lite_awready),
       .axil_arready                     (s0_noc_axi4lite_arready),
       .axil_wvalid                      (s0_noc_axi4lite_wvalid ),
       .axil_wstrb                       (s0_noc_axi4lite_wstrb  ),
       .axil_wdata                       (s0_noc_axi4lite_wdata  ),
       .axil_rready                      (s0_noc_axi4lite_rready ),
       .axil_bready                      (s0_noc_axi4lite_bready ),
       .axil_awvalid                     (s0_noc_axi4lite_awvalid),
       .axil_awaddr                      (s0_noc_axi4lite_awaddr ),
       .axil_arvalid                     (s0_noc_axi4lite_arvalid),
       .axil_araddr                      (s0_noc_axi4lite_araddr ),

      .calbus0_rst_n                    (iossm_to_seq__avl_rstn     ),
      .calbus0_clock                    (iossm_to_seq__avl_clk      ),
      .calbus0_write                    (iossm_to_seq__avl_write    ),
      .calbus0_read                     (iossm_to_seq__avl_read     ),
      .calbus0_addr                     (iossm_to_seq__avl_address  ),
      .calbus0_writedata                (iossm_to_seq__avl_writedata),
      .calbus0_readdata                 (seq_to_iossm__avl_readdata ),

      .mc0_irq                          (periph0_mc0_to_iossm__irq   | periph1_mc0_to_iossm__irq   ),
      .mc1_irq                          (periph0_mc1_to_iossm__irq   | periph1_mc1_to_iossm__irq   ),
      .mc0_rst_n                        (iossm_to_mc0__rst_n    ),
      .mc1_rst_n                        (iossm_to_mc1__rst_n    ),
      .clk_en_in                        (iossm_to_mc__clk_en_in ),
      .hclk                             (iossm_to_mc__hclk      ),
      .hresetn                          (iossm_to_mc__hresetn   ),
      .haddr                            (iossm_to_mc__haddr     ), 
      .hwdata                           (iossm_to_mc__hwdata    ), 
      .hsize                            (iossm_to_mc__hsize     ), 
      .hburst                           (iossm_to_mc__hburst    ), 
      .htrans                           (iossm_to_mc__htrans    ), 
      .hsel                             (iossm_to_mc__hsel      ),
      .hready                           (iossm_to_mc__hready    ),
      .hwrite                           (iossm_to_mc__hwrite    ),
      .mc0_hrdata                       (periph0_mc0_to_iossm__hrdata | periph1_mc0_to_iossm__hrdata), 
      .mc0_hresp                        (periph0_mc0_to_iossm__hresp  | periph1_mc0_to_iossm__hresp ), 
      .mc0_hreadyout                    (periph0_mc0_to_iossm__hready | periph1_mc0_to_iossm__hready),
      .mc1_hrdata                       (periph0_mc1_to_iossm__hrdata | periph1_mc1_to_iossm__hrdata), 
      .mc1_hresp                        (periph0_mc1_to_iossm__hresp  | periph1_mc1_to_iossm__hresp ), 
      .mc1_hreadyout                    (periph0_mc1_to_iossm__hready | periph1_mc1_to_iossm__hready),

      // synthesis translate_off
      .i_sim_param_table_0              (periph_calbus_param_table_0[PARAM_TABLE_WIDTH-1:0]),
      .i_sim_param_table_1              (NUM_CALBUS_PERIPHS == 1 ? periph_calbus_param_table_0[2*PARAM_TABLE_WIDTH-1:PARAM_TABLE_WIDTH] : 
                                                                   periph_calbus_param_table_1[  PARAM_TABLE_WIDTH-1:                0]),
      // synthesis translate_on
      .i3c_sda_rx                       (periph0_pa_to_iossm__i3c_sda_rx),
      
      .i3c_scl                          (iossm_to_pa__i3c_scl       ),
      .i3c_sda_pp                       (iossm_to_pa__i3c_sda_pp    ),
      .i3c_sda_tx                       (iossm_to_pa__i3c_sda_tx    ),
      .i3c_sda_dr_en_n                  (iossm_to_pa__i3c_sda_dr_en_n)
      );

   ed_synth_emif_ph2_inst_emif_ph2_cal_arch_fp_410_7vxea4y_stdfn_inst_seq #(
   ) u_seq (
      .i_avl_rstn                             (iossm_to_seq__avl_rstn     ),
      .i_avl_clk                              (iossm_to_seq__avl_clk      ),
      .i_avl_write                            (iossm_to_seq__avl_write    ),
      .i_avl_read                             (iossm_to_seq__avl_read     ),
      .i_avl_address                          (iossm_to_seq__avl_address  ),
      .i_avl_writedata                        (iossm_to_seq__avl_writedata),
      .o_avl_readdata                         (seq_to_iossm__avl_readdata ),

      .o_avl_rstn_comp                        (seq_to_comp__avl_rstn     ),
      .o_avl_clk_comp                         (seq_to_comp__avl_clk      ),
      .o_avl_write_comp                       (seq_to_comp__avl_write    ),
      .o_avl_read_comp                        (seq_to_comp__avl_read     ),
      .o_avl_address_comp                     (seq_to_comp__avl_address  ),
      .o_avl_writedata_comp                   (seq_to_comp__avl_writedata),
      .i_avl_readdata_comp                    (comp_to_seq__avl_readdata ),

      .o_avl_rstn_lane                        (seq_to_periph__avl_rstn     ),
      .o_avl_clk_lane                         (seq_to_periph__avl_clk      ),
      .o_avl_write_lane                       (seq_to_periph__avl_write    ),
      .o_avl_read_lane                        (seq_to_periph__avl_read     ),
      .o_avl_address_lane                     (seq_to_periph__avl_address  ),
      .o_avl_writedata_lane                   (seq_to_periph__avl_writedata),
      .i_avl_readdata_lane0                   (periph0_to_seq__avl_readdata_lane0 | periph1_to_seq__avl_readdata_lane0),
      .i_avl_readdata_lane1                   (periph0_to_seq__avl_readdata_lane1 | periph1_to_seq__avl_readdata_lane1),
      .i_avl_readdata_lane2                   (periph0_to_seq__avl_readdata_lane2 | periph1_to_seq__avl_readdata_lane2),
      .i_avl_readdata_lane3                   (periph0_to_seq__avl_readdata_lane3 | periph1_to_seq__avl_readdata_lane3),
      .i_avl_readdata_lane4                   (periph0_to_seq__avl_readdata_lane4 | periph1_to_seq__avl_readdata_lane4),
      .i_avl_readdata_lane5                   (periph0_to_seq__avl_readdata_lane5 | periph1_to_seq__avl_readdata_lane5),
      .i_avl_readdata_lane6                   (periph0_to_seq__avl_readdata_lane6 | periph1_to_seq__avl_readdata_lane6),
      .i_avl_readdata_lane7                   (periph0_to_seq__avl_readdata_lane7 | periph1_to_seq__avl_readdata_lane7),

      .o_avl_rstn_pll                         (seq_to_pll__avl_rstn     ),
      .o_avl_clk_pll                          (seq_to_pll__avl_clk      ),
      .o_avl_write_pll                        (seq_to_pll__avl_write    ),
      .o_avl_read_pll                         (seq_to_pll__avl_read     ),
      .o_avl_address_pll                      (seq_to_pll__avl_address  ),
      .o_avl_writedata_pll                    (seq_to_pll__avl_writedata),
      .i_avl_readdata_iopll0                  (pll2_to_seq__avl_readdata | periph0_to_seq__avl_readdata_pll ), 
      .i_avl_readdata_iopll1                  (pll1_to_seq__avl_readdata | periph1_to_seq__avl_readdata_pll ), 
      .i_avl_readdata_fbrpll                  (pll0_to_seq__avl_readdata ),                                    

      .o_avl_rstn_ckgen                       (seq_to_ckgen__avl_rstn     ),
      .o_avl_clk_ckgen                        (seq_to_ckgen__avl_clk      ),
      .o_avl_write_ckgen                      (seq_to_ckgen__avl_write    ),
      .o_avl_read_ckgen                       (seq_to_ckgen__avl_read     ),
      .o_avl_address_ckgen                    (seq_to_ckgen__avl_address  ),
      .o_avl_writedata_ckgen                  (seq_to_ckgen__avl_writedata),
      .i_avl_readdata_ckgen0                  (periph0_to_seq__avl_readdata_ckgen ),
      .i_avl_readdata_ckgen1                  (periph1_to_seq__avl_readdata_ckgen ),

      .i_phy_clka                             (periph0_to_seq__phy_clk),
      .i_phy_clksync_a                        (periph0_to_seq__phy_clksync),
      .i_phy_clkb                             (periph1_to_seq__phy_clk),
      .i_phy_clksync_b                        (periph1_to_seq__phy_clksync),
      
      `connect_pa(0)
      `connect_pa(1)
      `connect_pa(2)
      `connect_pa(3)
      `connect_pa(4)
      `connect_pa(5)
      `connect_pa(6)
      `connect_pa(7)
      
      .o_seq_cmd_sync                         (seq_to_fa__seq_cmd_sync),
      .i_seq_cmd_sync                         (fa_to_seq__seq_cmd_sync));

   (* altera_attribute = {"-name PRESERVE_FANOUT_FREE_WYSIWYG ON"} *)
   tennm_compensation_block # (
         .base_address                        (PORT_M_AXIL_ENABLE ? 101 : 0)
      ) u_comp_block (
      // synthesis translate_off
      .o_avm_readdata_comp   (comp_to_seq__avl_readdata  ),
      // synthesis translate_on
      .avm_clk               (seq_to_comp__avl_clk       ),
      .avm_rst_n             (seq_to_comp__avl_rstn      ),
      .i_avm_address         (seq_to_comp__avl_address   ),
      .i_avm_read            (seq_to_comp__avl_read      ),
      .i_avm_write           (seq_to_comp__avl_write     ),
      .i_avm_writedata       (seq_to_comp__avl_writedata ));

   logic [ 243:0] periph_calbus_0_a;
   logic [1097:0] periph_calbus_0_b;
   
   assign periph_calbus_1 = periph_calbus_0;
   assign periph_calbus_0 = {periph_calbus_0_a,periph_calbus_0_b};

   assign periph_calbus_0_a    = { seq_to_periph__avl_rstn       ,
                                   seq_to_periph__avl_clk        ,
                                   seq_to_periph__avl_write      ,
                                   seq_to_periph__avl_read       ,
                                   seq_to_periph__avl_address    ,
                                   seq_to_periph__avl_writedata  ,
                                   seq_to_pll__avl_rstn        ,
                                   seq_to_pll__avl_clk         ,
                                   seq_to_pll__avl_write       ,
                                   seq_to_pll__avl_read        ,
                                   seq_to_pll__avl_address     ,
                                   seq_to_pll__avl_writedata   ,
                                   seq_to_ckgen__avl_rstn      ,
                                   seq_to_ckgen__avl_clk       ,
                                   seq_to_ckgen__avl_write     ,
                                   seq_to_ckgen__avl_read      ,
                                   seq_to_ckgen__avl_address   ,
                                   seq_to_ckgen__avl_writedata ,
                                   iossm_to_mc__haddr         ,
                                   iossm_to_mc__hburst        ,
                                   iossm_to_mc__hclk          ,
                                   iossm_to_mc__hready        ,
                                   iossm_to_mc__hresetn       ,
                                   iossm_to_mc__hsel          ,
                                   iossm_to_mc__hsize         ,
                                   iossm_to_mc__htrans        ,
                                   iossm_to_mc__hwdata        ,
                                   iossm_to_mc__hwrite        ,
                                   iossm_to_mc__clk_en_in     ,
                                   fa_to_hmc__slim_fbr_dfi_init_complete,
                                   fa_to_hmc__slim_fbr_mc_clk_en,        
                                   fa_to_hmc__wide_fbr_dfi_init_complete,
                                   fa_to_hmc__wide_fbr_mc_clk_en,                                         
                                   iossm_to_pa__i3c_scl       ,
                                   iossm_to_pa__i3c_sda_pp    ,
                                   iossm_to_pa__i3c_sda_tx    ,
                                   iossm_to_pa__i3c_sda_dr_en_n };

   
   // synthesis translate_off

   assign periph_calbus_0_b    = { seq_to_pa7__en, seq_to_pa7__wrdata, seq_to_pa7__wrdata_en, seq_to_pa7__wr_dqs_en, seq_to_pa7__rddata_en, seq_to_pa7__wr_rank, seq_to_pa7__rd_rank, seq_to_pa7__suppression,
                                   seq_to_pa6__en, seq_to_pa6__wrdata, seq_to_pa6__wrdata_en, seq_to_pa6__wr_dqs_en, seq_to_pa6__rddata_en, seq_to_pa6__wr_rank, seq_to_pa6__rd_rank, seq_to_pa6__suppression,
                                   seq_to_pa5__en, seq_to_pa5__wrdata, seq_to_pa5__wrdata_en, seq_to_pa5__wr_dqs_en, seq_to_pa5__rddata_en, seq_to_pa5__wr_rank, seq_to_pa5__rd_rank, seq_to_pa5__suppression,
                                   seq_to_pa4__en, seq_to_pa4__wrdata, seq_to_pa4__wrdata_en, seq_to_pa4__wr_dqs_en, seq_to_pa4__rddata_en, seq_to_pa4__wr_rank, seq_to_pa4__rd_rank, seq_to_pa4__suppression,
                                   seq_to_pa3__en, seq_to_pa3__wrdata, seq_to_pa3__wrdata_en, seq_to_pa3__wr_dqs_en, seq_to_pa3__rddata_en, seq_to_pa3__wr_rank, seq_to_pa3__rd_rank, seq_to_pa3__suppression,
                                   seq_to_pa2__en, seq_to_pa2__wrdata, seq_to_pa2__wrdata_en, seq_to_pa2__wr_dqs_en, seq_to_pa2__rddata_en, seq_to_pa2__wr_rank, seq_to_pa2__rd_rank, seq_to_pa2__suppression,
                                   seq_to_pa1__en, seq_to_pa1__wrdata, seq_to_pa1__wrdata_en, seq_to_pa1__wr_dqs_en, seq_to_pa1__rddata_en, seq_to_pa1__wr_rank, seq_to_pa1__rd_rank, seq_to_pa1__suppression,
                                   seq_to_pa0__en, seq_to_pa0__wrdata, seq_to_pa0__wrdata_en, seq_to_pa0__wr_dqs_en, seq_to_pa0__rddata_en, seq_to_pa0__wr_rank, seq_to_pa0__rd_rank, seq_to_pa0__suppression,
                                   iossm_to_mc1__rst_n,
                                   iossm_to_mc0__rst_n};

   assign { periph0_to_seq__avl_readdata_lane7 ,
            periph0_to_seq__avl_readdata_lane6 ,
            periph0_to_seq__avl_readdata_lane5 ,
            periph0_to_seq__avl_readdata_lane4 ,
            periph0_to_seq__avl_readdata_lane3 ,
            periph0_to_seq__avl_readdata_lane2 ,
            periph0_to_seq__avl_readdata_lane1 ,
            periph0_to_seq__avl_readdata_lane0 ,
            periph0_to_seq__avl_readdata_ckgen ,
            periph0_to_seq__phy_clk            ,
            periph0_to_seq__phy_clksync        ,
            periph0_to_seq__avl_readdata_pll   ,
            periph0_pa7_to_seq__rddata,periph0_pa7_to_seq__rddata_valid,periph0_pa7_to_seq__rb_if_sel,periph0_pa7_to_seq__rb_phy_clk_en,periph0_pa7_to_seq__rb_rate_conv_en,periph0_pa7_to_seq__rb_ddr_lane_mode,periph0_pa7_to_seq__rb_base_address,
            periph0_pa6_to_seq__rddata,periph0_pa6_to_seq__rddata_valid,periph0_pa6_to_seq__rb_if_sel,periph0_pa6_to_seq__rb_phy_clk_en,periph0_pa6_to_seq__rb_rate_conv_en,periph0_pa6_to_seq__rb_ddr_lane_mode,periph0_pa6_to_seq__rb_base_address,
            periph0_pa5_to_seq__rddata,periph0_pa5_to_seq__rddata_valid,periph0_pa5_to_seq__rb_if_sel,periph0_pa5_to_seq__rb_phy_clk_en,periph0_pa5_to_seq__rb_rate_conv_en,periph0_pa5_to_seq__rb_ddr_lane_mode,periph0_pa5_to_seq__rb_base_address,
            periph0_pa4_to_seq__rddata,periph0_pa4_to_seq__rddata_valid,periph0_pa4_to_seq__rb_if_sel,periph0_pa4_to_seq__rb_phy_clk_en,periph0_pa4_to_seq__rb_rate_conv_en,periph0_pa4_to_seq__rb_ddr_lane_mode,periph0_pa4_to_seq__rb_base_address,
            periph0_pa3_to_seq__rddata,periph0_pa3_to_seq__rddata_valid,periph0_pa3_to_seq__rb_if_sel,periph0_pa3_to_seq__rb_phy_clk_en,periph0_pa3_to_seq__rb_rate_conv_en,periph0_pa3_to_seq__rb_ddr_lane_mode,periph0_pa3_to_seq__rb_base_address,
            periph0_pa2_to_seq__rddata,periph0_pa2_to_seq__rddata_valid,periph0_pa2_to_seq__rb_if_sel,periph0_pa2_to_seq__rb_phy_clk_en,periph0_pa2_to_seq__rb_rate_conv_en,periph0_pa2_to_seq__rb_ddr_lane_mode,periph0_pa2_to_seq__rb_base_address,
            periph0_pa1_to_seq__rddata,periph0_pa1_to_seq__rddata_valid,periph0_pa1_to_seq__rb_if_sel,periph0_pa1_to_seq__rb_phy_clk_en,periph0_pa1_to_seq__rb_rate_conv_en,periph0_pa1_to_seq__rb_ddr_lane_mode,periph0_pa1_to_seq__rb_base_address,
            periph0_pa0_to_seq__rddata,periph0_pa0_to_seq__rddata_valid,periph0_pa0_to_seq__rb_if_sel,periph0_pa0_to_seq__rb_phy_clk_en,periph0_pa0_to_seq__rb_rate_conv_en,periph0_pa0_to_seq__rb_ddr_lane_mode,periph0_pa0_to_seq__rb_base_address
                                            } = periph_calbus_readdata_0[1314:73];

   assign { periph1_to_seq__avl_readdata_lane7 ,
            periph1_to_seq__avl_readdata_lane6 ,
            periph1_to_seq__avl_readdata_lane5 ,
            periph1_to_seq__avl_readdata_lane4 ,
            periph1_to_seq__avl_readdata_lane3 ,
            periph1_to_seq__avl_readdata_lane2 ,
            periph1_to_seq__avl_readdata_lane1 ,
            periph1_to_seq__avl_readdata_lane0 ,
            periph1_to_seq__avl_readdata_ckgen ,
            periph1_to_seq__phy_clk            ,
            periph1_to_seq__phy_clksync        ,
            periph1_to_seq__avl_readdata_pll   ,
            periph1_pa7_to_seq__rddata,periph1_pa7_to_seq__rddata_valid,periph1_pa7_to_seq__rb_if_sel,periph1_pa7_to_seq__rb_phy_clk_en,periph1_pa7_to_seq__rb_rate_conv_en,periph1_pa7_to_seq__rb_ddr_lane_mode,periph1_pa7_to_seq__rb_base_address,
            periph1_pa6_to_seq__rddata,periph1_pa6_to_seq__rddata_valid,periph1_pa6_to_seq__rb_if_sel,periph1_pa6_to_seq__rb_phy_clk_en,periph1_pa6_to_seq__rb_rate_conv_en,periph1_pa6_to_seq__rb_ddr_lane_mode,periph1_pa6_to_seq__rb_base_address,
            periph1_pa5_to_seq__rddata,periph1_pa5_to_seq__rddata_valid,periph1_pa5_to_seq__rb_if_sel,periph1_pa5_to_seq__rb_phy_clk_en,periph1_pa5_to_seq__rb_rate_conv_en,periph1_pa5_to_seq__rb_ddr_lane_mode,periph1_pa5_to_seq__rb_base_address,
            periph1_pa4_to_seq__rddata,periph1_pa4_to_seq__rddata_valid,periph1_pa4_to_seq__rb_if_sel,periph1_pa4_to_seq__rb_phy_clk_en,periph1_pa4_to_seq__rb_rate_conv_en,periph1_pa4_to_seq__rb_ddr_lane_mode,periph1_pa4_to_seq__rb_base_address,
            periph1_pa3_to_seq__rddata,periph1_pa3_to_seq__rddata_valid,periph1_pa3_to_seq__rb_if_sel,periph1_pa3_to_seq__rb_phy_clk_en,periph1_pa3_to_seq__rb_rate_conv_en,periph1_pa3_to_seq__rb_ddr_lane_mode,periph1_pa3_to_seq__rb_base_address,
            periph1_pa2_to_seq__rddata,periph1_pa2_to_seq__rddata_valid,periph1_pa2_to_seq__rb_if_sel,periph1_pa2_to_seq__rb_phy_clk_en,periph1_pa2_to_seq__rb_rate_conv_en,periph1_pa2_to_seq__rb_ddr_lane_mode,periph1_pa2_to_seq__rb_base_address,
            periph1_pa1_to_seq__rddata,periph1_pa1_to_seq__rddata_valid,periph1_pa1_to_seq__rb_if_sel,periph1_pa1_to_seq__rb_phy_clk_en,periph1_pa1_to_seq__rb_rate_conv_en,periph1_pa1_to_seq__rb_ddr_lane_mode,periph1_pa1_to_seq__rb_base_address,
            periph1_pa0_to_seq__rddata,periph1_pa0_to_seq__rddata_valid,periph1_pa0_to_seq__rb_if_sel,periph1_pa0_to_seq__rb_phy_clk_en,periph1_pa0_to_seq__rb_rate_conv_en,periph1_pa0_to_seq__rb_ddr_lane_mode,periph1_pa0_to_seq__rb_base_address
                                            } = periph_calbus_readdata_1[1314:73];
   // synthesis translate_on

   assign { periph0_mc1_to_iossm__irq       ,
            periph0_mc1_to_iossm__hrdata    ,
            periph0_mc1_to_iossm__hready    ,
            periph0_mc1_to_iossm__hresp     ,
            periph0_mc0_to_iossm__irq       ,
            periph0_mc0_to_iossm__hrdata    ,
            periph0_mc0_to_iossm__hready    ,
            periph0_mc0_to_iossm__hresp     ,
            periph0_pa_to_iossm__i3c_sda_rx } = periph_calbus_readdata_0[72:0];

   assign { periph1_mc1_to_iossm__irq       ,
            periph1_mc1_to_iossm__hrdata    ,
            periph1_mc1_to_iossm__hready    ,
            periph1_mc1_to_iossm__hresp     ,
            periph1_mc0_to_iossm__irq       ,
            periph1_mc0_to_iossm__hrdata    ,
            periph1_mc0_to_iossm__hready    ,
            periph1_mc0_to_iossm__hresp     ,
            periph1_pa_to_iossm__i3c_sda_rx } = periph_calbus_readdata_1[72:0];
     
   assign pll_calbus_0 = pll_calbus_2;
   assign pll_calbus_1 = pll_calbus_2;
   assign pll_calbus_2 = { seq_to_pll__avl_rstn        ,
                           seq_to_pll__avl_clk         ,
                           seq_to_pll__avl_write       ,
                           seq_to_pll__avl_read        ,
                           seq_to_pll__avl_address     ,
                           seq_to_pll__avl_writedata   };

   // synthesis translate_off
   assign pll0_to_seq__avl_readdata = pll_calbus_readdata_0;
   assign pll1_to_seq__avl_readdata = pll_calbus_readdata_1;
   assign pll2_to_seq__avl_readdata = pll_calbus_readdata_2;

   generate
      genvar i;
      for(i = 0; i < 32; i++) begin: gen_pll_pulldowns
         pulldown (weak0) (pll_calbus_readdata_0[i]);
         pulldown (weak0) (pll_calbus_readdata_1[i]);
         pulldown (weak0) (pll_calbus_readdata_2[i]);
         pulldown (weak0) (periph0_to_seq__avl_readdata_lane0[i]);
         pulldown (weak0) (periph1_to_seq__avl_readdata_lane0[i]);
         pulldown (weak0) (periph0_to_seq__avl_readdata_lane1[i]);
         pulldown (weak0) (periph1_to_seq__avl_readdata_lane1[i]);
         pulldown (weak0) (periph0_to_seq__avl_readdata_lane2[i]);
         pulldown (weak0) (periph1_to_seq__avl_readdata_lane2[i]);
         pulldown (weak0) (periph0_to_seq__avl_readdata_lane3[i]);
         pulldown (weak0) (periph1_to_seq__avl_readdata_lane3[i]);
         pulldown (weak0) (periph0_to_seq__avl_readdata_lane4[i]);
         pulldown (weak0) (periph1_to_seq__avl_readdata_lane4[i]);
         pulldown (weak0) (periph0_to_seq__avl_readdata_lane5[i]);
         pulldown (weak0) (periph1_to_seq__avl_readdata_lane5[i]);
         pulldown (weak0) (periph0_to_seq__avl_readdata_lane6[i]);
         pulldown (weak0) (periph1_to_seq__avl_readdata_lane6[i]);
         pulldown (weak0) (periph0_to_seq__avl_readdata_lane7[i]);
         pulldown (weak0) (periph1_to_seq__avl_readdata_lane7[i]);
         pulldown (weak0) (periph0_to_seq__avl_readdata_pll[i]);
         pulldown (weak0) (periph1_to_seq__avl_readdata_pll[i]);
         pulldown (weak0) (periph0_to_seq__avl_readdata_ckgen[i]);
         pulldown (weak0) (periph1_to_seq__avl_readdata_ckgen[i]);
         pulldown (weak0) (comp_to_seq__avl_readdata[i]);
      end
   endgenerate
   
   pulldown (weak0) (u_iossm.axil_arvalid);
   pulldown (weak0) (u_iossm.axil_awvalid);
   pulldown (weak0) (u_iossm.axil_bready) ;
   pulldown (weak0) (u_iossm.axil_rready) ;
   pulldown (weak0) (u_iossm.axil_wvalid) ;

   generate
      genvar j;
      for(j = 0; j < 5; j++) begin: gen_ls_pulldowns
        pulldown (weak0) (ls_to_cal[j]);
      end
   endgenerate
   
   // synthesis translate_on
   
   /* TODO
    * 
    * user-interface
    * Review MC connections/ports
    * IOSSM parameters (meminit 512KB, 1KB)
    * 
    */

   
endmodule



