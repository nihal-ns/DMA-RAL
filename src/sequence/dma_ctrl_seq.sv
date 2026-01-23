class ctrl_seq extends uvm_sequence;
	`uvm_object_utils(ctrl_seq) 
	dma_reg_model regbk;

	function new (string name = "ctrl_seq"); 
		super.new(name); 
	endfunction 

	task body; 
		uvm_status_e status; 
		bit [31:0] w_data ,r_data; 
		bit [31:0] mirror;
		w_data[0] = 1; 
		w_data[15:1] = $random; 
		w_data[16] = 1; 

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |--------------------------------- CTRL SEQUENCE STARTED --------------------------------|\n ");

		`uvm_info(get_type_name(), $sformatf(" CTRL[0] = %0d | CTRL[15:1] = %0d | CTRL[16] = %0d", w_data[0], w_data[15:1] ,w_data[16]), UVM_MEDIUM) 
		`uvm_info(get_type_name(), $sformatf("Writing CTRL = %0d", w_data), UVM_MEDIUM) 
		regbk.ctrl.write(status, w_data); // to skip the initial reset 
		regbk.ctrl.write(status, w_data); 

    if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "CTRL register write failed") 

		regbk.ctrl.read( status, r_data,.parent(this) ); 
		`uvm_info(get_type_name(), $sformatf("Read CTRL = %0d", r_data), UVM_MEDIUM) 

		if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "CTRL register read failed") 

	// Display values
		$display("*****************************************CHECK*****************************************");
		$display("Field\t\t   Write Value\tRead Value");
		$display("ctrl_start_dma     \t%0b\t   %0b",w_data[0], r_data[0]);
		$display("ctrl_w_count\t    %0d\t   %0d",w_data[15:1], r_data[15:1]);
		$display("ctrl_io_mem     \t%0b\t   %0b",w_data[16], r_data[16]);
		
		if (r_data[0] == 0) 
			`uvm_info(get_type_name(),"ctrl_start_dma is RW",UVM_NONE)
		else 
			`uvm_error(get_type_name(), "ctrl_start_dma is RO") 

		if (r_data[15:1] == w_data[15:1]) 
			`uvm_info(get_type_name(),"ctrl_w_count is RW",UVM_NONE)
		else 
			`uvm_error(get_type_name(), "ctrl_w_count is RO") 

		if (r_data[0] == 0) 
			`uvm_info(get_type_name(),"ctrl_start_dma is RO",UVM_NONE)
		else 
			`uvm_error(get_type_name(), "ctrl_start_dma is RW") 
		`uvm_info(get_type_name(), $sformatf(" CTRL[0] = %0d | CTRL[15:1] = %0d | CTRL[16] = %0d", r_data[0], r_data[15:1] ,r_data[16]), UVM_MEDIUM) 

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |------------------------------------ CTRL SEQUENCE ENDED --------------------------------|\n");
	endtask

endclass
