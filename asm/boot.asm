[bits 16]

extern _start
extern SECOND_STAGE_LENGTH

global _boot

section .boot.text
_boot:
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov ax, 0x9000
    mov sp, ax
    sti

	call load_second_stage
	jmp enter_protected


[bits 32]

boot_pm:
    call check_cpuid
    jmp enter_long


[bits 64]

boot_lm:
    ; mov byte [0xb8000], "l"
    ; mov byte [0xb8002], "m"

    jmp _start

%include "load_second_stage.asm"
%include "gdt.asm"
%include "enter_protected.asm"
%include "protected_print.asm"
%include "debug.asm"
%include "cpuid.asm"
%include "enter_long.asm"

times 510 - ($-$$) db 0
dw 0xaa55
