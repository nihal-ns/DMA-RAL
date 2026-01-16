`ifndef DMA_ENV_INCLUDED_
`define DMA_ENV_INCLUDED_

class dma_env extends uvm_env;
	`uvm_component_utils(dma_env)

	dma_agent agt;
	/* dma_scoreboard scb; */
	 dma_coverage cov; 

	function new(string name = "dma_env", uvm_component parent);
		super.new(name,parent);
	endfunction: new	

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agt = dma_agent_active::type_id::create("agt",this);
		/* scb = dma_scoreboard::type_id::create("scb",this); */
		cov = dma_coverage::type_id::create("cov",this);
	endfunction: build_phase	

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		// should change the scb port names 
		/* agt.mon.mon_collect_port.connect(scb.item_act_port); */

		/* agt.mon.mon_collect_port.connect(cov.mon_act_cg_port); */
	endfunction: connect_phase

endclass: dma_env	

`endif
