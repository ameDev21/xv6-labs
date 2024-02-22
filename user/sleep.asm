
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

/* the time is in tick a notion of time specified bu the xv6 kernel */
int 
main(int argc, char *argv[]) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (argc)
   8:	e511                	bnez	a0,14 <main+0x14>
    sleep(atoi(argv[1]));
  exit(0);
   a:	4501                	li	a0,0
   c:	00000097          	auipc	ra,0x0
  10:	288080e7          	jalr	648(ra) # 294 <exit>
    sleep(atoi(argv[1]));
  14:	6588                	ld	a0,8(a1)
  16:	00000097          	auipc	ra,0x0
  1a:	184080e7          	jalr	388(ra) # 19a <atoi>
  1e:	00000097          	auipc	ra,0x0
  22:	306080e7          	jalr	774(ra) # 324 <sleep>
  26:	b7d5                	j	a <main+0xa>

0000000000000028 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  28:	1141                	addi	sp,sp,-16
  2a:	e422                	sd	s0,8(sp)
  2c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2e:	87aa                	mv	a5,a0
  30:	0585                	addi	a1,a1,1
  32:	0785                	addi	a5,a5,1
  34:	fff5c703          	lbu	a4,-1(a1)
  38:	fee78fa3          	sb	a4,-1(a5)
  3c:	fb75                	bnez	a4,30 <strcpy+0x8>
    ;
  return os;
}
  3e:	6422                	ld	s0,8(sp)
  40:	0141                	addi	sp,sp,16
  42:	8082                	ret

0000000000000044 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4a:	00054783          	lbu	a5,0(a0)
  4e:	cb91                	beqz	a5,62 <strcmp+0x1e>
  50:	0005c703          	lbu	a4,0(a1)
  54:	00f71763          	bne	a4,a5,62 <strcmp+0x1e>
    p++, q++;
  58:	0505                	addi	a0,a0,1
  5a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	fbe5                	bnez	a5,50 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  62:	0005c503          	lbu	a0,0(a1)
}
  66:	40a7853b          	subw	a0,a5,a0
  6a:	6422                	ld	s0,8(sp)
  6c:	0141                	addi	sp,sp,16
  6e:	8082                	ret

0000000000000070 <strlen>:

uint
strlen(const char *s)
{
  70:	1141                	addi	sp,sp,-16
  72:	e422                	sd	s0,8(sp)
  74:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  76:	00054783          	lbu	a5,0(a0)
  7a:	cf91                	beqz	a5,96 <strlen+0x26>
  7c:	0505                	addi	a0,a0,1
  7e:	87aa                	mv	a5,a0
  80:	86be                	mv	a3,a5
  82:	0785                	addi	a5,a5,1
  84:	fff7c703          	lbu	a4,-1(a5)
  88:	ff65                	bnez	a4,80 <strlen+0x10>
  8a:	40a6853b          	subw	a0,a3,a0
  8e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  90:	6422                	ld	s0,8(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret
  for(n = 0; s[n]; n++)
  96:	4501                	li	a0,0
  98:	bfe5                	j	90 <strlen+0x20>

000000000000009a <memset>:

void*
memset(void *dst, int c, uint n)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a0:	ca19                	beqz	a2,b6 <memset+0x1c>
  a2:	87aa                	mv	a5,a0
  a4:	1602                	slli	a2,a2,0x20
  a6:	9201                	srli	a2,a2,0x20
  a8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b0:	0785                	addi	a5,a5,1
  b2:	fee79de3          	bne	a5,a4,ac <memset+0x12>
  }
  return dst;
}
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strchr>:

char*
strchr(const char *s, char c)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	cb99                	beqz	a5,dc <strchr+0x20>
    if(*s == c)
  c8:	00f58763          	beq	a1,a5,d6 <strchr+0x1a>
  for(; *s; s++)
  cc:	0505                	addi	a0,a0,1
  ce:	00054783          	lbu	a5,0(a0)
  d2:	fbfd                	bnez	a5,c8 <strchr+0xc>
      return (char*)s;
  return 0;
  d4:	4501                	li	a0,0
}
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret
  return 0;
  dc:	4501                	li	a0,0
  de:	bfe5                	j	d6 <strchr+0x1a>

00000000000000e0 <gets>:

