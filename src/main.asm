[org 0x7c00] ; MBR загружается по адресу 0x7C00
[bits 16]

; code
section .text
global _start

_start:
    ; инициализация сегментных регистров
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; безопасная настройка стека (ниже MBR)
    mov ax, 0x7100     ; сегмент стека = 0x7100
    mov ss, ax
    mov sp, 0x0        ; вершина стека (0x0000)

    ; настройка видеорежима через BIOS (80x25 текстовый режим)
    mov ax, 0x3        ; ah=00, al=03 (80x25, 16 цветов)
    int 0x10           ; ch=0x26 (бит 5 установлен - скрыть курсор), cl=0x07

    ; отключаем курсор BIOS
    mov ah, 0x1        ; функция установки формы курсора
    mov ch, 0x2607     ; ch=0x26 (бит 5 установлен - скрыть курсор), cl=0x07
    int 0x10

    ; настройка доступа к видеопамяти
    mov ax, 0xB800     ; сегмент видеопамяти
    mov es, ax         ; es = видеопамять
    xor di, di         ; di = 0 (начало видеобуфера)

main_loop:
    ; рисуем левую платформу
    mov cx, 1          ; x-позиция
    mov dx, 10         ; y-позиция
    mov bx, 5          ; высота
    mov ax, 0x44       ; цвет
    call draw_platform

    ; рисуем правую платформу
    mov cx, 78         ; x-позиция
    mov dx, 10         ; y-позиция
    mov bx, 5          ; высота
    mov ax, 0x11       ; цвет
    call draw_platform

    ; рисуем мяч
    mov cx, 35          ; x-позиция
    mov dx, 10          ; y-позиция
    mov ax, 0xee        ; цвет
    call draw_ball

    jmp main_loop      ; бесконечный цикл

; включение файла с функциями рисования
%include "src/drawing_elements.asm"

; заполнение до 510 байт и сигнатура загрузочного сектора
times 510 - ($ - $$) db 0
dw 0xaa55