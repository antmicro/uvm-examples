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

class uart_int_enable_seq extends host_if_base_seq;

`uvm_object_utils(uart_int_enable_seq)

rand bit[3:0] IER;

function new(string name = "uart_int_enable_seq");
  super.new(name);
endfunction

task body;
  super.body();
  rm.IER.write(status, {'0, IER}, .parent(this));
endtask: body

endclass: uart_int_enable_seq