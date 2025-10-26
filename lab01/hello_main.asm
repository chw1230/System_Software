section .data
    msg db 'Hello, world!', 0x0a    ; 출력할 문자열 + 줄바꿈
    len equ $ - msg                 ; 문자열 길이 계산

section .text
    global main ; _start -> _main (change)

main:
    ; write(1, msg, len)
    mov eax, 4      ; 시스템 호출 번호 (sys_write)
    mov ebx, 1      ; 파일 디스크립터 (stdout)
    mov ecx, msg    ; 출력할 문자열 주소
    mov edx, len    ; 문자열 길이
    int 0x80        ; 커널 호출

    ; exit(0)
    mov eax, 1      ; 시스템 호출 번호 (sys_exit)
    xor ebx, ebx    ; 반환 코드 0
    int 0x80
; 만약에 main을 사용한다면 ld 말고 gcc를 사용해라!
