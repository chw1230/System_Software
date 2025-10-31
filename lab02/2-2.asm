%include "asm_io.inc"

	segment	.data
	;
	; initialized data is put in the data segment here
	;
out_string	db	'test string', 0xa, 0x00 ;.data 세그먼트에 out_string 이라는 레이블을 붙여 임의의 문자열을 하나 정의

	segment	.text
	global 	main
main:
	enter	0,0		; setup stack frame
	pusha

	;
	; code is put in the text segment. Do not modify the code before
	; or after this comment.
	;
	mov eax, out_string
	call print_string ;print_string 루틴을 사용하여 이 문자열을 출력

	popa
	mov	eax, 0	; return value
	leave			; leave stack frame
	ret
