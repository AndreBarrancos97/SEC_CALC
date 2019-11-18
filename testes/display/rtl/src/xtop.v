`timescale 1ns / 1ps
`include "xdefs.vh"


module xtop (
	     input 		  clk,
	     input 		  rst,
		  input [3:0] Btn,
	     input [7:0] Sw,
        
		  output 		  trap,
	     output [7:0]	  Led,
	     output [7:0]	  Disp,
	     output [3:0]   Disp_sel
				  `ifndef NO_EXT
				  // external parallel interface
		  ,output [`ADDR_W-2:0] par_addr,
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
   wire [`ADDR_W-2:0]             pc;

   // DATA BUS
   wire 			  data_sel;
   wire 			  data_we;
   wire [`ADDR_W-1:0] 		  data_addr;
   wire [`DATA_W-1:0] 		  data_to_rd;
   wire [`DATA_W-1:0] 		  data_to_wr;

   
   // ADDRESS DECODER
   wire                           mem_sel;
   wire [`DATA_W-1:0] 		  mem_data_to_rd;
   
   wire				  regf_sel;
   wire [`DATA_W-1:0] 		  regf_data_to_rd; 			  
   wire                           leds_sel;

   
   
`ifdef DEBUG
   reg 				  cprt_sel;
`endif

`ifndef NO_EXT
   wire                           ext_sel;
   wire [`DATA_W-1:0]             ext_data_to_rd = par_in;
 
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

`ifndef NO_EXT
                               //external
                               .ext_sel(ext_sel),
                               .ext_data_to_rd(ext_data_to_rd),
`endif

                               //trap
                               .trap_sel(trap),
                               .leds_sel(leds_sel),
                               
                               //data output 
                               .data_to_rd(data_to_rd)
                               );
   
   //
   //
   // USER MODULES INSERTED BELOW
   //
   //
	xdispDecoder displayDecoder(
			.clk(clk),
			.rst(rst),
			.bin(Sw[7:0]),
			.sgn(1'b1),
			.disp_select(Disp_sel[3:0]),
			.disp_value(Disp[7:0])
			
	);
	/*xdisplay disp(
			.reset(rst),
			.clk(clk),
			.val_sel(Sw[7:0]),
			.disp_value(Disp[7:0]),
			.disp_sel(Disp_sel[3:0])
	);
   */
    xleds leds(
	     .reset(rst),
	     .clk(clk),
	     .led_sel(leds_sel),
	     .sw(Sw[7:0]),
	     .led(Led[7:0])
	     );
   
`ifdef DEBUG
   xcprint cprint (
		   .clk(clk),
		   .sel(cprt_sel & data_we),
		   .data_in(data_to_wr[7:0])
		   );
`endif
   
endmodule
