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

package modem_agent_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "modem_config.svh"
`include "modem_seq_item.svh"
`include "modem_driver.svh"
typedef uvm_sequencer #(modem_seq_item) modem_sequencer;
`include "modem_basic_sequence.svh"
`include "modem_monitor.svh"
`include "modem_coverage_monitor.svh"
`include "modem_agent.svh"


endpackage: modem_agent_pkg
