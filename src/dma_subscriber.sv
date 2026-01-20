`ifndef DMA_SUBSCRIBER_INCLUDED_
`define DMA_SUBSCRIBER_INCLUDED_

class dma_subscriber extends uvm_subscriber#(dma_seq_item);
	`uvm_component_utils(dma_subscriber)
  
	dma_seq_item mon_seq;
	real mon_cov;

	// Input coverage
	covergroup dma_cvg ;
		// coverpoint pending
		WR_EN_CP : coverpoint mon_seq.wr_en {
			bins wr_0 = {0};
			bins wr_1 = {1};
		}
		RD_EN_CP : coverpoint mon_seq.rd_en { 
			bins rd_0 = {0};
			bins rd_1 = {1};
		}
		WDATA_CP : coverpoint mon_seq.wdata { 
			option.auto_bin_max = 4;
		}
		RDATA_CP : coverpoint mon_seq.rdata { 
			option.auto_bin_max = 4;
		}
		/* ADDR_CP : coverpoint mon_seq.addr  { */
		/* 	// pending */
		/* } */
	endgroup: dma_cvg

	function new(string name = "dma_subscriber", uvm_component parent);
		super.new(name, parent);
		dma_cvg = new;
	endfunction: new
  
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction: build_phase

	function void write(dma_seq_item t);
		mon_seq = t;
		dma_cvg.sample();
	endfunction: write

	function void extract_phase(uvm_phase phase);
		super.extract_phase(phase);
		mon_cov = dma_cvg.get_coverage();
	endfunction: extract_phase

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name, $sformatf("Coverage ------> %0.2f%%,", mon_cov), UVM_MEDIUM);
	endfunction: report_phase

endclass: dma_subscriber

`endif
