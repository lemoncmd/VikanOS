bits 64
section .text

extern kernel_main_stack
extern KernelMainNewStack

global KernelMain
KernelMain:
  mov rsp, kernel_main_stack + 1024 * 1024
  call KernelMainNewStack
.fin:
  hlt
  jmp .fin
