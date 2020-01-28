`timescale 1ns/1ps

module div_par(
           input [7:0]      D,
           input [7:0]      divider,
           input            start,
           output reg [7:0] q,
           output [7:0]     r,
           input            clk,
           output           valid
);

   reg [15:0]                Dext;
   reg [3:0]                cnt;

   assign r = Dext[7:0];

   assign valid = (cnt == 4'b1111);

   always @ (posedge clk) begin 
      if(start) begin
         q <= 8'b11111111;
         cnt <= 8;
      end
      else begin
         if(cnt == 8)
           Dext <= {8'b0, D}; // Dext começa por ficar com o valor de D e tem 8 bits
         else if( (divider<<cnt) > Dext )
           q[cnt] <= 0;
         else
           Dext <= Dext - (divider<<cnt);
         cnt <= (cnt != 4'b1111) ? cnt - 1'b1 : cnt;
      end
   end
endmodule // div





