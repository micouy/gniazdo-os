[bits 32]

check_cpuid:
    pusha
	
	pushfd
	pop eax
	
	mov ecx, eax

	xor eax, 1 << 21

	push eax
	popfd

	pushfd
	pop eax

	xor eax, ecx
	jz no_cpuid

	popa

	ret
	
	no_cpuid:
    	mov ax, " 1"
    	call debug
    	hlt
