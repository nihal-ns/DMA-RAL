package dma_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "dma_reg_block.sv"
		`include "dma_report_server.sv"

    `include "dma_seq_item.sv"
    `include "dma_sequencer.sv"
    `include "dma_driver.sv"
    `include "dma_monitor.sv"
    `include "dma_adapter.sv" 
    `include "dma_subscriber.sv"
    `include "dma_agent.sv"
    `include "dma_env.sv"

    `include "sequence/dma_config_seq.sv"
    `include "sequence/dma_ctrl_seq.sv"
    `include "sequence/dma_descriptor_addr_seq.sv"
    `include "sequence/dma_error_status_seq.sv"  
    `include "sequence/dma_extra_info_seq.sv"
    `include "sequence/dma_intr_seq.sv"         
    `include "sequence/dma_io_addr_seq.sv"
    `include "sequence/dma_mem_addr_seq.sv"
    `include "sequence/dma_status_seq.sv"       
    `include "sequence/dma_transfer_count_seq.sv"
		`include "sequence/dma_regression_seq.sv"

    `include "test/base_test.sv"
    `include "test/dma_config_test.sv"
    `include "test/dma_ctrl_test.sv"
    `include "test/dma_descriptor_addr_test.sv"
    `include "test/dma_error_status_test.sv"
    `include "test/dma_extra_info_test.sv"
    `include "test/dma_intr_test.sv"
    `include "test/dma_io_addr_test.sv"
    `include "test/dma_mem_addr_test.sv"
    `include "test/dma_status_test.sv"
    `include "test/dma_transfer_count_test.sv"
    `include "test/dma_regression_test.sv"

endpackage
