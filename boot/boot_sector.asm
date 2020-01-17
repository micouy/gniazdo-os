[org 0x7c00]
KERNEL_OFFSET equ 0x1000

mov [BOOT_DRIVE], dl

mov bp, 0x9000
mov sp, bp

mov bx, REAL_MODE_MSG
call print

call load_kernel

mov bx, LOADED_KERNEL_MSG
call print

call switch_to_pm

jmp $

%include "print.asm"
%include "read_disk.asm"
%include "print_pm.asm"
%include "gdt.asm"
%include "switch_to_pm.asm"

[bits 16]
load_kernel:
    mov bx, LOADING_KERNEL_MSG
    call print

    mov bx, KERNEL_OFFSET
    mov dl, [BOOT_DRIVE]
    mov dh, 15
    call read_disk

    ret

[bits 32]
BEGIN_PM:
    ; call clear_vga
    
    mov ebx, PROTECTED_MODE_MSG
    call print_string_pm

    call KERNEL_OFFSET

    jmp $

REAL_MODE_MSG: db "Real mode.", 0
LOADING_KERNEL_MSG: db "Loading kernel.", 0
LOADED_KERNEL_MSG: db "Loaded kernel.", 0
PROTECTED_MODE_MSG: db "Protected mode.", 0
BOOT_DRIVE: db 0

times 510-($-$$) db 0
dw 0xaa55
