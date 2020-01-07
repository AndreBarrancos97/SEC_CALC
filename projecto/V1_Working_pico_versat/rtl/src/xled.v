`timescale 1ns / 1ps
`include "xdefs.vh"

module xled (
		input 	   reset,
		input 	   clk,
		input 	   led0_sel,
	        input      sw0,
		output reg led0
		);

 always @(posedge clk,posedge reset)
   if (reset)
     led0 <= 1'b0;
   else if(led0_sel && sw0)
     led0 <= 1'b1;
     

endmodule
