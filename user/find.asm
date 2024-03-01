
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
   6:	87aa                	mv	a5,a0
   8:	0585                	addi	a1,a1,1
   a:	0785                	addi	a5,a5,1
   c:	fff5c703          	lbu	a4,-1(a1)
  10:	fee78fa3          	sb	a4,-1(a5)
  14:	fb75                	bnez	a4,8 <strcpy+0x8>
    ;
  return os;
}
  16:	6422                	ld	s0,8(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret

000000000000001c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  1c:	1141                	addi	sp,sp,-16
  1e:	e422                	sd	s0,8(sp)
  20:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  22:	00054783          	lbu	a5,0(a0)
  26:	cb91                	beqz	a5,3a <strcmp+0x1e>
  28:	0005c703          	lbu	a4,0(a1)
  2c:	00f71763          	bne	a4,a5,3a <strcmp+0x1e>
    p++, q++;
  30:	0505                	addi	a0,a0,1
  32:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  34:	00054783          	lbu	a5,0(a0)
  38:	fbe5                	bnez	a5,28 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  3a:	0005c503          	lbu	a0,0(a1)
}
  3e:	40a7853b          	subw	a0,a5,a0
  42:	6422                	ld	s0,8(sp)
  44:	0141                	addi	sp,sp,16
  46:	8082                	ret

0000000000000048 <strlen>:

uint
strlen(const char *s)
{
  48:	1141                	addi	sp,sp,-16
  4a:	e422                	sd	s0,8(sp)
  4c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  4e:	00054783          	lbu	a5,0(a0)
  52:	cf91                	beqz	a5,6e <strlen+0x26>
  54:	0505                	addi	a0,a0,1
  56:	87aa                	mv	a5,a0
  58:	86be                	mv	a3,a5
  5a:	0785                	addi	a5,a5,1
  5c:	fff7c703          	lbu	a4,-1(a5)
  60:	ff65                	bnez	a4,58 <strlen+0x10>
  62:	40a6853b          	subw	a0,a3,a0
  66:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  68:	6422                	ld	s0,8(sp)
  6a:	0141                	addi	sp,sp,16
  6c:	8082                	ret
  for(n = 0; s[n]; n++)
  6e:	4501                	li	a0,0
  70:	bfe5                	j	68 <strlen+0x20>

0000000000000072 <memset>:

void*
memset(void *dst, int c, uint n)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  78:	ca19                	beqz	a2,8e <memset+0x1c>
  7a:	87aa                	mv	a5,a0
  7c:	1602                	slli	a2,a2,0x20
  7e:	9201                	srli	a2,a2,0x20
  80:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  84:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  88:	0785                	addi	a5,a5,1
  8a:	fee79de3          	bne	a5,a4,84 <memset+0x12>
  }
  return dst;
}
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strchr>:

char*
strchr(const char *s, char c)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  for(; *s; s++)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb99                	beqz	a5,b4 <strchr+0x20>
    if(*s == c)
  a0:	00f58763          	beq	a1,a5,ae <strchr+0x1a>
  for(; *s; s++)
  a4:	0505                	addi	a0,a0,1
  a6:	00054783          	lbu	a5,0(a0)
  aa:	fbfd                	bnez	a5,a0 <strchr+0xc>
      return (char*)s;
  return 0;
  ac:	4501                	li	a0,0
}
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret
  return 0;
  b4:	4501                	li	a0,0
  b6:	bfe5                	j	ae <strchr+0x1a>

00000000000000b8 <gets>:

