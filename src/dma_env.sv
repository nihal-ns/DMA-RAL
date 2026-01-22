`ifndef DMA_ENV_INCLUDED_
`define DMA_ENV_INCLUDED_

class dma_env extends uvm_env;
	`uvm_component_utils(dma_env)

	dma_agent agt;
	dma_reg_model regbk;
	dma_adapter adapter;
	dma_subscriber cov; 
	uvm_reg_predictor #(dma_seq_item) predictor;

	function new(string name = "dma_env", uvm_component parent);
		super.new(name,parent);
	endfunction: new	

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agt = dma_agent::type_id::create("agt",this);
		regbk = dma_reg_model::type_id::create("regbk", this);
		adapter = dma_adapter::type_id::create("adapter");
		predictor = uvm_reg_predictor#(dma_seq_item)::type_id::create("predictor", this);
		cov = dma_subscriber::type_id::create("cov",this);
		regbk.set_hdl_path_root("top.DUT");
		regbk.build();
	endfunction: build_phase	

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		// should change the scb port names 
		agt.mon.mon_port.connect(cov.analysis_export);
		regbk.default_map.set_sequencer(.sequencer(agt.seqr), .adapter(adapter) );
		regbk.default_map.set_base_addr(0);
		predictor.map = regbk.default_map;
		predictor.adapter = adapter;
		agt.mon.mon_port.connect(predictor.bus_in);
		regbk.default_map.set_auto_predict(0);
	endfunction: connect_phase

endclass: dma_env	

`endif
