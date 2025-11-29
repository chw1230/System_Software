%include "asm_io.inc"

segment .text
global calc_sum      ; calc_sum 을 외부에서 사용 가능하게 하기

calc_sum:
    enter 8,0         ;  지역 변수 2개 (i, s)

    mov dword [ebp-8], 0   ; s = 0
    mov dword [ebp-4], 1   ; i = 1

sum_loop:
    mov eax, [ebp-4]       ; eax = i
    cmp eax, [ebp+8]       ; i와 n을 비교하기
    jg sum_done           

    mov eax, [ebp-8]       
    add eax, [ebp-4]       ; s += i
    mov [ebp-8], eax

    inc dword [ebp-4]      ; i++
    jmp sum_loop

sum_done:
    mov eax, [ebp+12]      ; pSum
    mov edx, [ebp-8]       ; s
    mov [eax], edx         ; *pSum = s

    leave
    ret

