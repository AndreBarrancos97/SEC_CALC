`timescale 1ns/1ps

module multiply_8bits_XOR (
	input rst,
	input  clk,
	input  complement1_sel,
	input  [15:0]a,
	input  [15:0]b,
	input  ci,
	//output co,
	output reg [15:0]sum
	//output reg complement1_finish
);

	wire  aux1;
	wire  aux2;
	wire  aux3;
	wire  aux4;
	wire  aux5;
	wire  aux6;
	wire  aux7;
	wire  aux8;
	wire  aux9;
	wire  aux10;
	wire  aux11;
	wire  aux12;
	wire  aux13;
	wire  aux14;
	wire  aux15;
	wire  [15:0]sum_aux;
	wire  [15:0]a_xor;
	wire  [15:0]aux_xor = 16'b1111111111111111; 

assign a_xor = a ^ aux_xor;

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
		     .co(aux8),
		     .sum(sum_aux[7])
		     );

	full_adder adder8 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[8]),
		     .b(b[8]),
		     .ci(aux8),
		     .co(aux9),
		     .sum(sum_aux[8])
		     );
   
	full_adder adder9 (
			 //.clk(clk),
			 //.rst(rst),
			 .a(a_xor[9]),
		     .b(b[9]),
		     .ci(aux9),
		     .co(aux10),
		     .sum(sum_aux[9])
		     );  
			 
	full_adder adder10 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[10]),
		     .b(b[10]),
		     .ci(aux10),
		     .co(aux11),
		     .sum(sum_aux[10])
		     );

	full_adder adder11 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[11]),
		     .b(b[11]),
		     .ci(aux11),
		     .co(aux12),
		     .sum(sum_aux[11])
		     );

	full_adder adder12 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[12]),
		     .b(b[12]),
		     .ci(aux12),
		     .co(aux13),
		     .sum(sum_aux[12])
		     );

	full_adder adder13 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[13]),
		     .b(b[13]),
		     .ci(aux13),
		     .co(aux14),
		     .sum(sum_aux[13])
		     );

	full_adder adder14 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[14]),
		     .b(b[14]),
		     .ci(aux14),
		     .co(aux15),
		     .sum(sum_aux[14])
		     );

	full_adder adder15 (
			 //.clk(clk),
			 //.rst(rst),
		     .a(a_xor[15]),
		     .b(b[15]),
		     .ci(aux15),
		     .co(),
		     .sum(sum_aux[15])
		     );

always @(posedge clk or posedge rst)
begin
	if (rst)begin
		sum <= 16'd0;
		//complement1_finish <= 1'b0;	
	end

	else if (complement1_sel)begin
	
		if ((a[15] == 1'b0))begin
			sum <= sum_aux;
			//complement1_finish <= 1'b1;
		end

	end
end
endmodule
