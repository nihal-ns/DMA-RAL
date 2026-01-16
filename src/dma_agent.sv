`ifndef DMA_AGENT_INCLUDED_
`define DMA_AGENT_INCLUDED_ 

class dma_agent extends uvm_agent;  
	`uvm_component_utils(dma_agent)  

	dma_driver drv;     
	dma_monitor mon;
	dma_sequencer seqr;

	function new(string name = "dma_agent", uvm_component parent); 
		super.new(name,parent);
	endfunction: new	

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(get_is_active == UVM_ACTIVE) begin
			drv = _driver::type_id::create("drv",this);         
			seqr = _sequencer::type_id::create("seqr",this);   
		end
		mon = dma_monitor::type_id::create("mon",this);
	endfunction: build_phase	

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		/* drv.seq_item_port.connect(seqr.seq_item_export); */  // Change the port commection
		/* if (get_is_active() == UVM_ACTIVE) begin */               // should check 
		/* 	drv.seq_item_port.connect(seqr.seq_item_export); */
		/* end */
	endfunction: connect_phase

endclass: dma_agent

`endif
