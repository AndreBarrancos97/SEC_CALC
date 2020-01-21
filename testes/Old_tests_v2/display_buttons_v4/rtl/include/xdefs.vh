//
// picoVersat system definitions
//

// DATA WIDTH
`define DATA_W 32 // bits

// ADDRESS WIDTH
`define ADDR_W 10

// MODULE SELECT ADDR WIDTH
`define SEL_ADDR_W 3

// REGISTER FILE ADDRESS WIDTH


// DEBUG: USE PRINTER AND GENERATE VCD FILE
//`define DEBUG

//
// MEMORY MAP
//

`define MEM_BASE 0 //instruction and data memory
`define MEM_ADDR_W 9 //log2 of size

`define REGF_BASE 512 //register file
`define REGF_ADDR_W 4

`define CPRT_BASE 600 //char printer
`define CPRT_ADDR_W 0 //only one address

`define LED0_BASE 700 
`define LED0_ADDR_W 0

`define SW_BASE 704 
`define SW_ADDR_W 0

`define BTN3_BASE 710 
`define BTN3_ADDR_W 0

`define BTN2_BASE 714 
`define BTN2_ADDR_W 0

`define SW2_BASE 718
`define SW2_ADDR_W 0 


//`define EXT_BASE 33280 //external peripherals
//`define EXT_ADDR_W 0 //only one address

`define TRAP_BASE 1023

// Instruction width 
`define INSTR_W 32

// Instruction fields
`define OPCODESZ 4
`define IMM_W 28

`define DELAY_SLOTS 1

// Instruction codes

// arithmetic
`define addi 0
`define add 1
`define sub 2
//logic
`define shft 3
`define and 4
`define xor 5

// load / store
`define ldi 6
`define ldih 7
`define rdw 8
`define wrw 9
`define rdwb 10
`define wrwb 11

// branch
`define beqi 12
`define beq 13
`define bneqi 14
`define bneq 15
