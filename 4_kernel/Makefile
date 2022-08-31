# Rename tools for Mac OS.
gcc = i686-elf-gcc
ld = i686-elf-ld

all: os-image

# Run bochs to simulate booting of our code.
run: all
	bochs -q

# This is the actual disk image that the computer loads,
# which is the combination of our compiled bootsector and kernel.
os-image: boot_sect.bin kernel.bin
	cat $^ > os-image

# This builds the binary of our kernel from two object files:
# - the kernel_entry, which jumps to main () in our kernel
# - the compiled C kernel
kernel.bin: kernel_entry.o kernel.o
	$(ld) -o kernel.bin -Ttext 0x1000 $^ --oformat binary

# Build our kernel object file.
kernel.o : kernel.c
	$(gcc) -ffreestanding -c $< -o $@

# Build our kernel entry object file.
kernel_entry.o : kernel_entry.asm
	nasm $< -f elf -o $@

# Assemble the boot sector to raw machine code.
# The -I options tells nasm where to find our useful assembly
# routines that we include in boot_sect .asm.
boot_sect.bin : boot_sect.asm $(wildcard ../lib/*.asm)
	nasm $< -f bin -I '../lib/' -o $@

clean:
	rm -fr *.bin *.dis *.o os-image *.map *.log

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

