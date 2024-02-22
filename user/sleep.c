#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

/* the time is in tick a notion of time specified bu the xv6 kernel */
int 
main(int argc, char *argv[]) {
  if (argc)
    sleep(atoi(argv[1]));
  exit(0);
}
