[bits 32]

; prints debug code stored in al
debug:
    mov byte [0xb8000], al
    mov byte [0xb8001], 0x20
    mov byte [0xb8002], ah
    mov byte [0xb8003], 0x20
    ret
