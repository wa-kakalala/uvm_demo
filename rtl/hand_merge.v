module hand_merge #(
	parameter CHL = 2
)(
	input     [CHL -1:0] s_valid,
	output    [CHL -1:0] s_ready,
	
	output               m_valid,
	input                m_ready
);

// 感觉这里原作者的想法可能有点问题
// genvar i;
// genvar j;
// generate
// 	for(i=0; i<CHL; i=i+1)begin
// 		for(j=0; j<CHL; j=j+1)begin
// 			always @* begin
// 				s_ready[i] = m_ready;
// 				if(i != j)begin
// 					s_ready[i] = m_ready & s_valid[j];
// 				end
// 			end
// 		end
// 	end
// endgenerate

// update
assign s_ready = { CHL{m_ready} } & s_valid;

assign m_valid = (&s_valid);

endmodule