`ifndef IO_ADDR_SV
`define IO_ADDR_SV

class io_addr_reg extends uvm_reg;
  `uvm_object_utils(io_addr_reg)
   
  rand uvm_reg_field io_addr;
  
	covergroup io_reg_cov;
		option.per_instance = 1;	

		io_addr_cp: coverpoint io_addr.value[31:0] {
			option.auto_bin_max  = 4;
		}
	endgroup	

  function new (string name = "io_addr_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
		if(has_coverage(UVM_CVR_FIELD_VALS))
			io_reg_cov = new();
  endfunction

	function void sample(
		uvm_reg_data_t data,
		uvm_reg_data_t byte_en,
		bit is_read,
		uvm_reg_map map
	);
		io_reg_cov.sample();
	endfunction

	function void sample_values();
		super.sample_values();
		io_reg_cov.sample();
	endfunction

  function void build; 
    io_addr = uvm_reg_field::type_id::create("io_addr");   
    io_addr.configure(.parent(this), 
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
