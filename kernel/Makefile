TARGET = kernel.elf
OBJS = main.o entry.o newlib_support.o

CFLAGS += -O2 -Wall -g --target=x86_64-elf -ffreestanding -mno-red-zone
LDFLAGS += --entry KernelMain -z norelro --image-base 0x100000 --static


.PHONY: all
all: $(TARGET)

.PHONY: clean
clean:
				rm -rf *.o

kernel.elf: $(OBJS) Makefile
				ld.lld $(LDFLAGS) -o kernel.elf $(OBJS) -lc

%.o: %.c Makefile
				clang $(CPPFLAGS) $(CFLAGS) -c $< -o $@

%.c: %.v Makefile
				v -o $@ $<
