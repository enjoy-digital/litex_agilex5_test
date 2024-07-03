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


`ifndef PHY_ARCH_FP_INTERFACE

`define PHY_ARCH_FP_INTERFACE 1

// altera message_off 18455
interface AXI_BUS #(
  parameter int signed PORT_AXI_AXADDR_WIDTH  = 0,
  parameter int signed PORT_AXI_AXID_WIDTH    = 0,
  parameter int signed PORT_AXI_AXBURST_WIDTH = 0,
  parameter int signed PORT_AXI_AXLEN_WIDTH   = 0,
  parameter int signed PORT_AXI_AXSIZE_WIDTH  = 0,
  parameter int signed PORT_AXI_AXUSER_WIDTH  = 0,
  parameter int signed PORT_AXI_DATA_WIDTH    = 0,
  parameter int signed PORT_AXI_STRB_WIDTH    = 0,
  parameter int signed PORT_AXI_RESP_WIDTH    = 0,
  parameter int signed PORT_AXI_ID_WIDTH      = 0,
  parameter int signed PORT_AXI_USER_WIDTH    = 0,
  parameter int signed PORT_AXI_AXQOS_WIDTH   = 0,
  parameter int signed PORT_AXI_AXCACHE_WIDTH = 0,
  parameter int signed PORT_AXI_AXPROT_WIDTH  = 0
);

typedef logic [PORT_AXI_AXADDR_WIDTH-1:0]  addr_t;
typedef logic [PORT_AXI_AXID_WIDTH-1:0]    id_t;
typedef logic [PORT_AXI_AXBURST_WIDTH-1:0] burst_t;
typedef logic [PORT_AXI_AXLEN_WIDTH-1:0]   len_t;
typedef logic [PORT_AXI_AXSIZE_WIDTH-1:0]  size_t;
typedef logic [PORT_AXI_AXUSER_WIDTH-1:0]  user_t;
typedef logic [PORT_AXI_DATA_WIDTH-1:0]    data_t;
typedef logic [PORT_AXI_STRB_WIDTH-1:0]    strb_t;
typedef logic [PORT_AXI_RESP_WIDTH-1:0]    resp_t;
typedef logic [PORT_AXI_ID_WIDTH-1:0]      respid_t;
typedef logic [PORT_AXI_USER_WIDTH-1:0]    respuser_t;
typedef logic [PORT_AXI_AXQOS_WIDTH-1:0]   qos_t;
typedef logic [PORT_AXI_AXCACHE_WIDTH-1:0] cache_t;
typedef logic [PORT_AXI_AXPROT_WIDTH-1:0]  prot_t;

id_t              awid;
addr_t            awaddr;
len_t             awlen;
size_t            awsize;
burst_t           awburst;
logic             awlock;
cache_t           awcache;
prot_t            awprot;
qos_t             awqos;
user_t            awuser;
logic             awvalid;
logic             awready;

data_t            wdata;
strb_t            wstrb;
logic             wlast;
respuser_t        wuser;
logic             wvalid;
logic             wready;

respid_t          bid;
resp_t            bresp;
respuser_t        buser;
logic             bvalid;
logic             bready;

id_t              arid;
addr_t            araddr;
len_t             arlen;
size_t            arsize;
burst_t           arburst;
logic             arlock;
cache_t           arcache;
prot_t            arprot;
qos_t             arqos;
user_t            aruser;
logic             arvalid;
logic             arready;

respid_t          rid;
data_t            rdata;
resp_t            rresp;
logic             rlast;
respuser_t        ruser;
logic             rvalid;
logic             rready;

modport Manager (
   output awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awqos, awuser, awvalid, input awready,
   output wdata, wstrb, wlast, wuser, wvalid, input wready,
   input bid, bresp, buser, bvalid, output bready,
   output arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arqos, aruser, arvalid, input arready,
   input rid, rdata, rresp, rlast, ruser, rvalid, output rready
);

modport Subordinate (
   input awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot, awqos, awuser, awvalid, output awready,
   input wdata, wstrb, wlast, wuser, wvalid, output wready,
   output bid, bresp, buser, bvalid, input bready,
   input arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot, arqos, aruser, arvalid, output arready,
   output rid, rdata, rresp, rlast, ruser, rvalid, input rready
);

endinterface

`endif 
`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "KIHsQL0tn7BsUxBiGtJAtAS6pksHg7tDJRLb6E/4ePx3ERhHTZ1dA6gNXMqWG+CEWUXOGdJkgLCJwkJ8Srhz2gxETnyhomLOh1pNf9WR9PqT6wR34xo7Nti9lq/RJOXdEpTr7VVj2iWC2T2LNF/8wb/dT3TME3lg/sj8FvUrkhzj9+2WhMlavwkUnMqPB+XWy2aSZYD9uwvr/hWprSk9cyHVtAO2aBryJMf64EZmndTMD43HMP/BqOzLrgIHF+4xZOBCe0th0IAOkouqQI2zRj6p0LLlxaNFdN6N8KlTs0GMWPfFbVs7L6thRGGYfxUga9RzzCAvfsgq/bWlHxn1E4+WV2Lw9Q8K/jDYgc7kiK2ESOgNMPBar0HY5P21ssHv4DPiAZKLblozmfrJ+hNxir+iAPhMNqyb3mGIPXDV+rNGiO57EGYjtkeY4hU2XxEaV+2kByP0VVjn7PH7lKYfHdCVdlhpaU4B/rm52/96InUcSu5EDxzh1T1ec3Abw5kY61v5Q/2PvJ+ZQXulL/dYLJpiQiwdh6HgIvX3YOiJjftBfD/b/53CvqWcJWqfGGOE8EE8nrMoc+bDq5Mqca5lSExC7qXMxPHPDn3e9reO/FHY/YSU3yBrEn+EAnkT0VnumrbxN1UYV7E0MQKb0GUDuUXgIJGqqLkCFmU6tOM0tnTiAP0Cba3HNEwQ5+GXujqadyDUXnmNn/hqdV4Xgs5nJ5inaVbKsr8Y1l7vieGabflyCUv08VAzmdZVBsC7hyxoRsoVlq3lvL/9LxdOK30Vz1/1ypotlrhYVuBXM0e2cbWgiRB61mrFhJ2rdmIrXJeYsoZBcaji7HfvAvxrNU7/SlhX2F3RmTi4d0IoA+2x8gep4tq2iXKXlI9iW+3vn2wrgfGGkgrUEr8e5KbxXFAGd+I0791ibsC+k5tfvK6n63Uk1CUf1fdQXgJuVLDg//GZDsWwhOVqHqcISbVwSmDGebggPn1VOnG6S36ajNHbrqJaYIdJNnxgf2hyMh9FBbfU"
`endif