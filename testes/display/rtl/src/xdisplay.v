`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:41:01 11/11/2019 
// Design Name: 
// Module Name:    xdisplay 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module xdisplay(
		input 	   reset,
		input 	   clk,
		input			[7:0] val_sel,
	   output reg [7:0]    	disp_value,
		output reg [3:0]      	disp_sel
    );
	
always @(posedge clk,posedge reset)
   if (reset)begin
	  disp_sel <= 4'd0;
	  disp_value <= 8'b0;
	  end
   else begin
	  disp_sel <= 4'd0;
     disp_value <= val_sel;  
	end
	
	
	
endmodule
