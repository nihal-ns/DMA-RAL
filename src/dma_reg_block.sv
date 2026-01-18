/* `include "register/ral_pkg.sv" */
/* import ral_pkg::*; */
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
  
  rand intr_reg							reg1; 
  rand ctrl_reg							reg2;
  rand io_addr_reg					reg3;
  rand mem_addr_reg					reg4;
  rand extra_info_reg				reg5;
	rand status_reg						reg6;
	rand transfer_count_reg		reg7;
	rand descriptor_addr_reg	reg8;
	rand error_status_reg			reg9;
	rand config_reg						reg10;
  
  function new (string name = "dma_reg_model");
		super.new(name, UVM_NO_COVERAGE);
  endfunction

  function void build;
    
    reg1 = intr_reg::type_id::create("reg1");
    reg1.build();
    reg1.configure(this);
 
    reg2 = ctrl_reg::type_id::create("reg2");
    reg2.build();
    reg2.configure(this);
    
    reg3 = io_addr_reg::type_id::create("reg3");
    reg3.build();
    reg3.configure(this);
  
    reg4 = mem_addr_reg::type_id::create("reg4");
    reg4.build();
    reg4.configure(this);
    
    reg5 = extra_info_reg::type_id::create("reg5");
    reg5.build();
    reg5.configure(this);
    
    reg6 = status_reg::type_id::create("reg6");
    reg6.build();
    reg6.configure(this);

    reg7 = transfer_count_reg::type_id::create("reg7");
    reg7.build();
    reg7.configure(this);

    reg8 = descriptor_addr_reg::type_id::create("reg8");
    reg8.build();
    reg8.configure(this);

    reg9 = error_status_reg::type_id::create("reg9");
    reg9.build();
    reg9.configure(this);

    reg10= config_reg::type_id::create("reg10");
    reg10.build();
    reg10.configure(this);


		// change the offset pending
    default_map = create_map("my_map", 0, 4, UVM_LITTLE_ENDIAN); // name, base, nBytes
    default_map.add_reg(reg1, 'h400, "RW");  // reg, offset, access
    default_map.add_reg(reg2, 'h404, "RW");
    default_map.add_reg(reg3, 'h408, "RW");
    default_map.add_reg(reg4, 'h40C, "RW");
    default_map.add_reg(reg5, 'h410, "RW");
    default_map.add_reg(reg6, 'h414, "RW");
    default_map.add_reg(reg7, 'h418, "RW");
    default_map.add_reg(reg8, 'h41C, "RW");
    default_map.add_reg(reg9, 'h420, "RW");
    default_map.add_reg(reg10,'h424, "RW");
    
    lock_model();
  endfunction
endclass
