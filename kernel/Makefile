TARGET = kernel.elf
OBJS = main.o entry.o newlib_support.o hankaku.o asmfunc.o

CFLAGS += -O2 -Wall -g --target=x86_64-elf -ffreestanding -mno-red-zone
LDFLAGS += --entry KernelMain -z norelro --image-base 0x100000 --static


.PHONY: all
all: $(TARGET)

.PHONY: clean
clean:
				rm -rf *.o
				rm *.bin
				rm *.elf

kernel.elf: $(OBJS) Makefile
				ld.lld $(LDFLAGS) -o kernel.elf $(OBJS) -lc

%.o: %.c Makefile
				clang $(CPPFLAGS) $(CFLAGS) -c $< -o $@

%.c: %.v Makefile
				v -o $@ $<

%.o: %.asm Makefile
				nasm -f elf64 -o $@ $<

hankaku.bin: hankaku.txt
				../tools/makefont.py -o $@ $<

hankaku.o: hankaku.bin
				objcopy -I binary -O elf64-x86-64 -B i386:x86-64 $< $@
