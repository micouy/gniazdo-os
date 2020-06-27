[bits 16]
[org 0x7c00]

; extern _second_stage
; extern SECOND_STAGE_LENGTH
SECOND_STAGE_LENGTH equ 1

global _boot

section .boot
_boot:
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov ax, 0x9000
    mov sp, ax
    sti
    ; ---
    cli
    mov ax, 0x7e0
    mov es, ax
    sti

    mov bx, 0x0
    mov ah, 0x2 ; int 0x13, ah = 0x2
    mov al, SECOND_STAGE_LENGTH ; n of sectors to read
    push ax
    mov ch, 0x0 ; cylinder
    mov dh, 0x0 ; head
    mov cl, 0x2 ; sector right after bootloader
    ; buffer address es:bx
    mov bx, 0x0
    int 0x13

    pop bx

    cmp al, bl
    je after_error
    ; error
    mov ah, 0xe
    mov al, "e"
    int 0x10
    jmp $
    after_error:

    ; ---
	; call 0:load_second_stage
	jmp enter_protected


[bits 32]

boot_pm:
    call check_cpuid
    jmp enter_long


[bits 64]

boot_lm:
    mov byte [0xb8000], "d"
    mov byte [0xb8002], "u"
    mov byte [0xb8004], "p"
    mov byte [0xb8006], "a"

	; jmp $
    jmp 0x7e00

; %include "load_second_stage.asm"
%include "gdt.asm"
%include "enter_protected.asm"
%include "protected_print.asm"
%include "debug.asm"
%include "cpuid.asm"
%include "enter_long.asm"

times 510 - ($-$$) db 0
dw 0xaa55


[bits 64]

_second_stage:
    mov byte [0xb8008], "x"
    mov byte [0xb800a], "d"
    jmp $
times 1024 - ($-$$) db 0
