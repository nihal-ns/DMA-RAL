class reset_seq extends uvm_sequence;
	`uvm_object_utils(reset_seq)

	dma_reg_model regbk;

	function new (string name = "reset_seq");
		super.new(name);
	endfunction

	task body;
		uvm_status_e status;
		bit [31:0] r_data, expected_val;

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|---------------------------------------- RESET CHECK SEQUENCE STARTED ------------------------------------|\n");

		expected_val = regbk.intr.get_reset();
		regbk.intr.peek(status, r_data); 

		if (r_data !== expected_val) 
			`uvm_error("RESET_CHECK", $sformatf("INTR Mismatch! Backdoor Read: %0d Expected: %0d", r_data, expected_val))
		else
			`uvm_info("RESET_CHECK", $sformatf("INTR Reset Verified (Value: %0d)", r_data), UVM_MEDIUM)

		expected_val = regbk.ctrl.get_reset();
		regbk.ctrl.peek(status, r_data);

		if(r_data !== expected_val) 
			`uvm_error("RESET_CHECK", $sformatf("CTRL Mismatch! Backdoor Read: %0d Expected: %0d", r_data, expected_val))
		else
			`uvm_info("RESET_CHECK", $sformatf("CTRL Reset Verified (Value: %0d)", r_data), UVM_MEDIUM)

		expected_val = regbk.io_addr.get_reset();
		regbk.io_addr.peek(status, r_data);

		if(r_data !== expected_val) 
			`uvm_error("RESET_CHECK", $sformatf("IO_ADDR Mismatch! Backdoor Read: %0d Expected: %0d", r_data, expected_val))
		else
			`uvm_info("RESET_CHECK", $sformatf("IO_ADDR Reset Verified (Value: %0d)", r_data), UVM_MEDIUM)

		expected_val = regbk.mem_addr.get_reset();
		regbk.mem_addr.peek(status, r_data);

		if (r_data !== expected_val) 
			`uvm_error("RESET_CHECK", $sformatf("MEM_ADDR Mismatch! Backdoor Read: %0d Expected: %0d", r_data, expected_val))
		else
			`uvm_info("RESET_CHECK", $sformatf("MEM_ADDR Reset Verified (Value: %0d)", r_data), UVM_MEDIUM)

		expected_val = regbk.extra_info.get_reset();
		regbk.extra_info.peek(status, r_data);

		if(r_data !== expected_val) 
			`uvm_error("RESET_CHECK", $sformatf("EXTRA_INFO Mismatch! Backdoor Read: %0d Expected: %0d", r_data, expected_val))
		else
			`uvm_info("RESET_CHECK", $sformatf("EXTRA_INFO Reset Verified (Value: %0d)", r_data), UVM_MEDIUM)

		expected_val = regbk.status.get_reset();
		regbk.status.peek(status, r_data);

		if(r_data !== expected_val) 
			`uvm_error("RESET_CHECK", $sformatf("STATUS Mismatch! Backdoor Read: %0d Expected: %0d", r_data, expected_val))
		else
			`uvm_info("RESET_CHECK", $sformatf("STATUS Reset Verified (Value: %0d)", r_data), UVM_MEDIUM)

		expected_val = regbk.transfer_count.get_reset();
		regbk.transfer_count.peek(status, r_data);

		if(r_data !== expected_val) 
			`uvm_error("RESET_CHECK", $sformatf("TRANSFER_COUNT Mismatch! Backdoor Read: %0d Expected: %0d", r_data, expected_val))
		else
			`uvm_info("RESET_CHECK", $sformatf("TRANSFER_COUNT Reset Verified (Value: %0d)", r_data), UVM_MEDIUM)

		expected_val = regbk.descriptor_addr.get_reset();
		regbk.descriptor_addr.peek(status, r_data);

		if(r_data !== expected_val) 
			`uvm_error("RESET_CHECK", $sformatf("DESCRIPTOR_ADDR Mismatch! Backdoor Read: %0d Expected: %0d", r_data, expected_val))
		else
			`uvm_info("RESET_CHECK", $sformatf("DESCRIPTOR_ADDR Reset Verified (Value: %0d)", r_data), UVM_MEDIUM)

		expected_val = regbk.error_status.get_reset();
		regbk.error_status.peek(status, r_data);

		if(r_data !== expected_val) 
			`uvm_error("RESET_CHECK", $sformatf("ERROR_STATUS Mismatch! Backdoor Read: %0d Expected: %0d", r_data, expected_val))
		else
			`uvm_info("RESET_CHECK", $sformatf("ERROR_STATUS Reset Verified (Value: %0d)", r_data), UVM_MEDIUM)

		expected_val = regbk.configuration.get_reset();
		regbk.configuration.read(status, r_data, UVM_BACKDOOR);

		if(r_data !== expected_val) 
			`uvm_error("RESET_CHECK", $sformatf("CONFIG Mismatch! Backdoor Read: %0d Expected: %0d", r_data, expected_val))
		else
			`uvm_info("RESET_CHECK", $sformatf("CONFIG Reset Verified (Value: %0d)", r_data), UVM_MEDIUM)

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|---------------------------------------- RESET CHECK SEQUENCE ENDED --------------------------------------|\n");
	endtask

endclass
