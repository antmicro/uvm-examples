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

class uart_rx_seq extends uvm_sequence #(uart_seq_item);

`uvm_object_utils(uart_rx_seq)

rand int no_rx_chars;

rand bit[7:0] lcr;
rand bit[15:0] baud_divisor;
rand bit no_errors;

function new(string name = "uart_rx_seq");
  super.new(name);
endfunction

task body;
  uart_seq_item rx_char = uart_seq_item::type_id::create("rx_char");

  repeat(no_rx_chars) begin
    start_item(rx_char);
    assert(rx_char.randomize() with {data[4:0] != 0;});
    rx_char.baud_divisor = baud_divisor;
    rx_char.lcr = lcr;
    if(no_errors) begin
      rx_char.fe = 0;
      rx_char.pe = 0;
      rx_char.sbe = 0;
    end
    finish_item(rx_char);
  end

endtask: body

endclass: uart_rx_seq