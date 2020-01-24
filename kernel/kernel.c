#include "../drivers/ports.h"

void XD() {
    char* vga_buffer = (char*) 0xb8000;

    for (int i = 0; i < 80 * 25; i++) {
        *(vga_buffer + i*2) = ' ';
    }

    char text[] = "XD TO DZIALA???";
    int length = sizeof(text) / sizeof(text[0]);

    for (int i = 0; i < length; i++) {
        *(vga_buffer + i*2) = text[i];
    }
}

void main() {
	XD();

	port_byte_out(0x3d4, 14); // request higher byte of cursor's position
	int position = port_byte_in(0x3d5);
	position = position << 8; // shift 8 bits to left to make room for the lower byte

	port_byte_out(0x3d4, 15); // request lower byte of cursor's position
	position += port_byte_in(0x3d5);
	int offset = 2 * position; // each cell consists of 2 bytes - letter + styling

	// breakpoint

	char* vga = 0xb8000;
	vga[offset] = 'X';
    vga[offset + 1] = 0x0f; // white text on black background
	vga[offset + 2] = 'D';
    vga[offset + 3] = 0x0f; // white text on black background
}
