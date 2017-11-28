
#Entity fifo
../src/common/fifo/fifo.o: ../src/common/fifo/reg/reg.o\
../src/common/fifo/fifo.vhdl
	ghdl -a -v ../src/common/fifo/fifo.vhdl

../src/common/fifo/fifo_tb : ../src/common/fifo/fifo.o ../src/common/fifo/fifo_tb.vhdl
	ghdl -a -v ../src/common/fifo/fifo_tb.vhdl
	ghdl -e -v fifo_tb
	mv fifo_tb ../bin/


#Entity reg
../src/common/fifo/reg/reg.o: ../src/common/fifo/reg/reg.vhdl
	ghdl -a -v ../src/common/fifo/reg/reg.vhdl

../src/common/fifo/reg/reg_tb : ../src/common/fifo/reg/reg.o ../src/common/fifo/reg/reg_tb.vhdl
	ghdl -a -v ../src/common/fifo/reg/reg_tb.vhdl
	ghdl -e -v reg_tb
	mv reg_tb ../bin/


#Entity fifo_handler
../src/common/fifo_handler/fifo_handler.o: ../src/common/fifo_handler/fifo_handler.vhdl
	ghdl -a -v ../src/common/fifo_handler/fifo_handler.vhdl

../src/common/fifo_handler/fifo_handler_tb : ../src/common/fifo_handler/fifo_handler.o ../src/common/fifo_handler/fifo_handler_tb.vhdl
	ghdl -a -v ../src/common/fifo_handler/fifo_handler_tb.vhdl
	ghdl -e -v fifo_handler_tb
	mv fifo_handler_tb ../bin/


#Entity exec
../src/exe/exec.o: ../src/exe/alu/alu.o\
../src/exe/shifter/shifter.o\
../src/exe/exec.vhdl
	ghdl -a -v ../src/exe/exec.vhdl

../src/exe/exec_tb : ../src/exe/exec.o ../src/exe/exec_tb.vhdl
	ghdl -a -v ../src/exe/exec_tb.vhdl
	ghdl -e -v exec_tb
	mv exec_tb ../bin/


#Entity shift_lsl
../src/exe/shifter/shift_lsl/shift_lsl.o: ../src/exe/shifter/shift_lsl/shift_lsl.vhdl
	ghdl -a -v ../src/exe/shifter/shift_lsl/shift_lsl.vhdl

../src/exe/shifter/shift_lsl/shift_lsl_tb : ../src/exe/shifter/shift_lsl/shift_lsl.o ../src/exe/shifter/shift_lsl/shift_lsl_tb.vhdl
	ghdl -a -v ../src/exe/shifter/shift_lsl/shift_lsl_tb.vhdl
	ghdl -e -v shift_lsl_tb
	mv shift_lsl_tb ../bin/


#Entity shift_lsr
../src/exe/shifter/shift_lsr/shift_lsr.o: ../src/exe/shifter/shift_lsr/shift_lsr.vhdl
	ghdl -a -v ../src/exe/shifter/shift_lsr/shift_lsr.vhdl

../src/exe/shifter/shift_lsr/shift_lsr_tb : ../src/exe/shifter/shift_lsr/shift_lsr.o ../src/exe/shifter/shift_lsr/shift_lsr_tb.vhdl
	ghdl -a -v ../src/exe/shifter/shift_lsr/shift_lsr_tb.vhdl
	ghdl -e -v shift_lsr_tb
	mv shift_lsr_tb ../bin/


#Entity shift_ror
../src/exe/shifter/shift_ror/shift_ror.o: ../src/exe/shifter/shift_ror/shift_ror.vhdl
	ghdl -a -v ../src/exe/shifter/shift_ror/shift_ror.vhdl

../src/exe/shifter/shift_ror/shift_ror_tb : ../src/exe/shifter/shift_ror/shift_ror.o ../src/exe/shifter/shift_ror/shift_ror_tb.vhdl
	ghdl -a -v ../src/exe/shifter/shift_ror/shift_ror_tb.vhdl
	ghdl -e -v shift_ror_tb
	mv shift_ror_tb ../bin/


#Entity shifter
../src/exe/shifter/shifter.o: ../src/exe/shifter/shift_asr/shift_asr.o\
../src/exe/shifter/shift_lsl/shift_lsl.o\
../src/exe/shifter/shift_lsr/shift_lsr.o\
../src/exe/shifter/shift_ror/shift_ror.o\
../src/exe/shifter/shift_rrx/shift_rrx.o\
../src/exe/shifter/shifter.vhdl
	ghdl -a -v ../src/exe/shifter/shifter.vhdl

../src/exe/shifter/shifter_tb : ../src/exe/shifter/shifter.o ../src/exe/shifter/shifter_tb.vhdl
	ghdl -a -v ../src/exe/shifter/shifter_tb.vhdl
	ghdl -e -v shifter_tb
	mv shifter_tb ../bin/


#Entity shift_rrx
../src/exe/shifter/shift_rrx/shift_rrx.o: ../src/exe/shifter/shift_rrx/shift_rrx.vhdl
	ghdl -a -v ../src/exe/shifter/shift_rrx/shift_rrx.vhdl

../src/exe/shifter/shift_rrx/shift_rrx_tb : ../src/exe/shifter/shift_rrx/shift_rrx.o ../src/exe/shifter/shift_rrx/shift_rrx_tb.vhdl
	ghdl -a -v ../src/exe/shifter/shift_rrx/shift_rrx_tb.vhdl
	ghdl -e -v shift_rrx_tb
	mv shift_rrx_tb ../bin/


#Entity shift_asr
../src/exe/shifter/shift_asr/shift_asr.o: ../src/exe/shifter/shift_asr/shift_asr.vhdl
	ghdl -a -v ../src/exe/shifter/shift_asr/shift_asr.vhdl

../src/exe/shifter/shift_asr/shift_asr_tb : ../src/exe/shifter/shift_asr/shift_asr.o ../src/exe/shifter/shift_asr/shift_asr_tb.vhdl
	ghdl -a -v ../src/exe/shifter/shift_asr/shift_asr_tb.vhdl
	ghdl -e -v shift_asr_tb
	mv shift_asr_tb ../bin/


#Entity alu
../src/exe/alu/alu.o: ../src/exe/alu/alu.vhdl
	ghdl -a -v ../src/exe/alu/alu.vhdl

../src/exe/alu/alu_tb : ../src/exe/alu/alu.o ../src/exe/alu/alu_tb.vhdl
	ghdl -a -v ../src/exe/alu/alu_tb.vhdl
	ghdl -e -v alu_tb
	mv alu_tb ../bin/


clean:
	rm *.o
	rm *.cf

mrproper:
	rm -r ../bin//*