char*
gets(char *buf, int max)
{
  b8:	711d                	addi	sp,sp,-96
  ba:	ec86                	sd	ra,88(sp)
  bc:	e8a2                	sd	s0,80(sp)
  be:	e4a6                	sd	s1,72(sp)
  c0:	e0ca                	sd	s2,64(sp)
  c2:	fc4e                	sd	s3,56(sp)
  c4:	f852                	sd	s4,48(sp)
  c6:	f456                	sd	s5,40(sp)
  c8:	f05a                	sd	s6,32(sp)
  ca:	ec5e                	sd	s7,24(sp)
  cc:	1080                	addi	s0,sp,96
  ce:	8baa                	mv	s7,a0
  d0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  d2:	892a                	mv	s2,a0
  d4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  d6:	4aa9                	li	s5,10
  d8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  da:	89a6                	mv	s3,s1
  dc:	2485                	addiw	s1,s1,1
  de:	0344d863          	bge	s1,s4,10e <gets+0x56>
    cc = read(0, &c, 1);
  e2:	4605                	li	a2,1
  e4:	faf40593          	addi	a1,s0,-81
  e8:	4501                	li	a0,0
  ea:	00000097          	auipc	ra,0x0
  ee:	19a080e7          	jalr	410(ra) # 284 <read>
    if(cc < 1)
  f2:	00a05e63          	blez	a0,10e <gets+0x56>
    buf[i++] = c;
  f6:	faf44783          	lbu	a5,-81(s0)
  fa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
  fe:	01578763          	beq	a5,s5,10c <gets+0x54>
 102:	0905                	addi	s2,s2,1
 104:	fd679be3          	bne	a5,s6,da <gets+0x22>
  for(i=0; i+1 < max; ){
 108:	89a6                	mv	s3,s1
 10a:	a011                	j	10e <gets+0x56>
 10c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 10e:	99de                	add	s3,s3,s7
 110:	00098023          	sb	zero,0(s3)
  return buf;
}
 114:	855e                	mv	a0,s7
 116:	60e6                	ld	ra,88(sp)
 118:	6446                	ld	s0,80(sp)
 11a:	64a6                	ld	s1,72(sp)
 11c:	6906                	ld	s2,64(sp)
 11e:	79e2                	ld	s3,56(sp)
 120:	7a42                	ld	s4,48(sp)
 122:	7aa2                	ld	s5,40(sp)
 124:	7b02                	ld	s6,32(sp)
 126:	6be2                	ld	s7,24(sp)
 128:	6125                	addi	sp,sp,96
 12a:	8082                	ret

000000000000012c <stat>:

int
stat(const char *n, struct stat *st)
{
 12c:	1101                	addi	sp,sp,-32
 12e:	ec06                	sd	ra,24(sp)
 130:	e822                	sd	s0,16(sp)
 132:	e426                	sd	s1,8(sp)
 134:	e04a                	sd	s2,0(sp)
 136:	1000                	addi	s0,sp,32
 138:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 13a:	4581                	li	a1,0
 13c:	00000097          	auipc	ra,0x0
 140:	170080e7          	jalr	368(ra) # 2ac <open>
  if(fd < 0)
 144:	02054563          	bltz	a0,16e <stat+0x42>
 148:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 14a:	85ca                	mv	a1,s2
 14c:	00000097          	auipc	ra,0x0
 150:	178080e7          	jalr	376(ra) # 2c4 <fstat>
 154:	892a                	mv	s2,a0
  close(fd);
 156:	8526                	mv	a0,s1
 158:	00000097          	auipc	ra,0x0
 15c:	13c080e7          	jalr	316(ra) # 294 <close>
  return r;
}
 160:	854a                	mv	a0,s2
 162:	60e2                	ld	ra,24(sp)
 164:	6442                	ld	s0,16(sp)
 166:	64a2                	ld	s1,8(sp)
 168:	6902                	ld	s2,0(sp)
 16a:	6105                	addi	sp,sp,32
 16c:	8082                	ret
    return -1;
 16e:	597d                	li	s2,-1
 170:	bfc5                	j	160 <stat+0x34>

0000000000000172 <atoi>:

int
atoi(const char *s)
{
 172:	1141                	addi	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 178:	00054683          	lbu	a3,0(a0)
 17c:	fd06879b          	addiw	a5,a3,-48
 180:	0ff7f793          	zext.b	a5,a5
 184:	4625                	li	a2,9
 186:	02f66863          	bltu	a2,a5,1b6 <atoi+0x44>
 18a:	872a                	mv	a4,a0
  n = 0;
 18c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 18e:	0705                	addi	a4,a4,1
 190:	0025179b          	slliw	a5,a0,0x2
 194:	9fa9                	addw	a5,a5,a0
 196:	0017979b          	slliw	a5,a5,0x1
 19a:	9fb5                	addw	a5,a5,a3
 19c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1a0:	00074683          	lbu	a3,0(a4)
 1a4:	fd06879b          	addiw	a5,a3,-48
 1a8:	0ff7f793          	zext.b	a5,a5
 1ac:	fef671e3          	bgeu	a2,a5,18e <atoi+0x1c>
  return n;
}
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret
  n = 0;
 1b6:	4501                	li	a0,0
 1b8:	bfe5                	j	1b0 <atoi+0x3e>

00000000000001ba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1c0:	02b57463          	bgeu	a0,a1,1e8 <memmove+0x2e>
    while(n-- > 0)
 1c4:	00c05f63          	blez	a2,1e2 <memmove+0x28>
 1c8:	1602                	slli	a2,a2,0x20
 1ca:	9201                	srli	a2,a2,0x20
 1cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1d2:	0585                	addi	a1,a1,1
 1d4:	0705                	addi	a4,a4,1
 1d6:	fff5c683          	lbu	a3,-1(a1)
 1da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1de:	fee79ae3          	bne	a5,a4,1d2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
    dst += n;
 1e8:	00c50733          	add	a4,a0,a2
    src += n;
 1ec:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 1ee:	fec05ae3          	blez	a2,1e2 <memmove+0x28>
 1f2:	fff6079b          	addiw	a5,a2,-1
 1f6:	1782                	slli	a5,a5,0x20
 1f8:	9381                	srli	a5,a5,0x20
 1fa:	fff7c793          	not	a5,a5
 1fe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 200:	15fd                	addi	a1,a1,-1
 202:	177d                	addi	a4,a4,-1
 204:	0005c683          	lbu	a3,0(a1)
 208:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 20c:	fee79ae3          	bne	a5,a4,200 <memmove+0x46>
 210:	bfc9                	j	1e2 <memmove+0x28>

0000000000000212 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 218:	ca05                	beqz	a2,248 <memcmp+0x36>
 21a:	fff6069b          	addiw	a3,a2,-1
 21e:	1682                	slli	a3,a3,0x20
 220:	9281                	srli	a3,a3,0x20
 222:	0685                	addi	a3,a3,1
 224:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 226:	00054783          	lbu	a5,0(a0)
 22a:	0005c703          	lbu	a4,0(a1)
 22e:	00e79863          	bne	a5,a4,23e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 232:	0505                	addi	a0,a0,1
    p2++;
 234:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 236:	fed518e3          	bne	a0,a3,226 <memcmp+0x14>
  }
  return 0;
 23a:	4501                	li	a0,0
 23c:	a019                	j	242 <memcmp+0x30>
      return *p1 - *p2;
 23e:	40e7853b          	subw	a0,a5,a4
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
  return 0;
 248:	4501                	li	a0,0
 24a:	bfe5                	j	242 <memcmp+0x30>

