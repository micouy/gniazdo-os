[bits 16]
; [org 0x7c00]

real_mode:
    ; if something doesn't work this might be the cause v
    xor ax, ax
    mov cx, ax
    mov ds, ax
    mov es, ax
    
    ; call load_second_stage
    jmp enter_protected

[bits 32]
protected_mode:
    call check_cpuid

    ; check for long mode instructions
    mov eax, 0x8000_0000
    cpuid
    cmp eax, 0x8000_0001
    jb no_long_mode

    ; check if long mode present
    mov eax, 0x8000_0001
    cpuid
    test edx, 1 << 29
    jz no_long_mode

    mov ax, "cl"
    call debug

    jmp enter_long

no_long_mode:
    mov ax, "nl"
    call debug
    hlt

[bits 64]
long_mode:
    mov edi, 0xB8000              ; Set the destination index to 0xB8000.
    mov rax, 0x1F201F201F201F20   ; Set the A-register to 0x1F201F201F201F20.
    mov ecx, 500                  ; Set the C-register to 500.
    rep stosq                     ; Clear the screen.

    mov byte [0xb8000], "d"
    mov byte [0xb8002], "u"
    mov byte [0xb8004], "p"
    mov byte [0xb8006], "a"
    hlt                           ; Halt the processor.

%include "real.asm"
%include "gdt.asm"
%include "protected.asm"
%include "protected_print.asm"
%include "debug.asm"
%include "cpuid.asm"
%include "long.asm"

times 510 - ($-$$) db 0
dw 0xaa55
