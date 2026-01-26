class intr_seq extends uvm_sequence;
	`uvm_object_utils(intr_seq) 
	dma_reg_model regbk;

	function new (string name = "intr_seq"); 
		super.new(name); 
	endfunction 

	task body;
		uvm_status_e status;
		bit [31:0] w_data, r_data, prev_data, reset_val;

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |---------------------------------------- INTR SEQUENCE STARTED ------------------------------| \n");

		reset_val = regbk.intr.get_reset(); 
		regbk.intr.read(status, r_data); // Frontdoor Read

		if(r_data !== reset_val) 
			`uvm_error(get_type_name(), $sformatf("Reset Mismatch Read: %0d Expected: %0d", r_data, reset_val))
		else
			`uvm_info(get_type_name(), $sformatf("Reset Check Passed (Value: %0d)", r_data), UVM_MEDIUM)

		repeat(3) begin
			w_data = $random;
			regbk.intr.poke(status, w_data);
			prev_data = w_data; 
			`uvm_info(get_type_name(), $sformatf("Poked Initial Value: INTR[15:0](RO)=%0d | INTR[31:16](RW)=%0d", prev_data[15:0], prev_data[31:16]), UVM_MEDIUM)

			void'(std::randomize(w_data) with { w_data != prev_data; }); 

			`uvm_info(get_type_name(), $sformatf("Attempting Write:    INTR[15:0]=%0d | INTR[31:16]=%0d", w_data[15:0], w_data[31:16]), UVM_MEDIUM)

			regbk.intr.write(status, w_data);

			if(status != UVM_IS_OK) 
				`uvm_error(get_type_name(), "INTR register write failed")

			regbk.intr.read(status, r_data);

			if(status != UVM_IS_OK) 
				`uvm_error(get_type_name(), "INTR register read failed")

			`uvm_info(get_type_name(), $sformatf("Read Back Value:     INTR=%0d ", r_data), UVM_MEDIUM)


			$display("***************************************** CHECK *****************************************");
			$display("Field          Expected Behavior    Poked(Old)    Wrote(New)    Read Back");
			$display("-----------------------------------------------------------------------------------------");
			$display("intr_status    RO (Keep Old)        %0d           %0d           %0d", prev_data[15:0], w_data[15:0], r_data[15:0]);
			$display("intr_mask      RW (Update New)      %0d           %0d           %0d", prev_data[31:16], w_data[31:16], r_data[31:16]);
			$display("-----------------------------------------------------------------------------------------");

			if (r_data[15:0] == prev_data[15:0]) 
				`uvm_info(get_type_name(), "PASS: intr_status is RO ", UVM_LOW)
			else 
				`uvm_error(get_type_name(), $sformatf("FAIL: intr_status changed Expected: %0d, Got: %0d", prev_data[15:0], r_data[15:0]))

			if (r_data[31:16] == w_data[31:16]) 
				`uvm_info(get_type_name(), "PASS: intr_mask is RW ", UVM_LOW)
			else 
				`uvm_error(get_type_name(), $sformatf("FAIL: intr_mask did not update Expected: %0d, Got: %0d", w_data[31:16], r_data[31:16]))

			if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
				$display("-----------------------------------------------------------------------------------------");
		end

		regbk.intr.poke(status, 32'h0);

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|--------------------------------- INTR SEQUENCE ENDED ----------------------------------|\n ");
  
	endtask

endclass
