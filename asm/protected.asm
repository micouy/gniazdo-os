[bits 16]
enter_protected:
    cli
    lgdt [gdt_desc]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    mov ax, CODE_SEG
    jmp CODE_SEG:init_protected

[bits 32]
init_protected:
    ; make sure segment register have right values
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; update the stack right at the top of the free space
    mov ebp, 0x90000
    mov esp, ebp
    
    jmp protected_mode
    
