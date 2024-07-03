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


`define IBUF_PARAMS(SIG,__pin)                                                                                                                              \
            .bus_hold         (IBUF_BUS_HOLD        [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .io_standard      (IBUF_IO_STANDARD     [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .rzq_id           (IBUF_RZQ_ID          [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .schmitt_trigger  (IBUF_SCHMITT_TRIGGER [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .termination      (IBUF_TERMINATION     [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .usage_mode       (IBUF_USAGE_MODE      [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .vref             (IBUF_VREF            [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .weak_pull_down   (IBUF_WEAK_PULL_DOWN  [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .weak_pull_up     (IBUF_WEAK_PULL_UP    [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .equalization     (IBUF_EQUALIZATION    [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]])

`define IBUF_DIFF_PARAMS(SIG,__pin)                                                                                                                         \
            .bus_hold         (IBUF_DIFF_BUS_HOLD        [(``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``])/2]),          \
            .io_standard      (IBUF_DIFF_IO_STANDARD     [(``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``])/2]),          \
            .rzq_id           (IBUF_DIFF_RZQ_ID          [(``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``])/2]),          \
            .schmitt_trigger  (IBUF_DIFF_SCHMITT_TRIGGER [(``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``])/2]),          \
            .termination      (IBUF_DIFF_TERMINATION     [(``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``])/2]),          \
            .usage_mode       (IBUF_DIFF_USAGE_MODE      [(``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``])/2]),          \
            .vref             (IBUF_DIFF_VREF            [(``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``])/2]),          \
            .weak_pull_down   (IBUF_DIFF_WEAK_PULL_DOWN  [(``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``])/2]),          \
            .weak_pull_up     (IBUF_DIFF_WEAK_PULL_UP    [(``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``])/2]),          \
            .equalization     (IBUF_DIFF_EQUALIZATION    [(``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``])/2])

