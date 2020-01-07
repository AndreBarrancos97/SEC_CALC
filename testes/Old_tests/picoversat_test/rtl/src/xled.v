`timescale 1ns / 1ps
`include "xdefs.vh"

module xleds (
		input 	   reset,
		input 	   clk,
		input 	   led_sel,
	   input [7:0]    	sw,
		output reg [7:0]      	led
		);

 always @(posedge clk,posedge reset)
   if (reset)
	  led <= 8'b0;
   else if(led_sel)
     led <= sw;
	  
endmodule
