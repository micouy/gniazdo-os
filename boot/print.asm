print:
    pusha

    mov ah, 0x0e

    print_loop:
        ; break on null byte       
        cmp byte [bx], 0x0
        je break_print_loop
        
        mov al, [bx] ; copy character at addr + counter to al
        int 0x10 ; print the character
        add bx, 0x1 ; increase counter
        jmp print_loop ; repeat

    break_print_loop:
        popa
        ret

print_newline:
    pusha
    
    mov ah, 0x0e
    
    mov al, 0x0A
    int 0x10
    mov al, 0x0D
    int 0x10
    
    popa
    ret
