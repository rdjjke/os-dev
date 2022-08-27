;
; print_hex prints the value of DX as hex.
;
print_hex:
    pusha ; Save all registers on the stack.

    mov cx, 5 ; Setup our loop index.

print_hex_loop:
    ; Quit the loop when the source value in DX become zero.
    cmp dx, 0
    je print_hex_end

    ; Get the current digit letter in AH.
    mov si, dx         ; Copy the current value to SI.
    and si, 0x000f     ; Take the last digit.
    add si, HEX_DIGITS ; Make SI the address to the desired hex digit.
    mov ah, [si]       ; Save the digit to AH.

    ; Save the digit to the right place in HEX_OUT string.
    mov bx, HEX_OUT ; Put the address of the HEX_OUT string to BX.
    add bx, cx      ; Add the current index to it.
    mov [bx], ah    ; Save the digit from AH to the right place.

    ; Decrement the current index.
    dec cx

    ; Shift the source value to 4 bits = 1 hex digit.
    shr dx, 4

    jmp print_hex_loop

print_hex_end:
    ; Print the string formed in HEX_OUT.
    mov si, HEX_OUT
    call print_string

    popa ; Restore all registers from the stack.
    ret

; The null-terminated hex string to print.
HEX_OUT: 
    db "0x0000",0
; The constant list of the hex digits.
HEX_DIGITS: 
    db "0123456789ABCDEF"



;
; print_string prints a null-terminated string starting with the address from SI.
;
print_string:
    pusha ; Save all registers on the stack.

print_string_loop:
    mov al, [si]        ; Put the current byte (character) from the source string to AL.
    cmp al, 0           ; Keep looping until the byte is not 0.
    je print_string_end

    mov ah, 0x0e ; Indicate scrolling tele-type BIOS routine.
    int 0x10     ; Call BIOS interrupt and print the character from AL on the screen.

    inc si ; Increment the pointer to the current byte in the string.

    jmp print_string_loop

print_string_end:
    popa ; Restore all registers from the stack.
    ret



;
; println prints a CRLF newline.
;
println:
    pusha ; Save all registers on the stack.

    ; Print CR (0x0d) using scrolling tele-type BIOS routine.
    mov ax, 0x0e0d 
    int 0x10

    ; Print LF (0x0a) using scrolling tele-type BIOS routine.
    mov ax, 0x0e0a
    int 0x10

    popa ; Restore all registers from the stack.
    ret

