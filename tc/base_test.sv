`ifndef BASE_TEST_SV
`define BASE_TEST_SV

class base_test extends uvm_test;

	my_env env;
	
	extern function new(string name = "base_test", uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void report_phase(uvm_phase phase);

	`uvm_component_utils(base_test)
endclass: base_test

function base_test::new(string name = "base_test", uvm_component parent=null);
	super.new(name, parent);
endfunction: new

function void base_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	env = my_env::type_id::create("env", this);
	uvm_config_db #(uvm_object_wrapper)::set(
		this,
		"env.i_agt.spr.main_phase",
		"default_sequence",
		my_sequence::type_id::get()
	);
endfunction: build_phase

function void base_test::report_phase(uvm_phase phase);
	super.report_phase(phase);
endfunction: report_phase

`endif
