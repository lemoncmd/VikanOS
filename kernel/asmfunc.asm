bits 64
section .text

global LoadGDT  ; void LoadGDT(uint16_t limit, uint64_t offset)
LoadGDT:
  push rbp
  mov rbp, rsp
  sub rsp, 10
  mov [rsp], di
  mov [rsp + 2], rsi
  lgdt [rsp]
  mov rsp, rbp
  pop rbp
  ret

global SetCSSS  ; void SetCSSS(uint16_t cs, uint16_t ss)
SetCSSS:
  push rbp
  mov rbp, rsp
  mov ss, si
  mov rax, .next
  push rdi
  push rax
  o64 retf
.next:
  mov rsp, rbp
  pop rbp
  ret

global SetDSAll  ; void SetDSAll(uint16_t value)
SetDSAll:
  mov ds, di
  mov es, di
  mov fs, di
  mov gs, di
  ret

global SetCR3  ; void SetCR3(uint64_t value)
SetCR3:
  mov cr3, rdi
  ret

extern kernel_main_stack
extern KernelMainNewStack

global KernelMain
KernelMain:
  mov rsp, kernel_main_stack + 1024 * 1024
  call KernelMainNewStack
.fin:
  hlt
  jmp .fin
