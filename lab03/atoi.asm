%include "asm_io.inc"

        segment .data
prompt          db    "십진수를 입력하세요: ", 0
result_msg      db    "변환된 정수: ", 0

        segment .text
        global  main
main:
        enter   0,0             ; setup stack frame
        pusha

        mov eax, prompt
        call print_string

        mov edx, 0              ; 지금까지 계산된 수를 의미! 처음에 0으로 시작

read_loop:
        call read_char

        cmp al, 0x0A            ; 엔터 확인
        je done                 ; 변환 완료

        sub al, '0'             ; al = al - 0x30  -> 문자를 숫자로 바꾸는 과정 아스키 코드 값 사용!

        imul ebx, 10            ; 계산된 값에 10을 곱해주기

        movzx eax, al           ; al을 eax로 확장(확장하는 과정에서 0으로 채우기!!! 입력되는 수는 0~9 사이의 값이기 때문에!) (8비트 → 32비트)
        add ebx, eax            ; 10 곱해진 값에 문자를 입력받고 숫자로 바꾸고, 비트 확장한 수를 더하기 (매번 일의 자리로 들어가는 것임!)
        jmp read_loop           ; 엔터입력 될때까지 계속 루프 돌기!

done:
        mov eax, result_msg
        call print_string

        mov eax, ebx            ; eax = 계산된 수
        call print_int
        call print_nl
        
        popa
        mov     eax, 0  ; return value
        leave                   ; leave stack frame
        ret
