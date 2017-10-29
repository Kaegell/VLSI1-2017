
.PHONY:	clean

all : shifter_tb clean

shifter_tb: shifter.vhdl shifter_tb.vhdl
	ghdl -a -v shift_lsl.vhdl
	ghdl -a -v shift_lsr.vhdl
	ghdl -a -v shift_asr.vhdl
	ghdl -a -v shift_ror.vhdl
	ghdl -a -v shift_rrx.vhdl
	ghdl -a -v shifter.vhdl
	ghdl -a -v shifter_tb.vhdl
	ghdl -e -v shifter_tb
	ghdl -r shifter_tb --vcd=shifter.vcd

clean :
	@echo "clean"
	@if [ -f work-obj93.cf ]; then rm work-obj93.cf; fi;
	@for obj in $(wildcard *.o); do \
		rm $$obj; \
	done;

mrproper:
	@if [ -f shifter_tb ]; then rm shifter_tb; fi;
	@if [ -f shifter.vcd ]; then rm shifter.vcd; fi;
