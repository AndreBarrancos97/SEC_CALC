# PATHS
VA := ../../../picoversat/tools/assembler/va
INCLUDE_DIR := rtl/include

all: program.hex


# assemble program
program.hex: program.va xdict.json
	$(VA) program.va program.hex

xdict.json: $(INCLUDE_DIR)/xdefs.vh
			../../../picoversat/tools/xdictgen $(INCLUDE_DIR)

#rtl files
INCLUDE_DIR := rtl/include
SRC_DIR := rtl/src

XDEFS := $(wildcard $(INCLUDE_DIR)/*.vh)
SRC := $(wildcard $(SRC_DIR)/*.v) 
TB := rtl/testbench/xtop_tb.v

#icarus verilog
VC = iverilog
CFLAGS = -W all -I$(INCLUDE_DIR) -g2005-sv -D DEBUG

all: sim
	./a.out

sim: $(SRC) $(XDEFS) $(TB)
	$(VC) $(CFLAGS) $(SRC) $(TB)



clean:
	@rm -f xdict.json *# *~ rom.v
	@rm -f *#
	@rm -f *~ 
	@rm -f *.vcd
	@rm -f *.hex
	@rm -f xtop
	@rm -f *.out

.phony: all clean
