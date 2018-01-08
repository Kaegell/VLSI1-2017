AS_ARM = /usr/bin/arm-linux-gnu-as
LD_ARM = /usr/bin/arm-linux-gnu-ld
CFLAGS = -march=armv2a
LD_FLAGS = -Bstatic -fix-v4bx

fic = test_b

all : $(fic)

$(fic) : % : %.o
	${LD_ARM} ${LD_FLAGS} -T sections.lds -o $@ $<

%.o : %.s
	${AS_ARM} ${CFLAGS} -c $< -o $@

clean :
	rm -f $(fic) *.o
