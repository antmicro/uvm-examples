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

class uart_host_rx_seq extends host_if_base_seq;

`uvm_object_utils(uart_host_rx_seq)

rand int no_rx_chars;

constraint char_limit_c { no_rx_chars inside {[1:20]};}

function new(string name = "uart_host_rx_seq");
  super.new(name);
endfunction

task body;
  super.body();
  for(int i = 0; i < no_rx_chars; i++) begin
    rm.LSR.read(status, data, .parent(this));
    // Wait for data to be available
    while(!data[0]) begin
      rm.LSR.read(status, data, .parent(this));
      cfg.wait_for_clock(10);
    end
    rm.RXD.read(status, data, .parent(this));
  end
endtask: body

endclass: uart_host_rx_seq
