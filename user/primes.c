#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

/* Some hints: */
/*  */
/* Be careful to close file descriptors that a process doesn't need, because otherwise your program will run xv6 out of resources before the first process reaches 35. */
/* Once the first process reaches 35, it should wait until the entire pipeline terminates, including all children, grandchildren, &c. 
 * Thus the main primes process should only exit after all the output has been printed, and after all the other primes processes have exited. */
/* Hint: read returns zero when the write-side of a pipe is closed. */
/* You should create the processes in the pipeline only as they are needed. */
/* It's simplest to directly write 32-bit (4-byte) ints to the pipes, rather than using formatted ASCII I/O. */
/* TA(s): think about use functions */

void new_proc(int left[2]) {
  int right[2];
  pipe(right); // creating its own 
  int prime;
  close(left[1]);;
  int n;
  uint8 has_forked = 0;
  read(left[0], &prime, sizeof(int)); // reading the sieve's prime
  printf("prime %d\n", prime);
  while (read(left[0], &n, sizeof(int))) {
    if (n % prime) { // does not divide
      write(right[1], &n, sizeof(int));
      if (!has_forked && fork() == 0)
        new_proc(right);
      else
       has_forked = 1;
    }
  }
  close(right[1]);
  wait(0);
  exit(1);
}

int
main(int argc, char *argv[]) {
  int p[2];
  pipe(p);
  int val;
  for(int n = 2; n < 36; ++n) {
    write(p[1], &n, sizeof(int)); // could also be size = 4 or something smaller like uint8;
  }
  /* while (read(p[0], &val, sizeof(int))) { */
  /*   printf("%d\n", val); */
  /* } */
  if (fork() == 0) // generating the first sieve
    new_proc(p);
  close(p[1]);
  wait(0);
  /* close(p[0]); */  
  exit(1);
}