`define OBUF_PARAMS(SIG,__pin)                                                                                                                              \
            .io_standard       (OBUF_IO_STANDARD    [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .open_drain        (OBUF_OPEN_DRAIN     [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .rzq_id            (OBUF_RZQ_ID         [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .slew_rate         (OBUF_SLEW_RATE      [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .termination       (OBUF_TERMINATION    [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .usage_mode        (OBUF_USAGE_MODE     [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]]),                   \
            .equalization      (OBUF_EQUALIZATION   [``SIG``_LOCATION_BYTE[``__pin``]*NUM_PINS_IN_BYTE+``SIG``_LOCATION_PIN[``__pin``]])


`ifdef EMIF_FIRMWARE_FULLCAL

    `define _ASSIGN_TX(sigwire,padsig) assign sigwire = padsig;
    `define _ASSIGN_RX(sigwire,padsig) assign padsig = sigwire;
    `define _TRAN(sigwire,padsig)      tran(sigwire,padsig);

    `define PADSIG(B,P)  gen_byte_conns[B].wrapper_byte.gen_used_byte.u_byte.io12phy_inst.io_phy_pad_sig[P]

    `define loop(TYPE, ch_idx, SIG, sig)                                                                                                                               \
    generate                                                                                                                                                           \
       for (_pin = 0; ch_idx < MEM_NUM_CHANNELS_PER_IO96 && (_pin+ch_idx*``SIG``_WIDTH) < $size(``SIG``_LOCATION_BYTE) && _pin < ``SIG``_WIDTH; ++_pin) begin : g_``SIG``_bypass_``ch_idx``  \
          `TYPE(``sig``[_pin],`PADSIG(``SIG``_LOCATION_BYTE[_pin+ch_idx*``SIG``_WIDTH],``SIG``_LOCATION_PIN[_pin+ch_idx*``SIG``_WIDTH]))                               \
       end                                                                                                                                                             \
    endgenerate
        
    
    `define out_se(ch_idx, SIG, sig, source)                     \
        `loop(_ASSIGN_TX,ch_idx, SIG, sig)

    `define in_se(ch_idx, SIG, sig, sink)                        \
        `loop(_ASSIGN_RX,ch_idx, SIG, sig)

    `define out_df(ch_idx, SIG, sig_t, sig_c, source)            \
        `loop(_ASSIGN_TX,ch_idx, ``SIG``_T, sig_t)               \
        `loop(_ASSIGN_TX,ch_idx, ``SIG``_C, sig_c)

    `define in_df(ch_idx, SIG, sig_t, sig_c, sink)               \
        `loop(_ASSIGN_RX,ch_idx, ``SIG``_T, sig_t)               \
        `loop(_ASSIGN_RX,ch_idx, ``SIG``_C, sig_c)

    `define bdir_se(ch_idx, SIG, sig, source, sink)              \
        `loop(_TRAN,ch_idx, SIG, sig)

    `define bdir_df(ch_idx, SIG, sig_t, sig_c, source, sink)     \
        `loop(_TRAN,ch_idx, ``SIG``_T, sig_t)                    \
        `loop(_TRAN,ch_idx, ``SIG``_C, sig_c)

`else

    `define out_se(ch_idx, SIG, sig, source)                                                                                                                                 \
       generate                                                                                                                                                              \
          for (_pin = 0; ch_idx < MEM_NUM_CHANNELS_PER_IO96 && (_pin+ch_idx*``SIG``_WIDTH) < $size(``SIG``_LOCATION_BYTE) && _pin < ``SIG``_WIDTH; ++_pin) begin : g_``SIG``_``ch_idx``_out        \
             tennm_ph2_io_obuf # (                                                                                                                                           \
               `OBUF_PARAMS(``SIG``,_pin+ch_idx*``SIG``_WIDTH)                                                                                                               \
             ) obuf (                                                                                                                                                        \
                .i     (``source``_d  [``SIG``_LOCATION_BYTE[_pin+ch_idx*``SIG``_WIDTH]][``SIG``_LOCATION_PIN[_pin+ch_idx*``SIG``_WIDTH]]),                                  \
                .oe    (``source``_doe[``SIG``_LOCATION_BYTE[_pin+ch_idx*``SIG``_WIDTH]][``SIG``_LOCATION_PIN[_pin+ch_idx*``SIG``_WIDTH]]),                                  \
                .o     (``sig``[_pin])                                                                                                                                       \
             );                                                                                                                                                              \
          end                                                                                                                                                                \
       endgenerate
    
    `define in_se(ch_idx, SIG, sig, sink)                                                                                                                                    \
       generate                                                                                                                                                              \
          for (_pin = 0; ch_idx < MEM_NUM_CHANNELS_PER_IO96 && _pin < $size(``SIG``_LOCATION_BYTE) && _pin < ``SIG``_WIDTH; ++_pin) begin : g_``SIG``_``ch_idx``_in         \
             tennm_ph2_io_ibuf # (                                                                                                                                           \
               `IBUF_PARAMS(``SIG``,_pin+ch_idx*``SIG``_WIDTH)                                                                                                               \
             ) ibuf (                                                                                                                                                        \
                .i     (``sig`` [_pin]),                                                                                                                                     \
                .o     (``sink``[``SIG``_LOCATION_BYTE[_pin+ch_idx*``SIG``_WIDTH]][``SIG``_LOCATION_PIN[_pin+ch_idx*``SIG``_WIDTH]])                                         \
             );                                                                                                                                                              \
          end                                                                                                                                                                \
       endgenerate
    
    `define out_df(ch_idx, SIG, sig_t, sig_c, source)             \
       `out_se(ch_idx, ``SIG``_T, sig_t, source)                  \
       `out_se(ch_idx, ``SIG``_C, sig_c, source)

    `define in_df(ch_idx, SIG, sig_t, sig_c, sink)                                                                                                                           \
       generate                                                                                                                                                              \
          for (_pin = 0; ch_idx < MEM_NUM_CHANNELS_PER_IO96 && _pin < $size(``SIG``_T_LOCATION_BYTE) && _pin < ``SIG``_T_WIDTH; ++_pin) begin : g_``SIG``_``ch_idx``_in     \
             tennm_ph2_io_ibuf # (                                                                                                                                           \
               `IBUF_DIFF_PARAMS(``SIG``_T,_pin+ch_idx*``SIG``_T_WIDTH)                                                                                                      \
             ) ibuf (                                                                                                                                                        \
                .i     (``sig_t`` [_pin]),                                                                                                                                   \
                .ibar  (``sig_c`` [_pin]),                                                                                                                                   \
                .o     (``sink``[``SIG``_T_LOCATION_BYTE[_pin+ch_idx*``SIG``_T_WIDTH]][``SIG``_T_LOCATION_PIN[_pin+ch_idx*``SIG``_T_WIDTH]])                                 \
             );                                                                                                                                                              \
          end                                                                                                                                                                \
       endgenerate
    
    `define bdir_se(ch_idx, SIG, sig, source, sink)               \
       `out_se(ch_idx, ``SIG``,``sig``, ``source``)               \
        `in_se(ch_idx, ``SIG``,``sig``, ``sink``)

    `define bdir_df(ch_idx, SIG, sig_t, sig_c, source, sink)      \
       `out_df(ch_idx, ``SIG``,``sig_t``, ``sig_c``, ``source``)  \
        `in_df(ch_idx, ``SIG``,``sig_t``, ``sig_c``, ``sink``)

