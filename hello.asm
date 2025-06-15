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
               db "3. Rectangle", 0xA
               db "4. Right-Angle Triangle", 0xA
               db "5. Line", 0xA
               db "6. Polygon", 0xA
               db "7. Equilateral Triangle", 0xA
               db "8. Parallelogram", 0xA
               db "9. Arrow", 0xA
               db "10. Diamond", 0xA
    shape_menu_len equ $ - shape_menu

    star db "* "
    star_len equ $ - star

    space db "  "
    space_len equ $ - space

    newline db 0xA
    newline_len equ $ - newline

section .bss
    shape_choice resb 10
    shape_size resb 10

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
    mov rdx, 10
    syscall

    ; Convert ASCII string to number for shape choice
    xor rax, rax               ; Clear result
    xor rcx, rcx               ; Clear index counter
    mov rsi, shape_choice      ; Point to input buffer

convert_choice:
    movzx rdx, byte [rsi+rcx]  ; Load next character
    cmp rdx, 0xA               ; Check for newline
    je choice_done             ; If newline, we're done
    cmp rdx, 0                 ; Check for null terminator
    je choice_done             ; If null, we're done
    cmp rdx, '0'               ; Check if character is below '0'
    jb choice_done             ; If below '0', not a digit
    cmp rdx, '9'               ; Check if character is above '9'
    ja choice_done             ; If above '9', not a digit
    
    sub rdx, '0'               ; Convert ASCII to number
    imul rax, 10               ; Multiply current result by 10
    add rax, rdx               ; Add new digit
    inc rcx                    ; Move to next character
    jmp convert_choice         ; Continue loop

choice_done:
    mov [shape_choice], al     ; Store the converted choice

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
    mov rdx, 10
    syscall

    ; Convert ASCII string to number (FIXED VERSION)
    xor rax, rax               ; Clear result
    xor rcx, rcx               ; Clear index counter
    mov rsi, shape_size        ; Point to input buffer

convert_size:
    movzx rdx, byte [rsi+rcx]  ; Load next character
    cmp rdx, 0xA               ; Check for newline
    je convert_done            ; If newline, we're done
    cmp rdx, 0                 ; Check for null terminator
    je convert_done            ; If null, we're done
    cmp rdx, '0'               ; Check if character is below '0'
    jb convert_done            ; If below '0', not a digit
    cmp rdx, '9'               ; Check if character is above '9'
    ja convert_done            ; If above '9', not a digit
    
    sub rdx, '0'               ; Convert ASCII to number
    imul rax, 10               ; Multiply current result by 10
    add rax, rdx               ; Add new digit
    inc rcx                    ; Move to next character
    cmp rcx, 4                 ; Prevent buffer overflow (max 4 digits)
    jl convert_size            ; Continue if within bounds

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
    je draw_polygon
    cmp al, 7
    je draw_etriangle
    cmp al, 8
    je draw_parallelogram
    cmp al, 9
    je draw_arrow
    cmp al, 10
    je draw_diamond
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

draw_polygon:
    mov r12, [shape_size]      ; Total rows (3)
    mov r14, [shape_size]      ; Stars per row (initially 3)
    add r14, r14               ; r14 = 3 * 2 = 6 (first row stars)
    mov r15, 0                 ; Current row counter

print_row:
    ; Print stars (r14 times)
    mov rbx, 0                 ; Star counter
    mov rcx, 0                 ; Space Counter

print_stars:
    mov rax, 1                
    mov rdi, 1                
    mov rsi, star              
    mov rdx, star_len          
    syscall

    inc rbx
    cmp rbx, r14
    jl print_stars             ; Loop until all stars printed

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall

    dec r14                    ; Decrease stars by 1
    inc r15                    ; Increment row counter
    cmp r15, r12               ; Check if we've printed (shape_size + 1) rows
    jle print_row              ; Loop if r15 <= r12

    jmp exit_program
draw_etriangle:
    mov r12, 1                 ; Current row counter (starting from 1)

etriangle_outer:
    ; Calculate and print leading spaces
    ; spaces = (shape_size - current_row)
    mov r8, [shape_size]
    sub r8, r12                ; r8 = spaces needed
    
etriangle_spaces:
    cmp r8, 0
    je etriangle_stars         ; If no more spaces, print stars
    
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, space_len         ; Print two spaces to match star width
    syscall
    
    dec r8
    jmp etriangle_spaces

etriangle_stars:
    ; Calculate number of stars for current row
    ; stars = (2 * current_row - 1)
    mov r13, r12
    add r13, r12               ; r13 = 2 * current_row
    dec r13                    ; r13 = 2 * current_row - 1

etriangle_inner:
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, star_len
    syscall
    dec r13
    jnz etriangle_inner

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall
    
    ; Move to next row
    inc r12
    mov rax, [shape_size]
    inc rax                    ; Compare with shape_size + 1
    cmp r12, rax
    jl etriangle_outer         ; Continue if r12 < shape_size + 1
    
    jmp exit_program

