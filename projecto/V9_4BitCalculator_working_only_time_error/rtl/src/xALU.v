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
	output reg alu_done
);
wire 	division_done;
wire	alu_done_aux;
reg [3:0] first_nr_reg;
reg [3:0] second_nr_reg;
reg [3:0] operation_reg;
wire [7:0]result_finish_adder;
wire [7:0]result_finish_mult;
wire [7:0]result_finish_div;
wire multiply_done;
wire done_sum;
wire sum_sel;
wire mult_sel;
wire div_sel;

assign alu_done_aux = ((done_sum == 1'b1)||(multiply_done == 1'b1) || (division_done == 1'b1));

assign sum_sel = (alu_sel & operation[0] & wr_enable);
assign mult_sel = (alu_sel & operation[1] & wr_enable);
assign div_sel = (alu_sel & operation[2] & wr_enable);

full_adder_4bits adder4bits(
	.clk(clk),
	.rst(rst),
	.start(sum_sel),
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
	.start(mult_sel),
	//.start(alu_sel),
	.c(result_finish_mult),
	.multiply_done(multiply_done)
);

division_block divide(
                     .clk(clk),
                     .rst(rst),
                     .a(first_nr_reg), 
                     .b(second_nr_reg),
                     //.start(alu_sel),
					 .start(div_sel),
                     .q(result_finish_div),
                     .done_division(division_done)
                     );

always @(posedge rst or posedge clk)
	begin
		
		if(rst)begin
			first_nr_reg <= 4'b0;
			second_nr_reg <= 4'b0;
			operation_reg <= 4'b0;
			end
		else if (alu_sel & wr_enable) begin
			first_nr_reg <= first_nr;
			second_nr_reg <= second_nr;
			operation_reg <= operation;
			end

		else if (operation_reg == 4'b0000)begin
			result_uncoded <= 4'd0;
		end

		else if ((operation_reg == 4'b0001) & (done_sum))begin
			result_uncoded <= result_finish_adder;
			//alu_done <= (alu_done_aux == 1'b1);
		end	

		else if ( (operation_reg == 4'b0010) & (multiply_done))begin
			result_uncoded <= result_finish_mult;
			//alu_done <= (alu_done_aux == 1'b1);
		end	

		else if( (operation_reg == 4'b0100) & (division_done) )begin
			result_uncoded <= result_finish_div;
			//alu_done <= (alu_done_aux == 1'b1);
		end	
	end

always @(posedge rst or posedge clk)
	begin
		if (rst)begin
			alu_done <= 1'b0;
		end
		else begin
			alu_done <= (alu_done_aux == 1'b1);
		end
	end
endmodule

