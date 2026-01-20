`ifndef TEST_INCLUDED_  
`define TEST_INCLUDED_ 

class base_test extends uvm_test;
	`uvm_component_utils(base_test)

	dma_env env;
	dma_report_server srv; 

	function new(string name = "base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction: new	

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = dma_env::type_id::create("env",this);
	  /* uvm_config_db#(uvm_active_passive_enum)::set(this, "env.agt_act", "is_active", UVM_ACTIVE); */
    /* uvm_config_db#(uvm_active_passive_enum)::set(this, "env.agt_pass", "is_active", UVM_PASSIVE); */
		srv = new();
		uvm_report_server::set_server(srv);
	endfunction: build_phase	

	function void end_of_elaboration(); 
		uvm_top.print_topology();
	endfunction 

	/* virtual task run_phase(uvm_phase phase); */
	/* 	phase.raise_objection(this); */
	/* 		/1* seq.start(env.agt_act.seqr); *1/ */
	/* 	phase.drop_objection(this); */
	/* endtask: run_phase */

endclass: base_test	

`endif
