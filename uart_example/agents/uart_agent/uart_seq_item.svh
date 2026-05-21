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

class uart_seq_item extends uvm_sequence_item;

`uvm_object_utils(uart_seq_item)

rand int delay;
rand bit sbe;
rand int sbe_clks;
rand bit[7:0] data;
rand bit fe;
rand bit[7:0] lcr;
rand bit pe;
rand bit[15:0] baud_divisor;

constraint BR_DIVIDE {baud_divisor == 16'h02;}

constraint error_dists {fe dist {1:= 1, 0:=99};
                        pe dist {1:= 1, 0:=99};
                        sbe dist {1:=1, 0:=50};}

constraint clks {delay inside {[0:20]};
                 sbe_clks inside {[1:4]};}

constraint lcr_setup {lcr == 8'h3f;}

// Standard UVM Methods:
extern function new(string name = "uart_seq_item");
extern function void do_copy(uvm_object rhs);
extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
extern function string convert2string();
extern function void do_print(uvm_printer printer);
extern function void do_record(uvm_recorder recorder);


endclass: uart_seq_item

function uart_seq_item::new(string name = "uart_seq_item");
  super.new(name);
endfunction


function void uart_seq_item::do_copy(uvm_object rhs);
  uart_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_fatal("do_copy", "cast of rhs object failed")
  end
  super.do_copy(rhs);
  // Copy over data members:
  delay = rhs_.delay;
  sbe = rhs_.sbe;
  sbe_clks = rhs_.sbe_clks;
  data = rhs_.data;
  fe = rhs_.fe;
  lcr = rhs_.lcr;
  pe = rhs_.pe;
  baud_divisor = rhs_.baud_divisor;

endfunction:do_copy

function bit uart_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  uart_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_copy", "cast of rhs object failed")
    return 0;
  end
  return super.do_compare(rhs, comparer) &&
         delay == rhs_.delay &&
         sbe == rhs_.sbe &&
         sbe_clks == rhs_.sbe_clks &&
         data == rhs_.data &&
         fe == rhs_.fe &&
         lcr == rhs_.lcr &&
         pe == rhs_.pe &&
         baud_divisor == rhs_.baud_divisor;

endfunction:do_compare

function string uart_seq_item::convert2string();
  string s;

  $sformat(s, "%s\n", super.convert2string());
  // Convert to string function reusing s:
  $sformat(s, "%s\n delay\t%0d\n sbe\t%0b\n sbe_clks\t%0d\n data\t%0h\n", s, delay, sbe, sbe_clks, data);
  $sformat(s, "%s\n fe\t%0b\n lcr\t%0h\n pe\t%0b\n baud_divisor\t%0h\n", s, fe, lcr, pe, baud_divisor);
  return s;

endfunction:convert2string

function void uart_seq_item::do_print(uvm_printer printer);
  if(printer.knobs.sprint == 0) begin
    $display(convert2string());
  end
  else begin
    printer.m_string = convert2string();
  end
endfunction:do_print

function void uart_seq_item:: do_record(uvm_recorder recorder);
  super.do_record(recorder);

  // Use the record macros to record the item fields:
  `uvm_record_field("delay", delay)
  `uvm_record_field("sbe", sbe)
  `uvm_record_field("sbe_clks", sbe_clks)
  `uvm_record_field("data", data)
  `uvm_record_field("fe", fe)
  `uvm_record_field("lcr", lcr)
  `uvm_record_field("pe", pe)
  `uvm_record_field("baud_divisor", baud_divisor)

endfunction:do_record

