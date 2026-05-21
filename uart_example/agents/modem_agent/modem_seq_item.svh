//------------------------------------------------------------
//   Copyright 2012-13 Mentor Graphics Corporation
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
class modem_seq_item extends uvm_sequence_item;

`uvm_object_utils(modem_seq_item)

rand logic[7:0] modem_bits;
rand int delay;
bit status;
constraint delay_range {delay inside {[3:10]};}

// Standard UVM Methods:
extern function new(string name = "modem_seq_item");
extern function void do_copy(uvm_object rhs);
extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
extern function string convert2string();
extern function void do_print(uvm_printer printer);
extern function void do_record(uvm_recorder recorder);

endclass: modem_seq_item

function modem_seq_item::new(string name = "modem_seq_item");
    super.new(name);
endfunction

function void modem_seq_item::do_copy(uvm_object rhs);
  modem_seq_item rhs_;

    if(!$cast(rhs_, rhs)) begin
      `uvm_fatal("do_copy", "cast of rhs object failed")
    end
    super.do_copy(rhs);
    // Copy over data members:
    modem_bits = rhs_.modem_bits;
    delay = rhs_.delay;
    status = rhs_.status;

endfunction: do_copy

function bit modem_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  modem_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_copy", "cast of rhs object failed")
    return 0;
  end
  return super.do_compare(rhs, comparer) &&
         modem_bits == rhs_.modem_bits &&
         delay == rhs_.delay &&
         status   == rhs_.status;
endfunction:do_compare

function string modem_seq_item::convert2string();
  string s;

  $sformat(s, "%s\n", super.convert2string());
  // Convert to string function reusing s:
  $sformat(s, "%s\n modem_bits\t%0h\n delay\t%0d\n status\t%0b\n", s, modem_bits, delay, status);
  return s;

endfunction:convert2string

function void modem_seq_item::do_print(uvm_printer printer);
  if(printer.knobs.sprint == 0) begin
    $display(convert2string());
  end
  else begin
    printer.m_string = convert2string();
  end
endfunction:do_print

function void modem_seq_item:: do_record(uvm_recorder recorder);
  super.do_record(recorder);

  // Use the record macros to record the item fields:
  `uvm_record_field("modem_bits", modem_bits)
  `uvm_record_field("delay", delay)
  `uvm_record_field("status", status)

endfunction:do_record
