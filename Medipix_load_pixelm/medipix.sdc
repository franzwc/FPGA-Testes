
#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {Clk25} -period 40.000 -waveform { 0.000 20.000 } [get_ports {Clk25}]
create_clock -name {Clk125} -period 8.000 -waveform { 0.000 4.000 } [get_ports {Clk125}]
create_clock -name {Clk_out_Mdpx} -period 16.000 -waveform { 0.000 8.000 } [get_ports {Clk_out_Mdpx}]
create_clock -name {Clk_in_Mdpx} -period 16.000 -waveform { 0.000 8.000 } [get_ports {Clk_in_Mdpx}]
create_clock -name {Eth_Rxc} -period 40.000 -waveform { 0.000 20.000 } [get_ports {Eth_Rxc}] 

#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************
set_clock_groups -exclusive -group [get_clocks {Clk25}]
set_clock_groups -exclusive -group [get_clocks {Clk125}]
set_clock_groups -exclusive -group [get_clocks {Eth_Rxc}]
set_clock_groups -exclusive -group [get_clocks {Clk_out_Mdpx}]
set_clock_groups -exclusive -group [get_clocks {Clk_in_Mdpx}]
set_clock_groups -exclusive -group [get_clocks {u_cpu_pll|*|clk[0]}]
set_clock_groups -exclusive -group [get_clocks {u_cpu_pll|*|clk[1]}]
set_clock_groups -exclusive -group [get_clocks {u_cpu_pll|*|clk[2]}]

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

