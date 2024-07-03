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


`timescale 1ps/1ps

module wr_sipo_plus_gtyc2oq #(
    parameter DEPTH = 1, 
    parameter TOTAL_W = 35,
    parameter ID_W    =10
) (
    input clk,
    input rst,
    // ST Sink IF to accept data
    input in_valid,
    input [TOTAL_W-2:0] in_data, // data in 1 less since valid is internally generated
    output in_ready,
    // flush mem
    input [DEPTH-1:0] clr, // clear mem space -1 bit per element
    output [DEPTH-1:0] shift_occurred, // indicates certain data shift shifted 
    // mem parallel outs  
    output [TOTAL_W-1:0] dout0

);

// mem structure : valid    , meta_data,       ID
//                 TOTAL_W-1,TOTAL_W-2:ID_W ,ID_W-1:0
logic [TOTAL_W-1:0] mem[DEPTH-1:0];

// mem operation - 
// write data @ MSB location when valid data is in
//   i.e. new data enters @ location 7 (DEPTH-1)
// every time any valid is low move elements to right to make sure all
// non-valids are at left
// when moving element to new location clear valid bit of current location
// ---- data unchanged during move on current location

// === data moves


logic shift_in;



assign shift_in  = in_ready & in_valid;




always @ (posedge clk) begin
    if (shift_in)
        mem[1-1][TOTAL_W-2:0] <= in_data[TOTAL_W-2:0];

end

// === valid moves
always @ (posedge clk) begin

    if (rst)
        mem[0][TOTAL_W-1] <= 0;
    else if (shift_in)
        mem[0][TOTAL_W-1] <= 1 & (! clr[0]);
    else if (clr[0])
        mem[0][TOTAL_W-1] <= 0;

end

// ready low when mem is full - all valids are up
assign in_ready = !(  mem[0][TOTAL_W-1]  );

// mem parallel outs
assign dout0 = mem[0];

endmodule
    


