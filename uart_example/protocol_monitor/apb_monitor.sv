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
//
// APB Protocol Monitor
//
interface apb_monitor #(int no_slaves = 16, int addr_width = 32, int data_width = 32)
  (
  input PCLK,
  input PRESETn,
  input[addr_width-1:0] PADDR,
  input[data_width-1:0] PWDATA,
  input[data_width-1:0] PRDATA,
  input[no_slaves-1:0] PSEL,
  input PWRITE,
  input PENABLE,
  input PREADY,
  input PSLVERR);

// Check for unknown signal values:

// Reuseable property to check that a signal is in a safe state
property SIGNAL_VALID(signal);
  @(posedge PCLK)
  !$isunknown(signal);
endproperty: SIGNAL_VALID

RESET_VALID: assert property(SIGNAL_VALID(PRESETn));
PSEL_VALID: assert property(SIGNAL_VALID(PSEL));

// Reuseable property to check that if a PSEL is active, then
// the signal is valid
property CONTROL_SIGNAL_VALID(signal);
  @(posedge PCLK)
  $onehot(PSEL) |-> !$isunknown(signal);
endproperty: CONTROL_SIGNAL_VALID

PADDR_VALID: assert property(CONTROL_SIGNAL_VALID(PADDR));
PWRITE_VALID: assert property(CONTROL_SIGNAL_VALID(PWRITE));
PENABLE_VALID: assert property(CONTROL_SIGNAL_VALID(PENABLE));

// Check that write data is valid if a write
property PWDATA_SIGNAL_VALID;
  @(posedge PCLK)
  ($onehot(PSEL) && PWRITE) |-> !$isunknown(PWDATA);
endproperty: PWDATA_SIGNAL_VALID

PWDATA_VALID: assert property(PWDATA_SIGNAL_VALID);

// Check that if PENABLE is active, then the signal is valid
property PENABLE_SIGNAL_VALID(signal);
  @(posedge PCLK)
  $rose(PENABLE) |-> !$isunknown(signal)[*1:$] ##1 $fell(PENABLE);
endproperty: PENABLE_SIGNAL_VALID

PREADY_VALID: assert property(PENABLE_SIGNAL_VALID(PREADY));
PSLVERR_VALID: assert property(PENABLE_SIGNAL_VALID(PSLVERR));

// Check that read data is valid if a read
property PRDATA_SIGNAL_VALID;
  @(posedge PCLK)
  ($rose(PENABLE && !PWRITE && PREADY)) |-> !$isunknown(PRDATA)[*1:$] ##1 $fell(PENABLE);
endproperty: PRDATA_SIGNAL_VALID

//PRDATA_VALID: assert property(PRDATA_SIGNAL_VALID);

// Check that only one PSEL line is valid at a time:
property PSEL_ONEHOT0;
  @(posedge PCLK)
  $onehot0(PSEL);
endproperty: PSEL_ONEHOT0

PSEL_ONLY_ONE: assert property(PSEL_ONEHOT0);

// PENABLE goes low once PREADY is sampled
property PENABLE_DEASSERTED;
  @(posedge PCLK)
  $rose(PENABLE && PREADY) |=> !PENABLE;
endproperty: PENABLE_DEASSERTED

PENABLE_DEASSERT: assert property(PENABLE_DEASSERTED);

// From PSEL active to PENABLE active is 1 cycle
property PSEL_TO_PENABLE_ACTIVE;
  @(posedge PCLK)
  (!$stable(PSEL) && $onehot(PSEL)) |=> PENABLE;
endproperty: PSEL_TO_PENABLE_ACTIVE

PSEL_2_PENABLE: assert property(PSEL_TO_PENABLE_ACTIVE);

// FROM PSEL being active, then signal must be stable until end of cycle
property PSEL_ASSERT_SIGNAL_STABLE(signal);
  @(posedge PCLK)
  (!$stable(PSEL) && $onehot(PSEL)) |=> $stable(signal)[*1:$] ##1 $fell(PENABLE);
endproperty: PSEL_ASSERT_SIGNAL_STABLE

PSEL_STABLE: assert property(PSEL_ASSERT_SIGNAL_STABLE(PSEL));
PWRITE_STABLE: assert property(PSEL_ASSERT_SIGNAL_STABLE(PWRITE));
PADDR_STABLE: assert property(PSEL_ASSERT_SIGNAL_STABLE(PADDR));
PWDATA_STABLE: assert property(PSEL_ASSERT_SIGNAL_STABLE(PWDATA & PWRITE));

// Functional Coverage for the APB transfers:
//
// Have we seen all possible PSELS activated?
// Have we seen reads/writes to all slaves?
// Have we seen good and bad PSLVERR results from all slaves?
covergroup APB_accesses_cg();

option.per_instance = 1;

RW: coverpoint PWRITE {
  bins read = {0};
  bins write = {1};
}
ERR: coverpoint PSLVERR {
  bins err = {1};
  bins ok = {0};
}

APB_CVR: cross RW, ERR;

endgroup: APB_accesses_cg

// Array of these covergroups
APB_accesses_cg APB_protocol_cg[no_slaves];

// Creation the covergroups
initial begin
  foreach(APB_protocol_cg[i]) begin
    APB_protocol_cg[i] = new();
  end
end

// Sampling of the covergroups
sequence END_OF_APB_TRANSFER;
  @(posedge PCLK)
  $rose(PENABLE & PREADY);
endsequence: END_OF_APB_TRANSFER

cover property(END_OF_APB_TRANSFER) begin
  foreach(APB_protocol_cg[i]) begin
    if(PSEL[i] == 1) begin
      APB_protocol_cg[i].sample();
    end
  end
end

endinterface: apb_monitor