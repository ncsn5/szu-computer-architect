create_clock -period 20 -name clk [get_ports {clk} ]
create_clock -period 100 -name jtag_clk [get_ports {JTAG_TCK} ]
set_clock_groups -asynchronous -group [get_clocks {clk}] -group [get_clocks {jtag_clk}]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets JTAG_TCK_IBUF]