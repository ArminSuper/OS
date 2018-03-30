OUTPUT_FORMAT(elf32-i386)
OUTPUT_ARCH(i386:i386)

SECTIONS
{
    . = 0x100000;
    .text :
    {
        *(.multiboot)
        *(.text*)
    }
    .rodata :
    {
	*(.rodata)
    }
    .data :
    {
        *(.data)
    }

    .bss :
    {
	*(COMMON)
        *(.bss) 
    }

    /DISCARD/ : { *(.fini_array*) *(.comment) }
}
