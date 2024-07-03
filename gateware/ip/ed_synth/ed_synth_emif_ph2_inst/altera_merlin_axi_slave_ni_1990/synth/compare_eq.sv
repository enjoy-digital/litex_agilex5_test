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

module compare_eq #(
    parameter WIDTH=10
) (
    input [WIDTH-1:0]  in_a,
    input [WIDTH-1:0]  in_b,
    output             equal
);

assign equal = (in_a==in_b);

endmodule 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "GdrtC8041f37ha52Ko+Jde808iDyKA+ht5m5AuKQCsm3cRPQscDvF+wBgbawWOxUtCRI9a/tnC6AChwO+BxfmEV2UK9ncMFAL//YMEMfhylNbbg+DkYNRltJ3oLac/x0CKLYUz0kP213IDPHPJdDrn2XWjqkg2d8WjL/DUsL13IJgiL6ltB1LI/UYnSBUYY+yK6OwicfHT3EuyorZ8lWql/zzL2Fl1behLT6A47M1qidy7wiZQZm+R+IsSMTvVKlDhAuzy/4Q87N6Qww/XRmG+iXYCOMUZw5CUx76XSBIVN6D+G4iFvT0vRyj7Do9Fs+3eEcPXAPsXLFM2gqhFJRoabgMGZzmiO0eStdSYkbiJewUvg6mLwMFwjwZfCnLiOYUVHaRkkG3muD8qZKpEAWoc74y7v0AnM3fet+ApjutL3M8mHhFKMPSea4zLb4LThlWUfUGJpw/AxC2/7idu0qbI8x53AJfeut4AeEIZSdXEzAJXBGbSJHa6TsR+OhrtLIZMUpifGtXVoPXQCT0ZW/HG+71yNMeC8gVi5wLr8hwojYQogdbv18vnATi+VB4x7zcM4LWFxm6m54vLqIhR8eBTEDvaAmEEawdUoNAuusLc1McJxa6atgmq1Y1Ja7b7EPzUrdjps1PvyCffTAlj00c2BUBLjTLbd7KZyyZy1DXBf9PJ9Rb4cyp6GDjQhMpKo6Os+E9ExwYb9mmM0IODaTCuuh/yhY5QJjeW/MJKIwzE0UtPWSgvjYIvmqD9hg/Ga054ZPeVGlWhz2pDZbh8uLBwSlJmItoresV3Yc1VHVxepmL5wiyefrXqVI/JbynaOb2CNaEyeAbqy3HbRuD3xRDretrZF8hZNV1AXqoxVtfkW4m/svVD7OsCg/miSCtRmGumn0q4IRNRPH0IzVVKLGz6EtY2h/Q5QyzVNq3HfBZYSfSExdi6alYelzec6C7JR5SnRGtoHNv3OqPQQP5t4x+i61ETjjaNDBFW6BoT873P7cTbalGbzV8MT2XZ8Zz2VJ"
`endif