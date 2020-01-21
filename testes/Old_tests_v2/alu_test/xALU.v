`timescale 1ns / 1ps

module xALU(
    input clk,
    input rst,
	//input led0_sel,
	//input wr_enable,
	input [11:0] nr_coded,
    output reg [3:0] result_uncoded
);

reg [3:0] first_nr_reg;
reg [3:0] second_nr_reg;
reg [3:0] oper_nr_reg;
wire co;
wire [3:0]result_finish_adder;
wire [3:0]result_finish_sub;
wire [3:0]result_finish_mult;
wire [3:0]result_finish_div;


/*wire first_nr_reg;
wire second_nr_reg;
wire oper_nr_reg;
wire co;
wire result_finish;*/
full_adder_4bits adder4bits(
	.a(first_nr_reg),
	.b(second_nr_reg),
	.co(),
	.sum(result_finish_adder)
	);

always @(posedge rst or posedge clk)
	begin
		if(rst)begin
			first_nr_reg <= 4'b0;
			second_nr_reg <= 4'b0;
			oper_nr_reg <= 4'b0;
			end
		if (!rst) begin
			first_nr_reg <= nr_coded[3:0];
			second_nr_reg <= nr_coded[7:4];
			oper_nr_reg <= nr_coded[11:8];
			end
	end



always @*
	begin
	
		if (oper_nr_reg == 4'b0000)begin
			result_uncoded <= 4'd0;
		end

		if (oper_nr_reg == 4'b0001)begin
			result_uncoded <= result_finish_adder;
		end		
	end 
endmodule