draw_parallelogram:
    mov r12, [shape_size]      ; Number of spaces (starts at shape_size)

fixed_stars_outer:
    ; Print spaces
    mov r14, r12               ; Copy space count
    
fixed_stars_spaces:
    cmp r14, 0
    je fixed_stars_print       ; If no more spaces, print stars
    
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1                 ; Print single space
    syscall
    
    dec r14
    jmp fixed_stars_spaces

fixed_stars_print:
    ; Print fixed number of stars (shape_size)
    mov r15, [shape_size]      ; Always print shape_size stars

fixed_stars_loop:
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, star_len
    syscall
    dec r15
    jnz fixed_stars_loop

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall
    
    ; Decrease spaces
    dec r12
    
    ; Check if we should continue (stop when spaces < 0)
    cmp r12, 0
    jge fixed_stars_outer      ; Continue if spaces >= 0
    
    jmp exit_program

draw_arrow:
    mov r12, 1                 ; Current row counter (starting from 1)

eatriangle_outer:
    ; Calculate and print leading spaces
    ; spaces = (shape_size - current_row)
    mov r8, [shape_size]
    sub r8, r12                ; r8 = spaces needed
    
eatriangle_spaces:
    cmp r8, 0
    je eatriangle_stars         ; If no more spaces, print stars
    
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, space_len
    syscall
    
    dec r8
    jmp eatriangle_spaces

eatriangle_stars:
    ; Calculate number of stars for current row
    ; stars = (2 * current_row - 1)
    mov r13, r12
    add r13, r12               ; r13 = 2 * current_row
    dec r13                    ; r13 = 2 * current_row - 1

eatriangle_inner:
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, star_len
    syscall
    dec r13
    jnz eatriangle_inner

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall
    
    ; Move to next row
    inc r12
    mov rax, [shape_size]
    inc rax                    ; Compare with shape_size + 1
    cmp r12, rax
    jl eatriangle_outer         ; Continue if r12 < shape_size + 1
    
    ; Draw vertical line (1 star wide, height = shape_size rows)
    mov r14, [shape_size]      ; Line height = triangle row count
    mov r15, [shape_size]
    dec r15                    ; r15 = spaces needed for centering (shape_size - 1)

draw_vertical_line:
    cmp r14, 0
    je exit_program            ; Exit when all lines drawn
    
    ; Print leading spaces
    mov r8, r15
    cmp r8, 0
    je print_vertical_star
    
print_vertical_spaces:
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, space_len
    syscall
    dec r8
    jnz print_vertical_spaces

print_vertical_star:
    ; Print single star
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, star_len
    syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall

    dec r14
    jmp draw_vertical_line

draw_diamond:
    mov r12, 1                 ; Current row counter for upper half
    
    ; Draw upper half of diamond (expanding triangle)
upper_diamond_outer:
    ; Calculate and print leading spaces
    ; spaces = (shape_size - current_row)
    mov r8, [shape_size]
    sub r8, r12                ; r8 = spaces needed
    
upper_diamond_spaces:
    cmp r8, 0
    je upper_diamond_stars     ; If no more spaces, print stars
    
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, space_len
    syscall
    
    dec r8
    jmp upper_diamond_spaces

upper_diamond_stars:
    ; Calculate number of stars for current row
    ; stars = (2 * current_row - 1)
    mov r13, r12
    add r13, r12               ; r13 = 2 * current_row
    dec r13                    ; r13 = 2 * current_row - 1

upper_diamond_inner:
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, star_len
    syscall
    dec r13
    jnz upper_diamond_inner

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall
    
    ; Move to next row
    inc r12
    mov rax, [shape_size]
    inc rax                    ; Compare with shape_size + 1
    cmp r12, rax
    jl upper_diamond_outer     ; Continue if r12 < shape_size + 1
    
    ; Draw lower half of diamond (contracting triangle)
    mov r12, [shape_size]      ; Start from shape_size
    dec r12                    ; r12 = shape_size - 1 (skip the middle row)
    
lower_diamond_outer:
    cmp r12, 0
    je exit_program            ; Exit when all rows drawn
    
    ; Calculate and print leading spaces
    ; spaces = (shape_size - current_row)
    mov r8, [shape_size]
    sub r8, r12                ; r8 = spaces needed
    
lower_diamond_spaces:
    cmp r8, 0
    je lower_diamond_stars     ; If no more spaces, print stars
    
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, space_len
    syscall
    
    dec r8
    jmp lower_diamond_spaces

lower_diamond_stars:
    ; Calculate number of stars for current row
    ; stars = (2 * current_row - 1)
    mov r13, r12
    add r13, r12               ; r13 = 2 * current_row
    dec r13                    ; r13 = 2 * current_row - 1

lower_diamond_inner:
    mov rax, 1
    mov rdi, 1
    mov rsi, star
    mov rdx, star_len
    syscall
    dec r13
    jnz lower_diamond_inner

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, newline_len
    syscall
    
    ; Move to previous row (contracting)
    dec r12
    jmp lower_diamond_outer

exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall
