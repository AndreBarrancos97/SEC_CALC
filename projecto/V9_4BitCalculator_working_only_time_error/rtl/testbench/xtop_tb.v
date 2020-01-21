`timescale 1ns / 1ps

`include "xdefs.vh"

module xtop_tb;
   
   //parameters 
   parameter clk_period = 10;

   //
   // Interface signals
   //
   reg clk;
   reg rst;
   reg Btn3;
   reg Btn2;
   reg [7:0] Sw;
   wire [7:0]		  Led;
   wire [7:0]	  Disp;
   wire [3:0]   Disp_sel;   
   wire trap;
   
`ifdef EXT_BASE
   //external parallel interface
   wire [`ADDR_W-2:0] par_addr;
   wire               par_we;
   reg [`DATA_W-1:0]  par_in;
   wire [`DATA_W-1:0] par_out;
`endif

   //iterator and timer
   integer 		   k, start_time;

   // Testbench data memory
   reg [`DATA_W-1:0] data [2**`REGF_ADDR_W-1:0];
   
   // Instantiate the Unit Under Test (UUT)
   xtop uut (
	          .clk(clk),
             .rst(rst),
	          .Btn3(Btn3),
             .Btn2(Btn2),
	         .Sw(Sw[7:0]),
             .trap(trap),
	     //.Led(Led[7:0]),
             .Disp(Disp[7:0]),
             .Disp_sel(Disp_sel[3:0])
	     
`ifdef EXT_BASE
   	     // external parallel interface
	     , .par_addr(par_addr),
	     .par_we(par_we),
	     .par_in(par_in),
	     .par_out(par_out)
`endif
	     );
   
   initial begin
      
`ifdef DEBUG
      $dumpfile("xtop.vcd");
      $dumpvars(0,xtop_tb);
`endif
        
      // Initialize Inputs
      clk = 1;
      rst = 0;  
      Sw = 8'b10010100; // a e b = -1 e 4 div = 0 mult = -4 sum = 3
      Btn3 = 1'b1;
      Btn2 = 1'b0;
      // assert reset for 1 clock cycle
      #(clk_period+1)
      rst = 1;
      #clk_period;
      rst = 0;
      
      //
      // Run picoVersat
      //
      start_time = $time;

      #50
	   Sw = 8'b00000001;
      Btn3 = 1'b0;
      Btn2 = 1'b1;

      
      #500
      $finish;

      //
      // Dump reg file data to outfile
      //
      for (k = 0; k < 2**`REGF_ADDR_W; k=k+1)
	   data[k] = uut.regf.regf[k];
  
      $writememh("data_out.hex", data, 0, 2**`REGF_ADDR_W - 1);

   end // initial begin


   //
   // End simulation
   //   
   always @(posedge clk)
     if(trap) begin 
        $display("Catched Trap at time  %0d clock cycles:",($time-start_time)/clk_period);
        $display("%s address %d, PC 0x%x", uut.data_we? "Write": "Read", uut.data_addr, uut.pc);
        $finish;
     end 

   // CLOCK
   always 
     #(clk_period/2) clk = ~clk;

   // show registers
   wire [`DATA_W-1:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
   assign r0 = uut.regf.regf[0];
   assign r1 = uut.regf.regf[1];
   assign r2 = uut.regf.regf[2];
   assign r3 = uut.regf.regf[3];
   assign r4 = uut.regf.regf[4];
   assign r5 = uut.regf.regf[5];
   assign r6 = uut.regf.regf[6];
   assign r7 = uut.regf.regf[7];
   assign r8 = uut.regf.regf[8];
   assign r9 = uut.regf.regf[9];
   assign r10 = uut.regf.regf[10];
   assign r11 = uut.regf.regf[11];
   assign r12 = uut.regf.regf[12];
   assign r13 = uut.regf.regf[13];
   assign r14 = uut.regf.regf[14];
   assign r15 = uut.regf.regf[15];  

endmodule