`endif

(*altera_attribute = {"-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF"} *)
module ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_phy_arch_fp_atom_inst_bufs_mem #(

   localparam NUM_BYTES_IN_IO96        = 8,
   localparam NUM_PINS_IN_BYTE         = 12,
   localparam NUM_IOS                  = NUM_PINS_IN_BYTE * NUM_BYTES_IN_IO96,
   parameter MEM_NUM_CHANNELS_PER_IO96 =  0,
   parameter LOCKSTEP_SECONDARY        =  0,
   parameter MEM_CK_T_WIDTH            =  1,
   parameter MEM_CK_C_WIDTH            =  1,
   parameter MEM_CKE_WIDTH             =  1,
   parameter MEM_ODT_WIDTH             =  1,
   parameter MEM_CS_N_WIDTH            =  1,
   parameter MEM_C_WIDTH               =  0,
   parameter MEM_A_WIDTH               =  17,
   parameter MEM_BA_WIDTH              =  2,
   parameter MEM_BG_WIDTH              =  2,
   parameter MEM_ACT_N_WIDTH           =  1,
   parameter MEM_ALERT_N_WIDTH         =  1,
   parameter MEM_RESET_N_WIDTH         =  1,
   parameter MEM_DQ_WIDTH              =  1,
   parameter MEM_DQS_T_WIDTH           =  1,
   parameter MEM_DQS_C_WIDTH           =  1,
   parameter MEM_DBI_N_WIDTH           =  1,
   parameter MEM_CA_WIDTH              =  1,    
   parameter MEM_DM_N_WIDTH            =  1,    
   parameter MEM_PAR_WIDTH             =  1,    
   parameter MEM_LBD_WIDTH             =  1,    
   parameter MEM_LBS_WIDTH             =  1,    
   parameter MEM_RDQS_T_WIDTH          =  1,    
   parameter MEM_RDQS_C_WIDTH          =  1,    
   parameter MEM_WCK_T_WIDTH           =  1,    
   parameter MEM_WCK_C_WIDTH           =  1,    
   parameter MEM_DMI_WIDTH             =  1,    
   parameter MEM_CS_WIDTH              =  1,    
   parameter OCT_RZQIN_WIDTH                 =  1,

   localparam PORT_IO_PHY_PAD_SIG_WIDTH  = 12,
   localparam PORT_O_PHY_PAD_DOE_WIDTH   = 12,

   localparam INTF_B_TO_BUFFS_WIDTH      = PORT_IO_PHY_PAD_SIG_WIDTH + PORT_O_PHY_PAD_DOE_WIDTH,
   localparam INTF_BUFFS_TO_B_WIDTH      = PORT_IO_PHY_PAD_SIG_WIDTH
) (
   // Ports that connect to the Byte atoms
   output      wire  [NUM_BYTES_IN_IO96-1:0][INTF_BUFFS_TO_B_WIDTH-1:0]    buffs_to_b,
   input       wire  [NUM_BYTES_IN_IO96-1:0][INTF_B_TO_BUFFS_WIDTH-1:0]    b_to_buffs,

   // Ports that connect to the PA atoms
   output      logic [NUM_BYTES_IN_IO96-1:0][INTF_BUFFS_TO_B_WIDTH-1:0]    buffs_to_pa_alert_n,

   input       logic [MEM_LBD_WIDTH-1:0]                              mem_lbd_0,
   input       logic [MEM_LBS_WIDTH-1:0]                              mem_lbs_0,

   output      logic [MEM_CK_T_WIDTH-1:0]                             mem_ck_t_0,
   output      logic [MEM_CK_C_WIDTH-1:0]                             mem_ck_c_0,
   output      logic [MEM_CKE_WIDTH-1:0]                              mem_cke_0,
   output      logic [MEM_ODT_WIDTH-1:0]                              mem_odt_0,
   output      logic [MEM_CS_N_WIDTH-1:0]                             mem_cs_n_0,
   output      logic [MEM_C_WIDTH-1:0]                                mem_c_0,
   output      logic [MEM_A_WIDTH-1:0]                                mem_a_0,
   output      logic [MEM_BA_WIDTH-1:0]                               mem_ba_0,
   output      logic [MEM_BG_WIDTH-1:0]                               mem_bg_0,
   output      logic [MEM_ACT_N_WIDTH-1:0]                            mem_act_n_0,
   output      logic [MEM_PAR_WIDTH-1:0]                              mem_par_0,
   input       logic [MEM_ALERT_N_WIDTH-1:0]                          mem_alert_n_0,
   output      logic [MEM_RESET_N_WIDTH-1:0]                          mem_reset_n_0,
   inout  tri  logic [MEM_DQ_WIDTH-1:0]                               mem_dq_0,
   inout  tri  logic [MEM_DQS_T_WIDTH-1:0]                            mem_dqs_t_0,
   inout  tri  logic [MEM_DQS_C_WIDTH-1:0]                            mem_dqs_c_0,
   inout  tri  logic [MEM_DBI_N_WIDTH-1:0]                            mem_dbi_n_0,
   output      logic [MEM_CA_WIDTH-1:0]                               mem_ca_0,
   output      logic [MEM_DM_N_WIDTH-1:0]                             mem_dm_n_0,
   inout  tri  logic [MEM_RDQS_T_WIDTH-1:0]                           mem_rdqs_t_0,
   inout  tri  logic [MEM_RDQS_C_WIDTH-1:0]                           mem_rdqs_c_0,
   output      logic [MEM_WCK_T_WIDTH-1:0]                            mem_wck_t_0,
   output      logic [MEM_WCK_C_WIDTH-1:0]                            mem_wck_c_0,
   inout  tri  logic [MEM_DMI_WIDTH-1:0]                              mem_dmi_0,
   output      logic [MEM_CS_WIDTH-1:0]                               mem_cs_0,
   input       logic [OCT_RZQIN_WIDTH-1:0]                            oct_rzqin_0,

   output      logic [MEM_CK_T_WIDTH-1:0]                             mem_ck_t_1,
   output      logic [MEM_CK_C_WIDTH-1:0]                             mem_ck_c_1,
   output      logic [MEM_CKE_WIDTH-1:0]                              mem_cke_1,
   output      logic [MEM_ODT_WIDTH-1:0]                              mem_odt_1,
   output      logic [MEM_CS_N_WIDTH-1:0]                             mem_cs_n_1,
   output      logic [MEM_C_WIDTH-1:0]                                mem_c_1,
   output      logic [MEM_A_WIDTH-1:0]                                mem_a_1,
   output      logic [MEM_BA_WIDTH-1:0]                               mem_ba_1,
   output      logic [MEM_BG_WIDTH-1:0]                               mem_bg_1,
   output      logic [MEM_ACT_N_WIDTH-1:0]                            mem_act_n_1,
   output      logic [MEM_PAR_WIDTH-1:0]                              mem_par_1,
   input       logic [MEM_ALERT_N_WIDTH-1:0]                          mem_alert_n_1,
   output      logic [MEM_RESET_N_WIDTH-1:0]                          mem_reset_n_1,
   inout  tri  logic [MEM_DQ_WIDTH-1:0]                               mem_dq_1,
   inout  tri  logic [MEM_DQS_T_WIDTH-1:0]                            mem_dqs_t_1,
   inout  tri  logic [MEM_DQS_C_WIDTH-1:0]                            mem_dqs_c_1,
   inout  tri  logic [MEM_DBI_N_WIDTH-1:0]                            mem_dbi_n_1,
   output      logic [MEM_CA_WIDTH-1:0]                               mem_ca_1,
   output      logic [MEM_DM_N_WIDTH-1:0]                             mem_dm_n_1,
   inout  tri  logic [MEM_RDQS_T_WIDTH-1:0]                           mem_rdqs_t_1,
   inout  tri  logic [MEM_RDQS_C_WIDTH-1:0]                           mem_rdqs_c_1,
   output      logic [MEM_WCK_T_WIDTH-1:0]                            mem_wck_t_1,
   output      logic [MEM_WCK_C_WIDTH-1:0]                            mem_wck_c_1,
   inout  tri  logic [MEM_DMI_WIDTH-1:0]                              mem_dmi_1,
   output      logic [MEM_CS_WIDTH-1:0]                               mem_cs_1,
   input       logic [OCT_RZQIN_WIDTH-1:0]                            oct_rzqin_1
);

   timeunit 1ns;
   timeprecision 1ps;
   localparam CH0_IDX_MUX = LOCKSTEP_SECONDARY ? 1 : 0;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_pin_locations::*;
   import ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_atom_attr_bufs_mem::*;

   // split the b_to_buffs array into two arrays that can be indexed independently
   logic [NUM_BYTES_IN_IO96-1:0][PORT_IO_PHY_PAD_SIG_WIDTH-1:0] b_to_buffs_d;
   logic [NUM_BYTES_IN_IO96-1:0][PORT_O_PHY_PAD_DOE_WIDTH-1:0]  b_to_buffs_doe;


   generate
      genvar _byte;
      for (_byte = 0; _byte < NUM_BYTES_IN_IO96; ++_byte) begin : g_b_to_buffs
         assign {b_to_buffs_d[_byte], b_to_buffs_doe[_byte]} = b_to_buffs[_byte];
      end

   endgenerate


`ifndef EMIF_FIRMWARE_FULLCAL
   `undef BDM_DELAYS
`endif

