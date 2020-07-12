LLD := /usr/local/opt/llvm/bin/ld.lld

rust/gniazdo-os.o: $(wildcard rust/src/*)
	cd rust; cargo xrustc --release -- --emit obj=gniazdo-os.o

clean:
	rm asm/*.o asm/*.bin

asm/boot.o: $(wildcard asm/*.asm)
	cd asm; nasm boot.asm -f elf64 -o boot.o

img.bin: rust/gniazdo-os.o asm/boot.o link.ld
	$(LLD) rust/gniazdo-os.o asm/boot.o -T link.ld --oformat binary -o img.bin

run: img.bin
	qemu-system-x86_64 -fda img.bin
