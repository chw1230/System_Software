%include "asm_io.inc"

	segment	.data
	;
	; initialized data is put in the data segment here
	;
string_a	db	'Enter a number (A) : ', 0x00
string_b	db	'Enter a number (B) : ', 0x00
string_sum	db 	'A + B = ', 0x00

	segment	.text
	global 	main
main:
	enter	0,0		; setup stack frame
	pusha

	;
	; code is put in the text segment. Do not modify the code before
	; or after this comment.
	;
	mov eax, string_a
	call print_string
	call read_int ; 여기 까지 하면 숫자입력하세 하고 숫자 입력 받는 것 까지 끝
	mov ebx, eax ; ebx에 숫자 A를 넣고 있도록 하기 eax를 또 쓸 거니까! ebx = A

	mov eax, string_b
	call print_string
	call read_int ; eax = B 인 상태가 됨

	add eax, ebx 	; eax와 ebx를 더하기 더한 결과는 eax에 남게 됨! eax = A + B
	
	mov ebx, eax	; 출력의 과정에서 eax가 사용되는 것을 고려해서 eax에 더한 결과물 이 있던 것을 ebx에 옮겨주기

	mov eax, string_sum
	call print_string	; 여기까지 A + B =  이 출력됨

	mov eax, ebx	; 숫자 출력을 위해서 다시 eax로 더한 결과를 옮겨오기
	call print_int
	call print_nl

	popa
	mov	eax, 0	; return value
	leave			; leave stack frame
	ret
