`ifndef MY_DRIVER_SV
`define MY_DRIVER_SV

// 针对my_transaction 类型的transaction进行驱动
class my_driver extends uvm_driver #(my_transaction);
	virtual my_interface vif;
    int aa_cnt;
	`uvm_component_utils(my_driver)

	extern function new(string name = "my_driver", uvm_component parent=null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
	extern virtual task drive_pkt(my_transaction pkt);
	extern virtual task drive_idle();

endclass: my_driver

function my_driver::new(string name = "my_driver", uvm_component parent=null);
	super.new(name, parent);
endfunction: new

function void my_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("my_driver", "build_phase is called", UVM_LOW);
	if(!uvm_config_db #(virtual my_interface)::get(this, "", "vif", vif))begin
		`uvm_fatal("my_driver", "virtual interface get fatal");
	end
endfunction: build_phase

// objection机制
// 通过raise_objection 和 drop_objection 可以控制程序的结束， objection可以相当于是对全局有效的
// 当driver drop_objection后，此时UVM监测发现所有的objection都被撤销了(因为只有driver raise_objection)
// 于是UVM会直接杀死monitor中的无限循环，并跳转到下一个phase, 即post_main_phase
// 如果想执行一些耗费时间的代码，需要在此phase下任意一个component中至少提起一次objection
task my_driver::main_phase(uvm_phase phase);
	my_transaction req;
	phase.raise_objection(this);
	`uvm_info("my_driver", "main_phase is called", UVM_LOW);
    this.drive_idle();
    while(!this.vif.rst_n) @(posedge vif.clk);
	while(1)begin
        // seq_item_port是driver和sequencer之间通信的一个接口
        // 允许driver从sequencer中获取事务，并将response发送回去
        // 在driver中seq_item_port通常已经被预定义，可以直接使用，而无需定义
        // get_nex_item是阻塞的
        // try_next_item是非阻塞的
		seq_item_port.try_next_item(req); // req是内部的一个变量，如果使用有参形式定义就可以直接使用
		if(req == null) break; // 结束平台的信号，如果接收不到新的数据就会结束，应该不存在sequence来不及产生数据的情况吧？
		else begin
	        //`uvm_info("my_driver", "drive a pkt start", UVM_LOW);
			this.drive_pkt(req);
			seq_item_port.item_done();
		end
	end
    this.drive_idle();

    #1000;
	phase.drop_objection(this);
    //`uvm_info("my_driver", "drop_objection", UVM_LOW);
endtask: main_phase

task my_driver::drive_pkt(my_transaction pkt);
	pkt.pack();
    if(pkt.data == 'hAA) this.aa_cnt = this.aa_cnt + 1;
    //`uvm_info("my_driver", $sformatf("pkt data = %0h", pkt.send_data), UVM_LOW);
	while(1) begin
        @this.vif.drv;
        this.vif.drv.valid <= 'd1;
		this.vif.drv.data  <= pkt.send_data;

        if(this.vif.ready === 1'd1) begin
            //`uvm_info("my_driver", "hand en, break", UVM_LOW);
            repeat(1) begin
                @this.vif.drv;
                this.vif.drv.valid <= 'd0;
            end
            break;
        end
	end
endtask: drive_pkt
	
task my_driver::drive_idle();
    @this.vif.drv;
	this.vif.drv.valid <= 'd0;
	this.vif.drv.data  <= 'dx;
endtask: drive_idle

function void my_driver::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("my_driver", $sformatf("this.aa_cnt = %0d", this.aa_cnt), UVM_LOW);
endfunction: report_phase

`endif
