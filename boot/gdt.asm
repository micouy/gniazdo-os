gdt_start:

gdt_null: ; null descriptor (1st descriptor)
    ; 2 * double word = 2 * 2 * 2 null bytes
    dd 0x0
    dd 0x0

gdt_code: ; code segment descriptor (2nd descriptor), CODE_SEG points here
    dw 0xffff    ; limit 0:15 - set to max
    dw 0x0       ; base 0:15 - set to 0
    db 0x0       ; base 16:23 - set to 0
    db 10011010b ; 1st flags, type flags
    db 11001111b ; 2nd flags, limit 16:19
    db 0x0       ; base 24:31 - set to 0

gdt_data: ; data segment descriptor (3rd descriptor), DATA_SEG points here
    dw 0xffff    ; limit 0:15 - set to max
    dw 0x0       ; base 0:15 - set to 0
    db 0x0       ; base 16:23 - set to 0
    db 10010010b ; 1st flags, type flags
    db 11001111b ; 2nd flags, limit 16:19
    db 0x0       ; base 24:31 - set to 0

gdt_end: ; label to calculate the length of the segment

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; 4 bytes describing the length less one
    dd gdt_start               ; 2 bytes pointing to the start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
