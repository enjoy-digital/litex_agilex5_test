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
endmodule

