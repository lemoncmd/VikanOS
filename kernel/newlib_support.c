#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

void _exit(void) {
  while (1) __asm__("hlt");
}

caddr_t program_break, program_break_end;

caddr_t sbrk(int incr) {
  if (program_break == 0 || program_break + incr >= program_break_end) {
    errno = ENOMEM;
    return (caddr_t)-1;
  }

  caddr_t prev_break = program_break;
  program_break += incr;
  return prev_break;
}

int close(int fd) {
  errno = EBADF;
  return -1;
}

off_t lseek(int fd, off_t offset, int whence) {
  errno = EBADF;
  return -1;
}

ssize_t read(int fd, void* buf, size_t count) {
  errno = EBADF;
  return -1;
}

void* main_console_ = 0;
void (*main_console_handler_)();
void register_console_print_handler(void* console, void (*handler)()) {
  main_console_ = console;
  main_console_handler_ = handler;
}

ssize_t write(int fd, const void* buf, ssize_t count) {
  if (fd == 1 && main_console_ != 0) {
    main_console_handler_(main_console_, buf);
    return count;
  }
  errno = EBADF;
  return -1;
}

int fstat(int fd, struct stat* buf) {
  errno = EBADF;
  return -1;
}

int isatty(int fd) {
  errno = EBADF;
  return -1;
}
