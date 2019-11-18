`timescale 1ns / 1ps
`include "xdefs.vh"

`define RB (`REGF_BASE+2**`REGF_ADDR_W)
`define RC (`REGF_BASE+2**`REGF_ADDR_W+1)

module xctrl (
	      input                    clk,
	      input                    rst,
	      
	      // instruction memory interface
	      output reg [`ADDR_W-2:0] pc,
	      input [`INSTR_W-1:0]     instruction,
	      
	      // data memory interface 
	      output                   mem_sel,
	      output                   mem_we,
	      output reg [`ADDR_W-1:0] mem_addr,
	      input [`DATA_W-1:0]      mem_data_from,
	      output [`DATA_W-1:0]     mem_data_to
	      );
   
   // Instruction fields
   wire [`OPCODESZ-1 :0] 		  opcode;
   wire signed [`DATA_W-1:0] 		  imm;

   //operand 
   reg [`DATA_W-1:0] 			  operand;
   
   //register A (accumulator)   
   reg [`DATA_W-1:0] 			  regA;

   // register B
   reg [`DATA_W-1:0] 			  regB;

   //register C
   reg [2:0]                              regC;
 				  
   //alu
   reg [`DATA_W-1:0]                      alu_result;
   reg                                    alu_carry;
   reg                                    alu_overflow;
   reg                                    alu_negative;
   

  
   // USEFUL INSTRUCTION GROUPS
   wire                                   load_imm_ops = (opcode == `ldi || opcode == `ldih);
   wire                                   load_mem_ops = (opcode == `rdw || opcode == `rdwb);
   wire                                   load_ops = load_imm_ops | load_mem_ops;
   wire                                   store_mem_ops = (opcode == `wrw || opcode == `wrwb);
   
   wire                                   alu_imm_ops = (opcode == `addi || opcode == `shft);
   wire                                   alu_arith_ops  = (opcode == `addi || opcode == `add || opcode == `sub);
   wire                                   alu_logic_ops  = (opcode == `and || opcode == `xor);
   wire                                   alu_mem_ops  = (alu_arith_ops && opcode != `addi) || alu_logic_ops;
   
   wire                                   alu_ops  = alu_imm_ops | alu_logic_ops | alu_arith_ops ;
   
   wire                                   imm_ops = load_imm_ops | alu_imm_ops;

   wire                                   branch_ops = (opcode == `beqi || opcode == `bneqi || opcode == `beq || opcode == `bneq);
   
   


   
   // instruction unpacking

   //opcode
   assign opcode  = instruction[`INSTR_W-1 -: `OPCODESZ];
   
   //immediate
   assign imm  = (opcode == `ldih)?                 
                 {instruction[`DATA_W/2-1:0], regA[`DATA_W/2-1:0]} :
                 { { (`DATA_W-`IMM_W) {instruction[`IMM_W-1]} }, instruction[`IMM_W-1:0]};


   //
   // MEMORY MAPPED DATA BUS
   //
       
   //select bit
   assign mem_sel = (store_mem_ops | load_mem_ops | alu_mem_ops) && mem_addr != `RB && mem_addr != `RC;

   //memory
   assign mem_we = store_mem_ops;

   // write word 
   assign mem_data_to = regA;
   
   //address
   always @ * begin
      if(opcode == `rdwb || opcode == `wrwb)
        mem_addr = regB[`ADDR_W-1:0];
      else
        mem_addr = imm[`ADDR_W-1:0];
   end
   

   // operand selection 
   always @ * begin
      operand = 0;
      if(load_ops || alu_ops) begin
         if (mem_addr == (`RB))
           operand = regB;
         else if (mem_addr == (`RC))
	   operand = regC | 0;
         else if (imm_ops)
           operand = imm;
         else if (mem_sel)
           operand = mem_data_from;
      end
   end
   

   // program counter 
   always @(posedge clk, posedge rst)
      if(rst)
        pc  <= 0;
      else begin
         pc <= pc + 1'b1;
         if (opcode == `beqi && regA == 0) begin 
	    pc <= imm[`ADDR_W-1:0];
            //$display("beqi: op=%x cd=%x RA=%x", opcode, `beqi, regA);
         end else if (opcode == `bneqi && regA != 0) begin
	    pc <= imm[`ADDR_W-1:0];
            //$display("bneqi: op=%x cd=%x RA=%x", opcode, `beqi, regA);
         end else if (opcode == `beq && regA == 0) begin 
	    pc <= regB[`ADDR_W-1:0];
            //$display("beq: op=%x cd=%x RA=%x", opcode, `beqi, regA);
         end else if (opcode == `bneq && regA != 0) begin
	    pc <= regB[`ADDR_W-1:0];
            //$display("bneq: op=%x cd=%x RA=%x", opcode, `bneq, regA);
         end
      end
 


   //
   // REGISTERS
   //
   
   // register A
   always @(posedge clk, posedge rst)
      if(rst)
        regA <= 0;
      else if (load_ops)
	regA <= operand;
      else if(alu_ops)
	regA <= alu_result;
      else if(branch_ops)
        regA <= regA-1'b1;


   // register B (data memory pointer)

   always @(posedge clk, posedge rst)
     if(rst)
       regB <= 0;
     else if (mem_addr == `RB && mem_we) 
       regB <= regA;
   
   // register C (processor flags)
   always @(posedge clk, posedge rst)
      if(rst)
        regC <= 3'b0;
      else if (alu_ops)
        regC <= {alu_negative, alu_overflow, alu_carry};
      
   //
   // ALU
   //
      
   reg [`DATA_W-1:0] carry_res_n_1;
   reg               carry_res_n;
 
   reg [`DATA_W-1:0] adder_res;

   always @*
     if(opcode == `sub)
       carry_res_n_1 = {1'b0, regA[`DATA_W-2:0]} - {1'b0,operand[`DATA_W-2:0]};
     else
       carry_res_n_1 = {1'b0, regA[`DATA_W-2:0]} + {1'b0,operand[`DATA_W-2:0]};

   always @*
     if(opcode == `sub)
       carry_res_n = (regA[`DATA_W-1] & ~operand[`DATA_W-1]) +  (regA[`DATA_W-1] ^ ~operand[`DATA_W-1]) & carry_res_n_1[`DATA_W-1];
     else
       carry_res_n = (regA[`DATA_W-1] & operand[`DATA_W-1]) +  (regA[`DATA_W-1] ^ operand[`DATA_W-1]) & carry_res_n_1[`DATA_W-1];


   always @*
     if(opcode == `sub)
       adder_res = carry_res_n_1 + {regA[`DATA_W-1], {`DATA_W-1{1'b0}}} - {operand[`DATA_W-1],{`DATA_W-1{1'b0}}};
     else
       adder_res = carry_res_n_1 + {regA[`DATA_W-1], {`DATA_W-1{1'b0}}} + {operand[`DATA_W-1],{`DATA_W-1{1'b0}}};

   
   wire [`DATA_W-1:0] and_res = regA & operand;
   wire [`DATA_W-1:0] xor_res = regA ^ operand;

   //alu operation
   always @* begin
      alu_result = 0;
      alu_carry = 0;
      alu_negative = 0;
      alu_overflow = 0;
      if(alu_arith_ops) begin
         alu_result = adder_res[`DATA_W-1:0];
         alu_carry = carry_res_n;
         alu_overflow = carry_res_n ^ carry_res_n_1[`DATA_W-1];
         alu_negative = adder_res[`DATA_W-1];
      end else if(opcode == `shft)
        if(operand[`DATA_W-1]) begin //left shift by 1
           alu_result = regA << 1;
           alu_carry = regA[`DATA_W-1];
           alu_overflow = regA[`DATA_W-1] ^ regA[`DATA_W-2];
           alu_negative = regA[`DATA_W-2];
        end else begin //arithmetic right shift by 1
           alu_result = {regA[`DATA_W-1], regA[`DATA_W-1:1]};
           alu_carry = 0;
           alu_overflow = 0;
           alu_negative = regA[`DATA_W-1];
        end
      else if(opcode == `and) begin
         alu_result = and_res;
         alu_carry = 0;
         alu_negative = and_res[`DATA_W-1];
         alu_overflow = 0;
      end
      else if(opcode == `xor) begin
         alu_result = xor_res;
         alu_carry = 0;
         alu_negative = xor_res[`DATA_W-1];
         alu_overflow = 0;
      end   
   end
   
endmodule
