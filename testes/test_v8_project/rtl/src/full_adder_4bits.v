`timescale 1ns/1ps

module full_adder_4bits (
  input  clk,
  input  rst,
  input	 start,
  input  [3:0]a,
  input  [3:0]b,
  //input  ci,
  output done_sum,
  output reg [7:0]sum
);
   wire  co;
   wire  ci = 0;
   wire  aux1;
   wire  aux2;
   wire  aux3;
   wire   [3:0]aux_sum_final;
   wire done_aux;
	reg [3:0]counter;
	
  assign done_aux = (counter == 2'd2);
  assign done_sum = (counter == 2'd3);

  full_adder adder0 (
	  		 //.clk(clk),
			 //.rst(rst),
		     .a(a[0]),
		     .b(b[0]),
		     .ci(ci),
		     .co(aux1),
		     .sum(aux_sum_final[0])
		     );
   
  full_adder adder1 (
	  		 //.clk(clk),
			 //.rst(rst),	  
		     .a(a[1]),
		     .b(b[1]),
		     .ci(aux1),
		     .co(aux2),
		     .sum(aux_sum_final[1])
		     );  
  full_adder adder2 (
	  		 //.clk(clk),
			 //.rst(rst),	  
		     .a(a[2]),
		     .b(b[2]),
		     .ci(aux2),
		     .co(aux3),
		     .sum(aux_sum_final[2])
		     );
  full_adder adder3 (
	  		 //.clk(clk),
			 //.rst(rst),	  
		     .a(a[3]),
		     .b(b[3]),
		     .ci(aux3),
		     .co(co),
		     .sum(aux_sum_final[3])
		     );

   always@(posedge clk)
     if(rst)begin
       counter <= 4'd4;
       sum <= 8'd0;
       //a_aux <= 4'd0;
       //b_aux <= 4'd0;        
      end
     else if (start)begin
       counter <= 4'd0;
       sum <= 8'd0;
       //a_aux <= a;
       //b_aux <= b;       
       end
     else if (counter < 4'd2)
       counter <= counter + 1'b1;
	   
	 else if (done_aux)begin
     	if((a[3]==1'b0) & (b[3]==1'b0)) begin
        	sum <= {4'b0000,aux_sum_final[3:0]};
			counter <= 4'd3;
     	end

     	else if((a[3]==1'b1) & (b[3]==1'b0)) begin
        	sum <= {4'b1111,aux_sum_final[3:0]};
			counter <= 4'd3;
     	end

     	else if((a[3]==1'b0) & (b[3]==1'b1)) begin
        	sum <= {4'b1111,aux_sum_final[3:0]};
			counter <= 4'd3;
     	end

     	else if((a[3]==1'b1) & (b[3]==1'b1)) begin
			sum <= {4'b1111,aux_sum_final[3:0]};
			counter <= 4'd3;
     	end
	end
   
/*     always@(posedge clk)
     begin
	if (done_aux)begin
     	if((a[3]==1'b0) & (b[3]==1'b0)) begin
        	sum <= {4'b0000,aux_sum_final[3:0]};
     	end

     	if((a[3]==1'b1) & (b[3]==1'b0)) begin
        	sum <= {4'b1111,aux_sum_final[3:0]};
     	end

     	if((a[3]==1'b0) & (b[3]==1'b1)) begin
        	sum <= {4'b1111,aux_sum_final[3:0]};
     	end

     	if((a[3]==1'b1) & (b[3]==1'b1)) begin
			sum <= {4'b1111,aux_sum_final[3:0]};
     	end
	end
	end*/
endmodule
