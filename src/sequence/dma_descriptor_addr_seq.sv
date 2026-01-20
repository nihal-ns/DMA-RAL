class descriptor_addr_seq extends uvm_sequence;
	`uvm_object_utils(descriptor_addr_seq) 
	dma_reg_model regbk;

	function new (string name = "descriptor_addr_seq"); 
		super.new(name); 
	endfunction 

	task body; 
		uvm_status_e status; 
		bit [31:0] w_data ,r_data; 
		bit [31:0] mirror;
    
		w_data = $urandom();

		`uvm_info(get_type_name(), $sformatf(" DESCRIPTOR_ADDR[31:0] = %0d", w_data), UVM_MEDIUM) 
		`uvm_info(get_type_name(), $sformatf(" Writing DESCRIPTOR_ADDR = %0d", w_data), UVM_MEDIUM) 
		regbk.descriptor_addr.write( status, w_data,.parent(this) ); 

		if (status != UVM_IS_OK) `uvm_error(get_type_name(), "DESCRIPTOR_ADDR register write failed") 
		
		mirror = regbk.descriptor_addr.get_mirrored_value(); 
		`uvm_info(get_type_name(), $sformatf("DESCRIPTOR_ADDR mirrored = %0d", mirror), UVM_MEDIUM)

		regbk.descriptor_addr.read( status, r_data,.parent(this) ); 
		`uvm_info(get_type_name(), $sformatf("Read DESCRIPTOR_ADDR = %0d", r_data), UVM_MEDIUM) 

		if (status != UVM_IS_OK) `uvm_error(get_type_name(), "DESCRIPTOR_ADDR register read failed") 
		
		if (r_data != w_data) `uvm_error(get_type_name(), "descriptor_addr mismatch") 
		else `uvm_info(get_type_name(),"DESCRIPTOR_ADDR register contents passed",UVM_NONE)

		`uvm_info(get_type_name(), $sformatf(" DESCRIPTOR_ADDR[31:0] = %0d" , r_data), UVM_MEDIUM) 
	endtask

endclass
