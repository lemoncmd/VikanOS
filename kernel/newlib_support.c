#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

void _exit(void) {
  while (1) __asm__("hlt");
}

caddr_t sbrk(int incr) {
  errno = ENOMEM;
  return (caddr_t)-1;
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

ssize_t write(int fd, const void* buf, ssize_t count) {
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
