[bits 16]
; buffer at 0x7E00
load_second_stage:
	pusha
    cli
    mov ax, 0x7e0
    mov es, ax
    sti

    mov bx, 0x0
    mov ah, 0x2 ; int 0x13, ah = 0x2
    mov al, SECOND_STAGE_LENGTH ; n of sectors to read
    push ax
    mov ch, 0x0 ; cylinder
    mov dh, 0x0 ; head
    mov cl, 0x2 ; sector right after bootloader
    ; buffer address es:bx
    mov bx, 0x0
    int 0x13

    pop bx

    cmp al, bl
    jne load_second_error
        
    popa
    ret

    load_second_error:
        mov ah, 0xe
        mov al, "e"
        int 0x10
        jmp $
