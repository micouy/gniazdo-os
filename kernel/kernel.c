void main() {
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
