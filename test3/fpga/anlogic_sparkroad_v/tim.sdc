create_clock -period 40.000 -name clk [get_ports clk]
create_clock -period 100.000 -name jtag_clk [get_ports JTAG_TCK]
set_clock_groups -asynchronous -group [get_clocks clk] -group [get_clocks {jtag_clk}]