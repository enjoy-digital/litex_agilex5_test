module q_sys_product_info_0 (
		input  wire        clk,          //       clock_reset.clk
		input  wire        reset_n,      // clock_reset_reset.reset_n
		input  wire        chipselect_n, //    avalon_slave_0.chipselect_n
		input  wire        read_n,       //                  .read_n
		output wire [31:0] av_data_read, //                  .readdata
		input  wire [1:0]  av_address    //                  .address
	);
endmodule

