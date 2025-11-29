%include "asm_io.inc"

segment .data
msg_result  db "sum = ", 0

segment .bss
result      resd 1

segment .text
global main
extern calc_sum

main:
    enter 0,0
    pusha

    ;   argc, argv 가져오기
    ;   argc = [ebp+8]
    ;   argv = [ebp+12]
    
    mov eax, [ebp+12]    ; argv 주소 가져오기
    add eax, 4           ; argv[1] -> 첫 번째 인자 문자열 주소로 접근하기 위헤서 + 4 해주기
    mov eax, [eax]       ; eax = argv[1] 문자열 실제 주소에 있는 값을 eax에 넣어주기

    ; 문자열 -> 정수 바꾸기
    push eax
    call str_to_int
    add esp, 4
    ; 이제 eax = n

    ; calc_sum(n, &result)
    push dword result
    push eax
    call calc_sum
    add esp, 8

    ; 결과 출력
    mov eax, msg_result
    call print_string

    mov eax, [result]
    call print_int
    call print_nl

    popa
    mov eax, 0
    leave
    ret


str_to_int:
    push    ebp
    mov     ebp, esp

    push    ebx                 

    mov     ecx, [ebp+8]        ; ECX = s (문자열 시작 주소)
    xor     ebx, ebx            ; EBX = 0  (누적값, 처음엔 0부터 시작)

.str_loop:
    mov     al, [ecx]           ; AL = *s  (현재 문자)
    cmp     al, 0               ; 문자열 끝('\0')인지
    je      .done               ; 맞으면 변환 종료
    cmp     al, 0x0A            ; 혹시 개행(엔터)이면?
    je      .done               ; 이 경우도 변환 종료 

    ; '0'~'9' 를 0~9로 변환
    sub     al, '0'             ; AL = AL - '0'
    cmp     al, 9
    ja      .done               ; 9보다 크면 숫자가 아니므로 종료

    ; 누적값 = 누적값 * 10 + 현재 자리 숫자
    imul    ebx, ebx, 10        ; EBX = EBX * 10
    movzx   eax, al             ; AL(8비트)을 EAX(32비트)로 확장
    add     ebx, eax            ; EBX = EBX + digit

    inc     ecx                 ; s++ (다음 문자로 이동)
    jmp     .str_loop

.done:
    mov     eax, ebx            ; 반환값 = 누적된 정수

    pop     ebx                 ; 보존했던 EBX 복원
    mov     esp, ebp
    pop     ebp
    ret
