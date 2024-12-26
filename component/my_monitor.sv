`ifndef MY_MONITOR_SV
`define MY_MONITOR_SV

class my_monitor extends uvm_monitor;
    // 如果是 in  monitor 就使用my_interface.pkt_drv -> vdrv
    // 如果是 out monitor 就使用my_interface.pkt_mon -> vmon;
	virtual my_interface vif; 
    // 需要补白皮书第4章的内容。
    // analysis port 与 IMP之间的通信是一种一对多的通信。(IMP端口用于接收通信请求，并且必须作为连接的终点)
    // 对于analysis port来说，只有一种操作就是write。
	uvm_analysis_port #(my_transaction) ap;
    // 在in  monitor中会连接refermodel
    // 在out monitor中会连接scoreborad
	
	`uvm_component_utils(my_monitor)
	
	extern function new(string name = "my_monitor", uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	extern virtual task receive_pkt();
endclass: my_monitor

function my_monitor::new(string name = "my_monitor", uvm_component parent=null);
	super.new(name, parent);
endfunction: new

function void my_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("my_monitor", "build_phase is called", UVM_LOW);
    // 用于获取interface 的handle
	if(!uvm_config_db #(virtual my_interface)::get(this, "", "vif", vif))begin
		`uvm_fatal("my_monitor", "virtual interface get fatal");
	end
    // 实例化通信端口
	ap   = new("ap", this);
endfunction: build_phase

task my_monitor::main_phase(uvm_phase phase);
	fork 
		this.receive_pkt();
	join_none
endtask: main_phase

task my_monitor::receive_pkt();
	my_transaction data = new();
	while(1) begin
		@this.vif.mon; // 等到时钟沿
		if(this.vif.mon.valid & this.vif.mon.ready)begin
			data.send_data = this.vif.mon.data;
			data.unpack();
			ap.write(data);
            //`uvm_info("my_monitor", $sformatf("if.data=%0h", this.vif.mon.data), UVM_LOW);
		end
	end
endtask: receive_pkt

`endif
