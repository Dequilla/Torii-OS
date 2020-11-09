# Loader for Torii OS

# Setup magic variables 
.set MAGIC,  0x1badb002
.set FLAGS, (1<<0 | 1<<1)
.set CHECKSUM, -(MAGIC + FLAGS)

# Make it recognizable to bootloaders
.section .multiboot
    .long MAGIC
    .long FLAGS
    .long CHECKSUM

.section .text
.extern torii_main
.extern init_ctors
.global loader

loader:
    # Set the stack pointer (defined at end)
    mov $kernel_stack, %esp

    # Initialize CPP constructors
    call init_ctors

    push %eax
    push %ebx
    call torii_main

# Just to ensure we don't exit
_stop:
    cli
    hlt
    jmp _stop

.section .bss
.space 2*1024*1024 # 2MiB of space for the stack (pushes backward towards start)
kernel_stack: # Pointer where the stack resides
