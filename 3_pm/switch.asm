;
; A simple boot sector program that demonstrates reading from the disk.
;

; Tell the assembler where this code should be loaded.
; BIOS will load our boot sector to this address.
[org 0x7c00]

; Setup the stack.
mov bp, 0x9000 ; Set the base of the stack a little above where BIOS 
mov sp, bp     ; loads our boot sector - so it won't overwrite us.

; Print something from Real Mode.
mov si, REAL_MODE_MSG
call print_string
call println

call switch_to_pm ; We never return from here.

jmp $ ; Jump forever.

%include "../lib/print.asm"         ; Include our print subroutines.
%include "../lib/gdt.asm"           ; Include our GDT.
%include "../lib/print_pm.asm"      ; Include our 32-bit print subroutines.
%include "../lib/switch_to_pm.asm"  ; Include our switching subroutines.

[bits 32]

; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:
    mov esi, PROT_MODE_MSG
    call print_string_pm

    jmp $

; Global variables.
REAL_MODE_MSG:
    db "Hello from 16-bit Real Mode!",0
PROT_MODE_MSG:
    db "Hello from 32-bit Protected Mode!",0


times 510-($-$$) db 0 ; Pad the boot sector out with zeroes.

dw 0xaa55 ; Put the magic number to the last two words,
          ; so BIOS knows we are a boot sector.

