`timescale 1ns / 1ps


module xdisplay(
		input 	        reset,
		input 	        clk,
		input		  [7:0] val_sel,
	   output reg [7:0] disp_value,
		output reg [3:0] disp_sel
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
