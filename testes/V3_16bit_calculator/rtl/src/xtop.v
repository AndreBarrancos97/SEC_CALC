`timescale 1ns / 1ps
`include "xdefs.vh"



module xtop (
	     input 		  clk,
	     input 		  rst,
		 input	Btn1,
 	     input  Btn3,
		 input  Btn2,
	     input [7:0] Sw,
         output 		  trap,
	     //output [7:0]	  Led,
	     output [7:0]	  Disp,
	     output [3:0]   Disp_sel
				  
		 `ifdef EXT_BASE
		  // external parallel interface
		 , output [`ADDR_W-2:0] par_addr,
	     input [`DATA_W-1:0]  par_in,
         output 		  par_re, 
	     output [`DATA_W-1:0] par_out,
	     output 		  par_we
				  `endif
	     );

   //
   //
   // CONNECTION WIRES
   //
   //
   
   // INSTRUCTION MEMORY INTERFACE
   wire [`INSTR_W-1:0] 		  instruction;
   wire [`ADDR_W-2:0]         pc;

   // DATA BUS
   wire 			          data_sel;
   wire 			          data_we;
   wire [`ADDR_W-1:0] 		  data_addr;
   wire [`DATA_W-1:0] 		  data_to_rd;
   wire [`DATA_W-1:0] 		  data_to_wr;

   
   // ADDRESS DECODER
   wire                       mem_sel;
   wire [`DATA_W-1:0] 		  mem_data_to_rd;
   
   wire				          regf_sel;
   wire [`DATA_W-1:0] 		  regf_data_to_rd;
   wire                       led0_sel;
   wire 					  complement2_sel;
   wire						  alu_sel;
   wire						  display_sel;
   wire		 				  final_result_convert_sel;
   

   wire						  sgn;
   wire						  final_result_convert_finish;
   wire						  alu_finish;
   wire                       complement2_finish;
   wire [7:0]				  first_nr;
   wire [7:0]				  second_nr;
   wire [3:0]				  operation;
   wire [7:0]				  result_uncoded;
   wire [7:0]				  final_result_uncoded;
	
`ifdef DEBUG
   reg 				          cprt_sel;
`endif

`ifdef EXT_BASE
   wire                       ext_sel;
   wire [`DATA_W-1:0]         ext_data_to_rd = par_in;
 
   //External interface
   assign par_addr = data_addr[`ADDR_W-2:0];
   assign par_re = ext_sel & ~data_we;
   assign par_out = data_to_wr;
   assign par_we = ext_sel & data_we;
`endif
   
   
   //
   // CONTROLLER MODULE
   //
   xctrl controller (
		     .clk(clk), 
		     .rst(rst),
		     
		     // Program memory interface
		     .pc(pc),
		     .instruction(instruction),
		     
		     // mem data bus
		     .mem_sel(data_sel),
		     .mem_we (data_we), 
		     .mem_addr(data_addr),
		     .mem_data_from(data_to_rd), 
		     .mem_data_to(data_to_wr)
		     );

   // MEMORY MODULE
   xram ram (
	       .clk(clk),

	       // instruction interface
	       .pc(pc),
       	   .instruction(instruction),

	       //data interface 
	       .data_sel(mem_sel),
	       .data_we(data_we),
	       .data_addr(data_addr[`ADDR_W-2 : 0]),
	       .data_in(data_to_wr),
	       .data_out(mem_data_to_rd)
	       );


   // REGISTER FILE
   xregf regf (
	       .clk(clk),
	       .sel(regf_sel),
	       .we(data_we),
	       .addr(data_addr[`REGF_ADDR_W-1:0]),
	       .data_in(data_to_wr),
	       .data_out(regf_data_to_rd)
	       );

   // INTERNAL ADDRESS DECODER

   xaddr_decoder addr_decoder (
	                       // input select and address
                               .sel(data_sel),
	                           .addr(data_addr),
                            
                               //memory 
	                           .mem_sel(mem_sel),
                               .mem_data_to_rd(mem_data_to_rd),

                               //registers
	                           .regf_sel(regf_sel),
                               .regf_data_to_rd(regf_data_to_rd),
`ifdef DEBUG
                               //debug char printer
	                           .cprt_sel(cprt_sel),
`endif

`ifdef EXT_BASE
                               //external
                               .ext_sel(ext_sel),
                               .ext_data_to_rd(ext_data_to_rd),
`endif

                               //trap
                               .trap_sel(trap),
                               .led0_sel(led0_sel),

							   .btn1_sel(),
							   .btn1_data_to_read(Btn1),

			                   .btn2_sel(),
							   .btn2_data_to_read(Btn2),

			                   .btn3_sel(),
							   .btn3_data_to_read(Btn3),

							   .sw_sel(),
							   .sw2_sel(),
							   .sw3_sel(),
                               .sw_data_to_read(Sw),

							   .alu_sel(alu_sel),
							   .alu_data_to_read(complement2_finish),

							   .final_result_convert_sel(final_result_convert_sel),
							   .final_result_data_to_read(alu_finish),

							   .display_sel(display_sel),
							   .display_data_to_read(final_result_convert_finish),

							   .complement2_sel(complement2_sel),                             
                               //data output 
                               .data_to_rd(data_to_rd)
                               );
   
   //
   //
   // USER MODULES INSERTED BELOW
   //
   //

   convert_Neg_to_Pos convert_final_result(
	   .clk(clk),
	   .rst(rst),
	   .complement1_sel(final_result_convert_sel & data_we),
	   .a(result_uncoded),
	   .b(8'd0),
	   .ci(1'b1),
	   .sign(sgn),
	   .sum(final_result_uncoded),
	   .complement1_finish(final_result_convert_finish)

   );
 	xdispDecoder displayDecoder(
			.clk(clk),
			.rst(rst),
			.display_sel(display_sel),
			.msg(2'b00),  //00 - normal mode; 01 - OP; 10 - VAL; 11 - ERR
			.bin(final_result_uncoded), //8-bit binary number to be displayed. being 255 the limit
			.wr_enable(data_we),
			.sgn(sgn), //0 - no signal; 1 - negative signal
			.dot(2'b00), //01 - 2nd display, 10 - 3rd display, 00 - none | (DOT POINT)
			.disp_select(Disp_sel[3:0]), //wich display will be selected
			.disp_value(Disp[7:0]) //value to be displayed
	);
	xALU real_alu(
		.clk(clk),
		.rst(rst),
		.alu_sel(alu_sel),
		.wr_enable(data_we),
		.first_nr(first_nr),
		.second_nr(second_nr),
		.operation(operation),
		.result_uncoded(result_uncoded),
		.alu_done(alu_finish)
	);

	complement_to_2 complement1 (
		.rst(rst),
		.clk(clk),
		.nr_coded(data_to_wr[19:0]),
		.complement1_sel(complement2_sel),
		.wr_enable(data_we),
		.first_nr(first_nr),
		.second_nr(second_nr),
		.operation(operation),
		.complement1_finish(complement2_finish)
	);
  
`ifdef DEBUG
   xcprint cprint (
		   .clk(clk),
		   .sel(cprt_sel & data_we),
		   .data_in(data_to_wr[7:0])
		   );
`endif
   
endmodule
