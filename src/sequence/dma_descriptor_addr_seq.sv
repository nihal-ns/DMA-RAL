class descriptor_addr_seq extends uvm_sequence;
	`uvm_object_utils(descriptor_addr_seq) 
	dma_reg_model regbk;

	function new (string name = "descriptor_addr_seq"); 
		super.new(name); 
	endfunction 

	task body;
		uvm_status_e status;
		bit [31:0] w_data, r_data, prev_data, reset_val;

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |---------------------------------------- DESCRIPTOR_ADDR SEQUENCE STARTED ------------------------------| \n");

		reset_val = regbk.descriptor_addr.get_reset();
		regbk.descriptor_addr.read(status, r_data);

		if(r_data !== reset_val)
			`uvm_error(get_type_name(), $sformatf("Reset Mismatch Read: %0d Expected: %0d", r_data, reset_val))
		else
			`uvm_info(get_type_name(), $sformatf("Reset Check Passed (Value: %0d)", r_data), UVM_MEDIUM)

		repeat(3) begin
			w_data = $random;
			regbk.descriptor_addr.poke(status, w_data);
			prev_data = w_data;

			`uvm_info(get_type_name(), $sformatf("Poked Initial Value: DESCRIPTOR_ADDR=%0d", prev_data), UVM_MEDIUM)

			void'(std::randomize(w_data) with { w_data != prev_data; });

			`uvm_info(get_type_name(), $sformatf("Attempting Write:    DESCRIPTOR_ADDR=%0d", w_data), UVM_MEDIUM)

			regbk.descriptor_addr.write(status, w_data);

			if(status != UVM_IS_OK)
				`uvm_error(get_type_name(), "DESCRIPTOR_ADDR register write failed")

			regbk.descriptor_addr.read(status, r_data);

			if(status != UVM_IS_OK)
				`uvm_error(get_type_name(), "DESCRIPTOR_ADDR register read failed")

			`uvm_info(get_type_name(), $sformatf("Read Back Value:     DESCRIPTOR_ADDR=%0d", r_data), UVM_MEDIUM)

			$display("***************************************** CHECK *****************************************");
			$display("Field              Expected Behavior    Poked(Old)    Wrote(New)    Read Back");
			$display("-----------------------------------------------------------------------------------------");
			$display("descriptor_addr    RW (Update New)      %0d    %0d     %0d", prev_data, w_data, r_data);
			$display("-----------------------------------------------------------------------------------------");

			if(r_data == w_data)
				`uvm_info(get_type_name(), "PASS: descriptor_addr is RW ", UVM_LOW)
			else
				`uvm_error(get_type_name(), $sformatf("FAIL: descriptor_addr mismatch Exp: %0d, Got: %0d", w_data, r_data))

			if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
				$display("-----------------------------------------------------------------------------------------");
		end

		regbk.descriptor_addr.poke(status, 32'h0);

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|--------------------------------- DESCRIPTOR_ADDR SEQUENCE ENDED ----------------------------------|\n ");
	endtask

endclass
