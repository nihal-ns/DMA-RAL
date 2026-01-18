`ifndef IO_ADDR_SV
`define IO_ADDR_SV

class io_addr_reg extends uvm_reg;
  `uvm_object_utils(io_addr_reg)
   
  rand uvm_reg_field io_addr;
  
  function new (string name = "io_addr_reg");
    super.new(name, 32, UVM_NO_COVERAGE); 
  endfunction

  function void build; 
    io_addr = uvm_reg_field::type_id::create("io_addr");   
    io_addr.configure(.parent(this), 
                   .size(32), 
                   .lsb_pos(0),  
                   .access("RW"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));   
    endfunction
endclass

`endif
