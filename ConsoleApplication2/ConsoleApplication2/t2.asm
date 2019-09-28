option casemap:none             ; case sensitive

;includelib legacy_stdio_definitions.lib
;extrn printf:near

.data ; start of a data section
public g						; export variable g
g	QWORD	4					; declare global variable g initialised to 4
.code							; start of a code section

public min						; export function name

min:	 mov	rax, rcx	    ; v = a
		 cmp	rdx, rax		; if(b < v) 
		 jge	min1		    ; -> min1 if b >= v
		 mov	rax, rdx		; v = b
min1:    cmp	r8, rax			; if(c < v)
		 jge	min2			; ->min2 if c >= v
		 mov	rax, r8			; v = c
min2:    ret					; return rax

public p						; export function name

p:       sub	rsp, 32         ; allocate 32 bytes of shadow space
		 push	rdx			    ; push j
		 push	rcx				; push i
		 push	g					; push g
		 call	min				; min(g, i, j)
		 push	r9				; push l
		 push	r8				; push k
		 push	rax				; push min(g, i, j)
		 add	rsp, 32			; deallocate shadow space
		 ret					; return rax

public gcd						; export function name

gcd:	 sub	rsp, 32		    ; allocate 32 bytes of shadow space
		 cmp	rdx, 0			; if( b == 0)
		 jne	gcd1			; -> gcd1 if b != 0
 		 mov	rax, rcx		; rax = a
		 jmp	gcd2			; -> gcd2 to return 'a'
gcd1:    mov	rax, rcx		; making rax the dividend
		 mov	r9, rdx			; can't use rdx here
		 cdq					; clears rdx
	     idiv   r9				; a div b
		 push	rdx				; push a % b
		 push   r9			    ; push b
gcd2:    add	rsp, 32			; deallocate 32 bytes of shadow space
	     ret					; return rax

public q						: export function name
		
		 push rbp

q:		 sub rsp, 32			; allocate shadow space
		 cmp rdx

end