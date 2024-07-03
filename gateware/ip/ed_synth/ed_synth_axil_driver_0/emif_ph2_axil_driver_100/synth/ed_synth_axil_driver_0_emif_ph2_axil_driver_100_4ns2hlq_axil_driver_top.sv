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


module ed_synth_axil_driver_0_emif_ph2_axil_driver_100_4ns2hlq_axil_driver_top
#(
   parameter STATUS_REGISTER_ADDRESS =  'h05000400,
   parameter AXIL_DRIVER_ADDRESS_WIDTH = 32
)
(
   input    wire                                         axil_driver_clk,
   input    wire                                         axil_driver_rst_n,
   output   wire     [AXIL_DRIVER_ADDRESS_WIDTH - 1:0]   axil_driver_araddr,
   output   wire     [2:0]                               axil_driver_arprot,
   output   wire                                         axil_driver_arvalid,
   input    wire                                         axil_driver_arready,
   input    wire     [31:0]                              axil_driver_rdata,
   input    wire     [1:0]                               axil_driver_rresp,
   input    wire                                         axil_driver_rvalid,
   output   wire                                         axil_driver_rready,

   output   wire     [AXIL_DRIVER_ADDRESS_WIDTH - 1:0]   axil_driver_awaddr,
   output   wire     [2:0]                               axil_driver_awprot,
   output   wire                                         axil_driver_awvalid,
   input    wire                                         axil_driver_awready,
   output   wire     [31:0]                              axil_driver_wdata,
   output   wire     [3:0]                               axil_driver_wstrb,
   output   wire                                         axil_driver_wvalid,
   input    wire                                         axil_driver_wready,
   input    wire     [1:0]                               axil_driver_bresp,
   input    wire                                         axil_driver_bvalid,
   output   wire                                         axil_driver_bready,

   output   wire                                         cal_done_rst_n
);

   typedef enum
   {
      RD_IDLE,
      RD_INIT_DELAY,      
      RD_SEND_ARADDR,
      RD_WAIT_RRESP,
      RD_TERMINATE
   } read_state_type;

   (* preserve *) logic    [AXIL_DRIVER_ADDRESS_WIDTH - 1:0]  r_axil_driver_araddr;
   (* preserve *) logic    [2:0]                              r_axil_driver_arprot;
   (* preserve *) logic                                       r_axil_driver_arvalid;
   (* preserve *) logic                                       r_axil_driver_rready;
   (* preserve *) logic    [AXIL_DRIVER_ADDRESS_WIDTH - 1:0]  r_axil_driver_awaddr;
   (* preserve *) logic    [2:0]                              r_axil_driver_awprot;
   (* preserve *) logic                                       r_axil_driver_awvalid;
   (* preserve *) logic    [31:0]                             r_axil_driver_wdata;
   (* preserve *) logic    [3:0]                              r_axil_driver_wstrb;
   (* preserve *) logic                                       r_axil_driver_wvalid;
   (* preserve *) logic                                       r_axil_driver_bready;
   (* preserve *) logic                                       r_cal_done_rst_n;

   read_state_type r_fsm_cs = RD_IDLE;
   read_state_type c_fsm_ns = RD_IDLE;

   logic    [3:0]                                             r_read_wait_ctr;

   assign axil_driver_araddr      = r_axil_driver_araddr;
   assign axil_driver_arprot      = r_axil_driver_arprot;
   assign axil_driver_arvalid     = r_axil_driver_arvalid;
   assign axil_driver_rready      = r_axil_driver_rready;
   assign axil_driver_awaddr      = r_axil_driver_awaddr;
   assign axil_driver_awprot      = r_axil_driver_awprot;
   assign axil_driver_awvalid     = r_axil_driver_awvalid;
   assign axil_driver_wdata       = r_axil_driver_wdata;
   assign axil_driver_wstrb       = r_axil_driver_wstrb;
   assign axil_driver_wvalid      = r_axil_driver_wvalid;
   assign axil_driver_bready      = r_axil_driver_bready;
   assign cal_done_rst_n          = r_cal_done_rst_n;


   always @(posedge axil_driver_clk or negedge axil_driver_rst_n)
   begin
      if (axil_driver_rst_n == 1'b0)
      begin
         r_axil_driver_araddr    <= STATUS_REGISTER_ADDRESS;
         r_axil_driver_arprot    <= 3'b000;
         r_axil_driver_arvalid   <= 1'b0;
         r_axil_driver_rready    <= 1'b0;
         r_axil_driver_awaddr    <= '0;
         r_axil_driver_awprot    <= 3'b000;
         r_axil_driver_awvalid   <= 1'b0;
         r_axil_driver_wdata     <= '0;
         r_axil_driver_wstrb     <= '0;
         r_axil_driver_wvalid    <= 1'b0;
         r_axil_driver_bready    <= 1'b0;
         r_cal_done_rst_n        <= 1'b0;
      end
      else
      begin
         r_axil_driver_araddr    <= STATUS_REGISTER_ADDRESS;
         r_axil_driver_arprot    <= 3'b000;
         r_axil_driver_arvalid   <= ((c_fsm_ns == RD_SEND_ARADDR) ? 1'b1 : 1'b0);
         r_axil_driver_rready    <= ((c_fsm_ns == RD_WAIT_RRESP) ? 1'b1 : 1'b0);
         r_axil_driver_awaddr    <= '0;
         r_axil_driver_awprot    <= 3'b000;
         r_axil_driver_awvalid   <= 1'b0;
         r_axil_driver_wdata     <= '0;
         r_axil_driver_wstrb     <= '0;
         r_axil_driver_wvalid    <= 1'b0;
         r_axil_driver_bready    <= 1'b0;

         if (axil_driver_rvalid == 1'b1)
         begin
            r_cal_done_rst_n <= axil_driver_rdata[0];
         end
      end
   end


   always @(posedge axil_driver_clk or negedge axil_driver_rst_n)
   begin
      if (axil_driver_rst_n == 1'b0)
      begin
         r_read_wait_ctr <= 4'b0111;
      end
      else
      begin
         if (r_fsm_cs == RD_INIT_DELAY)
         begin
            r_read_wait_ctr <= r_read_wait_ctr - 4'b0001;
         end
         else
         begin
            r_read_wait_ctr <= 4'b0111;
         end
      end
   end

   always @(*)
   begin
      case (r_fsm_cs)
         RD_IDLE:
         begin
            c_fsm_ns = RD_INIT_DELAY;
         end

         RD_INIT_DELAY:
         begin
            if (r_read_wait_ctr[3] == 1'b1)
            begin
               c_fsm_ns = RD_SEND_ARADDR;
            end
            else
            begin
               c_fsm_ns = RD_INIT_DELAY;
            end
         end
            
         RD_SEND_ARADDR:
         begin
            if (axil_driver_arready)
            begin
               c_fsm_ns = RD_WAIT_RRESP;
            end
            else
            begin
               c_fsm_ns = RD_SEND_ARADDR;
            end
         end

         RD_WAIT_RRESP:
         begin
            if (axil_driver_rvalid)
            begin
               // synthesis translate_off
               if(axil_driver_rdata[1])
               begin
                  $display("ERROR: Calibration Failed");
                  $finish();
               end
               // synthesis translate_on

               if(axil_driver_rdata[0])
               begin
                  c_fsm_ns = RD_TERMINATE;
               end
               else
               begin
                  c_fsm_ns = RD_IDLE;
               end
            end
            else
            begin
               c_fsm_ns = RD_WAIT_RRESP;
            end
         end

         RD_TERMINATE:
         begin
            c_fsm_ns = RD_TERMINATE;
         end

         default:
         begin
            c_fsm_ns = RD_IDLE;
         end
      endcase
   end


   always @(posedge axil_driver_clk or negedge axil_driver_rst_n)
   begin
      if (axil_driver_rst_n == 1'b0)
      begin
         r_fsm_cs <= RD_IDLE;
      end
      else
      begin
         r_fsm_cs <= c_fsm_ns;
      end
   end

endmodule


