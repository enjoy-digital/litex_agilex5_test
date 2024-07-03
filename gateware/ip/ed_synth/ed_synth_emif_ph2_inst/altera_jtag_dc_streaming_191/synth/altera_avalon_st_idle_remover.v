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


// --------------------------------------------------------------------------------
//| Avalon ST Idle Remover 
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_idle_remover (

      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: ST in
      output reg         in_ready,
      input              in_valid,
      input      [7: 0]  in_data,

      // Interface: ST out 
      input              out_ready,
      output reg         out_valid,
      output reg [7: 0]  out_data
);

   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  received_esc;
   wire escape_char, idle_char;

   // ---------------------------------------------------------------------
   //| Thingofamagick
   // ---------------------------------------------------------------------

   assign idle_char = (in_data == 8'h4a);
   assign escape_char = (in_data == 8'h4d);

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         received_esc <= 0; 
      end else begin
         if (in_valid & in_ready) begin
            if (escape_char & ~received_esc) begin
                 received_esc <= 1;
            end else if (out_valid) begin
                 received_esc <= 0;
            end
         end
      end
   end

   always @* begin
      in_ready = out_ready;
      //out valid when in_valid.  Except when we get idle or escape
      //however, if we have received an escape character, then we are valid
      out_valid = in_valid & ~idle_char & (received_esc | ~escape_char);
      out_data = received_esc ? (in_data ^ 8'h20) : in_data;
   end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "EpP162onJgJ/r9TODmtfKTHlY3hQkrhrlSXRfesAQCCeI2GiWCOay8pVgGFrgMjo1Tn7dgOokGqz9W5rJN6unSnW1C7t7ZxqCh27BlHhuiJoNk7evpoD1MFDBob6hbQf6UAI5VB9Qj9PXIl3nngESQL+00lxqYdAjHFBzRCAUeyhFI/LiCRu/snLtnCpkZMJsb7sWnqY2DNZ3YMeEklgliK3b+igQEvFkHuCG9WHLHfeQs1efRx9qsZTZBNeTejAWKmq/kVLSUIEX4yf1ngwmbJJSiRKV9aO+sTKULaZ7va/LhDnry4a/d6V2HKpdFp1IsdqE7QSH/7lOvGPzD25zSS3Kw7Y+7xpPifQf5ityVt1mdaXdCQU4IQhbJHHAkM3GGzjTole9Uz/f8ak69ioqaqOYjB41j1FSGICZia4acz/GimxbtUGOOuGeCkieNpJPb/tz2SEF5zqM3ZQaAA8JaXkKUhMAKytkZ4aGW/VjXKEE+krWjrH9LM7l7gVsfp0CafBFSZeVMUSEthZTjsdLMG0P/+1vXo5L/Tqk1uhypwii489USR9duUF6ir9VmhiiGv8r8TFZYZFl5oxtLUyvWug2xq6DhHCvTPaObrIdzHNSbpdzIAP5Exa4h+/a2vd1guSdSno0eqfv51Fozbr//ldsMJPU2yjSCcy1EI74f5lqTFsSnXCg4dQJ1LsWRBQN44zQNETMzgKSTy053wdnbdeQONSqPUgudUZihPQgrWUpR3iN6tOThxgHvlc9Fj8lRtnr4AdMFMBvugnvzqo97SGfJp89bHEuVqzV9jMSY0qGBnhj61604+doHRqt9/DOxqrrPM92JzSwdwR+1St41qpq+LmhXHwI72zVPq8szqc4RxxRGEdmQLH8j+eHD4O2AcqxO301ojga0/E+aOgQHd2fUCEmTvWGA5f8r+A9eaid12cozn5LOE9z0fNp3ZewHY43hIa2gsWDpNvnOnazuWM7vbnCT4SFxfQsxUBihCgIARF4GuhRQvv1LioCF5w"
`endif