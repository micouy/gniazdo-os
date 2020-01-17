[bits 16]

switch_to_pm:
    cli
    lgdt [gdt_descriptor]

    ; set the flag to switch to pm
    mov eax, cr0
    or eax, 0x1 ; set least bit flag to 1
    mov cr0, eax

    jmp CODE_SEG:begin_pm

[bits 32]

begin_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    jmp BEGIN_PM
