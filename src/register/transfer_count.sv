class transfer_count_reg extends uvm_reg;
  `uvm_object_utils(transfer_count_reg)
   
  rand uvm_reg_field transfer_count;

  function new (string name = "transfer_count_reg");
    super.new(name,32,UVM_NO_COVERAGE); //32 -> Register Width
  endfunction

  function void build; 
    transfer_count = uvm_reg_field::type_id::create("transfer_count");   
    transfer_count.configure(.parent(this), 
                   .size(32), 
                   .lsb_pos(0),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));   
    endfunction
endclass
