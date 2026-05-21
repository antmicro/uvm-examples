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
class uart_env_config extends uvm_object;

`uvm_object_utils(uart_env_config);

apb_agent_config m_apb_agent_cfg;
uart_agent_config m_tx_uart_agent_cfg;
uart_agent_config m_rx_uart_agent_cfg;
modem_config m_modem_agent_cfg;

uart_reg_block rm;

virtual interrupt_if IRQ;

function new(string name = "uart_env_config");
  super.new(name);
endfunction

extern task wait_for_interrupt();
extern function bit get_interrupt_level();
extern task wait_for_clock(int n = 1);
extern task wait_for_baud_rate();

endclass: uart_env_config

task uart_env_config::wait_for_interrupt();
    @(posedge IRQ.IRQ);
endtask: wait_for_interrupt

function bit uart_env_config::get_interrupt_level();
  if(IRQ.IRQ == 1)
    return 1;
  else
    return 0;
endfunction: get_interrupt_level

task uart_env_config::wait_for_clock(int n = 1);
  repeat(n)
    @(posedge IRQ.CLK);
endtask: wait_for_clock

task uart_env_config::wait_for_baud_rate();
  @(posedge IRQ.baud_out);
endtask: wait_for_baud_rate