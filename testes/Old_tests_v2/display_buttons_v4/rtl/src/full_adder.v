`timescale 1ns/1ps

module full_adder(
  input rst,
  input clk,
  input complement1_sel,
  input  a,
  input  b,
  input  ci,
  output  co,
  output  finished,
  output  sum
);

  /* reg  out_xor;
   reg  out_and1;
   reg  out_and2;*/

   wire  out_xor;
   wire  out_and1;
   wire   out_and2;

   assign out_xor = a ^ b;
   assign out_and1 = out_xor & ci;
   assign out_and2 = a & b;
   assign sum = out_xor ^ ci;
   assign co = out_and1 | out_and2;

/*always @(posedge clk or posedge rst)

begin

  
	if (rst)begin
		co <= 1'b0;
    sum <= 1'b0;
    finished <= 1'b0;
	end

  if (complement1_sel)begin
   out_xor <= a ^ b;
   out_and1 <= out_xor & ci;
   out_and2 <= a & b;
   sum <= out_xor ^ ci;
   co <= out_and1 | out_and2;
   finished <= complement1_sel;
  end

  if (!complement1_sel) begin
    finished <= 1'b0;
  end
end*/
endmodule
