[ORG 0X00]
[BITS 16]

SECTION .text

jmp 0x1000:START

SECTORCOUNT:    dw 0x0000   ; 현재 실행 중인 섹터 번호 저장
TOTALSECTORCOUNT equ 1024   ; 가상 OS의 총 섹터 수

START:
    mov ax, cs
    mov ds, ax
    mov ax, 0xB800
    mov es, ax

    %assign i   0
    %rep TOTALSECTORCOUNT                       ; TOTALSECTORCOUNT만큼 반복
        %assign i   i+1
        mov ax, 2
        mul word [ SECTORCOUNT ]
        mov si, ax
        mov byte [ es: si + (160 * 2) ], '0'+ ( i % 10 )  ; 계산된 결과를 세번째 라인부터 화면에 0을 출력

        add word [ SECTORCOUNT ], 1

        %if i == TOTALSECTORCOUNT
            jmp $                               ; 현재 위치에서 무한 루프 수행
        %else
            jmp (0x1000 + i * 0x20): 0x0000     ; 다음 섹터 오프셋으로 이동
        %endif

        times ( 512 - ($ - $$) % 512 )  db 0x00

    %endrep