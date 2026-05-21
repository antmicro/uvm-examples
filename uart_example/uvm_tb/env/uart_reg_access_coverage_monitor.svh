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
class uart_reg_access_coverage_monitor extends uvm_subscriber #(apb_seq_item);

`uvm_component_utils(uart_reg_access_coverage_monitor)

bit we;
bit[7:0] addr;

covergroup reg_access_cg();

  option.name = "reg_access_cg";
  option.per_instance = 1;

  RW: coverpoint we {
    bins read = {0};
    bins write = {1};
  }

  ADDR: coverpoint addr {
    bins data = {0};
    bins ier = {8'h4};
    bins iir_fcr = {8'h8};
    bins lcr = {8'hC};
    bins mcr = {8'h10};
    bins lsr = {8'h14};
    bins msr = {8'h18};
    bins div1 = {8'h1c};
    bins div2 = {8'h20};
  }

  REG_ACCESS: cross RW, ADDR {
    ignore_bins read_only = binsof(ADDR) intersect {8'h14, 8'h18} && binsof(RW) intersect {1};
  }


endgroup: reg_access_cg

covergroup lsr_read_cg() with function sample(bit[7:0] LSR);

  option.name = "lsr_read_cg";
  option.per_instance = 1;

  RX_DATA: coverpoint LSR[1:0] {
    bins empty = {2'b00};
    bins dr = {2'b01};
    bins overrun = {2'b11};
    illegal_bins invalid_status = {2'b10};
  }

  PE: coverpoint LSR[2] {
    bins pe = {1};
    bins no_pe = {0};
  }

  FE: coverpoint LSR[3]{
    bins fe = {1};
    bins no_fe = {0};
  }

  BI: coverpoint LSR[4]{
    bins bi = {1};
    bins no_bi = {0};
  }

  TX_DATA: coverpoint LSR[6:5] {
    bins empty = {2'b11};
    bins full = {2'b00};
    bins fifo_empty = {2'b01};
    illegal_bins invalid_status = {2'b10};
  }

  FIFOERR: coverpoint LSR[7]{
    bins fifo_error = {1};
    bins no_fifo_error = {0};
  }

  FIFO_ERROR_STATUS: cross PE, FE, BI, FIFOERR {
    illegal_bins invalid_fifo_error = binsof(FIFOERR) intersect {1} && (binsof(PE) intersect {0} && binsof(FE) intersect {0} && binsof(BI) intersect {0});
    illegal_bins missing_fifo_error = binsof(FIFOERR) intersect {0} && (binsof(PE) intersect {1} || binsof(FE) intersect {1} || binsof(BI) intersect {1});
  }

endgroup: lsr_read_cg


function new(string name = "uart_reg_access_coverage_monitor", uvm_component parent = null);
  super.new(name, parent);
  reg_access_cg = new();
  lsr_read_cg = new();
endfunction

function void write(T t);
  we = t.we;
  addr = t.addr;
  reg_access_cg.sample();
  if((addr[7:0] == 8'h14) && (we == 0)) begin
    lsr_read_cg.sample(t.data[7:0]);
  end
endfunction: write


endclass: uart_reg_access_coverage_monitor