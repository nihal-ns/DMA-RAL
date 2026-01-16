class intr_reg extends uvm_reg;
	`uvm_object_utils(intr_reg)
   
  rand uvm_reg_field intr_status;
  rand uvm_reg_field intr_mask;

  function new (string name = "intr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build; 
    intr_status = uvm_reg_field::type_id::create("status");   
    intr_status.configure(.parent(this), 
                     .size(16), 
                     .lsb_pos(0), 
                     .access("RO"),  
                     .volatile(0), 
                     .reset(0), 
                     .has_reset(1), 
                     .is_rand(1), 
                     .individually_accessible(0)); 
    
    intr_mask = uvm_reg_field::type_id::create("mask");   
    intr_mask.configure(.parent(this), 
                     .size(16), 
                     .lsb_pos(16), 
                     .access("RW"),  
                     .volatile(0), 
                     .reset(0), 
                     .has_reset(1), 
                     .is_rand(1), 
                     .individually_accessible(0));    
    endfunction
endclass
