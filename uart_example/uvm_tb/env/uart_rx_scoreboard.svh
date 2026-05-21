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

class uart_rx_scoreboard extends uvm_component;

`uvm_component_utils(uart_rx_scoreboard)

uvm_tlm_analysis_fifo #(apb_seq_item) apb_fifo;
uvm_tlm_analysis_fifo #(uart_seq_item) uart_fifo;
uvm_analysis_port #(lcr_item) ap;

uart_reg_block rm;

int no_chars_written;
int no_data_errors;
int no_errors;
int no_reported_errors;

// Error handling
bit PE;
bit FE;
bit oe;
bit bi;

bit[9:0] data_q[$];

extern function new(string name = "uart_rx_scoreboard", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task monitor_apb;
extern task monitor_uart;
extern function void report_phase(uvm_phase phase);

endclass: uart_rx_scoreboard

function uart_rx_scoreboard::new(string name = "uart_rx_scoreboard", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void uart_rx_scoreboard::build_phase(uvm_phase phase);
  apb_fifo = new("apb_fifo", this);
  uart_fifo = new("uart_fifo", this);
  ap = new("ap", this);
endfunction: build_phase

task uart_rx_scoreboard::run_phase(uvm_phase phase);
  no_chars_written = 0;
  no_data_errors = 0;
  no_errors = 0;
  no_reported_errors = 0;

  fork
    monitor_apb;
    monitor_uart;
  join

endtask: run_phase

task uart_rx_scoreboard::monitor_apb;
  apb_seq_item host_req;
  bit[9:0] data;
  uvm_reg_data_t WL;
  lcr_item lcr = lcr_item::type_id::create("lcr");

  forever begin
    apb_fifo.get(host_req);
    if((host_req.addr == 0) && (host_req.we == 0)) begin
      WL = rm.LCR.get();
      if(data_q.size() > 0) begin
        data = data_q.pop_front();
        PE = data[9];
        FE = data[8];
      end
      if(data[9:8] != 0) begin
        `uvm_info("monitor_uart", $sformatf("RX Data error detected: PE:%0b FE:%0b LCR:%0h", data[9], data[8], WL[7:0]), UVM_LOW)
        no_errors++;
      end
      case(WL[1:0])
        2'b00: begin
                 if(data[4:0] != host_req.data[4:0]) begin
                   no_data_errors++;
                   `uvm_error("monitor_uart", $sformatf("Error in observed UART RX data expected:%0h actual:%0h LCR:%0h", data[4:0], host_req.data[4:0], WL[7:0]))
                 end
               end
        2'b01: begin
                 if(data[5:0] != host_req.data[5:0]) begin
                   no_data_errors++;
                   `uvm_error("monitor_uart", $sformatf("Error in observed UART RX data expected:%0h actual:%0h LCR:%0h", data[5:0], host_req.data[5:0], WL[7:0]))
                 end
               end
        2'b10: begin
                 if(data[6:0] != host_req.data[6:0]) begin
                   no_data_errors++;
                   `uvm_error("monitor_uart", $sformatf("Error in observed UART RX data expected:%0h actual:%0h LCR:%0h", data[6:0], host_req.data[6:0], WL[7:0]))
                 end
               end
        2'b11: begin
                 if(data[7:0] != host_req.data[7:0]) begin
                   no_data_errors++;
                   `uvm_error("monitor_uart", $sformatf("Error in observed UART RX data expected:%0h actual:%0h LCR:%0h", data[7:0], host_req.data[7:0], WL[7:0]))
                 end
               end
      endcase
      lcr.lcr = WL[5:0];
      ap.write(lcr);
    end
    else if((host_req.addr[7:0] == 8'h14) && (host_req.we == 0)) begin
      if(PE != host_req.data[2]) begin
        `uvm_error("monitor_uart", $sformatf("Error in LSR PE bit - expected:%0b actual:%0b", PE, host_req.data[2]))
        no_reported_errors++;
      end
      if(FE != host_req.data[3]) begin
        `uvm_error("monitor_uart", $sformatf("Error in LSR FE bit - expected:%0b actual:%0b", PE, host_req.data[3]))
        no_reported_errors++;
      end
      PE = 0;
      FE = 0;
    end
  end
endtask: monitor_apb

task uart_rx_scoreboard::monitor_uart;
  uart_seq_item uart_item;
  bit[7:0] data;

  forever begin
    uart_fifo.get(uart_item);
    data_q.push_back({uart_item.pe, uart_item.fe, uart_item.data});
    no_chars_written++;
  end
endtask: monitor_uart

function void uart_rx_scoreboard::report_phase(uvm_phase phase);

  if((no_reported_errors == 0) && (no_data_errors == 0)) begin
    `uvm_info("report_phase", $sformatf("%0d characters received by the UART with %0d inserted errors", no_chars_written, no_errors), UVM_LOW)
  end
  if(no_reported_errors != 0) begin
    `uvm_error("report_phase", $sformatf("%0d characters received with undetected errors from %0d received overall", no_reported_errors, no_chars_written))
  end
  if(no_data_errors != 0) begin
    `uvm_error("report_phase", $sformatf("%0d characters received with data_errors from %0d received overall", no_data_errors, no_chars_written))
  end

endfunction: report_phase