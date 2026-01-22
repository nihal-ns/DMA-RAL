class io_addr_seq extends uvm_sequence;
	`uvm_object_utils(io_addr_seq) 
	dma_reg_model regbk;

	function new (string name = "io_addr_seq"); 
		super.new(name); 
	endfunction 

	task body; 
		uvm_status_e status; 
		bit [31:0] w_data ,r_data; 
    
		w_data = $urandom();

		`uvm_info(get_type_name()," \n|---------------------------- IO_ADDR SEQUENCE STARTED -----------------------------------|\n ", UVM_MEDIUM) 	

		`uvm_info(get_type_name(), $sformatf("Writing IO_ADDR = %0d\n", w_data), UVM_MEDIUM) 
		regbk.io_addr.write(status, w_data ); 

		if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "IO_ADDR register write failed\n") 

		regbk.io_addr.read(status, r_data); 
		`uvm_info(get_type_name(), $sformatf("Read IO_ADDR = %0d\n", r_data), UVM_MEDIUM) 

		if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "IO_ADDR register read failed\n") 
		
		// Display values
		$display("*****************************************CHECK*****************************************");
		$display("Field\t\t   Write Value\t   Read Value");
		$display("io_addr\t     %0h\t    %0h",w_data, r_data);

		if (r_data != w_data) 
			`uvm_error(get_type_name(), "io_addr is RO") 
		else 
			`uvm_info(get_type_name(),"io_addr is RW ",UVM_NONE)
		
		`uvm_info(get_type_name(),"\n|--------------------------------------- IO_ADDR SEQUENCE ENDED ----------------------------------|\n ", UVM_MEDIUM) 	
	endtask

endclass
