#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

void
find(char *path, char *fname)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf("ls: cannot stat %s\n", buf);
        continue;
      }
      if (st.type == 1 && strcmp(p, ".") && strcmp(p, "..")) {
        find(buf, fname);
      } else {
        if (!strcmp(de.name, fname)) {
          /* printf("%s\n", buf); */
          // Determine the size of the buffer
          int buf_size = sizeof(buf) - 1; // Subtract 1 to exclude the null terminator
          buf[sizeof(buf) - 2] = '\n';

          // Write the contents of the buffer to stdout
          write(1, buf, buf_size);
        }
      }
    }
    break;
  }
  close(fd);
}

int
main(int argc, char *argv[]) {
  int i;

  /* close(1); */
  /* int fd = open("output.txt", 1); */
  /* close(0); */
  /* dup(fd); */
  /* dup(fd[0]); */
  for (int i = 1; i < argc; ++i) {
    find(".", argv[i]);
  }
  exit(0);
}
