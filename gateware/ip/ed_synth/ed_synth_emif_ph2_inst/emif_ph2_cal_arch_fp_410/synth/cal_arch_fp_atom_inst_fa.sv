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



module stdfn_inst_fa_c2p_ssm #(
   parameter IS_USED  = 0,

   parameter SSM_C2P_DATA_MODE                               = "SSM_C2P_DATA_MODE_BYPASS",
   parameter FA_CORE_PERIPH_CLK_SEL_DATA_MODE                = "FA_CORE_PERIPH_CLK_SEL_DATA_MODE_UNUSED",
   parameter SSM_P2C_DATA_MODE                               = "SSM_P2C_DATA_MODE_BYPASS",
   localparam PORT_I_SSM_C2P_WIDTH                            = 40,
   localparam PORT_O_SSM_C2P_WIDTH                            = 40,
   localparam PORT_I_SSM_P2C_WIDTH                            = 20,
   localparam PORT_O_SSM_P2C_WIDTH                            = 20
) (
   input                                                      i_core_clk,
   input [PORT_I_SSM_C2P_WIDTH-1:0]                           i_ssm_c2p,
   output [PORT_O_SSM_C2P_WIDTH-1:0]                           o_ssm_c2p,
   input                                                      i_phy_clk_fr,
   input                                                      i_phy_clk_sync,
   input [PORT_I_SSM_P2C_WIDTH-1:0]                           i_ssm_p2c,
   output [PORT_O_SSM_P2C_WIDTH-1:0]                           o_ssm_p2c
);
   timeunit 1ns;
   timeprecision 1ps;

   tennm_ssm_c2p_fabric_adaptor # (
      .ssm_c2p_data_mode                                    (SSM_C2P_DATA_MODE),
      .fa_core_periph_clk_sel_data_mode                     (FA_CORE_PERIPH_CLK_SEL_DATA_MODE)
   ) fa_c2p_ssm (
      .i_core_clk                                           (i_core_clk),
      .i_phy_clk_fr                                         (i_phy_clk_fr),
      .i_phy_clk_sync                                       (i_phy_clk_sync),
      .i_ssm_c2p                                            (i_ssm_c2p),
      .o_ssm_c2p                                            (o_ssm_c2p)
   );
   tennm_ssm_p2c_fabric_adaptor # (
      .ssm_p2c_data_mode                                    (SSM_P2C_DATA_MODE),
      .fa_core_periph_clk_sel_data_mode                     (FA_CORE_PERIPH_CLK_SEL_DATA_MODE)
   ) fa_p2c_ssm (
      .i_core_clk                                           (i_core_clk),
      .i_phy_clk_fr                                         (i_phy_clk_fr),
      .i_phy_clk_sync                                       (i_phy_clk_sync),
      .i_ssm_p2c                                            (i_ssm_p2c),
      .o_ssm_p2c                                            (o_ssm_p2c)
   );

endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "KIHsQL0tn7BsUxBiGtJAtAS6pksHg7tDJRLb6E/4ePx3ERhHTZ1dA6gNXMqWG+CEWUXOGdJkgLCJwkJ8Srhz2gxETnyhomLOh1pNf9WR9PqT6wR34xo7Nti9lq/RJOXdEpTr7VVj2iWC2T2LNF/8wb/dT3TME3lg/sj8FvUrkhzj9+2WhMlavwkUnMqPB+XWy2aSZYD9uwvr/hWprSk9cyHVtAO2aBryJMf64EZmndQMCXsrijRxIruP5zI94FMTm68927hJ4Z/IqMTrRrYbue51tUWou31HOpauI5k01m+vmMiO2hERMbGQFpQ2u+WvH5yiPtm47qRjranzWNtt61wi/e0UvbjKn8mSXiWeHzVlNxT18jDkHS4AvuBpnKof5QbKTd8ckd9tayeAd2Rnb0xzyx30tzwAGg+BJ2ml1b/KAl9IsOajUjsYmbFWcnd1em08x7bjR757h6UELdJ28EIWUujbVowJcgI6YfeOOfDkrtErKUKlcLlWhrdgM02gWajOA2fRRp8UsG7fguJvk4R3tSVVW3VILvvOxcyQbQWUF9W6VJ8ctGlv6R6Jbhi+WCT1etYcODNMHALNqlFM07WK4Y8Oe6s+KRlMm+cYeBnfGRm8LkMWo6EMdbPlyakN0twbyKbp0G1EPh+5DIAZkt5+cCxWKb7PJ/+NxSnZvj5tSJJqzJXYnc4/ZYYHIJgMEMSaWN4x3jmKnr/GqGtc3jtIn3shtEL6SBDOeufrqLv8bglAx3vum/9LfTzUzuRg5/FvGxTacBWxqX7WCB/OYU168lNdwC5fMNNx6PjGD0BTyHSaxNIB1iyTJ3boah0cV30/HrnAYmXXwwAynb5qBhPWBMWHs3lppueQQU/gC09nh96aP86YJz2V/ncBdGD0mly4b6LhOxqdocHkZNjKI023SA+nPF6CAzaQl+vMK5kU1WoAuktpN/DCoAR8YSw0eLqaNladu5Er+DUv0KeNwnVHM79Rq1LJAb/0S6TO4sp28jQfL/8ckJoMmHAM4JmY"
`endif