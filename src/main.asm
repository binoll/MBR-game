[org 0x7c00] ; MBR загружается по адресу 0x7C00
[bits 16]

section .text
global _start

_start:
    ; инициализация сегментных регистров
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; безопасная настройка стека (ниже MBR)
    mov ax, 0x7100                      ; сегмент стека = 0x7100
    mov ss, ax
    mov sp, 0x0                         ; вершина стека (0x0000)

    ; настройка видеорежима через BIOS (80x25 текстовый режим)
    mov ax, 0x3                         ; ah=00, al=03 (80x25, 16 цветов)
    int 0x10                            ; ch=0x26 (бит 5 установлен - скрыть курсор), cl=0x07

    ; отключаем курсор BIOS
    mov ah, 0x1                         ; функция установки формы курсора
    mov ch, 0x2607                      ; ch=0x26 (бит 5 установлен - скрыть курсор), cl=0x07
    int 0x10

    ; настройка доступа к видеопамяти
    mov ax, 0xB800                      ; сегмент видеопамяти
    mov es, ax                          ; es = видеопамять
    xor di, di                          ; di = 0 (начало видеобуфера)

main_loop:
    ; рисуем левую платформу
    mov cx, [start_left_platform_pos_x] ; x-позиция
    mov dx, [start_left_platform_pos_y] ; y-позиция
    mov bx, [left_platform_height]      ; высота
    mov ax, [left_platform_color]       ; цвет
    call draw_platform

    ; рисуем правую платформу
    mov cx, [start_right_platform_pos_x] ; x-позиция
    mov dx, [start_right_platform_pos_y] ; y-позиция
    mov bx, [right_platform_height]      ; высота
    mov ax, [right_platform_color]       ; цвет
    call draw_platform

    ; рисуем мяч
    mov cx, [start_ball_pos_x]           ; x-позиция
    mov dx, [start_ball_pos_y]           ; y-позиция
    mov ax, [ball_color]                 ; цвет
    call draw_ball

    jmp main_loop                        ; бесконечный цикл

; включение файла с функциями рисования
%include "src/drawing_elements.asm"

; переменные
start_left_platform_pos_x dw 0x1
start_left_platform_pos_y dw 0xa
left_platform_height dw 0x5
left_platform_color dw 0x44

start_right_platform_pos_x dw 0x4E
start_right_platform_pos_y dw 0xa
right_platform_height dw 0x5
right_platform_color dw 0x11

start_ball_pos_x dw 0x23
start_ball_pos_y dw 0xa
ball_color dw 0xee

; заполнение до 510 байт и сигнатура загрузочного сектора
times 510 - ($ - $$) db 0
dw 0xaa55