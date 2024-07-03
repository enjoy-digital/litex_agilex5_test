# (C) 2001-2024 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# (C) 2001-2020 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# (C) 2001-2020 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# (C) 2001-2018 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


#------------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Altera timing constraints for Avalon clock domain crossing (CDC) paths.
# The purpose of these constraints is to remove the false paths and replace with timing bounded 
# requirements for compilation.
#
# ***Important note *** 
#
# The clocks involved in this transfer must be kept synchronous and no false path
# should be set on these paths for these constraints to apply correctly.
# -----------------------------------------------------------------------------

set crosser_entity "altera_avalon_st_clock_crosser:"
set_max_delay -from [get_registers *${crosser_entity}*|in_data_buffer* ] -to [get_registers *${crosser_entity}*|out_data_buffer* ] 100
set_min_delay -from [get_registers *${crosser_entity}*|in_data_buffer* ] -to [get_registers *${crosser_entity}*|out_data_buffer* ] -100

set sync_entity "altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:"
set_max_delay -from [get_registers *${crosser_entity}* ] -to [get_registers *${sync_entity}*|din_s1 ] 100
set_min_delay -from [get_registers *${crosser_entity}* ] -to [get_registers *${sync_entity}*|din_s1 ] -100

foreach_in_collection list_of_out_data_buffers [get_registers *${crosser_entity}*|out_data_buffer* ] {
   set regname [get_register_info -name $list_of_out_data_buffers]
   set sync_path [ regsub "(.*)(out_data_buffer)(.*)" $regname "\\1" ]
   set input_data_buffer ""
   append input_data_buffer $sync_path "in_data_buffer*"
   set output_data_buffer ""
   append output_data_buffer $sync_path "out_data_buffer*"
 
    if { $::quartus(nameofexecutable) ne "quartus_syn" && $::quartus(nameofexecutable) ne "quartus_map" } { 
        set_net_delay -from [get_registers $input_data_buffer ] -to [get_registers $output_data_buffer] -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
    }
   set_max_skew  -from [get_registers $input_data_buffer ] -to [get_registers $output_data_buffer] -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8 -nowarn 
}

foreach_in_collection list_in_data_toggle [ get_registers *${crosser_entity}*|in_data_toggle ] { 
   set in_flop [ get_register_info -name $list_in_data_toggle ] 
   # replace last occurence of string
   set in_sync_path [ regsub "(.*)(in_data_toggle)" $in_flop "\\1" ]
   set in_to_out_din_s1 ""
   set in_to_out_sync_din_s1 [ get_registers -nowarn [ append in_to_out_din_s1 $in_sync_path "in_to_out_synchronizer|din_s1" ] ]
   set in_data_toggle ""
   set in_data_toggle_with_path [ get_registers -nowarn [ append in_data_toggle $in_sync_path "in_data_toggle" ] ]
   
   # check for the presence of din_s1 and set the net_delay after that
   if { [ expr { [ llength [ query_collection -report -all $in_to_out_sync_din_s1 ] ] > 0 } ] } {
		if { $::quartus(nameofexecutable) ne "quartus_syn" && $::quartus(nameofexecutable) ne "quartus_map" } {
			set_net_delay -from  $in_data_toggle_with_path -to $in_to_out_sync_din_s1 -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8  
		}
      set_max_skew  -from  $in_data_toggle_with_path -to $in_to_out_sync_din_s1 -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8  -nowarn
   }
} 

foreach_in_collection list_out_data_toggle_flopped_n [ get_registers *${crosser_entity}*|out_data_toggle_flopped_n ] { 
   set out_flop [ get_register_info -name $list_out_data_toggle_flopped_n ] 
   # replace last occurence of string
   set out_sync_path [ regsub "(.*)(out_data_toggle_flopped_n)" $out_flop "\\1" ]
   set out_to_in_din_s1 ""
   set out_to_in_sync_din_s1 [ get_registers -nowarn [ append out_to_in_din_s1 $out_sync_path "out_to_in_synchronizer|din_s1" ] ]
   set out_data_toggle ""
   set out_data_toggle_with_path [ get_registers -nowarn [ append out_data_toggle $out_sync_path "out_data_toggle_flopped_n" ] ]

   # check for the presence of din_s1 and set the net_delay after that
   if { [ expr { [ llength [ query_collection -report -all $out_to_in_sync_din_s1 ] ]  > 0 } ] } { 
		if { $::quartus(nameofexecutable) ne "quartus_syn" && $::quartus(nameofexecutable) ne "quartus_map" } {
			set_net_delay -from $out_data_toggle_with_path -to $out_to_in_sync_din_s1 -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8  
		}
      set_max_skew  -from $out_data_toggle_with_path -to $out_to_in_sync_din_s1 -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8  -nowarn
   }
} 

set aclr_collection_in [get_pins -compatibility_mode -nocase -nowarn *|alt_rst_req_sync_in_rst|altera_reset_synchronizer_int_chain*|aclr]
set clrn_collection_in [get_pins -compatibility_mode -nocase -nowarn *|alt_rst_req_sync_in_rst|altera_reset_synchronizer_int_chain*|clrn]
set aclr_counter_in [get_collection_size $aclr_collection_in]
set clrn_counter_in [get_collection_size $clrn_collection_in]

if {$aclr_counter_in > 0} {
set_false_path -to [get_pins -compatibility_mode -nocase *|alt_rst_req_sync_in_rst|altera_reset_synchronizer_int_chain*|aclr]
}

if {$clrn_counter_in > 0} {
set_false_path -to [get_pins -compatibility_mode -nocase *|alt_rst_req_sync_in_rst|altera_reset_synchronizer_int_chain*|clrn]
}


set aclr_collection_out [get_pins -compatibility_mode -nocase -nowarn *|alt_rst_req_sync_out_rst|altera_reset_synchronizer_int_chain*|aclr]
set clrn_collection_out [get_pins -compatibility_mode -nocase -nowarn *|alt_rst_req_sync_out_rst|altera_reset_synchronizer_int_chain*|clrn]
set aclr_counter_out [get_collection_size $aclr_collection_out]
set clrn_counter_out [get_collection_size $clrn_collection_out]

if {$aclr_counter_out > 0} {
set_false_path -to [get_pins -compatibility_mode -nocase *|alt_rst_req_sync_out_rst|altera_reset_synchronizer_int_chain*|aclr]
}

if {$clrn_counter_out > 0} {
set_false_path -to [get_pins -compatibility_mode -nocase *|alt_rst_req_sync_out_rst|altera_reset_synchronizer_int_chain*|clrn]
}





# -----------------------------------------------------------------------------
# This procedure constrains the skew between the token and data bits, and should
# be called from the top level SDC, once per instance of the clock crosser.
#
# The hierarchy path to the handshake clock crosser instance is required as an 
# argument.
#
# In practice, the token and data bits tend to be placed close together, making
# excessive skew less of an issue.
# -----------------------------------------------------------------------------
proc constrain_alt_handshake_clock_crosser_skew { path } {

    set in_regs  [ get_registers $path|*clock_xer|in_data_buffer* ] 
    set out_regs [ get_registers $path|*clock_xer|out_data_buffer* ] 

    set in_regs [ add_to_collection $in_regs  [ get_registers $path|*clock_xer|in_data_toggle ] ]
    set out_regs [ add_to_collection $out_regs [ get_registers $path|*clock_xer|in_to_out_synchronizer|din_s1 ] ]

    set_max_skew -from $in_regs -to $out_regs -get_skew_value_from_clock_period dst_clock_period -skew_value_multiplier 0.8
}

