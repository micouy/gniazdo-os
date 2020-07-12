[bits 32]
; enter long mode
; https://wiki.osdev.org/Setting_Up_Long_Mode#The_Switch_from_Protected_Mode

; todo read:
; https://stackoverflow.com/questions/25210084/entering-long-mode
; https://wiki.osdev.org/Paging#Enabling
; https://intermezzos.github.io/book/first-edition/paging.html

enter_long:
	; clear 4 * 4096 bytes of memory starting at 0x1000
    mov edi, 0x1000
    mov cr3, edi ; physical address of the page table

    xor eax, eax
    mov ecx, 4096
    rep stosd ; move eax to (edi + 4 bytes * counter) ecx times
    ; edi is pointing to the last byte cleared so must reset
    mov edi, 0x1000

	; 0x2000 = 2 * 16^3 = 2 * 2^12 = 2 << 12
	; pages are aligned to 4096 bytes, so to get the
	; page address we just need to zero the last 12 bits
	; of the entry
    mov dword [edi], 0x2003 ; 2 << 12 | 0b11 <- flags
    add edi, 0x1000 ; 4096
    mov dword [edi], 0x3003
    add edi, 0x1000
    mov dword [edi], 0x4003
    add edi, 0x1000 ; edi = 0x4000

    mov ebx, 0b11 ; flags
    mov ecx, 512
    ; identity map first MB
    .set_entry:
    mov dword [edi], ebx
    add ebx, 0x1000
    add edi, 8
	loop .set_entry

	; enable physical address extension (4 Mb pages)
	mov eax, cr4
	or eax, 1 << 5
	mov cr4, eax

	; set long mode bit
	mov ecx, 0xc000_0080
	rdmsr
	or eax, 1 << 8
	wrmsr
	
	; set paging
	mov eax, cr0
	or eax, 0x80000001
    mov cr0, eax

	lgdt [long_gdt.pointer]

	jmp long_gdt.code_desc:init_long


; https://intermezzos.github.io/book/first-edition/setting-up-a-gdt.html
long_gdt:
    .null_desc: equ $ - long_gdt
    dq 0
    
    .code_desc: equ $ - long_gdt
    dq (1 << 53) | (1 << 47) | (1 << 44) | (1 << 43) | (1 << 41)
    ; 53 - long mode
    ; 47 - present
    ; 44 - either code or data
    ; 43 - executable
    ; 41 - is data writable/is code readable
    
    .data_desc: equ $ - long_gdt
    dq (1 << 47) | (1 << 44) | (1 << 41)
    
    .pointer:
    dw $ - long_gdt - 1
    dq long_gdt

[bits 64]
init_long:
    cli                           ; Clear the interrupt flag.
    mov ax, long_gdt.data_desc            ; Set the A-register to the data descriptor.
    mov ds, ax                    ; Set the data segment to the A-register.
    mov es, ax                    ; Set the extra segment to the A-register.
    mov fs, ax                    ; Set the F-segment to the A-register.
    mov gs, ax                    ; Set the G-segment to the A-register.
    mov ss, ax                    ; Set the stack segment to the A-register.
    jmp boot_lm
