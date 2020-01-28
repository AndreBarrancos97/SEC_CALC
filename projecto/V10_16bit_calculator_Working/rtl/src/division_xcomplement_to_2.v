`timescale 1ns/1ps

module division_complement_to_2(
  input	 rst,
  input  clk,
  input	 [7:0]first_nr_reg,
  input	 [7:0]second_nr_reg,
  input  complement1_sel,
  output reg[7:0]first_nr,
  output reg [7:0]second_nr
  //output reg [3:0]operation,
  //output reg complement1_finish
);

	wire [7:0]dumb_0 = 8'd0;
	wire ci = 1'b1;
	wire  complement1_finish_nr1;
	wire  complement1_finish_nr2;
	wire [7:0]first_nr_aux;	
	wire [7:0]second_nr_aux;
	//reg [3:0]first_nr_reg;
	//reg [3:0]second_nr_reg;
	//reg [3:0]oper_nr_reg;

division_4bits_XOR division_complement_first_nr(
	.rst(rst),
	.clk(clk),
	.complement1_sel(complement1_sel),
	.a(first_nr_reg),
	.b(dumb_0),
	.ci(ci),
	.sum(first_nr_aux),
	.complement1_finish(complement1_finish_nr1)
	);

division_4bits_XOR division_complement_second_nr(
	.rst(rst),
	.clk(clk),
	.a(second_nr_reg),
	.complement1_sel(complement1_sel),
	.b(dumb_0),
	.ci(ci),
	.sum(second_nr_aux),
	.complement1_finish(complement1_finish_nr2)
	);

always @(posedge rst or posedge clk)
	begin


		/*if (complement1_sel) begin
		    complement1_sel_delay <= complement1_sel;
			first_nr_reg <= nr_coded[11:8];
			second_nr_reg <= nr_coded[7:4];
			//oper_nr_reg <= nr_coded[3:0];
			end*/
		if (rst)begin
			//complement1_finish <= 1'b0;
			first_nr <= 8'd0;
			second_nr <= 8'd0;		
		end
		else if (complement1_finish_nr2 & complement1_finish_nr1)begin
			//complement1_finish <= 1'b1;
			first_nr <= first_nr_aux;
			second_nr <= second_nr_aux;
			//operation <= oper_nr_reg;
		end
		
	end



endmodule
