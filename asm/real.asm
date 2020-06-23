[bits 16]
; buffer at 0x7E00
load_second_stage:
	pusha
	
    mov ah, 0x2
    mov al, 0x3 ; n of sectors to read
    mov cl, 0x2 ; sector right after bootloader
    mov ch, 0x0 ; track
    mov dh, 0x0 ; head
    ; buffer address es:bx
    mov bx, 0x0
    mov ax, 0x7e0
    mov es, ax
    int 0x13
    cmp ah, 0x0
    jne load_second_error

    popa
    ret

    load_second_error:
        mov al, "e"
        mov ah, 0xe
        int 0x10
        hlt
