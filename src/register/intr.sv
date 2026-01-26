`ifndef INTR_SV
`define INTR_SV

class intr_reg extends uvm_reg;
	`uvm_object_utils(intr_reg)
   
  rand uvm_reg_field intr_status;
  rand uvm_reg_field intr_mask;

	covergroup intr_reg_cov;
		option.per_instance = 1;
		status_cp: coverpoint intr_status.value[15:0] {
			option.auto_bin_max  = 4;
		}
		mask_cp: coverpoint intr_mask.value[15:0]	{
			option.auto_bin_max  = 4;
		}	
	endgroup

  function new (string name = "intr_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
		if(has_coverage(UVM_CVR_FIELD_VALS))
			intr_reg_cov = new();
  endfunction

	function void sample(
		uvm_reg_data_t data,
		uvm_reg_data_t byte_en,
		bit is_read,
		uvm_reg_map map
	);
		intr_reg_cov.sample();
	endfunction

	function void sample_values();
		super.sample_values();
		intr_reg_cov.sample();
	endfunction

  function void build; 
    intr_status = uvm_reg_field::type_id::create("status");   
    intr_status.configure(.parent(this), 
                     .size(16), 
                     .lsb_pos(0), 
                     .access("RO"),  
                     .volatile(0), 
                     .reset(0), 
                     .has_reset(1), 
                     .is_rand(0), 
                     .individually_accessible(1)); 
    
    intr_mask = uvm_reg_field::type_id::create("mask");   
    intr_mask.configure(.parent(this), 
                     .size(16), 
                     .lsb_pos(16), 
                     .access("RW"),  // changed from RW
                     .volatile(0), 
                     .reset(0), 
                     .has_reset(1), 
                     .is_rand(1), 
                     .individually_accessible(1));    
    endfunction
endclass

`endif
