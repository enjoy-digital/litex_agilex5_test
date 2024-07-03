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
//| Avalon ST Idle Inserter 
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_idle_inserter (

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
         if (in_valid & out_ready) begin
            if ((idle_char | escape_char) & ~received_esc & out_ready) begin
                 received_esc <= 1;
            end else begin
                 received_esc <= 0;
            end
         end
      end
   end

   always @* begin
      //we are always valid
      out_valid = 1'b1;
      in_ready = out_ready & (~in_valid | ((~idle_char & ~escape_char) | received_esc));
      out_data = (~in_valid) ? 8'h4a :    //if input is not valid, insert idle
                 (received_esc) ? in_data ^ 8'h20 : //escaped once, send data XOR'd
                 (idle_char | escape_char) ? 8'h4d : //input needs escaping, send escape_char
                 in_data; //send data
   end
endmodule
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "EpP162onJgJ/r9TODmtfKTHlY3hQkrhrlSXRfesAQCCeI2GiWCOay8pVgGFrgMjo1Tn7dgOokGqz9W5rJN6unSnW1C7t7ZxqCh27BlHhuiJoNk7evpoD1MFDBob6hbQf6UAI5VB9Qj9PXIl3nngESQL+00lxqYdAjHFBzRCAUeyhFI/LiCRu/snLtnCpkZMJsb7sWnqY2DNZ3YMeEklgliK3b+igQEvFkHuCG9WHLHf1U5/SiXN2lOSpV7J1wyToG3XpRkWH1HgBUbdsXeo9wDGw/SRARVHGN8oZhCrB8HLBfbkFvjI83Fz0x5rkUzYQM5MooyO7MzEO//Hq1G6SEvH13V1WZvxlY4MCuTld2Lf7/A/I1tmusJBe2KXi+juAKzE75kf/w/1OR+VlN1ayKhaB4FSmj+Nk5BNlWgAAvJBImvzSKNMVqWyrTX6G8PdROvlqcEHrBNNI7SPNd0etDQ64Wb2OX+IVLAWERAu2m/Mbr9XyVKeI4WiraGERuxoMdSLlGyBkJv6+kX8EgjHjYozlfIDvK9C2t5VCvKKvkqG8psAkkWtyVPDtRc8EiyvVKhS8ykn7SyMBnIN1vLhHXm193YmOstg7bXvFXZ3JW+BZeH7pnJ827f/ffj1NSMlG9sbjM7bk15jd7yZ84ZO5MTvBp8m2bJpYbbfd7BIzjzn0WPHXXzIsF3/oj0hUB3Bm+QKAMi9Xg9nP3ywJlctdF3em1i9UqkJzMlkvO67qJhlzMZWxdDhkR0UQQdEqm4XcUmjPM495tbMWc8NTLzuzDZldiFuAU9ghFSMtTKkOYP6Q50TxAkbaejGdWMY+pKFO42WN2id1LWenczKhEWNwZJZg685FPm8gm8OP1LGLzN2JvTIpkfPM9PLOk4meJ1dbRKK2ssc9qUD+www1qp+BzU2OGLzZKYGdMYOoLVg5UleMTO2zkDf0ryDqnJBdHvWeew+LN/8gntTiRL/KtSx/ZPkVB8eJNOaqnY+WNI4DgxedN5tZEtufukgyz80jz0aJ"
`endif