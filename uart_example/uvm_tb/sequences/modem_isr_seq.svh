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

class modem_isr_seq extends host_if_base_seq;

`uvm_object_utils(modem_isr_seq)

function new(string name = "modem_isr_seq");
  super.new(name);
endfunction

task body;
  super.body();
  rm.IID.read(status, data, .parent(this));
  rm.MSR.read(status, data, .parent(this));
endtask: body

endclass: modem_isr_seq