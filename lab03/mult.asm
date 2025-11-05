%include "asm_io.inc"

        segment .data
string_a    db    'Enter a number (A) : ', 0x00
string_b    db    'Enter a number (B) : ', 0x00
string_prod    db    'A X B = ', 0x00

        segment .text
        global  main
main:
        enter   0,0             ; setup stack frame
        pusha

        mov eax, string_a
        call print_string
        call read_int
        mov edx, eax            ; edx = A

        mov eax, string_b
        call print_string
        call read_int
        mov ecx, eax            ; ecx = B

        ; 덧셈을 반복해서 곱셈을 표현하기!
        mov ebx, 0              ; ebx에 snm 값을 넣기!!
rpt:
        add ebx, edx            ; ebx(sum) += edx(A) 하는 것!
        loop rpt                ; loop 명령은 ecx에 들어간 횟수만큼 반복을 함!!!

        mov eax, string_prod
        call print_string

        mov eax, ebx             ; eax = snm
        call print_int
        call print_nl
        
        popa
        mov     eax, 0  ; return value
        leave                   ; leave stack frame
        ret
         
