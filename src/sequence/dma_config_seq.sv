class config_seq extends uvm_sequence;
	`uvm_object_utils(config_seq) 
	dma_reg_model regbk;

	function new (string name = "config_seq"); 
		super.new(name); 
	endfunction 

	task body;
		uvm_status_e status;
		bit [31:0] w_data, r_data, prev_data, reset_val;

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |---------------------------------------- CONFIG SEQUENCE STARTED ------------------------------| \n");

		reset_val = regbk.configuration.get_reset();
		regbk.configuration.read(status, r_data);

		if(r_data !== reset_val)
			`uvm_error(get_type_name(), $sformatf("Reset Mismatch Read: %0d Expected: %0d", r_data, reset_val))
		else
			`uvm_info(get_type_name(), $sformatf("Reset Check Passed (Value: %0d)", r_data), UVM_MEDIUM)

		repeat(3) begin
			w_data = $random;
			w_data[31:9] = 0; // Reserved bits [31:9] must be 0

			regbk.configuration.poke(status, w_data);
			prev_data = w_data;

			`uvm_info(get_type_name(), $sformatf("Poked Initial Value: CONFIG=%0d", prev_data), UVM_MEDIUM)

			void'(std::randomize(w_data) with {
				w_data != prev_data;
				w_data[31:9] == 0; // Keep Reserved bits 0
			});

			`uvm_info(get_type_name(), $sformatf("Attempting Write:    CONFIG=%0d", w_data), UVM_MEDIUM)

			regbk.configuration.write(status, w_data);

			if(status != UVM_IS_OK)
				`uvm_error(get_type_name(), "CONFIG register write failed")

			regbk.configuration.read(status, r_data);

			if(status != UVM_IS_OK)
				`uvm_error(get_type_name(), "CONFIG register read failed")

			`uvm_info(get_type_name(), $sformatf("Read Back Value:     CONFIG=%0d", r_data), UVM_MEDIUM)

			$display("***************************************** CHECK *****************************************");
			$display("Field (Bits)      Expected(Write)    Read Back    Result");
			$display("-----------------------------------------------------------------------------------------");

		// CHECK Priority [1:0]
			if(r_data[1:0] == w_data[1:0])
				$display("prio [1:0]        %2b                 %2b           PASS", w_data[1:0], r_data[1:0]);
			else
				`uvm_error(get_type_name(), $sformatf("FAIL: prio mismatch Exp: %b, Got: %b", w_data[1:0], r_data[1:0]))

		// CHECK Auto Restart [2]
			if(r_data[2] == w_data[2])
				$display("auto_restart [2]  %1b                  %1b            PASS", w_data[2], r_data[2]);
			else
				`uvm_error(get_type_name(), $sformatf("FAIL: auto_restart mismatch Exp: %b, Got: %b", w_data[2], r_data[2]))

		// CHECK Interrupt Enable [3]
			if(r_data[3] == w_data[3])
				$display("intr_enable [3]   %1b                  %1b            PASS", w_data[3], r_data[3]);
			else
				`uvm_error(get_type_name(), $sformatf("FAIL: intr_enable mismatch Exp: %b, Got: %b", w_data[3], r_data[3]))

		// CHECK Burst Size [5:4]
			if(r_data[5:4] == w_data[5:4])
				$display("burst_size [5:4]  %2b                 %2b           PASS", w_data[5:4], r_data[5:4]);
			else
				`uvm_error(get_type_name(), $sformatf("FAIL: burst_size mismatch Exp: %b, Got: %b", w_data[5:4], r_data[5:4]))

		// CHECK Data Width [7:6]
			if(r_data[7:6] == w_data[7:6])
				$display("data_width [7:6]  %2b                 %2b           PASS", w_data[7:6], r_data[7:6]);
			else
				`uvm_error(get_type_name(), $sformatf("FAIL: data_width mismatch Exp: %b, Got: %b", w_data[7:6], r_data[7:6]))

		// CHECK Descriptor Mode [8]
			if(r_data[8] == w_data[8])
				$display("desc_mode [8]     %1b                  %1b            PASS", w_data[8], r_data[8]);
			else
				`uvm_error(get_type_name(), $sformatf("FAIL: descriptor_mode mismatch Exp: %b, Got: %b", w_data[8], r_data[8]))

			$display("-----------------------------------------------------------------------------------------");

			if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
				$display("-----------------------------------------------------------------------------------------");
		end

		regbk.configuration.poke(status, 32'h0);

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|--------------------------------- CONFIG SEQUENCE ENDED ----------------------------------|\n ");
	endtask

endclass
