#include <sys/types.h>
void register_console_print_handler(void* console, void (*handler)());
extern caddr_t program_break, program_break_end;
