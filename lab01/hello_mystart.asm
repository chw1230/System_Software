section .data
    msg db 'Hello, world!', 0x0a    ; 출력할 문자열 + 줄바꿈
    len equ $ - msg                 ; 문자열 길이 계산

section .text
    global _mystart

; ELF 실행 파일의 헤더에는 Entry Point 주소가 기록되어야함 ld는 기본적으로 _start 심볼을 엔트리 포인트로 사용하지만 _start가 없으면 잘못된 주소를 넣거나 경고를 발생시키게 된다!!
_mystart:
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

; 해결 방안 : 1. _start로 바꾸기 / 2. ld과정에서 엔트리 포인트 지정하기
; 만약 프로그램을 만들 때 _start 가 엔트리 포인트가 아닌 다른 이름을 사용하고 싶으면 ld 사용할 때 -e '내가정한 엔트리 포인트' 이렇게 사용하면 된다!
