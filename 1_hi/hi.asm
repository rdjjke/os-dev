;
; A simple boot sector program that demonstrates printing on the screen.
;

; Tell the assembler where this code should be loaded.
; BIOS will load our boot sector to this address.
[org 0x7c00]

; Setup the stack.
mov bp, 0x9000 ; Set the base of the stack a little above where BIOS 
mov sp, bp     ; loads our boot sector - so it won't overwrite us.

; Print a greeting message.
mov si, HELLO_MSG
call print_string
call println

; Print a hex value.
mov si, SOME_HEX_MSG
call print_string
mov dx, 0xa0f9
call print_hex
call println

; Print a farewell message.
mov si, GOODBYE_MSG
call print_string

jmp $ ; Jump forever.

%include "../lib/print.asm" ; Include our print subroutines.

HELLO_MSG:
    db "Hello, World!",0

SOME_HEX_MSG:
    db "Here is some hex value: ",0

GOODBYE_MSG:
    db "Goodbye!",0

times 510-($-$$) db 0 ; Pad the boot sector out with zeroes.

dw 0xaa55 ; Put the magic number to the last two words,
          ; so BIOS knows we are a boot sector.

