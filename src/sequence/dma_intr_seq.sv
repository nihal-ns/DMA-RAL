class intr_seq extends uvm_sequence;
	`uvm_object_utils(intr_seq) 
	dma_reg_model regbk;

	function new (string name = "intr_seq"); 
		super.new(name); 
	endfunction 

	task body; 
		uvm_status_e status; 
		bit [31:0] w_data ,r_data, prev_data; 
		bit [31:0] mirror;
		w_data[15:0] = 16'h2323; 
		w_data[31:16] = 16'hABFF; 

		`uvm_info(get_type_name()," <------------ INTR SEQUENCE STARTED -----------> \n", UVM_MEDIUM) 	

		`uvm_info(get_type_name(), $sformatf(" INTR[15:0] = %0d | INTR[31:16] = %0d ", w_data[15:0], w_data[31:16] ), UVM_MEDIUM) 
		`uvm_info(get_type_name(),"Writing w_data to the dut INTR register \n", UVM_MEDIUM) 
		/* regbk.intr.read(status, prev_data, UVM_BACKDOOR); */ 
		/* regbk.intr.write(status, w_data, UVM_BACKDOOR); */ 
		regbk.intr.poke(status, w_data); 
		prev_data = w_data;
		
		w_data[15:0] = 16'h1331; 
		w_data[31:16] = 16'hAABB; 

		regbk.intr.write(status, w_data); 
		`uvm_info(get_type_name(), $sformatf(" INTR[15:0] = %0d | INTR[31:16] = %0d ", w_data[15:0], w_data[31:16] ), UVM_MEDIUM) 

    if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "INTR register write failed\n") 

		`uvm_info(get_type_name()," performing read method ", UVM_MEDIUM) 
 
		regbk.intr.peek(status, r_data); 
		/* regbk.intr.peek(status, r_data); */ 

		`uvm_info(get_type_name(), $sformatf("Read INTR = %0d\n", r_data), UVM_MEDIUM) 

		if (status != UVM_IS_OK) 
			`uvm_error(get_type_name(), "INTR register read failed\n") 

		if (prev_data[15:0] == r_data[15:0]) 
			`uvm_info(get_type_name(), "intr_reg status is read only \n", UVM_NONE) 
		else 
			`uvm_error(get_type_name(),"intr_reg status is read write \n")

		if (prev_data[31:16] == r_data[31:16]) 
			`uvm_error(get_type_name(), "intr_reg mask is read only \n") 
		else 
			`uvm_info(get_type_name(),"intr_reg mask is read write \n",UVM_NONE)

		`uvm_info( get_type_name(), $sformatf( "INTR[15:0] = %0d | INTR[31:16] = %0d\n", r_data[15:0], r_data[31:16] ), UVM_MEDIUM)

		`uvm_info(get_type_name()," <------------ INTR SEQUENCE ENDED ----------->\n ", UVM_MEDIUM) 

		/* uvm_status_e status; */
		/* bit [31:0] w_data, r_data, prev_data; */
		/* regbk.intr.read(status, prev_data, UVM_BACKDOOR); */
		
		/* w_data = $urandom_range(1,30); */
		/* regbk.intr.write(status, w_data, UVM_BACKDOOR); */
		/* regbk.intr.read(status, r_data); */
		/* if(prev_data == r_data) */
		/* 	$display("Read only"); */
		/* else */
		/* 	$display("Read and write"); */
	endtask

endclass
