%include "asm_io.inc"

	segment	.data
	
	segment .text
	global 	main
main:
	enter	0,0		; setup stack frame
	pusha

	push    dword 3       ; 세 번째 인자
	push    dword 2       ; 두 번째 인자
    	push    dword 1       ; 첫 번째 인자

    	call    subpr         ; call ->  반환 주소 push하고 subpr 로 점프

    	add     esp, 12       ; 인자 3개(3*4)를 호출자 쪽에서 스택 정리

	popa
	mov	eax, 0	; return value
	leave			; leave stack frame
	ret

subpr:
; 기존 코드
;    	push    ebp           ; 호출한 쪽(main)의 EBP 저장
;   	mov     ebp, esp      ; 현재 ESP를 기준점(EBP)으로 사용
;   	sub     esp, 8        ; 지역 변수 2개(각 4바이트) 공간 확보
	enter 8, 0               ; enter로 대체

    	push    dword 4       ; dwords_above_ebp = 4  ( +4, +8, +12, +16 )
   	push    dword 2       ; dwords_below_ebp = 2  ( -4, -8 )
   	push    dword 1       ; dump_no = 1
    	call    sub_dump_stack
    	
; 기존 코드
;	mov     esp, ebp      ; 지역 변수 영역 제거 (ESP 를 EBP 로 되돌림)
;   	pop     ebp           ; 저장해 둔 이전 EBP 복원
	leave                 ; leave로 대체
    	ret                   ; 스택에 저장된 반환 주소로 복귀