char*
gets(char *buf, int max)
{
  e0:	711d                	addi	sp,sp,-96
  e2:	ec86                	sd	ra,88(sp)
  e4:	e8a2                	sd	s0,80(sp)
  e6:	e4a6                	sd	s1,72(sp)
  e8:	e0ca                	sd	s2,64(sp)
  ea:	fc4e                	sd	s3,56(sp)
  ec:	f852                	sd	s4,48(sp)
  ee:	f456                	sd	s5,40(sp)
  f0:	f05a                	sd	s6,32(sp)
  f2:	ec5e                	sd	s7,24(sp)
  f4:	1080                	addi	s0,sp,96
  f6:	8baa                	mv	s7,a0
  f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fa:	892a                	mv	s2,a0
  fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  fe:	4aa9                	li	s5,10
 100:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 102:	89a6                	mv	s3,s1
 104:	2485                	addiw	s1,s1,1
 106:	0344d863          	bge	s1,s4,136 <gets+0x56>
    cc = read(0, &c, 1);
 10a:	4605                	li	a2,1
 10c:	faf40593          	addi	a1,s0,-81
 110:	4501                	li	a0,0
 112:	00000097          	auipc	ra,0x0
 116:	19a080e7          	jalr	410(ra) # 2ac <read>
    if(cc < 1)
 11a:	00a05e63          	blez	a0,136 <gets+0x56>
    buf[i++] = c;
 11e:	faf44783          	lbu	a5,-81(s0)
 122:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 126:	01578763          	beq	a5,s5,134 <gets+0x54>
 12a:	0905                	addi	s2,s2,1
 12c:	fd679be3          	bne	a5,s6,102 <gets+0x22>
  for(i=0; i+1 < max; ){
 130:	89a6                	mv	s3,s1
 132:	a011                	j	136 <gets+0x56>
 134:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 136:	99de                	add	s3,s3,s7
 138:	00098023          	sb	zero,0(s3)
  return buf;
}
 13c:	855e                	mv	a0,s7
 13e:	60e6                	ld	ra,88(sp)
 140:	6446                	ld	s0,80(sp)
 142:	64a6                	ld	s1,72(sp)
 144:	6906                	ld	s2,64(sp)
 146:	79e2                	ld	s3,56(sp)
 148:	7a42                	ld	s4,48(sp)
 14a:	7aa2                	ld	s5,40(sp)
 14c:	7b02                	ld	s6,32(sp)
 14e:	6be2                	ld	s7,24(sp)
 150:	6125                	addi	sp,sp,96
 152:	8082                	ret

0000000000000154 <stat>:

int
stat(const char *n, struct stat *st)
{
 154:	1101                	addi	sp,sp,-32
 156:	ec06                	sd	ra,24(sp)
 158:	e822                	sd	s0,16(sp)
 15a:	e426                	sd	s1,8(sp)
 15c:	e04a                	sd	s2,0(sp)
 15e:	1000                	addi	s0,sp,32
 160:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 162:	4581                	li	a1,0
 164:	00000097          	auipc	ra,0x0
 168:	170080e7          	jalr	368(ra) # 2d4 <open>
  if(fd < 0)
 16c:	02054563          	bltz	a0,196 <stat+0x42>
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	00000097          	auipc	ra,0x0
 178:	178080e7          	jalr	376(ra) # 2ec <fstat>
 17c:	892a                	mv	s2,a0
  close(fd);
 17e:	8526                	mv	a0,s1
 180:	00000097          	auipc	ra,0x0
 184:	13c080e7          	jalr	316(ra) # 2bc <close>
  return r;
}
 188:	854a                	mv	a0,s2
 18a:	60e2                	ld	ra,24(sp)
 18c:	6442                	ld	s0,16(sp)
 18e:	64a2                	ld	s1,8(sp)
 190:	6902                	ld	s2,0(sp)
 192:	6105                	addi	sp,sp,32
 194:	8082                	ret
    return -1;
 196:	597d                	li	s2,-1
 198:	bfc5                	j	188 <stat+0x34>

000000000000019a <atoi>:

int
atoi(const char *s)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e422                	sd	s0,8(sp)
 19e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a0:	00054683          	lbu	a3,0(a0)
 1a4:	fd06879b          	addiw	a5,a3,-48
 1a8:	0ff7f793          	zext.b	a5,a5
 1ac:	4625                	li	a2,9
 1ae:	02f66863          	bltu	a2,a5,1de <atoi+0x44>
 1b2:	872a                	mv	a4,a0
  n = 0;
 1b4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1b6:	0705                	addi	a4,a4,1
 1b8:	0025179b          	slliw	a5,a0,0x2
 1bc:	9fa9                	addw	a5,a5,a0
 1be:	0017979b          	slliw	a5,a5,0x1
 1c2:	9fb5                	addw	a5,a5,a3
 1c4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c8:	00074683          	lbu	a3,0(a4)
 1cc:	fd06879b          	addiw	a5,a3,-48
 1d0:	0ff7f793          	zext.b	a5,a5
 1d4:	fef671e3          	bgeu	a2,a5,1b6 <atoi+0x1c>
  return n;
}
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret
  n = 0;
 1de:	4501                	li	a0,0
 1e0:	bfe5                	j	1d8 <atoi+0x3e>

