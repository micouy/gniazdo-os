C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

CC = i386-elf-gcc
GDB = i386-elf-gdb
QEMU = qemu-system-i386

CFLAGS = -ggdb -m32

kernel.bin : kernel/kernel_entry.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary -m elf_i386

%.bin : %.asm
	nasm $< -f bin -I "boot/" -o $@

os-image : boot/boot_sector.bin kernel.bin
	cat $^ > $@

%.o : %.c ${HEADERS}
	i386-elf-gcc ${CFLAGS} -ffreestanding -c $< -o $@

%.o : %.asm
	nasm $< -f elf32 -o $@

kernel.elf : kernel/kernel_entry.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ -m elf_i386

run : os-image
	${QEMU} -fda $<

debug : os-image kernel.elf
	${QEMU} -s -fda os-image &
	${GDB} \
		-ex "set arch i386" \
		-ex "symbol-file kernel.elf" \
		-ex "target remote localhost:1234"

clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o
