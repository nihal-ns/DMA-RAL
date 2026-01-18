`ifndef DESCRIPTOR_ADDR_SV
`define DESCRIPTOR_ADDR_SV

class descriptor_addr_reg extends uvm_reg;
  `uvm_object_utils(descriptor_addr_reg)
   
  rand uvm_reg_field descriptor_addr;

  function new (string name = "descriptor_addr_reg");
    super.new(name,32,UVM_NO_COVERAGE); //32 -> Register Width
  endfunction

  function void build; 
    descriptor_addr = uvm_reg_field::type_id::create("descriptor_addr");   
    descriptor_addr.configure(.parent(this), 
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
