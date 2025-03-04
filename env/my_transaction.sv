`ifndef MY_TRANSACTION_SV
`define MY_TRANSACTION_SV

class my_transaction extends uvm_sequence_item;
	rand bit [8-1:0] data;
	rand bit	     par_err;

	bit 	         par;
	bit		 [8:0]   send_data;

    // auto fields : copy , compare, print, unpack_bytes, pack_bytes
    // 在ap.write中会使用到copy
	`uvm_object_utils_begin(my_transaction)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(par_err, UVM_ALL_ON)
	`uvm_object_utils_end
	
	constraint par_cons{
		par_err dist {0:/90, 1:/10};
        // par_err : 90% -> 0
        // par_err : 10% -> 1
	}
	
    // 应该打开这个宏
	`uvm_object_utils(my_transaction)
	
	extern function new(string name = "my_transaction");
	extern virtual function void pack();
	extern virtual function void unpack();
	
endclass: my_transaction

function my_transaction::new(string name = "my_transaction");
	super.new(name);
endfunction

function void my_transaction::pack();
    // 注入错误
	par = par_err ? ~(^data) : ^data;
    // par实际上是一个偶校验位
	send_data = {par, data};	
endfunction: pack

function void my_transaction::unpack();
	{par_err, data} = send_data;	
endfunction: unpack

`endif
