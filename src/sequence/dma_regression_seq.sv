class dma_regression_seq extends uvm_sequence;
	`uvm_object_utils(dma_regression_seq)

	dma_reg_model       regbk;
	intr_seq            int_seq;
	ctrl_seq            ct_seq;
	io_addr_seq         io_seq;
	mem_addr_seq        mem_seq;
	extra_info_seq      info_seq;
	status_seq          stat_seq;
	transfer_count_seq  trans_seq;
	descriptor_addr_seq des_seq;
	error_status_seq    err_seq;
	config_seq          con_seq;

	function new(string name = "dma_regression_seq");
		super.new(name);
	endfunction

	task body;
		`uvm_info(get_type_name(), "\n|================== STARTING DMA REGRESSION SEQUENCE ==================|", UVM_LOW)

	// 1. Interrupt Register
		int_seq = intr_seq::type_id::create("int_seq");
		int_seq.regbk = regbk;
		int_seq.start(m_sequencer);

	// 2. Control Register
		ct_seq = ctrl_seq::type_id::create("ct_seq");
		ct_seq.regbk = regbk;
		ct_seq.start(m_sequencer);

	// 3. IO Address Register
		io_seq = io_addr_seq::type_id::create("io_seq");
		io_seq.regbk = regbk;
		io_seq.start(m_sequencer);

	// 4. Memory Address Register
		mem_seq = mem_addr_seq::type_id::create("mem_seq");
		mem_seq.regbk = regbk;
		mem_seq.start(m_sequencer);

	// 5. Extra Info Register
		info_seq = extra_info_seq::type_id::create("info_seq");
		info_seq.regbk = regbk;
		info_seq.start(m_sequencer);

	// 6. Status Register
		stat_seq = status_seq::type_id::create("stat_seq");
		stat_seq.regbk = regbk;
		stat_seq.start(m_sequencer);

	// 7. Transfer Count Register
		trans_seq = transfer_count_seq::type_id::create("trans_seq");
		trans_seq.regbk = regbk;
		trans_seq.start(m_sequencer);

	// 8. Descriptor Address Register
		des_seq = descriptor_addr_seq::type_id::create("des_seq");
		des_seq.regbk = regbk;
		des_seq.start(m_sequencer);

	// 9. Error Status Register
		err_seq = error_status_seq::type_id::create("err_seq");
		err_seq.regbk = regbk;
		err_seq.start(m_sequencer);

	// 10. Configuration Register
		con_seq = config_seq::type_id::create("con_seq");
		con_seq.regbk = regbk;
		con_seq.start(m_sequencer);

		`uvm_info(get_type_name(), "\n|================== DMA REGRESSION SEQUENCE COMPLETED ==================|", UVM_LOW)
	endtask
endclass
