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


#####################################################################
#
# THIS IS AN AUTO-GENERATED FILE!
# -------------------------------
# If you modify this files, all your changes will be lost if you
# regenerate the core!
#
# FILE DESCRIPTION
# ----------------
# This file specifies the timing constraints of the memory device and
# of the memory interface
 
# ------------------------------------------- #
# -                                         - #
# --- Some useful functions and variables --- #
# -                                         - #
# ------------------------------------------- #
 
set script_dir [file dirname [info script]]
source "$script_dir/ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_timing_parameters.tcl"
source "$script_dir/ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_timing_pins.tcl"
 
#--------------------------------------------#
# -                                        - #
# --- Determine when SDC is being loaded --- #
# -                                        - #
#--------------------------------------------#
 
set syn_flow 0
set sta_flow 0
set fit_flow 0
set pow_flow 0
if { $::TimeQuestInfo(nameofexecutable) == "quartus_map" || $::TimeQuestInfo(nameofexecutable) == "quartus_syn" } {
   set syn_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_sta" } {
   set sta_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_fit" } {
   set fit_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_pow" } {
   set pow_flow 1
}
set ::io_only_analysis 0
 
# ------------------------ #
# -                      - #
# --- GENERAL SETTINGS --- #
# -                      - #
# ------------------------ #
 
# This is a global setting and will apply to the whole design.
# This setting is required for the memory interface to be
# properly constrained.
derive_clock_uncertainty
 
# Debug switch. Change to 1 to get more run-time debug information
set debug 0
 
# All timing requirements will be represented in nanoseconds with up to 3 decimal places of precision
set_time_format -unit ns -decimal_places 3
 
# Determine if entity names are on
set entity_names_on [ emif_are_entity_names_on ]
 
# ---------------------- #
# -                    - #
# --- DERIVED TIMING --- #
# -                    - #
# ---------------------- #
 
# PLL multiplier to mem clk
#regexp {([0-9\.]+) ps} $var(PLL_REF_CLK_FREQ_PS_STR) match var(PHY_REF_CLK_FREQ_PS)
set vco_freq [ emif_round_3dp [expr $var(PHY_MEMCLK_FREQ_MHZ)*$var(CLK_DIV_VCO_MEM)]]
set phy_freq [ emif_round_3dp [expr $var(PHY_MEMCLK_FREQ_MHZ)/$var(CLK_DIV_MEM_PHY)]]
set vco_multiplier [emif_round_3dp [expr $vco_freq/$var(PHY_REFCLK_FREQ_MHZ)]]


# Half of memory clock cycle
#set half_period [ emif_round_3dp [ expr $var(UI) / 2.0 ] ]
 
# Half of reference clock
#set ref_period      [ emif_round_3dp [ expr $var(PHY_REF_CLK_FREQ_PS)/1000.0] ]
 
# Other clock periods
#set tCK_AFI     [ emif_round_3dp [ expr 1000.0/$var(PHY_MEM_CLK_FREQ_MHZ)*$var(USER_CLK_RATIO) ] ]
 
# Asymmetric uncertainties on address and command paths
#set ac_min_delay [ emif_round_3dp [ expr - $var(tIH) + $var(CA_TO_CK_BD_PKG_SKEW) ]]
 
# ---------------------- #
# -                    - #
# --- INTERFACE RATE --- #
# -                    - #
# ---------------------- #
 
# -------------------------------------------------------------------- #
# -                                                                  - #
# --- This is the main call to the netlist traversal routines      --- #
# --- that will automatically find all pins and registers required --- #
# --- to apply timing constraints.                                 --- #
# --- During the fitter, the routines will be called only once     --- #
# --- and cached data will be used in all subsequent calls.        --- #
# -                                                                  - #
# -------------------------------------------------------------------- #
 
if { ! [ info exists ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_sdc_cache ] } {
   emif_initialize_ddr_db ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_emif_ddr_db var
   set ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_sdc_cache 1
} else {
   if { $debug } {
      post_message -type info "SDC: reusing cached DDR DB"
   }
}
 
