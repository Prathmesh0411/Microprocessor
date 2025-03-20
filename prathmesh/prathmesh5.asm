section .data
      menumsg db 10,10,'########## MENU FOR CODE CONVERSION #########'
             db 10,'1: Hex to BCD'
             db 10,'2:BCD to Hex'
             db 10,'3: Exit'
             db 10,10,'Please Enter Choice'
      menumsg_len equ $-menumsg
      wrchmsg db 10,10,'Wrong choice entered......Please try again',
      wrchmsg_len equ $-wrchmsg
      
      hexinmsg db 10,10,'Please enter 4 digit hex number: '
      hexinmsg_len equ $-hexinmsg
      
      bcdopmsg db 10,10,'BCD Equivaleny:: '
      bcdopmsg_len equ $-bcdopmsg
      
      bcdinmsg db 10,10,'Please enter 5 digit BCd number: '
      bcdinmsg_len equ $-bcdinmsg
      
      hexopmsg db 10,10,'Hex Equivalent:: '
      hexopmsg_len equ $-hexopmsg
      
section .bss
      numascii resb 06
      ansbuff resb 02
      dnumbuff resb 08
      
%macro disp 2
      mov eax,04
      mov ebx,01
      mov ecx,%1
      mov edx,%2
      int 80h
%endmacro

%macro accept 2
      mov eax,3
      mov ebx,0
      mov ecx,%1
      mov edx,%2
      int 80h
%endmacro

section .text
global _start      
_start:
      
      
      disp menumsg,menumsg_len
      accept numascii,2
      
      cmp byte [numascii],'1'
      jne case2
      call hex2bcd
      jmp _start 

case2:  cmp byte [numascii],'2'
      jne case3
      call bcd2hex
      jmp _start
      
case3:  cmp byte [numascii],'3'
      je exit      
      
      disp wrchmsg,wrchmsg_len
      jmp _start
      
exit: 
      mov eax,1
      mov ebx,0
      int 80h
      
hex2bcd:
      disp hexinmsg,hexinmsg_len
      accept numascii,5
      call atoh
      mov ax,bx
      mov bx,10
          mov ecx,0
h2b1:   mov dx,0

      div bx
      push edx
      inc ecx
      cmp ax,0
      jne h2b1
      
      mov edi,ansbuff
      
h2b2:  pop edx
      add dl,30h
      mov [edi],dl
      inc edi
      loop h2b2
      
      disp bcdopmsg,bcdopmsg_len
      disp ansbuff,5
      ret
      
bcd2hex: 
      disp bcdinmsg,bcd
      
b2h1:   mov dl,0
      mul ebx
        mov dl,[esi]
      sub dl,30h
      add eax,edx
      inc esi
        DEC ECX
        JNZ b2h1
      mov ebx,eax
      call disp32
      ret
      
atoh:
      mov bx,0
      mov ecx,0
      mov esi,numascii
up1: 
      rol bx,04
      mov al,[esi]
        sub al,30h
      cmp al,09h
      jbe skip1
      sub al,07h
skip1:add bl,al
      inc esi
      loop up1
      ret
disp32:
      mov edi,dnumbuff
      mov ecx,04

disp: 
      rol bx,4
      mov dl,bl
      and dl,0fh
      cmp dl,09h
      jbe next
      add dl,07h

next:  add dl,30h
      mov [edi],dl
      inc edi
      loop disp
      
      disp hexopmsg,hexopmsg_len
      disp dnumbuff,4
      ret
