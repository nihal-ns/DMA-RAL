class status_seq extends uvm_sequence;
	`uvm_object_utils(status_seq) 
	dma_reg_model regbk;

	function new (string name = "status_seq"); 
		super.new(name); 
	endfunction 

	task body;
		uvm_status_e status;
		bit [31:0] w_data, r_data, prev_data;

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |---------------------------------------- STATUS SEQUENCE STARTED ------------------------------| \n");

		regbk.ctrl.write(status, 0, UVM_BACKDOOR);
		regbk.transfer_count.poke(status, 0);

		repeat(5) begin
			w_data = $random;
			w_data[31:16] = 0; 

			w_data[0] = 0; // freezing the status register

			regbk.status.poke(status, w_data);
			prev_data = w_data;

			`uvm_info(get_type_name(), $sformatf("Poked Initial Value : STATUS=%0d", prev_data), UVM_MEDIUM)

			void'(std::randomize(w_data) with {
				w_data != prev_data;
				w_data[31:16] == 0;
			});

			`uvm_info(get_type_name(), $sformatf("Attempting Bus Write : STATUS=%0d", w_data), UVM_MEDIUM)

			regbk.status.write(status, w_data);
			if(status != UVM_IS_OK) 
				`uvm_error(get_type_name(), "STATUS register write failed")

			regbk.status.read(status, r_data);
			if(status != UVM_IS_OK) 
				`uvm_error(get_type_name(), "STATUS register read failed")

			`uvm_info(get_type_name(), $sformatf("Read Back Value:     STATUS=%0d ", r_data), UVM_MEDIUM)

			$display("***************************************** CHECK *****************************************");
			$display("Field          Expected(Poked)      Wrote(Ignored)    Read Back");
			$display("-----------------------------------------------------------------------------------------");
			$display("status         %0d                  %0d               %0d", prev_data, w_data, r_data);
			$display("-----------------------------------------------------------------------------------------");

			if(r_data == prev_data) begin
				`uvm_info(get_type_name(), "PASS: status is RO ", UVM_LOW)
			end else begin
				`uvm_error(get_type_name(), $sformatf("FAIL: status mismatch! Expected: %0d, Got: %0d", prev_data, r_data))
			end

			if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
				$display("-----------------------------------------------------------------------------------------");
		end

		regbk.status.poke(status, 32'h0);

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|--------------------------------- STATUS SEQUENCE ENDED ----------------------------------|\n ");

	endtask

endclass
