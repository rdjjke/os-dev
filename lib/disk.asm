;
; disk_load loads DH sectors to ES:BX from drive DL.
;
disk_load:
    pusha

    push dx ; Store DX on the stack so later we can recall
            ; how many sectors were read.

    mov ah, 0x02 ; Indicate the read sector BIOS routine.
    
    ; Setup the BIOS routine arguments.
    mov al, dh   ; Read DH sectors.
    mov ch, 0x00 ; Select cyllinder 0.
    mov dh, 0x00 ; Select head 0.
    mov cl, 0x02 ; Start reading from the second sector (i.e. 
                 ; after the boot sector).
    
    int 0x13 ; BIOS interrupt.

    mov si, DISK_ERROR_MSG
    jc disk_error ; Jump if error (i.e. carry flag set).

    pop dx
    cmp dh, al     ; If AL (sectors read) != DH (sectors expected)
    mov si, NOT_ENOUGH_SECTORS_MSG
    jne disk_error ; display an error message.

    popa
    ret

disk_error:
    call print_string
    call println

    jmp $ ; Hang forever.

DISK_ERROR_MSG:
    db "Disk read error!", 0

NOT_ENOUGH_SECTORS_MSG:
    db "Not enough sectors were read!", 0

