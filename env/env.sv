/**************************************
@ filename    : env.sv
@ author      : yyrwkk
@ create time : 2025/03/16 00:05:25
@ version     : v1.0.0
**************************************/
`ifndef ENV_SV 
`define ENV_SV

`include  "uvm_macros.svh"
import uvm_pkg::*;

package dut_pkg;
    `include "my_agent.sv" 
    `include "my_driver.sv" 
    `include "my_env.sv" 
    `include "my_interface.sv"
    `include "my_monitor.sv"
    `include "my_rm.sv"
    `include "my_scb"
    `include "my_sequencer.sv"
    `include "my_transaction.sv"  
endpackage 

import dut_pkg::*;

`endif  
