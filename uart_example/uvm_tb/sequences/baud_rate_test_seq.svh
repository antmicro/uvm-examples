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

class baud_rate_test_seq extends host_if_base_seq;

rand bit[15:0] div;

`uvm_object_utils(baud_rate_test_seq)

constraint div_value {
  div inside {16'h1, 16'h2, 16'h4, 16'h8,
              16'h10, 16'h20, 16'h40, 16'h80,
              16'h100, 16'h200, 16'h400, 16'h800,
              16'h1000, 16'h2000, 16'h4000, 16'h8000,
              16'hfffe, 16'hfffd, 16'hfffb, 16'hfff7,
              16'hffef, 16'hffdf, 16'hffbf, 16'hff7f,
              16'hfeff, 16'hfdff, 16'hfbff, 16'hf7ff,
              16'hefff, 16'hdfff, 16'hbfff, 16'h7fff,
              16'h00ff, 16'hff00, 16'hffff};
}

function new(string name = "baud_rate_test_seq");
  super.new(name);
endfunction

task body;

  super.body();
  repeat(150) begin
    assert(this.randomize());
    data = {'0, div[15:8]};
    rm.DIV2.write(status, data, .parent(this));
    data = {'0, div[7:0]};
    rm.DIV1.write(status, data, .parent(this));
    repeat(2) begin
      cfg.wait_for_baud_rate();
    end
    cfg.wait_for_clock(10);
  end

endtask: body


endclass: baud_rate_test_seq