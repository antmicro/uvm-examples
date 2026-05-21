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
class uart_env extends uvm_component;

`uvm_component_utils(uart_env)

uart_env_config m_cfg;

apb_agent m_apb_agent;
uart_agent m_tx_uart_agent;
uart_agent m_rx_uart_agent;
modem_agent m_modem_agent;

uart_tx_scoreboard tx_sb;
uart_rx_scoreboard rx_sb;
uart_modem_scoreboard modem_sb;
uart_tx_coverage_monitor tx_cov;
uart_rx_coverage_monitor rx_cov;
uart_interrupt_coverage_monitor int_cov;
uart_modem_coverage_monitor modem_cov;
baud_rate_checker br_sb;
uart_reg_access_coverage_monitor reg_cov;

reg2apb_adapter reg_adapter;
uvm_reg_predictor #(apb_seq_item) reg_predictor;

extern function new(string name = "uart_env", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: uart_env

function uart_env::new(string name = "uart_env", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void uart_env::build_phase(uvm_phase phase);
  if(!uvm_config_db #(uart_env_config)::get(this, "", "uart_env_config", m_cfg)) begin
    `uvm_error("build_phase", "Unable to get uart_env_config from uvm_config_db")
  end
  m_apb_agent = apb_agent::type_id::create("m_apb_agent", this);
  uvm_config_db #(apb_agent_config)::set(this, "m_apb_agent*", "apb_agent_config", m_cfg.m_apb_agent_cfg);
  m_tx_uart_agent = uart_agent::type_id::create("m_tx_uart_agent", this);
  uvm_config_db #(uart_agent_config)::set(this, "m_tx_uart_agent*", "uart_agent_config", m_cfg.m_tx_uart_agent_cfg);
  m_rx_uart_agent = uart_agent::type_id::create("m_rx_uart_agent", this);
  uvm_config_db #(uart_agent_config)::set(this, "m_rx_uart_agent*", "uart_agent_config", m_cfg.m_rx_uart_agent_cfg);
  m_modem_agent = modem_agent::type_id::create("m_modem_agent", this);
  uvm_config_db #(modem_config)::set(this, "m_modem_agent*", "modem_config", m_cfg.m_modem_agent_cfg);
  reg_predictor = uvm_reg_predictor #(apb_seq_item)::type_id::create("reg_predictor", this);
  reg_adapter = reg2apb_adapter::type_id::create("reg_adapter");
  // Analysis components:
  tx_sb = uart_tx_scoreboard::type_id::create("tx_sb", this);
  rx_sb = uart_rx_scoreboard::type_id::create("rx_sb", this);
  modem_sb = uart_modem_scoreboard::type_id::create("modem_sb", this);
  tx_cov = uart_tx_coverage_monitor::type_id::create("tx_cov", this);
  rx_cov = uart_rx_coverage_monitor::type_id::create("rx_cov", this);
  int_cov = uart_interrupt_coverage_monitor::type_id::create("int_cov", this);
  modem_cov = uart_modem_coverage_monitor::type_id::create("modem_cov", this);
  br_sb = baud_rate_checker::type_id::create("br_sb", this);
  reg_cov = uart_reg_access_coverage_monitor::type_id::create("reg_cov", this);
endfunction: build_phase

function void uart_env::connect_phase(uvm_phase phase);
  // Register model connections
  m_cfg.rm.map.set_sequencer(m_apb_agent.m_sequencer, reg_adapter);
  reg_predictor.map = m_cfg.rm.map;
  reg_predictor.adapter = reg_adapter;
  m_apb_agent.ap.connect(reg_predictor.bus_in);
  // Analysis component connections:
  m_apb_agent.ap.connect(tx_sb.apb_fifo.analysis_export);
  m_tx_uart_agent.ap.connect(tx_sb.uart_fifo.analysis_export);
  tx_sb.rm = m_cfg.rm;
  m_apb_agent.ap.connect(rx_sb.apb_fifo.analysis_export);
  m_rx_uart_agent.ap.connect(rx_sb.uart_fifo.analysis_export);
  rx_sb.rm = m_cfg.rm;
  m_apb_agent.ap.connect(modem_sb.apb_fifo.analysis_export);
  m_modem_agent.ap.connect(modem_sb.modem_fifo.analysis_export);
  tx_sb.ap.connect(tx_cov.analysis_export);
  m_apb_agent.ap.connect(int_cov.apb_fifo.analysis_export);
  int_cov.cfg = m_cfg;
  int_cov.rm = m_cfg.rm;
  modem_cov.rm = m_cfg.rm;
  m_apb_agent.ap.connect(modem_cov.analysis_export);
  rx_sb.ap.connect(rx_cov.analysis_export);
  br_sb.rm = m_cfg.rm;
  br_sb.IRQ = m_cfg.IRQ;
  m_apb_agent.ap.connect(br_sb.apb_fifo.analysis_export);
  m_apb_agent.ap.connect(reg_cov.analysis_export);
endfunction: connect_phase