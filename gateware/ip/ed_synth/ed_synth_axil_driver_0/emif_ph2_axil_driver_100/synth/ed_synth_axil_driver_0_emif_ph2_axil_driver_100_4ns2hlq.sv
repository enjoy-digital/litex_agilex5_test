module ed_synth_axil_driver_0_emif_ph2_axil_driver_100_4ns2hlq #(
   parameter AXIL_DRIVER_ADDRESS_WIDTH                          = 0
) (
   input  logic            axil_driver_clk,
   input  logic            axil_driver_rst_n,
   output logic [31:0]     axil_driver_awaddr,
   output logic            axil_driver_awvalid,
   input  logic            axil_driver_awready,
   output logic [31:0]     axil_driver_wdata,
   output logic [3:0]      axil_driver_wstrb,
   output logic            axil_driver_wvalid,
   input  logic            axil_driver_wready,
   input  logic [1:0]      axil_driver_bresp,
   input  logic            axil_driver_bvalid,
   output logic            axil_driver_bready,
   output logic [31:0]     axil_driver_araddr,
   output logic            axil_driver_arvalid,
   input  logic            axil_driver_arready,
   input  logic [31:0]     axil_driver_rdata,
   input  logic [1:0]      axil_driver_rresp,
   input  logic            axil_driver_rvalid,
   output logic            axil_driver_rready,
   output logic [2:0]      axil_driver_awprot,
   output logic [2:0]      axil_driver_arprot,
   output logic            cal_done_rst_n
);
   timeunit 1ns;
   timeprecision 1ps;

   ed_synth_axil_driver_0_emif_ph2_axil_driver_100_4ns2hlq_axil_driver_top # (
      .AXIL_DRIVER_ADDRESS_WIDTH (AXIL_DRIVER_ADDRESS_WIDTH)
   ) ed_synth_axil_driver_0_emif_ph2_axil_driver_100_4ns2hlq_axil_driver_inst (
      .axil_driver_clk (axil_driver_clk),
      .axil_driver_rst_n (axil_driver_rst_n),
      .axil_driver_awaddr (axil_driver_awaddr),
      .axil_driver_awvalid (axil_driver_awvalid),
      .axil_driver_awready (axil_driver_awready),
      .axil_driver_wdata (axil_driver_wdata),
      .axil_driver_wstrb (axil_driver_wstrb),
      .axil_driver_wvalid (axil_driver_wvalid),
      .axil_driver_wready (axil_driver_wready),
      .axil_driver_bresp (axil_driver_bresp),
      .axil_driver_bvalid (axil_driver_bvalid),
      .axil_driver_bready (axil_driver_bready),
      .axil_driver_araddr (axil_driver_araddr),
      .axil_driver_arvalid (axil_driver_arvalid),
      .axil_driver_arready (axil_driver_arready),
      .axil_driver_rdata (axil_driver_rdata),
      .axil_driver_rresp (axil_driver_rresp),
      .axil_driver_rvalid (axil_driver_rvalid),
      .axil_driver_rready (axil_driver_rready),
      .axil_driver_awprot (axil_driver_awprot),
      .axil_driver_arprot (axil_driver_arprot),
      .cal_done_rst_n (cal_done_rst_n)
   );
endmodule
