[org 0x7c00] ; MBR загружается по адресу 0x7C00
[bits 16]

section .text
global _start

_start:
    ; безопасная настройка стека (ниже MBR)
    mov ax, 0x7100  ; сегмент стека = 0x7100
    mov ss, ax
    xor sp, sp      ; вершина стека (0x0000)

    ; настройка видеорежима через BIOS (80x25 текстовый режим)
    mov ax, 0x0003  ; ah=00, al=03 (80x25, 16 цветов)
    int 0x10

    ; отключаем курсор BIOS
    mov ah, 0x1     ; функция установки формы курсора
    mov cx, 0x2607
    int 0x10

    ; настройка доступа к видеопамяти
    mov ax, 0xb800  ; сегмент видеопамяти
    mov es, ax      ; es = видеопамять
    xor di, di      ; di = 0 (начало видеобуфера)

.main_loop:
    ; обработка ввода с клавиатуры для ВСЕХ платформ
    call handle_keyboard

    ; проверка изменений для ЛЕВОЙ платформы
    cmp ax, [prev_left_platform_pos_y]
    je .no_redraw_left

    ; перерисовка левой платформы
    mov cx, [current_left_platform_pos_x]
    mov dx, [prev_left_platform_pos_y]
    mov bx, [left_platform_height]
    mov ax, 0x0020  ; заменяем на пробельный символ
    call draw_elements

    mov cx, [current_left_platform_pos_x]
    mov dx, [current_left_platform_pos_y]
    mov bx, [left_platform_height]
    mov ah, [left_platform_color]
    mov al, [symbol]
    call draw_elements

    mov ax, [current_left_platform_pos_y]
    mov [prev_left_platform_pos_y], ax

.no_redraw_left:
    ; проверка изменений для ПРАВОЙ платформы
    mov ax, [prev_right_platform_pos_y]
    cmp ax, [current_right_platform_pos_y]
    je .end_redraw_platform

    ; перерисовка правой платформы
    mov cx, [current_right_platform_pos_x]
    mov dx, [prev_right_platform_pos_y]
    mov bx, [right_platform_height]
    mov ax, 0x0020  ; заменяем на пробельный символ
    call draw_elements

    mov cx, [current_right_platform_pos_x]
    mov dx, [current_right_platform_pos_y]
    mov bx, [right_platform_height]
    mov ah, [right_platform_color]
    mov al, [symbol]
    call draw_elements

    mov ax, [current_right_platform_pos_y]
    mov [prev_right_platform_pos_y], ax

.end_redraw_platform:
    call moving_ball

    ; задержка
    mov ah, 0x86
    xor cx, cx
    mov dx, 65535
    int 15h

    mov ax, [current_ball_pos_x]
    dec ax
    cmp ax, 77
    ja .end_game

    jmp .main_loop

.end_game:
    ret

; включение файлов
%include "src/drawing_elements.asm"
%include "src/keyboard.asm"
%include "src/moving_ball.asm"

; переменные
; для левой платформы
symbol                        db 0xdb    ; символ: █ (полный блок)

prev_left_platform_pos_y      dw 0x0     ; предыдущая y-координата
current_left_platform_pos_x   dw 0x1     ; текущая x-координата
current_left_platform_pos_y   dw 0xa     ; текущая y-координата
left_platform_height          dw 0x5     ; высота платформы
left_platform_color           db 0x44    ; цвет платфоры
left_platform_key_up          db 0x11    ; скан-код W
left_platform_key_down        db 0x1f    ; скан-код S

; для правой платформы
prev_right_platform_pos_y     dw 0x0     ; предыдущая y-координата
current_right_platform_pos_x  dw 0x4E    ; текущая x-координата
current_right_platform_pos_y  dw 0xa     ; текущая y-координата
right_platform_height         dw 0x5     ; высота платформы
right_platform_color          db 0x11    ; цвет платфоры
right_platform_key_up         db 0x48    ; стрелка вверх
right_platform_key_down       db 0x50    ; стрелка вниз

; для мяча
ball_vert_dir                 db 0x0     ; 1 = вниз, 0 = вверх
ball_horiz_dir                db 0x0     ; 1 = вправо, 0 = влево
prev_ball_pos_x               dw 0x23    ; предыдущая x-координата
prev_ball_pos_y               dw 0xa     ; предыдущая y-координата
current_ball_pos_x            dw 0x23    ; текущая x-координата
current_ball_pos_y            dw 0xa     ; текущая y-координата
ball_color                    db 0xee    ; цвет платфоры

; заполнение до 510 байт и сигнатура загрузочного сектора
times 510 - ($ - $$) db 0
dw 0xaa55