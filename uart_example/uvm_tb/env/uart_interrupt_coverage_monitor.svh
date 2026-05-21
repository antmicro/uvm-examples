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
class uart_interrupt_coverage_monitor extends uvm_component;

`uvm_component_utils(uart_interrupt_coverage_monitor)

uvm_tlm_analysis_fifo #(apb_seq_item) apb_fifo;

uart_reg_block rm;
uart_env_config cfg;

uvm_reg_data_t data;

covergroup tx_word_format_int_cg() with function sample(bit[5:0] lcr);

  option.name = "tx_word_format_interrupt";
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

endgroup: tx_word_format_int_cg

covergroup rx_word_format_int_cg() with function sample(bit[5:0] lcr, bit[1:0] fcr);

  option.name = "rx_word_format_interrupt";
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

  FCR: coverpoint fcr {
    bins one = {0};
    bins four = {1};
    bins eight = {2};
    bins fourteen = {3};
  }

  WORD_FORMAT: cross WORD_LENGTH, STOP_BITS, PARITY, FCR;

endgroup: rx_word_format_int_cg

covergroup rx_status_word_format_int_cg() with function sample(bit[5:0] lcr);

  option.name = "rx_status_word_format_interrupt";
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

endgroup: rx_status_word_format_int_cg

covergroup rx_timeout_word_format_int_cg() with function sample(bit[5:0] lcr);

  option.name = "rx_timeout_word_format_interrupt";
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

endgroup: rx_timeout_word_format_int_cg

covergroup int_enable_cg() with function sample(bit[3:0] en);

  option.name = "interrupt_enable";
  option.per_instance = 1;

  INT_SOURCE: coverpoint en {
    bins rx_data_only = {4'b0001};
    bins tx_data_only = {4'b0010};
    bins rx_status_only = {4'b0100};
    bins modem_status_only = {4'b1000};
    bins rx_tx_data = {4'b0011};
    bins rx_status_rx_data = {4'b0101};
    bins rx_status_tx_data = {4'b0110};
    bins rx_status_rx_tx_data = {4'b0111};
    bins modem_status_rx_data = {4'b1001};
    bins modem_status_tx_data = {4'b1010};
    bins modem_status_rx_tx_data = {4'b1011};
    bins modem_status_rx_status = {4'b1100};
    bins modem_status_rx_status_rx_data = {4'b1101};
    bins modem_status_rx_status_tx_data = {4'b1110};
    bins modem_status_rx_status_rx_tx_data = {4'b1111};
    illegal_bins no_enables = {0}; // If we get an interrupt with no enables its an error
  }

endgroup: int_enable_cg

covergroup int_enable_src_cg() with function sample(bit[3:0] en, bit[3:0] src);

  option.name = "interrupt_enable_and_source";
  option.per_instance = 1;

  IIR: coverpoint src {
    bins rx_status = {6};
    bins rx_data = {4};
    bins timeout = {4'hc};
    bins tx_data = {2};
    bins modem_status = {0};
    ignore_bins no_ints = {1};
    illegal_bins invalid_src = default;
  }

  IEN: coverpoint en {
    bins rx_data_only = {4'b0001};
    bins tx_data_only = {4'b0010};
    bins rx_status_only = {4'b0100};
    bins modem_status_only = {4'b1000};
    bins rx_tx_data = {4'b0011};
    bins rx_status_rx_data = {4'b0101};
    bins rx_status_tx_data = {4'b0110};
    bins rx_status_rx_tx_data = {4'b0111};
    bins modem_status_rx_data = {4'b1001};
    bins modem_status_tx_data = {4'b1010};
    bins modem_status_rx_tx_data = {4'b1011};
    bins modem_status_rx_status = {4'b1100};
    bins modem_status_rx_status_rx_data = {4'b1101};
    bins modem_status_rx_status_tx_data = {4'b1110};
    bins modem_status_rx_status_rx_tx_data = {4'b1111};
    illegal_bins no_enables = {0}; // If we get an interrupt with no enables its an error
  }

  ID_IEN: cross IIR, IEN {
    ignore_bins rx_not_enabled = binsof(IEN) intersect{4'b0010, 4'b0100, 4'b0110, 4'b1000, 4'b1010, 4'b1100, 4'b1110} && binsof(IIR) intersect{4};
    ignore_bins tx_not_enabled = binsof(IEN) intersect{4'b0001, 4'b0100, 4'b0101, 4'b1000, 4'b1001, 4'b1100, 4'b1101} && binsof(IIR) intersect{2};
    ignore_bins rx_line_status_not_enabled = binsof(IEN) intersect{4'b0001, 4'b0010, 4'b0011, 4'b1000, 4'b1001, 4'b1010, 4'b1011} && binsof(IIR) intersect{4'hc, 6};
    ignore_bins modem_status_not_enabled = binsof(IEN) intersect{4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111} && binsof(IIR) intersect{0};
  }

endgroup: int_enable_src_cg

covergroup modem_int_src_cg() with function sample(bit[4:0] src);

  option.name = "modem_int_src_cg";
  option.per_instance = 1;

  MODEM_INT_SRC: coverpoint src[3:0] {
    wildcard bins dcts = {4'b???1};
    wildcard bins ddsr = {4'b??1?};
    wildcard bins teri = {4'b?1??};
    wildcard bins ddcd = {4'b1???};
    illegal_bins error = {0};
  }

  LOOPBACK: coverpoint src[4] {
    bins no_loopback = {0};
    bins loopback = {1};
  }

  MODEM_INT_CAUSE: cross MODEM_INT_SRC, LOOPBACK;

endgroup: modem_int_src_cg

covergroup lsr_int_src_cg() with function sample(bit[7:0] lsr);

  option.name = "lsr_int_src_cg";
  option.per_instance = 1;

  LINE_STATUS_SRC: coverpoint lsr[4:1] {
    bins oe_only = {4'b0001};
    bins pe_only = {4'b0010};
    bins fe_only = {4'b0100};
    bins bi_only = {4'b1000, 4'b1100, 4'b1010, 4'b1100}; // BI active discounts pe & fe
    bins bi_oe = {4'b1001, 4'b1101, 4'b1011, 4'b1101}; // BI active discounts pe & fe
    bins oe_pe = {4'b0011};
    bins oe_fe = {4'b0101};
    bins fe_pe = {4'b0110};
    bins no_ints = {0};
  }

endgroup: lsr_int_src_cg

extern function new(string name = "uart_interrupt_coverage_monitor", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task monitor_int_enable;
extern task monitor_int_src;

endclass: uart_interrupt_coverage_monitor

function uart_interrupt_coverage_monitor::new(string name = "uart_interrupt_coverage_monitor", uvm_component parent = null);
  super.new(name, parent);
  tx_word_format_int_cg = new();
  rx_word_format_int_cg = new();
  int_enable_cg = new();
  int_enable_src_cg = new();
  modem_int_src_cg = new();
  lsr_int_src_cg = new();
endfunction

function void uart_interrupt_coverage_monitor::build_phase(uvm_phase phase);
  apb_fifo = new("apb_fifo", this);
endfunction: build_phase

task uart_interrupt_coverage_monitor::run_phase(uvm_phase phase);

fork
  monitor_int_enable;
  monitor_int_src;
join

endtask: run_phase

task uart_interrupt_coverage_monitor::monitor_int_enable;

  forever begin
    cfg.wait_for_interrupt();
    data = rm.IER.get_mirrored_value();
    int_enable_cg.sample(data[3:0]);
  end

endtask: monitor_int_enable

task uart_interrupt_coverage_monitor::monitor_int_src;
  apb_seq_item req;
  bit[3:0] ien;
  bit[5:0] lcr;

  forever begin
    cfg.wait_for_interrupt();
    apb_fifo.get(req);
    if((req.addr[7:0] != 8'h8) || (req.we)) begin
      while((req.addr[7:0] != 8'h8) || (req.we)) begin
        apb_fifo.get(req);
      end
    end
    data = rm.LCR.get();
    lcr = data[5:0];
    data = rm.IER.get(); // get the enable info
    ien = data[3:0];
//    $display("interrupt_cov_monitor: @%0h ien:%0h iir:%0h", req.addr[7:0], ien, req.data[3:0]);
    case(req.data[3:0])
      4'b0010: begin
                 tx_word_format_int_cg.sample(lcr);
               end
      4'b0100: begin
                 data = rm.FCR.get();
                 rx_word_format_int_cg.sample(lcr, data[7:6]);
               end
      4'b0110: begin
                 rx_status_word_format_int_cg.sample(lcr);
               end
      4'b1100: begin
                 rx_timeout_word_format_int_cg.sample(lcr);
               end
    endcase
    int_enable_src_cg.sample(ien, req.data[3:0]);
    // Check for the cause of the modem status interrupt
    if(req.data[3:0] == 0) begin
      apb_fifo.get(req);
      if(req.addr[7:0] != 8'h18) begin
        while(req.addr[7:0] != 8'h18) begin
          apb_fifo.get(req);
        end
      end
      data = rm.MCR.get();
      modem_int_src_cg.sample({data[4], req.data[3:0]});
    end
    // Check for the source of the line status interrupt
    if(req.data[3:0] == 4'h6) begin
      apb_fifo.get(req);
      if(req.addr[7:0] != 8'h14) begin
        while(req.addr[7:0] != 8'h14) begin
          apb_fifo.get(req);
        end
        data = req.data;
        lsr_int_src_cg.sample(data[7:0]);
      end
    end
  end

endtask: monitor_int_src

