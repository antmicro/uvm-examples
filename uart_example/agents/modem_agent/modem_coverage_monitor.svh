//------------------------------------------------------------
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
//------------------------------------------------------------

class modem_coverage_monitor extends uvm_subscriber #(modem_seq_item);

`uvm_component_utils(modem_coverage_monitor)

logic[7:0] modem;

  covergroup modem_lines_cg;
    DCD: coverpoint modem[0];
    RI: coverpoint modem[1];
    DSR: coverpoint modem[2];
    DTR: coverpoint modem[3];
    CTS: coverpoint modem[4];
    RTS: coverpoint modem[5];
    OUT1: coverpoint modem[6];
    OUT2: coverpoint modem[7];
  cross DCD, RI, DSR, DTR, CTS, RTS, OUT1, OUT2;
  endgroup: modem_lines_cg

 function new(string name = "modem_coverage_monitor", uvm_component parent = null);
   super.new(name, parent);
   modem_lines_cg = new;
 endfunction

 function void write(modem_seq_item t);
   modem = t.modem_bits;
   modem_lines_cg.sample();
 endfunction

 endclass: modem_coverage_monitor
