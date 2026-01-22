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

		`uvm_info(get_type_name(),"\n|------------------------------ EXTRA_INFO SEQUENCE STARTED -------------------------------|\n ", UVM_MEDIUM)

		`uvm_info(get_type_name(), $sformatf("Writing EXTRA_INFO= %0d\n", w_data), UVM_MEDIUM)
		regbk.extra_info.write(status, w_data);

		if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "EXTRA_INFO register write failed")

		regbk.extra_info.read(status, r_data);
		`uvm_info(get_type_name(), $sformatf("Read EXTRA_INFO = %0d\n", r_data), UVM_MEDIUM)

		if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "EXTRA_INFO register read failed")

		// Display values
		$display("*****************************************CHECK*****************************************");
		$display("Field\t\t   Write Value\t   Read Value");
		$display("extra_info\t     %0h\t    %0h",w_data, r_data);

		if (r_data != w_data) 
			`uvm_error(get_type_name(), "extra_info is RO")
		else 
			`uvm_info(get_type_name(),"extra_info is RW",UVM_NONE)

		`uvm_info(get_type_name(),"\n|------------------------------------- EXTRA_INFO SEQUENCE ENDED ---------------------------------------|\n ", UVM_MEDIUM)
	endtask

endclass
