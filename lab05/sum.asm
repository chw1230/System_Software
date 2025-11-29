%include "asm_io.inc"

	segment	.data
msg_input	db	"Input n: ", 0x00
msg_result 	db 	"sum = ", 0x00

	segment .bss
result	resd 1		; 총합을 계속해서 저장할 변수

	segment	.text
	global 	main

main:
	enter	0,0		; setup stack frame
	pusha

	mov eax, msg_input	;  n 입력 받으라는 문구 출력
	call print_string

	call read_int 		; n 입력

; calc_sum(n, &result) 함수 호출	
	push dword result 	; 두 번째 인자: &result  -> [EBP+12]에 위치
	push eax                ; 첫 번째 인자: n        -> [EBP+8]에 위치
	call calc_sum 		; 함수 호출
	add esp, 8		; 인자 2개 × 4바이트 = 8, caller가 정리하기!

; 결과 출력
	mov eax, msg_result     ; 합 결과 출력문 'sum = '
	call print_string

	mov eax, [result]  	; result 값 가져오기
	call print_int     	; 출력
	call print_nl		; 개행

	popa
	mov eax, 0
	leave			; leave stack frame
	ret


calc_sum:
	enter 8, 0		; 호출한 쪽 EBP 저장 + 새 프레임 기준점 설정 + 지역 변수 2개(각 4바이트) 공간 확보
	
	; s = 0 -> 함수 안에서 증가하는 i 값을 게속 저장할 변수
	mov dword [ebp-8], 0

	; i = 1 -> 함수 안에서 증가하는 i 값
	mov dword [ebp-4], 1


sum_loop:
	mov eax, [ebp-4]	; eax = i
	cmp eax, [ebp+8]	; i를 파라미터 n과 비교
	jg  sum_done		; i > n 이면 루프 종료

	; s = s + i
	mov eax, [ebp-8]	; eax = s
	add eax, [ebp-4]	; eax = s + i
	mov [ebp-8], eax	

	inc	dword [ebp-4]	; i++

	jmp sum_loop

sum_done:
	; *pSum = s -> 합 결과를 매개변수로 주어진 주소에 넣기!
	mov eax, [ebp+12]	; eax = pSum -> 결과 주소를 eax에 저장
	mov edx, [ebp-8] 	; edx = s -> 최종 합을 edx에 저장
	mov [eax], edx		; *pSum = s -> 결과 주소에 결과 합을 넣기

	leave
	ret


