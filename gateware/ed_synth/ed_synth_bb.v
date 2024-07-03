module ed_synth (
		input  wire         axil_driver_clk_i_clk,       //   axil_driver_clk_i.clk
		input  wire         axil_driver_rst_n_i_reset_n, // axil_driver_rst_n_i.reset_n
		output wire         cal_done_rst_n_reset_n,      //      cal_done_rst_n.reset_n
		input  wire         ref_clk_i_clk,               //           ref_clk_i.clk
		input  wire         core_init_n_i_reset_n,       //       core_init_n_i.reset_n
		output wire         usr_clk_o_clk,               //           usr_clk_o.clk
		output wire         usr_rst_n_o_reset_n,         //         usr_rst_n_o.reset_n
		input  wire [31:0]  s0_axi4_araddr,              //             s0_axi4.araddr
		input  wire [1:0]   s0_axi4_arburst,             //                    .arburst
		input  wire [6:0]   s0_axi4_arid,                //                    .arid
		input  wire [7:0]   s0_axi4_arlen,               //                    .arlen
		input  wire         s0_axi4_arlock,              //                    .arlock
		input  wire [3:0]   s0_axi4_arqos,               //                    .arqos
		input  wire [2:0]   s0_axi4_arsize,              //                    .arsize
		input  wire         s0_axi4_arvalid,             //                    .arvalid
		input  wire [3:0]   s0_axi4_aruser,              //                    .aruser
		input  wire [2:0]   s0_axi4_arprot,              //                    .arprot
		input  wire [31:0]  s0_axi4_awaddr,              //                    .awaddr
		input  wire [1:0]   s0_axi4_awburst,             //                    .awburst
		input  wire [6:0]   s0_axi4_awid,                //                    .awid
		input  wire [7:0]   s0_axi4_awlen,               //                    .awlen
		input  wire         s0_axi4_awlock,              //                    .awlock
		input  wire [3:0]   s0_axi4_awqos,               //                    .awqos
		input  wire [2:0]   s0_axi4_awsize,              //                    .awsize
		input  wire         s0_axi4_awvalid,             //                    .awvalid
		input  wire [3:0]   s0_axi4_awuser,              //                    .awuser
		input  wire [2:0]   s0_axi4_awprot,              //                    .awprot
		input  wire         s0_axi4_bready,              //                    .bready
		input  wire         s0_axi4_rready,              //                    .rready
		input  wire [255:0] s0_axi4_wdata,               //                    .wdata
		input  wire [31:0]  s0_axi4_wstrb,               //                    .wstrb
		input  wire         s0_axi4_wlast,               //                    .wlast
		input  wire         s0_axi4_wvalid,              //                    .wvalid
		input  wire [63:0]  s0_axi4_wuser,               //                    .wuser
		output wire [63:0]  s0_axi4_ruser,               //                    .ruser
		output wire         s0_axi4_arready,             //                    .arready
		output wire         s0_axi4_awready,             //                    .awready
		output wire [6:0]   s0_axi4_bid,                 //                    .bid
		output wire [1:0]   s0_axi4_bresp,               //                    .bresp
		output wire         s0_axi4_bvalid,              //                    .bvalid
		output wire [255:0] s0_axi4_rdata,               //                    .rdata
		output wire [6:0]   s0_axi4_rid,                 //                    .rid
		output wire         s0_axi4_rlast,               //                    .rlast
		output wire [1:0]   s0_axi4_rresp,               //                    .rresp
		output wire         s0_axi4_rvalid,              //                    .rvalid
		output wire         s0_axi4_wready,              //                    .wready
		output wire         mem_mem_ck_t,                //                 mem.mem_ck_t
		output wire         mem_mem_ck_c,                //                    .mem_ck_c
		output wire         mem_mem_cke,                 //                    .mem_cke
		output wire         mem_mem_reset_n,             //                    .mem_reset_n
		output wire         mem_mem_cs,                  //                    .mem_cs
		output wire [5:0]   mem_mem_ca,                  //                    .mem_ca
		inout  wire [31:0]  mem_mem_dq,                  //                    .mem_dq
		inout  wire [3:0]   mem_mem_dqs_t,               //                    .mem_dqs_t
		inout  wire [3:0]   mem_mem_dqs_c,               //                    .mem_dqs_c
		inout  wire [3:0]   mem_mem_dmi,                 //                    .mem_dmi
		input  wire         oct_oct_rzqin,               //                 oct.oct_rzqin
		input  wire         s0_axil_clk_i_clk,           //       s0_axil_clk_i.clk
		input  wire         s0_axil_rst_n_i_reset_n      //     s0_axil_rst_n_i.reset_n
	);
endmodule

