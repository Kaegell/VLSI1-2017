
.PHONY:	clean

all : alu_tb clean

alu_tb: alu.vhdl alu_tb.vhdl
	ghdl -a -v alu.vhdl
	ghdl -a -v alu_tb.vhdl
	ghdl -e -v alu_tb
	ghdl -r alu_tb --vcd=alu.vcd

clean :
	@echo "clean"
	@if [ -f work-obj93.cf ]; then rm work-obj93.cf; fi;
	@for obj in $(wildcard *.o); do \
		rm $$obj; \
	done;

mrproper:
	@if [ -f alu_tb ]; then rm alu_tb; fi;
	@if [ -f alu.vcd ]; then rm alu.vcd; fi;
