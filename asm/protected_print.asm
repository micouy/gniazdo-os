[bits 32]
; assumes string beggining in %esi
protected_print:
    pusha
    mov edx, 0xb8000
    mov ah, 0x0f

    protected_print_loop:
        mov al, [esi]
        cmp al, 0
        je protected_print_ret

        mov [edx], ax
        add edx, 2
        add esi, 1
        
        jmp protected_print_loop

    protected_print_ret:
        popa
        ret
    
