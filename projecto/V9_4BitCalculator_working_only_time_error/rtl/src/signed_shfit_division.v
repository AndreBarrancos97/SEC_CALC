`timescale 1ns / 1ps

module division_block (
                     input         clk,
                     input         rst,
                     
                     input [3:0]   a, 
                     input [3:0]   b,
                     output reg [7:0] q,
                     input         start,
                     output        done_division
                     );
   
   
   wire [3:0]                        quociente_XOR;
   wire                          done_valid;
   wire [3:0]                   quociente;
   reg [3:0]                    D_aux;
   reg [3:0]                    divider_aux;
   reg [3:0]                    counter;
   wire [3:0]                    first_nr_aux;
   wire [3:0]                    second_nr_aux;
   
   reg                         start_aux;
   wire                         done_valid_xor;

division_complement_to_2 multiply_comple2(
  .rst(rst),
  .clk(clk),
  .first_nr_reg(a),
  .second_nr_reg(b),
  .complement1_sel(1'b1),
  .first_nr(first_nr_aux),
  .second_nr(second_nr_aux)
  //.complement1_finish()
);

div_par div1 (
   .clk(clk),
   .start(start_aux),   
   .D(D_aux),
   .divider(divider_aux),
   .q(quociente),
   .r(),
   .valid(done_valid)
);

division_4bits_XOR result_div(
	.rst(rst),
	.clk(clk),
	.complement1_sel(done_valid),
	.a({1'b1,quociente[2:0]}),
	//.a(quociente[3:0]),
  .b(4'd0),
	.ci(1'b1),
	.sum(quociente_XOR),
	.complement1_finish()
);
   assign done_division = (counter == 4'd11); 
   assign done_valid_xor = (counter == 4'd10);

   always@(posedge clk)
     if(rst)begin
       counter <= 4'd4;
      end
     else if (start)begin
       counter <= 4'd0; 
       end
     else if (counter != 4'd12)
       counter <= counter + 1'b1;
   
   
     always@(posedge clk)
     begin
     start_aux <= 1'b0;
     if((counter == 4'd2) & (a[3]==1'b0) & (b[3]==1'b0)) begin
         D_aux <= a;
         divider_aux <= b;
         start_aux <= 1'b1;
     end

     if((counter == 4'd2) & (a[3]==1'b1) & (b[3]==1'b0)) begin
         D_aux <= first_nr_aux;
         divider_aux <= b;
         start_aux <= 1'b1;
     end

     if((counter == 4'd2) & (a[3]==1'b0) & (b[3]==1'b1)) begin
         D_aux <= a;
         divider_aux <= second_nr_aux;
         start_aux <= 1'b1;
     end

     if((counter == 4'd2) & (a[3]==1'b1) & (b[3]==1'b1)) begin
         D_aux <= first_nr_aux;
         divider_aux <= second_nr_aux;
         start_aux <= 1'b1;
     end
     
     if (done_valid_xor)begin
      if (a == 4'b0000 || a == 4'b1000 || b == 4'b0000 || b == 4'b1000)begin
        q <= 8'd0;
      end
      else if (((a[3]==1'b0) & (b[3]==1'b1))||((a[3]==1'b1) & (b[3]==1'b0)))begin
         q <= {5'b11111,quociente_XOR[2:0]};
         
      end
      else if (((a[3]==1'b0) & (b[3]==1'b0))||((a[3]==1'b1) & (b[3]==1'b1)))begin
         q <= {4'b0000,quociente};
      end
     end


     end
endmodule



