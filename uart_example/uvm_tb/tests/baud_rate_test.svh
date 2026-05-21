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

class baud_rate_test extends uart_test_base;

`uvm_component_utils(baud_rate_test)

extern function new(string name = "baud_rate_test", uvm_component parent = null);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

endclass: baud_rate_test

function baud_rate_test::new(string name = "baud_rate_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task baud_rate_test::run_phase(uvm_phase phase);
  baud_rate_test_seq br_test = baud_rate_test_seq::type_id::create("br_test");

  phase.raise_objection(this);
  br_test.start(m_env.m_apb_agent.m_sequencer);
  phase.drop_objection(this);
endtask: run_phase

function void baud_rate_test::report_phase(uvm_phase phase);
  if(m_env.br_sb.div_errors == 0) begin
    `uvm_info("*** UVM TEST PASSED ***", "No baud rate errors detected", UVM_LOW)
  end
  else begin
    `uvm_error("*** UVM TEST FAILED ***", $sformatf("%0d baud rate errors detected", m_env.br_sb.div_errors))
  end
endfunction: report_phase
