`ifndef DMA_SEQUENCER_INCLUDED_  
`define DMA_SEQUENCER_INCLUDED_ 

class dma_sequencer extends uvm_sequencer#(dma_seq_item); 
	`uvm_component_utils(dma_sequencer)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

endclass: dma_sequencer	

`endif
