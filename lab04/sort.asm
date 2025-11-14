%include "asm_io.inc"

        segment .data
array   dd      3,1,5,7,2,8,4,9,6,10
size    dd      10
out_str db      'Sort ', 0

        segment .text
        global  main
main:
        enter   0,0             ; setup stack frame
        pusha

        mov esi, 0              ; esi = i, 중첩 for문 에서 밖에 위치한 것!

outer_loop: 
        cmp esi, [size]         ; esi(i) 가 10보다 작으면 반복, 10보다 크면 루프 완전히 빠져나오기! ( 0 <= i <= n-1 )
        jge end_outer

        mov edx, [size] 
        sub edx, esi             ; edx = n - i
        mov edi, 0               ; edi = j
inner_loop:
        cmp edi, edx
        jg end_inner

        mov ebx, [array + edi*4] ; ebx = array[j]
        cmp ebx, [array + edi*4 + 4] ; array[j] 와 array[j+1]의 값의 비교를 하려는 것!
        ; 오름 차순으로 할 것이니까 array[j] > array[j+1] 이거면 안됨!
        jle skip

        ; 여기에 왔다는 것은 array[j] > array[j+1] 라는 것!! -> 바꿔주기!
        mov ecx, [array + edi*4 + 4] ; ecx = array[j+1]
        mov [array + edi*4 + 4], ebx ; array[j+1] = array[j]
        mov [array + edi*4], ecx     ; array[j] = array[j+1]
                
skip:  
        inc edi
        jmp inner_loop
end_inner:
        
        inc esi
        jmp outer_loop
end_outer:
        
        ; 정렬이 종료된 상태! -> 이제 출력
        mov ecx, 0
while:
        cmp ecx, [size]
        jge end_while

        mov eax, [array + ecx*4]        ; print array[ecx]
        call print_int
        call print_nl

        inc ecx   
        jmp while

end_while:
        popa
        mov     eax, 0  ; return value
        leave                   ; leave stack frame
        ret

