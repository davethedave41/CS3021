.686                                ; create 32 bit code
.model flat, C                      ; 32 bit memory model
 option casemap:none                ; case sensitive

.data						     ; start of a data section
public g					     ; export variable g
g DWORD 4						 ; declare global variable g initialised to 4
.code							 ; start of a code section

 public  min                     ; make sure function name is exported
       ; function entry 
    min: push ebp                ;push frame pointer
         mov ebp, esp            ; update ebp
         sub esp, 4              ; allocate space for local variables
       ; function body
         mov eax, [ebp+8]        ; eax = a
         mov [ebp-4], eax        ; v = a
         mov ecx, [ebp+12]       ; ecx = b 
         cmp ecx, [ebp-4]        ; if(b < v)
         jge min1                ; -> if(c < v)
         mov [ebp-4], ecx        ; v = b
   min1: mov ecx, [ebp+16]       ; ecx = c
         cmp ecx, [ebp-4]        ; if(c < v)
         jge min2
         mov [ebp-4], ecx        ; v = c
   min2: mov eax, [ebp-4]		 ; return v
       ; function exit 
         mov esp, ebp            ; can also use the operator leave to replace the next two lines
         pop ebp                 ; restore ebp
         ret 0                   ; return

public  p                       ; make sure function name is exported
       ; function entry
      p: push ebp                ; push frame pointer
         mov ebp, esp
       ; function body				
         push [ebp+12]           ; push j
         push [ebp+8]            ; push i 
         push g                  ; push g
         call min                ; call min(g, i ,j)  // call pushes return address and jumps to function
         add esp, 12             ; add 12 to esp to remove parameters from stack
         push [ebp+20]           ; push l
         push [ebp+16]           ; push k
         push eax                ; push min(g, i, j)
         call min                ; call min(min(g, i ,j), k, l)
         add esp, 12             ; add 12 to esp to remove parameters from stack      
       ; function exit
         mov esp, ebp            ; restore esp       // putting esp back to where it points to return address
         pop ebp                 ; restores previous ebp     // esp now points to return address 
         ret 0                   ; return from function 

 public gcd
      ; function entry
   gcd: push ebp                 ; push frame/base pointer
        mov ebp, esp             ; save previous ebp
      ; function body
	    mov eax, [ebp+12]		 ; eax = b 
        cmp eax, 0				 ; if(b == 0)
        jne gcd1                 ; -> else
        mov eax, [ebp+8]         ; eax = a
		jmp gcd2				 ;
 gcd1: 
        mov eax, [ebp+8]         ; eax = a
        mov ecx, [ebp+12]        ; ecx = b
        cdq                      ; clear edx
        idiv ecx                 ; divides a/b, quotient is stored in a and remainder is stored in edx
        mov eax, edx             ; eax = remainder
        push eax                 ; push a % b 
		push [ebp+12]		     ; push b 
        call gcd                 ; call gcd(b, a % b)
        add esp, 8               ; add 8 to esp to remove 2 parameters from the stack
      ; function exit
  gcd2: mov esp, ebp             ; restore esp
        pop ebp                  ; restore old ebp
        ret 0                    ; return from function
end


        
