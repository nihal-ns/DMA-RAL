`ifndef STATUS_SV
`define STATUS_SV

class status_reg extends uvm_reg;
  `uvm_object_utils(status_reg)
   
  rand uvm_reg_field busy;
  rand uvm_reg_field done;
  rand uvm_reg_field error;
  rand uvm_reg_field paused;
  rand uvm_reg_field current_state;
  rand uvm_reg_field fifo_level;
  rand uvm_reg_field reserved;

	covergroup status_reg_cov;
		option.per_instance = 1;
		busy_cp :coverpoint busy.value {
			bins busy_val = {0,1};
		}
		done_cp: coverpoint done.value {
			bins done_val = {0,1};
		}
		error_cp: coverpoint error.value {
			bins error_val = {0,1};
		}
		paused_cp: coverpoint paused.value {
			bins paused_val = {0,1};
		}
		current_state_cp: coverpoint current_state.value {
			bins current_state_val = {0,1,2,3};
		}
		fifo_level_cp: coverpoint fifo_level.value[7:0] {
			option.auto_bin_max  = 4;
		}
	endgroup

  function new (string name = "status_reg");
		super.new(name,32,UVM_CVR_FIELD_VALS);
		if(has_coverage(UVM_CVR_FIELD_VALS))
			status_reg_cov = new();
	endfunction

	function void sample(
		uvm_reg_data_t data,
		uvm_reg_data_t byte_en,
		bit is_read,
		uvm_reg_map map
	);
		status_reg_cov.sample();
	endfunction

	function void sample_values();
		super.sample_values();
		status_reg_cov.sample();
	endfunction

  function void build; 
    busy = uvm_reg_field::type_id::create("busy");   
    busy.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(0),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(0),  
                   .individually_accessible(1));   

    done = uvm_reg_field::type_id::create("done"); 
    done.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(1),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(0),  
                   .individually_accessible(1));   

    error = uvm_reg_field::type_id::create("error");   
    error.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(2),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(0),  
                   .individually_accessible(1));   

    paused = uvm_reg_field::type_id::create("paused");   
    paused.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(3),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(0),  
                   .individually_accessible(1));   

    current_state = uvm_reg_field::type_id::create("current_state");   
    current_state.configure(.parent(this), 
                   .size(4), 
                   .lsb_pos(4),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(0),  
                   .individually_accessible(1));   

    fifo_level = uvm_reg_field::type_id::create("fifo_level");   
    fifo_level.configure(.parent(this), 
                   .size(8), 
                   .lsb_pos(8),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(0),  
                   .individually_accessible(1));   

    reserved = uvm_reg_field::type_id::create("reserved");   
    reserved.configure(.parent(this), 
                   .size(16), 
                   .lsb_pos(16),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(0),   // check again
                   .individually_accessible(1));   
    endfunction
endclass

`endif
