`timescale 1ns/1ps

module full_adder(
  input rst,
  input clk,
  input  a,
  input  b,
  input  ci,
  output  co,
  output  sum
);

   wire  out_xor;
   wire  out_and1;
   wire   out_and2;

   assign out_xor = a ^ b;
   assign out_and1 = out_xor & ci;
   assign out_and2 = a & b;
   assign sum = out_xor ^ ci;
   assign co = out_and1 | out_and2;

endmodule
