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
class baud_rate_checker extends uvm_component;

`uvm_component_utils(baud_rate_checker)

uvm_tlm_analysis_fifo #(apb_seq_item) apb_fifo;

virtual interrupt_if IRQ;
uart_reg_block rm;

int clk_count;
uvm_reg_data_t div1;
uvm_reg_data_t div2;
bit[15:0] div;

int div_errors;
bit new_value_written;
bit br_value_invalid;


covergroup baud_rate_cg() with function sample(bit[15:0] div);

  coverpoint div {
    bins div_ratio[] = {16'h1, 16'h2, 16'h4, 16'h8,
                        16'h10, 16'h20, 16'h40, 16'h80,
                        16'h100, 16'h200, 16'h400, 16'h800,
                        16'h1000, 16'h2000, 16'h4000, 16'h8000,
                        16'hfffe, 16'hfffd, 16'hfffb, 16'hfff7,
                        16'hffef, 16'hffdf, 16'hffbf, 16'hff7f,
                        16'hfeff, 16'hfdff, 16'hfbff, 16'hf7ff,
                        16'hefff, 16'hdfff, 16'hbfff, 16'h7fff,
                        16'h00ff, 16'hff00, 16'hffff};
  }
endgroup: baud_rate_cg

extern function new(string name = "baud_rate_checker", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);
extern task count_clocks;
extern task monitor_baudout;
extern task monitor_apb;
extern function void check_count(bit[15:0] div, int clk_count);

endclass: baud_rate_checker

function baud_rate_checker::new(string name = "baud_rate_checker", uvm_component parent = null);
  super.new(name, parent);
  baud_rate_cg = new();
endfunction

function void baud_rate_checker::build_phase(uvm_phase phase);
  apb_fifo = new("apb", this);
endfunction: build_phase

task baud_rate_checker::run_phase(uvm_phase phase);

  clk_count = 0;
  div_errors = 0;

  fork
    count_clocks();
    monitor_baudout();
    monitor_apb();
  join

endtask: run_phase

task baud_rate_checker::count_clocks();
  forever begin
    @(posedge IRQ.CLK);
    clk_count++;
  end
endtask: count_clocks

function void baud_rate_checker::check_count(bit[15:0] div, int clk_count);
  if(clk_count != div) begin
    `uvm_error("check_count", $sformatf("Baudrate divisor error - Divisor:%0d Clock interval:%0d", div, clk_count))
    div_errors++;
  end
  else begin
    baud_rate_cg.sample(div);
  end
endfunction: check_count

task baud_rate_checker::monitor_baudout();

  forever begin
    @(posedge IRQ.baud_out);
    if((new_value_written == 0) && (br_value_invalid == 0)) begin
      div1 = rm.DIV1.DIV.get_mirrored_value();
      div2 = rm.DIV2.DIV.get_mirrored_value();
      div = {div2[7:0], div1[7:0]};
      check_count(div, clk_count);
    end
    new_value_written = 0;
    clk_count = 0;
  end

endtask: monitor_baudout

task baud_rate_checker::monitor_apb();
  apb_seq_item apb;

  forever begin
    apb_fifo.get(apb);
    if(apb.we == 1) begin
      case(apb.addr[7:0])
        8'h1c: begin
                 new_value_written = 1;
                 br_value_invalid = 0;
               end
        8'h20: br_value_invalid = 1;
      endcase
    end
  end

endtask: monitor_apb


function void baud_rate_checker::report_phase(uvm_phase phase);
  if(div_errors == 0) begin
    `uvm_info("report_phase", "No baud rate errors detected", UVM_LOW)
  end
  else begin
    `uvm_error("report_phase", $sformatf("%0d baud rate errors detected", div_errors))
  end
endfunction: report_phase