00000000000001e2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e8:	02b57463          	bgeu	a0,a1,210 <memmove+0x2e>
    while(n-- > 0)
 1ec:	00c05f63          	blez	a2,20a <memmove+0x28>
 1f0:	1602                	slli	a2,a2,0x20
 1f2:	9201                	srli	a2,a2,0x20
 1f4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f8:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fa:	0585                	addi	a1,a1,1
 1fc:	0705                	addi	a4,a4,1
 1fe:	fff5c683          	lbu	a3,-1(a1)
 202:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 206:	fee79ae3          	bne	a5,a4,1fa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret
    dst += n;
 210:	00c50733          	add	a4,a0,a2
    src += n;
 214:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 216:	fec05ae3          	blez	a2,20a <memmove+0x28>
 21a:	fff6079b          	addiw	a5,a2,-1
 21e:	1782                	slli	a5,a5,0x20
 220:	9381                	srli	a5,a5,0x20
 222:	fff7c793          	not	a5,a5
 226:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 228:	15fd                	addi	a1,a1,-1
 22a:	177d                	addi	a4,a4,-1
 22c:	0005c683          	lbu	a3,0(a1)
 230:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 234:	fee79ae3          	bne	a5,a4,228 <memmove+0x46>
 238:	bfc9                	j	20a <memmove+0x28>

000000000000023a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 240:	ca05                	beqz	a2,270 <memcmp+0x36>
 242:	fff6069b          	addiw	a3,a2,-1
 246:	1682                	slli	a3,a3,0x20
 248:	9281                	srli	a3,a3,0x20
 24a:	0685                	addi	a3,a3,1
 24c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 24e:	00054783          	lbu	a5,0(a0)
 252:	0005c703          	lbu	a4,0(a1)
 256:	00e79863          	bne	a5,a4,266 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25a:	0505                	addi	a0,a0,1
    p2++;
 25c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 25e:	fed518e3          	bne	a0,a3,24e <memcmp+0x14>
  }
  return 0;
 262:	4501                	li	a0,0
 264:	a019                	j	26a <memcmp+0x30>
      return *p1 - *p2;
 266:	40e7853b          	subw	a0,a5,a4
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
  return 0;
 270:	4501                	li	a0,0
 272:	bfe5                	j	26a <memcmp+0x30>

0000000000000274 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 274:	1141                	addi	sp,sp,-16
 276:	e406                	sd	ra,8(sp)
 278:	e022                	sd	s0,0(sp)
 27a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 27c:	00000097          	auipc	ra,0x0
 280:	f66080e7          	jalr	-154(ra) # 1e2 <memmove>
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret

000000000000028c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 28c:	4885                	li	a7,1
 ecall
 28e:	00000073          	ecall
 ret
 292:	8082                	ret

0000000000000294 <exit>:
.global exit
exit:
 li a7, SYS_exit
 294:	4889                	li	a7,2
 ecall
 296:	00000073          	ecall
 ret
 29a:	8082                	ret

000000000000029c <wait>:
.global wait
wait:
 li a7, SYS_wait
 29c:	488d                	li	a7,3
 ecall
 29e:	00000073          	ecall
 ret
 2a2:	8082                	ret

