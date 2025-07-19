; стирание платформы
erase_platform:
; параметры:
;   cx = x-позиция
;   dx = y-позиция
;   bx = высота
    pusha

    mov di, dx
    imul di, 80
    add di, cx
    shl di, 1
    mov ax, 0x0020  ; пробел + черный фон

.erase_loop:
    mov [es:di], ax
    add di, 160
    dec bx
    jnz .erase_loop

    popa
    ret