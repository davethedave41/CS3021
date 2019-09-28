option casemap:none             ; case sensitive

includelib legacy_stdio_definitions.lib
extrn printf:near

.data						    ; start of a data section

str	db 'a = %I64d b = %I64d c = %I64d d = %I64d e = %I64d sum = %I64d\n', 0AH, 00H		;ASCII format string

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
		 mov	[rsp + 40], r8  ; save k
		 mov	r8, rdx	        ; push j
		 mov	rdx, rcx		; push i
		 mov 	rcx, g			; push g
		 call	min				; min(g, i, j)
		 mov	r8, r9			; push l
		 mov 	rdx, [rsp + 40] ; push k
		 mov 	rcx, rax		; push min(g, i, j)
		 add	rsp, 32			; deallocate shadow space
		 ret					; return rax

public gcd						; export function name

gcd:	 sub	rsp, 32		    ; allocate 32 bytes of shadow space
		 mov    [rsp + 40], rdx ; save b 
		 cmp	rdx, 0			; if( b == 0)
		 jne	gcd1			; -> gcd1 if b != 0
 		 mov	rax, rcx		; rax = a
		 jmp	gcd2			; -> gcd2 to return 'a'
gcd1:    mov	rax, rcx		; making rax the dividend
		 mov	r9, rdx			; can't use rdx here
		 cdq					; clears rdx
	     idiv   r9				; a div b
		 mov  	rcx, [rsp + 40  ; push b (remainder stored in rdx and rdx is 2nd parameter slot)
		 call   gcd				; gcd(b, a % b)
gcd2:    add	rsp, 32			; deallocate 32 bytes of shadow space
	     ret					; return rax

public q						: export function name
		
q:		 sub rsp, 32			; allocate shadow space
		 mov rax, rcx			; sum = a
		 add rax, [rsp + 32]	; sum + e
		 add rax, r9			; sum + d
		 add rax, r8			; sum + c
		 add rax, rdx			; sum + b
		 mov [rsp+40], rax		; param 7 = sum
		 mov rcx, [rsp]
		 

		 add rsp, 32			; deallocate shadow space
		 ret					; return rax

end