00000000000002a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2a4:	4891                	li	a7,4
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <read>:
.global read
read:
 li a7, SYS_read
 2ac:	4895                	li	a7,5
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <write>:
.global write
write:
 li a7, SYS_write
 2b4:	48c1                	li	a7,16
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <close>:
.global close
close:
 li a7, SYS_close
 2bc:	48d5                	li	a7,21
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2c4:	4899                	li	a7,6
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 2cc:	489d                	li	a7,7
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <open>:
.global open
open:
 li a7, SYS_open
 2d4:	48bd                	li	a7,15
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2dc:	48c5                	li	a7,17
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2e4:	48c9                	li	a7,18
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2ec:	48a1                	li	a7,8
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <link>:
.global link
link:
 li a7, SYS_link
 2f4:	48cd                	li	a7,19
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2fc:	48d1                	li	a7,20
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 304:	48a5                	li	a7,9
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <dup>:
.global dup
dup:
 li a7, SYS_dup
 30c:	48a9                	li	a7,10
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 314:	48ad                	li	a7,11
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 31c:	48b1                	li	a7,12
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 324:	48b5                	li	a7,13
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 32c:	48b9                	li	a7,14
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 334:	1101                	addi	sp,sp,-32
 336:	ec06                	sd	ra,24(sp)
 338:	e822                	sd	s0,16(sp)
 33a:	1000                	addi	s0,sp,32
 33c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 340:	4605                	li	a2,1
 342:	fef40593          	addi	a1,s0,-17
 346:	00000097          	auipc	ra,0x0
 34a:	f6e080e7          	jalr	-146(ra) # 2b4 <write>
}
 34e:	60e2                	ld	ra,24(sp)
 350:	6442                	ld	s0,16(sp)
 352:	6105                	addi	sp,sp,32
 354:	8082                	ret

0000000000000356 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 356:	7139                	addi	sp,sp,-64
 358:	fc06                	sd	ra,56(sp)
 35a:	f822                	sd	s0,48(sp)
 35c:	f426                	sd	s1,40(sp)
 35e:	f04a                	sd	s2,32(sp)
 360:	ec4e                	sd	s3,24(sp)
 362:	0080                	addi	s0,sp,64
 364:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 366:	c299                	beqz	a3,36c <printint+0x16>
 368:	0805c963          	bltz	a1,3fa <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 36c:	2581                	sext.w	a1,a1
  neg = 0;
 36e:	4881                	li	a7,0
 370:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 374:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 376:	2601                	sext.w	a2,a2
 378:	00000517          	auipc	a0,0x0
 37c:	48850513          	addi	a0,a0,1160 # 800 <digits>
 380:	883a                	mv	a6,a4
 382:	2705                	addiw	a4,a4,1
 384:	02c5f7bb          	remuw	a5,a1,a2
 388:	1782                	slli	a5,a5,0x20
 38a:	9381                	srli	a5,a5,0x20
 38c:	97aa                	add	a5,a5,a0
 38e:	0007c783          	lbu	a5,0(a5)
 392:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 396:	0005879b          	sext.w	a5,a1
 39a:	02c5d5bb          	divuw	a1,a1,a2
 39e:	0685                	addi	a3,a3,1
 3a0:	fec7f0e3          	bgeu	a5,a2,380 <printint+0x2a>
  if(neg)
 3a4:	00088c63          	beqz	a7,3bc <printint+0x66>
    buf[i++] = '-';
 3a8:	fd070793          	addi	a5,a4,-48
 3ac:	00878733          	add	a4,a5,s0
 3b0:	02d00793          	li	a5,45
 3b4:	fef70823          	sb	a5,-16(a4)
 3b8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3bc:	02e05863          	blez	a4,3ec <printint+0x96>
 3c0:	fc040793          	addi	a5,s0,-64
 3c4:	00e78933          	add	s2,a5,a4
 3c8:	fff78993          	addi	s3,a5,-1
 3cc:	99ba                	add	s3,s3,a4
 3ce:	377d                	addiw	a4,a4,-1
 3d0:	1702                	slli	a4,a4,0x20
 3d2:	9301                	srli	a4,a4,0x20
 3d4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3d8:	fff94583          	lbu	a1,-1(s2)
 3dc:	8526                	mv	a0,s1
 3de:	00000097          	auipc	ra,0x0
 3e2:	f56080e7          	jalr	-170(ra) # 334 <putc>
  while(--i >= 0)
 3e6:	197d                	addi	s2,s2,-1
 3e8:	ff3918e3          	bne	s2,s3,3d8 <printint+0x82>
}
 3ec:	70e2                	ld	ra,56(sp)
 3ee:	7442                	ld	s0,48(sp)
 3f0:	74a2                	ld	s1,40(sp)
 3f2:	7902                	ld	s2,32(sp)
 3f4:	69e2                	ld	s3,24(sp)
 3f6:	6121                	addi	sp,sp,64
 3f8:	8082                	ret
    x = -xx;
 3fa:	40b005bb          	negw	a1,a1
    neg = 1;
 3fe:	4885                	li	a7,1
    x = -xx;
 400:	bf85                	j	370 <printint+0x1a>

