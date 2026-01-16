`ifndef DMA_DRIVER_INCLUDED_
`define DMA_DRIVER_INCLUDED_ 

class dma_driver extends uvm_driver#(dma_seq_item);
	`uvm_component_utils(dma_driver)   

	virtual dma_intf vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new	

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual dma_intf)::get(this,"","vif",vif)) begin   
			`uvm_fatal("NO_VIF","virtual interface failed to get from config") 
		end
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);
			drive();
			seq_item_port.item_done();
		end
	endtask: run_phase
	
	task drive;
		// logic pending
	endtask: drive

endclass: dma_driver	

`endif
