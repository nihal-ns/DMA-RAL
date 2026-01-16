`ifndef TEST_INCLUDED_  
`define TEST_INCLUDED_ 

class base_test extends uvm_test;
	`uvm_component_utils(base_test)

	dma_env env;
	dma_seq seq;

	function new(string name = "base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new	

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = dma_env::type_id::create("env",this);
	  /* uvm_config_db#(uvm_active_passive_enum)::set(this, "env.agt_act", "is_active", UVM_ACTIVE); */
    /* uvm_config_db#(uvm_active_passive_enum)::set(this, "env.agt_pass", "is_active", UVM_PASSIVE); */
		seq = dma_seq::type_id::create("seq",this);
	endfunction: build_phase	

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			/* seq.start(env.agt_act.seqr); */
		phase.drop_objection(this);
	endtask: run_phase

endclass: test	

`endif
