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



module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_fa_hmc #(

   parameter ID                               = 0,

   localparam PORT_C2P_HMC_WIDTH = 168,
   localparam PORT_P2C_HMC_WIDTH = 32,

   localparam INTF_PLL_TO_FAHMC_WIDTH = 2,

   localparam INTF_CORE_TO_FAHMC_WIDTH = PORT_C2P_HMC_WIDTH,
   localparam INTF_FAHMC_TO_HMC_WIDTH = PORT_C2P_HMC_WIDTH,

   localparam INTF_HMC_TO_FAHMC_WIDTH = PORT_P2C_HMC_WIDTH,
   localparam INTF_FAHMC_TO_CORE_WIDTH = PORT_P2C_HMC_WIDTH,

   localparam C2P_REGISTER_STAGE = 1,
   localparam C2P_REGISTER_DELAY_PS = 350,
   localparam P2C_REGISTER_STAGE = 1

) (
   input  logic                                cpa_to_fahmc,
   input  logic [INTF_PLL_TO_FAHMC_WIDTH-1:0]  pll_to_fahmc,

   input  logic [INTF_CORE_TO_FAHMC_WIDTH-1:0] core_to_fahmc,
   output logic [INTF_FAHMC_TO_CORE_WIDTH-1:0] fahmc_to_core,

   input  logic [INTF_HMC_TO_FAHMC_WIDTH-1:0]  hmc_to_fahmc,
   output logic [INTF_FAHMC_TO_HMC_WIDTH-1:0]  fahmc_to_hmc
);
   timeunit 1ns;
   timeprecision 1ps;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_hmc::*;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_p2c_hmc::*;

   logic                                i_phy_clk_fr;
   logic                                i_phy_clk_sync;
   logic                                i_core_clk;

   logic    [PORT_C2P_HMC_WIDTH-1:0]    i_hmc_c2p;
   logic    [PORT_C2P_HMC_WIDTH-1:0]    o_hmc_c2p;

   logic    [PORT_P2C_HMC_WIDTH-1:0]    i_hmc_p2c;
   logic    [PORT_P2C_HMC_WIDTH-1:0]    o_hmc_p2c;
   logic                                i_mipi_fwd_clk;

   genvar                               g;

   assign fahmc_to_hmc  = o_hmc_c2p;

   assign i_core_clk = cpa_to_fahmc;
   assign {i_phy_clk_fr, i_phy_clk_sync}= pll_to_fahmc;

   assign i_hmc_p2c = hmc_to_fahmc;


   generate
   begin

      if (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_hmc::IS_USED[ID])
      begin : gen_hmc_c2p_fa
         tennm_hmc_c2p_fabric_adaptor # (
            .fa_core_periph_clk_sel_data_mode                  (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_hmc::FA_CORE_PERIPH_CLK_SEL_DATA_MODE[ID]),
            .hmc_c2p_data_mode                                 (HMC_C2P_DATA_MODE[ID])
         ) fa_c2p_hmc (
            .i_hmc_c2p                                         (i_hmc_c2p     ),
            .o_hmc_c2p                                         (o_hmc_c2p     ),
            .i_phy_clk_fr                                      (i_phy_clk_fr  ),
            .i_phy_clk_sync                                    (i_phy_clk_sync),
            .i_core_clk                                        (i_core_clk    )
         );
      end
      else
      begin : gen_no_hmc_c2p_fa
         assign o_hmc_c2p          = '0;
      end

      if (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_p2c_hmc::IS_USED[ID])
      begin : gen_hmc_p2c_fa

         tennm_hmc_p2c_fabric_adaptor # (
            .fa_core_periph_clk_sel_data_mode                  (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_p2c_hmc::FA_CORE_PERIPH_CLK_SEL_DATA_MODE[ID]),
            .fwd_clock_divide_data_mode                        (FWD_CLOCK_DIVIDE_DATA_MODE[ID]),
            .hmc_p2c_data_mode                                 (HMC_P2C_DATA_MODE[ID])
         ) fa_p2c_hmc (
            .i_hmc_p2c                                         (i_hmc_p2c     ),
            .o_hmc_p2c                                         (o_hmc_p2c     ),
            .i_phy_clk_fr                                      (i_phy_clk_fr  ),
            .i_phy_clk_sync                                    (i_phy_clk_sync),
            .i_core_clk                                        (i_core_clk    ),
            .i_mipi_fwd_clk                                    (i_mipi_fwd_clk)
         );
      end
      else
      begin : gen_no_hmc_p2c_fa
         assign o_hmc_p2c          = '0;
      end

      if ((C2P_REGISTER_STAGE > 0) && (C2P_REGISTER_DELAY_PS == 100) && (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_hmc::IS_USED[ID]))
      begin : gen_hmc_c2p_reg_100
         for (g = 0; g < PORT_C2P_HMC_WIDTH; g = g + 1)
         begin : gen_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 100"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(core_to_fahmc[g]),
               .q(i_hmc_c2p[g])
            );
         end
      end
      else if ((C2P_REGISTER_STAGE > 0) && (C2P_REGISTER_DELAY_PS == 225) && (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_hmc::IS_USED[ID]))
      begin : gen_hmc_c2p_reg_225
         for (g = 0; g < PORT_C2P_HMC_WIDTH; g = g + 1)
         begin : gen_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 225"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(core_to_fahmc[g]),
               .q(i_hmc_c2p[g])
            );
         end
      end
      else if ((C2P_REGISTER_STAGE > 0) && (C2P_REGISTER_DELAY_PS == 350) && (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_c2p_hmc::IS_USED[ID]))
      begin : gen_hmc_c2p_reg_350
         for (g = 0; g < PORT_C2P_HMC_WIDTH; g = g + 1)
         begin : gen_c2p_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON; -name HYPER_REGISTER_DELAY_CHAIN 350"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(core_to_fahmc[g]),
               .q(i_hmc_c2p[g])
            );
         end
      end
      else
      begin : gen_hmc_c2p_reg_bypass
         assign i_hmc_c2p = core_to_fahmc;
      end
   end
   endgenerate

   generate
   begin
      if ((P2C_REGISTER_STAGE > 0) && (ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_p2c_hmc::IS_USED[ID]))
      begin : gen_hmc_p2c_reg
         for (g = 0; g < PORT_P2C_HMC_WIDTH; g = g + 1)
         begin : gen_p2c_ff
            (* altera_attribute = {"-name FORCE_HYPER_REGISTER_FOR_PERIPHERY_CORE_TRANSFER ON"} *)
            tennm_ff inst_ff
            (
               .clk(i_core_clk),
               .d(o_hmc_p2c[g]),
               .q(fahmc_to_core[g])
            );
         end
      end
      else
      begin : gen_hmc_p2c_reg_bypass
         assign fahmc_to_core = o_hmc_p2c;
      end
   end
   endgenerate

endmodule


