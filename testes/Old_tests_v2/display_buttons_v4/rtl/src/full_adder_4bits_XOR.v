`timescale 1ns/1ps

module full_adder_4bits_XOR (
	input rst,
	input  clk,
	input  complement1_sel,
	input  [3:0]a,
	input  [3:0]b,
	input  ci,
	output co,
	output reg [3:0]sum,
	output reg complement1_finish
);

   //wire  ci = 1'b0;
	wire  aux1;
	wire  aux2;
	wire  aux3;
	reg  [3:0]sum_aux_v2;
	wire  [3:0]sum_aux;
	reg  [3:0]a_xor;
	wire  [3:0]aux_xor = 4'b1111; 
	wire finished1;
	wire finished2;
	wire finished3;
	reg aa;

assign a_xor = a ^ aux_xor;

	full_adder adder0 (
			 .clk(clk),
			 .rst(rst),
			 .complement1_sel(complement1_sel),
		     .a(a_xor[0]),
		     .b(b[0]),
		     .ci(ci),
		     .co(aux1),
		     .sum(sum_aux[0]),
			 .finished(finished1)
		     );
   
	full_adder adder1 (
			 .clk(clk),
			 .rst(rst),
			 .complement1_sel(finished1),
		     .a(a_xor[1]),
		     .b(b[1]),
		     .ci(aux1),
		     .co(aux2),
		     .sum(sum_aux[1]),
			 .finished(finished2)
		     );  
	full_adder adder2 (
			 .clk(clk),
			 .rst(rst),
			 .complement1_sel(finished2),
		     .a(a_xor[2]),
		     .b(b[2]),
		     .ci(aux2),
		     .co(aux3),
		     .sum(sum_aux[2]),
			 .finished(finished3)
		     );
	/*full_adder adder3 (
		     .a(a_xor[3]),
		     .b(b[3]),
		     .ci(aux3),
		     .co(co),
		     .sum(sum_aux[3])
		     );*/

/*always @(posedge clk or posedge rst)
begin
	if (rst)begin
		sum <= 4'b0;
		//finished <= 1'b0;
	end

	if (complement1_sel)begin
		a_xor <= a ^ aux_xor;
	end
	if (finished3)begin
		aa <= 1;
		sum <= {a[3], sum_aux[2:0]};
	end*/
/*	if ((sum_aux_v2[3] == 1'b0))begin
		sum <= a;
		complement1_finish <= 1'b1;
		end
	
	if ((sum_aux_v2[3] == 1'b1))begin
		sum <= sum_aux_v2;
		complement1_finish <= 1'b1;
		end*/

//end
endmodule
