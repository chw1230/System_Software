%include "asm_io.inc"

        segment .data
a       dd  1, 2, 3, 4, 5, 6
rows_a  dd  2          ; A의 행 개수
cols_a  dd  3          ; A의 열 개수

b       dd  7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9
rows_b  dd  3          ; B의 행 개수
cols_b  dd  4          ; B의 열 개수

        segment .bss
c       resd 8          ; 2 * 4 = 8개

rows_c  resd 1          ; 결과 행렬의 행 수 (rows_a와 동일)
cols_c  resd 1          ; 결과 행렬의 열 수 (cols_b와 동일)

        segment .text
        global  main

main:
        enter   0, 0            
        pusha                   

;-----------------------------------------
; 행열 C의 크기 관련 설정하기
;    rows_c = rows_a
;    cols_c = cols_b
        mov     eax, [rows_a]
        mov     [rows_c], eax

        mov     eax, [cols_b]
        mov     [cols_c], eax

;-----------------------------------------
; 행렬 곱하기
;
; 의사코드:
; for (i = 0; i < rows_a; i++)
;   for (j = 0; j < cols_b; j++) {
;     sum = 0;
;     for (k = 0; k < cols_a; k++)
;       sum += A[i][k] * B[k][j];
;     C[i][j] = sum;
;   }
;
; 레지스터 역할:
;   ESI = i (행 인덱스)
;   EDI = j (열 인덱스)
;   EDX = k (내부 루프 인덱스)
;   EBX = sum (누적 합)
;   EAX, ECX = 중간 계산용

        mov     esi, 0          ; i = 0, 시작 루프 인덱스 시작 0부터

outer_i_loop:                   ; i 루프 시작
        cmp     esi, [rows_a]   ; i < rows_a 비교해서 작으면 다음 루프(mid)로!
        jge     done_mmult      ; 크거나 같으면 행렬 곱 끝내기

        mov     edi, 0          ; j = 0, 다음 루프(mid) 인덱스 시작 0부터

outer_j_loop:                     
        cmp     edi, [cols_b]   ; j < cols_b 비교해서 작으면 다음 루프(inner)로!
        jge     end_row_i       ; 크거나 같으면 해당 i(행)의 열 계산이 모두 끝난 상태 -> 한 행(row)이 끝났다는 뜻이니까, 다음 행(i+1) 으로 넘어가는 코드가 있는 end_row_i 로 점프

        mov     ebx, 0          ; sum = 0, sum 선언하기

        mov     edx, 0          ; k = 0, 다음 루프(inner) 인덱스 시작 0부터 

inner_k_loop:                   
        cmp     edx, [cols_a]   ; k < cols_a 비교해서 작으면 계산으로 이동
        jge     end_k_loop      ; 크거나 같으면 sum을 C[i][j] 에 저장하는 코드로 이동
        
; ----- A[i][k] 로드 --------------------------------
; indexA = i * cols_a + k 
; 주소 = a + indexA * 4 (int 4바이트)
        mov     eax, esi        ; eax = i
        imul    eax, [cols_a]   ; eax = i * cols_a
        add     eax, edx        ; eax = i * cols_a + k
        shl     eax, 2          ; eax *= 4 / imul eax, 4 랑 동일함   
        mov     ecx, [a + eax]  ; ecx = A[i][k]

; ----- B[k][j] 로드 --------------------------------
; indexB = k * cols_b + j
; 주소 = b + indexB * 4
        mov     eax, edx        ; eax = k
        imul    eax, [cols_b]   ; eax = k * cols_b
        add     eax, edi        ; eax = k * cols_b + j
        shl     eax, 2          ; eax *= 4
        mov     eax, [b + eax]  ; eax = B[k][j]

; ----- sum += A[i][k] * B[k][j] --------------------
        imul    ecx, eax        ; ecx = A[i][k] * B[k][j]
        add     ebx, ecx        ; sum += ecx

        inc     edx             ; k++
        jmp     inner_k_loop

end_k_loop:
; ----- C[i][j] = sum --------------------------------
; indexC = i * cols_b + j
; 주소 = c + indexC * 4
        mov     eax, esi        ; eax = i
        imul    eax, [cols_b]   ; eax = i * cols_b
        add     eax, edi        ; eax = i * cols_b + j
        shl     eax, 2          ; eax *= 4
        mov     [c + eax], ebx  ; C[i][j] = sum

        inc     edi             ; j++
        jmp     outer_j_loop

end_row_i:
        inc     esi             ; i++
        jmp     outer_i_loop    ; 다음 행(i)로 이동

;-----------------------------------------
; 결과 출력
done_mmult:
        mov     esi, 0          ; i = 0 (행 인덱스)

print_i_loop:
        cmp     esi, [rows_c]   ; i < rows_c ?
        jge     end_program     ; 아니면 출력 종료

        mov     edi, 0          ; j = 0 (열 인덱스)

print_j_loop:
        cmp     edi, [cols_c]   ; j < cols_c ?
        jge     end_print_row   ; 한 행 출력 끝

; c[i][j] 읽어서 출력
        mov     eax, esi
        imul    eax, [cols_c]   ; eax = i * cols_c
        add     eax, edi        ; eax = i * cols_c + j
        shl     eax, 2          ; 바이트 오프셋
        mov     eax, [c + eax]  ; eax = C[i][j]

        ; print_int(eax)
        call    print_int

        ; 숫자 사이 공백 출력
        mov     eax, ' '        ; 공백 문자
        call    print_char

        inc     edi
        jmp     print_j_loop

end_print_row:
        ; 한 행 끝 -> 줄바꿈
        call    print_nl
        inc     esi
        jmp     print_i_loop

;-----------------------------------------
; 종료 처리
end_program:
        popa                    
        mov     eax, 0         
        leave                  
        ret

