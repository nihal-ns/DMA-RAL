class extra_info_seq extends uvm_sequence;
	`uvm_object_utils(extra_info_seq) 
	dma_reg_model regbk;

	function new (string name = "extra_info_seq"); 
		super.new(name); 
	endfunction 

	task body; 
		uvm_status_e status; 
		bit [31:0] w_data ,r_data; 
		bit [31:0] mirror;
    
		w_data = $urandom();

		`uvm_info(get_type_name(), $sformatf(" EXTRA_INFO[31:0] = %0d", w_data), UVM_MEDIUM) 
		`uvm_info(get_type_name(), $sformatf("Writing EXTRA_INFO= %0d", w_data), UVM_MEDIUM) 
		regbk.reg_file.extra_info.write( status, w_data,.parent(this) ); 

		if (status != UVM_IS_OK) `uvm_error(get_type_name(), "EXTRA_INFO register write failed") 
		
		mirror = regbk.reg_file.extra_info.get_mirrored_value(); 
		`uvm_info(get_type_name(), $sformatf("EXTRA_INFO mirrored = %0d", mirror), UVM_MEDIUM)

		regbk.reg_file.extra_info.read( status, r_data,.parent(this) ); 
		`uvm_info(get_type_name(), $sformatf("Read EXTRA_INFO = %0d", r_data), UVM_MEDIUM) 

		if (status != UVM_IS_OK) `uvm_error(get_type_name(), "EXTRA_INFO register read failed") 
		
		if (r_data != w_data) `uvm_error(get_type_name(), "extra_info mismatch") 
		else `uvm_info(get_type_name(),"EXTRA_INFO register contents passed",UVM_NONE)

		`uvm_info(get_type_name(), $sformatf(" EXTRA_INFO[31:0] = %0d" , r_data), UVM_MEDIUM) 
	endtask

endclass
