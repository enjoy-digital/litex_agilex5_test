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

(*altera_attribute = {"-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF"} *)
module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_fa_noc #(
   parameter ID = 0
) (
   AXI_BUS.Subordinate                           core_fanoc_axi_intf,
   AXI_BUS.Manager                               fanoc_hmc_axi_intf,
   input   logic [1:0]                           pll_to_fanoc,
   input                                         hmc_to_fanoc,
   output                                        fanoc_to_core
);
   timeunit 1ns;
   timeprecision 1ps;

   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_fa_noc::*;;

   logic                                phy_clk_fr              ;
   logic                                phy_clk_sync            ;
   logic                                o_noc256_clk_tonoc      ;
   logic                                i_noc256_clk_tonoc      ;
   
   assign {phy_clk_fr,phy_clk_sync} = pll_to_fanoc;

   assign i_noc256_clk_tonoc = hmc_to_fanoc;
   assign fanoc_to_core = o_noc256_clk_tonoc;

   generate
      if (IS_USED)
      begin : gen_noc_fa
         tennm_noc_fabric_adaptor #(   
         ) u_fanoc (
            .i_noc256_araddr_toio    (core_fanoc_axi_intf.araddr    ),
            .i_noc256_arburst_toio   (core_fanoc_axi_intf.arburst   ),
            .i_noc256_arid_toio      (core_fanoc_axi_intf.arid      ),
            .i_noc256_arlen_toio     (core_fanoc_axi_intf.arlen     ),
            .i_noc256_arlock_toio    (core_fanoc_axi_intf.arlock    ),
            .i_noc256_arqos_toio     (core_fanoc_axi_intf.arqos     ),
            .i_noc256_arsize_toio    (core_fanoc_axi_intf.arsize    ),
            .i_noc256_aruser_toio    (core_fanoc_axi_intf.aruser    ),
            .i_noc256_arvalid_toio   (core_fanoc_axi_intf.arvalid   ),
            .i_noc256_awaddr_toio    (core_fanoc_axi_intf.awaddr    ),
            .i_noc256_awburst_toio   (core_fanoc_axi_intf.awburst   ),
            .i_noc256_awid_toio      (core_fanoc_axi_intf.awid      ),
            .i_noc256_awlen_toio     (core_fanoc_axi_intf.awlen     ),
            .i_noc256_awlock_toio    (core_fanoc_axi_intf.awlock    ),
            .i_noc256_awqos_toio     (core_fanoc_axi_intf.awqos     ),
            .i_noc256_awsize_toio    (core_fanoc_axi_intf.awsize    ),
            .i_noc256_awuser_toio    (core_fanoc_axi_intf.awuser    ),
            .i_noc256_awvalid_toio   (core_fanoc_axi_intf.awvalid   ),
            .i_noc256_bready_toio    (core_fanoc_axi_intf.bready    ),
            .i_noc256_rready_toio    (core_fanoc_axi_intf.rready    ),
            .i_noc256_wdata_toio     (core_fanoc_axi_intf.wdata     ),
            .i_noc256_wlast_toio     (core_fanoc_axi_intf.wlast     ),
            .i_noc256_wstrb_toio     (core_fanoc_axi_intf.wstrb     ),
            .i_noc256_wuser_toio     (core_fanoc_axi_intf.wuser     ),
            .i_noc256_wvalid_toio    (core_fanoc_axi_intf.wvalid    ),

            .i_noc256_arready_tonoc  (fanoc_hmc_axi_intf.arready    ),
            .i_noc256_awready_tonoc  (fanoc_hmc_axi_intf.awready    ),
            .i_noc256_bid_tonoc      (fanoc_hmc_axi_intf.bid        ),
            .i_noc256_bresp_tonoc    (fanoc_hmc_axi_intf.bresp      ),
            .i_noc256_bvalid_tonoc   (fanoc_hmc_axi_intf.bvalid     ),
            .i_noc256_clk_tonoc      (i_noc256_clk_tonoc            ),
            .i_noc256_rdata_tonoc    (fanoc_hmc_axi_intf.rdata      ),
            .i_noc256_rid_tonoc      (fanoc_hmc_axi_intf.rid        ),
            .i_noc256_rlast_tonoc    (fanoc_hmc_axi_intf.rlast      ),
            .i_noc256_rresp_tonoc    (fanoc_hmc_axi_intf.rresp      ),
            .i_noc256_ruser_tonoc    (fanoc_hmc_axi_intf.ruser      ),
            .i_noc256_rvalid_tonoc   (fanoc_hmc_axi_intf.rvalid     ),
            .i_noc256_wready_tonoc   (fanoc_hmc_axi_intf.wready     ),

            .o_noc256_araddr_toio    (fanoc_hmc_axi_intf.araddr    ),
            .o_noc256_arburst_toio   (fanoc_hmc_axi_intf.arburst   ),
            .o_noc256_arid_toio      (fanoc_hmc_axi_intf.arid      ),
            .o_noc256_arlen_toio     (fanoc_hmc_axi_intf.arlen     ),
            .o_noc256_arlock_toio    (fanoc_hmc_axi_intf.arlock    ),
            .o_noc256_arqos_toio     (fanoc_hmc_axi_intf.arqos     ),
            .o_noc256_arsize_toio    (fanoc_hmc_axi_intf.arsize    ),
            .o_noc256_aruser_toio    (fanoc_hmc_axi_intf.aruser    ),
            .o_noc256_arvalid_toio   (fanoc_hmc_axi_intf.arvalid   ),
            .o_noc256_awaddr_toio    (fanoc_hmc_axi_intf.awaddr    ),
            .o_noc256_awburst_toio   (fanoc_hmc_axi_intf.awburst   ),
            .o_noc256_awid_toio      (fanoc_hmc_axi_intf.awid      ),
            .o_noc256_awlen_toio     (fanoc_hmc_axi_intf.awlen     ),
            .o_noc256_awlock_toio    (fanoc_hmc_axi_intf.awlock    ),
            .o_noc256_awqos_toio     (fanoc_hmc_axi_intf.awqos     ),
            .o_noc256_awsize_toio    (fanoc_hmc_axi_intf.awsize    ),
            .o_noc256_awuser_toio    (fanoc_hmc_axi_intf.awuser    ),
            .o_noc256_awvalid_toio   (fanoc_hmc_axi_intf.awvalid   ),
            .o_noc256_bready_toio    (fanoc_hmc_axi_intf.bready    ),
            .o_noc256_rready_toio    (fanoc_hmc_axi_intf.rready    ),
            .o_noc256_wdata_toio     (fanoc_hmc_axi_intf.wdata     ),
            .o_noc256_wlast_toio     (fanoc_hmc_axi_intf.wlast     ),
            .o_noc256_wstrb_toio     (fanoc_hmc_axi_intf.wstrb     ),
            .o_noc256_wuser_toio     (fanoc_hmc_axi_intf.wuser     ),
            .o_noc256_wvalid_toio    (fanoc_hmc_axi_intf.wvalid    ),
            
            .o_noc256_arready_tonoc  (core_fanoc_axi_intf.arready  ),
            .o_noc256_awready_tonoc  (core_fanoc_axi_intf.awready  ),
            .o_noc256_bid_tonoc      (core_fanoc_axi_intf.bid      ),
            .o_noc256_bresp_tonoc    (core_fanoc_axi_intf.bresp    ),
            .o_noc256_bvalid_tonoc   (core_fanoc_axi_intf.bvalid   ),
            .o_noc256_clk_tonoc      (o_noc256_clk_tonoc           ),
            .o_noc256_rdata_tonoc    (core_fanoc_axi_intf.rdata    ),
            .o_noc256_rid_tonoc      (core_fanoc_axi_intf.rid      ),
            .o_noc256_rlast_tonoc    (core_fanoc_axi_intf.rlast    ),
            .o_noc256_rresp_tonoc    (core_fanoc_axi_intf.rresp    ),
            .o_noc256_ruser_tonoc    (core_fanoc_axi_intf.ruser    ),
            .o_noc256_rvalid_tonoc   (core_fanoc_axi_intf.rvalid   ),
            .o_noc256_wready_tonoc   (core_fanoc_axi_intf.wready   )
         );
      end
      else
      begin : gen_no_noc_fa
         assign fanoc_hmc_axi_intf.araddr    = '0;
         assign fanoc_hmc_axi_intf.arburst   = '0;
         assign fanoc_hmc_axi_intf.arid      = '0;
         assign fanoc_hmc_axi_intf.arlen     = '0;
         assign fanoc_hmc_axi_intf.arlock    = '0;
         assign fanoc_hmc_axi_intf.arqos     = '0;
         assign fanoc_hmc_axi_intf.arsize    = '0;
         assign fanoc_hmc_axi_intf.aruser    = '0;
         assign fanoc_hmc_axi_intf.arvalid   = '0;
         assign fanoc_hmc_axi_intf.awaddr    = '0;
         assign fanoc_hmc_axi_intf.awburst   = '0;
         assign fanoc_hmc_axi_intf.awid      = '0;
         assign fanoc_hmc_axi_intf.awlen     = '0;
         assign fanoc_hmc_axi_intf.awlock    = '0;
         assign fanoc_hmc_axi_intf.awqos     = '0;
         assign fanoc_hmc_axi_intf.awsize    = '0;
         assign fanoc_hmc_axi_intf.awuser    = '0;
         assign fanoc_hmc_axi_intf.awvalid   = '0;
         assign fanoc_hmc_axi_intf.bready    = '0;
         assign fanoc_hmc_axi_intf.rready    = '0;
         assign fanoc_hmc_axi_intf.wdata     = '0;
         assign fanoc_hmc_axi_intf.wlast     = '0;
         assign fanoc_hmc_axi_intf.wstrb     = '0;
         assign fanoc_hmc_axi_intf.wuser     = '0;
         assign fanoc_hmc_axi_intf.wvalid    = '0;
         assign core_fanoc_axi_intf.arready  = '0;
         assign core_fanoc_axi_intf.awready  = '0;
         assign core_fanoc_axi_intf.bid      = '0;
         assign core_fanoc_axi_intf.bresp    = '0;
         assign core_fanoc_axi_intf.bvalid   = '0;
         assign core_fanoc_axi_intf.rdata    = '0;
         assign core_fanoc_axi_intf.rid      = '0;
         assign core_fanoc_axi_intf.rlast    = '0;
         assign core_fanoc_axi_intf.rresp    = '0;
         assign core_fanoc_axi_intf.ruser    = '0;
         assign core_fanoc_axi_intf.rvalid   = '0;
         assign core_fanoc_axi_intf.wready   = '0;
         assign o_noc256_clk_tonoc           = '0;
      end
   endgenerate

   assign fanoc_hmc_axi_intf.awcache  = '0;
   assign fanoc_hmc_axi_intf.awprot   = '0;
   assign fanoc_hmc_axi_intf.arcache  = '0;
   assign fanoc_hmc_axi_intf.arprot   = '0;


endmodule


