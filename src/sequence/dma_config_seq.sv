class config_seq extends uvm_sequence;
	`uvm_object_utils(config_seq) 
	dma_reg_model regbk;

	function new (string name = "config_seq"); 
		super.new(name); 
	endfunction 

	task body; 
		uvm_status_e status; 
		bit [31:0] w_data ,r_data; 
		bit [31:0] mirror;
		w_data[1:0] = 2; 
		w_data[2] = 0;  
		w_data[3] = 1; 
    w_data[5:4] = 3; 
   	w_data[7:6] = 1; 
		w_data[8] = 1; 

		`uvm_info(get_type_name(), $sformatf("CONFIGURE[1:0] = %0d | CONFIGURE[2] = %0d | CONFIGURE[3] = %0d | CONFIGURE[5:4] = %0d | CONFIGURE[7:6] = %0d | CONFIGURE[8] = %0d", w_data[1:0] , w_data[2] , w_data[3] , w_data[5:4] , w_data[7:6] , w_data[8] ), UVM_MEDIUM) 
		`uvm_info(get_type_name(), $sformatf("Writing CONFIGURE = %0d", w_data), UVM_MEDIUM) 
		regbk.reg_file.configuration.write( status, w_data,.parent(this) ); 

    if (status != UVM_IS_OK) `uvm_error(get_type_name(), "CONFIGURE register write failed") 

		mirror = regbk.reg_file.configuration.get_mirrored_value(); 
		`uvm_info(get_type_name(), $sformatf("CONFIGURE mirrored = %0d", mirror), UVM_MEDIUM)

		regbk.reg_file.configuration.read( status, r_data,.parent(this) ); 
		`uvm_info(get_type_name(), $sformatf("Read CONFIGURE = %0d", r_data), UVM_MEDIUM) 

		if (status != UVM_IS_OK) `uvm_error(get_type_name(), "CONFIGURE register read failed") 

		if ( r_data[1:0] != 2 && r_data[2] != 0 && r_data[3] != 1 && r_data[5:4] != 3 && r_data[7:6] != 1 && r_data[8] != 1  ) 
			`uvm_error(get_type_name(), "configure_mem mismatch") 
		
		else `uvm_info(get_type_name(),"CONFIGURE register contents passed",UVM_NONE)

		`uvm_info(get_type_name(), $sformatf("CONFIGURE[1:0] = %0d | CONFIGURE[2] = %0d | CONFIGURE[3] = %0d | CONFIGURE[5:4] = %0d | CONFIGURE[7:6] = %0d | CONFIGURE[8] = %0d", r_data[1:0] , r_data[2] , r_data[3] , r_data[5:4] , r_data[7:6] , r_data[8] ), UVM_MEDIUM) 
		
	endtask

endclass
