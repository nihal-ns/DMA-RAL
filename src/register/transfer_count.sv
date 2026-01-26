`ifndef TRANSFER_COUNT_SV
`define TRANSFER_COUNT_SV

class transfer_count_reg extends uvm_reg;
  `uvm_object_utils(transfer_count_reg)
   
  rand uvm_reg_field transfer_count;

	covergroup transfer_count_reg_cov;
		option.per_instance = 1;

		transfer_count_cp: coverpoint transfer_count.value[31:0]	{
			option.auto_bin_max  = 4;
		}	
	endgroup

  function new (string name = "transfer_count_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
		if(has_coverage(UVM_CVR_FIELD_VALS))
			transfer_count_reg_cov = new();
  endfunction

	function void sample(
		uvm_reg_data_t data,
		uvm_reg_data_t byte_en,
		bit is_read,
		uvm_reg_map map
	);
		transfer_count_reg_cov.sample();
	endfunction

	function void sample_values();
		super.sample_values();
		transfer_count_reg_cov.sample();
	endfunction

  function void build; 
    transfer_count = uvm_reg_field::type_id::create("transfer_count");   
    transfer_count.configure(.parent(this), 
                   .size(32), 
                   .lsb_pos(0),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(0),  
                   .individually_accessible(1));   
    endfunction
endclass

`endif
