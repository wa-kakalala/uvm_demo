`ifndef SANITY_CASE_SV
`define SANITY_CASE_SV

//class tv0;
//    rand bit[7:0] id;
    //bit[7:0] mid = 8'hF;
//endclass


class sanity_case_seq extends my_sequence;

	extern function new(string name = "sanity_case_seq");
	extern virtual task body();

	
	`uvm_object_utils(sanity_case_seq)
endclass: sanity_case_seq

function sanity_case_seq::new(string name = "sanity_case_seq");
	super.new(name);
endfunction: new

task sanity_case_seq::body();
	repeat(10000) begin
		`uvm_do_with(my_tr, {my_tr.par_err == 0;})
	end
	#100;
endtask: body

class sanity_case extends base_test;

    bit[7:0] mid = 8'hA;
    
	extern function new(string name = "base_test", uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	
	`uvm_component_utils(sanity_case)
endclass: sanity_case

function sanity_case::new(string name = "base_test", uvm_component parent=null);
    //bit[7:0] mid = 8'h5;
    //tv0 t0 = new();
    //tv0 t1 = new();
    //tv0 t2 = new();
    //tv0 t3 = new();
    super.new(name, parent);
    
    //t0.randomize with {id == this.mid;};
    //t1.randomize with {id == sanity_case::mid;};
    //t2.randomize with {id == local::mid;};
    //t3.randomize with {id == mid;};
    //$display("t0.id = 'h%0h", t0.id);
    //$display("t1.id = 'h%0h", t1.id);
    //$display("t2.id = 'h%0h", t2.id);
    //$display("t3.id = 'h%0h", t3.id);
    //$finish;
endfunction: new

function void sanity_case::build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db #(uvm_object_wrapper)::set(
		this,
		"env.i_agt0.sqr.main_phase",
		"default_sequence",
		sanity_case_seq::type_id::get()
	);
    uvm_config_db #(uvm_object_wrapper)::set(
		this,
		"env.i_agt1.sqr.main_phase",
		"default_sequence",
		sanity_case_seq::type_id::get()
	);

endfunction: build_phase

`endif
