%include "asm_io.inc"
;입력된 숫자를 출력해주는 코드
	segment	.data
	;
	; initialized data is put in the data segment here
	;
out_string	db 'Enter a number!!!!: ', 0x00 ;안내 코멘트

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
	call print_string

	call read_int
	call print_int ; 줄바꿈 없음!
	call print_nl

	popa
	mov	eax, 0	; return value
	leave			; leave stack frame
	ret
