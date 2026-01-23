class mem_addr_seq extends uvm_sequence;
	`uvm_object_utils(mem_addr_seq) 
	dma_reg_model regbk;

	function new (string name = "mem_addr_seq"); 
		super.new(name); 
	endfunction 

	task body; 
		uvm_status_e status;
		bit [31:0] w_data ,r_data;
		bit [31:0] mirror;

		w_data = $urandom();
    
		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|--------------------------- MEM_ADDR SEQUENCE STARTED --------------------------------|\n ");

		`uvm_info(get_type_name(), $sformatf(" Writing MEM_ADDR = %0d\n", w_data), UVM_MEDIUM)
		regbk.mem_addr.write(status, w_data);

		if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "MEM_ADDR register write failed\n")

		regbk.mem_addr.read(status, r_data);
		`uvm_info(get_type_name(), $sformatf("Read MEM_ADDR = %0d\n", r_data), UVM_MEDIUM)

		if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "MEM_ADDR register read failed\n")

		// Display values
		$display("*****************************************CHECK*****************************************");
		$display("Field\t\t   Write Value\t   Read Value");
		$display("mem_addr\t     %0h\t    %0h",w_data, r_data);

		if (r_data != w_data) 
			`uvm_error(get_type_name(), "mem_addr is RO\n")
		else 
			`uvm_info(get_type_name(),"mem_addr is RW",UVM_NONE)
	
		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |------------------------------- MEM_ADDR SEQUENCE ENDED -----------------------------|\n ");
	endtask

endclass