000000000000024c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 254:	00000097          	auipc	ra,0x0
 258:	f66080e7          	jalr	-154(ra) # 1ba <memmove>
}
 25c:	60a2                	ld	ra,8(sp)
 25e:	6402                	ld	s0,0(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret

0000000000000264 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 264:	4885                	li	a7,1
 ecall
 266:	00000073          	ecall
 ret
 26a:	8082                	ret

000000000000026c <exit>:
.global exit
exit:
 li a7, SYS_exit
 26c:	4889                	li	a7,2
 ecall
 26e:	00000073          	ecall
 ret
 272:	8082                	ret

0000000000000274 <wait>:
.global wait
wait:
 li a7, SYS_wait
 274:	488d                	li	a7,3
 ecall
 276:	00000073          	ecall
 ret
 27a:	8082                	ret

000000000000027c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 27c:	4891                	li	a7,4
 ecall
 27e:	00000073          	ecall
 ret
 282:	8082                	ret

0000000000000284 <read>:
.global read
read:
 li a7, SYS_read
 284:	4895                	li	a7,5
 ecall
 286:	00000073          	ecall
 ret
 28a:	8082                	ret

000000000000028c <write>:
.global write
write:
 li a7, SYS_write
 28c:	48c1                	li	a7,16
 ecall
 28e:	00000073          	ecall
 ret
 292:	8082                	ret

0000000000000294 <close>:
.global close
close:
 li a7, SYS_close
 294:	48d5                	li	a7,21
 ecall
 296:	00000073          	ecall
 ret
 29a:	8082                	ret

000000000000029c <kill>:
.global kill
kill:
 li a7, SYS_kill
 29c:	4899                	li	a7,6
 ecall
 29e:	00000073          	ecall
 ret
 2a2:	8082                	ret

00000000000002a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2a4:	489d                	li	a7,7
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <open>:
.global open
open:
 li a7, SYS_open
 2ac:	48bd                	li	a7,15
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2b4:	48c5                	li	a7,17
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2bc:	48c9                	li	a7,18
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2c4:	48a1                	li	a7,8
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <link>:
.global link
link:
 li a7, SYS_link
 2cc:	48cd                	li	a7,19
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2d4:	48d1                	li	a7,20
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2dc:	48a5                	li	a7,9
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2e4:	48a9                	li	a7,10
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2ec:	48ad                	li	a7,11
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2f4:	48b1                	li	a7,12
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2fc:	48b5                	li	a7,13
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 304:	48b9                	li	a7,14
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 30c:	1101                	addi	sp,sp,-32
 30e:	ec06                	sd	ra,24(sp)
 310:	e822                	sd	s0,16(sp)
 312:	1000                	addi	s0,sp,32
 314:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 318:	4605                	li	a2,1
 31a:	fef40593          	addi	a1,s0,-17
 31e:	00000097          	auipc	ra,0x0
 322:	f6e080e7          	jalr	-146(ra) # 28c <write>
}
 326:	60e2                	ld	ra,24(sp)
 328:	6442                	ld	s0,16(sp)
 32a:	6105                	addi	sp,sp,32
 32c:	8082                	ret

