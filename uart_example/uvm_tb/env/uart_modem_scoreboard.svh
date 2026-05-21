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

class uart_modem_scoreboard extends uvm_component;

`uvm_component_utils(uart_modem_scoreboard)

uvm_tlm_analysis_fifo #(apb_seq_item) apb_fifo;
uvm_tlm_analysis_fifo #(modem_seq_item) modem_fifo;

uart_reg_block rm;

bit RTS;
bit DTR;
bit OUT1;
bit OUT2;

bit loopback;
bit last_CTS;
bit last_DSR;
bit last_RI;
bit last_DCD;
bit delta_CTS;
bit delta_DSR;
bit trailing_RI;
bit delta_DCD;

int modem_status_reads;
int modem_status_errors;
int modem_output_errors;
int modem_output_writes;

extern function new(string name = "uart_modem_scoreboard", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task monitor_apb;
extern task monitor_modem;
extern function void report_phase(uvm_phase phase);

endclass: uart_modem_scoreboard

function uart_modem_scoreboard::new(string name = "uart_modem_scoreboard", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void uart_modem_scoreboard::build_phase(uvm_phase phase);
  apb_fifo = new("apb_fifo", this);
  modem_fifo = new("modem_fifo", this);
endfunction: build_phase

task uart_modem_scoreboard::run_phase(uvm_phase phase);

  modem_status_reads = 0;
  modem_status_errors = 0;
  modem_output_errors = 0;
  modem_output_writes = 0;

  fork
    monitor_apb;
    monitor_modem;
  join

endtask: run_phase

task uart_modem_scoreboard::monitor_apb;
  apb_seq_item req = apb_seq_item::type_id::create("req");

  forever begin
    apb_fifo.get(req);
    if(req.we == 1) begin
      if(req.addr == 'h10) begin
        DTR = req.data[0];
        RTS = req.data[1];
        OUT1 = req.data[2];
        OUT2 = req.data[3];
        loopback = req.data[4];
        modem_output_writes++;
      end
    end
    else begin // Read
      modem_status_reads++;
      if(req.addr == 'h18) begin
        if(req.data[0] != delta_CTS) begin
          `uvm_error("monitor_apb", "Error in the DCTS value read back from the MSR")
          modem_status_errors++;
        end
        if(req.data[1] != delta_DSR) begin
          `uvm_error("monitor_apb", "Error in the DDSR value read back from the MSR")
          modem_status_errors++;
        end
        if(req.data[2] != trailing_RI) begin
          `uvm_error("monitor_apb", "Error in the TERI value read back from the MSR")
          modem_status_errors++;
        end
        if(req.data[3] != delta_DCD) begin
          `uvm_error("monitor_apb", "Error in the DDCD value read back from the MSR")
          modem_status_errors++;
        end
        if(loopback == 0) begin
          if(req.data[4] != ~last_CTS) begin
            `uvm_error("monitor_apb", "Error in CTS value read back from the MSR")
            modem_status_errors++;
          end
          if(req.data[5] != ~last_DSR) begin
            `uvm_error("monitor_apb", "Error in DSR value read back from the MSR")
            modem_status_errors++;
          end
          if(req.data[6] != ~last_RI) begin
            `uvm_error("monitor_apb", "Error in RI value read back from the MSR")
            modem_status_errors++;
          end
          if(req.data[7] != ~last_DCD) begin
            `uvm_error("monitor_apb", "Error in DCD value read back from the MSR")
            modem_status_errors++;
          end
        end
        else begin
          if(req.data[4] != RTS) begin
            `uvm_error("monitor_apb", "Error in RTS value read back from the MSR")
            modem_status_errors++;
          end
          if(req.data[5] != DTR) begin
            `uvm_error("monitor_apb", "Error in DTR value read back from the MSR")
            modem_status_errors++;
          end
          if(req.data[6] != OUT1) begin
            `uvm_error("monitor_apb", "Error in OUT1 value read back from the MSR")
            modem_status_errors++;
          end
          if(req.data[7] != OUT2) begin
            `uvm_error("monitor_apb", "Error in OUT2 value read back from the MSR")
            modem_status_errors++;
          end
        end
        delta_CTS = 0;
        delta_DSR = 0;
        trailing_RI = 0;
        delta_DCD = 0;
      end
    end
  end

endtask: monitor_apb

task uart_modem_scoreboard::monitor_modem;
  modem_seq_item item;

  forever begin
    modem_fifo.get(item);
    if(item.modem_bits[0] != last_DCD) begin
      delta_DCD = 1;
    end
    if((item.modem_bits[1] == 0) && (last_RI == 1)) begin
      trailing_RI = 1;
    end
    if(item.modem_bits[2] != last_DSR) begin
      delta_DSR = 1;
    end
    if(item.modem_bits[4] != last_CTS) begin
      delta_CTS = 1;
    end
    if((loopback != 0) && (item.status == 0)) begin
      if(item.modem_bits[3] == DTR) begin
        `uvm_error("monitor_modem", $sformatf("DTR output does not match MCR value: %0b cf %0b", item.modem_bits[3], DTR))
        modem_output_errors++;
      end
      if(item.modem_bits[5] == RTS) begin
        `uvm_error("monitor_modem", $sformatf("RTS output does not match MCR value: %0b cf %0b", item.modem_bits[5], RTS))
        modem_output_errors++;
      end
      if(item.modem_bits[6] != OUT1) begin
        `uvm_error("monitor_modem", $sformatf("OUT1 output does not match MCR value: %0b cf %0b", item.modem_bits[6], OUT1))
        modem_output_errors++;
      end
      if(item.modem_bits[7] != OUT2) begin
        `uvm_error("monitor_modem", $sformatf("OUT2 output does not match MCR value: %0b cf %0b", item.modem_bits[7], OUT2))
        modem_output_errors++;
      end
    end
    last_DCD = item.modem_bits[0];
    last_RI = item.modem_bits[1];
    last_DSR = item.modem_bits[2];
    last_CTS = item.modem_bits[4];
  end

endtask: monitor_modem

function void uart_modem_scoreboard::report_phase(uvm_phase phase);

  if((modem_status_errors == 0) && (modem_output_errors == 0)) begin
    `uvm_info("uart_modem_scoreboard::report_phase", "No modem errors observed", UVM_LOW)
  end

  if(modem_status_errors != 0) begin
    `uvm_error("uart_modem_scoreboard::report_phase", $sformatf("%0d modem status errors occurred during %0d MSR reads", modem_status_errors, modem_status_reads))
  end

  if(modem_output_errors != 0) begin
    `uvm_error("uart_modem_scoreboard::report_phase", $sformatf("%0d modem control errors occurred during %0d MSR writes", modem_output_errors, modem_output_writes))
  end

endfunction: report_phase