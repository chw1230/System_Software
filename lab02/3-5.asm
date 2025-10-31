%include "asm_io.inc"

	segment	.data
	;
	; initialized data is put in the data segment here
	;
string_a	db	'Enter a number (A) : ', 0x00
string_b	db	'Enter a number (B) : ', 0x00
string_sum	db 	'A + B = ', 0x00
string_sub	db 	'A - B = ', 0x00
	
	segment	.text
	global 	main
main:
	enter	0,0		; setup stack frame
	pusha

	;
	; code is put in the text segment. Do not modify the code before
	; or after this comment.
	;
	
	; 1. 첫 번째 수 A 입력받기
	mov eax, string_a
	call print_string
	call read_int
	mov ebx, eax	; ebx에 A(첫번째 수)를 넣기 

	; 2. 두 번째 수 B 입력받기
	mov eax, string_b
	call print_string
	call read_int
	mov ecx, eax	; ecx에 B를 저장하기
	
	; 3. A + B 계산 및 출력
	mov eax, ebx	; ebx = A
	add eax, ecx	; eax = A+B
	dump_regs 1 	; 레지스터/플래그 덤프	
	mov edx, eax	; edx = A+B

	mov eax, string_sum
	call print_string
	mov eax, edx	; eax = A+B
	call print_int	; A+B 의 결과 값을 출력 
	call print_nl

	; 4. A - B 계산 및 출력
	mov eax, ebx	; eax = A
	sub eax, ecx	; eax = A-B
	dump_regs 2 	;레지스터/플래그 덤프
	mov edx, eax	; edx = A-B
	
	mov eax, string_sub
	call print_string
	mov eax, edx	; eax = A-B	
	call print_int
	call print_nl

	popa
	mov	eax, 0	; return value
	leave			; leave stack frame
	ret
