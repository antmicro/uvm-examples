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

class uart_vseq_base extends uvm_sequence #(modem_seq_item);

`uvm_object_utils(uart_vseq_base)

apb_sequencer apb;
uart_sequencer uart;
modem_sequencer modem;
uart_env_config cfg;

uart_agent_config tx_uart_config;
uart_agent_config rx_uart_config;

uart_reg_block rm;

function new(string name = "uart_vseq_base");
  super.new(name);
endfunction

endclass: uart_vseq_base