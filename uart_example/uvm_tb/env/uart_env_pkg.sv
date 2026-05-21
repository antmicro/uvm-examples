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

package uart_env_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_agent_pkg::*;
import uart_agent_pkg::*;
import modem_agent_pkg::*;
import uart_reg_pkg::*;

`include "uart_env_config.svh"
`include "lcr_item.svh"

`include "uart_tx_scoreboard.svh"
`include "uart_rx_scoreboard.svh"
`include "uart_modem_scoreboard.svh"
`include "uart_interrupt_coverage_monitor.svh"
`include "uart_tx_coverage_monitor.svh"
`include "uart_rx_coverage_monitor.svh"
`include "uart_modem_coverage_monitor.svh"
`include "baud_rate_checker.svh"
`include "uart_reg_access_coverage_monitor.svh"

`include "uart_env.svh"

endpackage: uart_env_pkg