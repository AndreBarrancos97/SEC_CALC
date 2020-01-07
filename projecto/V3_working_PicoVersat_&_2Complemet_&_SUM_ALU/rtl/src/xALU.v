`timescale 1ns / 1ps

module xALU(
    input clk,
    input rst,
	input alu_sel,
	input wr_enable,
	input [3:0]first_nr,
	input [3:0]second_nr,
	input [3:0]operation,
    output reg [3:0] result_uncoded
);

reg [3:0] first_nr_reg;
reg [3:0] second_nr_reg;
reg [3:0] operation_reg;
wire co;
wire [3:0]result_finish_adder;
wire [3:0]result_finish_sub;
wire [3:0]result_finish_mult;
wire [3:0]result_finish_div;


full_adder_4bits adder4bits(
	.clk(clk),
	.rst(rst),
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
			operation_reg <= 4'b0;
			end
		if (alu_sel & wr_enable) begin
			first_nr_reg <= first_nr;
			second_nr_reg <= second_nr;
			operation_reg <= operation;
			end

		if (operation_reg == 4'b0000)begin
			result_uncoded <= 4'd0;
		end

		if (operation_reg == 4'b0001)begin
			result_uncoded <= result_finish_adder;
		end	
		if (operation_reg == 4'b0010)begin
			result_uncoded <= result_finish_sub;
		end

		if (operation_reg == 4'b0100)begin
			result_uncoded <= result_finish_mult;
		end	

		if (operation_reg == 4'b1000)begin
			result_uncoded <= result_finish_div;
		end	
	end
 
endmodule

