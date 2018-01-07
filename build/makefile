
#Entity fifo_32b
../src/common/fifo_32b/fifo_32b.o: ../src/common/fifo_32b/fifo_32b.vhdl
	ghdl -a -v ../src/common/fifo_32b/fifo_32b.vhdl

../src/common/fifo_32b/fifo_32b_tb : ../src/common/fifo_32b/fifo_32b.o ../src/common/fifo_32b/fifo_32b_tb.vhdl
	ghdl -a -v ../src/common/fifo_32b/fifo_32b_tb.vhdl
	ghdl -e -v fifo_32b_tb
	mv fifo_32b_tb ../bin/


#Entity ram
../src/common/ram/ram.o: ../src/common/ram/ram.vhdl
	ghdl -a -v ../src/common/ram/ram.vhdl

../src/common/ram/ram_tb : ../src/common/ram/ram.o ../src/common/ram/ram_tb.vhdl
	ghdl -a -v ../src/common/ram/ram_tb.vhdl
	ghdl -e -v ram_tb
	mv ram_tb ../bin/


#Entity fifo_handler
../src/common/fifo_handler/fifo_handler.o: ../src/common/fifo_handler/fifo_handler.vhdl
	ghdl -a -v ../src/common/fifo_handler/fifo_handler.vhdl

../src/common/fifo_handler/fifo_handler_tb : ../src/common/fifo_handler/fifo_handler.o ../src/common/fifo_handler/fifo_handler_tb.vhdl
	ghdl -a -v ../src/common/fifo_handler/fifo_handler_tb.vhdl
	ghdl -e -v fifo_handler_tb
	mv fifo_handler_tb ../bin/


#Entity fifo_127b
../src/common/fifo_127b/fifo_127b.o: ../src/common/fifo_127b/fifo_127b.vhdl
	ghdl -a -v ../src/common/fifo_127b/fifo_127b.vhdl

../src/common/fifo_127b/fifo_127b_tb : ../src/common/fifo_127b/fifo_127b.o ../src/common/fifo_127b/fifo_127b_tb.vhdl
	ghdl -a -v ../src/common/fifo_127b/fifo_127b_tb.vhdl
	ghdl -e -v fifo_127b_tb
	mv fifo_127b_tb ../bin/


#Entity fifov2
../src/common/fifov2/fifov2.o: ../src/common/fifov2/fifov2.vhdl
	ghdl -a -v ../src/common/fifov2/fifov2.vhdl

../src/common/fifov2/fifov2_tb : ../src/common/fifov2/fifov2.o ../src/common/fifov2/fifov2_tb.vhdl
	ghdl -a -v ../src/common/fifov2/fifov2_tb.vhdl
	ghdl -e -v fifov2_tb
	mv fifov2_tb ../bin/


#Entity fifo
../src/common/fifo/fifo.o: ../src/common/fifo/fifo.vhdl
	ghdl -a -v ../src/common/fifo/fifo.vhdl

../src/common/fifo/fifo_tb : ../src/common/fifo/fifo.o ../src/common/fifo/fifo_tb.vhdl
	ghdl -a -v ../src/common/fifo/fifo_tb.vhdl
	ghdl -e -v fifo_tb
	mv fifo_tb ../bin/


#Entity fifo_72b
../src/common/fifo_72b/fifo_72b.o: ../src/common/fifo_72b/fifo_72b.vhdl
	ghdl -a -v ../src/common/fifo_72b/fifo_72b.vhdl

../src/common/fifo_72b/fifo_72b_tb : ../src/common/fifo_72b/fifo_72b.o ../src/common/fifo_72b/fifo_72b_tb.vhdl
	ghdl -a -v ../src/common/fifo_72b/fifo_72b_tb.vhdl
	ghdl -e -v fifo_72b_tb
	mv fifo_72b_tb ../bin/


#Entity ram
../src/main_tb/dcache/ram/ram.o: ../src/main_tb/dcache/ram/ram.vhdl
	#ghdl -a -v ../src/main_tb/dcache/ram/ram.vhdl

../src/main_tb/dcache/ram/ram_tb : ../src/main_tb/dcache/ram/ram.o ../src/main_tb/dcache/ram/ram_tb.vhdl
	ghdl -a -v ../src/main_tb/dcache/ram/ram_tb.vhdl
	ghdl -e -v ram_tb
	mv ram_tb ../bin/


#Entity dcache
../src/main_tb/dcache/dcache.o: ../src/main_tb/dcache/ram/ram.o\
../src/main_tb/dcache/dcache.vhdl
	ghdl -a -v ../src/main_tb/dcache/dcache.vhdl

