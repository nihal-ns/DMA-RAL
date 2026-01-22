interface dma_intf(input bit clk, rst_n);

  logic wr_en;
  logic rd_en;
  logic [31:0] addr;
  logic [31:0] wdata;
  logic [31:0] rdata;
  
  clocking drv_cb @(posedge clk);
    /* default input #0 output #0; */
    output addr;
    output wr_en;
    output rd_en;
    output wdata;
		input rdata;
  endclocking: drv_cb
  
  clocking mon_cb @(posedge clk);
    /* default input #0 output #0; */
    input addr;
    input wr_en;
    input rd_en;
    input wdata;
    input rdata;  
  endclocking: mon_cb
  
endinterface: dma_intf
