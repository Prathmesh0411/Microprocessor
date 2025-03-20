section .data
    array db 11h,59h,33h,22h,44h
    
    msg1 db 10,"ALP to find the largest number in an array",10
    msg1_len equ $-msg1
    
    msg2 db 10,"The Array contains the elements: ",10
    msg2_len equ $ -msg2
    
    msg3 db 10,10,"The largest number in an array is: ",10
    msg3_len equ $-msg3
    
section .bss
    counter resb 1
    result resb 4
    
%macro write 2
    mov rax,1
    mov rdi,1
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro

section .text
    global _start

_start: 
    write msg1, msg1_len
    write msg2, msg2_len
    
    mov byte[counter],05
    mov rsi, array
next: mov al,[rsi]
    push rsi
    call disp
    pop rsi
    inc rsi
    dec byte[counter]
    jnz next
    
    write msg3, msg3_len
    
    mov byte[counter],05
    mov rsi,array
    mov al,0
repeat: cmp al,[rsi]
    jg skip
    mov al,[rsi]
skip: inc rsi
    dec byte[counter]
    jnz repeat
    
    call disp
    
    mov rax,60
    mov rdi,1
    syscall
    
disp:
    mov bl,al
    mov rdi,result
    mov cx,02

up1:
    rol bl,04
    mov al,bl
    and al,0fh
    cmp al,09h
    jg add_37
    add al,30h
    jmp skip1
add_37: add al,37h
skip1: mov [rdi],al
    inc rdi
    dec cx
    jnz up1
    
    write result, 4
    
    ret
