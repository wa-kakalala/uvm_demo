`ifndef MY_AGENT_SV
`define MY_AGENT_SV

class my_agent #(parameter WD = 8) extends uvm_agent;
	my_sequencer     sqr;
	my_driver        drv;
	my_monitor       mon;
    my_ready_drv     rdy;

    bit rdy_en;

    virtual my_interface vif;
    uvm_tlm_analysis_fifo #(my_transaction) out_fifo;//rm connect out_fifo.blocking_get_export
	
	`uvm_component_utils(my_agent)
	
	extern function new(string name = "my_agent", uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);

endclass

function my_agent::new(string name = "my_agent", uvm_component parent=null);
	super.new(name, parent);
endfunction: new

function void my_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
    if(!uvm_config_db #(virtual my_interface)::get(this, "", "vif", vif))begin
		`uvm_fatal("my_driver", "virtual interface get fatal");
	end
    uvm_config_db#(virtual my_interface)::set(this, "drv", "vif", vif);
    uvm_config_db#(virtual my_interface)::set(this, "mon", "vif", vif);
    // uvm_config_db#(virtual my_interface)::set(this, "rdy", "vif", vif);

	if(is_active == UVM_ACTIVE) begin
		sqr = my_sequencer::type_id::create("sqr", this);
		drv = my_driver::type_id::create("drv", this);
	end
    // if(rdy_en == 1)begin
    //     rdy = my_ready_drv::type_id::create("rdy", this);
    // end
	mon = my_monitor::type_id::create("mon", this);
    out_fifo = new("out_fifo", this);
endfunction: build_phase

function void my_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(is_active == UVM_ACTIVE) begin
		drv.seq_item_port.connect(sqr.seq_item_export);
	end
    mon.ap.connect(out_fifo.analysis_export);
endfunction: connect_phase

`endif
