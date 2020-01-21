top: full_adder.v division_4bits_XOR.v division_xcomplement_to_2.v div_par.v signed_shfit_division.v div_par_tb.v
	iverilog -o top full_adder.v division_4bits_XOR.v division_xcomplement_to_2.v div_par.v signed_shfit_division.v div_par_tb.v
	./top

clean: 
	rm -f top *~ *.vcd

.PHONY: clean all
