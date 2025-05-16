# hw11
 The program translates a fixed buffer of binary byte values into a printable ASCII hexadecimal string, placing the result in an output buffer, and prints the entire result followed by a newline.

 To compile:
 nasm -f elf32 hw11translate2Ascii.asm -o hw11translate2Ascii.o
 ld -m elf_i386 -o hw11translate2Ascii hw11translate2Ascii.o
 ./hw11translate2Ascii
