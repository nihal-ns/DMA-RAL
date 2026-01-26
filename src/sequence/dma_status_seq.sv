class status_seq extends uvm_sequence;
	`uvm_object_utils(status_seq) 
	dma_reg_model regbk;

	function new (string name = "status_seq"); 
		super.new(name); 
	endfunction 

	task body;
		uvm_status_e status;
		bit [31:0] w_data, r_data, prev_data, reset_val;

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |---------------------------------------- STATUS SEQUENCE STARTED ------------------------------| \n");

		reset_val = regbk.status.get_reset();
		regbk.status.read(status, r_data);

		if(r_data !== reset_val)
			`uvm_error(get_type_name(), $sformatf("Reset Mismatch Read: %0d Expected: %0d", r_data, reset_val))
		else
			`uvm_info(get_type_name(), $sformatf("Reset Check Passed (Value: %0d)", r_data), UVM_MEDIUM)

		repeat(3) begin
			w_data = $random;
			w_data[31:16] = 0;
			regbk.status.poke(status, w_data);
			prev_data = w_data;

			`uvm_info(get_type_name(), $sformatf("Poked Initial Value : STATUS=%0d", prev_data), UVM_MEDIUM)
			
			void'(std::randomize(w_data) with {
                w_data != prev_data;
                w_data[31:16] == 0; // Keep Reserved 0
            });

			`uvm_info(get_type_name(), $sformatf("Attempting Write:    STATUS=%0d", w_data), UVM_MEDIUM)

			regbk.status.write(status, w_data);

			if(status != UVM_IS_OK)
				`uvm_error(get_type_name(), "STATUS register write failed")

			regbk.status.read(status, r_data);

			if(status != UVM_IS_OK)
				`uvm_error(get_type_name(), "STATUS register read failed")

			`uvm_info(get_type_name(), $sformatf("Read Back Value:     STATUS=%0d", r_data), UVM_MEDIUM)

			$display("***************************************** CHECK *****************************************");
			$display("Field          Expected Behavior    Poked(Old)    Wrote(New)    Read Back");
			$display("-----------------------------------------------------------------------------------------");
			$display("status         RO (Keep Old)        %0d           %0d           %0d", prev_data, w_data, r_data);
			$display("-----------------------------------------------------------------------------------------");

			if(r_data == prev_data)
				`uvm_info(get_type_name(), "PASS: status is RO (Ignored Write, kept Poked value)", UVM_LOW)
			else
				`uvm_error(get_type_name(), $sformatf("FAIL: status changed! Expected (Poked): %0d, Got: %0d", prev_data, r_data))

			if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
				$display("-----------------------------------------------------------------------------------------");
		end

		regbk.status.poke(status, 32'h0);

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|--------------------------------- STATUS SEQUENCE ENDED ----------------------------------|\n ");
	endtask

endclass
