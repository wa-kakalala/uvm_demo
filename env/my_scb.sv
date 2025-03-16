`ifndef MY_SCB__SV
`define MY_SCB__SV

class my_scb extends uvm_scoreboard;
   my_transaction  expect_q[$];
   uvm_blocking_get_port #(my_transaction)  exp_port;
   uvm_blocking_get_port #(my_transaction)  act_port;
   `uvm_component_utils(my_scb)

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
endclass 

function my_scb::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction: new

function void my_scb::build_phase(uvm_phase phase);
   super.build_phase(phase);
   exp_port = new("exp_port", this);
   act_port = new("act_port", this);
endfunction: build_phase

task my_scb::main_phase(uvm_phase phase);
    my_transaction  get_expect,  get_actual, tmp_tran;
    bit result;
    super.main_phase(phase);
    fork 
        while (1) begin
           exp_port.get(get_expect);
           expect_q.push_back(get_expect);
        end
        while (1) begin
            act_port.get(get_actual);
            if(expect_q.size() > 0) begin
                tmp_tran = expect_q.pop_front();
                //`uvm_info("my_scb", $sformatf("exp par_err=%0h", tmp_tran.par_err), UVM_LOW);
                //`uvm_info("my_scb", $sformatf("act par_err=%0h", get_actual.par_err), UVM_LOW);
                result = get_actual.compare(tmp_tran); // tranaction 必须要实现 auto field
                if(result) begin 
                   `uvm_info("my_scb", "Compare SUCCESSFULLY", UVM_LOW);
                end else begin
                    `uvm_error("my_scb", "Compare FAILED");
                    $display("RM:");
                    tmp_tran.print(); // tranaction 必须要实现 auto field
                    $display("RTL:");
                    get_actual.print();
                end
            end else begin
                `uvm_error("my_scb", "Received from DUT, while Expect Queue is empty");
                get_actual.print();
            end 
        end
    join_none
endtask: main_phase

`endif