`ifdef BDM_DELAYS


   `ifdef DDR5
       `define CK_RST_DELAY 50
       `define DQS_DELAY 100
       `define CTRL_DELAY_AMT_MAX 100
       `define DQ_DELAY_AMT_MAX 200
   `elsif DDR4
       `define CK_RST_DELAY 50
       `define DQS_DELAY 100
       `define CTRL_DELAY_AMT_MAX 100
       `define DQ_DELAY_AMT_MAX 200
   `elsif LPDDR4
       `define CK_RST_DELAY 0
       `define DQS_DELAY 0
       `define CTRL_DELAY_AMT_MAX 0
       `define DQ_DELAY_AMT_MAX 0
   `elsif LPDDR5
       `define CK_RST_DELAY 0
       `define DQS_DELAY 0
       `define CTRL_DELAY_AMT_MAX 0
       `define DQ_DELAY_AMT_MAX 0
   `else
       $display("Protocol not specified. Please define protocol in compilation and try again.");
       $stop();
   `endif


   `define DELAY_VAL_RAND(WIRE_NAME, DELAY) \
        delay_amt_mem_``WIRE_NAME``[i] = $urandom_range(0, ``DELAY``); \

   `define DELAY_VAL_FIXED(WIRE_NAME, DELAY) \
        delay_amt_mem_``WIRE_NAME``[i] = ``DELAY``; \

   `define DELAY_UNIDIR(sig, SIG, ch_idx, t_or_c_, T_OR_C_) \
        assign #(1ps * delay_amt_mem_``sig``_``ch_idx``[_del_pin]) mem_``sig``_``t_or_c_````ch_idx``[_del_pin] = mem_``sig``_``t_or_c_````ch_idx``_temp[_del_pin]; \

   /*
   logic a_dly = 'z, b_dly = 'z;
   always@(a) a_dly <= #(1ps * del) b_dly === 'z ? a : 'z;
   always@(b) b_dly <= #(1ps * del) a_dly === 'z ? b : 'z;
   assign b = a_dly, a = b_dly;
   */
   `define MAKE_BIDIR_ASSIGNS(A_WIRE, B_WIRE, A_DLY, B_DLY, DELAY) \
        always@(A_WIRE) A_DLY <= #(1ps * DELAY) B_DLY === 'z ? A_WIRE : 'z; \
        always@(B_WIRE) B_DLY <= #(1ps * DELAY) A_DLY === 'z ? B_WIRE : 'z; \
        assign B_WIRE = A_DLY; \
        assign A_WIRE = B_DLY; \

   `define DELAY_BIDIR(sig, SIG, ch_idx, t_or_c_, T_OR_C_) \
        `MAKE_BIDIR_ASSIGNS(mem_``sig``_``t_or_c_````ch_idx``[_del_pin], gen_byte_conns[MEM_``SIG``_``T_OR_C_``LOCATION_BYTE[_del_pin +``ch_idx`` * MEM_``SIG``_``T_OR_C_``WIDTH]].wrapper_byte.gen_used_byte.u_byte.io12phy_inst.io_phy_pad_sig[MEM_``SIG``_``T_OR_C_``LOCATION_PIN[_del_pin+``ch_idx``*MEM_``SIG``_``T_OR_C_``WIDTH]], mem_``sig``_``t_or_c_````ch_idx``_a_dly[_del_pin], mem_``sig``_``t_or_c_````ch_idx``_b_dly[_del_pin], delay_amt_mem_``sig``_``ch_idx``[_del_pin]) \

   `define LOGIC_SINGLE_ENDED(sig, SIG, ch_idx) \
        localparam WIRE_SIZE_``SIG``_``ch_idx`` = MEM_``SIG``_WIDTH > 0 ? MEM_``SIG``_WIDTH : 1; \
        logic [WIRE_SIZE_``SIG``_``ch_idx``-1:0] mem_``sig``_``ch_idx``_temp; \
        logic [WIRE_SIZE_``SIG``_``ch_idx``-1:0] mem_``sig``_``ch_idx``_a_dly = 'z; \
        logic [WIRE_SIZE_``SIG``_``ch_idx``-1:0] mem_``sig``_``ch_idx``_b_dly = 'z; \

   `define LOGIC_DIFFERENTIAL(sig, SIG, ch_idx) \
        localparam WIRE_SIZE_``SIG``_``ch_idx`` = MEM_``SIG``_T_WIDTH > 0 ? MEM_``SIG``_T_WIDTH : 1; \
        logic [WIRE_SIZE_``SIG``_``ch_idx``-1:0] mem_``sig``_t_``ch_idx``_temp; \
        logic [WIRE_SIZE_``SIG``_``ch_idx``-1:0] mem_``sig``_c_``ch_idx``_temp; \
        logic [WIRE_SIZE_``SIG``_``ch_idx``-1:0] mem_``sig``_t_``ch_idx``_a_dly = 'z; \
        logic [WIRE_SIZE_``SIG``_``ch_idx``-1:0] mem_``sig``_t_``ch_idx``_b_dly = 'z; \
        logic [WIRE_SIZE_``SIG``_``ch_idx``-1:0] mem_``sig``_c_``ch_idx``_a_dly = 'z; \
        logic [WIRE_SIZE_``SIG``_``ch_idx``-1:0] mem_``sig``_c_``ch_idx``_b_dly = 'z; \

   `define GENERATE_SINGLE_ENDED(sig, SIG, ch_idx, WIRE_DRV_TYPE) \
        generate \
            for (_del_pin = 0; ch_idx < MEM_NUM_CHANNELS_PER_IO96 && _del_pin < $size(MEM_``SIG``_LOCATION_BYTE) && _del_pin < MEM_``SIG``_WIDTH; ++_del_pin) begin : g_MEM_``SIG``_del_``ch_idx`` \
                `DELAY_``WIRE_DRV_TYPE``(``sig``, ``SIG``, ``ch_idx``, , ) \
            end \
        endgenerate \

   `define GENERATE_DIFFERENTIAL(sig, SIG, ch_idx, WIRE_DRV_TYPE) \
        generate \
            for (_del_pin = 0; ch_idx < MEM_NUM_CHANNELS_PER_IO96 && _del_pin < $size(MEM_``SIG``_T_LOCATION_BYTE) && _del_pin < MEM_``SIG``_T_WIDTH; ++_del_pin) begin : g_MEM_``SIG``_T_del_``ch_idx`` \
                `DELAY_``WIRE_DRV_TYPE``(``sig``, ``SIG``, ``ch_idx``, t_, T_) \
            end \
            for (_del_pin = 0; ch_idx < MEM_NUM_CHANNELS_PER_IO96 && _del_pin < $size(MEM_``SIG``_C_LOCATION_BYTE) && _del_pin < MEM_``SIG``_C_WIDTH; ++_del_pin) begin : g_MEM_``SIG``_C_del_``ch_idx`` \
                `DELAY_``WIRE_DRV_TYPE``(``sig``, ``SIG``, ``ch_idx``, c_, C_) \
            end \
        endgenerate \

   `define ASSIGN_DELAYS(sig, SIG, ch_idx, DELAY_TYPE, STROBE_TYPE, WIRE_DRV_TYPE, DELAY) \
        `LOGIC_``STROBE_TYPE``(``sig``, ``SIG``, ``ch_idx``) \
        int delay_amt_mem_``sig``_``ch_idx`` [WIRE_SIZE_``SIG``_``ch_idx``]; \
        initial begin \
            for (int i = 0; i < WIRE_SIZE_``SIG``_``ch_idx``; i++) begin \
                `DELAY_VAL_``DELAY_TYPE``(``sig``_``ch_idx``, ``DELAY``) \
                $display("Custom ``DELAY_TYPE`` ``STROBE_TYPE`` ``WIRE_DRV_TYPE`` delay setting: ``SIG``_``ch_idx``[%0d] = %0d", i, delay_amt_mem_``sig``_``ch_idx``[i]);  \
            end \
        end \
        `GENERATE_``STROBE_TYPE``(``sig``, ``SIG``, ``ch_idx``, ``WIRE_DRV_TYPE``) \


   genvar _del_pin;

   `ASSIGN_DELAYS(ck,      CK,      0, FIXED, DIFFERENTIAL, UNIDIR, `CK_RST_DELAY)
   `ASSIGN_DELAYS(ck,      CK,      1, FIXED, DIFFERENTIAL, UNIDIR, `CK_RST_DELAY)
   `ASSIGN_DELAYS(cke,     CKE,     0, FIXED, SINGLE_ENDED, UNIDIR, `CK_RST_DELAY)
   `ASSIGN_DELAYS(cke,     CKE,     1, FIXED, SINGLE_ENDED, UNIDIR, `CK_RST_DELAY)
   `ASSIGN_DELAYS(reset_n, RESET_N, 0, FIXED, SINGLE_ENDED, UNIDIR, `CK_RST_DELAY)
   `ASSIGN_DELAYS(reset_n, RESET_N, 1, FIXED, SINGLE_ENDED, UNIDIR, `CK_RST_DELAY)
   `ASSIGN_DELAYS(cs,      CS,      0, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(cs,      CS,      1, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(cs_n,    CS_N,    0, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(cs_n,    CS_N,    1, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(c,       C,       0, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(c,       C,       1, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(odt,     ODT,     0, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(odt,     ODT,     1, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(ca,      CA,      0, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(ca,      CA,      1, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(a,       A,       0, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(a,       A,       1, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(ba,      BA,      0, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(ba,      BA,      1, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(bg,      BG,      0, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(bg,      BG,      1, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(act_n,   ACT_N,   0, RAND,  SINGLE_ENDED, UNIDIR, `CK_RST_DELAY)
   `ASSIGN_DELAYS(act_n,   ACT_N,   1, RAND,  SINGLE_ENDED, UNIDIR, `CK_RST_DELAY)
   `ASSIGN_DELAYS(par,     PAR,     0, RAND,  SINGLE_ENDED, UNIDIR, `CK_RST_DELAY)
   `ASSIGN_DELAYS(par,     PAR,     1, RAND,  SINGLE_ENDED, UNIDIR, `CK_RST_DELAY)
   `ASSIGN_DELAYS(dm_n,    DM_N,    0, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(dm_n,    DM_N,    1, RAND,  SINGLE_ENDED, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(wck,     WCK,     0, RAND,  DIFFERENTIAL, UNIDIR, `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(wck,     WCK,     1, RAND,  DIFFERENTIAL, UNIDIR, `CTRL_DELAY_AMT_MAX)

   `ASSIGN_DELAYS(dmi,     DMI,     0, RAND,  SINGLE_ENDED, BIDIR,  `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(dmi,     DMI,     1, RAND,  SINGLE_ENDED, BIDIR,  `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(dq,      DQ,      0, RAND,  SINGLE_ENDED, BIDIR,  `DQ_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(dq,      DQ,      1, RAND,  SINGLE_ENDED, BIDIR,  `DQ_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(dbi_n,   DBI_N,   0, RAND,  SINGLE_ENDED, BIDIR,  `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(dbi_n,   DBI_N,   1, RAND,  SINGLE_ENDED, BIDIR,  `CTRL_DELAY_AMT_MAX)
   `ASSIGN_DELAYS(dqs,     DQS,     0, FIXED, DIFFERENTIAL, BIDIR,  `DQS_DELAY)
   `ASSIGN_DELAYS(dqs,     DQS,     1, FIXED, DIFFERENTIAL, BIDIR,  `DQS_DELAY)
   `ASSIGN_DELAYS(rdqs,    RDQS,    0, FIXED, DIFFERENTIAL, BIDIR,  `DQS_DELAY)
   `ASSIGN_DELAYS(rdqs,    RDQS,    1, FIXED, DIFFERENTIAL, BIDIR,  `DQS_DELAY)



   genvar _pin;

   // Channel 0
   `out_df( CH0_IDX_MUX, MEM_CK,      mem_ck_t_0_temp, mem_ck_c_0_temp       , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_CKE,     mem_cke_0_temp                         , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_ODT,     mem_odt_0_temp                         , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_CS_N,    mem_cs_n_0_temp                        , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_C,       mem_c_0                                , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_CA,      mem_ca_0_temp                          , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_A,       mem_a_0_temp                           , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_BA,      mem_ba_0_temp                          , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_BG,      mem_bg_0_temp                          , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_ACT_N,   mem_act_n_0_temp                       , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_PAR,     mem_par_0_temp                         , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_RESET_N, mem_reset_n_0_temp                     , b_to_buffs)
   `out_se( 0,           MEM_DM_N,    mem_dm_n_0_temp                        , b_to_buffs)
   `out_df( CH0_IDX_MUX, MEM_WCK,     mem_wck_t_0_temp, mem_wck_c_0_temp     , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_CS,      mem_cs_0_temp                          , b_to_buffs)
   `in_se(  CH0_IDX_MUX, MEM_ALERT_N, mem_alert_n_0                          , buffs_to_pa_alert_n)
   `in_se(  CH0_IDX_MUX, OCT_RZQIN,   oct_rzqin_0                            , buffs_to_b)

   // MEM_LBS/MEM_LBD
   `in_se(  CH0_IDX_MUX, MEM_LBS,     mem_lbs_0                    , buffs_to_b)
   `in_se(  CH0_IDX_MUX, MEM_LBD,     mem_lbd_0                    , buffs_to_b)

   generate                                                                                 
      for (_pin = 0; _pin < (LOCKSTEP_SECONDARY ? 0 : (MEM_ALERT_N_WIDTH * MEM_NUM_CHANNELS_PER_IO96)); ++_pin) begin
         assign buffs_to_b[MEM_ALERT_N_LOCATION_BYTE[_pin]][MEM_ALERT_N_LOCATION_PIN[_pin]] = buffs_to_pa_alert_n[MEM_ALERT_N_LOCATION_BYTE[_pin]][MEM_ALERT_N_LOCATION_PIN[_pin]];
      end                                                                                   
   endgenerate

   // Channel 1 (optional)
   `out_df( 1, MEM_CK,      mem_ck_t_1_temp, mem_ck_c_1_temp     , b_to_buffs)
   `out_se( 1, MEM_CKE,     mem_cke_1_temp                       , b_to_buffs)
   `out_se( 1, MEM_ODT,     mem_odt_1_temp                       , b_to_buffs)
   `out_se( 1, MEM_CS_N,    mem_cs_n_1_temp                      , b_to_buffs)
   `out_se( 1, MEM_C,       mem_c_1                              , b_to_buffs)
   `out_se( 1, MEM_CA,      mem_ca_1_temp                        , b_to_buffs)
   `out_se( 1, MEM_A,       mem_a_1_temp                         , b_to_buffs)
   `out_se( 1, MEM_BA,      mem_ba_1_temp                        , b_to_buffs)
   `out_se( 1, MEM_BG,      mem_bg_1_temp                        , b_to_buffs)
   `out_se( 1, MEM_ACT_N,   mem_act_n_1_temp                     , b_to_buffs)
   `out_se( 1, MEM_PAR,     mem_par_1_temp                       , b_to_buffs)
   `out_se( 1, MEM_RESET_N, mem_reset_n_1_temp                   , b_to_buffs)
   `out_se( 1, MEM_DM_N,    mem_dm_n_1_temp                      , b_to_buffs)
   `out_df( 1, MEM_WCK,     mem_wck_t_1_temp, mem_wck_c_1_temp   , b_to_buffs)
   `out_se( 1, MEM_CS,      mem_cs_1_temp                        , b_to_buffs)
   `in_se(  1, MEM_ALERT_N, mem_alert_n_1                        , buffs_to_pa_alert_n)
   `in_se(  1, OCT_RZQIN,   oct_rzqin_1                          , buffs_to_b)

