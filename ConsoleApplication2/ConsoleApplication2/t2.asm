option casemap:none             ; case sensitive

includelib legacy_stdio_definitions.lib
extrn printf:near
.data ; start of a data section
public g ; export variable g
g	QWORD	4 ; declare global variable g initialised to 4
.code ; start of a code section
public min						; export function name

min:	 mov rax, rcx
		 cmp rdx, rax
		 jge min1
		 mov rax, rdx
min1:    cmp r9, rax
		 jge min2
		 mov rax, r9
min2:    ret

public p

p:       push 