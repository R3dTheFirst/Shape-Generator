section .data
    welcome_msg db "################################", 0xA
                db "  Welcome to the Shape Drawer!", 0xA
                db "################################", 0xA
    welcome_len equ $ - welcome_msg

    shape_prompt db "Please select a shape (1-10):", 0xA
    shape_prompt_len equ $ - shape_prompt

    size_prompt db "Enter the size of the shape:", 0xA
    size_prompt_len equ $ - size_prompt

    shape_menu db "1. Pixel", 0xA
               db "2. Square", 0xA
               db "3. Right-Angle Rectangle", 0xA
               db "4. Triangle", 0xA
               db "5. Line", 0xA
               db "6. Trapizoid", 0xA
               db "7. Equilateral Triangle", 0xA
               db "8. ---", 0xA
               db "9. ---", 0xA
               db "10. ---", 0xA
    shape_menu_len equ $ - shape_menu

    star db "* "
    star_len equ $ - star
    space db "  "
    space_len equ $ - space
    newline db 0xA
    newline_len equ $ - newline

section .bss
    shape_choice resb 2
    shape_size resb 5

section .text
    global _start

_start:
    ; Print welcome message
    mov rax, 1
    mov rdi, 1
    mov rsi, welcome_msg
    mov rdx, welcome_len
    syscall

    ; Print shape menu
    mov rax, 1
    mov rdi, 1
    mov rsi, shape_menu
    mov rdx, shape_menu_len
    syscall

    ; Print shape prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, shape_prompt
    mov rdx, shape_prompt_len
    syscall

    ; Read shape choice
    mov rax, 0
    mov rdi, 0
    mov rsi, shape_choice
    mov rdx, 2
    syscall

    ; Convert ASCII digit to number
    mov al, [shape_choice]
    sub al, '0'
    mov [shape_choice], al

    ; Print size prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, size_prompt
    mov rdx, size_prompt_len
    syscall

    ; Read size input
    mov rax, 0
    mov rdi, 0
    mov rsi, shape_size
    mov rdx, 5
    syscall

    ; Convert ASCII string to number
    xor rax, rax
    xor rcx, rcx
    mov rsi, shape_size
convert_size:
    movzx rdx, byte [rsi+rcx]
    cmp rdx, 0xA
    je convert_done
    sub rdx, '0'
    imul rax, 10
    add rax, rdx
    inc rcx
    jmp convert_size
convert_done:
    mov [shape_size], rax

    ; Jump to appropriate shape drawing function
    mov al, [shape_choice]
    cmp al, 1
    je draw_pixel
    cmp al, 2
    je draw_square
    cmp al, 3
    je draw_rectangle
    cmp al, 4
    je draw_rtriangle
    cmp al, 5
    je draw_line
    cmp al, 6
    je draw_trapizoid
    cmp al, 7
    je draw_etriangle
    jmp exit_program

; Algorithm for the shapes
draw_pixel:
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall

    jmp exit_program

draw_square:
    mov r12, [shape_size]  ; rows
    mov r13, [shape_size]  ; columns
square_outer:
    mov r13, [shape_size]
square_inner:
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, star_len
    syscall
    dec r13
    jnz square_inner
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall
    dec r12
    jnz square_outer
    jmp exit_program

draw_rectangle:
    mov r12, [shape_size]
    mov r13, [shape_size]
    add r13, r12            ; The width of the rectangle is more than its height
rectangle_outter:
    mov r14, r13            ; A copy of the width
rectangle_inner:
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, star_len
    syscall

    dec r14
    jnz rectangle_inner

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall

    dec r12
    jnz rectangle_outter

    jmp exit_program

draw_rtriangle:
    mov r12, 1          ; row counter
triangle_outer:
    mov r13, r12        ; stars to print
triangle_inner:
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, star_len
    syscall
    dec r13
    jnz triangle_inner
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall
    inc r12
    cmp r12, [shape_size]
    jle triangle_outer
    jmp exit_program

draw_line:
    mov r12, [shape_size]
    mov r13, r12
line:
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, star_len
    syscall
    dec r13

    jnz line
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall
    
    jmp exit_program

draw_trapizoid:
    mov rax, 1
    mov rdi, 1


draw_etriangle:
    mov rax, 1
    mov rdi, 1

exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall
