## Generated SDC file "/home/jeff/fpga_workspace/GitIPCores/recon/hw/recon_0/bemicro_max10/timing_constraints/recon_0.sdc"

## Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus Prime License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 16.0.0 Build 211 04/27/2016 SJ Lite Edition"

## DATE    "Tue May 23 22:37:36 2017"

##
## DEVICE  "10M08DAF484C8GES"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {sys_clk_in} -period 83.000 -waveform { 0.000 42.000 } [get_ports {sys_clk}]

derive_pll_clocks
# Rename the clock 
set cpu_clk {comb_3|altpll_0|sd1|pll7|clk[0]}

#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************
set_multicycle_path -from [get_clocks {pll|altpll_component|auto_generated|pll1|clk[1]}] -to [get_clocks {pll|altpll_component|auto_generated|pll1|clk[0]}] -setup -end 2



#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -clock { pll|altpll_component|auto_generated|pll1|clk[1] } 1.5 [get_ports {sdram_0_addr[0] sdram_0_addr[1] sdram_0_addr[2] sdram_0_addr[3] sdram_0_addr[4] sdram_0_addr[5] sdram_0_addr[6] sdram_0_addr[7] sdram_0_addr[8] sdram_0_addr[9] sdram_0_addr[10] sdram_0_addr[11] sdram_0_ba[0] sdram_0_ba[1] sdram_0_cas_n sdram_0_cke sdram_0_cs_n sdram_0_dq[0] sdram_0_dq[1] sdram_0_dq[2] sdram_0_dq[3] sdram_0_dq[4] sdram_0_dq[5] sdram_0_dq[6] sdram_0_dq[7] sdram_0_dq[8] sdram_0_dq[9] sdram_0_dq[10] sdram_0_dq[11] sdram_0_dq[12] sdram_0_dq[13] sdram_0_dq[14] sdram_0_dq[15] sdram_0_dqm[0] sdram_0_dqm[1] sdram_0_ras_n sdram_0_we_n}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
set_false_path -to [get_registers {*|flash_busy_reg}]
set_false_path -to [get_registers {*|flash_busy_clear_reg}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]
set_false_path -from [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_nios2_oci_break:the_recon_0_cpu0_cpu_nios2_oci_break|break_readreg*}] -to [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_debug_slave_wrapper:the_recon_0_cpu0_cpu_debug_slave_wrapper|recon_0_cpu0_cpu_debug_slave_tck:the_recon_0_cpu0_cpu_debug_slave_tck|*sr*}]
set_false_path -from [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_nios2_oci_debug:the_recon_0_cpu0_cpu_nios2_oci_debug|*resetlatch}] -to [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_debug_slave_wrapper:the_recon_0_cpu0_cpu_debug_slave_wrapper|recon_0_cpu0_cpu_debug_slave_tck:the_recon_0_cpu0_cpu_debug_slave_tck|*sr[33]}]
set_false_path -from [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_nios2_oci_debug:the_recon_0_cpu0_cpu_nios2_oci_debug|monitor_ready}] -to [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_debug_slave_wrapper:the_recon_0_cpu0_cpu_debug_slave_wrapper|recon_0_cpu0_cpu_debug_slave_tck:the_recon_0_cpu0_cpu_debug_slave_tck|*sr[0]}]
set_false_path -from [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_nios2_oci_debug:the_recon_0_cpu0_cpu_nios2_oci_debug|monitor_error}] -to [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_debug_slave_wrapper:the_recon_0_cpu0_cpu_debug_slave_wrapper|recon_0_cpu0_cpu_debug_slave_tck:the_recon_0_cpu0_cpu_debug_slave_tck|*sr[34]}]
set_false_path -from [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_nios2_ocimem:the_recon_0_cpu0_cpu_nios2_ocimem|*MonDReg*}] -to [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_debug_slave_wrapper:the_recon_0_cpu0_cpu_debug_slave_wrapper|recon_0_cpu0_cpu_debug_slave_tck:the_recon_0_cpu0_cpu_debug_slave_tck|*sr*}]
set_false_path -from [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_debug_slave_wrapper:the_recon_0_cpu0_cpu_debug_slave_wrapper|recon_0_cpu0_cpu_debug_slave_tck:the_recon_0_cpu0_cpu_debug_slave_tck|*sr*}] -to [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_debug_slave_wrapper:the_recon_0_cpu0_cpu_debug_slave_wrapper|recon_0_cpu0_cpu_debug_slave_sysclk:the_recon_0_cpu0_cpu_debug_slave_sysclk|*jdo*}]
set_false_path -from [get_keepers {sld_hub:*|irf_reg*}] -to [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_debug_slave_wrapper:the_recon_0_cpu0_cpu_debug_slave_wrapper|recon_0_cpu0_cpu_debug_slave_sysclk:the_recon_0_cpu0_cpu_debug_slave_sysclk|ir*}]
set_false_path -from [get_keepers {sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1]}] -to [get_keepers {*recon_0_cpu0_cpu:*|recon_0_cpu0_cpu_nios2_oci:the_recon_0_cpu0_cpu_nios2_oci|recon_0_cpu0_cpu_nios2_oci_debug:the_recon_0_cpu0_cpu_nios2_oci_debug|monitor_go}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from [get_registers {*altera_avalon_st_clock_crosser:*|in_data_buffer*}] -to [get_registers {*altera_avalon_st_clock_crosser:*|out_data_buffer*}] 100.000
set_max_delay -from [get_registers *] -to [get_registers {*altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:*|din_s1}] 100.000


#**************************************************************
# Set Minimum Delay
#**************************************************************

set_min_delay -from [get_registers {*altera_avalon_st_clock_crosser:*|in_data_buffer*}] -to [get_registers {*altera_avalon_st_clock_crosser:*|out_data_buffer*}] -100.000
set_min_delay -from [get_registers *] -to [get_registers {*altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:*|din_s1}] -100.000


#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Net Delay
#**************************************************************

set_net_delay -max 2.000 -from [get_registers *] -to [get_registers {*altera_avalon_st_clock_crosser:*|altera_std_synchronizer_nocut:*|din_s1}]
set_net_delay -max 2.000 -from [get_registers {*altera_avalon_st_clock_crosser:*|in_data_buffer*}] -to [get_registers {*altera_avalon_st_clock_crosser:*|out_data_buffer*}]
