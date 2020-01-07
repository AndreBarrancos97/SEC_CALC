`timescale 1ns / 1ps
`include "xdefs.vh"

module xled (
		input	   reset,
		input 	    clk,
		input 	    sel,
		input  	data_in,
		output reg led
		);

 always @(posedge clk,posedge reset)
   if (reset)
     led <= 1'b0;
   else if(sel)
     led <= data_in;
     

endmodule
