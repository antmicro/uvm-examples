all: work monitor tb sim

work:
	vlib work

monitor:
	vlog ../protocol_monitor/apb_monitor.sv

tb:
	vlog ../testbench/apb_monitor_tb.sv

sim:
	vsim apb_monitor_tb -do "run -all" -c

simgui:
	vsim apb_monitor_tb -voptargs=+acc

clean:
	rm -r work transcript

tarball: clean tgz

tgz:
	@(cd ../..; \
	tar -zcf apb_protocol_monitor_example/sim/apb_protocol_monitor.tgz \
	apb_protocol_monitor_example/testbench \
	apb_protocol_monitor_example/sim/Makefile \
	apb_protocol_monitor_example/README \
	apb_protocol_monitor_example/protocol_monitor)

