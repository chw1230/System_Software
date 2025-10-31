%include "asm_io.inc"

	segment	.data
	;
	; initialized data is put in the data segment here
	;
string_a	db	'Enter a number (A) : ', 0x00
string_b	db	'Enter a number (B) : ', 0x00
string_sum	db 	'A + B = ', 0x00
string_sub	db 	'A - B = ', 0x00
string_mul	db	'A * B = ', 0x00
string_div	db	'A / B = ', 0x00
string_comma	db	', ', 0x00

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
	mov edx, eax	; edx = A+B

	mov eax, string_sum
	call print_string
	mov eax, edx	; eax = A+B
	call print_int	; A+B 의 결과 값을 출력 
	call print_nl

	; 4. A - B 계산 및 출력
	mov eax, ebx	; eax = A
	sub eax, ecx	; eax = A-B
	mov edx, eax	; edx = A-B
	
	mov eax, string_sub
	call print_string
	mov eax, edx	; eax = A-B	
	call print_int
	call print_nl

	; 5. A * B 계산 및 출력 
	mov eax, ebx	; eax = A
	imul ecx	; eax = A * B 부호있는 곱
	mov edx, eax

	mov eax, string_mul
	call print_string
	mov eax, edx
	call print_int
	call print_nl

	; 6. A / B (몫과 나머지)
	mov eax, ebx	; eax = A
	cdq	; edx에 부호 확장 / EAX의 부호 비트(최상위 비트) 를 EDX로 복사
	idiv ecx	; ( A / B )
	mov esi, eax	; 몫
	mov edi, edx	; 나머지

	mov eax, string_div
	call print_string
	mov eax, esi	; 몫 출력
	call print_int
	mov eax, string_comma	; , 출력
	call print_string
	mov eax, edi	; 나머지 출력
	call print_int
	call print_nl

	popa
	mov	eax, 0	; return value
	leave			; leave stack frame
	ret
