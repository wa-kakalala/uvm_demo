`ifndef MY_INTERFACE_SV
`define MY_INTERFACE_SV

`timescale 1ns/1ps
interface my_interface #(
    parameter WD = 9
)( 
    input clk   , 
    input rst_n
);

	logic [WD -1:0] data ;
	logic 	        valid;
	logic		    ready;

	clocking drv @(posedge clk);
		default input #1ps output #1ps;
		output 	data;
		output	valid;
		input   ready;
	endclocking : drv
    // dut的输入驱动接口
	modport pkt_drv (clocking drv);

	clocking mon @(posedge clk);
		default input #1ps output #1ps;
		input 	data;
		input	valid;
		input   ready;
	endclocking : mon
    // dut的输出接受接口
	modport pkt_mon (clocking mon);

	// clocking ready_drv @(posedge clk);
	// 	default input #1ps output #1ps;
	// 	input 	data;
	// 	input	valid;
	// 	output  ready;
	// endclocking : ready_drv
    // 目前还不知道有什么作用
	// modport pkt_ready_drv (clocking ready_drv);

endinterface

typedef virtual my_interface.pkt_drv vdrv;
typedef virtual my_interface.pkt_mon vmon;

`endif
