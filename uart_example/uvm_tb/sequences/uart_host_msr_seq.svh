class uart_host_msr_seq extends host_if_base_seq;

`uvm_object_utils(uart_host_msr_seq)

function new(string name = "uart_host_msr_seq");
  super.new(name);
endfunction

task body;
  super.body();
  rm.MSR.read(status, data, .parent(this));
endtask: body

endclass: uart_host_msr_seq