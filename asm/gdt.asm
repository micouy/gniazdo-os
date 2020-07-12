[bits 16]
gdt:

gdt_null:
    dq 0x0

gdt_code:
    dw 0xFFFF ; length
    dw 0x0 ; base 0-15
    db 0x0 ; base 16-23
    ; 7 - present flag
    ; 5-6 - required privelige
    ; 4 - is either code or data?
    ; 3 - code or data?
    ; 2 - is lower privelige allowed to read/exec?
    ; 1 - read or write?
    ; 0 - access flag
    db 0b1001_1010

    ; 7 - granularity (multiplies segment limit by 4kB)
    ; 6 - 16 bit or 32 bit?
    ; 5 - required by intel to be set to 0
    ; 4 - free to use
    ; 0-3 - last bits of segment limit
    db 0b1100_1111

    db 0x0 ; base 24-31
    
gdt_data:
    dw 0xFFFF ; size
    dw 0x0 ; base 0-15
    db 0x0 ; base 16-23
    ; 7 - present flag
    ; 5-6 - required privelige
    ; 4 - is either code or data?
    ; 3 - code or data?
    ; 2 - is lower privelige allowed to read/exec?
    ; 1 - read or write?
    ; 0 - access flag
    db 0b1001_0010

    ; 7 - granularity (multiplies segment limit by 4kB)
    ; 6 - 16 bit or 32 bit?
    ; 5 - required by intel to be set to 0
    ; 4 - free to use
    ; 0-3 - last bits of segment limit
    db 0b1100_1111

    db 0x0 ; base 24-31
gdt_end:

gdt_desc:
    dw gdt_end - gdt - 1
    dd gdt

CODE_SEG equ gdt_code - gdt
DATA_SEG equ gdt_data - gdt