000000000000032e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 32e:	7139                	addi	sp,sp,-64
 330:	fc06                	sd	ra,56(sp)
 332:	f822                	sd	s0,48(sp)
 334:	f426                	sd	s1,40(sp)
 336:	f04a                	sd	s2,32(sp)
 338:	ec4e                	sd	s3,24(sp)
 33a:	0080                	addi	s0,sp,64
 33c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 33e:	c299                	beqz	a3,344 <printint+0x16>
 340:	0805c963          	bltz	a1,3d2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 344:	2581                	sext.w	a1,a1
  neg = 0;
 346:	4881                	li	a7,0
 348:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 34c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 34e:	2601                	sext.w	a2,a2
 350:	00000517          	auipc	a0,0x0
 354:	48850513          	addi	a0,a0,1160 # 7d8 <digits>
 358:	883a                	mv	a6,a4
 35a:	2705                	addiw	a4,a4,1
 35c:	02c5f7bb          	remuw	a5,a1,a2
 360:	1782                	slli	a5,a5,0x20
 362:	9381                	srli	a5,a5,0x20
 364:	97aa                	add	a5,a5,a0
 366:	0007c783          	lbu	a5,0(a5)
 36a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 36e:	0005879b          	sext.w	a5,a1
 372:	02c5d5bb          	divuw	a1,a1,a2
 376:	0685                	addi	a3,a3,1
 378:	fec7f0e3          	bgeu	a5,a2,358 <printint+0x2a>
  if(neg)
 37c:	00088c63          	beqz	a7,394 <printint+0x66>
    buf[i++] = '-';
 380:	fd070793          	addi	a5,a4,-48
 384:	00878733          	add	a4,a5,s0
 388:	02d00793          	li	a5,45
 38c:	fef70823          	sb	a5,-16(a4)
 390:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 394:	02e05863          	blez	a4,3c4 <printint+0x96>
 398:	fc040793          	addi	a5,s0,-64
 39c:	00e78933          	add	s2,a5,a4
 3a0:	fff78993          	addi	s3,a5,-1
 3a4:	99ba                	add	s3,s3,a4
 3a6:	377d                	addiw	a4,a4,-1
 3a8:	1702                	slli	a4,a4,0x20
 3aa:	9301                	srli	a4,a4,0x20
 3ac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3b0:	fff94583          	lbu	a1,-1(s2)
 3b4:	8526                	mv	a0,s1
 3b6:	00000097          	auipc	ra,0x0
 3ba:	f56080e7          	jalr	-170(ra) # 30c <putc>
  while(--i >= 0)
 3be:	197d                	addi	s2,s2,-1
 3c0:	ff3918e3          	bne	s2,s3,3b0 <printint+0x82>
}
 3c4:	70e2                	ld	ra,56(sp)
 3c6:	7442                	ld	s0,48(sp)
 3c8:	74a2                	ld	s1,40(sp)
 3ca:	7902                	ld	s2,32(sp)
 3cc:	69e2                	ld	s3,24(sp)
 3ce:	6121                	addi	sp,sp,64
 3d0:	8082                	ret
    x = -xx;
 3d2:	40b005bb          	negw	a1,a1
    neg = 1;
 3d6:	4885                	li	a7,1
    x = -xx;
 3d8:	bf85                	j	348 <printint+0x1a>

