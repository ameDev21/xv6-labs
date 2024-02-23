#include "kernel/types.h"
#include "user/user.h"

/* time is computed in tick (notion of time of the xv6 kernel) */
int 
main(int argc, char *argv[]) {
char *echoargv[] = { "echo", "no", "argument", "given", 0 };
  if (argc >= 2)
    sleep(atoi(argv[1]));
  else 
    exec("echo", echoargv);
  exit(0);
}
