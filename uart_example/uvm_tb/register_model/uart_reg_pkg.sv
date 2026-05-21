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

package uart_reg_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class txd_reg extends uvm_reg;
  `uvm_object_utils(txd_reg)

  rand uvm_reg_field data;

  function new(string name = "txd_reg");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 8, 0, "WO", 0, 8'h0, 0, 1, 0);
  endfunction: build
endclass: txd_reg

class rxd_reg extends uvm_reg;
  `uvm_object_utils(rxd_reg)

  uvm_reg_field data;

  function new(string name = "rxd_reg");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 8, 0, "RO", 0, 8'h0, 0, 0, 0);
  endfunction: build
endclass: rxd_reg

class ier_reg extends uvm_reg;
  `uvm_object_utils(ier_reg)

  rand uvm_reg_field RDI;
  rand uvm_reg_field TXE;
  rand uvm_reg_field RXS;
  rand uvm_reg_field MSI;

  function new(string name = "ier_reg");
    super.new(name, 4, UVM_NO_COVERAGE);
  endfunction

  function void build();
    RDI = uvm_reg_field::type_id::create("RDI");
    RDI.configure(this, 1, 0, "RW", 0, 0, 1, 1, 0);
    TXE = uvm_reg_field::type_id::create("TXE");
    TXE.configure(this, 1, 1, "RW", 0, 0, 1, 1, 0);
    RXS = uvm_reg_field::type_id::create("RXS");
    RXS.configure(this, 1, 2, "RW", 0, 0, 1, 1, 0);
    MSI = uvm_reg_field::type_id::create("MSI");
    MSI.configure(this, 1, 3, "RW", 0, 0, 1, 1, 0);
  endfunction: build

endclass: ier_reg

class fcr_reg extends uvm_reg;
  `uvm_object_utils(fcr_reg)

  rand uvm_reg_field unused;
  rand uvm_reg_field RFITL;

  function new(string name = "fcr_reg");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  function void build();
    unused = uvm_reg_field::type_id::create("unused");
    unused.configure(this, 6, 0, "WO", 0, 0, 1, 0, 0);
    RFITL = uvm_reg_field::type_id::create("RFITL");
    RFITL.configure(this, 2, 6, "WO", 0, 2'b11, 1, 1, 0);
  endfunction: build

endclass: fcr_reg

class iid_reg extends uvm_reg;
  `uvm_object_utils(iid_reg)

  uvm_reg_field ID;
  uvm_reg_field unused;

  function new(string name = "iid_reg");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  function void build();
    ID = uvm_reg_field::type_id::create("ID");
    ID.configure(this, 4, 0, "RO", 1, 4'h1, 1, 0, 0);
    unused = uvm_reg_field::type_id::create("unused");
    unused.configure(this, 4, 4, "RO", 1, 4'hc, 1, 0, 0);
  endfunction: build

endclass: iid_reg

class lcr_reg extends uvm_reg;
  `uvm_object_utils(lcr_reg)

  rand uvm_reg_field WL;
  rand uvm_reg_field STP;
  rand uvm_reg_field PE;
  rand uvm_reg_field EP;
  rand uvm_reg_field SP;
  rand uvm_reg_field BRK;
  rand uvm_reg_field DLAB;

  function new(string name = "lcr_reg");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  function void build();
    WL = uvm_reg_field::type_id::create("WL");
    WL.configure(this, 2, 0, "RW", 0, 2'b11, 1, 1, 0);
    STP = uvm_reg_field::type_id::create("STP");
    STP.configure(this, 1, 2, "RW", 0, 1'b0, 1, 1, 0);
    PE = uvm_reg_field::type_id::create("PE");
    PE.configure(this, 1, 3, "RW", 0, 1'b0, 1, 1, 0);
    EP = uvm_reg_field::type_id::create("EP");
    EP.configure(this, 1, 4, "RW", 0, 1'b0, 1, 1, 0);
    SP = uvm_reg_field::type_id::create("SP");
    SP.configure(this, 1, 5, "RW", 0, 1'b0, 1, 1, 0);
    BRK = uvm_reg_field::type_id::create("BRK");
    BRK.configure(this, 1, 6, "RW", 0, 1'b0, 1, 1, 0);
    DLAB = uvm_reg_field::type_id::create("DLAB");
    DLAB.configure(this, 1, 7, "RW", 0, 1'b0, 1, 1, 0);
  endfunction

endclass: lcr_reg

class mcr_reg extends uvm_reg;
  `uvm_object_utils(mcr_reg)

  rand uvm_reg_field DTR;
  rand uvm_reg_field RTS;
  rand uvm_reg_field OUT1;
  rand uvm_reg_field OUT2;
  rand uvm_reg_field LBACK;

  function new(string name = "mcr_reg");
    super.new(name, 5, UVM_NO_COVERAGE);
  endfunction

  function void build();
    DTR = uvm_reg_field::type_id::create("DTR");
    DTR.configure(this, 1, 0, "WO", 0, 1'b0, 1, 1, 0);
    RTS = uvm_reg_field::type_id::create("RTS");
    RTS.configure(this, 1, 1, "WO", 0, 1'b0, 1, 1, 0);
    OUT1 = uvm_reg_field::type_id::create("OUT1");
    OUT1.configure(this, 1, 2, "WO", 0, 1'b0, 1, 1, 0);
    OUT2 = uvm_reg_field::type_id::create("OUT2");
    OUT2.configure(this, 1, 3, "WO", 0, 1'b0, 1, 1, 0);
    LBACK = uvm_reg_field::type_id::create("LBACK");
    LBACK.configure(this, 1, 4, "WO", 0, 1'b0, 1, 1, 0);
  endfunction: build

endclass: mcr_reg

class lsr_reg extends uvm_reg;
  `uvm_object_utils(lsr_reg)

  uvm_reg_field DR;
  uvm_reg_field OE;
  uvm_reg_field PE;
  uvm_reg_field FE;
  uvm_reg_field BI;
  uvm_reg_field TFE;
  uvm_reg_field TXE;
  uvm_reg_field RFE;

  function new(string name = "lsr_reg");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  function void build();
    DR = uvm_reg_field::type_id::create("DR");
    DR.configure(this, 1, 0, "RO", 0, 1'b0, 1, 0, 0);
    OE = uvm_reg_field::type_id::create("OE");
    OE.configure(this, 1, 1, "RC", 0, 1'b0, 1, 0, 0);
    PE = uvm_reg_field::type_id::create("PE");
    PE.configure(this, 1, 2, "RC", 0, 1'b0, 1, 0, 0);
    FE = uvm_reg_field::type_id::create("FE");
    FE.configure(this, 1, 3, "RC", 0, 1'b0, 1, 0, 0);
    BI = uvm_reg_field::type_id::create("BI");
    BI.configure(this, 1, 4, "RC", 0, 1'b0, 1, 0, 0);
    TFE = uvm_reg_field::type_id::create("TFE");
    TFE.configure(this, 1, 5, "RO", 0, 1'b0, 1, 0, 0);
    TXE = uvm_reg_field::type_id::create("TXE");
    TXE.configure(this, 1, 6, "RO", 0, 1'b0, 1, 0, 0);
    RFE = uvm_reg_field::type_id::create("RFE");
    RFE.configure(this, 1, 7, "RC", 0, 1'b0, 1, 0, 0);
  endfunction: build

endclass: lsr_reg

class msr_reg extends uvm_reg;
  `uvm_object_utils(msr_reg)

  uvm_reg_field DCTS;
  uvm_reg_field DDSR;
  uvm_reg_field TERI;
  uvm_reg_field DDCD;
  uvm_reg_field CTS;
  uvm_reg_field DSR;
  uvm_reg_field RI;
  uvm_reg_field DCD;

  function new(string name = "msr_reg");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  function void build();
    DCTS = uvm_reg_field::type_id::create("DCTS");
    DCTS.configure(this, 1, 0, "RC", 0, 1'b0, 1, 0, 0);
    DDSR = uvm_reg_field::type_id::create("DDSR");
    DDSR.configure(this, 1, 1, "RC", 0, 1'b0, 1, 0, 0);
    TERI = uvm_reg_field::type_id::create("TERI");
    TERI.configure(this, 1, 2, "RC", 0, 1'b0, 1, 0, 0);
    DDCD = uvm_reg_field::type_id::create("DDCD");
    DDCD.configure(this, 1, 3, "RC", 0, 1'b0, 1, 0, 0);
    CTS = uvm_reg_field::type_id::create("CTS");
    CTS.configure(this, 1, 4, "RO", 0, 1'b0, 1, 0, 0);
    DSR = uvm_reg_field::type_id::create("DSR");
    DSR.configure(this, 1, 5, "RO", 0, 1'b0, 1, 0, 0);
    RI = uvm_reg_field::type_id::create("RI");
    RI.configure(this, 1, 6, "RO", 0, 1'b0, 1, 0, 0);
    DCD = uvm_reg_field::type_id::create("DCD");
    DCD.configure(this, 1, 7, "RO", 0, 1'b0, 1, 0, 0);
  endfunction: build

endclass: msr_reg

class div_reg extends uvm_reg;
  `uvm_object_utils(div_reg)

  rand uvm_reg_field DIV;

  function new(string name = "div_reg");
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction

  function void build();
    DIV = uvm_reg_field::type_id::create("DIV");
    DIV.configure(this, 8, 0, "RW", 0, 8'h0, 1, 1, 0);
  endfunction: build

endclass: div_reg

class uart_reg_block extends uvm_reg_block;
  `uvm_object_utils(uart_reg_block)

  rand txd_reg TXD;
  rand rxd_reg RXD;
  rand ier_reg IER;
  iid_reg IID;
  rand fcr_reg FCR;
  rand lcr_reg LCR;
  rand mcr_reg MCR;
  lsr_reg LSR;
  msr_reg MSR;
  rand div_reg DIV1;
  rand div_reg DIV2;

  uvm_reg_map map;

  function new(string name = "uart_reg_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  function void build();
    TXD = txd_reg::type_id::create("TXD");
    TXD.build();
    TXD.configure(this);
    RXD = rxd_reg::type_id::create("RXD");
    RXD.build();
    RXD.configure(this);
    IER = ier_reg::type_id::create("IER");
    IER.build();
    IER.configure(this);
    IID = iid_reg::type_id::create("IID");
    IID.build();
    IID.configure(this);
    FCR = fcr_reg::type_id::create("FCR");
    FCR.build();
    FCR.configure(this);
    LCR = lcr_reg::type_id::create("LCR");
    LCR.build();
    LCR.configure(this);
    MCR = mcr_reg::type_id::create("MCR");
    MCR.build();
    MCR.configure(this);
    LSR = lsr_reg::type_id::create("LSR");
    LSR.build();
    LSR.configure(this);
    MSR = msr_reg::type_id::create("MSR");
    MSR.build();
    MSR.configure(this);
    DIV1 = div_reg::type_id::create("DIV1");
    DIV1.build();
    DIV1.configure(this);
    DIV2 = div_reg::type_id::create("DIV2");
    DIV2.build();
    DIV2.configure(this);

    map = create_map("map", 'h0, 4, UVM_LITTLE_ENDIAN);

    map.add_reg(TXD, 32'h0, "WO");
    map.add_reg(RXD, 32'h0, "RO");
    map.add_reg(IER, 32'h4, "RW");
    map.add_reg(IID, 32'h8, "RO");
    map.add_reg(FCR, 32'h8, "WO");
    map.add_reg(LCR, 32'hc, "RW");
    map.add_reg(MCR, 32'h10, "RW");
    map.add_reg(LSR, 32'h14, "RO");
    map.add_reg(MSR, 32'h18, "RO");
    map.add_reg(DIV1, 32'h1c, "RW");
    map.add_reg(DIV2, 32'h20, "RW");

    lock_model();
  endfunction

endclass: uart_reg_block

endpackage: uart_reg_pkg