0000000000000402 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 402:	715d                	addi	sp,sp,-80
 404:	e486                	sd	ra,72(sp)
 406:	e0a2                	sd	s0,64(sp)
 408:	fc26                	sd	s1,56(sp)
 40a:	f84a                	sd	s2,48(sp)
 40c:	f44e                	sd	s3,40(sp)
 40e:	f052                	sd	s4,32(sp)
 410:	ec56                	sd	s5,24(sp)
 412:	e85a                	sd	s6,16(sp)
 414:	e45e                	sd	s7,8(sp)
 416:	e062                	sd	s8,0(sp)
 418:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 41a:	0005c903          	lbu	s2,0(a1)
 41e:	18090c63          	beqz	s2,5b6 <vprintf+0x1b4>
 422:	8aaa                	mv	s5,a0
 424:	8bb2                	mv	s7,a2
 426:	00158493          	addi	s1,a1,1
  state = 0;
 42a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 42c:	02500a13          	li	s4,37
 430:	4b55                	li	s6,21
 432:	a839                	j	450 <vprintf+0x4e>
        putc(fd, c);
 434:	85ca                	mv	a1,s2
 436:	8556                	mv	a0,s5
 438:	00000097          	auipc	ra,0x0
 43c:	efc080e7          	jalr	-260(ra) # 334 <putc>
 440:	a019                	j	446 <vprintf+0x44>
    } else if(state == '%'){
 442:	01498d63          	beq	s3,s4,45c <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 446:	0485                	addi	s1,s1,1
 448:	fff4c903          	lbu	s2,-1(s1)
 44c:	16090563          	beqz	s2,5b6 <vprintf+0x1b4>
    if(state == 0){
 450:	fe0999e3          	bnez	s3,442 <vprintf+0x40>
      if(c == '%'){
 454:	ff4910e3          	bne	s2,s4,434 <vprintf+0x32>
        state = '%';
 458:	89d2                	mv	s3,s4
 45a:	b7f5                	j	446 <vprintf+0x44>
      if(c == 'd'){
 45c:	13490263          	beq	s2,s4,580 <vprintf+0x17e>
 460:	f9d9079b          	addiw	a5,s2,-99
 464:	0ff7f793          	zext.b	a5,a5
 468:	12fb6563          	bltu	s6,a5,592 <vprintf+0x190>
 46c:	f9d9079b          	addiw	a5,s2,-99
 470:	0ff7f713          	zext.b	a4,a5
 474:	10eb6f63          	bltu	s6,a4,592 <vprintf+0x190>
 478:	00271793          	slli	a5,a4,0x2
 47c:	00000717          	auipc	a4,0x0
 480:	32c70713          	addi	a4,a4,812 # 7a8 <malloc+0xf4>
 484:	97ba                	add	a5,a5,a4
 486:	439c                	lw	a5,0(a5)
 488:	97ba                	add	a5,a5,a4
 48a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 48c:	008b8913          	addi	s2,s7,8
 490:	4685                	li	a3,1
 492:	4629                	li	a2,10
 494:	000ba583          	lw	a1,0(s7)
 498:	8556                	mv	a0,s5
 49a:	00000097          	auipc	ra,0x0
 49e:	ebc080e7          	jalr	-324(ra) # 356 <printint>
 4a2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4a4:	4981                	li	s3,0
 4a6:	b745                	j	446 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4a8:	008b8913          	addi	s2,s7,8
 4ac:	4681                	li	a3,0
 4ae:	4629                	li	a2,10
 4b0:	000ba583          	lw	a1,0(s7)
 4b4:	8556                	mv	a0,s5
 4b6:	00000097          	auipc	ra,0x0
 4ba:	ea0080e7          	jalr	-352(ra) # 356 <printint>
 4be:	8bca                	mv	s7,s2
      state = 0;
 4c0:	4981                	li	s3,0
 4c2:	b751                	j	446 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 4c4:	008b8913          	addi	s2,s7,8
 4c8:	4681                	li	a3,0
 4ca:	4641                	li	a2,16
 4cc:	000ba583          	lw	a1,0(s7)
 4d0:	8556                	mv	a0,s5
 4d2:	00000097          	auipc	ra,0x0
 4d6:	e84080e7          	jalr	-380(ra) # 356 <printint>
 4da:	8bca                	mv	s7,s2
      state = 0;
 4dc:	4981                	li	s3,0
 4de:	b7a5                	j	446 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 4e0:	008b8c13          	addi	s8,s7,8
 4e4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 4e8:	03000593          	li	a1,48
 4ec:	8556                	mv	a0,s5
 4ee:	00000097          	auipc	ra,0x0
 4f2:	e46080e7          	jalr	-442(ra) # 334 <putc>
  putc(fd, 'x');
 4f6:	07800593          	li	a1,120
 4fa:	8556                	mv	a0,s5
 4fc:	00000097          	auipc	ra,0x0
 500:	e38080e7          	jalr	-456(ra) # 334 <putc>
 504:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 506:	00000b97          	auipc	s7,0x0
 50a:	2fab8b93          	addi	s7,s7,762 # 800 <digits>
 50e:	03c9d793          	srli	a5,s3,0x3c
 512:	97de                	add	a5,a5,s7
 514:	0007c583          	lbu	a1,0(a5)
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	e1a080e7          	jalr	-486(ra) # 334 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 522:	0992                	slli	s3,s3,0x4
 524:	397d                	addiw	s2,s2,-1
 526:	fe0914e3          	bnez	s2,50e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 52a:	8be2                	mv	s7,s8
      state = 0;
 52c:	4981                	li	s3,0
 52e:	bf21                	j	446 <vprintf+0x44>
        s = va_arg(ap, char*);
 530:	008b8993          	addi	s3,s7,8
 534:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 538:	02090163          	beqz	s2,55a <vprintf+0x158>
        while(*s != 0){
 53c:	00094583          	lbu	a1,0(s2)
 540:	c9a5                	beqz	a1,5b0 <vprintf+0x1ae>
          putc(fd, *s);
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	df0080e7          	jalr	-528(ra) # 334 <putc>
          s++;
 54c:	0905                	addi	s2,s2,1
        while(*s != 0){
 54e:	00094583          	lbu	a1,0(s2)
 552:	f9e5                	bnez	a1,542 <vprintf+0x140>
        s = va_arg(ap, char*);
 554:	8bce                	mv	s7,s3
      state = 0;
 556:	4981                	li	s3,0
 558:	b5fd                	j	446 <vprintf+0x44>
          s = "(null)";
 55a:	00000917          	auipc	s2,0x0
 55e:	24690913          	addi	s2,s2,582 # 7a0 <malloc+0xec>
        while(*s != 0){
 562:	02800593          	li	a1,40
 566:	bff1                	j	542 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 568:	008b8913          	addi	s2,s7,8
 56c:	000bc583          	lbu	a1,0(s7)
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	dc2080e7          	jalr	-574(ra) # 334 <putc>
 57a:	8bca                	mv	s7,s2
      state = 0;
 57c:	4981                	li	s3,0
 57e:	b5e1                	j	446 <vprintf+0x44>
        putc(fd, c);
 580:	02500593          	li	a1,37
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	dae080e7          	jalr	-594(ra) # 334 <putc>
      state = 0;
 58e:	4981                	li	s3,0
 590:	bd5d                	j	446 <vprintf+0x44>
        putc(fd, '%');
 592:	02500593          	li	a1,37
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	d9c080e7          	jalr	-612(ra) # 334 <putc>
        putc(fd, c);
 5a0:	85ca                	mv	a1,s2
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	d90080e7          	jalr	-624(ra) # 334 <putc>
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	bd61                	j	446 <vprintf+0x44>
        s = va_arg(ap, char*);
 5b0:	8bce                	mv	s7,s3
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	bd49                	j	446 <vprintf+0x44>
    }
  }
}
 5b6:	60a6                	ld	ra,72(sp)
 5b8:	6406                	ld	s0,64(sp)
 5ba:	74e2                	ld	s1,56(sp)
 5bc:	7942                	ld	s2,48(sp)
 5be:	79a2                	ld	s3,40(sp)
 5c0:	7a02                	ld	s4,32(sp)
 5c2:	6ae2                	ld	s5,24(sp)
 5c4:	6b42                	ld	s6,16(sp)
 5c6:	6ba2                	ld	s7,8(sp)
 5c8:	6c02                	ld	s8,0(sp)
 5ca:	6161                	addi	sp,sp,80
 5cc:	8082                	ret

00000000000005ce <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5ce:	715d                	addi	sp,sp,-80
 5d0:	ec06                	sd	ra,24(sp)
 5d2:	e822                	sd	s0,16(sp)
 5d4:	1000                	addi	s0,sp,32
 5d6:	e010                	sd	a2,0(s0)
 5d8:	e414                	sd	a3,8(s0)
 5da:	e818                	sd	a4,16(s0)
 5dc:	ec1c                	sd	a5,24(s0)
 5de:	03043023          	sd	a6,32(s0)
 5e2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5e6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5ea:	8622                	mv	a2,s0
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e16080e7          	jalr	-490(ra) # 402 <vprintf>
}
 5f4:	60e2                	ld	ra,24(sp)
 5f6:	6442                	ld	s0,16(sp)
 5f8:	6161                	addi	sp,sp,80
 5fa:	8082                	ret

00000000000005fc <printf>:

void
printf(const char *fmt, ...)
{
 5fc:	711d                	addi	sp,sp,-96
 5fe:	ec06                	sd	ra,24(sp)
 600:	e822                	sd	s0,16(sp)
 602:	1000                	addi	s0,sp,32
 604:	e40c                	sd	a1,8(s0)
 606:	e810                	sd	a2,16(s0)
 608:	ec14                	sd	a3,24(s0)
 60a:	f018                	sd	a4,32(s0)
 60c:	f41c                	sd	a5,40(s0)
 60e:	03043823          	sd	a6,48(s0)
 612:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 616:	00840613          	addi	a2,s0,8
 61a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 61e:	85aa                	mv	a1,a0
 620:	4505                	li	a0,1
 622:	00000097          	auipc	ra,0x0
 626:	de0080e7          	jalr	-544(ra) # 402 <vprintf>
}
 62a:	60e2                	ld	ra,24(sp)
 62c:	6442                	ld	s0,16(sp)
 62e:	6125                	addi	sp,sp,96
 630:	8082                	ret

0000000000000632 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 632:	1141                	addi	sp,sp,-16
 634:	e422                	sd	s0,8(sp)
 636:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 638:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63c:	00000797          	auipc	a5,0x0
 640:	1dc7b783          	ld	a5,476(a5) # 818 <freep>
 644:	a02d                	j	66e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 646:	4618                	lw	a4,8(a2)
 648:	9f2d                	addw	a4,a4,a1
 64a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 64e:	6398                	ld	a4,0(a5)
 650:	6310                	ld	a2,0(a4)
 652:	a83d                	j	690 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 654:	ff852703          	lw	a4,-8(a0)
 658:	9f31                	addw	a4,a4,a2
 65a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 65c:	ff053683          	ld	a3,-16(a0)
 660:	a091                	j	6a4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 662:	6398                	ld	a4,0(a5)
 664:	00e7e463          	bltu	a5,a4,66c <free+0x3a>
 668:	00e6ea63          	bltu	a3,a4,67c <free+0x4a>
{
 66c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66e:	fed7fae3          	bgeu	a5,a3,662 <free+0x30>
 672:	6398                	ld	a4,0(a5)
 674:	00e6e463          	bltu	a3,a4,67c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 678:	fee7eae3          	bltu	a5,a4,66c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 67c:	ff852583          	lw	a1,-8(a0)
 680:	6390                	ld	a2,0(a5)
 682:	02059813          	slli	a6,a1,0x20
 686:	01c85713          	srli	a4,a6,0x1c
 68a:	9736                	add	a4,a4,a3
 68c:	fae60de3          	beq	a2,a4,646 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 690:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 694:	4790                	lw	a2,8(a5)
 696:	02061593          	slli	a1,a2,0x20
 69a:	01c5d713          	srli	a4,a1,0x1c
 69e:	973e                	add	a4,a4,a5
 6a0:	fae68ae3          	beq	a3,a4,654 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6a4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6a6:	00000717          	auipc	a4,0x0
 6aa:	16f73923          	sd	a5,370(a4) # 818 <freep>
}
 6ae:	6422                	ld	s0,8(sp)
 6b0:	0141                	addi	sp,sp,16
 6b2:	8082                	ret

00000000000006b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b4:	7139                	addi	sp,sp,-64
 6b6:	fc06                	sd	ra,56(sp)
 6b8:	f822                	sd	s0,48(sp)
 6ba:	f426                	sd	s1,40(sp)
 6bc:	f04a                	sd	s2,32(sp)
 6be:	ec4e                	sd	s3,24(sp)
 6c0:	e852                	sd	s4,16(sp)
 6c2:	e456                	sd	s5,8(sp)
 6c4:	e05a                	sd	s6,0(sp)
 6c6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c8:	02051493          	slli	s1,a0,0x20
 6cc:	9081                	srli	s1,s1,0x20
 6ce:	04bd                	addi	s1,s1,15
 6d0:	8091                	srli	s1,s1,0x4
 6d2:	0014899b          	addiw	s3,s1,1
 6d6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6d8:	00000517          	auipc	a0,0x0
 6dc:	14053503          	ld	a0,320(a0) # 818 <freep>
 6e0:	c515                	beqz	a0,70c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6e4:	4798                	lw	a4,8(a5)
 6e6:	02977f63          	bgeu	a4,s1,724 <malloc+0x70>
  if(nu < 4096)
 6ea:	8a4e                	mv	s4,s3
 6ec:	0009871b          	sext.w	a4,s3
 6f0:	6685                	lui	a3,0x1
 6f2:	00d77363          	bgeu	a4,a3,6f8 <malloc+0x44>
 6f6:	6a05                	lui	s4,0x1
 6f8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6fc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 700:	00000917          	auipc	s2,0x0
 704:	11890913          	addi	s2,s2,280 # 818 <freep>
  if(p == (char*)-1)
 708:	5afd                	li	s5,-1
 70a:	a895                	j	77e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 70c:	00000797          	auipc	a5,0x0
 710:	11478793          	addi	a5,a5,276 # 820 <base>
 714:	00000717          	auipc	a4,0x0
 718:	10f73223          	sd	a5,260(a4) # 818 <freep>
 71c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 71e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 722:	b7e1                	j	6ea <malloc+0x36>
      if(p->s.size == nunits)
 724:	02e48c63          	beq	s1,a4,75c <malloc+0xa8>
        p->s.size -= nunits;
 728:	4137073b          	subw	a4,a4,s3
 72c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 72e:	02071693          	slli	a3,a4,0x20
 732:	01c6d713          	srli	a4,a3,0x1c
 736:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 738:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 73c:	00000717          	auipc	a4,0x0
 740:	0ca73e23          	sd	a0,220(a4) # 818 <freep>
      return (void*)(p + 1);
 744:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 748:	70e2                	ld	ra,56(sp)
 74a:	7442                	ld	s0,48(sp)
 74c:	74a2                	ld	s1,40(sp)
 74e:	7902                	ld	s2,32(sp)
 750:	69e2                	ld	s3,24(sp)
 752:	6a42                	ld	s4,16(sp)
 754:	6aa2                	ld	s5,8(sp)
 756:	6b02                	ld	s6,0(sp)
 758:	6121                	addi	sp,sp,64
 75a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 75c:	6398                	ld	a4,0(a5)
 75e:	e118                	sd	a4,0(a0)
 760:	bff1                	j	73c <malloc+0x88>
  hp->s.size = nu;
 762:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 766:	0541                	addi	a0,a0,16
 768:	00000097          	auipc	ra,0x0
 76c:	eca080e7          	jalr	-310(ra) # 632 <free>
  return freep;
 770:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 774:	d971                	beqz	a0,748 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 776:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 778:	4798                	lw	a4,8(a5)
 77a:	fa9775e3          	bgeu	a4,s1,724 <malloc+0x70>
    if(p == freep)
 77e:	00093703          	ld	a4,0(s2)
 782:	853e                	mv	a0,a5
 784:	fef719e3          	bne	a4,a5,776 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 788:	8552                	mv	a0,s4
 78a:	00000097          	auipc	ra,0x0
 78e:	b92080e7          	jalr	-1134(ra) # 31c <sbrk>
  if(p == (char*)-1)
 792:	fd5518e3          	bne	a0,s5,762 <malloc+0xae>
        return 0;
 796:	4501                	li	a0,0
 798:	bf45                	j	748 <malloc+0x94>
