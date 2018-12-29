## Generated SDC file "/home/jeff/fpga_workspace/GitIPCores/recon/hw/recon_2/bemicro_max10/timing_constraints/recon_2.sdc"

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
create_clock -name {sys_clk_in} -period 83.334 -waveform { 0.000 42.000 } [get_ports {sys_clk}]



derive_pll_clocks
# Rename the clock 
set cpu_clk {pll|altpll_component|auto_generated|pll1|clk[0]}
set ram_clk {pll|altpll_component|auto_generated|pll1|clk[1]}

#**************************************************************
# Create Generated Clock
#**************************************************************
create_generated_clock -name sdram_clk -source pll|altpll_component|auto_generated|pll1|clk[1]  -divide_by 1 -multiply_by 1 [get_ports {sdram_0_clk}]
create_generated_clock -name flash_se_clk -source pll|altpll_component|auto_generated|pll1|clk[0] -divide_by 2 -multiply_by 1 [get_pins {recon_2:comb_4|altera_onchip_flash:onchip_flash|altera_onchip_flash_avmm_data_controller:avmm_data_controller|flash_se_neg_reg|q}] 

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************
set_multicycle_path -from [get_clocks {sdram_clk}] -to [get_clocks {pll|altpll_component|auto_generated|pll1|clk[0]}] -setup -end 2
set_input_delay -clock {sdram_clk} 4.5 [get_ports {sdram_0_dq[0] sdram_0_dq[1] sdram_0_dq[2] sdram_0_dq[3] sdram_0_dq[4] sdram_0_dq[5] sdram_0_dq[6] sdram_0_dq[7] sdram_0_dq[8] sdram_0_dq[9] sdram_0_dq[10] sdram_0_dq[11] sdram_0_dq[12] sdram_0_dq[13] sdram_0_dq[14] sdram_0_dq[15] sdram_0_dqm[0] sdram_0_dqm[1]}]

set_input_delay -clock { altera_reserved_tck } 10 [get_ports {altera_reserved_tdi}]
set_input_delay -clock { altera_reserved_tck } 10 [get_ports {altera_reserved_tms}]

#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -clock {sdram_clk} 1.5 [get_ports {sdram_0_addr[0] sdram_0_addr[1] sdram_0_addr[2] sdram_0_addr[3] sdram_0_addr[4] sdram_0_addr[5] sdram_0_addr[6] sdram_0_addr[7] sdram_0_addr[8] sdram_0_addr[9] sdram_0_addr[10] sdram_0_addr[11] sdram_0_ba[0] sdram_0_ba[1] sdram_0_cas_n sdram_0_cke sdram_0_cs_n sdram_0_dq[0] sdram_0_dq[1] sdram_0_dq[2] sdram_0_dq[3] sdram_0_dq[4] sdram_0_dq[5] sdram_0_dq[6] sdram_0_dq[7] sdram_0_dq[8] sdram_0_dq[9] sdram_0_dq[10] sdram_0_dq[11] sdram_0_dq[12] sdram_0_dq[13] sdram_0_dq[14] sdram_0_dq[15] sdram_0_dqm[0] sdram_0_dqm[1] sdram_0_ras_n sdram_0_we_n}]

set_output_delay -clock { altera_reserved_tck } 10 [get_ports {altera_reserved_tdo}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************
set_false_path -from [get_ports {port_0_io[0] port_0_io[1] port_0_io[2] port_0_io[3] port_0_io[4] port_0_io[5] port_0_io[6] port_0_io[7] port_0_io[8] port_0_io[9] port_0_io[10] port_0_io[11] port_0_io[12] port_0_io[13] port_0_io[14] port_0_io[15] port_0_io[16] port_0_io[17] port_0_io[18] port_0_io[19] port_0_io[20] port_0_io[21] port_0_io[22] port_0_io[23] port_0_io[24] port_0_io[25] port_0_io[26] port_0_io[27] port_0_io[28] port_0_io[29] port_0_io[30] port_0_io[31] uart_0_rxd uart_0_txd sys_rstn}]
set_false_path -to [get_ports {port_0_io[0] port_0_io[1] port_0_io[2] port_0_io[3] port_0_io[4] port_0_io[5] port_0_io[6] port_0_io[7] port_0_io[8] port_0_io[9] port_0_io[10] port_0_io[11] port_0_io[12] port_0_io[13] port_0_io[14] port_0_io[15] port_0_io[16] port_0_io[17] port_0_io[18] port_0_io[19] port_0_io[20] port_0_io[21] port_0_io[22] port_0_io[23] port_0_io[24] port_0_io[25] port_0_io[26] port_0_io[27] port_0_io[28] port_0_io[29] port_0_io[30] port_0_io[31] uart_0_rxd uart_0_txd sys_rstn}]

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************


#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Net Delay
#**************************************************************

