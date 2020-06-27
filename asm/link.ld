ENTRY(_boot)
INPUT(boot.o second_sector.o)

SECTIONS {
	.boot 0x0 :
		AT (0x7c000) {
		boot.o(.text)
    }

	.second_stage (ADDR(.boot) + SIZEOF(.boot)) :
		AT (0x7e000) {
		second_sector.o(.text)
    }
}
