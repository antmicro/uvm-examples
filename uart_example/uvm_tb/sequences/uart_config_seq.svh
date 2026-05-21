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

class uart_config_seq extends host_if_base_seq;

`uvm_object_utils(uart_config_seq)

rand bit[5:0] LCR;
rand bit[15:0] DIV;
rand bit[1:0] FCR;

function new(string name = "uart_config_seq");
  super.new(name);
endfunction

task body;
  super.body();

  rm.LCR.write(status, {'0, LCR}, .parent(this));
  rm.LCR.read(status, data, .parent(this));
  rm.FCR.write(status, {'0, FCR, 6'b0}, .parent(this));
  rm.DIV1.write(status, {'0, DIV[7:0]}, .parent(this));
  rm.DIV2.write(status, {'0, DIV[15:8]}, .parent(this));

endtask: body

endclass: uart_config_seq