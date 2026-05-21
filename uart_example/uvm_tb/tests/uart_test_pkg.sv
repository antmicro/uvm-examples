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

package uart_test_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import uart_reg_pkg::*;
import uart_agent_pkg::*;
import apb_agent_pkg::*;
import modem_agent_pkg::*;

import uart_env_pkg::*;
import uart_vseq_pkg::*;
import host_if_seq_pkg::*;

`include "uart_test_base.svh"
`include "uart_test.svh"
`include "word_format_poll_test.svh"
`include "modem_poll_test.svh"
`include "word_format_int_test.svh"
`include "modem_int_test.svh"
`include "rx_errors_int_test.svh"
`include "baud_rate_test.svh"

endpackage: uart_test_pkg