; функция задержки
delay:
    push cx
    mov cx, 0x3000

.delay_loop:
    nop
    loop .delay_loop

    pop cx
    ret