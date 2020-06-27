[bits 16]
[org 0x7C00]
stage1:
    mov ah, 0x2
    mov al, 0x1
    push ax
    mov cl, 0x2
    mov dh, 0x0
    mov ch, 0x0
    ; mov dl, 0x80

    mov bx, 0x7e0
    mov es, bx
    mov bx, 0x0
    int 0x13

	pop bx
    cmp al, bl
    jne error

    jmp 0x7e00

error:
   mov al, "e"
   mov ah, 0xe
   int 0x10
   jmp $

times 510 - ($ - $$) db 0
dw 0xaa55

stage2:
   mov al, "d"
   mov ah, 0xe
   int 0x10
   jmp $
