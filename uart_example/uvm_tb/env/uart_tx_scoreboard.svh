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

class uart_tx_scoreboard extends uvm_component;

`uvm_component_utils(uart_tx_scoreboard)

uvm_tlm_analysis_fifo #(apb_seq_item) apb_fifo;
uvm_tlm_analysis_fifo #(uart_seq_item) uart_fifo;
uvm_analysis_port #(lcr_item) ap;

uart_reg_block rm;

int no_chars_written;
int no_chars_tx;
int no_data_errors;
int no_errors;

bit[7:0] data_q[$];

extern function new(string name = "uart_tx_scoreboard", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task monitor_apb;
extern task monitor_uart;
extern function void report_phase(uvm_phase phase);

endclass: uart_tx_scoreboard

function uart_tx_scoreboard::new(string name = "uart_tx_scoreboard", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void uart_tx_scoreboard::build_phase(uvm_phase phase);
  apb_fifo = new("apb_fifo", this);
  uart_fifo = new("uart_fifo", this);
  ap = new("ap", this);
endfunction: build_phase

task uart_tx_scoreboard::run_phase(uvm_phase phase);
  no_chars_written = 0;
  no_chars_tx = 0;
  no_data_errors = 0;
  no_errors = 0;

  fork
    monitor_apb;
    monitor_uart;
  join

endtask: run_phase

task uart_tx_scoreboard::monitor_apb;
  apb_seq_item host_req;
  forever begin
    apb_fifo.get(host_req);
    if((host_req.addr == 0) && (host_req.we == 1)) begin
      data_q.push_back(host_req.data);
      no_chars_written++;
    end
  end
endtask: monitor_apb

task uart_tx_scoreboard::monitor_uart;
  uart_seq_item uart_item;
  bit[7:0] data;
  uvm_reg_data_t WL;
  lcr_item report_item;

  forever begin
    uart_fifo.get(uart_item);
    no_chars_tx++;
    WL = rm.LCR.get();
    if(uart_item.pe || uart_item.fe) begin
      `uvm_error("monitor_uart", $sformatf("TX Data error detected: PE:%0b FE:%0b LCR:%0h", uart_item.pe, uart_item.fe, WL[7:0]))
      no_errors++;
    end
    if(data_q.size() > 0) begin
      data = data_q.pop_front();
    end
    case(WL[1:0])
      2'b00: begin
               if(data[4:0] != uart_item.data[4:0]) begin
                 no_data_errors++;
                 `uvm_error("monitor_uart", $sformatf("Error in observed UART TX data expected:%0h actual:%0h LCR:%0h", data[4:0], uart_item.data[4:0], WL[7:0]))
               end
             end
      2'b01: begin
               if(data[5:0] != uart_item.data[5:0]) begin
                 no_data_errors++;
                 `uvm_error("monitor_uart", $sformatf("Error in observed UART TX data expected:%0h actual:%0h LCR:%0h", data[5:0], uart_item.data[5:0], WL[7:0]))
               end
             end
      2'b10: begin
               if(data[6:0] != uart_item.data[6:0]) begin
                 no_data_errors++;
                 `uvm_error("monitor_uart", $sformatf("Error in observed UART TX data expected:%0h actual:%0h LCR:%0h", data[6:0], uart_item.data[6:0], WL[7:0]))
               end
             end
      2'b11: begin
               if(data[7:0] != uart_item.data[7:0]) begin
                 no_data_errors++;
                 `uvm_error("monitor_uart", $sformatf("Error in observed UART TX data expected:%0h actual:%0h LCR:%0h", data[7:0], uart_item.data[7:0], WL[7:0]))
               end
             end
    endcase
    report_item = lcr_item::type_id::create("lcr_item");
    report_item.lcr = WL[6:0];
    ap.write(report_item);
  end

  endtask: monitor_uart

function void uart_tx_scoreboard::report_phase(uvm_phase phase);

  if((no_errors == 0) && (no_data_errors == 0)) begin
    `uvm_info("report_phase", $sformatf("%0d characters transmitted from the UART with no errors", no_chars_written), UVM_LOW)
  end
  if(no_errors != 0) begin
    `uvm_error("report_phase", $sformatf("%0d characters transmitted with errors from %0d transmitted overall", no_errors, no_chars_written))
  end
  if(no_data_errors != 0) begin
    `uvm_error("report_phase", $sformatf("%0d characters transmitted with data_errors from %0d transmitted overall", no_data_errors, no_chars_written))
  end

endfunction: report_phase