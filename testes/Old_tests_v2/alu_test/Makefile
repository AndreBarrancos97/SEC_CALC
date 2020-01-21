top:  full_adder.v full_adder_4bits.v xALU.v xALU_tb.v
	iverilog -o top full_adder.v full_adder_4bits.v xALU.v xALU_tb.v 
	./top

clean: 
	rm -f top *~ *.vcd

.PHONY: clean all
