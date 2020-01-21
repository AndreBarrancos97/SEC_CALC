`timescale 1ns / 1ps

module xALU_tb;
   
   //parameters 
   parameter clk_period = 10;

   //
   // Interface signals
   //
   reg clk;
   reg rst;
   reg [11:0]     nr_coded;
   wire [3:0]     result_uncoded;
   

   //iterator and timer
   integer 		  start_time;

   // Instantiate the Unit Under Test (UUT)
   xALU uut (
	      .clk(clk),
         .rst(rst),
	      .nr_coded(nr_coded),
	      .result_uncoded(result_uncoded)
	     );
   
   initial begin
      

      $dumpfile("top.vcd");
      $dumpvars();

        
      // Initialize Inputs
      clk = 1;
      rst = 0;  
      nr_coded = 12'b000100010001;
      
     // assert reset for 1 clock cycle
      #(clk_period+1)
      rst = 1;
      #clk_period;
      rst = 0;
      
      //
      // Run picoVersat
      //
      start_time = $time;

      #200 $finish;

      //
      // Dump reg file data to outfile
      //
   end // initial begin


   // CLOCK
   always 
     #(clk_period/2) clk = ~clk; 

endmodule

