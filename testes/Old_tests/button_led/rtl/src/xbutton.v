`timescale 1ns / 1ps
`include "xdefs.vh"

module xbutton (
		input 	   reset,
		input 	   clk,
		input      push_button,
		input 	   button_sel,
		output reg button
		);

 always @(posedge clk,posedge reset)
   if (button_sel && push_button)
     button <= 1'b1;
     

endmodule
