[bits 64]

global _second_stage
global SECOND_STAGE_LENGTH

SECOND_STAGE_LENGTH equ ((second_stage_end - _second_stage) >> 9)

section .second_stage
_second_stage:

    mov byte [0xb8008], "x"
    mov byte [0xb800a], "d"
    mov byte [0xb800c], SECOND_STAGE_LENGTH
    jmp $

align 512, db 0x00
second_stage_end:
