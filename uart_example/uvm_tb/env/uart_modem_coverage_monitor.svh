class uart_modem_coverage_monitor extends uvm_subscriber #(apb_seq_item);

`uvm_component_utils(uart_modem_coverage_monitor)


covergroup mcr_settings_cg() with function sample(bit[4:0] mcr);

  option.name = "mcr_settings_cg";
  option.per_instance = 1;

  DTR: coverpoint mcr[0];
  RTS: coverpoint mcr[1];
  OUT1: coverpoint mcr[2];
  OUT2: coverpoint mcr[3];
  LOOPBACK: coverpoint mcr[4];

  MCR_SETTINGS: cross DTR, RTS, OUT1, OUT2, LOOPBACK;

endgroup: mcr_settings_cg

covergroup msr_inputs_cg() with function sample(bit[7:0] msr, bit loopback);

  option.name = "msr_inputs_cg";
  option.per_instance = 1;

  DCTS: coverpoint msr[0];
  DDSR: coverpoint msr[1];
  TERI: coverpoint msr[2];
  DDCD: coverpoint msr[3];
  CTS: coverpoint msr[4];
  DSR: coverpoint msr[5];
  RI: coverpoint msr[6];
  DCD: coverpoint msr[7];
  LOOPBACK: coverpoint loopback;

  MSR_INPUTS: cross DCTS, DDSR, TERI, DDCD, CTS, DSR, RI, DCD, LOOPBACK;

endgroup: msr_inputs_cg

uart_reg_block rm;

function new(string name = "uart_modem_coverage_monitor", uvm_component parent = null);
  super.new(name, parent);
  mcr_settings_cg = new();
  msr_inputs_cg = new();
endfunction

function void write(T t);
  uvm_reg_data_t data;

  if((t.addr[7:0] == 8'h18) && (t.we == 0)) begin
    data = rm.MCR.get_mirrored_value();
    msr_inputs_cg.sample(t.data[7:0], data[4]);
  end
  else if((t.addr[7:0] == 8'h10) && (t.we == 1)) begin
    mcr_settings_cg.sample(t.data[4:0]);
  end

endfunction: write

endclass: uart_modem_coverage_monitor