`ifndef MY_SEQUENCER_SV
`define MY_SEQUENCER_SV

// 产生my_transaction类型的 transaction
class my_sequencer extends uvm_sequencer #(my_transaction);
	
	extern function new(string name = "my_sequencer", uvm_component parent=null);
	
	`uvm_component_utils(my_sequencer)
endclass: my_sequencer

function my_sequencer::new(string name = "my_sequencer", uvm_component parent=null);
	super.new(name, parent);
endfunction: new

`endif