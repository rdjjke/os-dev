[bits 16]
; switch_to_pm switches CPU to protected mode.
switch_to_pm:
    ; Turn off interrupts until we have set up 
    ; the protected mode interrupt vector.
    cli

    ; Load our Global Descriptor Table, which defines
    ; the protected mode segments (e.g. for code and data).
    lgdt [gdt_descriptor] 
                          
    ; To make the switch we set the first bit of CR0.
    mov eax, cr0     
    or eax, 0x1  
    mov cr0, eax

    ; Make a far jump to our new 32-bit code segment.
    ; This also forces the CPU to flush its cache of pre-fetched
    ; and real-mode decoded instructions, which can cause problems.
    jmp CODE_SEG:init_pm

[bits 32]
init_pm:
    ; Point our segment registers to the data selector.
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Updata our stack position so it is right
    ; at the top of the free space.
    mov ebp, 0x90000 
    mov esp, ebp

    call BEGIN_PM

