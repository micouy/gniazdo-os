C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

kernel.bin : kernel/kernel_entry.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

%.bin : %.asm
	nasm $< -f bin -I "boot/" -o $@

os-image : boot/boot_sector.bin kernel.bin
	cat $^ > $@

%.o : %.c ${HEADERS}
	i386-elf-gcc -ffreestanding -c $< -o $@

%.o : %.asm
	nasm $< -f elf -o $@

run : os-image
	qemu-system-x86_64 -fda $<

clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o
