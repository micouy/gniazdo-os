[bits 32]

check_cpuid:
    pusha

	; get flags and check if cpuid available
	pushfd
	pop eax
	
	mov ecx, eax

	xor eax, 1 << 21

	push eax
	popfd

	pushfd
	pop eax

	xor eax, ecx
	jz no_lm
	
    ; check for long mode instructions
    mov eax, 0x8000_0000
    cpuid
    cmp eax, 0x8000_0001
    jb no_lm

    ; check if long mode present
    mov eax, 0x8000_0001
    cpuid
    test edx, 1 << 29
    jz no_lm

	popa

	ret
	
	no_lm:
    	mov ax, " 1"
    	call debug
    	jmp $
