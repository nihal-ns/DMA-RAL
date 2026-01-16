`ifndef DMA_MONITOR_INCLUDED_   
`define DMA_MONITOR_INCLUDED_  

class dma_monitor extends uvm_monitor;
	`uvm_component_utils(dma_monitor)  

	virtual dma_intf vif;             
	uvm_analysis_port #(dma_seq_item) mon_port; 

	function new(string name = "dma_monitor", uvm_component parent);
		super.new(name,parent);
	endfunction	

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon_port = new("mon_port",this);
		if(!uvm_config_db#(virtual dma_intf)::get(this,"","vif",vif))       
			`uvm_fatal("NO_VIF","virtual interface failed to get from config");
	endfunction	

	virtual task run_phase(uvm_phase phase);
		forever begin
			// monitor logic
		end
	endtask	

endclass: dma_monitor 

`endif
