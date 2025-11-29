%include "asm_io.inc"

segment .data
msg_input   db  "Input n: ", 0
msg_result  db  "sum = ", 0

segment .bss
result      resd 1

segment .text
global main          ; main 함수 외부 공개
extern calc_sum      ; calc_sum 을 링커에게 외부 함수로 알림

main:
    enter 0,0
    pusha

    mov eax, msg_input
    call print_string

    call read_int     ; eax = n

    push dword result
    push eax
    call calc_sum     ; sub.asm 에 정의
    add esp, 8

    mov eax, msg_result
    call print_string

    mov eax, [result]
    call print_int
    call print_nl

    popa
    mov eax, 0
    leave
    ret

