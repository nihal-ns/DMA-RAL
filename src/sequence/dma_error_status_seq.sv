class error_status_seq extends uvm_sequence;
	`uvm_object_utils(error_status_seq) 
	dma_reg_model regbk;

	function new (string name = "error_status_seq"); 
		super.new(name); 
	endfunction 

	task body; 
		uvm_status_e status;
		bit [31:0] w_data, r_data, prev_data, reset_val;

	// Helpers variable
		bit [4:0]  poked_errs, write_errs, read_errs;
		bit [7:0]  poked_code, read_code;
		bit [15:0] poked_offset, read_offset;

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n |---------------------------------------- ERROR_STATUS SEQUENCE STARTED ------------------------------| \n");

		reset_val = regbk.error_status.get_reset(); 
		regbk.error_status.read(status, r_data); 

		if(r_data !== reset_val) 
			`uvm_error(get_type_name(), $sformatf("Reset Mismatch Read: %0d Expected: %0d", r_data, reset_val))
		else
			`uvm_info(get_type_name(), $sformatf("Reset Check Passed (Value: %0d)", r_data), UVM_MEDIUM)

		repeat(3) begin
		// We force the register to a Bad State (All errors active)
		// This allows us to test if writing 1 clears them, and writing 0 keeps them.
			w_data = $random;
			w_data[4:0] = 5'b11111; // Force ALL error bits to 1
			w_data[7:5] = 3'b000;   // Reserved must be 0

			regbk.error_status.poke(status, w_data);
			prev_data = w_data; 

			`uvm_info(get_type_name(), $sformatf("Poked Initial Value: ERROR_STATUS=%0d", prev_data), UVM_MEDIUM)

			void'(std::randomize(w_data) with { 
				w_data != prev_data; 
				w_data[7:5] == 0; 
			}); 

			`uvm_info(get_type_name(), $sformatf("Attempting Write:    ERROR_STATUS=%0d", w_data), UVM_MEDIUM)

			regbk.error_status.write(status, w_data);

			if(status != UVM_IS_OK) 
				`uvm_error(get_type_name(), "ERROR_STATUS register write failed")

			regbk.error_status.read(status, r_data);

			if(status != UVM_IS_OK) 
				`uvm_error(get_type_name(), "ERROR_STATUS register read failed")

			`uvm_info(get_type_name(), $sformatf("Read Back Value:     ERROR_STATUS=%0d", r_data), UVM_MEDIUM)

			poked_errs   = prev_data[4:0];   // Should be 11111
			poked_code   = prev_data[15:8];
			poked_offset = prev_data[31:16];

			write_errs   = w_data[4:0];      // The mask we wrote

			read_errs    = r_data[4:0];
			read_code    = r_data[15:8];
			read_offset  = r_data[31:16];

			$display("***************************************** CHECK *****************************************");
			$display("Field                Behavior             Poked(State)  Wrote(Mask)   Read Back");
			$display("-----------------------------------------------------------------------------------------");
			$display("Error Bits [4:0]     W1C (1=Clr, 0=Keep)  %5b         %5b         %5b", poked_errs, write_errs, read_errs);
			$display("Error Code [15:8]    RO  (Keep Old)       %0d            %0d            %0d", poked_code, w_data[15:8], read_code);
			$display("Addr Offset[31:16]   RO  (Keep Old)       %0d          %0d          %0d", poked_offset, w_data[31:16], read_offset);
			$display("-----------------------------------------------------------------------------------------");

		// CHECK W1C Fields (Bits 0-4)
		// If poked=1 and write=1 -> result 0 (Cleared)
		// If poked=1 and write=0 -> result 1 (Preserved)
			if (read_errs == (poked_errs & ~write_errs))
				`uvm_info(get_type_name(), "PASS: Error bits followed W1C logic", UVM_LOW)
			else
				`uvm_error(get_type_name(), $sformatf("FAIL: W1C Logic mismatch Exp: %b, Got: %b", (poked_errs & ~write_errs), read_errs))

		// CHECK RO Fields
			if (read_code == poked_code && read_offset == poked_offset)
				`uvm_info(get_type_name(), "PASS: RO fields preserved poked value", UVM_LOW)
			else
				`uvm_error(get_type_name(), "FAIL: RO fields changed after write")

			if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
				$display("-----------------------------------------------------------------------------------------");
		end

		regbk.error_status.poke(status, 32'h0);

		if(m_sequencer.get_report_verbosity_level() >= UVM_MEDIUM)
			$display("\n|--------------------------------- ERROR_STATUS SEQUENCE ENDED ----------------------------------|\n ");
	endtask

endclass
