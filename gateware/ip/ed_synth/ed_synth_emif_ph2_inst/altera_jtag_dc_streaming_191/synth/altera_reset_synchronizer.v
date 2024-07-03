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


// $Id: //acds/rel/24.1/ip/iconnect/merlin/altera_reset_controller/altera_reset_synchronizer.v#1 $
// $Revision: #1 $
// $Date: 2024/02/01 $

// -----------------------------------------------
// Reset Synchronizer
// -----------------------------------------------
`timescale 1 ns / 1 ns

module altera_reset_synchronizer
#(
    parameter ASYNC_RESET = 1,
    parameter DEPTH       = 2
)
(
    input   reset_in /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R101" */,

    input   clk,
    output  reset_out
);

    // -----------------------------------------------
    // Synchronizer register chain. We cannot reuse the
    // standard synchronizer in this implementation 
    // because our timing constraints are different.
    //
    // Instead of cutting the timing path to the d-input 
    // on the first flop we need to cut the aclr input.
    // 
    // We omit the "preserve" attribute on the final
    // output register, so that the synthesis tool can
    // duplicate it where needed.
    // -----------------------------------------------
    (*preserve*) reg [DEPTH-1:0] altera_reset_synchronizer_int_chain;
    reg altera_reset_synchronizer_int_chain_out;

    generate if (ASYNC_RESET) begin

        // -----------------------------------------------
        // Assert asynchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk or posedge reset_in) begin
            if (reset_in) begin
                altera_reset_synchronizer_int_chain <= {DEPTH{1'b1}};
                altera_reset_synchronizer_int_chain_out <= 1'b1;
            end
            else begin
                altera_reset_synchronizer_int_chain[DEPTH-2:0] <= altera_reset_synchronizer_int_chain[DEPTH-1:1];
                altera_reset_synchronizer_int_chain[DEPTH-1] <= 0;
                altera_reset_synchronizer_int_chain_out <= altera_reset_synchronizer_int_chain[0];
            end
        end

        assign reset_out = altera_reset_synchronizer_int_chain_out;
     
    end else begin

        // -----------------------------------------------
        // Assert synchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk) begin
            altera_reset_synchronizer_int_chain[DEPTH-2:0] <= altera_reset_synchronizer_int_chain[DEPTH-1:1];
            altera_reset_synchronizer_int_chain[DEPTH-1] <= reset_in;
            altera_reset_synchronizer_int_chain_out <= altera_reset_synchronizer_int_chain[0];
        end

        assign reset_out = altera_reset_synchronizer_int_chain_out;
 
    end
    endgenerate

endmodule

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "EpP162onJgJ/r9TODmtfKTHlY3hQkrhrlSXRfesAQCCeI2GiWCOay8pVgGFrgMjo1Tn7dgOokGqz9W5rJN6unSnW1C7t7ZxqCh27BlHhuiJoNk7evpoD1MFDBob6hbQf6UAI5VB9Qj9PXIl3nngESQL+00lxqYdAjHFBzRCAUeyhFI/LiCRu/snLtnCpkZMJsb7sWnqY2DNZ3YMeEklgliK3b+igQEvFkHuCG9WHLHduTjYfHQhjzruz4qp9uBYeLF58LDNgccGihbEpw8jo9PKsJnpDXS3CEb8N0Mk4mxi6YzKuZrxw9uv8AiMJm7nZw9jjmmiuwys4dXTdV1VQMjxYCoDnLleRZnF3wGlSW+Zu06Frm8oYj92/WiZ2yhDNdt4qYqsf0DZC756dZ42SXXPHzgXai6GNdS76UyA0xsdGwn/195OyQU70ei6KT2+1pvdNGXgdCI6PdexSCBew+UDyqvROTGj6N/yQH6YUWaIZmwyaL5aDx+46XLDZhitT7FZ6CoGNzZltYg7UCekaoOsV4yJTkoRqil8+Nh18wajYdTu0Nl3ujIJZbWy7rAH6hWGUKNjKGJgy4OeDd7FGtlytXcokeaTnbj7AjEN1isIgqHlKiDencQhbsK/G/PyyEQnAMHxpwJx0clYmYjrrl6OAX2ZTKbKQWoH4nGNdPpWN+e/ykqoD3hzwvjecUf8YB/wwVMbW8YfSq8bqdb/+hTBhoTXs1embzEFFc+/IxxIVsI8TQNtwLCbejo4O4bGfFvCJFoRXak/WS4xcX/U9oqEmwe46ianXi3I4APS0mkkWZ6Die5wrW1gaJvHl+a2dok9Fv5oOJJTn1m7tZTiF3kz6T2cEAYOgwk8UUrxlHr3EqTOyaFxOsAEIgDeqlz5RZI1F4nhNWsgCsxLTR7lCqbPOMDgUyUCysaZEdFdVildX8QI+2btKG0Npy5umP+ofYoeY9vXTw2l+xV/bPvNWE83Fu5m6dXLbhQGhSjhm4E2iQP/vgOyHdNtLF8N9tvSI"
`endif