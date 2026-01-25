class extra_info_seq extends uvm_sequence;
	`uvm_object_utils(extra_info_seq) 
	dma_reg_model regbk;

	function new (string name = "extra_info_seq"); 
		super.new(name); 
	endfunction 

	task body;
		uvm_status_e status;
		bit [31:0] w_data, r_data, prev_data, reset_val;

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |---------------------------------------- EXTRA_INFO SEQUENCE STARTED ------------------------------| \n");

		reset_val = regbk.extra_info.get_reset();
		regbk.extra_info.read(status, r_data);

		if (r_data !== reset_val)
			`uvm_error(get_type_name(), $sformatf("Reset Mismatch Read: %0d Expected: %0d", r_data, reset_val))
		else
			`uvm_info(get_type_name(), $sformatf("Reset Check Passed (Value: %0d)", r_data), UVM_MEDIUM)

		repeat(3) begin
			w_data = $random;
			regbk.extra_info.poke(status, w_data);
			prev_data = w_data;

			`uvm_info(get_type_name(), $sformatf("Poked Initial Value: EXTRA_INFO=%0d", prev_data), UVM_MEDIUM)

			void'(std::randomize(w_data) with { w_data != prev_data; });

			`uvm_info(get_type_name(), $sformatf("Attempting Write:    EXTRA_INFO=%0d", w_data), UVM_MEDIUM)

			regbk.extra_info.write(status, w_data);

			if(status != UVM_IS_OK)
				`uvm_error(get_type_name(), "EXTRA_INFO register write failed")

			regbk.extra_info.read(status, r_data);

			if(status != UVM_IS_OK)
				`uvm_error(get_type_name(), "EXTRA_INFO register read failed")

			`uvm_info(get_type_name(), $sformatf("Read Back Value:     EXTRA_INFO=%0d", r_data), UVM_MEDIUM)

			$display("***************************************** CHECK *****************************************");
			$display("Field          Expected Behavior    Poked(Old)    Wrote(New)    Read Back");
			$display("-----------------------------------------------------------------------------------------");
			$display("extra_info     RW (Update New)      %0d    %0d     %0d", prev_data, w_data, r_data);
			$display("-----------------------------------------------------------------------------------------");

			if(r_data == w_data)
				`uvm_info(get_type_name(), "PASS: extra_info is RW ", UVM_LOW)
			else
				`uvm_error(get_type_name(), $sformatf("FAIL: extra_info mismatch Exp: %0d, Got: %0d", w_data, r_data))

			if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
				$display("-----------------------------------------------------------------------------------------");
		end

		regbk.extra_info.poke(status, 32'h0);

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|--------------------------------- EXTRA_INFO SEQUENCE ENDED ----------------------------------|\n ");
	endtask

endclass
