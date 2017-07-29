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

create_clock -name {sys_clk_in} -period 20.000 -waveform { 0.000 10.000 } [get_ports {sys_clk}]

derive_pll_clocks
# Rename the clock 
set cpu_clk {comb_3|altpll_0|sd1|pll7|clk[0]}

#**************************************************************
# Create Generated Clock
#**************************************************************
create_generated_clock -name spi_clk_reg -source [get_pins $cpu_clk] -edges {1 5 9} [get_registers {recon_1:comb_3|recon_1_epcs_0:epcs_0|recon_1_epcs_0_sub:the_recon_1_epcs_0_sub|SCLK_reg}]
create_generated_clock -name spi_clk_out -source [get_pins {recon_1:comb_3|recon_1_epcs_0:epcs_0|recon_1_epcs_0_sub:the_recon_1_epcs_0_sub|SCLK_reg|q}] -divide_by 1 [get_ports {epcs_0_dclk}]


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay -clock_fall -clock {spi_clk_out} -max 8 [get_ports {epcs_0_data0}]
set_input_delay -clock_fall -clock {spi_clk_out} -min 2 [get_ports {epcs_0_data0}]
set_multicycle_path -setup -end -from [get_clocks spi_clk_out] -to [get_clocks $cpu_clk] 2
set_multicycle_path -hold  -end -from [get_clocks spi_clk_out] -to [get_clocks $cpu_clk] 1


#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -clock {spi_clk_out} -max 3 [get_ports {epcs_0_sdo epcs_0_sce}]
set_output_delay -clock {spi_clk_out} -min 1 [get_ports {epcs_0_sdo epcs_0_sce}]
set_multicycle_path -setup -start -from [get_clocks $cpu_clk] -to [get_clocks spi_clk_out] 2
set_multicycle_path -hold  -start -from [get_clocks $cpu_clk] -to [get_clocks spi_clk_out] 1
 


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************


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

