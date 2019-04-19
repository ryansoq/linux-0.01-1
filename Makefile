CC	=gcc
CFLAGS	=-Wall -O -std=gnu89 -fstrength-reduce  -fomit-frame-pointer -m32 \
	-fno-stack-protector -finline-functions -nostdinc -fno-builtin -g -I../include
AS	=as --32
AR	=ar 
LD	=ld -m  elf_i386 
CPP	=gcc -E -nostdinc -I../include

.c.o:
	$(CC) $(CFLAGS) \
	-c -o $*.o $<
.s.o:
	$(AS) -o $*.o $<
.c.s:
	$(CC) $(CFLAGS) \
	-S -o $*.s $<

OBJS	= memory.o page.o

all: mm.o

mm.o: $(OBJS)
	$(LD) -r -o mm.o $(OBJS)

clean:
	rm -f core *.o *.a tmp_make
	for i in *.c;do rm -f `basename $$i .c`.s;done

dep:
	sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	(for i in *.c;do $(CPP) -M $$i;done) >> tmp_make
	cp tmp_make Makefile

### Dependencies:
memory.o : memory.c ../include/signal.h ../include/sys/types.h \
  ../include/linux/config.h ../include/linux/head.h ../include/linux/kernel.h \
  ../include/asm/system.h 
