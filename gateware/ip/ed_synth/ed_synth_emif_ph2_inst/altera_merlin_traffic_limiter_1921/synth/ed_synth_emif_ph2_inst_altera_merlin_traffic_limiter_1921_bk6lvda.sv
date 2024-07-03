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


// -----------------------------------------------------
// Merlin Traffic Limiter
//
// Ensures that non-posted transaction responses are returned 
// in order of request. Out-of-order responses can happen 
// when a master does a non-posted transaction on a slave 
// while responses are pending from a different slave.
//
// Examples:
//   1) read to any latent slave, followed by a read to a 
//      variable-latent slave
//   2) read to any fixed-latency slave, followed by a read 
//      to another fixed-latency slave whose fixed latency is smaller.
//   3) non-posted write to any latent slave, followed by a non-posted
//      write or read to any variable-latent slave.
//
// This component has two implementation modes that ensure
// response order, controlled by the REORDER parameter.
// 
//   0) Backpressure to prevent a master from switching slaves 
//   until all outstanding responses have returned. We also 
//   have to suppress the non-posted transaction, obviously.
//
//   1) Reorder the responses as they return using a memory
//   block.
// -----------------------------------------------------

`timescale 1 ns / 1 ns

// altera message_off 10036
module ed_synth_emif_ph2_inst_altera_merlin_traffic_limiter_1921_bk6lvda
#(
   parameter
      PKT_TRANS_POSTED           = 1,
      PKT_DEST_ID_H              = 0,
      PKT_DEST_ID_L              = 0,
      PKT_SRC_ID_H               = 0,
      PKT_SRC_ID_L               = 0,
      PKT_BYTE_CNT_H             = 0,
      PKT_BYTE_CNT_L             = 0,
      PKT_BYTEEN_H               = 0,
      PKT_BYTEEN_L               = 0,
      PKT_TRANS_WRITE            = 0,
      PKT_TRANS_READ             = 0,
      PKT_THREAD_ID_H            = 0,
      PKT_THREAD_ID_L            = 0,
      PKT_TRANS_SEQ_H            = 0,
      PKT_TRANS_SEQ_L            = 0,
      ST_DATA_W                  = 72,
      ST_CHANNEL_W               = 32,

      MAX_OUTSTANDING_RESPONSES  = 1,
      PIPELINED                  = 0,
      ENFORCE_ORDER              = 1,
      SYNC_RESET                 = 0,
      // -------------------------------------
      // internal: allows optimization between this
      // component and the demux
      // -------------------------------------
      VALID_WIDTH                = 1,

      // -------------------------------------
      // Prevents all RAW and WAR hazards by waiting for 
      // responses to return before issuing a command 
      // with different direction.
      //
      // This is intended for Avalon masters which are 
      // connected to AXI slaves, because of the differing
      // ordering models for the protocols.
      //
      // If PREVENT_HAZARDS is 1, then the current implementation
      // needs to know whether incoming writes will be posted or
      // not at compile-time. Only one of SUPPORTS_POSTED_WRITES
      // and SUPPORTS_NONPOSTED_WRITES can be 1.
      //
      // When PREVENT_HAZARDS is 0 there is no such restriction.
      //
      // It is possible to be less restrictive for memories.
      // -------------------------------------
      PREVENT_HAZARDS            = 0,

      // -------------------------------------
      // Used only when hazard prevention is on, but may be used
      // for optimization work in the future.
      // -------------------------------------
      SUPPORTS_POSTED_WRITES     = 1,
      SUPPORTS_NONPOSTED_WRITES  = 0,

      // -------------------------------------------------
      // Enables the reorder buffer which allows a master to 
      // switch slaves while responses are pending.
      // Reponses will be reordered following command issue order.
      // -------------------------------------------------
      REORDER                    = 0,
      // For OOO responses reordering can be done with or without using FIFO
      // For REORDER using FIFO further optimization needs to be 
      // Also going forward there will be 2 flavors of REORDER under OOO (sw controlled)
      // As of now default functionality is REORDER without using FIFO
      USE_FIFO                   = 0,
      // -------------------------------------------------
      // Enables concurrent subordinate access - a master to 
      // do not backpressure on dest_id change when set to 1
      // will need reordering buffer in most cases
      // -------------------------------------------------
      ENABLE_CONCURRENT_SUBORDINATE_ACCESS = 0,
      ENABLE_OOO = 0,
      // -------------------------------------------------
      // optimization for AXI - if pending IDs are not repeated
      // across subordniates, no reoderig buffer required
      // send responses back in whatever order they arrive
      // -------------------------------------------------
      NO_REPEATED_IDS_BETWEEN_SUBORDINATES = 0
)
(
   // -------------------
   // Clock & Reset
   // -------------------
   input clk,
   input reset,

   // -------------------
   // Command
   // -------------------
   input                            cmd_sink_valid,
   input [ST_DATA_W-1 : 0]          cmd_sink_data,
   input [ST_CHANNEL_W-1 : 0]       cmd_sink_channel,
   input                            cmd_sink_startofpacket,
   input                            cmd_sink_endofpacket,
   output                           cmd_sink_ready,

   output reg [VALID_WIDTH-1  : 0]  cmd_src_valid,
   output reg [ST_DATA_W-1    : 0]  cmd_src_data,
   output reg [ST_CHANNEL_W-1 : 0]  cmd_src_channel,
   output reg                       cmd_src_startofpacket,
   output reg                       cmd_src_endofpacket,
   input                            cmd_src_ready,

   // -------------------
   // Response
   // -------------------
   input                            rsp_sink_valid,
   input [ST_DATA_W-1 : 0]          rsp_sink_data,
   input [ST_CHANNEL_W-1 : 0]       rsp_sink_channel,
   input                            rsp_sink_startofpacket,
   input                            rsp_sink_endofpacket,
   output reg                       rsp_sink_ready,

   output reg                       rsp_src_valid,
   output reg [ST_DATA_W-1 : 0]     rsp_src_data,
   output reg [ST_CHANNEL_W-1 : 0]  rsp_src_channel,
   output reg                       rsp_src_startofpacket,
   output reg                       rsp_src_endofpacket,
   input                            rsp_src_ready
);

   // -------------------------------------
   // Local Parameters
   // -------------------------------------
   localparam DEST_ID_W = PKT_DEST_ID_H - PKT_DEST_ID_L + 1;
   localparam COUNTER_W = log2ceil(MAX_OUTSTANDING_RESPONSES + 1);
   localparam PAYLOAD_W = ST_DATA_W + ST_CHANNEL_W + 4;
   localparam NUMSYMBOLS = PKT_BYTEEN_H - PKT_BYTEEN_L + 1;
   localparam MAX_DEST_ID = 1 << (DEST_ID_W);
   localparam PKT_BYTE_CNT_W = PKT_BYTE_CNT_H - PKT_BYTE_CNT_L + 1;
   
   // -------------------------------------------------------
   // Memory Parameters
   // ------------------------------------------------------
   localparam MAX_BYTE_CNT = 1 << (PKT_BYTE_CNT_W);
   localparam MAX_BURST_LENGTH = log2ceil(MAX_BYTE_CNT/NUMSYMBOLS);

   // Memory stores packet width, including sop and eop
   localparam MEM_W = ST_DATA_W + ST_CHANNEL_W + 1 + 1;
   localparam MEM_DEPTH = MAX_OUTSTANDING_RESPONSES * (MAX_BYTE_CNT/NUMSYMBOLS);
   
   localparam SCAN_COUNT_W = 2;
   
   // -----------------------------------------------------
   // Input Stage
   //
   // Figure out if the destination id has changed
   // -----------------------------------------------------
   wire                    stage1_dest_changed;
   wire                    stage1_trans_changed;
   wire [PAYLOAD_W-1 : 0]  stage1_payload;
   wire                    in_nonposted_cmd;
   reg [ST_CHANNEL_W-1:0]  last_channel;
   wire [DEST_ID_W-1 : 0]  dest_id;
   reg [DEST_ID_W-1 : 0]   last_dest_id;
   reg                     was_write;
   wire                    is_write;
   wire                    suppress;
   wire                    save_dest_id;

   wire                    suppress_change_dest_id;
   wire                    suppress_max_outstanding;
   wire                    suppress_max_reorder_depth;
   wire                    suppress_change_trans_but_not_dest;
   wire                    suppress_change_trans_for_one_slave;
  
   generate if (PREVENT_HAZARDS == 1) begin : convert_posted_to_nonposted_block
      assign in_nonposted_cmd = 1'b1;
   end else begin : non_posted_cmd_assignment_block
      assign in_nonposted_cmd = (cmd_sink_data[PKT_TRANS_POSTED] == 0);
   end
   endgenerate

   // ------------------------------------
   // Optimization: for the unpipelined case, we can save the destid if
   // this is an unsuppressed nonposted command. This eliminates
   // dependence on the backpressure signal.
   //
   // Not a problem for the pipelined case.
   // ------------------------------------
   generate
      if (PIPELINED) begin : pipelined_save_dest_id
         assign save_dest_id = cmd_sink_valid & cmd_sink_ready & in_nonposted_cmd;
      end else begin : unpipelined_save_dest_id
         assign save_dest_id = cmd_sink_valid & ~(suppress_change_dest_id | suppress_max_outstanding) & in_nonposted_cmd;
      end
   endgenerate

  // Generating synchronous reset
  reg internal_sclr;
   generate if (SYNC_RESET == 1) begin : rst_syncronizer
      always @ (posedge clk) begin
         internal_sclr <= reset;
      end
   end
   endgenerate

  generate
  if (SYNC_RESET == 0) begin : async_reg0
     always @(posedge clk, posedge reset) begin
        if (reset) begin
           last_dest_id   <= 0;
           last_channel   <= 0;
           was_write      <= 0;
        end
        else if (save_dest_id) begin
           last_dest_id   <= dest_id;
           last_channel   <= cmd_sink_channel;
           was_write      <= is_write;
        end
     end
  end // async_reg0
  else begin // sync_reg0

    always @(posedge clk) begin
        if (internal_sclr) begin
           last_dest_id   <= 0;
           last_channel   <= 0;
           was_write      <= 0;
        end
        else if (save_dest_id) begin
           last_dest_id   <= dest_id;
           last_channel   <= cmd_sink_channel;
           was_write      <= is_write;
        end
     end
  end // sync_reg0
  endgenerate

   assign dest_id = cmd_sink_data[PKT_DEST_ID_H:PKT_DEST_ID_L];
   assign is_write = cmd_sink_data[PKT_TRANS_WRITE];
   // do not backpressure/supress commands when dest_id changes for concurrent access
   assign stage1_dest_changed = (NO_REPEATED_IDS_BETWEEN_SUBORDINATES && ENABLE_CONCURRENT_SUBORDINATE_ACCESS) ? 1'b0 : (last_dest_id != dest_id);
   assign stage1_trans_changed = (was_write != is_write);

   assign stage1_payload = {
      cmd_sink_data, 
      cmd_sink_channel,
      cmd_sink_startofpacket,
      cmd_sink_endofpacket,
      stage1_dest_changed,
      stage1_trans_changed };
      
   // -----------------------------------------------------
   // (Optional) pipeline between input and output
   // -----------------------------------------------------
   wire                    stage2_valid;
   reg                     stage2_ready;
   wire [PAYLOAD_W-1 : 0]  stage2_payload;
   
   generate
      if (PIPELINED == 1) begin : pipelined_limiter
         altera_avalon_st_pipeline_base
         #(
            .BITS_PER_SYMBOL(PAYLOAD_W)
         ) stage1_pipe (
            .clk        (clk),
            .reset      (reset),
            .in_ready   (cmd_sink_ready),
            .in_valid   (cmd_sink_valid),
            .in_data    (stage1_payload),
            .out_valid  (stage2_valid),
            .out_ready  (stage2_ready),
            .out_data   (stage2_payload)
         );
      end else begin : unpipelined_limiter
         assign stage2_valid   = cmd_sink_valid;
         assign stage2_payload = stage1_payload;
         assign cmd_sink_ready = stage2_ready;
      end
   endgenerate

   // -----------------------------------------------------
   // Output Stage
   // -----------------------------------------------------
   wire [ST_DATA_W-1 : 0]  stage2_data;
   wire [ST_CHANNEL_W-1:0] stage2_channel;
   wire                    stage2_startofpacket;
   wire                    stage2_endofpacket;
   wire                    stage2_dest_changed;               
   wire                    stage2_trans_changed;               
   reg                     has_pending_responses;
   reg [COUNTER_W-1 : 0]   pending_response_count;
   reg [COUNTER_W-1 : 0]   next_pending_response_count;
   wire                    nonposted_cmd;
   wire                    nonposted_cmd_accepted;
   wire                    response_accepted;
   wire                    response_sink_accepted;
   wire                    response_src_accepted;
   wire                    count_is_1;
   wire                    count_is_0;
   reg                     internal_valid;
   wire [VALID_WIDTH-1:0]  wide_valid;

   assign { stage2_data, 
      stage2_channel,
      stage2_startofpacket,
      stage2_endofpacket,
      stage2_dest_changed,
      stage2_trans_changed } = stage2_payload;

   generate if (PREVENT_HAZARDS == 1) begin : stage2_nonposted_block
      assign nonposted_cmd = 1'b1;
   end else begin
      assign nonposted_cmd = (stage2_data[PKT_TRANS_POSTED] == 0);
   end
   endgenerate

   assign nonposted_cmd_accepted = nonposted_cmd && internal_valid && (cmd_src_ready && cmd_src_endofpacket);

   // -----------------------------------------------------------------------------
   // Use the sink's control signals here, because write responses may be dropped
   // when hazard prevention is on.
   //
   // When case REORDER, move all side to rsp_source as all packets from rsp_sink will 
   // go in the reorder memory.
   // One special case when PREVENT_HAZARD is on, need to use reorder_memory_valid
   // as the rsp_source will drop
   // -----------------------------------------------------------------------------
   
   assign response_sink_accepted = rsp_sink_valid && rsp_sink_ready && rsp_sink_endofpacket;
   // Avoid Qis warning when incase, no REORDER, the signal reorder_mem_valid is not in used.
   wire   reorder_mem_out_valid;
   wire   reorder_mem_valid;
   

   generate 
      if (REORDER) begin
         assign reorder_mem_out_valid = reorder_mem_valid;
      end else begin
         assign reorder_mem_out_valid = '0;
      end
   endgenerate

   assign response_src_accepted = reorder_mem_out_valid & rsp_src_ready & rsp_src_endofpacket;
   assign response_accepted = (REORDER == 1) ? response_src_accepted : response_sink_accepted;
   
   always @* begin
      next_pending_response_count = pending_response_count;

      if (nonposted_cmd_accepted)
         next_pending_response_count = pending_response_count + 1'b1;
      if (response_accepted)
         next_pending_response_count = pending_response_count - 1'b1;
      if (nonposted_cmd_accepted && response_accepted)
         next_pending_response_count = pending_response_count;
   end

   assign count_is_1 = (pending_response_count == 1);
   assign count_is_0 = (pending_response_count == 0);
   // ------------------------------------------------------------------
   // count_max_reached : count if maximum command reach to backpressure
   // ------------------------------------------------------------------
   reg count_max_reached;
   generate
   if (SYNC_RESET == 0) begin : async_reg1
      always @(posedge clk, posedge reset) begin
         if (reset) begin
            pending_response_count <= 0;
            has_pending_responses <= 0;
            count_max_reached     <= 0;
         end
         else begin
            pending_response_count <= next_pending_response_count;
            // synthesis translate_off
            if (count_is_0 && response_accepted) 
               $display("%t: %m: Error: unexpected response: pending_response_count underflow", $time());
            // synthesis translate_on
            has_pending_responses <= has_pending_responses 
               && ~(count_is_1 && response_accepted && ~nonposted_cmd_accepted)
               || (count_is_0 && nonposted_cmd_accepted && ~response_accepted);
               count_max_reached <= (next_pending_response_count == MAX_OUTSTANDING_RESPONSES);
            
         end
      end
   end //async_reg1

   else begin //sync_reg1
     always @(posedge clk) begin
         if (internal_sclr) begin
            pending_response_count <= 0;
            has_pending_responses <= 0;
            count_max_reached     <= 0;
         end
         else begin
            pending_response_count <= next_pending_response_count;
            // synthesis translate_off
            if (count_is_0 && response_accepted) 
               $display("%t: %m: Error: unexpected response: pending_response_count underflow", $time());
            // synthesis translate_on
            has_pending_responses <= has_pending_responses 
               && ~(count_is_1 && response_accepted && ~nonposted_cmd_accepted)
               || (count_is_0 && nonposted_cmd_accepted && ~response_accepted);
               count_max_reached <= (next_pending_response_count == MAX_OUTSTANDING_RESPONSES);
            
         end
     end
   end //sync_reg1
   endgenerate


   wire suppress_prevent_harzard_for_particular_destid;
   wire this_destid_trans_changed;
   genvar j;
   generate
     if (REORDER) begin: fifo_dest_id_write_read_control_reorder_on
       wire [COUNTER_W -1: 0] rsp_sequence;
       wire [COUNTER_W - 1: 0]    trans_sequence_rsp;
       reg [COUNTER_W - 1:0] trans_sequence;
       reg [COUNTER_W - 1 : 0] expect_trans_sequence;
       reg ptr_busy;
       reg  [COUNTER_W - 1:0]  read_ptr;
       reg  [MAX_OUTSTANDING_RESPONSES-1:0] meta_data_busy;
       wire   reorder_mem_valid_p0;
       wire   reorder_mem_valid_p1;
       reg  [MEM_W - 1 : 0] reorder_mem_out_data;
       wire [MEM_W-1:0] reorder_mem_out_data_p0;
       wire [MEM_W-1:0] reorder_mem_out_data_p1;
       wire   rsp_src_ready_p1;
       // -------------------------------------
       // Control Memory for reorder responses 
       // -------------------------------------
       wire [ST_DATA_W - 1 : 0]        reorder_mem_data;
       wire [ST_CHANNEL_W - 1 : 0]      reorder_mem_channel;
       wire                       reorder_mem_startofpacket;
       wire                       reorder_mem_endofpacket;
       wire                       reorder_mem_ready;
       // -------------------------------------------
       // Data to write and read from reorder memory
       // Store everything includes channel, sop, eop
       // -------------------------------------------
       reg  [MEM_W - 1 : 0]       mem_in_rsp_sink_data;
       always_comb
       begin
          mem_in_rsp_sink_data = {rsp_sink_data, rsp_sink_channel, rsp_sink_startofpacket, rsp_sink_endofpacket};
       end
   
       if (ENABLE_OOO == 1) begin
         assign rsp_sequence = rsp_sink_data[PKT_TRANS_SEQ_L + COUNTER_W -1 :PKT_TRANS_SEQ_L];    
         assign trans_sequence_rsp = '0;    
         assign suppress_prevent_harzard_for_particular_destid = 1'b0;
            always_comb begin
              if (reorder_mem_valid && rsp_src_ready && reorder_mem_out_data[0]) begin
                ptr_busy  = 1'b0;
              end
              else begin 
                ptr_busy  = 1'b1;
              end
            end    
       end
       else begin
         assign rsp_sequence = '0;    
         always_comb begin
           ptr_busy  = 1'b0;
         end
       end
  
       if (ENABLE_OOO == 0 | USE_FIFO == 0) begin : REORDER_WITHOUT_FIFO_OR_INORDER_RSP
         wire [COUNTER_W - 1 : 0]    current_trans_seq_of_this_destid;
         wire [MAX_DEST_ID - 1 : 0]  current_trans_seq_of_this_destid_valid;
         
         
         wire [COUNTER_W : 0]        trans_sequence_plus_trans_type;
         wire                        current_trans_type_of_this_destid;
         wire [COUNTER_W : 0]        current_trans_seq_of_this_destid_plus_trans_type [MAX_DEST_ID];
         // ------------------------------------------------------------
         // Control write trans_sequence to fifos
         //
         // 1. when command accepted, read destid from command packet, 
         //     write this id to the fifo (each fifo for each desitid)  
         // 2. when response acepted, read the destid from response packet,
         //     will know which sequence of this response, write it to
         //     correct segment in memory.
         //     what if two commands go to same slave, the two sequences
         //     go time same fifo, this even helps us to maintain order
         //     when two commands same thread to one slave.
         // -----------------------------------------------------------
         wire [DEST_ID_W - 1 : 0]   rsp_sink_dest_id; 
         wire [DEST_ID_W - 1 : 0]   cmd_dest_id;

         assign rsp_sink_dest_id = rsp_sink_data[PKT_SRC_ID_H : PKT_SRC_ID_L];
         // write in fifo the trans_sequence and type of transaction
         assign trans_sequence_plus_trans_type = {stage2_data[PKT_TRANS_WRITE], trans_sequence};

         // read the cmd_dest_id from output of pipeline stage so that either
         // or not, it wont affect how we write to fifo
         assign cmd_dest_id = stage2_data[PKT_DEST_ID_H : PKT_DEST_ID_L];
         

         // -------------------------------------
         // Control Memory for reorder responses 
         // -------------------------------------
         wire [COUNTER_W - 1 : 0] next_rd_trans_sequence;
         reg [COUNTER_W - 1 : 0] rd_trans_sequence;
         reg [COUNTER_W - 1 : 0] next_expected_trans_sequence;
   
         assign next_rd_trans_sequence = ((rd_trans_sequence + 1'b1) == MAX_OUTSTANDING_RESPONSES) ? '0 : rd_trans_sequence + 1'b1;
         assign next_expected_trans_sequence = ((expect_trans_sequence + 1'b1) == MAX_OUTSTANDING_RESPONSES) ? '0 : expect_trans_sequence + 1'b1;
        
         if (SYNC_RESET == 0) begin : async_reg3   
           always_ff @(posedge clk, posedge reset) begin
                 if (reset) begin
                    rd_trans_sequence    <= '0;
                    expect_trans_sequence <= '0;
                 end 
                 else begin
                    if (rsp_src_ready && reorder_mem_valid) begin
                       if (reorder_mem_endofpacket == 1) begin //endofpacket
                          expect_trans_sequence <= next_expected_trans_sequence;
                          rd_trans_sequence    <= next_rd_trans_sequence;
                       end
                    end
                 end
           end // always_ff @
         end // async_reg3

         else begin //sync_reg3
            always_ff @(posedge clk) begin
                 if (internal_sclr) begin
                    rd_trans_sequence    <= '0;
                    expect_trans_sequence <= '0;
                 end else begin
                    if (rsp_src_ready && reorder_mem_valid) begin
                       if (reorder_mem_endofpacket == 1) begin //endofpacket
                          expect_trans_sequence <= next_expected_trans_sequence;
                          rd_trans_sequence    <= next_rd_trans_sequence;
                       end
                    end
                 end
            end // always_ff @
         end //sync_reg3

              
         if (ENABLE_OOO == 0) begin : REORDER_for_in_order_rsp
     
           wire [MAX_DEST_ID - 1 : 0]  trans_sequence_we;
           wire [MAX_DEST_ID - 1 : 0]  responses_arrived;
   
           // -------------------------------------
           // Get the transaction_seq for that dest_id
           // -------------------------------------
           wire [COUNTER_W : 0]       trans_sequence_rsp_plus_trans_type;
           wire [COUNTER_W - 1: 0]    trans_sequence_rsp_this_destid_waiting;
           wire [COUNTER_W : 0]       sequence_and_trans_type_this_destid_waiting;
           wire                         trans_sequence_rsp_this_destid_waiting_valid;
 
           assign trans_sequence_rsp_plus_trans_type = current_trans_seq_of_this_destid_plus_trans_type[rsp_sink_dest_id];
           assign trans_sequence_rsp                 = trans_sequence_rsp_plus_trans_type[COUNTER_W - 1: 0];
          
           // do I need to check if this fifo is valid, it should be always valid, unless a command not yet sent
           // and response comes back which means something weird happens.
           // It is worth to do an assertion but now to avoid QIS warning, just do as normal ST handshaking
           // check valid and ready
 
           for (j = 0; j < MAX_DEST_ID; j = j+1) 
           begin : write_and_read_trans_sequence
              assign trans_sequence_we[j] = (cmd_dest_id == j) && nonposted_cmd_accepted;
              assign responses_arrived[j] = (rsp_sink_dest_id == j) && response_sink_accepted;
           end
   
           // --------------------------------------------------------------------
           // This is array of fifos, which will be created base on how many slaves
           // that this master can see (max dest_id_width)
           // Each fifo, will store the trans_sequence, which go to that slave
           // On the response path, based in the response from which slave
           // the fifo of that slave will be read, to check the sequences.
           // and this sequence is the write address to the memory
           // -----------------------------------------------------------------------------------
           // There are 3 sequences run around the limiter, they have a relationship
           // And this is how the key point of reorder work:
           // 
           // trans_sequence      : command sequence, each command go thru the limiter
           //                   will have a sequence to show their order. A simple 
           //                   counter from 0 go up and repeat.      
           // trans_sequence_rsp   : response sequence, each response that go back to limiter,
           //                   will be read from trans_fifos to know their sequence.
           // expect_trans_sequence : Expected sequences for response that the master is waiting
           //                   The limiter will hold this sequence and wait until exactly response
           //                   for this sequence come back (trans_sequence_rsp)
           //                   aka: if trans_sequence_rsp back is same as expect_trans_sequence
           //                   then it is correct order, else response store in memory and
           //                   send out to master later, when expect_trans_sequence match.
           // ------------------------------------------------------------------------------------
           for (j = 0;j < MAX_DEST_ID; j = j+1) begin : trans_sequence_per_fifo
           //altera_avalon_sc_fifo 
           ed_synth_emif_ph2_inst_altera_merlin_traffic_limiter_altera_avalon_sc_fifo_1921_fbfpikq #(
                 .SYMBOLS_PER_BEAT   (1),
                 .BITS_PER_SYMBOL    (COUNTER_W + 1), // one bit extra to store type of transaction
                 .FIFO_DEPTH         (MAX_OUTSTANDING_RESPONSES),
                 .CHANNEL_WIDTH      (0),
                 .ERROR_WIDTH        (0),
                 .USE_PACKETS        (0),
                 .USE_FILL_LEVEL     (0),
                 .EMPTY_LATENCY      (1),
                 .USE_MEMORY_BLOCKS  (0),
                 .USE_STORE_FORWARD  (0),
                 .USE_ALMOST_FULL_IF (0),
                 .USE_ALMOST_EMPTY_IF (0),
                 .SYNC_RESET          (SYNC_RESET)
                 ) dest_id_fifo 
               (
                .clk            (clk),
                .reset          (reset),
                .in_data         (trans_sequence_plus_trans_type),
                .in_valid        (trans_sequence_we[j]),
                .in_ready        (),     
                .out_data        (current_trans_seq_of_this_destid_plus_trans_type[j]),
                .out_valid       (current_trans_seq_of_this_destid_valid[j]),
                .out_ready       (responses_arrived[j])
                 );

           end // block: trans_sequence_per_fifo
        
           // For PREVENT_HAZARD, 
           // Case: Master Write to S0, read S1, and Read S0 back but if Write for S0
           // not yet return then we need to backpressure this, else read S0 might take over write 
           // This is more checking after the fifo destid, as read S1 is inserted in midle
           // when see new packet, try to look at the fifo for that slave id, check if it
           // type of transaction
           assign sequence_and_trans_type_this_destid_waiting = current_trans_seq_of_this_destid_plus_trans_type[cmd_dest_id];
           assign current_trans_type_of_this_destid = sequence_and_trans_type_this_destid_waiting[COUNTER_W];
           assign trans_sequence_rsp_this_destid_waiting_valid = current_trans_seq_of_this_destid_valid[cmd_dest_id];
           // it might waiting other sequence, check if different type of transaction as only for PREVENT HAZARD
           // if comming comamnd to one slave and this slave is still waiting for response from previous command
           // which has diiferent type of transaction, we back-pressure this command to avoid HAZARD
           assign suppress_prevent_harzard_for_particular_destid = (current_trans_type_of_this_destid != is_write) & trans_sequence_rsp_this_destid_waiting_valid;
       
           // meta_data_busy is used to know if a TRANS_SEQ is available to be assigned a new command or not 
           always@(posedge clk ) begin
             meta_data_busy <= '0;
           end
         end // block: REORDER_for_in_order_rsp
         else begin : REORDER_WITHOUT_FIFO
   
           if (SYNC_RESET == 0) begin
             always@(posedge clk or posedge reset) begin
               if(reset) begin
                 meta_data_busy <= '0;
               end
               else begin
                 if(nonposted_cmd_accepted) begin 
                   meta_data_busy[trans_sequence] <= 1'b1;
                 end
                 if(~ptr_busy) begin
                   meta_data_busy[expect_trans_sequence ] <= 1'b0;
                 end
               end
             end //always_@
           end  //if async_reset
           else begin
             always@(posedge clk) begin
               if(internal_sclr) begin
                 meta_data_busy <= '0;
               end
               else begin
                 if(nonposted_cmd_accepted) begin 
                   meta_data_busy[trans_sequence] <= 1'b1;
                 end
                 if(~ptr_busy) begin
                   meta_data_busy[expect_trans_sequence ] <= 1'b0;
                 end
               end
             end //always_@
           end //if sync_reset
         end //block: REORDER_WITHOUT_FIFO
         // -------------------------------------------------------
         // Calculate the transaction sequence, just simple increase
         // when each commands pass by
         // --------------------------------------------------------
         if (SYNC_RESET == 0) begin:async_reg2
           always @(posedge clk or posedge reset) 
              begin
                 if (reset) begin
                    trans_sequence   <= '0;
                 end else begin
                    if (nonposted_cmd_accepted) 
                       trans_sequence <= ( (trans_sequence + 1'b1) == MAX_OUTSTANDING_RESPONSES) ? '0 : trans_sequence + 1'b1;
                 end
              end
         end // async_reg2
         else begin //sync_reg2

           always @(posedge clk) 
              begin
                 if (internal_sclr) begin
                    trans_sequence   <= '0;
                 end else begin
                    if (nonposted_cmd_accepted) 
                       trans_sequence <= ( (trans_sequence + 1'b1) == MAX_OUTSTANDING_RESPONSES) ? '0 : trans_sequence + 1'b1;
                 end
              end
         end // sync_reg2
 
         assign reorder_mem_valid = reorder_mem_valid_p0;
         assign reorder_mem_out_data = reorder_mem_out_data_p0;

         assign reorder_mem_valid_p1  = 1'b0;
         assign rsp_src_ready_p1 = 1'b0;
         assign reorder_mem_out_data_p1 = '0;
       end // block: REORDER_WITHOUT_FIFO_OR_INORDER_RSP

       else if (ENABLE_OOO == 1 && USE_FIFO == 1) begin: OOO_REORDER_USING_FIFO
         wire [MAX_OUTSTANDING_RESPONSES-1:0] read_ptr_fifo_valid;
         reg  [MAX_OUTSTANDING_RESPONSES-1:0] fifo_valid;
         reg  [COUNTER_W-1:0]    fifo_num;
         reg  read_ptr_valid;
         reg  [COUNTER_W:0]      fifo_mem[MAX_OUTSTANDING_RESPONSES-1 : 0];
         reg  [COUNTER_W-1:0]    read_out_fifo;
         reg  [COUNTER_W-1:0]    write_in_fifo;
         reg  [COUNTER_W-1:0]    mem_count[MAX_OUTSTANDING_RESPONSES-1 : 0];
         reg  [COUNTER_W-1 : 0]  fifo_sel;
         reg  [COUNTER_W : 0]    fifo_match;
         reg  [COUNTER_W-1:0]    read_ptr_fifo_data[MAX_OUTSTANDING_RESPONSES-1 : 0];
         wire wptr_eq_rptr;
         wire read_next_ptr;
         reg hold_pointer;
         wire [PKT_THREAD_ID_H-PKT_THREAD_ID_L:0]cmd_id;
         wire [PKT_THREAD_ID_H-PKT_THREAD_ID_L:0]rsp_id;
         reg read_fifo;
         reg [SCAN_COUNT_W-1:0] fifo_cycle_count;
         reg [COUNTER_W-1 :0]pointer_count;
         wire [COUNTER_W-1 :0]pointer_data_in;
         wire pointer_valid_in;
         wire pointer_ready;
         reg default_write_done;
 
         assign cmd_id =  cmd_sink_data[PKT_THREAD_ID_H:PKT_THREAD_ID_L];
         assign rsp_id =  rsp_sink_data[PKT_THREAD_ID_H:PKT_THREAD_ID_L];
          
         /*
           Following code infers 
                1. array of registers 
                2. 2-input Priority MUX where inputs ae from comparator value from array of register and POINTER_FIFO_0 and output going as valid signal to the FIFOs storing TRANS_SEQ 
         */ 
         always_comb begin
           for(integer i=0; i <MAX_OUTSTANDING_RESPONSES; i = i+1) begin
             if(fifo_mem[i][COUNTER_W] == 1'b1) begin
               fifo_valid[i]= 1'b1;
             end
             else begin 
               fifo_valid[i]= 1'b0;
             end
           end //for
          
           for(integer i=0; i <MAX_OUTSTANDING_RESPONSES; i = i+1) begin
             if(cmd_sink_valid &&cmd_sink_ready &&cmd_sink_data[PKT_THREAD_ID_H:PKT_THREAD_ID_L] == fifo_mem[i][COUNTER_W-1:0]) begin
               fifo_match = i + 1'b1;
             end
           end //for
            
           if (fifo_match ==  0) begin
             for(integer  i = MAX_OUTSTANDING_RESPONSES ; i >0; i=i-1) begin
               if(~fifo_valid[i-1]) begin
                 fifo_sel = i-1;
               end
             end
           end
           else begin
             fifo_sel = fifo_match - 1'b1;
             fifo_match = 1'b0;
           end
         end //always_comb
            
         for(j= MAX_OUTSTANDING_RESPONSES;j > 0 ;j=j-1) begin : FIFO_MEM_COUNT
           if(SYNC_RESET == 0) begin
             always@(posedge clk) begin
               if(internal_sclr) begin
                 mem_count[j-1] <= 'b0;
               end
               else begin
                 if(cmd_sink_valid && cmd_sink_ready && (fifo_sel == j-1)) begin
                   mem_count[j-1] <= mem_count[j-1] + 1'b1;
                 end
                 else if(read_next_ptr && read_ptr_fifo_valid[j-1] && (fifo_num == j-1)) begin
                   mem_count[j-1] <= mem_count[j-1] ? mem_count[j-1] - 1'b1 : '0;
                 end
               end
             end //awlays@
           end //async_reset
           else begin
             always@(posedge clk or posedge reset) begin
               if(reset) begin
                 mem_count[j-1] <= '0;
               end
               else begin
                 if(cmd_sink_valid && cmd_sink_ready && (fifo_sel == j-1)) begin
                   mem_count[j-1] <= mem_count[j-1] + 1'b1;
                 end
                 else if(read_next_ptr && read_ptr_fifo_valid[j-1] && (fifo_num == j-1)) begin
                   mem_count[j-1] <= mem_count[j-1] ? mem_count[j-1] - 1'b1 : '0;
                 end
               end
             end //aways@
           end//sync_reset
         end //FIFO_MEM_COUNT

         for(j= MAX_OUTSTANDING_RESPONSES;j > 0 ;j=j-1) begin : FIFO_RD_WR
           always@(posedge clk) begin
             if(cmd_sink_valid && cmd_sink_ready && (fifo_sel == j-1)) begin
               write_in_fifo <= j-1;
             end
             if(read_next_ptr && read_ptr_fifo_valid[j-1] && (fifo_num == j-1)) begin
               read_out_fifo <= j-1;
             end
           end
         end//FIFO_WR_RD
         
         for(j= MAX_OUTSTANDING_RESPONSES;j > 0 ;j=j-1) begin : FIFO_MEM_DATA
           always@(posedge clk) begin
             if(mem_count[j-1] == 0)  begin
               fifo_mem[j-1][COUNTER_W] <= '0;
             end
             else if(cmd_sink_valid && cmd_sink_ready && fifo_sel == j-1) begin
               fifo_mem[j-1] <= {1'b1, cmd_sink_data[PKT_THREAD_ID_H:PKT_THREAD_ID_L]}; 
             end
           end
         end//FIFO_MEM_DATA
        //-------------------------------------------------------------------------//
        
         assign read_next_ptr = (~ptr_busy && rsp_src_ready && reorder_mem_valid) ? reorder_mem_endofpacket : 1'b0; 
         for(j=0 ; j<MAX_OUTSTANDING_RESPONSES; j=j+1) 
         begin :multi_fifo
               assign read_ptr_fifo_valid[j] = 1'b0;
               assign read_ptr_fifo_data[j] = '0;
         end
         if (SYNC_RESET == 1) begin //sync_reset   
           always@(posedge clk) begin
             if (internal_sclr) begin
               read_fifo <= 1'b0;
             end
             else begin
               if (rsp_src_valid && rsp_src_ready && rsp_src_startofpacket && ~rsp_src_endofpacket) begin
                 read_fifo <= 1'b1;
               end
               else if (rsp_src_valid && rsp_src_ready && rsp_src_endofpacket) begin
                 read_fifo <= 1'b0;
               end
             end
           end
           always@(posedge clk) begin
             if(internal_sclr) begin
               fifo_num <= 2'b0;
               fifo_cycle_count <= 2'b1;
             end
             else begin
              fifo_cycle_count <= (~read_fifo) ? fifo_cycle_count + 1 : fifo_cycle_count;
              if(rsp_src_valid && rsp_src_ready && rsp_src_endofpacket) begin
                fifo_num <= fifo_num == MAX_OUTSTANDING_RESPONSES-1 ? '0 :  fifo_num + 1'b1;
                fifo_cycle_count <= 2'b1;
              end
              else if(fifo_cycle_count == 2'b0 && ~wptr_eq_rptr && ~read_fifo && ~hold_pointer) begin
                fifo_num <= fifo_num == MAX_OUTSTANDING_RESPONSES-1 ? '0 :  fifo_num + 1'b1;
              end
             end
           end
         end //sync_reset
         else begin //async_reset 
           always@(posedge clk or posedge reset) begin
             if (reset) begin
               read_fifo <= 1'b0;
             end
             else begin
               if (rsp_src_valid && rsp_src_ready && rsp_src_startofpacket && ~rsp_src_endofpacket) begin
                 read_fifo <= 1'b1;
               end
               else if (rsp_src_valid && rsp_src_ready && ~rsp_src_startofpacket && rsp_src_endofpacket) begin
                 read_fifo <= 1'b0;
               end
               else if (rsp_src_valid && rsp_src_ready && rsp_src_startofpacket && rsp_src_endofpacket) begin
                 read_fifo <= 1'b0;
               end
             end
           end //always@
           always@(posedge clk or posedge reset) begin
             if(reset) begin
               fifo_num <= 2'b0;
               fifo_cycle_count <= 2'b1;
             end
             else begin
               fifo_cycle_count <= (~read_fifo) ? fifo_cycle_count + 2'b1 : fifo_cycle_count;
               if(rsp_src_valid && rsp_src_ready && rsp_src_endofpacket) begin
                 fifo_num <= fifo_num == MAX_OUTSTANDING_RESPONSES-1 ? '0 :  fifo_num + 1'b1;
                 fifo_cycle_count <= 2'b1;
               end
               else if(fifo_cycle_count == 2'b0 && ~wptr_eq_rptr && ~read_fifo && ~hold_pointer) begin
                 fifo_num <= fifo_num == MAX_OUTSTANDING_RESPONSES-1 ? '0  :  fifo_num + 1'b1;
               end
             end
           end //always@
         end   //async_reset
         //-------------------------------------------------------------------//

         always@(posedge clk) begin
            if(nonposted_cmd_accepted) begin
              meta_data_busy[trans_sequence] <= 1'b1;
            end
            if(~ptr_busy && read_ptr_valid) begin
              meta_data_busy[read_ptr] <= 1'b0;
            end
         end
        
         
         assign wptr_eq_rptr = ((read_ptr == rsp_sequence) && read_ptr_valid) ? 1'b1 : 1'b0;
         

         always_comb begin
           for(integer i=MAX_OUTSTANDING_RESPONSES ; i>0; i =i-1) begin
             if(fifo_num == i-1 && read_ptr_fifo_valid[i-1]) begin
               read_ptr = read_ptr_fifo_data[i-1];
             end  
           end
           read_ptr_valid = |read_ptr_fifo_valid;
         end 

         altera_avalon_st_pipeline_base # (
                      .SYMBOLS_PER_BEAT       (1),
                      .BITS_PER_SYMBOL        (MEM_W),
                      .PIPELINE_READY         (1),
                      .SYNC_RESET             (SYNC_RESET)
                   ) ROM_single_stage_pipeline (
       
                     .clk                    (clk),
                     .reset                  (reset),
                     .in_ready               (rsp_src_ready_p1),
                     .in_valid               (reorder_mem_valid_p0),
                     .in_data                (reorder_mem_out_data_p0),
                     .out_ready              (rsp_src_ready),
                     .out_valid              (reorder_mem_valid_p1),
                     .out_data               (reorder_mem_out_data_p1)
                     );
       
       
         always_comb begin
           if (rsp_src_ready_p1 && reorder_mem_valid_p0 && reorder_mem_out_data_p0[1]) begin     // SOP or packet_chunk 
             hold_pointer = 1'b1;
           end
           else if (rsp_src_ready && reorder_mem_valid_p1 && reorder_mem_out_data_p1[0] )  begin   // EOP or single_burst
             hold_pointer = 1'b0;
           end
         end
          
          
         if (SYNC_RESET == 0) begin:async_reg2
           always @(posedge clk or posedge reset) begin
             if(reset)begin
               pointer_count      <= '0;
               default_write_done <= 1'b0;
             end
             else begin
               if((pointer_count < MAX_OUTSTANDING_RESPONSES) && default_write_done == 0 )begin
                 pointer_count <= pointer_count + 1'b1;
               end
               else begin
                 default_write_done <= 1'b1;
               end
             end
           end //always@
         end //block:async_reset
         else begin
           always @(posedge clk) begin
             if(internal_sclr)begin
               pointer_count      <= '0;
               default_write_done <= 1'b0;
             end
             else begin
               if((pointer_count < MAX_OUTSTANDING_RESPONSES) && default_write_done == 0 && pointer_ready )begin
                 pointer_count <= pointer_count + 1'b1;
               end
               else begin
                 default_write_done <= 1'b1;
               end
             end
           end // always@
         end //sync_reset
          
          
         assign pointer_data_in = (default_write_done && read_ptr_valid) ? read_ptr : pointer_count;
         assign pointer_valid_in =(rsp_src_valid && rsp_src_ready && rsp_src_endofpacket) | (~default_write_done); 
          
   assign pointer_ready = 1'b0;
   assign trans_sequence = '0;

         assign reorder_mem_valid = reorder_mem_valid_p1;
         assign reorder_mem_out_data = reorder_mem_out_data_p1;

       end //block:OOO_REORDER_USING_FIFO
        
        
       // -------------------------------------
       // Memory for reorder buffer
       // -------------------------------------
         altera_merlin_reorder_memory 
            #(
              .DATA_W     (MEM_W),
              .ADDR_H_W   (COUNTER_W),
              .ADDR_L_W   (MAX_BURST_LENGTH),
              .NUM_SEGMENT (MAX_OUTSTANDING_RESPONSES),
              .DEPTH      (MEM_DEPTH),
              .SYNC_RESET (SYNC_RESET),
              .USE_FIFO   (USE_FIFO)
              ) reorder_memory 
               (
                .clk          (clk),
                .reset        (reset),              
                .in_data      (mem_in_rsp_sink_data),
                .in_valid     (rsp_sink_valid),
                .in_ready     (reorder_mem_ready),
                .out_data     (reorder_mem_out_data_p0),
                .out_valid    (reorder_mem_valid_p0),              
                .out_ready    ((USE_FIFO == 0) ? rsp_src_ready : rsp_src_ready_p1),              
                .wr_segment   ((~NO_REPEATED_IDS_BETWEEN_SUBORDINATES && ENABLE_CONCURRENT_SUBORDINATE_ACCESS && ENABLE_OOO)? rsp_sequence : trans_sequence_rsp),
                .rd_segment   ((USE_FIFO == 0) ? expect_trans_sequence : read_ptr)        // For REORDER without FIFO rd_segment is a simple incremental counter. In case of REORDER using FIFO rd_segment gets the rd_pointer from the FIFOs     
                );
         // -------------------------------------
         // Output from reorder buffer
         // -------------------------------------
       assign reorder_mem_data = reorder_mem_out_data[MEM_W -1 : ST_CHANNEL_W + 2];
       assign reorder_mem_channel = reorder_mem_out_data[ST_CHANNEL_W + 2 - 1 : 2];
       assign reorder_mem_startofpacket = reorder_mem_out_data[1];
       assign reorder_mem_endofpacket = reorder_mem_out_data[0];
       assign suppress_max_reorder_depth = (~NO_REPEATED_IDS_BETWEEN_SUBORDINATES && ENABLE_CONCURRENT_SUBORDINATE_ACCESS && ENABLE_OOO) ? ((meta_data_busy[trans_sequence ] == 1'b1) ? 1'b1 : 1'b0) : 1'b0 ;

       // -------------------------------------
       // Because use generate statment
       // so move all rsp_src_xxx controls here
       // -------------------------------------
       always_comb begin
          cmd_src_data            = stage2_data;
          if(~NO_REPEATED_IDS_BETWEEN_SUBORDINATES && ENABLE_CONCURRENT_SUBORDINATE_ACCESS && ENABLE_OOO) begin
           cmd_src_data[PKT_TRANS_SEQ_L + COUNTER_W - 1:PKT_TRANS_SEQ_L] = trans_sequence; 
          end
          rsp_src_valid           = reorder_mem_valid;
          rsp_src_data            = reorder_mem_data;
          rsp_src_channel         = reorder_mem_channel;
          rsp_src_startofpacket   = reorder_mem_startofpacket;
          rsp_src_endofpacket     = reorder_mem_endofpacket;
          // -------------------------------------
          // Forces commands to be non-posted if hazard prevention
          // is on, also drops write responses
          // -------------------------------------
          rsp_sink_ready       = reorder_mem_ready; // now it takes ready signal from the memory not direct from master
          if (PREVENT_HAZARDS == 1) begin
             cmd_src_data[PKT_TRANS_POSTED] = 1'b0;
             
             if (rsp_src_data[PKT_TRANS_WRITE] == 1'b1 && SUPPORTS_POSTED_WRITES == 1 && SUPPORTS_NONPOSTED_WRITES == 0) begin
                rsp_src_valid = 1'b0;
                rsp_sink_ready = 1'b1;
             end
          end
       end // always_comb

    end // block: fifo_dest_id_write_read_control_reorder_on
   endgenerate
   
   // -------------------------------------
   // Pass-through command and response
   // -------------------------------------

   always_comb 
      begin
         cmd_src_channel         = stage2_channel;
         cmd_src_startofpacket   = stage2_startofpacket;
         cmd_src_endofpacket     = stage2_endofpacket;
      end // always_comb
   
   // -------------------------------------
   // When there is no REORDER requirement
   // Just pass through signals
   // -------------------------------------
   generate
      if (!REORDER) begin : use_selector_or_pass_thru_rsp
         always_comb begin
            cmd_src_data            = stage2_data;
            // pass thru almost signals
            rsp_src_valid           = rsp_sink_valid;
            rsp_src_data            = rsp_sink_data;
            rsp_src_channel         = rsp_sink_channel;
            rsp_src_startofpacket   = rsp_sink_startofpacket;
            rsp_src_endofpacket     = rsp_sink_endofpacket;
            // -------------------------------------
            // Forces commands to be non-posted if hazard prevention
            // is on, also drops write responses
            // -------------------------------------
            rsp_sink_ready = rsp_src_ready; // take care this, should check memory empty
            if (PREVENT_HAZARDS == 1) begin
               cmd_src_data[PKT_TRANS_POSTED] = 1'b0;

               if (rsp_sink_data[PKT_TRANS_WRITE] == 1'b1 && SUPPORTS_POSTED_WRITES == 1 && SUPPORTS_NONPOSTED_WRITES == 0) begin
                  rsp_src_valid = 1'b0;
                  rsp_sink_ready = 1'b1;
               end
            end
         end // always_comb
     end // if (!REORDER)
   endgenerate

   // --------------------------------------------------------
   // Backpressure & Suppression
   // --------------------------------------------------------
   // ENFORCE_ORDER: unused option, always is 1, remove it
   // Now the limiter will suppress when max_outstanding reach
   // --------------------------------------------------------
   generate
      if (ENFORCE_ORDER) begin : enforce_order_block
         assign suppress_change_dest_id = (REORDER == 1) ? 1'b0 : nonposted_cmd && has_pending_responses && 
                                   (stage2_dest_changed || (PREVENT_HAZARDS == 1 && stage2_trans_changed));
      end else begin : no_order_block
         assign suppress_change_dest_id = 1'b0;
      end
   endgenerate

   // ------------------------------------------------------------
   // Even we allow change slave while still have pending responses
   // But one special case, when PREVENT_HAZARD=1, we still allow
   // switch slave while type of transaction change (RAW, WAR) but
   // only to different slaves.
   // if to same slave, we still need back pressure that to make
   // sure no racing
   // ------------------------------------------------------------

   generate
      if (REORDER) begin : prevent_hazard_block
         assign suppress_change_trans_but_not_dest = nonposted_cmd && has_pending_responses && 
                                          !stage2_dest_changed && (PREVENT_HAZARDS == 1 && stage2_trans_changed);
      end else begin : no_hazard_block
         assign suppress_change_trans_but_not_dest = 1'b0; // no REORDER, the suppress_changes_destid take care of this.
      end
   endgenerate
   
   generate
      if (REORDER) begin : prevent_hazard_block_for_particular_slave
         assign suppress_change_trans_for_one_slave = nonposted_cmd && has_pending_responses && (PREVENT_HAZARDS == 1 && suppress_prevent_harzard_for_particular_destid);
      end else begin : no_hazard_block_for_particular_slave
         assign suppress_change_trans_for_one_slave = 1'b0; // no REORDER, the suppress_changes_destid take care of this.
      end
   endgenerate
   
   // ------------------------------------------
   // Backpressure when max outstanding transactions are reached
   // ------------------------------------------
   generate
      if (REORDER) begin : max_outstanding_block
         assign suppress_max_outstanding = count_max_reached;
      end else begin
         assign suppress_max_outstanding = 1'b0;
      end
   endgenerate

   generate 
      if(REORDER)
      assign suppress = suppress_change_trans_for_one_slave | suppress_change_dest_id | suppress_max_outstanding | suppress_max_reorder_depth;
      else
      assign suppress = suppress_change_trans_for_one_slave | suppress_change_dest_id | suppress_max_outstanding;
   endgenerate
   assign wide_valid = { VALID_WIDTH {stage2_valid} } & stage2_channel;

   always @* begin
      stage2_ready = cmd_src_ready;
      internal_valid = stage2_valid;
      // --------------------------------------------------------
      // change suppress condidtion, in case REODER it will alllow changing slave
      // even still have pending transactions.
      // -------------------------------------------------------
      if (suppress) begin
         stage2_ready = 0;
         internal_valid = 0;
      end

      if (VALID_WIDTH == 1) begin
         cmd_src_valid = {VALID_WIDTH{1'b0}};
         cmd_src_valid[0] = internal_valid;
      end else begin
         // -------------------------------------
         // Use the one-hot channel to determine if the destination
         // has changed. This results in a wide valid bus
         // -------------------------------------
         cmd_src_valid = wide_valid;
         if (nonposted_cmd & has_pending_responses) begin
            if (!REORDER) begin
                if (NO_REPEATED_IDS_BETWEEN_SUBORDINATES && ENABLE_CONCURRENT_SUBORDINATE_ACCESS)
                    cmd_src_valid = wide_valid ;
                else
                    cmd_src_valid = wide_valid & last_channel;
               // -------------------------------------
               // Mask the valid signals if the transaction type has changed
               // if hazard prevention is enabled
               // -------------------------------------
               if (PREVENT_HAZARDS == 1)
                  cmd_src_valid = wide_valid & last_channel & { VALID_WIDTH {!stage2_trans_changed} };
            end else begin // else: !if(!REORDER) if REORDER happen
               if (PREVENT_HAZARDS == 1)
                  cmd_src_valid = wide_valid & { VALID_WIDTH {!suppress_change_trans_for_one_slave} };
               if (suppress_max_outstanding | suppress_max_reorder_depth) begin
                  cmd_src_valid = {VALID_WIDTH {1'b0}};
               end

            end 
         end
      end
   end
   
   // --------------------------------------------------
   // Calculates the log2ceil of the input value.
   //
   // This function occurs a lot... please refactor.
   // --------------------------------------------------
   function integer log2ceil;
      input integer val;
      integer i;

      begin
         i = 1;
         log2ceil = 0;

         while (i < val) begin
            log2ceil = log2ceil + 1;
            i = i << 1;
         end
      end
   endfunction

endmodule



