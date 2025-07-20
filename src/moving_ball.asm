; функция движения мяча
moving_ball:
    ; сохраняем текущие позиции как предыдущие
    mov ax, [current_ball_pos_x]
    mov bx, [current_ball_pos_y]
    mov [prev_ball_pos_x], ax
    mov [prev_ball_pos_y], bx

    ; загружаем текущие позиции
    mov ax, [current_ball_pos_y]
    mov bx, [current_ball_pos_x]

    ; вертикальное движение
    cmp byte [ball_vert_dir], 1
    je .moving_down

.moving_up:
    dec ax
    cmp ax, 0
    jg .moving_horiz
    mov byte [ball_vert_dir], 1
    jmp .moving_horiz

.moving_down:
    inc ax
    cmp ax, 24
    jl .moving_horiz
    mov byte [ball_vert_dir], 0

.moving_horiz:
    ; горизонтальное движение с учетом направления
    cmp byte [ball_horiz_dir], 1
    je .move_right
    dec bx  ; движение влево
    jmp .check_left_platform
.move_right:
    inc bx  ; движение вправо

.check_left_platform:
    ; проверка столкновения с левой платформой
    cmp byte [ball_horiz_dir], 0
    jne .check_right_platform
    mov cx, [current_left_platform_pos_x]
    inc cx
    cmp bx, cx
    jne .check_right_platform
    mov cx, [current_left_platform_pos_y]
    mov dx, cx
    add dx, [left_platform_height]
    cmp ax, cx
    jl .check_right_platform
    cmp ax, dx
    jge .check_right_platform
    mov byte [ball_horiz_dir], 1
    jmp .save_position

.check_right_platform:
    ; проверка столкновения с правой платформой
    cmp byte [ball_horiz_dir], 1
    jne .save_position
    mov cx, [current_right_platform_pos_x]
    dec cx
    cmp bx, cx
    jne .save_position
    mov cx, [current_right_platform_pos_y]
    mov dx, cx
    add dx, [right_platform_height]
    cmp ax, cx
    jl .save_position
    cmp ax, dx
    jge .save_position
    mov byte [ball_horiz_dir], 0

.save_position:
    ; сохраняем новые позиции
    mov [current_ball_pos_y], ax
    mov [current_ball_pos_x], bx

    ; перерисовка мяча (используем сохраненные ранее предыдущие позиции)
    mov cx, [prev_ball_pos_x]
    mov dx, [prev_ball_pos_y]
    mov bx, 1
    mov ax, 0x0020 ; заменяем на пробельный символ
    call draw_elements

    ; рисование мяча (используем текущие позиции из регистров)
    mov cx, [current_ball_pos_x]
    mov dx, [current_ball_pos_y]
    mov bx, 1
    mov ah, [ball_color]
    mov al, [symbol]
    call draw_elements

    ret