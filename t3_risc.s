        ; global variable g in r9
        add r0, #4, r9
        ; int mint(int a, int b, int c)
        add r0, r26, r1         ; a = p1
        sub r27, r1, r0 {C}
        jge min0
        xor r0, r0, r0          ; nop
        add r0, r27, r1
min0:   sub r28, r1, r0 {C}
        jge min1
        xor r0, r0, r0          ; nop
        add r0, r28, r1
min1:   ret r25, 0              ; return in r25
        xor r0, r0, r0          ; not possible to remove any of the nops in the delay slots

        ; int p(int i, int j, int k, int l)
        add r9, r0, r10
        add r26, r0, r11
        add r27, r0, r12
        callr r25, min
        xor r0, r0, r0          ; nop
        add r25, r0, r10
        add r28, r0, r11
        add r29, r0, r12
        callr r25, min
        xor r0, r0, r0          ; nop
        ret r25, 0
        xor r0, r0, r0

        ;int gcd(int a, int b)
        sub r27, r0, r0, {C}    ; if(b == 0)
        jne gcd0                ; ->gcd0
        xor r0, r0, r0          ; nop
        add r26, r0, r1         ; return a
        jmp gcd1                ; go to return
        xor r0, r0, r0          ; nop
gcd0:   add r26, r0, r11        ; passing a into mod(a,b)
        add r27, r0, r12        ; passing b into mod(a,b)
        callr r25, mod          ; external function mod called
        xor r0, r0, r0,         ; nop
        add r27, r0, r11        ; passing b
        add r1, r0, r12         ; passing mod(a,b)     
        callr r25, gcd          ; gcd(b, a % b)
        xor r0, r0, r0          ;
gcd1:   ret r25, 0              ;
        xor r0, r0, r0          ; nop


     