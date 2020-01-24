unsigned char port_byte_in(unsigned short port) {
    unsigned char result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));

    return result;
}

void port_byte_out(unsigned short port, unsigned char value) {
    __asm__("out %%al, %%dx" : : "a" (value), "d" (port));
}

unsigned short port_word_in(unsigned short port) {
    unsigned short result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));

    return result;
}

void port_word_out(unsigned short port, unsigned short value) {
    __asm__("out %%ax, %%dx" : : "a" (value), "d" (port));
}
