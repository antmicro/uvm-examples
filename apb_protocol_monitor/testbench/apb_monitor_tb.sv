//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
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
//
// The purpose of this testbench is to exercise the monitor
// as an illustration. It is not intended to be an exhaustive protocol check
//
module apb_monitor_tb;

// Testbench signals - i.e. the APB signals
logic PCLK;
logic PRESETn;
logic[31:0] PADDR;
logic[31:0] PWDATA;
logic[31:0] PRDATA;
logic[15:0] PSEL;
logic PENABLE;
logic PWRITE;
logic PREADY;
logic PSLVERR;

// Control signals:
bit[15:0] PSEL_v;

// APB Monitor - which is encapsulated within a SV interface:
apb_monitor #(.no_slaves(16), .addr_width(32), .data_width(32)) APB
  (
  .PCLK(PCLK),
  .PRESETn(PRESETn),
  .PADDR(PADDR),
  .PWDATA(PWDATA),
  .PRDATA(PRDATA),
  .PSEL(PSEL),
  .PWRITE(PWRITE),
  .PENABLE(PENABLE),
  .PREADY(PREADY),
  .PSLVERR(PSLVERR));

// APB - Put the bus into a safe state
task apb_park;
  @(posedge PCLK);
  PSEL <= 0;
  PENABLE <= 0;
  PADDR <= 0;
  PWRITE <= 1;
  PSLVERR <= 0;
  PREADY <= 0;
endtask: apb_park

// APB Write task - including responses
task apb_write(bit[15:0] PSEL_v);
  int response_delay;

  wait(PRESETn == 1);
  @(posedge PCLK);
  PSEL <= PSEL_v;
  PADDR <= $urandom();
  PWRITE <= 1;
  PWDATA <= $urandom();
  @(posedge PCLK);
  PENABLE <= 1;
  response_delay = $urandom_range(10, 0);
  repeat(response_delay) begin
    @(posedge PCLK);
  end
  @(negedge PCLK);
  PREADY <= 1;
  randcase
    1: PSLVERR <= 0;
    1: PSLVERR <= 1;
  endcase
  @(posedge PCLK);
  PENABLE <= 0;
  PREADY <= 0;

endtask: apb_write

// APB Read task - including responses
task apb_read(bit[15:0] PSEL_v);
  int response_delay;

  wait(PRESETn == 1);
  @(posedge PCLK);
  PSEL <= PSEL_v;
  PADDR <= $urandom();
  PWRITE <= 0;
  @(posedge PCLK);
  PENABLE <= 1;
  response_delay = $urandom_range(10, 0);
  repeat(response_delay) begin
    @(posedge PCLK);
  end
  @(negedge PCLK);
  PREADY <= 1;
  PRDATA <= $urandom();
  randcase
    1: PSLVERR <= 0;
    1: PSLVERR <= 1;
  endcase
  @(posedge PCLK);
  PENABLE <= 0;
  PREADY <= 0;

endtask: apb_read

// Clock and reset:
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

// Some stimulus based on the tasks:
initial begin
  PSEL = 0;
  apb_park;
  repeat(5) begin
    PSEL_v = 16'h1;
    repeat(16) begin
      apb_read(PSEL_v);
      PSEL_v = PSEL_v << 1;
    end
    PSEL_v = 16'h1;
    repeat(16) begin
      apb_write(PSEL_v);
      PSEL_v = PSEL_v << 1;
    end
    PSEL_v = 16'h8000;
    repeat(16) begin
      apb_write(PSEL_v);
      PSEL_v = PSEL_v >> 1;
      apb_park;
    end
    PSEL_v = 16'h8000;
    repeat(16) begin
      apb_read(PSEL_v);
      PSEL_v = PSEL_v >> 1;
      apb_park;
    end
  end
  if(APB.APB_accesses_cg.get_coverage() == 100) begin
    $display("[*** TEST PASSED ***] Monitor coverage attained");
  end
  else begin
    $display("[*** TEST FAILED ***] Monitor coverage not attained");
  end
  $finish;
end


endmodule: apb_monitor_tb