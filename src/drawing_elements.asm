; рисование платформы
draw_elements:
; параметры:
;   cx = x-позиция
;   dx = y-позиция
;   bx = высота
;   ax = символ (al) и атрибут (ah)
    ; вычисляем адрес в видеопамяти: di = 2 * (y * 80 + x)
    mov di, dx          ; di = y
    imul di, 80         ; di = y * 80
    add di, cx          ; di = y * 80 + x
    shl di, 1           ; di *= 2 (каждый символ 2 байта)

.draw_loop:
    mov [es:di], ax
    add di, 160
    dec bx
    jnz .draw_loop

    ret