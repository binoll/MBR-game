; обработка нажатий на клавиши
handle_keyboard:
pusha

; проверяем наличие нажатых клавиш в буфере
.process_keys:
    ; проверяем, есть ли клавиши в буфере
    mov ah, 0x01
    int 0x16
    jz .no_keys

    ; считываем клавишу из буфера
    mov ah, 0x00
    int 0x16

    ; обрабатываем клавишу для ЛЕВОЙ платформы
    cmp ah, [left_platform_key_up]
    je .left_up
    cmp ah, [left_platform_key_down]
    je .left_down

    ; обрабатываем клавишу для ПРАВОЙ платформы
    cmp ah, [right_platform_key_up]
    je .right_up
    cmp ah, [right_platform_key_down]
    je .right_down

    jmp .process_keys ; продолжаем обработку других клавиш

.left_up:
    ; двигаем левую платформу вверх
    mov ax, [start_left_platform_pos_y]
    cmp ax, 1
    jle .process_keys
    dec ax
    mov [start_left_platform_pos_y], ax
    jmp .process_keys

.left_down:
    ; двигаем левую платформу вниз
    mov ax, [start_left_platform_pos_y]
    mov bx, [left_platform_height]
    add ax, bx
    cmp ax, 24
    jge .process_keys
    mov ax, [start_left_platform_pos_y]
    inc ax
    mov [start_left_platform_pos_y], ax
    jmp .process_keys

.right_up:
    ; двигаем правую платформу вверх
    mov ax, [start_right_platform_pos_y]
    cmp ax, 1
    jle .process_keys
    dec ax
    mov [start_right_platform_pos_y], ax
    jmp .process_keys

.right_down:
    ; двигаем правую платформу вниз
    mov ax, [start_right_platform_pos_y]
    mov bx, [right_platform_height]
    add ax, bx
    cmp ax, 24
    jge .process_keys
    mov ax, [start_right_platform_pos_y]
    inc ax
    mov [start_right_platform_pos_y], ax
    jmp .process_keys

.no_keys:
    popa
    ret