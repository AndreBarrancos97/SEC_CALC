`timescale 1ns / 1ps
`include "xdefs.vh"

module xregf (
	      input                    clk,
	      input                    sel,
	      input                    we,
	      input [`REGF_ADDR_W-1:0] addr,
	      input [`DATA_W-1:0]      data_in,
	      output [`DATA_W-1:0]     data_out
	      );

   // register file
   reg [`DATA_W-1:0]                   regf [2**`REGF_ADDR_W-1:0];

   assign data_out = sel? regf[addr] : `DATA_W'h0;
   
   always @ (posedge clk)
      if (sel && we)
	 regf[addr] <= data_in;

endmodule
