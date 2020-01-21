`timescale 1ns/1ps

module full_adder_4bits (
  input  [3:0]a,
  input  [3:0]b,
//  input  ci,
  output co,
  output [3:0]sum
);

   wire  ci = 0;
   wire  aux1;
   wire  aux2;
   wire  aux3;
   
  full_adder adder0 (
		     .a(a[0]),
		     .b(b[0]),
		     .ci(ci),
		     .co(aux1),
		     .sum(sum[0])
		     );
   
  full_adder adder1 (
		     .a(a[1]),
		     .b(b[1]),
		     .ci(aux1),
		     .co(aux2),
		     .sum(sum[1])
		     );  
  full_adder adder2 (
		     .a(a[2]),
		     .b(b[2]),
		     .ci(aux2),
		     .co(aux3),
		     .sum(sum[2])
		     );
  full_adder adder3 (
		     .a(a[3]),
		     .b(b[3]),
		     .ci(aux3),
		     .co(co),
		     .sum(sum[3])
		     );

endmodule
