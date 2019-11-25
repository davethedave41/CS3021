        ; global variable g in r9

        add r0, #4, r9

public min
        ; int mint(int a, int b, int c) -optimised
min:    add r0, r26, r1         ; a = p1
        sub r27, r1, r0 {C}     ; if(b > v)
        jge min0                    
        xor r0, r0, r0          ; nop
        add r0, r27, r1         ; v = b 
min0:   sub r28, r1, r0 {C}     ; if(c > v)
        jge min1                
        xor r0, r0, r0          ; nop
        add r0, r28, r1         ; v = c
min1:   ret r25, 0              ; return in r25
        xor r0, r0, r0          ; not possible to remove any of the nops in the delay slots
public p
        ; int p(int i, int j, int k, int l) -optimised
p:      add r9, r0, r10         ; pass g
        add r26, r0, r11        ; pass i
        callr r25, min          ; min(g,i,j)
        add r27, r0, r12        ; pass j
        add r1, r0, r10         ; pass min(g,i,j)
        add r28, r0, r11        ; pass k
        callr r25, min          ; min(min(g,i,j),k,l)
        add r29, r0, r12        ; pass l
        ret r25, 0              ; return
        xor r0, r0, r0          ; nop
public gcd
        ;int gcd(int a, int b) -optimised
gcd:    sub r27, r0, r0, {C}    ; if(b == 0)
        jne gcd0                ; ->gcd0
        xor r0, r0, r0          ; nop
        jmp gcd1                ; go to return
        add r26, r0, r1         ; return a
gcd0:   add r26, r0, r10        ; passing a into mod(a,b)
        callr r25, mod          ; external function mod called
        add r27, r0, r11        ; passing b into mod(a,b)
        add r27, r0, r10        ; passing b    
        callr r25, gcd          ; gcd(b, a % b)
        add r1, r0, r11         ; passing mod(a,b) 
gcd1:   ret r25, 0              ; return 
        xor r0, r0, r0          ; nop


     