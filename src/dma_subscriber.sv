`ifndef DMA_SUBSCRIBER_INCLUDED_
`define DMA_SUBSCRIBER_INCLUDED_

class dma_subscriber extends uvm_subscriber#(dma_seq_item);
	`uvm_component_utils(dma_subscriber)
  
	dma_seq_item mon_seq;
	real mon_cov;

	// Input coverage
	covergroup dma_cvg ;
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
		ADDR_CP	: coverpoint mon_seq.addr  {
			bins intr_addr            = {[1024:1027]};
			bins ctrl_addr            = {[1028:1031]};
			bins io_addr              = {[1032:1035]};
			bins mem_addr             = {[1036:1039]};
			bins extra_info_addr      = {[1040:1043]};
			bins status_addr          = {[1044:1047]};
			bins transfer_count_addr  = {[1048:1051]};
			bins descriptor_addr      = {[1052:1055]};
			bins error_status_addr    = {[1056:1059]};
			bins configure_addr       = {[1060:1064]};
		}
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
