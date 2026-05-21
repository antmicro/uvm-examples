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

module uart_tb;

import uvm_pkg::*;
import uart_test_pkg::*;

logic PCLK;
logic PRESETn;

apb_if APB(.PCLK(PCLK), .PRESETn(PRESETn));
serial_if RX_UART();
serial_if TX_UART();
modem_if MODEM();
interrupt_if IRQ();

// DUT - a 16550 UART:
uart_16550 DUT (
  // APB Signals
  .PCLK(PCLK),
  .PRESETn(PRESETn),
  .PADDR(APB.PADDR),
  .PWDATA(APB.PWDATA),
  .PRDATA(APB.PRDATA),
  .PWRITE(APB.PWRITE),
  .PENABLE(APB.PENABLE),
  .PSEL(APB.PSEL[0]),
  .PREADY(APB.PREADY),
  .PSLVERR(APB.PSLVERR),
  // UART interrupt request line
  .IRQ(IRQ.IRQ),
  // UART signals
  // serial input/output
  .TXD(TX_UART.sdata),
  .RXD(RX_UART.sdata),
  // modem signals
  .nRTS(MODEM.nRTS),
  .nDTR(MODEM.nDTR),
  .nOUT1(MODEM.OUT1),
  .nOUT2(MODEM.OUT2),
  .nCTS(MODEM.nCTS),
  .nDSR(MODEM.nDSR),
  .nDCD(MODEM.nDCD),
  .nRI(MODEM.nRI),
  // Baud rate generator output - needed for the divisor checks
  .baud_o(IRQ.baud_out)
  );

// APB Protocol Monitor:
apb_monitor #(.no_slaves(1), .addr_width(32), .data_width(32))
  APB_PROTOCOL_MONITOR
  (
  .PCLK(PCLK),
  .PRESETn(PRESETn),
  .PADDR(APB.PADDR),
  .PWDATA(APB.PWDATA),
  .PRDATA(APB.PRDATA),
  .PSEL(APB.PSEL[0]),
  .PWRITE(APB.PWRITE),
  .PENABLE(APB.PENABLE),
  .PREADY(APB.PREADY),
  .PSLVERR(APB.PSLVERR));



// UVM virtual interface handling and run_test()
initial begin
  uvm_config_db #(virtual apb_if)::set(null, "uvm_test_top", "APB", APB);
  uvm_config_db #(virtual serial_if)::set(null, "uvm_test_top", "RX_UART", RX_UART);
  uvm_config_db #(virtual serial_if)::set(null, "uvm_test_top", "TX_UART", TX_UART);
  uvm_config_db #(virtual modem_if)::set(null, "uvm_test_top", "MODEM", MODEM);
  uvm_config_db #(virtual interrupt_if)::set(null, "uvm_test_top", "IRQ", IRQ);
  run_test();
end


// Simple clock/reset
initial begin
  PCLK = 0;
  PRESETn = 0;
  repeat(10) begin
    #1ns PCLK = ~PCLK;
  end
  PRESETn = 1;
  forever begin
    #1ns PCLK = ~PCLK;
  end
end

// Some interface signal assignments:
assign IRQ.CLK = PCLK;
assign MODEM.CLK = PCLK;
assign RX_UART.clk = IRQ.baud_out;
assign TX_UART.clk = IRQ.baud_out;

endmodule: uart_tb