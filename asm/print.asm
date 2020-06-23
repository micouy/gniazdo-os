bits 16

; assumes string beggining in %si
print:
    push ax
    push si
    
    mov ah, 0x0e
    
    print_loop:
        mov al, [si]
        cmp al, 0
        je print_return
        
        int 0x10
        
        add si, 1
        jmp print_loop

    print_return:
        pop si
        pop ax
        
        ret
