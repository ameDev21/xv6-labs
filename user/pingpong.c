#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int 
main(int argc, char *argv[]) {
  int p[2];
  char byte[1];
  pipe(p);
  if (fork() == 0) {
    read(p[0], byte, sizeof(byte));
    printf("%d: received ping\n", (int)getpid());
    write(p[1], "1", sizeof(char));
  } else {
    write(p[1], "1", sizeof(char));
    read(p[0], byte, sizeof(byte));
    printf("%d: received pong\n", (int)getpid());
  }
  exit(0);
}
