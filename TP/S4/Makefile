GHDL = /home/jeanlou/Outils/ghdl/bin/ghdl
all : alu_tb

alu.o : alu.vhdl
	${GHDL} -a -v alu.vhdl

alu_tb.o : alu_tb.vhdl alu.o
	${GHDL} -a -v alu_tb.vhdl
	
alu_tb : alu.o alu_tb.o 
	${GHDL} -e -v alu_tb

shifter.o : shifter.vhdl
	${GHDL} -a -v shifter.vhdl

run : alu_tb
	./alu_tb --vcd=alu_tb.vcd

clean :
	rm *.o work-obj93.cf alu_tb alu_tb.vcd
