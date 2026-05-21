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

class uart_rx_coverage_monitor extends uvm_subscriber #(lcr_item);

`uvm_component_utils(uart_rx_coverage_monitor)

covergroup rx_word_format_cg with function sample(bit[5:0] lcr);

  option.name = "rx_word_format";
  option.per_instance = 1;

  WORD_LENGTH: coverpoint lcr[1:0] {
    bins bits_5 = {0};
    bins bits_6 = {1};
    bins bits_7 = {2};
    bins bits_8 = {3};
  }

  STOP_BITS: coverpoint lcr[2] {
    bins stop_1 = {0};
    bins stop_2 = {1};
  }

  PARITY: coverpoint lcr[5:3] {
    bins no_parity = {3'b000, 3'b010, 3'b100, 3'b110};
    bins even_parity = {3'b011};
    bins odd_parity = {3'b001};
    bins stick1_parity = {3'b101};
    bins stick0_parity = {3'b111};
  }

  WORD_FORMAT: cross WORD_LENGTH, STOP_BITS, PARITY;

endgroup: rx_word_format_cg


function new(string name = "uart_rx_coverage_monitor", uvm_component parent = null);
  super.new(name, parent);
  rx_word_format_cg = new();
endfunction

function void write(T t);
  rx_word_format_cg.sample(t.lcr[5:0]);
endfunction: write

endclass: uart_rx_coverage_monitor
