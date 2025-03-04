`ifndef MY_ENV_SV
`define MY_ENV_SV

class my_env extends uvm_env;
	my_agent i_agt0;
	my_agent i_agt1;
	my_agent o_agt;

    my_rm    rm;
    my_scb   scb;
	
	extern function new(string name = "my_env", uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
	
	`uvm_component_utils(my_env)
endclass: my_env

function my_env::new(string name = "my_env", uvm_component parent=null);
	super.new(name, parent);
endfunction: new

function void my_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	i_agt0 = my_agent::type_id::create("i_agt0", this);
	i_agt1 = my_agent::type_id::create("i_agt1", this);
	o_agt  = my_agent::type_id::create("o_agt", this);
    rm     = my_rm::type_id::create("rm", this);
    scb    = my_scb::type_id::create("scb", this);
	i_agt0.is_active = UVM_ACTIVE;
	i_agt1.is_active = UVM_ACTIVE;
	o_agt.is_active  = UVM_PASSIVE;
    o_agt.rdy_en = 1;
endfunction: build_phase

function void my_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   rm.port0.connect(i_agt0.out_fifo.blocking_get_export);
   rm.port1.connect(i_agt1.out_fifo.blocking_get_export);
   scb.exp_port.connect(rm.out_fifo.blocking_get_export);
   scb.act_port.connect(o_agt.out_fifo.blocking_get_export);
endfunction

`endif
