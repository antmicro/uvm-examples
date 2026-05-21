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

class modem_int_test extends uart_test_base;

`uvm_component_utils(modem_int_test)

extern function new(string name = "modem_int_test", uvm_component parent = null);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

endclass: modem_int_test

function modem_int_test::new(string name = "modem_int_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task modem_int_test::run_phase(uvm_phase phase);
  modem_int_test_vseq vseq = modem_int_test_vseq::type_id::create("vseq");

  phase.raise_objection(this);
  init_vseq(vseq);
  vseq.start(null);
  phase.drop_objection(this);
endtask: run_phase

function void modem_int_test::report_phase(uvm_phase phase);
  if((m_env.modem_sb.modem_status_errors == 0) && (m_env.modem_sb.modem_output_errors == 0)) begin
    `uvm_info("*** UVM TEST PASSED ***", "No modem errors observed", UVM_LOW)
  end

  if(m_env.modem_sb.modem_status_errors != 0) begin
    `uvm_error("*** UVM TEST FAILED ***", $sformatf("%0d modem status errors occurred during %0d MSR reads", m_env.modem_sb.modem_status_errors, m_env.modem_sb.modem_status_reads))
  end

  if(m_env.modem_sb.modem_output_errors != 0) begin
    `uvm_error("*** UVM TEST FAILED ***", $sformatf("%0d modem control errors occurred during %0d MSR writes", m_env.modem_sb.modem_output_errors, m_env.modem_sb.modem_output_writes))
  end
endfunction: report_phase