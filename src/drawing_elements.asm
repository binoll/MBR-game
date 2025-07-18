; рисование платформы
draw_platform:
; параметры:
;   cx = x-позиция
;   dx = y-позиция
;   bx = высота
;   ax = символ (al) и атрибут (ah)

    pusha
    mov di, dx
    imul di, 80
    add di, cx
    shl di, 1

.draw_loop:
    mov [es:di], ax
    add di, 160
    dec bx
    jnz .draw_loop

    popa
    ret

; рисование мяча
draw_ball:
; параметры:
;   cx = x-позиция (колонка)
;   dx = y-позиция (строка)

    pusha

    ; вычисляем адрес в видеопамяти: di = 2 * (y * 80 + x)
    mov di, dx          ; di = y
    imul di, 80         ; di = y * 80
    add di, cx          ; di = y * 80 + x
    shl di, 1           ; di *= 2 (каждый символ 2 байта)

    ; настройка символа и атрибута
    shl ax, 8
    mov al, 0xdb        ; символ: █ (полный блок)

    mov [es:di], ax     ; записываем символ с атрибутом

    popa
    ret