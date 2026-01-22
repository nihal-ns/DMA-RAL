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
			item.wr_en = vif.wr_en ;
			item.rd_en = vif.rd_en ;
			item.addr  = vif.addr  ;
			item.wdata = vif.wdata ;
			item.rdata = vif.rdata ;
			`uvm_info(get_type_name,$sformatf("\nMonitor: wr:%0b | rd:%0b || wdata:%0d | rdata:%0d | addr:%0d",vif.wr_en, vif.rd_en, vif.wdata, vif.rdata, vif.addr), UVM_MEDIUM)
			mon_port.write(item);
		end
	endtask: run_phase	

endclass: dma_monitor 

`endif
