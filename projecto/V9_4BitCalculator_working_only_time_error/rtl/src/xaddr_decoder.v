`include "xdefs.vh"
`timescale 1ns / 1ps

module xaddr_decoder (
	              // address and global select signal
	              input [`ADDR_W-1:0] addr,
                input               sel,
      
                //memory
	              output reg          mem_sel,
                input [31:0]        mem_data_to_rd,

	              output reg          regf_sel,
                input [31:0]        regf_data_to_rd,
                     
                output reg          btn2_sel,
                input               btn2_data_to_read,

                output reg          btn3_sel,
                input               btn3_data_to_read,

                output reg          alu_sel,
                input               alu_data_to_read,

                output reg          final_result_convert_sel,
                input               final_result_data_to_read,

                output reg          display_sel,
                input               display_data_to_read,                

                output reg          sw2_sel,     
                output reg          sw_sel,
                input [7:0]         sw_data_to_read,
                      
                output reg          led0_sel,
                output reg          complement2_sel,

`ifdef DEBUG	
	              output reg          cprt_sel,
`endif

`ifdef EXT_BASE
                output reg          ext_sel,
                input [31:0]        ext_data_to_rd,
`endif

                output reg          trap_sel,

                //read port
                output reg [31:0]   data_to_rd
                );

   
   //select module
   always @* begin
      final_result_convert_sel = 1'b0;
      btn3_sel = 1'b0;
      btn2_sel = 1'b0;
      sw_sel = 1'b0;
      sw2_sel = 1'b0;
      led0_sel = 1'b0;
      complement2_sel = 1'b0;
      alu_sel = 1'b0;
      display_sel = 1'b0;
      mem_sel = 1'b0;
      regf_sel = 1'b0;

`ifdef DEBUG
      cprt_sel = 1'b0;
`endif
`ifdef EXT_BASE
      ext_sel = 1'b0;
`endif
      trap_sel = 1'b0;

      //mask offset and compare with base
      if ( (addr & {  {`ADDR_W-`MEM_ADDR_W{1'b1}}, {`MEM_ADDR_W{1'b0}}  }) == `MEM_BASE)
        mem_sel = sel;
      else if ( (addr & {  {`ADDR_W-`REGF_ADDR_W{1'b1}}, {`REGF_ADDR_W{1'b0}}  }) == `REGF_BASE)
        regf_sel = sel;
`ifdef DEBUG
      else if ( (addr &  {  {`ADDR_W-`CPRT_ADDR_W{1'b1}}, {`CPRT_ADDR_W{1'b0}}  }) == `CPRT_BASE)
        cprt_sel = sel;
`endif
`ifdef EXT_BASE
      else if ( (addr &  {  {`ADDR_W-`EXT_ADDR_W{1'b1}}, {`EXT_ADDR_W{1'b0}}  }) == `EXT_BASE)
        ext_sel = sel;
`endif
      else if ( (addr &  {  {`ADDR_W-`LED0_ADDR_W{1'b1}}, {`LED0_ADDR_W{1'b0}}  }) == `LED0_BASE)
        led0_sel = sel;
      else if ( (addr &  {  {`ADDR_W-`SW_ADDR_W{1'b1}}, {`SW_ADDR_W{1'b0}}  }) == `SW_BASE)
        sw_sel = sel;
      else if ( (addr &  {  {`ADDR_W-`SW2_ADDR_W{1'b1}}, {`SW2_ADDR_W{1'b0}}  }) == `SW2_BASE)
        sw2_sel = sel;
      else if ( (addr &  {  {`ADDR_W-`BTN3_ADDR_W{1'b1}}, {`BTN3_ADDR_W{1'b0}}  }) == `BTN3_BASE)
        btn3_sel = sel;
      else if ( (addr &  {  {`ADDR_W-`BTN2_ADDR_W{1'b1}}, {`BTN2_ADDR_W{1'b0}}  }) == `BTN2_BASE)
        btn2_sel = sel;
      else if ( (addr &  {  {`ADDR_W-`COMPLEMENT2_ADDR_W{1'b1}}, {`COMPLEMENT2_ADDR_W{1'b0}}  }) == `COMPLEMENT2_BASE)
        complement2_sel = sel;
      else if ( (addr &  {  {`ADDR_W-`ALU_ADDR_W{1'b1}}, {`ALU_ADDR_W{1'b0}}  }) == `ALU_BASE)
        alu_sel = sel;
      else if ( (addr &  {  {`ADDR_W-`CONVERT_ADDR_W{1'b1}}, {`CONVERT_ADDR_W{1'b0}}  }) == `CONVERT_BASE)
        final_result_convert_sel = sel;  
      else if ( (addr &  {  {`ADDR_W-`DISPLAY_ADDR_W{1'b1}}, {`DISPLAY_ADDR_W{1'b0}}  }) == `DISPLAY_BASE)
        display_sel = sel;                  
      else
        trap_sel = sel;
   end

   //select data to read
   always @(*) begin
      data_to_rd = `DATA_W'd0;

      if(mem_sel)
        data_to_rd = mem_data_to_rd;
      else if(regf_sel)
        data_to_rd = regf_data_to_rd;
      else if(sw_sel)
        data_to_rd = {24'b0, sw_data_to_read[7:0]};
      else if(sw2_sel)
        data_to_rd = {24'b0, sw_data_to_read[7:0]};
      else if(btn3_sel)
        data_to_rd = {31'b0, btn3_data_to_read}; 
      else if(btn2_sel)
        data_to_rd = {31'b0, btn2_data_to_read}; 
      else if(alu_sel)begin
        data_to_rd = {31'b0, alu_data_to_read}; 
        end
      else if(final_result_convert_sel)begin
        data_to_rd = {31'b0, final_result_data_to_read}; 
        end
      else if(display_sel)
        data_to_rd = {31'b0, display_data_to_read}; 

`ifdef EXT_BASE
      else if(ext_sel)
        data_to_rd = ext_data_to_rd;
`endif
   end

endmodule
