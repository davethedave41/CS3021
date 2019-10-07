option casemap:none			    ; case sensitive

includelib legacy_stdio_definitions.lib
extrn printf:near
.data	   					    ; start of a data section

qnsx db	   'qns', 0AH, 00H	;ASCII format string 
wah	 db	   'a = %I64d b = %I64d c = %I64d d = %I64d e = %I64d sum = %I64d', 0AH, 00H		; ASCII format string

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
		 mov	[rsp + 40], r8   ; save k
		 mov	r8, rdx	        ; push j
		 mov	rdx, rcx		; push i
		 mov 	rcx, g			; push g
		 call	min				; min(g, i, j)
		 mov	r8, r9			; push l
		 mov 	rdx, [rsp + 40] ; push k
		 mov 	rcx, rax		; push min(g, i, j)
		 call   min				; min(min(g,i,j),k,l)
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
		 mov  	rcx, [rsp + 40]  ; push b (remainder stored in rdx and rdx is 2nd parameter slot)
		 call   gcd				; gcd(b, a % b)
gcd2:    add	rsp, 32			; deallocate 32 bytes of shadow space
	     ret					; return rax

public q								; export function name

q:		mov		rax, [rsp+40]				; move e into a register before allocating shadow space  / sum = e
		add		rax, rcx					; sum + a
		add		rax, r9						; sum + d
		add		rax, r8						; sum + c
		add		rax, rdx					; sum + b
		sub		rsp, 56
		mov		[rsp + 48], rax				; push sum
		mov		rax, [rsp + 96]				; push e
		mov		[rsp + 40], rax			
		mov		[rsp + 32], r9				; push d
		mov		r9,  r8						; push c
		mov		r8,  rdx					; push b
		mov		rdx, rcx					; push a
		lea		rcx, wah				    ; push string
		call	printf                      ; printf(...)
	    mov     rax, [rsp+48]
		add		rsp, 56						; deallocate shadow space
		ret									; return rax

public qns

qns:	sub		rsp, 32					; allocate shadow space
		lea		rcx, qnsx				; push string
		call	printf					; printf("qns\n")
		add		rsp, 32					; deallocate shadow space
		mov		rax, 0					; return 0
		ret		0						; return
end