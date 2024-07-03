	q_sys_product_info_0 u0 (
		.clk          (_connected_to_clk_),          //   input,   width = 1,       clock_reset.clk
		.reset_n      (_connected_to_reset_n_),      //   input,   width = 1, clock_reset_reset.reset_n
		.chipselect_n (_connected_to_chipselect_n_), //   input,   width = 1,    avalon_slave_0.chipselect_n
		.read_n       (_connected_to_read_n_),       //   input,   width = 1,                  .read_n
		.av_data_read (_connected_to_av_data_read_), //  output,  width = 32,                  .readdata
		.av_address   (_connected_to_av_address_)    //   input,   width = 2,                  .address
	);

