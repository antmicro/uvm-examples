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

class uart_test_base extends uvm_test;

`uvm_component_utils(uart_test_base)

uart_env m_env;
uart_env_config m_env_cfg;
uart_reg_block rm;

uart_agent_config m_tx_uart_cfg;
uart_agent_config m_rx_uart_cfg;
apb_agent_config m_apb_cfg;
modem_config m_modem_cfg;


extern function new(string name = "uart_test_base", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void init_vseq(uart_vseq_base vseq);

endclass: uart_test_base

function uart_test_base::new(string name = "uart_test_base", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void uart_test_base::build_phase(uvm_phase phase);
  m_env_cfg = uart_env_config::type_id::create("m_env_cfg");

  rm = uart_reg_block::type_id::create("rm");
  rm.build();
  m_env_cfg.rm = rm;

  m_apb_cfg = apb_agent_config::type_id::create("m_apb_cfg");
  if(!uvm_config_db #(virtual apb_if)::get(this, "", "APB", m_apb_cfg.APB)) begin
    `uvm_error("build_phase", "Unable to find APB interface in the uvm_config_db")
  end
  m_env_cfg.m_apb_agent_cfg = m_apb_cfg;
  m_apb_cfg.start_address[0] = 0;
  m_apb_cfg.range[0] = 32'h30;
  m_tx_uart_cfg = uart_agent_config::type_id::create("m_tx_uart_cfg");
  if(!uvm_config_db #(virtual serial_if)::get(this, "", "TX_UART", m_tx_uart_cfg.sline)) begin
    `uvm_error("build_phase", "Unable to find UART interface in the uvm_config_db")
  end
  m_tx_uart_cfg.ACTIVE = 0;
  m_env_cfg.m_tx_uart_agent_cfg = m_tx_uart_cfg;
  m_rx_uart_cfg = uart_agent_config::type_id::create("m_rx_uart_cfg");
  if(!uvm_config_db #(virtual serial_if)::get(this, "", "RX_UART", m_rx_uart_cfg.sline)) begin
    `uvm_error("build_phase", "Unable to find UART interface in the uvm_config_db")
  end
  m_env_cfg.m_rx_uart_agent_cfg = m_rx_uart_cfg;
  if(!uvm_config_db #(virtual interrupt_if)::get(this, "", "IRQ", m_env_cfg.IRQ)) begin
    `uvm_error("build_phase", "Unable to find IRQ interface in the uvm_config_db")
  end
  m_modem_cfg = modem_config::type_id::create("m_modem_cfg");
  if(!uvm_config_db #(virtual modem_if)::get(this, "", "MODEM", m_modem_cfg.mif)) begin
    `uvm_error("build_phase", "Unable to find MODEM interface in the uvm_config_db")
  end
  m_env_cfg.m_modem_agent_cfg = m_modem_cfg;
  m_env = uart_env::type_id::create("m_env", this);
  uvm_config_db #(uart_env_config)::set(this, "m_env*", "uart_env_config", m_env_cfg);
endfunction: build_phase

function void uart_test_base::init_vseq(uart_vseq_base vseq);
  vseq.apb = m_env.m_apb_agent.m_sequencer;
  vseq.uart = m_env.m_rx_uart_agent.m_uart_sequencer;
  vseq.modem = m_env.m_modem_agent.m_sequencer;
  vseq.rm = rm;
  vseq.tx_uart_config = m_tx_uart_cfg;
  vseq.rx_uart_config = m_rx_uart_cfg;
  vseq.cfg = m_env_cfg;
endfunction: init_vseq