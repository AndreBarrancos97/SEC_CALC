`timescale 1ns/1ps
module div_tb;
   //reg clk,rst;
   reg [3:0] D, d;
   wire [3:0] q, r;
   reg        clk, rst;
   reg start;
   wire multiply_done;
    
   division_block div1 (
             .a(D),
             .b(d),
             .q(q),
             .start(start),
             .done_division(),
             .clk(clk),
             .rst(rst)
             );
 
   initial begin
      $dumpfile("dump.vcd");
      $dumpvars();
      rst = 1;
      clk = 1;  
      D = 4'd4;
      d = 4'd2;
      start = 0;
      #40
      
      rst = 0;
      start = 1;
      #10
      start = 0;
      #400;
      D = 0;
      d = 2;
      #100 start = 1;
      #100 start = 0;
      #400;
      D = 9;
      d = 2;
      #100 start = 1;
      #100 start = 0;
      #400;
      D = 3;
      d = 6;
      #100 start = 1;
      #100 start = 0;
      #500;
      $finish;
   end

   always #10 clk = ~clk;
   
endmodule // div_tb

