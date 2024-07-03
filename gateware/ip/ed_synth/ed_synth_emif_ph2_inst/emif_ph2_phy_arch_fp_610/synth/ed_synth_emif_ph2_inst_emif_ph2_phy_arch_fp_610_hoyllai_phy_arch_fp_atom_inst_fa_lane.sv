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



module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_fa_lane #(

   parameter ID                               = 0,

   localparam PORT_P2C_WIDTH = 96,
   localparam PORT_P2C_CTRL_WIDTH = 4,
   localparam PORT_C2P_WIDTH = 96,
   localparam PORT_C2P_CTRL_WIDTH = 20,

   localparam INTF_CORE_TO_FALANE_WIDTH = PORT_C2P_WIDTH + PORT_C2P_CTRL_WIDTH,
   localparam INTF_FALANE_TO_CORE_WIDTH = PORT_P2C_WIDTH + PORT_P2C_CTRL_WIDTH,

   localparam INTF_PA_TO_FALANE_WIDTH  = PORT_P2C_WIDTH + PORT_P2C_CTRL_WIDTH + 1,
   localparam INTF_FALANE_TO_PA_WIDTH  = PORT_C2P_WIDTH + PORT_C2P_CTRL_WIDTH,

   localparam INTF_HMC_TO_FALANE_WIDTH = 100,
   localparam INTF_FALANE_TO_HMC_WIDTH = 116,

   localparam INTF_PLL_TO_FALANE_WIDTH = 2,

   localparam C2P_REGISTER_STAGE = 1,
   localparam C2P_REGISTER_DELAY_PS = 350,
   localparam P2C_REGISTER_STAGE = 1

) (
   input logic                                   cpa_to_falane,
   input logic [INTF_PLL_TO_FALANE_WIDTH-1:0]    pll_to_falane,

   input logic [INTF_CORE_TO_FALANE_WIDTH-1:0]   core_to_falane,
   output logic [INTF_FALANE_TO_CORE_WIDTH-1:0]  falane_to_core,

   input  logic [INTF_HMC_TO_FALANE_WIDTH-1:0]   hmc_to_falane,
   output logic [INTF_FALANE_TO_HMC_WIDTH-1:0]   falane_to_hmc,

   input logic [INTF_PA_TO_FALANE_WIDTH-1:0]     pa_to_falane,
   output logic [INTF_FALANE_TO_PA_WIDTH-1:0]    falane_to_pa

);
   timeunit 1ns;
   timeprecision 1ps;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_lane::*;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_p2c_lane::*;

   logic                                           i_core_clk;
   logic                                           i_phy_clk_fr;
   logic                                           i_phy_clk_sync;

   logic    [PORT_C2P_WIDTH-1:0]                   i_c2p;
   logic    [PORT_C2P_CTRL_WIDTH-1:0]              i_c2p_ctrl;
   logic    [PORT_C2P_WIDTH-1:0]                   o_c2p_hmc;
   logic    [PORT_C2P_CTRL_WIDTH-1:0]              o_c2p_hmc_ctrl;
   logic    [PORT_C2P_WIDTH-1:0]                   o_c2p_phylite;
   logic    [PORT_C2P_CTRL_WIDTH-1:0]              o_c2p_phylite_ctrl;
   logic                                           i_mipi_fwd_clk;

   logic    [PORT_P2C_WIDTH-1:0]                   o_p2c;
   logic    [PORT_P2C_CTRL_WIDTH-1:0]              o_p2c_ctrl;
   logic    [PORT_P2C_WIDTH-1:0]                   i_hmc;
   logic    [PORT_P2C_CTRL_WIDTH-1:0]              i_p2c_hmc_ctrl;
   logic    [PORT_P2C_WIDTH-1:0]                   i_phy;
   logic    [PORT_P2C_CTRL_WIDTH-1:0]              i_p2c_phylite_ctrl;

   genvar                                          g;

   assign i_core_clk = cpa_to_falane;
   assign {i_phy_clk_fr, i_phy_clk_sync} = pll_to_falane;

   assign {i_p2c_phylite_ctrl, i_phy, i_mipi_fwd_clk} = pa_to_falane;
   assign {i_p2c_hmc_ctrl, i_hmc} = hmc_to_falane;

   assign falane_to_pa   = {o_c2p_phylite_ctrl, o_c2p_phylite};
   assign falane_to_hmc  = {o_c2p_hmc_ctrl, o_c2p_hmc};

   generate
      if (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_lane::IS_USED[ID])
      begin : gen_lane_c2p_fa
         tennm_lane_c2p_fabric_adaptor # (
            .fa_core_periph_clk_sel_data_mode        (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_lane::FA_CORE_PERIPH_CLK_SEL_DATA_MODE[ID]),
            .io12lane_c2p_data_mode                  (IO12LANE_C2P_DATA_MODE[ID])
         ) fa_c2p_lane (
            .i_c2p                                   (i_c2p),
            .i_c2p_ctrl                              (i_c2p_ctrl),
            .i_core_clk                              (i_core_clk),
            .o_c2p_hmc                               (o_c2p_hmc),
            .o_c2p_hmc_ctrl                          (o_c2p_hmc_ctrl),
            .o_c2p_phylite                           (o_c2p_phylite),
            .o_c2p_phylite_ctrl                      (o_c2p_phylite_ctrl),
            .i_phy_clk_fr                            (i_phy_clk_fr),
            .i_phy_clk_sync                          (i_phy_clk_sync)
         );
      end
      else
      begin : gen_no_lane_c2p_fa
         assign o_c2p_hmc           = '0;
         assign o_c2p_hmc_ctrl      = '0;
         assign o_c2p_phylite       = '0;
         assign o_c2p_phylite_ctrl  = '0;
      end

      if (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_p2c_lane::IS_USED[ID])
      begin : gen_lane_p2c_fa
         tennm_lane_p2c_fabric_adaptor # (
            .fa_core_periph_clk_sel_data_mode        (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_p2c_lane::FA_CORE_PERIPH_CLK_SEL_DATA_MODE[ID]),
            .fwd_clock_divide_data_mode              (FWD_CLOCK_DIVIDE_DATA_MODE[ID]),
            .io12lane_p2c_data_mode                  (IO12LANE_P2C_DATA_MODE[ID])
         ) fa_p2c_lane (
           .i_core_clk                               (i_core_clk),
           .o_p2c                                    (o_p2c),
           .o_p2c_ctrl                               (o_p2c_ctrl),
           .i_hmc                                    (i_hmc),
           .i_p2c_hmc_ctrl                           (i_p2c_hmc_ctrl),
           .i_p2c_phylite_ctrl                       (i_p2c_phylite_ctrl),
           .i_phy                                    (i_phy),
           .i_phy_clk_fr                             (i_phy_clk_fr),
           .i_phy_clk_sync                           (i_phy_clk_sync),
           .i_mipi_fwd_clk                           (i_mipi_fwd_clk)
         );
      end
      else
      begin : gen_no_lane_p2c_fa
         assign o_p2c      = '0;
         assign o_p2c_ctrl = '0;
      end
   endgenerate

   generate
   begin   
      if ((C2P_REGISTER_STAGE > 0) && (C2P_REGISTER_DELAY_PS == 100) && (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_lane::IS_USED[ID]))
      begin : gen_lane_c2p_reg_100
         for (g = 0; g < PORT_C2P_WIDTH; g = g + 1)
         begin : gen_c2p_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 100"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(core_to_falane[g]),
               .q(i_c2p[g])
            );
         end

         for (g = 0; g < PORT_C2P_CTRL_WIDTH; g = g + 1)
         begin : gen_c2p_ctrl_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 100"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(core_to_falane[g+PORT_C2P_WIDTH]),
               .q(i_c2p_ctrl[g])
            );
         end
      end
      else if ((C2P_REGISTER_STAGE > 0) && (C2P_REGISTER_DELAY_PS == 225) && (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_lane::IS_USED[ID]))
      begin : gen_lane_c2p_reg_225
         for (g = 0; g < PORT_C2P_WIDTH; g = g + 1)
         begin : gen_c2p_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 225"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(core_to_falane[g]),
               .q(i_c2p[g])
            );
         end

         for (g = 0; g < PORT_C2P_CTRL_WIDTH; g = g + 1)
         begin : gen_c2p_ctrl_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 225"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(core_to_falane[g+PORT_C2P_WIDTH]),
               .q(i_c2p_ctrl[g])
            );
         end
      end
      else if ((C2P_REGISTER_STAGE > 0) && (C2P_REGISTER_DELAY_PS == 350) && (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_lane::IS_USED[ID]))
      begin : gen_lane_c2p_reg_350
         for (g = 0; g < PORT_C2P_WIDTH; g = g + 1)
         begin : gen_c2p_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 350"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(core_to_falane[g]),
               .q(i_c2p[g])
            );
         end

         for (g = 0; g < PORT_C2P_CTRL_WIDTH; g = g + 1)
         begin : gen_c2p_ctrl_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 350"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(core_to_falane[g+PORT_C2P_WIDTH]),
               .q(i_c2p_ctrl[g])
            );
         end
      end
      else
      begin : gen_lane_c2p_reg_bypass
         assign {i_c2p_ctrl, i_c2p} = core_to_falane;
      end
   end
   endgenerate

   generate
   begin
      if ((P2C_REGISTER_STAGE > 0) && (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_p2c_lane::IS_USED[ID]))
      begin : gen_lane_p2c_reg
         for (g = 0; g < PORT_P2C_WIDTH; g = g + 1)
         begin : gen_p2c_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_PERIPHERY_CORE_TRANSFER ON"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(o_p2c[g]),
               .q(falane_to_core[g])
            );
         end

         for (g = 0; g < PORT_P2C_CTRL_WIDTH; g = g + 1)
         begin : gen_p2c_ctrl_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_PERIPHERY_CORE_TRANSFER ON"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(o_p2c_ctrl[g]),
               .q(falane_to_core[g+PORT_P2C_WIDTH])
            );
         end
      end
      else
      begin : gen_lane_p2c_reg_bypass
         assign falane_to_core = {o_p2c_ctrl, o_p2c};
      end
   end
   endgenerate

endmodule


