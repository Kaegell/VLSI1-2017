AS_ARM = /usr/bin/arm-none-eabi-as
LD_ARM = /usr/bin/arm-none-eabi-ld
CFLAGS = -march=armv2a -mno-thumb-interwork -Wall -O1
LD_FLAGS = -Bstatic -fix-v4bx

all : test1 test2

test1 : test1.o
	${LD_ARM} ${LD_FLAGS} -T sections.lds -o test1 test1.o

test1.o : test1.s
	${AS_ARM} -c test1.s -o test1.o

test2 : test2.o
	${LD_ARM} ${LD_FLAGS} -T sections.lds -o test2 test2.o

test2.o : test2.s
	${AS_ARM} -c test2.s -o test2.o

clean :
	rm -f test1 test2 *.o
