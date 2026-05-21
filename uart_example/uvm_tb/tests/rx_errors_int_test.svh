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

class rx_errors_int_test extends uart_test_base;

`uvm_component_utils(rx_errors_int_test)

extern function new(string name = "rx_errors_int_test", uvm_component parent = null);
extern task run_phase(uvm_phase phase);

endclass: rx_errors_int_test

function rx_errors_int_test::new(string name = "rx_errors_int_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task rx_errors_int_test::run_phase(uvm_phase phase);
  rx_errors_int_vseq vseq = rx_errors_int_vseq::type_id::create("vseq");

  phase.raise_objection(this);
  init_vseq(vseq);
  vseq.start(null);
  phase.drop_objection(this);
endtask: run_phase