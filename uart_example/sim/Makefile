all: work rtl agents uvm_tb tb sim_all

work:
	vlib work

rtl:
	vlog ../rtl/uart/*.sv +cover=sbf

agents:
	vlog ../agents/apb_agent/apb_if.sv
	vlog +incdir+../agents/apb_agent ../agents/apb_agent/apb_agent_pkg.sv
	vlog ../agents/uart_agent/serial_if.sv
	vlog +incdir+../agents/uart_agent ../agents/uart_agent/uart_agent_pkg.sv
	vlog ../agents/modem_agent/modem_if.sv
	vlog +incdir+../agents/modem_agent ../agents/modem_agent/modem_agent_pkg.sv

uvm_tb:
	vlog ../uvm_tb/register_model/uart_reg_pkg.sv
	vlog +incdir+../uvm_tb/env ../uvm_tb/env/uart_env_pkg.sv
	vlog +incdir+../uvm_tb/sequences ../uvm_tb/sequences/host_if_seq_pkg.sv
	vlog +incdir+../uvm_tb/sequences ../uvm_tb/sequences/uart_seq_pkg.sv
	vlog +incdir+../uvm_tb/virtual_sequences ../uvm_tb/virtual_sequences/uart_vseq_pkg.sv
	vlog +incdir+../uvm_tb/tests ../uvm_tb/tests/uart_test_pkg.sv

tb:
	vlog ../uvm_tb/tb/interrupt_if.sv
	vlog ../protocol_monitor/apb_monitor.sv
	vlog ../uvm_tb/tb/uart_tb.sv
	
sim_all: sim_word_format_poll sim_modem_poll sim_word_format_int sim_modem_int sim_baud_rate sim_uart_regs

sim_word_format_poll:
	vsim uart_tb +UVM_TESTNAME=word_format_poll_test -do "coverage save word_format_poll.ucdb -onexit;run -all" -c -l word_format_poll.log -coverage -voptargs=+acc

sim_modem_poll:
	vsim uart_tb +UVM_TESTNAME=modem_poll_test -do "coverage save modem_poll.ucdb -onexit;run -all" -l modem_poll.log -c -coverage

sim_word_format_int:
	vsim uart_tb +UVM_TESTNAME=word_format_int_test -do "coverage save word_format_int.ucdb -onexit;run -all" -l word_format_int.log -c -coverage

sim_modem_int:
	vsim uart_tb +UVM_TESTNAME=modem_int_test -do "coverage save modem_int.ucdb -onexit;run -all" -l modem_int.log -c -coverage

sim_baud_rate:
	vsim uart_tb +UVM_TESTNAME=baud_rate_test -do "coverage save baud_rate.ucdb -onexit;run -all" -l baud_rate.log -c -coverage

sim_rx_errors_int:
	vsim uart_tb +UVM_TESTNAME=rx_errors_int_test -do "coverage save rx_errors_int.ucdb -onexit;run -all" -l rx_errors_int.log  -voptargs=+acc

sim_uart_regs:
	vsim uart_tb +UVM_TESTNAME=uart_test -do "coverage save uart_regs.ucdb -onexit;run -all" -l uart_regs.log -c -voptargs=+acc

#	vsim uart_tb +UVM_TESTNAME=rx_errors_int_test -do "coverage save rx_errors_int.ucdb -onexit;run -all" -l rx_errors_int.log -c -coverage


clean: 
	rm -r work
	rm *.log transcript vsim.* *.ucdb 

tarball: clean tgz

tgz:
	@(cd ../..; \
	tar -zcf uart_example/sim/uart_example.tgz \
	uart_example/agents \
	uart_example/docs \
	uart_example/protocol_monitor \
	uart_example/rtl \
	uart_example/uvm_tb \
	uart_example/README \
	uart_example/sim/Makefile)

