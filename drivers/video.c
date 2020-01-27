#include "ports.h"
#include "video.h"

int get_col_from_vga_offset(int offset) {
    int cell = offset / 2;
    int col = cell % SCREEN_WIDTH;

    return col;
}

int get_row_from_vga_offset(int offset) {
    int cell = offset / 2;
    int row = cell / SCREEN_WIDTH;

    return row;
}

int get_vga_offset(int col, int row) {
    int offset = 2 * (row * SCREEN_WIDTH + col);

    return offset;
}

void set_cursor_offset(int offset) {
    port_byte_out(SCREEN_CTRL_PORT, 14);
    port_byte_out(SCREEN_DATA_PORT, (unsigned char)(offset >> 8));
    port_byte_out(SCREEN_CTRL_PORT, 15);
    port_byte_out(SCREEN_DATA_PORT, (unsigned char)(offset & 0xff));
}

int get_vga_offset_from_cursor() {
    int offset;

    port_byte_out(SCREEN_CTRL_PORT, 14);
    offset = port_byte_in(SCREEN_DATA_PORT);
    offset = offset << 8;
    port_byte_out(SCREEN_CTRL_PORT, 15);
    offset += port_byte_in(SCREEN_DATA_PORT);

    return offset;
}

void print_error() {
    unsigned char* vga_memory = (unsigned char*) VGA_MEMORY;
    int bottom_right = 2 * SCREEN_WIDTH * SCREEN_HEIGHT;
	vga_memory[bottom_right - 2] = 'E';
	vga_memory[bottom_right - 1] = RED_ON_WHITE;
}

int print_char_and_get_offset(char c, int col, int row, char style) {
    unsigned char* vga_memory = (unsigned char*) VGA_MEMORY;
    if (!style) {
        style = WHITE_ON_BLACK;
    }

    if (col >= SCREEN_WIDTH || row >= SCREEN_HEIGHT) {
        print_error();

		return get_vga_offset_from_cursor();
    }

    int offset;
    if (col >= 0 && row >= 0) {
        offset = get_vga_offset(col, row);
    } else {
        offset = get_vga_offset_from_cursor();
    }

	if (c == '\n') {
    	row = get_row_from_vga_offset(offset);
    	row += 1;
    	col = 0;
    	offset = get_vga_offset(col, row);
	} else {
        vga_memory[offset] = c;
        vga_memory[offset + 1] = style;
        offset += 2;
	}

	set_cursor_offset(offset);

	return offset;
}

void kprint_at(char *message, int col, int row, char style) {
    int offset;

    if (col >= 0 && row >= 0) {
        offset = get_vga_offset(col, row);
    } else {
        offset = get_vga_offset_from_cursor();
        col = get_col_from_vga_offset(offset);
        row = get_row_from_vga_offset(offset);
    }

	int counter = 0;
	while (message[counter] != 0) {
		offset = print_char_and_get_offset(message[counter], col, row, style);
		col = get_col_from_vga_offset(offset);
		row = get_row_from_vga_offset(offset);
		counter++;
	}
}

void kprint(char *message, char style) {
    kprint_at(message, -1, -1, style);
}

void clear_screen() {
    unsigned char* vga_memory = (unsigned char*) VGA_MEMORY;

    int bottom_right = SCREEN_WIDTH * SCREEN_HEIGHT;
    int counter = 0;

    while (counter < bottom_right) {
        vga_memory[counter * 2] = ' ';
        vga_memory[counter * 2 + 1] = WHITE_ON_BLACK;
        counter++;
    }

    set_cursor_offset(get_vga_offset(0, 0));
}

