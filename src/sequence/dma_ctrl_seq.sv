class ctrl_seq extends uvm_sequence;
	`uvm_object_utils(ctrl_seq) 
	dma_reg_model regbk;

	function new (string name = "ctrl_seq"); 
		super.new(name); 
	endfunction 

	task body;
		uvm_status_e status;
		bit [31:0] w_data, r_data, prev_data, reset_val;

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |---------------------------------------- CTRL SEQUENCE STARTED ------------------------------| \n");

		reset_val = regbk.ctrl.get_reset(); 
		regbk.ctrl.read(status, r_data); 

		if (r_data !== reset_val) 
			`uvm_error(get_type_name(), $sformatf("Reset Mismatch Read: %0d Expected: %0d", r_data, reset_val))
		else
			`uvm_info(get_type_name(), $sformatf("Reset Check Passed (Value: %0d)", r_data), UVM_MEDIUM)

		repeat(3) begin
			w_data = $random;
			w_data[31:17] = 0; // Reserved bits must be 0

			regbk.ctrl.poke(status, w_data);
			prev_data = w_data; 

			`uvm_info(get_type_name(), $sformatf("Poked Initial Value: CTRL=%0d", prev_data), UVM_MEDIUM)

			void'(std::randomize(w_data) with { 
				w_data != prev_data; 
				w_data[31:17] == 0; 
			}); 

			`uvm_info(get_type_name(), $sformatf("Attempting Write:    CTRL=%0d", w_data), UVM_MEDIUM)

			regbk.ctrl.write(status, w_data);

			if (status != UVM_IS_OK) 
				`uvm_error(get_type_name(), "CTRL register write failed")

			regbk.ctrl.read(status, r_data);

			if (status != UVM_IS_OK) 
				`uvm_error(get_type_name(), "CTRL register read failed")

			`uvm_info(get_type_name(), $sformatf("Read Back Value:     CTRL=%0d", r_data), UVM_MEDIUM)

			$display("***************************************** CHECK *****************************************");
			$display("Field          Expected Behavior    Poked(Old)    Wrote(New)    Read Back");
			$display("-----------------------------------------------------------------------------------------");
			$display("io_mem [16]    RW (Update New)      %0d           \t%0d           \t%0d", prev_data[16], w_data[16], r_data[16]);
			$display("w_count[15:1]  RW (Update New)      %0d           %0d           %0d", prev_data[15:1], w_data[15:1], r_data[15:1]);
			$display("start   [0]    Self-Clear (0)       %0d           \t%0d           \t%0d", prev_data[0], w_data[0], r_data[0]);
			$display("-----------------------------------------------------------------------------------------");

		// CHECK IO_MEM (RW)
			if (r_data[16] == w_data[16]) 
				`uvm_info(get_type_name(), "PASS: io_mem is RW ", UVM_LOW)
			else 
				`uvm_error(get_type_name(), $sformatf("FAIL: io_mem mismatch Exp: %0b, Got: %0b", w_data[16], r_data[16]))

		// CHECK W_COUNT (RW)
			if (r_data[15:1] == w_data[15:1]) 
				`uvm_info(get_type_name(), "PASS: w_count is RW ", UVM_LOW)
			else 
				`uvm_error(get_type_name(), $sformatf("FAIL: w_count mismatch Exp: %0d, Got: %0d", w_data[15:1], r_data[15:1]))

		// CHECK START_DMA (Self-Clearing)
			if (r_data[0] == 0) 
				`uvm_info(get_type_name(), "PASS: start_dma auto-cleared to 0", UVM_LOW)
			else 
				`uvm_error(get_type_name(), $sformatf("FAIL: start_dma stuck at 1 Expected 0 Got: %0b", r_data[0]))

			if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
				$display("-----------------------------------------------------------------------------------------");
	end

	regbk.ctrl.poke(status, 32'h0);

	if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
		$display("\n|--------------------------------- CTRL SEQUENCE ENDED ----------------------------------|\n ");
  
	endtask

endclass
