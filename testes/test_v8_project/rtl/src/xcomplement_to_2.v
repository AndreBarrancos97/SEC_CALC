`timescale 1ns/1ps

module complement_to_2(
  input	 rst,
  input  clk,
  input  [11:0]nr_coded,
  input  complement1_sel,
  input	 wr_enable,
  output reg[3:0]first_nr,
  output reg [3:0]second_nr,
  output reg [3:0]operation,
  output reg complement1_finish
);

	wire [3:0]dumb_0 = 4'b0000;
	wire ci = 1'b1;
	wire complement1_sel_aux;
	wire  complement1_finish_nr1;
	wire  complement1_finish_nr2;
	wire [3:0]first_nr_aux;	
	wire [3:0]second_nr_aux;
	reg [3:0]first_nr_reg;
	reg [3:0]second_nr_reg;
	reg [3:0]oper_nr_reg;

//assign complement1_sel_aux2 = complement1_sel_aux
assign complement1_sel_aux = ((complement1_finish_nr1 == 1'b1) & (complement1_finish_nr1 == 1'b1)) ;

full_adder_4bits_XOR complement_first_nr(
	.rst(rst),
	.clk(clk),
	.complement1_sel(complement1_sel),
	.a(first_nr_reg),
	.b(dumb_0),
	.ci(ci),
	.sum(first_nr_aux),
	.complement1_finish(complement1_finish_nr1)
	);

full_adder_4bits_XOR complement_second_nr(
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
		
		if(rst)begin
			first_nr_reg <= 4'b0;
			second_nr_reg <= 4'b0;
			oper_nr_reg <= 4'b0;
			complement1_finish <= 1'b0;
			end

		else if (complement1_sel & wr_enable) begin
		    
			first_nr_reg <= nr_coded[11:8];
			second_nr_reg <= nr_coded[7:4];
			oper_nr_reg <= nr_coded[3:0];
			end

		else if (complement1_finish_nr2 & complement1_finish_nr1)begin
			complement1_finish <= 1'b1;
			first_nr <= first_nr_aux;
			second_nr <= second_nr_aux;
			operation <= oper_nr_reg;
		end

		else if (!rst)begin
			complement1_finish <= (complement1_sel_aux == 1'b1);
		end
		
	end





endmodule
