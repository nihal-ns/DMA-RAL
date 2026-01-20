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
			dma_seq_item item = dma_seq_item::type_id::create("item");
			repeat(2) @(vif.mon_cb);
			item.wr_en = vif.mon_cb.wr_en ;
			item.rd_en = vif.mon_cb.rd_en ;
			item.addr  = vif.mon_cb.addr  ;
			item.wdata = vif.mon_cb.wdata ;
			item.rdata = vif.mon_cb.rdata ;
			mon_port.write(item);
		end
	endtask: run_phase	

endclass: dma_monitor 

`endif
