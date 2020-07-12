/* ENTRY(_boot) */
/* INPUT(boot.o gniazdo-os.o) */

SECTIONS {
    .boot 0x7c00 : {
		*(.boot.text);
    }

    .text 0x7e00 : {
        *(.text*);
    }
    .data : {
        *(.data* .rodata*);
	}
	.rela : {
		*(.rela*);
		. = ALIGN(512);
    } = 0xdeadc0de

	SECOND_STAGE_LENGTH = ((. - ADDR(.text)) >> 9);
}