../src/main_tb/dcache/dcache_tb : ../src/main_tb/dcache/dcache.o ../src/main_tb/dcache/dcache_tb.vhdl
	ghdl -a -v ../src/main_tb/dcache/dcache_tb.vhdl
	ghdl -e -v dcache_tb
	mv dcache_tb ../bin/


#Entity ram
../src/main_tb/icache/ram/ram.o: ../src/main_tb/icache/ram/ram.vhdl
	#ghdl -a -v ../src/main_tb/icache/ram/ram.vhdl

../src/main_tb/icache/ram/ram_tb : ../src/main_tb/icache/ram/ram.o ../src/main_tb/icache/ram/ram_tb.vhdl
	ghdl -a -v ../src/main_tb/icache/ram/ram_tb.vhdl
	ghdl -e -v ram_tb
	mv ram_tb ../bin/


#Entity icache
../src/main_tb/icache/icache.o: ../src/main_tb/icache/ram/ram.o\
../src/main_tb/icache/icache.vhdl
	ghdl -a -v ../src/main_tb/icache/icache.vhdl

../src/main_tb/icache/icache_tb : ../src/main_tb/icache/icache.o ../src/main_tb/icache/icache_tb.vhdl
	ghdl -a -v ../src/main_tb/icache/icache_tb.vhdl
	ghdl -e -v icache_tb
	mv icache_tb ../bin/


#Entity arm_core
../src/main_tb/arm_core/arm_core.o: ../src/main_tb/arm_core/dec/dec.o\
../src/main_tb/arm_core/exe/exe.o\
../src/main_tb/arm_core/ifc/ifc.o\
../src/main_tb/arm_core/mem/mem.o\
../src/main_tb/arm_core/arm_core.vhdl
	ghdl -a -v ../src/main_tb/arm_core/arm_core.vhdl

../src/main_tb/arm_core/arm_core_tb : ../src/main_tb/arm_core/arm_core.o ../src/main_tb/arm_core/arm_core_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/arm_core_tb.vhdl
	ghdl -e -v arm_core_tb
	mv arm_core_tb ../bin/


#Entity fifo_32b
../src/main_tb/arm_core/dec/fifo_32b/fifo_32b.o: ../src/main_tb/arm_core/dec/fifo_32b/fifo_32b.vhdl
	ghdl -a -v ../src/main_tb/arm_core/dec/fifo_32b/fifo_32b.vhdl

../src/main_tb/arm_core/dec/fifo_32b/fifo_32b_tb : ../src/main_tb/arm_core/dec/fifo_32b/fifo_32b.o ../src/main_tb/arm_core/dec/fifo_32b/fifo_32b_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/dec/fifo_32b/fifo_32b_tb.vhdl
	ghdl -e -v fifo_32b_tb
	mv fifo_32b_tb ../bin/


#Entity reg
../src/main_tb/arm_core/dec/reg/reg.o: ../src/main_tb/arm_core/dec/reg/reg.vhdl
	ghdl -a -v ../src/main_tb/arm_core/dec/reg/reg.vhdl

../src/main_tb/arm_core/dec/reg/reg_tb : ../src/main_tb/arm_core/dec/reg/reg.o ../src/main_tb/arm_core/dec/reg/reg_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/dec/reg/reg_tb.vhdl
	ghdl -e -v reg_tb
	mv reg_tb ../bin/


#Entity dec
../src/main_tb/arm_core/dec/dec.o: ../src/main_tb/arm_core/dec/fifo_127b/fifo_127b.o\
../src/main_tb/arm_core/dec/fifo_32b/fifo_32b.o\
../src/main_tb/arm_core/dec/reg/reg.o\
../src/main_tb/arm_core/dec/dec.vhdl
	ghdl -a -v ../src/main_tb/arm_core/dec/dec.vhdl

../src/main_tb/arm_core/dec/dec_tb : ../src/main_tb/arm_core/dec/dec.o ../src/main_tb/arm_core/dec/dec_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/dec/dec_tb.vhdl
	ghdl -e -v dec_tb
	mv dec_tb ../bin/


#Entity fifo_127b
../src/main_tb/arm_core/dec/fifo_127b/fifo_127b.o: ../src/main_tb/arm_core/dec/fifo_127b/fifo_127b.vhdl
	ghdl -a -v ../src/main_tb/arm_core/dec/fifo_127b/fifo_127b.vhdl

../src/main_tb/arm_core/dec/fifo_127b/fifo_127b_tb : ../src/main_tb/arm_core/dec/fifo_127b/fifo_127b.o ../src/main_tb/arm_core/dec/fifo_127b/fifo_127b_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/dec/fifo_127b/fifo_127b_tb.vhdl
	ghdl -e -v fifo_127b_tb
	mv fifo_127b_tb ../bin/


