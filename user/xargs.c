#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"

#define MAXBUF 100

void xargs(char* cmd_p[], int argc, char line_p[MAXARG][MAXBUF], int l_argc) {
  char* merged[argc+l_argc];
  int j = 0;
  for (int i = 1; i < argc; ++i) {
    merged[j] = cmd_p[i];
    ++j;
  }
  j = 0;
  for (int i = argc - 1; j < l_argc; ++i) {
    merged[i] = line_p[j];
    j++;
  }
  merged[l_argc+argc - 1] = 0;
  if (fork() == 0) {
    exec(merged[0], merged);
  } else {
    wait(0);
  }
}

int
main(int argc, char *argv[])
{
  char l_argv[MAXARG][MAXBUF];
  char ch;
  int i = 0;
  int j = 0;
  while (read(0, &ch, 1)) {
    if (ch == '\n') {
      ++i;
      xargs(argv, argc, l_argv, i);
      i = 0;
      j = 0;
      memset(l_argv, 0, MAXARG * sizeof(char*));
    } else if (ch == ' ') {
      ++i;
      j = 0;
    } else {
      l_argv[i][j++] = ch;
    }
  }
  exit(0);
}
