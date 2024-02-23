#include "kernel/types.h"
/* #include "kernel/stat.h" */
#include "user/user.h"
#include <unistd.h>

/* the time is computed in tick (notion of time of the xv6 kernel) */
int 
main(int argc, char *argv[]) {
  uint8 p[2];
  uint8* byte;
  pipe(p);
  if (fork() == 0) {
    read(0, byte, 1);
  } else {
  }
  exit(0);
}