#Entity exe
../src/main_tb/arm_core/exe/exe.o: ../src/main_tb/arm_core/exe/alu/alu.o\
../src/main_tb/arm_core/exe/fifo_handler/fifo_handler.o\
../src/main_tb/arm_core/exe/fifov2/fifov2.o\
../src/main_tb/arm_core/exe/shifter/shifter.o\
../src/main_tb/arm_core/exe/exe.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/exe.vhdl

../src/main_tb/arm_core/exe/exe_tb : ../src/main_tb/arm_core/exe/exe.o ../src/main_tb/arm_core/exe/exe_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/exe_tb.vhdl
	ghdl -e -v exe_tb
	mv exe_tb ../bin/


#Entity fifo_handler
../src/main_tb/arm_core/exe/fifo_handler/fifo_handler.o: ../src/main_tb/arm_core/exe/fifo_handler/fifo_handler.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/fifo_handler/fifo_handler.vhdl

../src/main_tb/arm_core/exe/fifo_handler/fifo_handler_tb : ../src/main_tb/arm_core/exe/fifo_handler/fifo_handler.o ../src/main_tb/arm_core/exe/fifo_handler/fifo_handler_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/fifo_handler/fifo_handler_tb.vhdl
	ghdl -e -v fifo_handler_tb
	mv fifo_handler_tb ../bin/


#Entity fifov2
../src/main_tb/arm_core/exe/fifov2/fifov2.o: ../src/main_tb/arm_core/exe/fifov2/fifov2.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/fifov2/fifov2.vhdl

../src/main_tb/arm_core/exe/fifov2/fifov2_tb : ../src/main_tb/arm_core/exe/fifov2/fifov2.o ../src/main_tb/arm_core/exe/fifov2/fifov2_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/fifov2/fifov2_tb.vhdl
	ghdl -e -v fifov2_tb
	mv fifov2_tb ../bin/


#Entity shift_lsr
../src/main_tb/arm_core/exe/shifter/shift_lsr/shift_lsr.o: ../src/main_tb/arm_core/exe/shifter/shift_lsr/shift_lsr.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shift_lsr/shift_lsr.vhdl

../src/main_tb/arm_core/exe/shifter/shift_lsr/shift_lsr_tb : ../src/main_tb/arm_core/exe/shifter/shift_lsr/shift_lsr.o ../src/main_tb/arm_core/exe/shifter/shift_lsr/shift_lsr_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shift_lsr/shift_lsr_tb.vhdl
	ghdl -e -v shift_lsr_tb
	mv shift_lsr_tb ../bin/


#Entity shift_lsl
../src/main_tb/arm_core/exe/shifter/shift_lsl/shift_lsl.o: ../src/main_tb/arm_core/exe/shifter/shift_lsl/shift_lsl.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shift_lsl/shift_lsl.vhdl

../src/main_tb/arm_core/exe/shifter/shift_lsl/shift_lsl_tb : ../src/main_tb/arm_core/exe/shifter/shift_lsl/shift_lsl.o ../src/main_tb/arm_core/exe/shifter/shift_lsl/shift_lsl_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shift_lsl/shift_lsl_tb.vhdl
	ghdl -e -v shift_lsl_tb
	mv shift_lsl_tb ../bin/


#Entity shift_ror
../src/main_tb/arm_core/exe/shifter/shift_ror/shift_ror.o: ../src/main_tb/arm_core/exe/shifter/shift_ror/shift_ror.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shift_ror/shift_ror.vhdl

../src/main_tb/arm_core/exe/shifter/shift_ror/shift_ror_tb : ../src/main_tb/arm_core/exe/shifter/shift_ror/shift_ror.o ../src/main_tb/arm_core/exe/shifter/shift_ror/shift_ror_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shift_ror/shift_ror_tb.vhdl
	ghdl -e -v shift_ror_tb
	mv shift_ror_tb ../bin/


#Entity shifter
../src/main_tb/arm_core/exe/shifter/shifter.o: ../src/main_tb/arm_core/exe/shifter/shift_asr/shift_asr.o\
../src/main_tb/arm_core/exe/shifter/shift_lsl/shift_lsl.o\
../src/main_tb/arm_core/exe/shifter/shift_lsr/shift_lsr.o\
../src/main_tb/arm_core/exe/shifter/shift_ror/shift_ror.o\
../src/main_tb/arm_core/exe/shifter/shift_rrx/shift_rrx.o\
../src/main_tb/arm_core/exe/shifter/shifter.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shifter.vhdl

