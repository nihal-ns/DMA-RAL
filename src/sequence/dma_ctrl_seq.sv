class ctrl_seq extends uvm_sequence;
	`uvm_object_utils(ctrl_seq) 
	dma_reg_model regbk;

	function new (string name = "ctrl_seq"); 
		super.new(name); 
	endfunction 

	task body; 
		uvm_status_e status; 
		bit [31:0] w_data ,r_data; 
		bit [31:0] mirror;
		w_data[0] = 1; 
		w_data[15:1] = 15'd16; 
		w_data[16] = 1; 

		`uvm_info(get_type_name(), $sformatf(" CTRL[0] = %0d | CTRL[15:1] = %0d | CTRL[16] = %0d", w_data[0], w_data[15:1] ,w_data[16]), UVM_MEDIUM) 
		`uvm_info(get_type_name(), $sformatf("Writing CTRL = %0d", w_data), UVM_MEDIUM) 
		regbk.ctrl.write( status, w_data,.parent(this) ); 

    if (status != UVM_IS_OK) `uvm_error(get_type_name(), "CTRL register write failed") 

		mirror = regbk.ctrl.get_mirrored_value(); 
		`uvm_info(get_type_name(), $sformatf("CTRL mirrored = %0d", mirror), UVM_MEDIUM)

		regbk.ctrl.read( status, r_data,.parent(this) ); 
		`uvm_info(get_type_name(), $sformatf("Read CTRL = %0d", r_data), UVM_MEDIUM) 

		if (status != UVM_IS_OK) `uvm_error(get_type_name(), "CTRL register read failed") 

		if (r_data[0] != 1 && r_data[15:1] != 15'd16 && r_data[16] != 1) `uvm_error(get_type_name(), "ctrl_mem mismatch") 
		else `uvm_info(get_type_name(),"CTRL register contents passed",UVM_NONE)

		`uvm_info(get_type_name(), $sformatf(" CTRL[0] = %0d | CTRL[15:1] = %0d | CTRL[16] = %0d", r_data[0], r_data[15:1] ,r_data[16]), UVM_MEDIUM) 
	endtask

endclass
