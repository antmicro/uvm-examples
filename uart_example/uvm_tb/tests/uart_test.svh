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

class uart_test extends uart_test_base;

`uvm_component_utils(uart_test)

extern function new(string name = "uart_test", uvm_component parent = null);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

endclass: uart_test

function uart_test::new(string name = "uart_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task uart_test::run_phase(uvm_phase phase);
  basic_reg_vseq vseq = basic_reg_vseq::type_id::create("vseq");

  phase.raise_objection(this);
  init_vseq(vseq);
  vseq.start(null);
  phase.drop_objection(this);
endtask: run_phase

function void uart_test::report_phase(uvm_phase phase);
  `uvm_info("*** UVM TEST PASSED ***", "Register RW paths checked", UVM_LOW)
endfunction: report_phase