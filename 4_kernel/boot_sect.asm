;
; A boot sector that boots a C kernel in 32 - bit protected mode;
;

; Tell the assembler where this code should be loaded.
; BIOS will load our boot sector to this address.
[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; The memory offset to which we will load our kernel.

; Setup the stack.
mov bp, 0x9000 ; Set the base of the stack a little above where BIOS 
mov sp, bp     ; loads our boot sector - so it won't overwrite us.

; Print a message from real mode.
mov si, MSG_REAL_MODE
call print_string
call println

call load_kernel ; Load our kernel into the disk.

call switch_to_pm ; We never return from here.

jmp $ ; Jump forever.

%include "../lib/print.asm"         ; Include our print subroutines.
%include "../lib/disk.asm"          ; Include our disk i/o subroutines.
%include "../lib/gdt.asm"           ; Include our GDT.
%include "../lib/print_pm.asm"      ; Include our 32-bit print subroutines.
%include "../lib/switch_to_pm.asm"  ; Include our switching subroutines.

[bits 16]

load_kernel:
    mov si, MSG_LOAD_KERNEL
    call print_string
    call println

    mov bx, KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load

    ret

[bits 32]

; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:
    mov esi, MSG_PROT_MODE
    call print_string_pm

    call KERNEL_OFFSET

    jmp $ ; Hang forever.

; Global variables.
BOOT_DRIVE:
    db 0
MSG_REAL_MODE:
    db "Started in 16-bit Real Mode.",0
MSG_LOAD_KERNEL:
    db "Loading kernel into memory.",0
MSG_PROT_MODE:
    db "Successfully landed in 32-bit Protected Mode.",0

times 510-($-$$) db 0 ; Pad the boot sector out with zeroes.

dw 0xaa55 ; Put the magic number to the last two words,
          ; so BIOS knows we are a boot sector.

