class intr_seq extends uvm_sequence;
	`uvm_object_utils(intr_seq) 
	dma_reg_model regbk;

	function new (string name = "intr_seq"); 
		super.new(name); 
	endfunction 

	task body; 
		uvm_status_e status; 
		bit [31:0] w_data ,r_data, prev_data; 
		w_data[15:0] = $random; 
		w_data[31:16] = $random; 

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |---------------------------------------- INTR SEQUENCE STARTED ------------------------------| \n");

		`uvm_info(get_type_name(), $sformatf(" INTR[15:0] = %0d | INTR[31:16] = %0d ", w_data[15:0], w_data[31:16]), UVM_MEDIUM) 
		`uvm_info(get_type_name(),"Writing w_data to the dut INTR register \n", UVM_MEDIUM) 
		/* regbk.intr.read(status, prev_data, UVM_BACKDOOR); */ 
		regbk.intr.write(status, $random(), UVM_FRONTDOOR); // to skip the reset stage
		regbk.intr.poke(status, w_data); 
		prev_data = w_data;
		
		w_data[15:0] = $random; 
		w_data[31:16] = $random; 

		regbk.intr.write(status, w_data); 
		`uvm_info(get_type_name(), $sformatf(" INTR[15:0] = %0d | INTR[31:16] = %0d ", w_data[15:0], w_data[31:16] ), UVM_MEDIUM) 

    if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "INTR register write failed\n") 

		`uvm_info(get_type_name()," performing read method ", UVM_MEDIUM) 
 
		regbk.intr.peek(status, r_data); 
		/* regbk.intr.peek(status, r_data); */ 

		`uvm_info(get_type_name(), $sformatf("Read INTR = %0d\n", r_data), UVM_MEDIUM) 

		if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "INTR register read failed\n") 

		// Display values
		$display("*****************************************CHECK*****************************************");
		$display("Field\t\t   Write Value\tRead Value");
		$display("intr_status\t     %0d\t    %0d",w_data[15:0], r_data[15:0]);
		$display("intr_mask\t     %0d\t    %0d",w_data[31:16], r_data[31:16]);

		if (prev_data[15:0] == r_data[15:0]) 
			`uvm_info(get_type_name(), "intr_reg status is RO ", UVM_LOW) 
		else 
			`uvm_error(get_type_name(),"intr_reg status is RW ")

		if (prev_data[31:16] == r_data[31:16]) 
			`uvm_error(get_type_name(), "intr_reg mask is RO ") 
		else 
			`uvm_info(get_type_name(),"intr_reg mask is RW ",UVM_LOW)

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|--------------------------------- INTR SEQUENCE ENDED ----------------------------------|\n ");
	endtask

endclass
