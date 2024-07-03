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



// altera message_off 16788
module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_pll #(

   localparam PORT_CORE_AVL_ADDRESS_WIDTH = 9,
   localparam PORT_CORE_AVL_DATA_WIDTH = 8,
   localparam PORT_OUT_CLK_WIDTH = 7,
   localparam PORT_VCO_CLK_WIDTH = 8,
   localparam PORT_CAL_BUS_DATA_WIDTH = 32,
   localparam PORT_CAL_BUS_ADDRESS_WIDTH = 22,

   localparam PORT_REF_CLK_BAD_WIDTH = 2,
   localparam PORT_DPS_NUM_PHASE_SHIFTS_WIDTH = 3,
   localparam PORT_DPS_CNT_SEL_WIDTH = 4,

   localparam INTF_PLL_TO_BC_WIDTH = 4,
   localparam INTF_PLL_TO_CPA_WIDTH = PORT_VCO_CLK_WIDTH + 3,
   localparam INTF_PLL_TO_HMC_WIDTH = 2,
   localparam INTF_PLL_TO_PA_WIDTH = 2,
   localparam INTF_PLL_TO_FA_WIDTH = 2,
   localparam INTF_PLL_TO_SEQ_WIDTH = PORT_CAL_BUS_DATA_WIDTH + 2,
   localparam INTF_PLL_TO_CORE_WIDTH = PORT_CORE_AVL_DATA_WIDTH,
   localparam INTF_SEQ_AVBB_WIDTH = PORT_CAL_BUS_ADDRESS_WIDTH + PORT_CAL_BUS_DATA_WIDTH + 4,
   localparam INTF_CORE_TO_PLL_WIDTH = PORT_CORE_AVL_ADDRESS_WIDTH + PORT_CORE_AVL_DATA_WIDTH + 3

) (
   output logic [INTF_PLL_TO_BC_WIDTH-1:0]   pll_to_bc,
   output logic [INTF_PLL_TO_CPA_WIDTH-1:0]  pll_to_cpa,
   output logic [INTF_PLL_TO_HMC_WIDTH-1:0]  pll_to_hmc,
   output logic [INTF_PLL_TO_PA_WIDTH-1:0]   pll_to_pa,
   output logic [INTF_PLL_TO_FA_WIDTH-1:0]   pll_to_falane,
   output logic [INTF_PLL_TO_FA_WIDTH-1:0]   pll_to_fahmc,
   output logic [INTF_PLL_TO_FA_WIDTH-1:0]   pll_to_fanoc,
   output logic [INTF_PLL_TO_SEQ_WIDTH-1:0]  pll_to_seq,
   output logic [INTF_PLL_TO_CORE_WIDTH-1:0] pll_to_core,

   input logic                               ref_clk,
   input logic                               rst_n,
   input logic [INTF_SEQ_AVBB_WIDTH-1:0]     seq_avbb,
   input logic [INTF_CORE_TO_PLL_WIDTH-1:0]  core_to_pll

);
   timeunit 1ns;
   timeprecision 1ps;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_pll::*;

   logic                                           reset;
   logic                                           ref_clk0;
   logic                                           fb_clk_out;
   logic                                           core_avl_clk;
   logic                                           core_avl_write;
   logic                                           core_avl_read;
   logic    [PORT_CORE_AVL_ADDRESS_WIDTH-1:0]      core_avl_address;
   logic    [PORT_CORE_AVL_DATA_WIDTH-1:0]         core_avl_writedata;
   logic                                           vco_clk_periph;
   logic                                           lock;
   logic    [PORT_OUT_CLK_WIDTH-1:0]               out_clk;
   logic    [PORT_CORE_AVL_DATA_WIDTH-1:0]         core_avl_readdata;
   logic    [PORT_VCO_CLK_WIDTH-1:0]               vco_clk;
   logic    [PORT_CAL_BUS_DATA_WIDTH-1:0]          cal_bus_readdata;
   logic                                           cal_bus_rst_n;
   logic                                           cal_bus_clk;
   logic                                           cal_bus_write;
   logic                                           cal_bus_read;
   logic    [PORT_CAL_BUS_ADDRESS_WIDTH-1:0]       cal_bus_address;
   logic    [PORT_CAL_BUS_DATA_WIDTH-1:0]          cal_bus_writedata;
   logic                                           ref_clk_switch_n;
   logic                                           permit_cal;
   logic                                           ref_clk1;
   logic    [PORT_REF_CLK_BAD_WIDTH-1:0]           ref_clk_bad;
   logic                                           ref_clk_active;
   logic                                           fb_clk_in;
   logic                                           fb_clk_in_lvds;
   logic                                           out_clk_external0;
   logic                                           out_clk_external1;
   logic                                           out_clk_periph0;
   logic                                           out_clk_periph1;
   logic                                           out_clk_cascade;
   logic    [PORT_DPS_NUM_PHASE_SHIFTS_WIDTH-1:0]  dps_num_phase_shifts;
   logic    [PORT_DPS_CNT_SEL_WIDTH-1:0]           dps_cnt_sel;
   logic                                           dps_phase_en;
   logic                                           dps_up_dn;
   logic                                           dps_phase_done;



   assign pll_to_bc      = {out_clk_periph0, out_clk_periph1, vco_clk_periph, lock};
   assign pll_to_cpa     = {out_clk_periph0, out_clk_periph1, vco_clk, lock};
   assign pll_to_hmc     = {out_clk_periph0, out_clk_periph1};
   assign pll_to_pa      = {out_clk_periph0, out_clk_periph1};
   assign pll_to_falane  = {out_clk_periph0, out_clk_periph1};
   assign pll_to_fahmc   = {out_clk_periph0, out_clk_periph1};
   assign pll_to_fanoc   = {out_clk_periph0, out_clk_periph1};


   assign pll_to_seq  = {out_clk_periph0, out_clk_periph1,
                         cal_bus_readdata};

   assign pll_to_core = core_avl_readdata;


   assign {reset} = ~rst_n;
   assign {ref_clk0} = ref_clk;

   assign {cal_bus_rst_n,
           cal_bus_clk,
           cal_bus_write,
           cal_bus_read,
           cal_bus_address,
           cal_bus_writedata} = seq_avbb;

   assign {core_avl_clk,
           core_avl_write,
           core_avl_read,
           core_avl_address,
           core_avl_writedata} = core_to_pll;

   assign ref_clk_switch_n = 1; 
   assign permit_cal       = 1;
   
   tennm_ph2_iopll # (
      .bandwidth_mode                                       (BANDWIDTH_MODE),
      .base_address                                         (BASE_ADDRESS),
      .cascade_mode                                         (CASCADE_MODE),
      .clk_switch_auto_en                                   (CLK_SWITCH_AUTO_EN),
      .clk_switch_manual_en                                 (CLK_SWITCH_MANUAL_EN),
      .compensation_clk_source                              (COMPENSATION_CLK_SOURCE),
      .compensation_mode                                    (COMPENSATION_MODE),
      .fb_clk_delay                                         (FB_CLK_DELAY),
      .fb_clk_fractional_div_den                            (FB_CLK_FRACTIONAL_DIV_DEN),
      .fb_clk_fractional_div_num                            (FB_CLK_FRACTIONAL_DIV_NUM),
      .fb_clk_fractional_div_value                          (FB_CLK_FRACTIONAL_DIV_VALUE),
      .fb_clk_m_div                                         (FB_CLK_M_DIV),
      .out_clk_0_c_div                                      (OUT_CLK_C_DIV[0]),
      .out_clk_0_core_en                                    (OUT_CLK_CORE_EN[0]),
      .out_clk_0_delay                                      (OUT_CLK_DELAY[0]),
      .out_clk_0_dutycycle_den                              (OUT_CLK_DUTYCYCLE_DEN[0]),
      .out_clk_0_dutycycle_num                              (OUT_CLK_DUTYCYCLE_NUM[0]),
      .out_clk_0_dutycycle_percent                          (OUT_CLK_DUTYCYCLE_PERCENT[0]),
      .out_clk_0_freq                                       (OUT_CLK_FREQ[0]),
      .out_clk_0_phase_ps                                   (OUT_CLK_PHASE_PS[0]),
      .out_clk_0_phase_shifts                               (OUT_CLK_PHASE_SHIFTS[0]),
      .out_clk_1_c_div                                      (OUT_CLK_C_DIV[1]),
      .out_clk_1_core_en                                    (OUT_CLK_CORE_EN[1]),
      .out_clk_1_delay                                      (OUT_CLK_DELAY[1]),
      .out_clk_1_dutycycle_den                              (OUT_CLK_DUTYCYCLE_DEN[1]),
      .out_clk_1_dutycycle_num                              (OUT_CLK_DUTYCYCLE_NUM[1]),
      .out_clk_1_dutycycle_percent                          (OUT_CLK_DUTYCYCLE_PERCENT[1]),
      .out_clk_1_freq                                       (OUT_CLK_FREQ[1]),
      .out_clk_1_phase_ps                                   (OUT_CLK_PHASE_PS[1]),
      .out_clk_1_phase_shifts                               (OUT_CLK_PHASE_SHIFTS[1]),
      .out_clk_2_c_div                                      (OUT_CLK_C_DIV[2]),
      .out_clk_2_core_en                                    (OUT_CLK_CORE_EN[2]),
      .out_clk_2_delay                                      (OUT_CLK_DELAY[2]),
      .out_clk_2_dutycycle_den                              (OUT_CLK_DUTYCYCLE_DEN[2]),
      .out_clk_2_dutycycle_num                              (OUT_CLK_DUTYCYCLE_NUM[2]),
      .out_clk_2_dutycycle_percent                          (OUT_CLK_DUTYCYCLE_PERCENT[2]),
      .out_clk_2_freq                                       (OUT_CLK_FREQ[2]),
      .out_clk_2_phase_ps                                   (OUT_CLK_PHASE_PS[2]),
      .out_clk_2_phase_shifts                               (OUT_CLK_PHASE_SHIFTS[2]),
      .out_clk_3_c_div                                      (OUT_CLK_C_DIV[3]),
      .out_clk_3_core_en                                    (OUT_CLK_CORE_EN[3]),
      .out_clk_3_delay                                      (OUT_CLK_DELAY[3]),
      .out_clk_3_dutycycle_den                              (OUT_CLK_DUTYCYCLE_DEN[3]),
      .out_clk_3_dutycycle_num                              (OUT_CLK_DUTYCYCLE_NUM[3]),
      .out_clk_3_dutycycle_percent                          (OUT_CLK_DUTYCYCLE_PERCENT[3]),
      .out_clk_3_freq                                       (OUT_CLK_FREQ[3]),
      .out_clk_3_phase_ps                                   (OUT_CLK_PHASE_PS[3]),
      .out_clk_3_phase_shifts                               (OUT_CLK_PHASE_SHIFTS[3]),
      .out_clk_4_c_div                                      (OUT_CLK_C_DIV[4]),
      .out_clk_4_core_en                                    (OUT_CLK_CORE_EN[4]),
      .out_clk_4_delay                                      (OUT_CLK_DELAY[4]),
      .out_clk_4_dutycycle_den                              (OUT_CLK_DUTYCYCLE_DEN[4]),
      .out_clk_4_dutycycle_num                              (OUT_CLK_DUTYCYCLE_NUM[4]),
      .out_clk_4_dutycycle_percent                          (OUT_CLK_DUTYCYCLE_PERCENT[4]),
      .out_clk_4_freq                                       (OUT_CLK_FREQ[4]),
      .out_clk_4_phase_ps                                   (OUT_CLK_PHASE_PS[4]),
      .out_clk_4_phase_shifts                               (OUT_CLK_PHASE_SHIFTS[4]),
      .out_clk_5_c_div                                      (OUT_CLK_C_DIV[5]),
      .out_clk_5_core_en                                    (OUT_CLK_CORE_EN[5]),
      .out_clk_5_delay                                      (OUT_CLK_DELAY[5]),
      .out_clk_5_dutycycle_den                              (OUT_CLK_DUTYCYCLE_DEN[5]),
      .out_clk_5_dutycycle_num                              (OUT_CLK_DUTYCYCLE_NUM[5]),
      .out_clk_5_dutycycle_percent                          (OUT_CLK_DUTYCYCLE_PERCENT[5]),
      .out_clk_5_freq                                       (OUT_CLK_FREQ[5]),
      .out_clk_5_phase_ps                                   (OUT_CLK_PHASE_PS[5]),
      .out_clk_5_phase_shifts                               (OUT_CLK_PHASE_SHIFTS[5]),
      .out_clk_6_c_div                                      (OUT_CLK_C_DIV[6]),
      .out_clk_6_core_en                                    (OUT_CLK_CORE_EN[6]),
      .out_clk_6_delay                                      (OUT_CLK_DELAY[6]),
      .out_clk_6_dutycycle_den                              (OUT_CLK_DUTYCYCLE_DEN[6]),
      .out_clk_6_dutycycle_num                              (OUT_CLK_DUTYCYCLE_NUM[6]),
      .out_clk_6_dutycycle_percent                          (OUT_CLK_DUTYCYCLE_PERCENT[6]),
      .out_clk_6_freq                                       (OUT_CLK_FREQ[6]),
      .out_clk_6_phase_ps                                   (OUT_CLK_PHASE_PS[6]),
      .out_clk_6_phase_shifts                               (OUT_CLK_PHASE_SHIFTS[6]),
      .out_clk_cascading_source                             (OUT_CLK_CASCADING_SOURCE),
      .out_clk_external_0_source                            (OUT_CLK_EXTERNAL_SOURCE[0]),
      .out_clk_external_1_source                            (OUT_CLK_EXTERNAL_SOURCE[1]),
      .out_clk_periph_0_delay                               (OUT_CLK_PERIPH_DELAY[0]),
      .out_clk_periph_0_en                                  (OUT_CLK_PERIPH_EN[0]),
      .out_clk_periph_1_delay                               (OUT_CLK_PERIPH_DELAY[1]),
      .out_clk_periph_1_en                                  (OUT_CLK_PERIPH_EN[1]),
      .pfd_clk_freq                                         (PFD_CLK_FREQ),
      .protocol_mode                                        (PROTOCOL_MODE),
      .ref_clk_0_freq                                       (REF_CLK_FREQ[0]),
      .ref_clk_1_freq                                       (REF_CLK_FREQ[1]),
      .ref_clk_delay                                        (REF_CLK_DELAY),
      .ref_clk_n_div                                        (REF_CLK_N_DIV),
      .self_reset_en                                        (SELF_RESET_EN),
      .set_dutycycle                                        (SET_DUTYCYCLE),
      .set_fractional                                       (SET_FRACTIONAL),
      .set_freq                                             (SET_FREQ),
      .set_phase                                            (SET_PHASE),
      .vco_clk_freq                                         (VCO_CLK_FREQ)
   ) pll (
      .fb_clk_out                                           (fb_clk_out),
      .reset                                                (reset),
      .ref_clk0                                             (ref_clk0),
      .vco_clk_periph                                       (vco_clk_periph),
      .lock                                                 (lock),
      .out_clk                                              (out_clk),
      .vco_clk                                              (vco_clk),
      .cal_bus_readdata                                     (cal_bus_readdata),
      .cal_bus_rst_n                                        (cal_bus_rst_n),
      .cal_bus_clk                                          (cal_bus_clk),
      .cal_bus_write                                        (cal_bus_write),
      .cal_bus_read                                         (cal_bus_read),
      .cal_bus_address                                      (cal_bus_address),
      .cal_bus_writedata                                    (cal_bus_writedata),
      .ref_clk_switch_n                                     (ref_clk_switch_n),
      .permit_cal                                           (permit_cal),
      .ref_clk1                                             (ref_clk1),
      .ref_clk_bad                                          (ref_clk_bad),
      .ref_clk_active                                       (ref_clk_active),
      .fb_clk_in                                            (fb_clk_in),
      .fb_clk_in_lvds                                       (fb_clk_in_lvds),
      .out_clk_external0                                    (out_clk_external0),
      .out_clk_external1                                    (out_clk_external1),
      .out_clk_periph0                                      (out_clk_periph0),
      .out_clk_periph1                                      (out_clk_periph1),
      .out_clk_cascade                                      (out_clk_cascade)
   );

endmodule


