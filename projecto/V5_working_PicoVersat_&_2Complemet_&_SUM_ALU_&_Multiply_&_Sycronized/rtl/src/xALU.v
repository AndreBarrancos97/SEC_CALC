`timescale 1ns / 1ps

module xALU(
    input clk,
    input rst,
	input alu_sel,
	input wr_enable,
	input [3:0]first_nr,
	input [3:0]second_nr,
	input [3:0]operation,
    output reg [7:0] result_uncoded,
	output	reg alu_done
);
wire	alu_done_aux;
wire	[7:0] multiply_result;
reg		  alu_sel_reg;
reg [3:0] first_nr_reg;
reg [3:0] second_nr_reg;
reg [3:0] operation_reg;
wire co;
wire [7:0]result_finish_adder;
wire [7:0]result_finish_sub;
wire [7:0]result_finish_mult;
wire [7:0]result_finish_div;
wire multiply_done;
wire done_sum;

assign alu_done_aux = ((done_sum == 1'b1)||(multiply_done == 1'b1));


full_adder_4bits adder4bits(
	.clk(clk),
	.rst(rst),
	.start(alu_sel),
	.a(first_nr_reg),
	.b(second_nr_reg),
	.done_sum(done_sum),
	.sum(result_finish_adder)
	);

multiply_block mult(
	.clk(clk),
	.rst(rst),
	.a(first_nr_reg),
	.b(second_nr_reg),
	.start(alu_sel),
	.c(result_finish_mult),
	.multiply_done(multiply_done)
);

always @(posedge rst or posedge clk)
	begin
		if(rst)begin
			first_nr_reg <= 4'b0;
			second_nr_reg <= 4'b0;
			operation_reg <= 4'b0;
			end
		if (alu_sel & wr_enable) begin
			alu_sel_reg <= alu_sel;
			first_nr_reg <= first_nr;
			second_nr_reg <= second_nr;
			operation_reg <= operation;
			end

		if (operation_reg == 4'b0000)begin
			result_uncoded <= 4'd0;
		end

		if ((operation_reg == 4'b0001) & (done_sum))begin
			result_uncoded <= result_finish_adder;
			//alu_done <= (alu_done_aux == 1'b1);
		end	

		if ( (operation_reg == 4'b0010) & (multiply_done))begin
			result_uncoded <= result_finish_mult;
			//alu_done <= (alu_done_aux == 1'b1);
		end	

		if (operation_reg == 4'b0100)begin
			result_uncoded <= result_finish_div;
			//alu_done <= (alu_done_aux == 1'b1);
		end	
		if (!rst)begin
			alu_done <= (alu_done_aux == 1'b1);
		end
	end
 
endmodule