00000000000003da <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3da:	715d                	addi	sp,sp,-80
 3dc:	e486                	sd	ra,72(sp)
 3de:	e0a2                	sd	s0,64(sp)
 3e0:	fc26                	sd	s1,56(sp)
 3e2:	f84a                	sd	s2,48(sp)
 3e4:	f44e                	sd	s3,40(sp)
 3e6:	f052                	sd	s4,32(sp)
 3e8:	ec56                	sd	s5,24(sp)
 3ea:	e85a                	sd	s6,16(sp)
 3ec:	e45e                	sd	s7,8(sp)
 3ee:	e062                	sd	s8,0(sp)
 3f0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3f2:	0005c903          	lbu	s2,0(a1)
 3f6:	18090c63          	beqz	s2,58e <vprintf+0x1b4>
 3fa:	8aaa                	mv	s5,a0
 3fc:	8bb2                	mv	s7,a2
 3fe:	00158493          	addi	s1,a1,1
  state = 0;
 402:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 404:	02500a13          	li	s4,37
 408:	4b55                	li	s6,21
 40a:	a839                	j	428 <vprintf+0x4e>
        putc(fd, c);
 40c:	85ca                	mv	a1,s2
 40e:	8556                	mv	a0,s5
 410:	00000097          	auipc	ra,0x0
 414:	efc080e7          	jalr	-260(ra) # 30c <putc>
 418:	a019                	j	41e <vprintf+0x44>
    } else if(state == '%'){
 41a:	01498d63          	beq	s3,s4,434 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 41e:	0485                	addi	s1,s1,1
 420:	fff4c903          	lbu	s2,-1(s1)
 424:	16090563          	beqz	s2,58e <vprintf+0x1b4>
    if(state == 0){
 428:	fe0999e3          	bnez	s3,41a <vprintf+0x40>
      if(c == '%'){
 42c:	ff4910e3          	bne	s2,s4,40c <vprintf+0x32>
        state = '%';
 430:	89d2                	mv	s3,s4
 432:	b7f5                	j	41e <vprintf+0x44>
      if(c == 'd'){
 434:	13490263          	beq	s2,s4,558 <vprintf+0x17e>
 438:	f9d9079b          	addiw	a5,s2,-99
 43c:	0ff7f793          	zext.b	a5,a5
 440:	12fb6563          	bltu	s6,a5,56a <vprintf+0x190>
 444:	f9d9079b          	addiw	a5,s2,-99
 448:	0ff7f713          	zext.b	a4,a5
 44c:	10eb6f63          	bltu	s6,a4,56a <vprintf+0x190>
 450:	00271793          	slli	a5,a4,0x2
 454:	00000717          	auipc	a4,0x0
 458:	32c70713          	addi	a4,a4,812 # 780 <malloc+0xf4>
 45c:	97ba                	add	a5,a5,a4
 45e:	439c                	lw	a5,0(a5)
 460:	97ba                	add	a5,a5,a4
 462:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 464:	008b8913          	addi	s2,s7,8
 468:	4685                	li	a3,1
 46a:	4629                	li	a2,10
 46c:	000ba583          	lw	a1,0(s7)
 470:	8556                	mv	a0,s5
 472:	00000097          	auipc	ra,0x0
 476:	ebc080e7          	jalr	-324(ra) # 32e <printint>
 47a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 47c:	4981                	li	s3,0
 47e:	b745                	j	41e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 480:	008b8913          	addi	s2,s7,8
 484:	4681                	li	a3,0
 486:	4629                	li	a2,10
 488:	000ba583          	lw	a1,0(s7)
 48c:	8556                	mv	a0,s5
 48e:	00000097          	auipc	ra,0x0
 492:	ea0080e7          	jalr	-352(ra) # 32e <printint>
 496:	8bca                	mv	s7,s2
      state = 0;
 498:	4981                	li	s3,0
 49a:	b751                	j	41e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 49c:	008b8913          	addi	s2,s7,8
 4a0:	4681                	li	a3,0
 4a2:	4641                	li	a2,16
 4a4:	000ba583          	lw	a1,0(s7)
 4a8:	8556                	mv	a0,s5
 4aa:	00000097          	auipc	ra,0x0
 4ae:	e84080e7          	jalr	-380(ra) # 32e <printint>
 4b2:	8bca                	mv	s7,s2
      state = 0;
 4b4:	4981                	li	s3,0
 4b6:	b7a5                	j	41e <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 4b8:	008b8c13          	addi	s8,s7,8
 4bc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 4c0:	03000593          	li	a1,48
 4c4:	8556                	mv	a0,s5
 4c6:	00000097          	auipc	ra,0x0
 4ca:	e46080e7          	jalr	-442(ra) # 30c <putc>
  putc(fd, 'x');
 4ce:	07800593          	li	a1,120
 4d2:	8556                	mv	a0,s5
 4d4:	00000097          	auipc	ra,0x0
 4d8:	e38080e7          	jalr	-456(ra) # 30c <putc>
 4dc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4de:	00000b97          	auipc	s7,0x0
 4e2:	2fab8b93          	addi	s7,s7,762 # 7d8 <digits>
 4e6:	03c9d793          	srli	a5,s3,0x3c
 4ea:	97de                	add	a5,a5,s7
 4ec:	0007c583          	lbu	a1,0(a5)
 4f0:	8556                	mv	a0,s5
 4f2:	00000097          	auipc	ra,0x0
 4f6:	e1a080e7          	jalr	-486(ra) # 30c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 4fa:	0992                	slli	s3,s3,0x4
 4fc:	397d                	addiw	s2,s2,-1
 4fe:	fe0914e3          	bnez	s2,4e6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 502:	8be2                	mv	s7,s8
      state = 0;
 504:	4981                	li	s3,0
 506:	bf21                	j	41e <vprintf+0x44>
        s = va_arg(ap, char*);
 508:	008b8993          	addi	s3,s7,8
 50c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 510:	02090163          	beqz	s2,532 <vprintf+0x158>
        while(*s != 0){
 514:	00094583          	lbu	a1,0(s2)
 518:	c9a5                	beqz	a1,588 <vprintf+0x1ae>
          putc(fd, *s);
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	df0080e7          	jalr	-528(ra) # 30c <putc>
          s++;
 524:	0905                	addi	s2,s2,1
        while(*s != 0){
 526:	00094583          	lbu	a1,0(s2)
 52a:	f9e5                	bnez	a1,51a <vprintf+0x140>
        s = va_arg(ap, char*);
 52c:	8bce                	mv	s7,s3
      state = 0;
 52e:	4981                	li	s3,0
 530:	b5fd                	j	41e <vprintf+0x44>
          s = "(null)";
 532:	00000917          	auipc	s2,0x0
 536:	24690913          	addi	s2,s2,582 # 778 <malloc+0xec>
        while(*s != 0){
 53a:	02800593          	li	a1,40
 53e:	bff1                	j	51a <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 540:	008b8913          	addi	s2,s7,8
 544:	000bc583          	lbu	a1,0(s7)
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	dc2080e7          	jalr	-574(ra) # 30c <putc>
 552:	8bca                	mv	s7,s2
      state = 0;
 554:	4981                	li	s3,0
 556:	b5e1                	j	41e <vprintf+0x44>
        putc(fd, c);
 558:	02500593          	li	a1,37
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	dae080e7          	jalr	-594(ra) # 30c <putc>
      state = 0;
 566:	4981                	li	s3,0
 568:	bd5d                	j	41e <vprintf+0x44>
        putc(fd, '%');
 56a:	02500593          	li	a1,37
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	d9c080e7          	jalr	-612(ra) # 30c <putc>
        putc(fd, c);
 578:	85ca                	mv	a1,s2
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	d90080e7          	jalr	-624(ra) # 30c <putc>
      state = 0;
 584:	4981                	li	s3,0
 586:	bd61                	j	41e <vprintf+0x44>
        s = va_arg(ap, char*);
 588:	8bce                	mv	s7,s3
      state = 0;
 58a:	4981                	li	s3,0
 58c:	bd49                	j	41e <vprintf+0x44>
    }
  }
}
 58e:	60a6                	ld	ra,72(sp)
 590:	6406                	ld	s0,64(sp)
 592:	74e2                	ld	s1,56(sp)
 594:	7942                	ld	s2,48(sp)
 596:	79a2                	ld	s3,40(sp)
 598:	7a02                	ld	s4,32(sp)
 59a:	6ae2                	ld	s5,24(sp)
 59c:	6b42                	ld	s6,16(sp)
 59e:	6ba2                	ld	s7,8(sp)
 5a0:	6c02                	ld	s8,0(sp)
 5a2:	6161                	addi	sp,sp,80
 5a4:	8082                	ret

00000000000005a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5a6:	715d                	addi	sp,sp,-80
 5a8:	ec06                	sd	ra,24(sp)
 5aa:	e822                	sd	s0,16(sp)
 5ac:	1000                	addi	s0,sp,32
 5ae:	e010                	sd	a2,0(s0)
 5b0:	e414                	sd	a3,8(s0)
 5b2:	e818                	sd	a4,16(s0)
 5b4:	ec1c                	sd	a5,24(s0)
 5b6:	03043023          	sd	a6,32(s0)
 5ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5be:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5c2:	8622                	mv	a2,s0
 5c4:	00000097          	auipc	ra,0x0
 5c8:	e16080e7          	jalr	-490(ra) # 3da <vprintf>
}
 5cc:	60e2                	ld	ra,24(sp)
 5ce:	6442                	ld	s0,16(sp)
 5d0:	6161                	addi	sp,sp,80
 5d2:	8082                	ret

00000000000005d4 <printf>:

void
printf(const char *fmt, ...)
{
 5d4:	711d                	addi	sp,sp,-96
 5d6:	ec06                	sd	ra,24(sp)
 5d8:	e822                	sd	s0,16(sp)
 5da:	1000                	addi	s0,sp,32
 5dc:	e40c                	sd	a1,8(s0)
 5de:	e810                	sd	a2,16(s0)
 5e0:	ec14                	sd	a3,24(s0)
 5e2:	f018                	sd	a4,32(s0)
 5e4:	f41c                	sd	a5,40(s0)
 5e6:	03043823          	sd	a6,48(s0)
 5ea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5ee:	00840613          	addi	a2,s0,8
 5f2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5f6:	85aa                	mv	a1,a0
 5f8:	4505                	li	a0,1
 5fa:	00000097          	auipc	ra,0x0
 5fe:	de0080e7          	jalr	-544(ra) # 3da <vprintf>
}
 602:	60e2                	ld	ra,24(sp)
 604:	6442                	ld	s0,16(sp)
 606:	6125                	addi	sp,sp,96
 608:	8082                	ret

000000000000060a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60a:	1141                	addi	sp,sp,-16
 60c:	e422                	sd	s0,8(sp)
 60e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 610:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 614:	00000797          	auipc	a5,0x0
 618:	1dc7b783          	ld	a5,476(a5) # 7f0 <freep>
 61c:	a02d                	j	646 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 61e:	4618                	lw	a4,8(a2)
 620:	9f2d                	addw	a4,a4,a1
 622:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 626:	6398                	ld	a4,0(a5)
 628:	6310                	ld	a2,0(a4)
 62a:	a83d                	j	668 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 62c:	ff852703          	lw	a4,-8(a0)
 630:	9f31                	addw	a4,a4,a2
 632:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 634:	ff053683          	ld	a3,-16(a0)
 638:	a091                	j	67c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63a:	6398                	ld	a4,0(a5)
 63c:	00e7e463          	bltu	a5,a4,644 <free+0x3a>
 640:	00e6ea63          	bltu	a3,a4,654 <free+0x4a>
{
 644:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 646:	fed7fae3          	bgeu	a5,a3,63a <free+0x30>
 64a:	6398                	ld	a4,0(a5)
 64c:	00e6e463          	bltu	a3,a4,654 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	fee7eae3          	bltu	a5,a4,644 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 654:	ff852583          	lw	a1,-8(a0)
 658:	6390                	ld	a2,0(a5)
 65a:	02059813          	slli	a6,a1,0x20
 65e:	01c85713          	srli	a4,a6,0x1c
 662:	9736                	add	a4,a4,a3
 664:	fae60de3          	beq	a2,a4,61e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 668:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 66c:	4790                	lw	a2,8(a5)
 66e:	02061593          	slli	a1,a2,0x20
 672:	01c5d713          	srli	a4,a1,0x1c
 676:	973e                	add	a4,a4,a5
 678:	fae68ae3          	beq	a3,a4,62c <free+0x22>
    p->s.ptr = bp->s.ptr;
 67c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 67e:	00000717          	auipc	a4,0x0
 682:	16f73923          	sd	a5,370(a4) # 7f0 <freep>
}
 686:	6422                	ld	s0,8(sp)
 688:	0141                	addi	sp,sp,16
 68a:	8082                	ret

000000000000068c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 68c:	7139                	addi	sp,sp,-64
 68e:	fc06                	sd	ra,56(sp)
 690:	f822                	sd	s0,48(sp)
 692:	f426                	sd	s1,40(sp)
 694:	f04a                	sd	s2,32(sp)
 696:	ec4e                	sd	s3,24(sp)
 698:	e852                	sd	s4,16(sp)
 69a:	e456                	sd	s5,8(sp)
 69c:	e05a                	sd	s6,0(sp)
 69e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a0:	02051493          	slli	s1,a0,0x20
 6a4:	9081                	srli	s1,s1,0x20
 6a6:	04bd                	addi	s1,s1,15
 6a8:	8091                	srli	s1,s1,0x4
 6aa:	0014899b          	addiw	s3,s1,1
 6ae:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6b0:	00000517          	auipc	a0,0x0
 6b4:	14053503          	ld	a0,320(a0) # 7f0 <freep>
 6b8:	c515                	beqz	a0,6e4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6bc:	4798                	lw	a4,8(a5)
 6be:	02977f63          	bgeu	a4,s1,6fc <malloc+0x70>
  if(nu < 4096)
 6c2:	8a4e                	mv	s4,s3
 6c4:	0009871b          	sext.w	a4,s3
 6c8:	6685                	lui	a3,0x1
 6ca:	00d77363          	bgeu	a4,a3,6d0 <malloc+0x44>
 6ce:	6a05                	lui	s4,0x1
 6d0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6d4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6d8:	00000917          	auipc	s2,0x0
 6dc:	11890913          	addi	s2,s2,280 # 7f0 <freep>
  if(p == (char*)-1)
 6e0:	5afd                	li	s5,-1
 6e2:	a895                	j	756 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 6e4:	00000797          	auipc	a5,0x0
 6e8:	11478793          	addi	a5,a5,276 # 7f8 <base>
 6ec:	00000717          	auipc	a4,0x0
 6f0:	10f73223          	sd	a5,260(a4) # 7f0 <freep>
 6f4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 6f6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 6fa:	b7e1                	j	6c2 <malloc+0x36>
      if(p->s.size == nunits)
 6fc:	02e48c63          	beq	s1,a4,734 <malloc+0xa8>
        p->s.size -= nunits;
 700:	4137073b          	subw	a4,a4,s3
 704:	c798                	sw	a4,8(a5)
        p += p->s.size;
 706:	02071693          	slli	a3,a4,0x20
 70a:	01c6d713          	srli	a4,a3,0x1c
 70e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 710:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 714:	00000717          	auipc	a4,0x0
 718:	0ca73e23          	sd	a0,220(a4) # 7f0 <freep>
      return (void*)(p + 1);
 71c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 720:	70e2                	ld	ra,56(sp)
 722:	7442                	ld	s0,48(sp)
 724:	74a2                	ld	s1,40(sp)
 726:	7902                	ld	s2,32(sp)
 728:	69e2                	ld	s3,24(sp)
 72a:	6a42                	ld	s4,16(sp)
 72c:	6aa2                	ld	s5,8(sp)
 72e:	6b02                	ld	s6,0(sp)
 730:	6121                	addi	sp,sp,64
 732:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 734:	6398                	ld	a4,0(a5)
 736:	e118                	sd	a4,0(a0)
 738:	bff1                	j	714 <malloc+0x88>
  hp->s.size = nu;
 73a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 73e:	0541                	addi	a0,a0,16
 740:	00000097          	auipc	ra,0x0
 744:	eca080e7          	jalr	-310(ra) # 60a <free>
  return freep;
 748:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 74c:	d971                	beqz	a0,720 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 750:	4798                	lw	a4,8(a5)
 752:	fa9775e3          	bgeu	a4,s1,6fc <malloc+0x70>
    if(p == freep)
 756:	00093703          	ld	a4,0(s2)
 75a:	853e                	mv	a0,a5
 75c:	fef719e3          	bne	a4,a5,74e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 760:	8552                	mv	a0,s4
 762:	00000097          	auipc	ra,0x0
 766:	b92080e7          	jalr	-1134(ra) # 2f4 <sbrk>
  if(p == (char*)-1)
 76a:	fd5518e3          	bne	a0,s5,73a <malloc+0xae>
        return 0;
 76e:	4501                	li	a0,0
 770:	bf45                	j	720 <malloc+0x94>
