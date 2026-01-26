`ifndef EXTRA_INFO_SV
`define EXTRA_INFO_SV

class extra_info_reg extends uvm_reg;
  `uvm_object_utils(extra_info_reg)
   
  rand uvm_reg_field extra_info;

	covergroup extra_reg_cov;
		option.per_instance = 1;

		extra_info_cp: coverpoint extra_info.value[31:0]	{
			option.auto_bin_max  = 4;
		}	
	endgroup

  function new (string name = "extra_info_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
		if(has_coverage(UVM_CVR_FIELD_VALS))
			extra_reg_cov = new();
  endfunction

	function void sample(
		uvm_reg_data_t data,
		uvm_reg_data_t byte_en,
		bit is_read,
		uvm_reg_map map
	);
		extra_reg_cov.sample();
	endfunction

	function void sample_values();
		super.sample_values();
		extra_reg_cov.sample();
	endfunction

  function void build; 
    extra_info = uvm_reg_field::type_id::create("extra_info"); 
    extra_info.configure(.parent(this), 
                   .size(32), 
                   .lsb_pos(0),  
                   .access("RW"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(1));
    endfunction
endclass

`endif
