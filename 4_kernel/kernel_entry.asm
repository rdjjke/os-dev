; Ensures that we jump straight into the kernel's entry function.
[bits 32]
[extern main] ; Declate that we will be referencing the external symbol 'main',
              ; so the linker can substitute the final address.

call main ; Invoke main() in our C kernel.

jmp $ ; Hung forever.

