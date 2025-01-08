`ifndef MY_RM_SV
`define MY_RM_SV

`define prj_cast(to, from) \
    if (from == null) begin\
        `uvm_fatal("prj_cast", "cast NULL");\
    end\
    if(!$cast(to, from)) begin\
        `uvm_fatal("prj_cast", "cast fatal");\
    end\

class my_rm extends uvm_component;

    uvm_blocking_get_port #(my_transaction) port0;
    uvm_blocking_get_port #(my_transaction) port1;
    uvm_analysis_port     #(my_transaction) ap;
    uvm_tlm_analysis_fifo #(my_transaction) out_fifo; // 这个fifo用来保存输出结果

    my_transaction ch0_q[$];
    my_transaction ch1_q[$];

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern virtual  task main_phase(uvm_phase phase);

    `uvm_component_utils(my_rm);

endclass: my_rm

function my_rm::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction 

function void my_rm::build_phase(uvm_phase phase);
    super.build_phase(phase);
    port0 = new("port0", this);
    port1 = new("port1", this);
    ap    = new("ap", this);
    out_fifo = new("out_fifo", this);
endfunction

function void my_rm::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ap.connect(out_fifo.analysis_export);
endfunction


task my_rm::main_phase(uvm_phase phase);
    super.main_phase(phase);
    fork
        while(1) begin
            my_transaction tr0;
            port0.get(tr0);
            ch0_q.push_back(tr0);
            `uvm_info("my_rm", $sformatf("pkt0 data = %0h", tr0.data), UVM_LOW);
        end
        while(1) begin
            my_transaction tr1;
            port1.get(tr1);
            ch1_q.push_back(tr1);
            `uvm_info("my_rm", $sformatf("pkt1 data = %0h", tr1.data), UVM_LOW);
        end
        while(1)begin
            my_transaction out_tr = new();
            my_transaction tr0;
            my_transaction tr1;
            wait(ch0_q.size() > 0 && ch1_q.size() > 0);
            tr0 = ch0_q.pop_front();
            tr1 = ch1_q.pop_front();
            out_tr.data = tr0.data * tr1.data;
            out_tr.par_err  = |out_tr.data;
            //`uvm_info("my_rm", $sformatf("pkt1 par_err = %0h", tr1.par_err), UVM_LOW);
            ap.write(out_tr);
        end
    join_none
endtask



`endif
