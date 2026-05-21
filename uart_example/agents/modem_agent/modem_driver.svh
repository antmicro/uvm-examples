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

 // Simplistic Modem Driver
 //
 //
 class modem_driver extends uvm_driver #(modem_seq_item, modem_seq_item);

 `uvm_component_utils(modem_driver)

 virtual modem_if MODEM;

 function new(string name = "modem_driver", uvm_component parent = null);
   super.new(name, parent);
 endfunction

 task run_phase(uvm_phase phase);

   MODEM.nCTS <= 0;
   MODEM.nDSR <= 0;
   MODEM.nRI <= 0;
   MODEM.nDCD <= 0;

   forever
     begin
       seq_item_port.get_next_item(req);
       repeat(req.delay) begin
         @(posedge MODEM.CLK);
       end
       MODEM.nCTS    <= req.modem_bits[4];
       MODEM.nDSR    <= req.modem_bits[2];
       MODEM.nRI     <= req.modem_bits[1];
       MODEM.nDCD    <= req.modem_bits[0];
       seq_item_port.item_done();

     end

 endtask: run_phase

 endclass: modem_driver
