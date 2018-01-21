
fifov2.vcd : fifov2_tb
	ghdl -r $< --vcd=$@

fifov2_tb : fifov2_tb.o fifov2.o
	ghdl -e $@

%.o : %.vhdl
	ghdl -a $<
clean :
	rm -f *.o
	rm work-obj93.cf

mrproper :
	rm -f *.vcd
	rm -f $(target)
	rm -f *_tb
