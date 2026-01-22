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
		@(vif.drv_cb);

		vif.wr_en <= req.wr_en;
		vif.rd_en <= req.rd_en;
		vif.wdata <= req.wdata;
		vif.addr  <= req.addr;
		`uvm_info(get_type_name,$sformatf("Driver: wr:%0b | rd:%0b || data:%0d | addr:%0d", req.wr_en, req.rd_en, req.wdata, req.addr), UVM_MEDIUM)

		repeat(2) @(vif.drv_cb);

		req.rdata = vif.rdata; 

        /* vif.wr_en <= 0; */
        /* vif.rd_en <= 0; */

		/* if(req.rd_en) */
		/* 	@(vif.drv_cb); */
		/* vif.wr_en <= req.wr_en; */
		/* vif.rd_en <= req.rd_en; */
		/* vif.wdata <= req.wdata; */
		/* vif.addr  <= req.addr; */
		/* `uvm_info(get_type_name,$sformatf("\nDriver: wr:%0b | rd:%0b || data:%0d | addr:%0d",req.wr_en, req.rd_en, req.wdata, req.addr), UVM_MEDIUM) */
		/* if(req.rd_en) */ 
		/* 	@(vif.drv_cb); */
		/* else */
		/* 	repeat(2)@(vif.drv_cb); */
	endtask: drive

endclass: dma_driver	

`endif
