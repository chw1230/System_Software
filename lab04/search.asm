%include "asm_io.inc"

        segment .data
array   dd      3, 1, 5, 7, 2, 8, 4, 9, 6, 10
size    dd      10  ; 배열의 크기
prompt  db      'Enter a number: ', 0
out_str db      'The number found is found at ', 0

        segment .text
        global  main
main:
        enter   0,0             ; setup stack frame
        pusha

        mov eax, prompt
        call print_string
        call read_int           ; eax = 검색할 key

        mov ecx, 0              ; index

rpt: 
        cmp eax, [array + ecx*4] ;array는 배열의 시작 주소, 4*ecx 배열의 인덱스, 4*의 4는 double word 4byte를 의미
        ; 내가 찾는 KEY랑 배열에 있는 값이랑 같은지 확인하는 부분
        je out 
        inc ecx                  ; 같지 않다면, ecx 값을 키워서 배열속에 있는 지 확인
        cmp ecx, [size]          ; 10과 비교해서 작다면
        jl rpt                   ; rpt 반복!

out:   
        cmp ecx, [size]           ; ecx - index를 통해서 중간에 답을 찾아서 나온 것인지 아니면, 못 찾고 10을 넘어 나온 것인지
        jl found
        mov ecx, -1              ; 못 찾아서 ecx에 -1 넣어두기
        
found: 
        mov eax, out_str
        call print_string
        
        mov eax, ecx             ; 찾은 값의 인덱스 혹은 -1을 eax에 넘기기
        call print_int
        call print_nl   

        popa
        mov     eax, 0  ; return value
        leave                   ; leave stack frame
        ret

