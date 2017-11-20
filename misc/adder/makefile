
adder_tb: adder.vhdl adder_tb.vhdl
	ghdl -a -v adder.vhdl
	ghdl -a -v adder_tb.vhdl
	ghdl -e -v adder_tb

clean :
	echo "clean"
	rm $(wildcard *.o) adder.vcd  work-obj93.cf
