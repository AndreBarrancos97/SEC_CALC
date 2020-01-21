`timescale 1ns/1ps

module convert_Neg_to_Pos (
	input rst,
	input  clk,
	input  complement1_sel,
	input  [7:0]a,
	input  [7:0]b,
	input  ci,
	output reg sign,
	output reg [7:0]sum,
	output  complement1_finish
);

	wire  aux1;
	wire  aux2;
	wire  aux3;
	wire  aux4;
	wire  aux5;
	wire  aux6;
	wire  aux7;
	wire complement1_finish_aux;
	reg   [2:0]counter;
	wire  [7:0]sum_aux;
	wire  [7:0]a_xor;
	wire  [7:0]aux_xor = 8'b11111111; 

assign a_xor = a ^ aux_xor;
assign complement1_finish_aux = (counter == 3'd2);
assign complement1_finish = (counter == 3'd3);

	full_adder adder0 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[0]),
		     .b(b[0]),
		     .ci(ci),
		     .co(aux1),
		     .sum(sum_aux[0])
		     );
   
	full_adder adder1 (
			 //.clk(clk),
			 //.rst(rst),
			 .a(a_xor[1]),
		     .b(b[1]),
		     .ci(aux1),
		     .co(aux2),
		     .sum(sum_aux[1])
		     );  
			 
	full_adder adder2 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[2]),
		     .b(b[2]),
		     .ci(aux2),
		     .co(aux3),
		     .sum(sum_aux[2])
		     );

	full_adder adder3 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[3]),
		     .b(b[3]),
		     .ci(aux3),
		     .co(aux4),
		     .sum(sum_aux[3])
		     );

	full_adder adder4 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[4]),
		     .b(b[4]),
		     .ci(aux4),
		     .co(aux5),
		     .sum(sum_aux[4])
		     );

	full_adder adder5 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[5]),
		     .b(b[5]),
		     .ci(aux5),
		     .co(aux6),
		     .sum(sum_aux[5])
		     );

	full_adder adder6 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[6]),
		     .b(b[6]),
		     .ci(aux6),
		     .co(aux7),
		     .sum(sum_aux[6])
		     );

	full_adder adder7 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[7]),
		     .b(b[7]),
		     .ci(aux7),
		     .co(),
		     .sum(sum_aux[7])
		     );

always @(posedge clk or posedge rst)
begin
     if(rst)begin
       counter <= 3'd4;
       sum <= 8'd0;
	   sign <= 1'b0;
	   //complement1_finish <= 1'b0;
       //a_aux <= 4'd0;
       //b_aux <= 4'd0;        
      end
     else if (complement1_sel)begin
       counter <= 3'd0;
       sum <= 8'd0;
	   sign <= 1'b0;
	   //complement1_finish <= 1'b0;
       //a_aux <= a;
       //b_aux <= b;       
       end
	else if ((counter < 3'd2) | (counter > 3'd3))
       counter <= counter + 1'b1;

	else if (complement1_finish_aux)begin

		if ((a[7] == 1'b1))begin
			counter <= 3'd3;
			sum <= sum_aux;
			sign <= 1'b1;
			//complement1_finish <= 1'b1;
		end
		else if (a[7] == 1'b0) begin
			counter <= 3'd3;
			sum <= a;
			sign <= 1'b0;
			//complement1_finish <= 1'b1;
		end
			
	end
	/*else if (complement1_finish)begin
		complement1_finish <= 1'b0;
	end*/
end
endmodule
