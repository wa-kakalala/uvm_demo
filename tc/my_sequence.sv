`ifndef MY_SEQUENCE_SV
`define MY_SEQUENCE_SV

class my_sequence extends uvm_sequence #(my_transaction);
	my_transaction my_tr;
	
	extern function new(string name = "my_sequence");
	extern virtual task body();
	
	`uvm_object_utils(my_sequence)
endclass: my_sequence

function my_sequence::new(string name = "my_sequence");
	super.new(name);
endfunction: new

task my_sequence::body();
	repeat(10) begin
		`uvm_do(my_tr)
	end
	#100;
endtask: body

`endif
