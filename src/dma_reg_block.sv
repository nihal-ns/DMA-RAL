`include "register/intr.sv"
`include "register/ctrl.sv"
`include "register/io_addr.sv"
`include "register/mem_addr.sv"
`include "register/extra_info.sv"
`include "register/status.sv"
`include "register/transfer_count.sv"
`include "register/descriptor_addr.sv"
`include "register/error_status.sv"
`include "register/config.sv"

class dma_reg_model extends uvm_reg_block;
  `uvm_object_utils(dma_reg_model)

  rand intr_reg            intr;            
  rand ctrl_reg            ctrl;            
  rand io_addr_reg         io_addr;         
  rand mem_addr_reg        mem_addr;        
  rand extra_info_reg      extra_info;      
  rand status_reg          status;          
  rand transfer_count_reg  transfer_count;  
  rand descriptor_addr_reg descriptor_addr; 
  rand error_status_reg    error_status;    
  rand config_reg          configuration;   

  function new (string name = "dma_reg_model");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  virtual function void build;
		uvm_reg::include_coverage("*", UVM_CVR_FIELD_VALS);
		add_hdl_path("top.DUT","RTL");

    intr = intr_reg::type_id::create("intr");
    intr.build();
    intr.configure(this);

    ctrl = ctrl_reg::type_id::create("ctrl");
    ctrl.build();
    ctrl.configure(this);

    io_addr = io_addr_reg::type_id::create("io_addr");
    io_addr.build();
    io_addr.configure(this);

    mem_addr = mem_addr_reg::type_id::create("mem_addr");
    mem_addr.build();
    mem_addr.configure(this);

    extra_info = extra_info_reg::type_id::create("extra_info");
    extra_info.build();
    extra_info.configure(this);

    status = status_reg::type_id::create("status");
    status.build();
    status.configure(this);

    transfer_count = transfer_count_reg::type_id::create("transfer_count");
    transfer_count.build();
    transfer_count.configure(this);

    descriptor_addr = descriptor_addr_reg::type_id::create("descriptor_addr");
    descriptor_addr.build();
    descriptor_addr.configure(this);

    error_status = error_status_reg::type_id::create("error_status");
    error_status.build();
    error_status.configure(this);

    configuration = config_reg::type_id::create("configuration");
    configuration.build();
    configuration.configure(this);

		intr.add_hdl_path_slice("intr_status", 0,  16);
    intr.add_hdl_path_slice("intr_mask",   16, 16);

		ctrl.add_hdl_path_slice("ctrl_start_dma", 0, 1);
		ctrl.add_hdl_path_slice("ctrl_w_count", 1, 15);
		ctrl.add_hdl_path_slice("ctrl_io_mem", 16, 1);
	
		io_addr.add_hdl_path_slice("io_addr", 0, 32);
		
		mem_addr.add_hdl_path_slice("mem_addr", 0, 32);
		
		extra_info.add_hdl_path_slice("extra_info", 0, 32);
		
		status.add_hdl_path_slice("status_busy", 0, 1);
		status.add_hdl_path_slice("status_done", 1, 1);
		status.add_hdl_path_slice("status_error", 2, 1);
		status.add_hdl_path_slice("status_paused", 3, 1);
		status.add_hdl_path_slice("status_current_state", 4, 4);
		status.add_hdl_path_slice("status_fifo_level", 8, 8);
		
		transfer_count.add_hdl_path_slice("transfer_count", 0, 32);
		
		descriptor_addr.add_hdl_path_slice("descriptor_addr", 0, 32);
		
		error_status.add_hdl_path_slice("error_bus", 0, 1);
		error_status.add_hdl_path_slice("error_timeout", 1, 1);
		error_status.add_hdl_path_slice("error_alignment", 2, 1);
		error_status.add_hdl_path_slice("error_overflow", 3, 1);
		error_status.add_hdl_path_slice("error_underflow", 4, 1);
		error_status.add_hdl_path_slice("error_code", 8, 8);
		error_status.add_hdl_path_slice("error_addr_offset", 16, 16);
		
		configuration.add_hdl_path_slice("config_priority", 0, 2);
		configuration.add_hdl_path_slice("config_auto_restart", 2, 1);
		configuration.add_hdl_path_slice("config_interrupt_enable", 3, 1);
		configuration.add_hdl_path_slice("config_burst_size", 4, 2);
		configuration.add_hdl_path_slice("config_data_width", 6, 2);
		configuration.add_hdl_path_slice("config_descriptor_mode", 8, 1);

    default_map = create_map("my_map", 'h400, 4, UVM_LITTLE_ENDIAN);

    default_map.add_reg(intr,            'h400, "RW");
    default_map.add_reg(ctrl,            'h404, "RW");
    default_map.add_reg(io_addr,         'h408, "RW");
    default_map.add_reg(mem_addr,        'h40C, "RW");
    default_map.add_reg(extra_info,      'h410, "RW");
    default_map.add_reg(status,          'h414, "RO");
    default_map.add_reg(transfer_count,  'h418, "RO");
    default_map.add_reg(descriptor_addr, 'h41C, "RW");
    default_map.add_reg(error_status,    'h420, "RW");
    default_map.add_reg(configuration,   'h424, "RW");

    lock_model();
  endfunction
endclass