`else

   genvar _pin;
   // Channel 0
   `out_df( CH0_IDX_MUX, MEM_CK,      mem_ck_t_0, mem_ck_c_0       , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_CKE,     mem_cke_0                    , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_ODT,     mem_odt_0                    , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_CS_N,    mem_cs_n_0                   , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_C,       mem_c_0                      , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_CA,      mem_ca_0                     , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_A,       mem_a_0                      , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_BA,      mem_ba_0                     , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_BG,      mem_bg_0                     , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_ACT_N,   mem_act_n_0                  , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_PAR,     mem_par_0                    , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_RESET_N, mem_reset_n_0                , b_to_buffs)
   `out_se( 0,           MEM_DM_N,    mem_dm_n_0                   , b_to_buffs)
   `out_df( CH0_IDX_MUX, MEM_WCK,     mem_wck_t_0, mem_wck_c_0     , b_to_buffs)
   `out_se( CH0_IDX_MUX, MEM_CS,      mem_cs_0                     , b_to_buffs)
   `bdir_se(0,           MEM_DMI,     mem_dmi_0                    , b_to_buffs, buffs_to_b)
   `bdir_df(0,           MEM_RDQS,    mem_rdqs_t_0, mem_rdqs_c_0   , b_to_buffs, buffs_to_b)
   `bdir_df(0,           MEM_DQS,     mem_dqs_t_0, mem_dqs_c_0     , b_to_buffs, buffs_to_b)
   `bdir_se(0,           MEM_DQ,      mem_dq_0                     , b_to_buffs, buffs_to_b)
   `bdir_se(0,           MEM_DBI_N,   mem_dbi_n_0                  , b_to_buffs, buffs_to_b)
   `in_se(  CH0_IDX_MUX, MEM_ALERT_N, mem_alert_n_0                , buffs_to_pa_alert_n)
   `in_se(  CH0_IDX_MUX, OCT_RZQIN,   oct_rzqin_0                  , buffs_to_b)

   // MEM_LBS/MEM_LBD
   `in_se(  CH0_IDX_MUX, MEM_LBS,     mem_lbs_0                    , buffs_to_b)
   `in_se(  CH0_IDX_MUX, MEM_LBD,     mem_lbd_0                    , buffs_to_b)

   generate                                                                                 
      for (_pin = 0; _pin < (LOCKSTEP_SECONDARY ? 0 :(MEM_ALERT_N_WIDTH * MEM_NUM_CHANNELS_PER_IO96)); ++_pin) begin : alter_pa
         assign buffs_to_b[MEM_ALERT_N_LOCATION_BYTE[_pin]][MEM_ALERT_N_LOCATION_PIN[_pin]] = buffs_to_pa_alert_n[MEM_ALERT_N_LOCATION_BYTE[_pin]][MEM_ALERT_N_LOCATION_PIN[_pin]];
      end                                                                                   
   endgenerate

   // Channel 1 (optional)
   `out_df( 1, MEM_CK,      mem_ck_t_1, mem_ck_c_1     , b_to_buffs)
   `out_se( 1, MEM_CKE,     mem_cke_1                  , b_to_buffs)
   `out_se( 1, MEM_ODT,     mem_odt_1                  , b_to_buffs)
   `out_se( 1, MEM_CS_N,    mem_cs_n_1                 , b_to_buffs)
   `out_se( 1, MEM_C,       mem_c_1                    , b_to_buffs)
   `out_se( 1, MEM_CA,      mem_ca_1                   , b_to_buffs)
   `out_se( 1, MEM_A,       mem_a_1                    , b_to_buffs)
   `out_se( 1, MEM_BA,      mem_ba_1                   , b_to_buffs)
   `out_se( 1, MEM_BG,      mem_bg_1                   , b_to_buffs)
   `out_se( 1, MEM_ACT_N,   mem_act_n_1                , b_to_buffs)
   `out_se( 1, MEM_PAR,     mem_par_1                  , b_to_buffs)
   `out_se( 1, MEM_RESET_N, mem_reset_n_1              , b_to_buffs)
   `out_se( 1, MEM_DM_N,    mem_dm_n_1                 , b_to_buffs)
   `out_df( 1, MEM_WCK,     mem_wck_t_1, mem_wck_c_1   , b_to_buffs)
   `out_se( 1, MEM_CS,      mem_cs_1                   , b_to_buffs)
   `bdir_se(1, MEM_DMI,     mem_dmi_1                  , b_to_buffs, buffs_to_b)
   `bdir_df(1, MEM_RDQS,    mem_rdqs_t_1, mem_rdqs_c_1 , b_to_buffs, buffs_to_b)
   `bdir_df(1, MEM_DQS,     mem_dqs_t_1, mem_dqs_c_1   , b_to_buffs, buffs_to_b)
   `bdir_se(1, MEM_DQ,      mem_dq_1                   , b_to_buffs, buffs_to_b)
   `bdir_se(1, MEM_DBI_N,   mem_dbi_n_1                , b_to_buffs, buffs_to_b)
   `in_se(  1, MEM_ALERT_N, mem_alert_n_1              , buffs_to_pa_alert_n)
   `in_se(  1, OCT_RZQIN,   oct_rzqin_1                , buffs_to_b)

`endif

endmodule

`undef IBUF_PARAMS
`undef IBUF_DIFF_PARAMS
`undef OBUF_PARAMS
`undef _ASSIGN_TX
`undef _ASSIGN_RX
`undef _TRAN
`undef PAD_SIG
`undef loop
`undef out_se
`undef in_se
`undef out_df
`undef in_df
`undef bdir_se
`undef bdir_df
`undef DELAY_VAL_RAND
`undef ASSIGN_DELAYS
`undef GENERATE_DIFFERENTIAL
`undef GENERATE_SINGLE_ENDED
`undef LOGIC_DIFFERENTIAL
`undef LOGIC_SINGLE_ENDED
`undef DELAY_BIDIR
`undef MAKE_BIDIR_ASSIGNS
`undef DELAY_UNIDIR
`undef DELAY_VAL_FIXED
`undef DELAY_VAL_RAND


