`timescale 1ns/1ps

module full_adder_8bits (
  input  clk,
  input  rst,
  input	 start,
  input  [7:0]a,
  input  [7:0]b,
  //input  ci,
  output done_sum,
  output reg [7:0]sum
);
   wire  co;
   wire  ci = 0;
   wire  aux1;
   wire  aux2;
   wire  aux3;
   wire	 aux4;
   wire  aux5;
   wire  aux6;
   wire  aux7;
   wire   [7:0]aux_sum_final;
   wire done_aux;
	reg [3:0]counter;
	//reg [7:0]a_aux;
	//reg  [7:0]b_aux;
	
  assign done_aux = (counter == 3'd4);
  assign done_sum = (counter == 3'd5);

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
		     .co(aux4),
		     .sum(aux_sum_final[3])
		     );
  full_adder adder4 (
	  		 //.clk(clk),
			 //.rst(rst),	  
		     .a(a[4]),
		     .b(b[4]),
		     .ci(aux4),
		     .co(aux5),
		     .sum(aux_sum_final[4])
		     );
  full_adder adder5 (
	  		 //.clk(clk),
			 //.rst(rst),	  
		     .a(a[5]),
		     .b(b[5]),
		     .ci(aux5),
		     .co(aux6),
		     .sum(aux_sum_final[5])
		     );
  full_adder adder6 (
	  		 //.clk(clk),
			 //.rst(rst),	  
		     .a(a[6]),
		     .b(b[6]),
		     .ci(aux6),
		     .co(aux7),
		     .sum(aux_sum_final[6])
		     );
  full_adder adder7 (
	  		 //.clk(clk),
			 //.rst(rst),	  
		     .a(a[7]),
		     .b(b[7]),
		     .ci(aux7),
		     .co(),
		     .sum(aux_sum_final[7])
		     );


   always@(posedge clk)
     if(rst)begin
       counter <= 3'd6;
       sum <= 8'd0;        
      end
     else if (start)begin
       	counter <= 3'd0;
       	sum <= 8'd0;       
     end
     else if ((counter != 3'd4) && (counter < 8))
       counter <= counter + 1'b1;


	 else if (done_aux)begin
	 		if ((a[7] == 1'b0) & (b[7] == 1'b0) & (aux_sum_final[7] != 1'b0))begin
				sum <= 8'd0;
				counter <= 3'd5;
			end
			else if ((a[7] == 1'b1) & (b[7] == 1'b1) & (aux_sum_final[7] != 1'b1))begin
				sum <= 8'd0;
				counter <= 3'd5;
			end
			else begin
     	    sum <= aux_sum_final;
			counter <= 3'd5;
			end
     end

endmodule
