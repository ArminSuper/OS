void printf(char *str)
{
	
	volatile unsigned short* VideoMemory = (unsigned short*) 0xb8000; 

	
	for(int i = 0; str[i] != '\0'; ++i)
		VideoMemory[i] = (VideoMemory[i] & 0xff00) | str[i];
	
	

}

void kernelMain(const void* multiboot_structure, unsigned int multiboot_magic) 
{
	printf("OS kernel!");

	while(1); //LOOP
}
