// ed_synth_axil_driver_0.v

// Generated using ACDS version 24.1 115

`timescale 1 ps / 1 ps
module ed_synth_axil_driver_0 (
		input  wire        axil_driver_clk,     //       axil_driver_clk.clk
		input  wire        axil_driver_rst_n,   //     axil_driver_rst_n.reset_n
		output wire [31:0] axil_driver_awaddr,  // axil_driver_axi4_lite.awaddr
		output wire        axil_driver_awvalid, //                      .awvalid
		input  wire        axil_driver_awready, //                      .awready
		output wire [31:0] axil_driver_wdata,   //                      .wdata
		output wire [3:0]  axil_driver_wstrb,   //                      .wstrb
		output wire        axil_driver_wvalid,  //                      .wvalid
		input  wire        axil_driver_wready,  //                      .wready
		input  wire [1:0]  axil_driver_bresp,   //                      .bresp
		input  wire        axil_driver_bvalid,  //                      .bvalid
		output wire        axil_driver_bready,  //                      .bready
		output wire [31:0] axil_driver_araddr,  //                      .araddr
		output wire        axil_driver_arvalid, //                      .arvalid
		input  wire        axil_driver_arready, //                      .arready
		input  wire [31:0] axil_driver_rdata,   //                      .rdata
		input  wire [1:0]  axil_driver_rresp,   //                      .rresp
		input  wire        axil_driver_rvalid,  //                      .rvalid
		output wire        axil_driver_rready,  //                      .rready
		output wire [2:0]  axil_driver_awprot,  //                      .awprot
		output wire [2:0]  axil_driver_arprot,  //                      .arprot
		output wire        cal_done_rst_n       //        cal_done_rst_n.reset_n
	);

	ed_synth_axil_driver_0_emif_ph2_axil_driver_100_4ns2hlq #(
		.AXIL_DRIVER_ADDRESS_WIDTH (32)
	) emif_ph2_axil_driver_inst (
		.axil_driver_clk     (axil_driver_clk),     //   input,   width = 1,       axil_driver_clk.clk
		.axil_driver_rst_n   (axil_driver_rst_n),   //   input,   width = 1,     axil_driver_rst_n.reset_n
		.axil_driver_awaddr  (axil_driver_awaddr),  //  output,  width = 32, axil_driver_axi4_lite.awaddr
		.axil_driver_awvalid (axil_driver_awvalid), //  output,   width = 1,                      .awvalid
		.axil_driver_awready (axil_driver_awready), //   input,   width = 1,                      .awready
		.axil_driver_wdata   (axil_driver_wdata),   //  output,  width = 32,                      .wdata
		.axil_driver_wstrb   (axil_driver_wstrb),   //  output,   width = 4,                      .wstrb
		.axil_driver_wvalid  (axil_driver_wvalid),  //  output,   width = 1,                      .wvalid
		.axil_driver_wready  (axil_driver_wready),  //   input,   width = 1,                      .wready
		.axil_driver_bresp   (axil_driver_bresp),   //   input,   width = 2,                      .bresp
		.axil_driver_bvalid  (axil_driver_bvalid),  //   input,   width = 1,                      .bvalid
		.axil_driver_bready  (axil_driver_bready),  //  output,   width = 1,                      .bready
		.axil_driver_araddr  (axil_driver_araddr),  //  output,  width = 32,                      .araddr
		.axil_driver_arvalid (axil_driver_arvalid), //  output,   width = 1,                      .arvalid
		.axil_driver_arready (axil_driver_arready), //   input,   width = 1,                      .arready
		.axil_driver_rdata   (axil_driver_rdata),   //   input,  width = 32,                      .rdata
		.axil_driver_rresp   (axil_driver_rresp),   //   input,   width = 2,                      .rresp
		.axil_driver_rvalid  (axil_driver_rvalid),  //   input,   width = 1,                      .rvalid
		.axil_driver_rready  (axil_driver_rready),  //  output,   width = 1,                      .rready
		.axil_driver_awprot  (axil_driver_awprot),  //  output,   width = 3,                      .awprot
		.axil_driver_arprot  (axil_driver_arprot),  //  output,   width = 3,                      .arprot
		.cal_done_rst_n      (cal_done_rst_n)       //  output,   width = 1,        cal_done_rst_n.reset_n
	);

endmodule
