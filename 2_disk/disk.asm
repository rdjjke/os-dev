;
; A simple boot sector program that demonstrates reading from the disk.
;

; Tell the assembler where this code should be loaded.
; BIOS will load our boot sector to this address.
[org 0x7c00]

; BIOS stores our boot drive in DL, so remember this for later.
mov [BOOT_DRIVE], dl

; Setup the stack.
mov bp, 0x8000 ; Set the base of the stack a little above where BIOS 
mov sp, bp     ; loads our boot sector - so it won't overwrite us.

; Print the 1st line of the start message.
mov si, START_MSG_L1
call print_string
call println

; Print the 2st line of the start message.
mov si, START_MSG_L2
call print_string
call println

; Print the 3rd line of the start message.
mov si, START_MSG_L3
call print_string
call println

; Load 5 sectors to 0x0000(ES):0x:9000(BX) from the boot disk.
mov bx, 0x9000
mov dh, 5
mov dl, [BOOT_DRIVE]
call disk_load

; Print out the first loaded word, which we expect to be 0xdada,
; stored at address 0x9000.
mov dx, [0x9000]
call print_hex
call println

; Also, print the first word from the 2nd loaded sector: should be 0xface.
mov dx, [0x9000 + 512]
call print_hex
call println

jmp $ ; Jump forever.

%include "../lib/print.asm" ; Include our print subroutines.
%include "../lib/disk.asm"  ; Include our disk i/0 subroutines.

; Global variables.
BOOT_DRIVE: db 0
START_MSG_L1:
    db "We are going to read some sectors from the disk",0
START_MSG_L2:
    db "the 2nd sector consists of the repeated word 0xDADA,",0
START_MSG_L3:
    db "and the 3rd one consists of 0xFACE.",0

times 510-($-$$) db 0 ; Pad the boot sector out with zeroes.

dw 0xaa55 ; Put the magic number to the last two words,
          ; so BIOS knows we are a boot sector.

; We know that BIOS will load only the first 512 - byte sector from the disk,
; so if we purposely add a few more sectors to our code by repeating some
; familiar numbers, we can prove to ourselfs that we actually loaded those
; additional two sectors from the disk we booted from.
times 256 dw 0xdada
times 256 dw 0xface

