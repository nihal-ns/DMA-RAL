`ifndef CTRL_SV
`define CTRL_SV

class ctrl_reg extends uvm_reg;
  `uvm_object_utils(ctrl_reg)
   
  rand uvm_reg_field start_dma;
  rand uvm_reg_field w_count;
  rand uvm_reg_field io_mem;
  rand uvm_reg_field reserved;

	covergroup ctrl_reg_cov;
		option.per_instance = 1;

		start_dma_cp: coverpoint start_dma.value {
			bins start_dma_0 = {0};
			bins start_dma_1 = {1};
		}
		w_count_cp: coverpoint w_count.value[14:0] {
			option.auto_bin_max  = 4;
		}
		io_mem_cp: coverpoint io_mem.value {
			bins io_mem_0 = {0};
			bins io_mem_1 = {1};
		}
	endgroup

  function new (string name = "ctrl_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
		if(has_coverage(UVM_CVR_FIELD_VALS))
			ctrl_reg_cov = new();
  endfunction

	function void sample(
		uvm_reg_data_t data,
		uvm_reg_data_t byte_en,
		bit is_read,
		uvm_reg_map map
	);
		ctrl_reg_cov.sample();
	endfunction

	function void sample_values();
		super.sample_values();
		ctrl_reg_cov.sample();
	endfunction

  function void build; 
    start_dma = uvm_reg_field::type_id::create("start_dma");   
    start_dma.configure(.parent(this), 
                        .size(1), 
                        .lsb_pos(0),  
                        .access("RW"),   
                        .volatile(0),  
                        .reset(0),  
                        .has_reset(1),  
                        .is_rand(1),  
                        .individually_accessible(1));  
    
    w_count = uvm_reg_field::type_id::create("w_count");   
    w_count.configure(.parent(this),  
                      .size(15),  
                      .lsb_pos(1),  
                      .access("RW"),   
                      .volatile(0),  
                      .reset(0),  
                      .has_reset(1),  
                      .is_rand(1),  
                      .individually_accessible(1));     
            
    io_mem = uvm_reg_field::type_id::create("io_mem");   
    io_mem.configure(.parent(this),  
                     .size(1),  
                     .lsb_pos(16),  
                     .access("RW"),    
                     .volatile(0),   
                     .reset(0),   
                     .has_reset(1),   
                     .is_rand(1),   
                     .individually_accessible(1));   
            
    reserved = uvm_reg_field::type_id::create("reserved");   
    reserved.configure(.parent(this),  
                       .size(15),  
                       .lsb_pos(17),  
                       .access("RO"),     
                       .volatile(0),    
                       .reset(0),    
                       .has_reset(1),    
                       .is_rand(0),    // check this again
                       .individually_accessible(1));        
    endfunction
endclass

`endif
