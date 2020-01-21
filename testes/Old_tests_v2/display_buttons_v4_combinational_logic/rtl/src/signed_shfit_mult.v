`timescale 1ns / 1ps

module multiply_block (
                     input         clk,
                     input         rst,
                     
                     input [3:0]   a, 
                     input [3:0]   b,
                     output reg [7:0] c,
                     input         start,
                     output        multiply_done
                     );

   //reg [3:0]                    a_aux;
   //reg [3:0]                    b_aux;
   wire                         done;
   reg                         complement_result_sel = 1'b1;
   wire [7:0]                    resulty;
   reg [3:0]                    counter;
   wire [3:0]                    first_nr_aux;
   wire [3:0]                    second_nr_aux;
   wire [7:0]                   sumy;
   reg [7:0]                    aux_sumy;
   reg [7:0]                    aux_sumy_v2;
  //reg                           multiply_done;
multiply_complement_to_2 multiply_comple2(
  .rst(rst),
  .clk(clk),
  .first_nr_reg(a),
  .second_nr_reg(b),
  .complement1_sel(1'b1),
  .first_nr(first_nr_aux),
  .second_nr(second_nr_aux),
  .complement1_finish()
);

multiply_8bits_XOR multiply_complement_result(
	.rst(rst),
	.clk(clk),
	.complement1_sel(complement_result_sel),
	.a(aux_sumy_v2),
	.b(8'd0),
	.ci(1'b1),
	.co(),
	.sum(resulty),
	.complement1_finish()
	);

//   assign multiply_done = (counter == 4'd9);
//   assign done = (counter == 4'd8);

   assign multiply_done = (counter == 4'd8);
   assign done = (counter == 4'd7);

   always@(posedge clk)
     if(rst)begin
       counter <= 4'd4;
       aux_sumy_v2 <= 8'd0;
       //a_aux <= 4'd0;
       //b_aux <= 4'd0;        
      end
     else if (start)begin
       counter <= 4'd0;
       aux_sumy_v2 <= 8'd0;
       //a_aux <= a;
       //b_aux <= b;       
       end
     else if (counter != 4'd11)
       counter <= counter + 1'b1;
   
   
     always@(posedge clk)
     begin
     /*if(rst)begin
       a_aux <= 4'd0;
       b_aux <= 4'd0;
       counter <= 4'd0;
       c <= 8'd0;
       aux_sumy_v2 <= 8'd0;
     end
     if (start)begin
       a_aux <= a;
       b_aux <= b;
       counter <= 4'd0;
       aux_sumy_v2 <= 8'd0;
     end
     if (counter != 4'd11)begin
       counter <= counter + 1'b1;
     end*/
     if((counter>4'd1) & (counter < 4'd6) & (a[3]==1'b0) & (b[3]==1'b0)) begin
        aux_sumy_v2 <= (aux_sumy_v2>>1) + (b[counter-4'd2]? a<<3: 8'd0); 
     end

     if((counter>4'd1) & (counter < 4'd6) & (a[3]==1'b1) & (b[3]==1'b0)) begin
        //aux_sumy_v2 <= (aux_sumy_v2>>>1) + (b[counter]? a<<4: 8'd0);
        //complement_result_sel <= 1'b1;
        aux_sumy_v2 <= (aux_sumy_v2>>1) + (first_nr_aux[counter-4'd2]? b<<3: 8'd0);
     end

     if((counter>4'd1) & (counter < 4'd6) & (a[3]==1'b0) & (b[3]==1'b1)) begin
        //aux_sumy_v2 <= (aux_sumy_v2>>>1) + (a[counter]? b<<4: 8'd0);
        //complement_result_sel <= 1'b1;
        aux_sumy_v2 <= (aux_sumy_v2>>1) + (a[counter-4'd2]? second_nr_aux<<3: 8'd0); 
     end

     if((counter>4'd1) & (counter < 4'd6) & (a[3]==1'b1) & (b[3]==1'b1)) begin
        aux_sumy_v2 <= (aux_sumy_v2>>1) + (first_nr_aux[counter-4'd2]? second_nr_aux<<3: 8'd0); 
     end
     
     if (done)begin
      if (((a[3]==1'b0) & (b[3]==1'b1))||((a[3]==1'b1) & (b[3]==1'b0)))begin
         c <= resulty;
         
      end
      if (((a[3]==1'b0) & (b[3]==1'b0))||((a[3]==1'b1) & (b[3]==1'b1)))begin
         c <= aux_sumy_v2;
      end
     end


     end
endmodule



