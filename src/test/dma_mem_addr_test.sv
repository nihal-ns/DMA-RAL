
class dma_mem_addr_test extends base_test;
	mem_addr_seq seq;
	`uvm_component_utils(dma_mem_addr_test) 
	
	function new(string name = "dma_mem_addr_test", uvm_component parent); 
		super.new(name,parent); 
	endfunction
	
	function void build_phase(uvm_phase phase); 
		super.build_phase(phase);
		seq = mem_addr_seq::type_id::create("seq"); 
	endfunction
	
	task run_phase(uvm_phase phase); 
		phase.raise_objection(this);
		seq.regbk = env.regbk; 
		seq.start(env.agt.seqr); 
		phase.drop_objection(this); 
		// phase.phase_done.set_drain_time(this, 20); 
	endtask

endclass
