%macro IO 4  ;  simple macro ,
mov rax,%1  
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro
section .data
     m1 db "Enter string",10
     l1 equ $-m1
     m2 db "Entered",10
     l2 equ $-m2
     m3 db "Length is",10  
     l3 equ $-m3
     m4 db "Write an X86/64 Alp to accept a string and to display its length",10
     l4 equ $-m4
     m5 db "Exiting now",10
     l5 equ $-m5
     m6 db "Umesh 17",10
     l6 equ $-m6
     m7 db 10
section .bss
     string resb 50
     strl equ $-string
     count resb 1
     _output resb 20
section .text
     global _start
     
_start:
     IO 1,1,m6,l6
     IO 1,1,m4,l4
     IO 1,1,m1,l1
  input:
     IO 0,0,string,strl
     mov [count],rax
  output:
     IO 1,1,m2,l2
     IO 1,1,string,strl
     IO 1,1,m3,l3
     mov rax,[count]
     call hex_to_dec
     IO 1,1,_output,16
     IO 1,1,m7,1
  exit:
     IO 1,1,m5,l5 
     mov rax,60
     mov rdi,0
     syscall
hex_to_dec:
        mov rsi,_output+15
        mov rcx,2
     letter2:
        xor rdx,rdx
        mov rbx,10     
        div rbx
        cmp dl,09h
        jbe add30
     add30:
        add dl,30h
        mov [rsi],dl
        dec rsi
        dec rcx
        jnz letter2
ret