../src/main_tb/arm_core/exe/shifter/shifter_tb : ../src/main_tb/arm_core/exe/shifter/shifter.o ../src/main_tb/arm_core/exe/shifter/shifter_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shifter_tb.vhdl
	ghdl -e -v shifter_tb
	mv shifter_tb ../bin/


#Entity shift_asr
../src/main_tb/arm_core/exe/shifter/shift_asr/shift_asr.o: ../src/main_tb/arm_core/exe/shifter/shift_asr/shift_asr.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shift_asr/shift_asr.vhdl

../src/main_tb/arm_core/exe/shifter/shift_asr/shift_asr_tb : ../src/main_tb/arm_core/exe/shifter/shift_asr/shift_asr.o ../src/main_tb/arm_core/exe/shifter/shift_asr/shift_asr_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shift_asr/shift_asr_tb.vhdl
	ghdl -e -v shift_asr_tb
	mv shift_asr_tb ../bin/


#Entity shift_rrx
../src/main_tb/arm_core/exe/shifter/shift_rrx/shift_rrx.o: ../src/main_tb/arm_core/exe/shifter/shift_rrx/shift_rrx.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shift_rrx/shift_rrx.vhdl

../src/main_tb/arm_core/exe/shifter/shift_rrx/shift_rrx_tb : ../src/main_tb/arm_core/exe/shifter/shift_rrx/shift_rrx.o ../src/main_tb/arm_core/exe/shifter/shift_rrx/shift_rrx_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/shifter/shift_rrx/shift_rrx_tb.vhdl
	ghdl -e -v shift_rrx_tb
	mv shift_rrx_tb ../bin/


#Entity alu
../src/main_tb/arm_core/exe/alu/alu.o: ../src/main_tb/arm_core/exe/alu/alu.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/alu/alu.vhdl

../src/main_tb/arm_core/exe/alu/alu_tb : ../src/main_tb/arm_core/exe/alu/alu.o ../src/main_tb/arm_core/exe/alu/alu_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/exe/alu/alu_tb.vhdl
	ghdl -e -v alu_tb
	mv alu_tb ../bin/


#Entity fifo_32b
../src/main_tb/arm_core/ifc/fifo_32b/fifo_32b.o: ../src/main_tb/arm_core/ifc/fifo_32b/fifo_32b.vhdl
	ghdl -a -v ../src/main_tb/arm_core/ifc/fifo_32b/fifo_32b.vhdl

../src/main_tb/arm_core/ifc/fifo_32b/fifo_32b_tb : ../src/main_tb/arm_core/ifc/fifo_32b/fifo_32b.o ../src/main_tb/arm_core/ifc/fifo_32b/fifo_32b_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/ifc/fifo_32b/fifo_32b_tb.vhdl
	ghdl -e -v fifo_32b_tb
	mv fifo_32b_tb ../bin/


#Entity ifc
../src/main_tb/arm_core/ifc/ifc.o: ../src/main_tb/arm_core/ifc/fifo_32b/fifo_32b.o\
../src/main_tb/arm_core/ifc/ifc.vhdl
	ghdl -a -v ../src/main_tb/arm_core/ifc/ifc.vhdl

../src/main_tb/arm_core/ifc/ifc_tb : ../src/main_tb/arm_core/ifc/ifc.o ../src/main_tb/arm_core/ifc/ifc_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/ifc/ifc_tb.vhdl
	ghdl -e -v ifc_tb
	mv ifc_tb ../bin/


#Entity mem
../src/main_tb/arm_core/mem/mem.o: ../src/main_tb/arm_core/mem/mem.vhdl
	ghdl -a -v ../src/main_tb/arm_core/mem/mem.vhdl

../src/main_tb/arm_core/mem/mem_tb : ../src/main_tb/arm_core/mem/mem.o ../src/main_tb/arm_core/mem/mem_tb.vhdl
	ghdl -a -v ../src/main_tb/arm_core/mem/mem_tb.vhdl
	ghdl -e -v mem_tb
	mv mem_tb ../bin/


main_tb.o : ../src/main_tb/main_tb.vhdl\
         ../src/main_tb/arm_core/arm_core.o\
         ../src/main_tb/icache/icache.o\
         ../src/main_tb/dcache/dcache.o
	ghdl -a -v ../src/main_tb/main_tb.vhdl

main_tb : main_tb.o ../lib/arm_ghdl.o
	ghdl -e -v -Wl,../lib/mem.o -Wl,../lib/arm_ghdl.o -Wl,../lib/ElfObj.o main_tb

clean:
	rm *.o
	rm *.cf

mrproper:
	rm -r ../bin//*

