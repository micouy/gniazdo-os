[bits 16]
; read DH sectors starting from second sector to [ES:BX]
read_disk:
    push dx ; store for later comparasion

    mov ah, 0x02
    mov al, dh ; how many sectors
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0
    mov cl, 0x02 ; sector 2 (right after boot sector)
    int 0x13
    jc disk_error
    
    pop dx ; restore from stack
    cmp al, dh ; compare no. of sectors read with specified amount
    jne disk_error
    
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print
    jmp $

DISK_ERROR_MSG:
    db "Disk error!", 0
