class transfer_count_seq extends uvm_sequence;
	`uvm_object_utils(transfer_count_seq) 
	dma_reg_model regbk;

	function new (string name = "transfer_count_seq"); 
		super.new(name); 
	endfunction 

	task body;
		uvm_status_e status;
		bit [31:0] w_data, r_data, prev_data, reset_val;

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |---------------------------------------- TRANSFER_COUNT SEQUENCE STARTED ------------------------------| \n");

		reset_val = regbk.transfer_count.get_reset();
		regbk.transfer_count.read(status, r_data);

		if(r_data !== reset_val)
			`uvm_error(get_type_name(), $sformatf("Reset Mismatch Read: %0d Expected: %0d", r_data, reset_val))
		else
			`uvm_info(get_type_name(), $sformatf("Reset Check Passed (Value: %0d)", r_data), UVM_MEDIUM)

		repeat(3) begin
			w_data = $random;
			regbk.transfer_count.poke(status, w_data);
			prev_data = w_data;

			`uvm_info(get_type_name(), $sformatf("Poked Initial Value : %0d", prev_data), UVM_MEDIUM)

			void'(std::randomize(w_data) with { w_data != prev_data; });

			`uvm_info(get_type_name(), $sformatf("Attempting Write:    %0d", w_data), UVM_MEDIUM)

			regbk.transfer_count.write(status, w_data);

			if(status != UVM_IS_OK)
				`uvm_error(get_type_name(), "TRANSFER_COUNT register write failed")

			regbk.transfer_count.read(status, r_data);

			if(status != UVM_IS_OK)
				`uvm_error(get_type_name(), "TRANSFER_COUNT register read failed")

			`uvm_info(get_type_name(), $sformatf("Read Back Value:     %0d", r_data), UVM_MEDIUM)

			$display("***************************************** CHECK *****************************************");
			$display("Field             Expected Behavior    Poked(Old)    Wrote(New)    Read Back");
			$display("-----------------------------------------------------------------------------------------");
			$display("transfer_count    RO (Keep Old)        %0d    %0d    %0d", prev_data, w_data, r_data);
			$display("-----------------------------------------------------------------------------------------");

			if (r_data == prev_data)
				`uvm_info(get_type_name(), "PASS: transfer_count is RO ", UVM_LOW)
			else
				`uvm_error(get_type_name(), $sformatf("FAIL: transfer_count changed Expected (Poked): %0d, Got: %0d", prev_data, r_data))

			if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
				$display("-----------------------------------------------------------------------------------------");
		end

		regbk.transfer_count.poke(status, 32'h0);

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|--------------------------------- TRANSFER_COUNT SEQUENCE ENDED ----------------------------------|\n ");

	endtask

endclass