# ------------------------------------------------------------- #
# -                                                           - #
# --- If multiple instances of this core are present in the --- #
# --- design they will all be constrained through the       --- #
# --- following loop                                        --- #
# -                                                           - #
# ------------------------------------------------------------- #
 
set instances [ array names ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_emif_ddr_db ]
foreach { inst } $instances {
   if { [ info exists pins ] } {
      unset pins
   }
   array set pins $ed_synth_emif_ph2_inst_emif_ph2_phy_arch_fp_610_hoyllai_emif_ddr_db($inst)

   # ----------------------- #
   # -                     - #
   # --- REFERENCE CLOCK --- #
   # -                     - #
   # ----------------------- #
 
   # First determine if a reference clock has already been created (i.e. Reference clock sharing)
   set ref_clock_exists [ emif_does_ref_clk_exist $pins(pll_ref_clock) ]
   if { $ref_clock_exists == 0 }  {
      # This is the reference clock used by the PLL to derive any other clock in the core
      if {$var(LOCKSTEP_ROLE) eq "OFF"} {
        create_clock -period "$var(PHY_REFCLK_FREQ_MHZ)MHz" $pins(pll_ref_clock) -add -name ${inst}_ref_clock
      } else {
        create_clock -period "$var(PHY_REFCLK_FREQ_MHZ)MHz" $pins(pll_ref_clock) -add -name $pins(pll_ref_clock)
      }
   }
   
   set pins(ref_clock_name) [emif_get_clock_name_from_pin_name $pins(pll_ref_clock)]
   # NCNTR clock division
   set pll_ncntr_clk [emif_get_or_add_generated_clock \
      -target $pins(pll_ncntr) \
      -name ${inst}_pll_ncntr \
      -source $pins(pll_ref_clock) \
      -multiply_by 1 \
      -divide_by $var(PLL_N_DIV) \
      -phase 0 ]

    if {$var(PLL_N_DIV)==1} {
       set srcclk $pins(pll_ref_clock)
    } else {
       set srcclk $pins(pll_ncntr)
    }

   # VCO clock
   set i_vco_clock 0
   foreach { vco_clock } $pins(pll_vco_clock) vco_base $pins(vco_base_node) {
 
      emif_get_or_add_generated_clock -target $vco_base \
         -name "${inst}_vco_base_${i_vco_clock}" \
         -source $srcclk \
         -multiply_by $var(PLL_M_DIV)  \
         -divide_by 1 \
         -phase 0 
 
      incr i_vco_clock
   }
   set i_vco_clock 0
   foreach { vco_clock } $pins(pll_vco_periph_clock) vco_base $pins(vco_base_node) {
      set local_pll_vco_clk__p${i_vco_clock} [ emif_get_or_add_generated_clock \
         -target $vco_clock \
         -name "${inst}_vco_clk_periph_${i_vco_clock}" \
         -source $srcclk \
         -multiply_by $var(PLL_M_DIV)  \
         -divide_by 1 \
         -phase 0 ]
      incr i_vco_clock
   }

   # Periphery clocks
   set periphery_clocks [list]
   set i_phy_clock 0
   foreach { phy_clock } $pins(pll_phy_clock) phy_reg $pins(pll_phy_reg) {
      set divide_by [expr {$var(CLK_DIV_VCO_MEM) * $var(CLK_DIV_MEM_PHY)}]
      set phase 0 ;
      emif_get_or_add_generated_clock -target $phy_reg \
         -name "${inst}_c0_cntr_${i_phy_clock}" \
         -source [lindex $pins(vco_base_node) $i_phy_clock] \
         -multiply_by 1 \
         -divide_by $divide_by \
         -phase $phase

      set local_phy_clk_${i_phy_clock} [ emif_get_or_add_generated_clock \
         -target $phy_clock \
         -name "${inst}_phy_clk_${i_phy_clock}" \
         -source $phy_reg \
         -multiply_by 1 \
         -divide_by 1 \
         -phase $phase ]
      lappend periphery_clocks [set local_phy_clk_${i_phy_clock}]
      incr i_phy_clock
   }
 
   set i_phy_clock_l 0
   foreach { phy_clock_l } $pins(pll_phy_clock_sync) phy_reg_s $pins(pll_phy_reg_sync) {
      set divide_by $var(PLL_C_DIV_1)
      set phase 0
      emif_get_or_add_generated_clock -target $phy_reg_s \
         -name "${inst}_c1_cntr_${i_phy_clock_l}" \
         -source [lindex $pins(vco_base_node) $i_phy_clock_l] \
         -multiply_by 1 \
         -divide_by $divide_by \
         -phase $phase
 
      set local_phy_clk_sync_${i_phy_clock_l} [ emif_get_or_add_generated_clock \
         -target $phy_clock_l \
         -name "${inst}_phy_clk_sync_${i_phy_clock_l}" \
         -source $phy_reg_s \
         -multiply_by 1 \
         -divide_by 1 \
         -phase $phase ]
      lappend periphery_clocks [set local_phy_clk_sync_${i_phy_clock_l}]
      incr i_phy_clock_l
   }
   
   set usr_clock ""
   if {!($var(PHY_NOC_EN) || $var(MEM_CLK_ASYNC) || $var(LOCKSTEP_ROLE) eq "SECONDARY")} {
      set phase 0
 
      set usr_clock [ emif_get_or_add_generated_clock \
         -target $pins(cpa_clock) \
         -name "${inst}_usr_clk" \
         -source [lindex $pins(vco_base_node) 0] \
         -multiply_by 1 \
         -divide_by $var(CLK_DIV_VCO_CORE) \
         -phase $phase ]
   }

   # WRITE_CLK
   foreach {dqs_t} $pins(dqs_t) {

      set_false_path -to [get_ports $dqs_t]
      set_false_path -from [get_ports $dqs_t]

      create_clock -period "${vco_freq}MHz" $dqs_t -name "${inst}_${dqs_t}_in" -add

      disable_min_pulse_width ${inst}_${dqs_t}_in
   }

   # READ_CLK
#set rclk_idx 0

   if {[regexp "_DDR4" $var(MEM_TECHNOLOGY)]} {
      set fa_div 2
   } else {
      set fa_div 4
   }
   foreach {fa_phyclk} $pins(phyclk_div) {
      emif_get_or_add_generated_clock \
         -target [lindex $fa_phyclk 0] \
         -name "${inst}_fa_[lindex $fa_phyclk 1]_[lindex $fa_phyclk 2]_[lindex $fa_phyclk 3]" \
         -source [lindex $pins(pll_phy_clock) 0] \
         -multiply_by 1 \
         -divide_by $fa_div \
         -phase 0
   }

   set lane 0
   foreach { phy_rxclk_gated } $pins(phy_rxclk_gated) byte_rx_gated $pins(byte_rx_gated) {
      create_clock -name "${inst}_lane_${lane}_rxclk_gated" -period 10.000 $phy_rxclk_gated
      set lane_${lane}_byte_rx_gated [ emif_get_or_add_generated_clock \
         -target $byte_rx_gated \
         -name "${inst}_lane_${lane}_byte_rx_gated" \
         -source $phy_rxclk_gated \
         -multiply_by 1 \
         -divide_by 1 \
         -phase 0 ]
      set_false_path -from [get_clocks "${inst}_lane_${lane}_byte_rx_gated"]
      incr lane
   }
      
   foreach t $pins(dqs_t) n $pins(dqsn_nff) {
      create_generated_clock \
         -name "${inst}_${t}_nff" \
         -source $t \
         -invert \
         $n
      set_false_path -from [get_clocks "${inst}_${t}_nff"]
   }

   foreach mipi $pins(mipi_div) {
      disable_min_pulse_width $mipi
   }
   
   # LOCKSTEP
   if {$var(LOCKSTEP_ROLE) eq "PRIMARY"} {
        regexp {(\S+)\|(arch_emif_ls_0)} $inst -> emif_inst
        if ${sta_flow} {
            set_min_delay -10 -from [get_keepers ${emif_inst}|axil_adaptor|*|*_mcp*]
            set_max_delay  10 -from [get_keepers ${emif_inst}|axil_adaptor|*|*_mcp*]
            set_data_delay -from [get_keepers ${emif_inst}|axil_adaptor|*|*_mcp*] -get_value_from_clock_period dst_clock_period -no_synchronizer -value_multiplier 2
        } else { 
            set_min_delay -5 -from [get_keepers ${emif_inst}|axil_adaptor|*|*_mcp*]
            set_max_delay  5 -from [get_keepers ${emif_inst}|axil_adaptor|*|*_mcp*]
            set_data_delay -from [get_keepers ${emif_inst}|axil_adaptor|*|*_mcp*] -get_value_from_clock_period dst_clock_period -no_synchronizer -value_multiplier 1
        }
        emif_add_false_path $sta_flow 5 -to [get_keepers ${emif_inst}|axil_adaptor|*|*_sync_inst|din_s1]
        set_data_delay -to [get_keepers ${emif_inst}|axil_adaptor|*|*_sync_inst|din_s1] -get_value_from_clock_period dst_clock_period -value_multiplier 1
        emif_add_false_path $sta_flow 10 -to [get_keepers ${emif_inst}|axil_adaptor|*|*rst*_sync_inst|*]
        set_false_path -from  [get_keepers ${emif_inst}|*|AXIL_ADAPTOR.adaptor_inst|*hipi_c2p|inst] -to [get_keepers ${emif_inst}|*|wrapper_pll|pll~out_clk_periph0_reg]
        set_false_path -from  [get_keepers ${emif_inst}|*|AXIL_ADAPTOR.adaptor_inst|*hipi_c2p*] -to [get_keepers ${emif_inst}|*|wrapper_pll|pll~out_clk_periph0_reg]
   }


   # DQ/DQS pins are calibrated
   if {[llength $pins(dq)] > 0} {
      set_false_path -to $pins(dq)
      set_false_path -from $pins(dq)
      set_output_delay -clock $pins(ref_clock_name) 0 $pins(dq) -add
      set_input_delay -clock $pins(ref_clock_name) 0 $pins(dq) -add
   }

   if {[llength $pins(dm)] > 0} {
      set_false_path -to $pins(dm)
      set_output_delay -clock $pins(ref_clock_name) 0 $pins(dm) -add
   }
   if {[llength $pins(dbi)] > 0} {
      set_false_path -to $pins(dbi)
      set_false_path -from $pins(dbi)
      set_output_delay -clock $pins(ref_clock_name) 0 $pins(dbi) -add
      set_input_delay -clock $pins(ref_clock_name) 0 $pins(dbi) -add
   }
   if {[llength $pins(wclk)] > 0} {
      set_false_path -to $pins(wclk)
      set_output_delay -clock $pins(ref_clock_name) 0 $pins(wclk) -add
   }

   if {[llength $pins(rclk)] > 0} {
      set_false_path -from $pins(rclk)
   }

   if {[llength $pins(ac_clk)] > 0} {
      set_false_path -to $pins(ac_clk)
      set_output_delay -clock $pins(ref_clock_name) 0 $pins(ac_clk) -add
   }
 
   if {[llength $pins(ac_async)] > 0} {
      set_false_path -to $pins(ac_async)
      set_false_path -from $pins(ac_async)
      foreach ac_async $pins(ac_async) {
         if {[string match "*alert*" $ac_async]} {
            set_input_delay -clock $pins(ref_clock_name) 0 $ac_async -add
         }
         if {[string match "*reset*" $ac_async]} {
            set_output_delay -clock $pins(ref_clock_name) 0 $ac_async -add
         }
      }
   }

   if {[llength $pins(ac_sync)] > 0} {
      set_false_path -to $pins(ac_sync)
      set_output_delay -clock $pins(ref_clock_name) 0 $pins(ac_sync) -add
   }
}

set_false_path -to [get_registers *pa_hr_reg] -setup
