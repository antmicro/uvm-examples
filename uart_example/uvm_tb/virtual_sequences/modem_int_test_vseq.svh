//----------------------------------------------------------------------
//   Copyright 2012 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

class modem_int_test_vseq extends uart_vseq_base;

`uvm_object_utils(modem_int_test_vseq)

function new(string name = "modem_int_test_vseq");
  super.new(name);
endfunction

task body;
  modem_basic_sequence modem_seq = modem_basic_sequence::type_id::create("modem_seq");
  uart_host_msr_seq read_msr = uart_host_msr_seq::type_id::create("read_msr");
  uart_host_mcr_seq write_mcr = uart_host_mcr_seq::type_id::create("read_mcr");
  uart_int_enable_seq ien = uart_int_enable_seq::type_id::create("ien");
  modem_isr_seq modem_isr = modem_isr_seq::type_id::create("modem_isr");

  // No loopback:
  write_mcr.loopback = 0;
  ien.IER = 4'h8;
  ien.start(apb);

  fork
    modem_seq.start(modem);
    begin
      forever begin
        if(!cfg.get_interrupt_level()) begin
          cfg.wait_for_interrupt();
        end
        modem_isr.start(apb);
      end
    end
  join_none

  repeat(500) begin
    write_mcr.start(apb);
  end

  // With loopback:
  write_mcr.loopback = 1;
  repeat(500) begin
    write_mcr.start(apb);
  end

endtask: body

endclass: modem_int_test_vseq