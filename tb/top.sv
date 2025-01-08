`timescale 1ns/1ps

module top;

logic clk;
logic rst_n;

initial begin
   clk = 0;
   forever begin
      #10 clk = ~clk;
   end
end

initial begin
   rst_n = 1'b0;
   #1000;
   rst_n = 1'b1;
end

initial begin
   run_test("sanity_case");
end

my_interface u_in_if0(clk, rst_n);
my_interface u_in_if1(clk, rst_n);
my_interface u_out_if(clk, rst_n);

mul_trans u_mul(
	.clk(clk),
	.rst_n(rst_n),
	
	.s0_valid(u_in_if0.valid),
	.s0_data(u_in_if0.data),
	.s0_ready(u_in_if0.ready),

	.s1_valid(u_in_if1.valid),
	.s1_data(u_in_if1.data),
	.s1_ready(u_in_if1.ready),
	
	.m_valid(u_out_if.valid),
	.m_data(u_out_if.data),
	.m_ready(u_out_if.ready)
	//.m_ready(1'b1)
);

initial begin
   uvm_config_db#(virtual my_interface)::set(null, "uvm_test_top.env.i_agt0", "vif", u_in_if0);
   uvm_config_db#(virtual my_interface)::set(null, "uvm_test_top.env.i_agt1", "vif", u_in_if1);
   uvm_config_db#(virtual my_interface)::set(null, "uvm_test_top.env.o_agt",  "vif", u_out_if);
end

initial begin
    #1000ns;
    // force 是SystemVerilog的一个仿真控制语句，用于再仿真过程中强制给某个变量或者网络赋一个特定的值，覆盖其原有的驱动。
    // 直到使用release语句释放这个强制赋值  
    force top.u_mul.m_valid = 1;
    $display("force!!!");
    #10ns;
    release  top.u_mul.m_valid;
end

endmodule
