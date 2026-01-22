class dma_adapter extends uvm_reg_adapter;
	`uvm_object_utils (dma_adapter)

	function new (string name = "dma_adapter");
		super.new (name);
	endfunction: new

	function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		dma_seq_item dma;    
		dma = dma_seq_item::type_id::create("dma");
		dma.wr_en = (rw.kind == UVM_WRITE);
		dma.rd_en = (rw.kind == UVM_READ);
		dma.addr  = rw.addr;
		dma.wdata = rw.data;
		/* if (!dma.wr_en) */ 
		/* 	dma.rdata = rw.data; */
		return dma;
	endfunction: reg2bus

	function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
		dma_seq_item dma;
		assert($cast(dma, bus_item))
		rw.kind = dma.wr_en ? UVM_WRITE : UVM_READ;
		rw.data = dma.wr_en ? dma.wdata : dma.rdata;
		rw.addr = dma.addr;
		rw.status = UVM_IS_OK;
	/* $display("wr_En = %b, rd_En = %B, addr = %d, wdata = %d, rdata = %d", dma.wr_en, dma.rd_en, dma.addr, dma.wdata, dma.rdata); */
	endfunction: bus2reg

endclass: dma_adapter
