class dma_regression_test extends base_test;
	`uvm_component_utils(dma_regression_test)

	dma_regression_seq reg_seq;

	function new(string name = "dma_regression_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		reg_seq = dma_regression_seq::type_id::create("reg_seq");
		reg_seq.regbk = env.regbk; 
		reg_seq.start(env.agt.seqr);
		phase.drop_objection(this);
	endtask

endclass
