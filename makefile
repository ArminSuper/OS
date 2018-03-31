AS_FLAGS = --32 -gstabs 
C_FLAGS = -c -Wall -m32 -ggdb -gstabs+ -nostdinc -fno-builtin -fno-stack-protector 
LD_FLAGS = -melf_i386

objects = loader.o kernel.o

%.o : %.c
	$(CC) $(C_FLAGS) -o $@ $<

%.o : %.s
	as $(AS_FLAGS) -o $@ $<

Kernel.bin: linker.ld $(objects)
	ld $(LD_FLAGS) -T $< -o $@ $(objects)

Kernel.iso : Kernel.bin
	mkdir -p iso/boot/grub
	cp Kernel.bin iso/boot/Kernel.bin
	echo 'set timeout = 0' > iso/boot/grub/grub.cfg
	echo 'set default = 0' >> iso/boot/grub/grub.cfg
	echo 'menuentry "OS Kernel" {' >> iso/boot/grub/grub.cfg
	echo 'multiboot /boot/Kernel.bin' >> iso/boot/grub/grub.cfg
	echo 'boot' >> iso/boot/grub/grub.cfg
	echo '}'    >> iso/boot/grub/grub.cfg
	grub-mkrescue -o Kernel.iso iso
	@rm -rf iso

.PHONY:clean
clean :
	@rm -rf $(objects) iso  

.PHONY:debug
debug:
	qemu-img create floppy.img 2G
	qemu-system-i386 -S -s -fda floppy.img -cdrom Kernel.iso &
	cgdb -x gdbinit
	
