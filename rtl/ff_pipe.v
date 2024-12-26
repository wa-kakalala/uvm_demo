// forwared pipe
module ff_pipe #(
	parameter WD = 8
)(
	input             clk    ,
	input             rst_n  ,
	
	input   		  s_valid,
	input  [WD - 1:0] s_data ,
	output			  s_ready,
	
	output			  m_valid,
	output [WD -1:0]  m_data ,
	input			  m_ready
);

reg s_valid_ff;
always @(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		s_valid_ff <= 1'b0;
	end
	else if(m_ready || ~s_valid_ff) begin
		s_valid_ff <= s_valid;
	end
end

reg [WD -1:0] s_data_ff;
always @(posedge clk or negedge rst_n)begin
	if(m_ready || ~s_valid_ff) begin
		s_data_ff <= s_data;
	end
end

assign s_ready = m_ready | (~s_valid_ff);
assign m_valid = s_valid_ff;
assign m_data  = s_data_ff;

endmodule
