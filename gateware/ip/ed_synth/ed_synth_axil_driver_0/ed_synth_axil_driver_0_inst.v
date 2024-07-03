	ed_synth_axil_driver_0 u0 (
		.axil_driver_clk     (_connected_to_axil_driver_clk_),     //   input,   width = 1,       axil_driver_clk.clk
		.axil_driver_rst_n   (_connected_to_axil_driver_rst_n_),   //   input,   width = 1,     axil_driver_rst_n.reset_n
		.axil_driver_awaddr  (_connected_to_axil_driver_awaddr_),  //  output,  width = 32, axil_driver_axi4_lite.awaddr
		.axil_driver_awvalid (_connected_to_axil_driver_awvalid_), //  output,   width = 1,                      .awvalid
		.axil_driver_awready (_connected_to_axil_driver_awready_), //   input,   width = 1,                      .awready
		.axil_driver_wdata   (_connected_to_axil_driver_wdata_),   //  output,  width = 32,                      .wdata
		.axil_driver_wstrb   (_connected_to_axil_driver_wstrb_),   //  output,   width = 4,                      .wstrb
		.axil_driver_wvalid  (_connected_to_axil_driver_wvalid_),  //  output,   width = 1,                      .wvalid
		.axil_driver_wready  (_connected_to_axil_driver_wready_),  //   input,   width = 1,                      .wready
		.axil_driver_bresp   (_connected_to_axil_driver_bresp_),   //   input,   width = 2,                      .bresp
		.axil_driver_bvalid  (_connected_to_axil_driver_bvalid_),  //   input,   width = 1,                      .bvalid
		.axil_driver_bready  (_connected_to_axil_driver_bready_),  //  output,   width = 1,                      .bready
		.axil_driver_araddr  (_connected_to_axil_driver_araddr_),  //  output,  width = 32,                      .araddr
		.axil_driver_arvalid (_connected_to_axil_driver_arvalid_), //  output,   width = 1,                      .arvalid
		.axil_driver_arready (_connected_to_axil_driver_arready_), //   input,   width = 1,                      .arready
		.axil_driver_rdata   (_connected_to_axil_driver_rdata_),   //   input,  width = 32,                      .rdata
		.axil_driver_rresp   (_connected_to_axil_driver_rresp_),   //   input,   width = 2,                      .rresp
		.axil_driver_rvalid  (_connected_to_axil_driver_rvalid_),  //   input,   width = 1,                      .rvalid
		.axil_driver_rready  (_connected_to_axil_driver_rready_),  //  output,   width = 1,                      .rready
		.axil_driver_awprot  (_connected_to_axil_driver_awprot_),  //  output,   width = 3,                      .awprot
		.axil_driver_arprot  (_connected_to_axil_driver_arprot_),  //  output,   width = 3,                      .arprot
		.cal_done_rst_n      (_connected_to_cal_done_rst_n_)       //  output,   width = 1,        cal_done_rst_n.reset_n
	);

