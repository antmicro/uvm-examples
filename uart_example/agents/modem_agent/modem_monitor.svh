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

 //
 //
class modem_monitor extends uvm_component;

  `uvm_component_utils(modem_monitor)

  uvm_analysis_port #(modem_seq_item) ap;

  virtual modem_if MODEM;

  function new(string name = "modem_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    ap = new("analysis_port", this);
  endfunction : build_phase


  task run_phase(uvm_phase phase);
    modem_seq_item t;
    modem_seq_item cloned_item;


  t = new("Modem analysis transaction");
    fork
      forever
      begin
        @(MODEM.nRTS, MODEM.nDTR, MODEM.OUT1, MODEM.OUT2)
        @(posedge MODEM.CLK);
        @(posedge MODEM.CLK);
        t.modem_bits[6] = MODEM.OUT1;
        t.modem_bits[7] = MODEM.OUT2;
        t.modem_bits[5] = MODEM.nRTS;
        t.modem_bits[3] = MODEM.nDTR;
        t.status = 0;
        ap.write(t);
      end
      forever
      begin
        @(MODEM.nCTS, MODEM.nDSR, MODEM.nRI, MODEM.nDCD)
        @(posedge MODEM.CLK);
        @(posedge MODEM.CLK);
        t.modem_bits[4] = MODEM.nCTS;
        t.modem_bits[2] = MODEM.nDSR;
        t.modem_bits[1] = MODEM.nRI;
        t.modem_bits[0] = MODEM.nDCD;
        t.status = 1;
        $cast(cloned_item, t.clone());
        ap.write(cloned_item);
      end
    join
  endtask : run_phase

 endclass: modem_monitor



