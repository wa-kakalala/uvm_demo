module mul_trans #(
	parameter WD = 9
)(
	input             clk     ,
	input             rst_n   ,
	
	input   		  s0_valid,
	input  [WD - 1:0] s0_data,
	output			  s0_ready,

	input   		  s1_valid,
	input  [WD - 1:0] s1_data ,
	output			  s1_ready,
	
	output			  m_valid ,
	output [WD -1:0]  m_data  ,
	input			  m_ready
);

wire   		    s0_ff_valid;
wire [WD - 1:0] s0_data_ff;
wire		    s0_ff_ready;
ff_pipe #(.WD(WD))
u_s0_ff (
	.clk	 (clk),
	.rst_n	 (rst_n),
	.s_valid (s0_valid),
	.s_data  (s0_data),
	.s_ready (s0_ready),
	.m_valid (s0_ff_valid),
	.m_data  (s0_data_ff),
	.m_ready (s0_ff_ready)	
);

wire   		    s1_ff_valid;
wire [WD - 1:0] s1_data_ff;
wire		    s1_ff_ready;
ff_pipe #(.WD(WD))
u_s1_ff (
	.clk	 (clk),
	.rst_n	 (rst_n),
	.s_valid (s1_valid),
	.s_data  (s1_data),
	.s_ready (s1_ready),
	.m_valid (s1_ff_valid),
	.m_data  (s1_data_ff),
	.m_ready (s1_ff_ready)	
);

wire check_point = 1'b1;

wire t1 = (s0_data == s1_data);
wire t2 = (s0_data == s1_data);
wire t3 = t1 & t2;
wire t4 = t3;

// 这里应该是自己定义的一种运算
// 两个[WD]位宽的数,低[WD-1]位相乘，得到2(WD-1)位宽的结果
// 截取低[WD-1]位作为输出
wire [WD-2:0] mul_data = s0_data_ff[WD-2:0] * s1_data_ff[WD-2:0];
// 将低[WD-1]位再进行按位或操作，得到[WD]位宽的结果
wire [WD-1:0] out_data = {|mul_data, mul_data};

wire out_valid;
wire out_ready;
hand_merge #(.CHL(2))
u_hand_merge(
	.s_valid({s1_ff_valid, s0_ff_valid}),
	.s_ready({s1_ff_ready, s0_ff_ready}),
	.m_valid(out_valid),
	.m_ready(out_ready)
);

ff_pipe #(.WD(WD))
u_out_pipe (
	.clk	 (clk),
	.rst_n	 (rst_n),
	.s_valid (out_valid),
	.s_data  (out_data),
	.s_ready (out_ready),
	.m_valid (m_valid),
	.m_data  (m_data),
	.m_ready (m_ready)	
);

endmodule
