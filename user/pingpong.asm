
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int 
main(int argc, char *argv[]) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int p[2];
  char byte[1];
  pipe(p);
   8:	fe840513          	addi	a0,s0,-24
   c:	00000097          	auipc	ra,0x0
  10:	31e080e7          	jalr	798(ra) # 32a <pipe>
  if (fork() == 0) {
  14:	00000097          	auipc	ra,0x0
  18:	2fe080e7          	jalr	766(ra) # 312 <fork>
  1c:	e539                	bnez	a0,6a <main+0x6a>
    read(p[0], byte, sizeof(byte));
  1e:	4605                	li	a2,1
  20:	fe040593          	addi	a1,s0,-32
  24:	fe842503          	lw	a0,-24(s0)
  28:	00000097          	auipc	ra,0x0
  2c:	30a080e7          	jalr	778(ra) # 332 <read>
    printf("%d: received ping\n", (int)getpid());
  30:	00000097          	auipc	ra,0x0
  34:	36a080e7          	jalr	874(ra) # 39a <getpid>
  38:	85aa                	mv	a1,a0
  3a:	00000517          	auipc	a0,0x0
  3e:	7e650513          	addi	a0,a0,2022 # 820 <malloc+0xe6>
  42:	00000097          	auipc	ra,0x0
  46:	640080e7          	jalr	1600(ra) # 682 <printf>
    write(p[1], "1", sizeof(char));
  4a:	4605                	li	a2,1
  4c:	00000597          	auipc	a1,0x0
  50:	7ec58593          	addi	a1,a1,2028 # 838 <malloc+0xfe>
  54:	fec42503          	lw	a0,-20(s0)
  58:	00000097          	auipc	ra,0x0
  5c:	2e2080e7          	jalr	738(ra) # 33a <write>
  } else {
    write(p[1], "1", sizeof(char));
    read(p[0], byte, sizeof(byte));
    printf("%d: received pong\n", (int)getpid());
  }
  exit(0);
  60:	4501                	li	a0,0
  62:	00000097          	auipc	ra,0x0
  66:	2b8080e7          	jalr	696(ra) # 31a <exit>
    write(p[1], "1", sizeof(char));
  6a:	4605                	li	a2,1
  6c:	00000597          	auipc	a1,0x0
  70:	7cc58593          	addi	a1,a1,1996 # 838 <malloc+0xfe>
  74:	fec42503          	lw	a0,-20(s0)
  78:	00000097          	auipc	ra,0x0
  7c:	2c2080e7          	jalr	706(ra) # 33a <write>
    read(p[0], byte, sizeof(byte));
  80:	4605                	li	a2,1
  82:	fe040593          	addi	a1,s0,-32
  86:	fe842503          	lw	a0,-24(s0)
  8a:	00000097          	auipc	ra,0x0
  8e:	2a8080e7          	jalr	680(ra) # 332 <read>
    printf("%d: received pong\n", (int)getpid());
  92:	00000097          	auipc	ra,0x0
  96:	308080e7          	jalr	776(ra) # 39a <getpid>
  9a:	85aa                	mv	a1,a0
  9c:	00000517          	auipc	a0,0x0
  a0:	7a450513          	addi	a0,a0,1956 # 840 <malloc+0x106>
  a4:	00000097          	auipc	ra,0x0
  a8:	5de080e7          	jalr	1502(ra) # 682 <printf>
  ac:	bf55                	j	60 <main+0x60>

00000000000000ae <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b4:	87aa                	mv	a5,a0
  b6:	0585                	addi	a1,a1,1
  b8:	0785                	addi	a5,a5,1
  ba:	fff5c703          	lbu	a4,-1(a1)
  be:	fee78fa3          	sb	a4,-1(a5)
  c2:	fb75                	bnez	a4,b6 <strcpy+0x8>
    ;
  return os;
}
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cb91                	beqz	a5,e8 <strcmp+0x1e>
  d6:	0005c703          	lbu	a4,0(a1)
  da:	00f71763          	bne	a4,a5,e8 <strcmp+0x1e>
    p++, q++;
  de:	0505                	addi	a0,a0,1
  e0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	fbe5                	bnez	a5,d6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e8:	0005c503          	lbu	a0,0(a1)
}
  ec:	40a7853b          	subw	a0,a5,a0
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strlen>:

uint
strlen(const char *s)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  fc:	00054783          	lbu	a5,0(a0)
 100:	cf91                	beqz	a5,11c <strlen+0x26>
 102:	0505                	addi	a0,a0,1
 104:	87aa                	mv	a5,a0
 106:	86be                	mv	a3,a5
 108:	0785                	addi	a5,a5,1
 10a:	fff7c703          	lbu	a4,-1(a5)
 10e:	ff65                	bnez	a4,106 <strlen+0x10>
 110:	40a6853b          	subw	a0,a3,a0
 114:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret
  for(n = 0; s[n]; n++)
 11c:	4501                	li	a0,0
 11e:	bfe5                	j	116 <strlen+0x20>

0000000000000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	1141                	addi	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 126:	ca19                	beqz	a2,13c <memset+0x1c>
 128:	87aa                	mv	a5,a0
 12a:	1602                	slli	a2,a2,0x20
 12c:	9201                	srli	a2,a2,0x20
 12e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 132:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 136:	0785                	addi	a5,a5,1
 138:	fee79de3          	bne	a5,a4,132 <memset+0x12>
  }
  return dst;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strchr>:

char*
strchr(const char *s, char c)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  for(; *s; s++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb99                	beqz	a5,162 <strchr+0x20>
    if(*s == c)
 14e:	00f58763          	beq	a1,a5,15c <strchr+0x1a>
  for(; *s; s++)
 152:	0505                	addi	a0,a0,1
 154:	00054783          	lbu	a5,0(a0)
 158:	fbfd                	bnez	a5,14e <strchr+0xc>
      return (char*)s;
  return 0;
 15a:	4501                	li	a0,0
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret
  return 0;
 162:	4501                	li	a0,0
 164:	bfe5                	j	15c <strchr+0x1a>

0000000000000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	e4a6                	sd	s1,72(sp)
 16e:	e0ca                	sd	s2,64(sp)
 170:	fc4e                	sd	s3,56(sp)
 172:	f852                	sd	s4,48(sp)
 174:	f456                	sd	s5,40(sp)
 176:	f05a                	sd	s6,32(sp)
 178:	ec5e                	sd	s7,24(sp)
 17a:	1080                	addi	s0,sp,96
 17c:	8baa                	mv	s7,a0
 17e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	892a                	mv	s2,a0
 182:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 184:	4aa9                	li	s5,10
 186:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 188:	89a6                	mv	s3,s1
 18a:	2485                	addiw	s1,s1,1
 18c:	0344d863          	bge	s1,s4,1bc <gets+0x56>
    cc = read(0, &c, 1);
 190:	4605                	li	a2,1
 192:	faf40593          	addi	a1,s0,-81
 196:	4501                	li	a0,0
 198:	00000097          	auipc	ra,0x0
 19c:	19a080e7          	jalr	410(ra) # 332 <read>
    if(cc < 1)
 1a0:	00a05e63          	blez	a0,1bc <gets+0x56>
    buf[i++] = c;
 1a4:	faf44783          	lbu	a5,-81(s0)
 1a8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ac:	01578763          	beq	a5,s5,1ba <gets+0x54>
 1b0:	0905                	addi	s2,s2,1
 1b2:	fd679be3          	bne	a5,s6,188 <gets+0x22>
  for(i=0; i+1 < max; ){
 1b6:	89a6                	mv	s3,s1
 1b8:	a011                	j	1bc <gets+0x56>
 1ba:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1bc:	99de                	add	s3,s3,s7
 1be:	00098023          	sb	zero,0(s3)
  return buf;
}
 1c2:	855e                	mv	a0,s7
 1c4:	60e6                	ld	ra,88(sp)
 1c6:	6446                	ld	s0,80(sp)
 1c8:	64a6                	ld	s1,72(sp)
 1ca:	6906                	ld	s2,64(sp)
 1cc:	79e2                	ld	s3,56(sp)
 1ce:	7a42                	ld	s4,48(sp)
 1d0:	7aa2                	ld	s5,40(sp)
 1d2:	7b02                	ld	s6,32(sp)
 1d4:	6be2                	ld	s7,24(sp)
 1d6:	6125                	addi	sp,sp,96
 1d8:	8082                	ret

00000000000001da <stat>:

int
stat(const char *n, struct stat *st)
{
 1da:	1101                	addi	sp,sp,-32
 1dc:	ec06                	sd	ra,24(sp)
 1de:	e822                	sd	s0,16(sp)
 1e0:	e426                	sd	s1,8(sp)
 1e2:	e04a                	sd	s2,0(sp)
 1e4:	1000                	addi	s0,sp,32
 1e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	4581                	li	a1,0
 1ea:	00000097          	auipc	ra,0x0
 1ee:	170080e7          	jalr	368(ra) # 35a <open>
  if(fd < 0)
 1f2:	02054563          	bltz	a0,21c <stat+0x42>
 1f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f8:	85ca                	mv	a1,s2
 1fa:	00000097          	auipc	ra,0x0
 1fe:	178080e7          	jalr	376(ra) # 372 <fstat>
 202:	892a                	mv	s2,a0
  close(fd);
 204:	8526                	mv	a0,s1
 206:	00000097          	auipc	ra,0x0
 20a:	13c080e7          	jalr	316(ra) # 342 <close>
  return r;
}
 20e:	854a                	mv	a0,s2
 210:	60e2                	ld	ra,24(sp)
 212:	6442                	ld	s0,16(sp)
 214:	64a2                	ld	s1,8(sp)
 216:	6902                	ld	s2,0(sp)
 218:	6105                	addi	sp,sp,32
 21a:	8082                	ret
    return -1;
 21c:	597d                	li	s2,-1
 21e:	bfc5                	j	20e <stat+0x34>

0000000000000220 <atoi>:

int
atoi(const char *s)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 226:	00054683          	lbu	a3,0(a0)
 22a:	fd06879b          	addiw	a5,a3,-48
 22e:	0ff7f793          	zext.b	a5,a5
 232:	4625                	li	a2,9
 234:	02f66863          	bltu	a2,a5,264 <atoi+0x44>
 238:	872a                	mv	a4,a0
  n = 0;
 23a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 23c:	0705                	addi	a4,a4,1
 23e:	0025179b          	slliw	a5,a0,0x2
 242:	9fa9                	addw	a5,a5,a0
 244:	0017979b          	slliw	a5,a5,0x1
 248:	9fb5                	addw	a5,a5,a3
 24a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 24e:	00074683          	lbu	a3,0(a4)
 252:	fd06879b          	addiw	a5,a3,-48
 256:	0ff7f793          	zext.b	a5,a5
 25a:	fef671e3          	bgeu	a2,a5,23c <atoi+0x1c>
  return n;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  n = 0;
 264:	4501                	li	a0,0
 266:	bfe5                	j	25e <atoi+0x3e>

0000000000000268 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 26e:	02b57463          	bgeu	a0,a1,296 <memmove+0x2e>
    while(n-- > 0)
 272:	00c05f63          	blez	a2,290 <memmove+0x28>
 276:	1602                	slli	a2,a2,0x20
 278:	9201                	srli	a2,a2,0x20
 27a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 27e:	872a                	mv	a4,a0
      *dst++ = *src++;
 280:	0585                	addi	a1,a1,1
 282:	0705                	addi	a4,a4,1
 284:	fff5c683          	lbu	a3,-1(a1)
 288:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28c:	fee79ae3          	bne	a5,a4,280 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
    dst += n;
 296:	00c50733          	add	a4,a0,a2
    src += n;
 29a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 29c:	fec05ae3          	blez	a2,290 <memmove+0x28>
 2a0:	fff6079b          	addiw	a5,a2,-1
 2a4:	1782                	slli	a5,a5,0x20
 2a6:	9381                	srli	a5,a5,0x20
 2a8:	fff7c793          	not	a5,a5
 2ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ae:	15fd                	addi	a1,a1,-1
 2b0:	177d                	addi	a4,a4,-1
 2b2:	0005c683          	lbu	a3,0(a1)
 2b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ba:	fee79ae3          	bne	a5,a4,2ae <memmove+0x46>
 2be:	bfc9                	j	290 <memmove+0x28>

00000000000002c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c6:	ca05                	beqz	a2,2f6 <memcmp+0x36>
 2c8:	fff6069b          	addiw	a3,a2,-1
 2cc:	1682                	slli	a3,a3,0x20
 2ce:	9281                	srli	a3,a3,0x20
 2d0:	0685                	addi	a3,a3,1
 2d2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	0005c703          	lbu	a4,0(a1)
 2dc:	00e79863          	bne	a5,a4,2ec <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2e0:	0505                	addi	a0,a0,1
    p2++;
 2e2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e4:	fed518e3          	bne	a0,a3,2d4 <memcmp+0x14>
  }
  return 0;
 2e8:	4501                	li	a0,0
 2ea:	a019                	j	2f0 <memcmp+0x30>
      return *p1 - *p2;
 2ec:	40e7853b          	subw	a0,a5,a4
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  return 0;
 2f6:	4501                	li	a0,0
 2f8:	bfe5                	j	2f0 <memcmp+0x30>

00000000000002fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 302:	00000097          	auipc	ra,0x0
 306:	f66080e7          	jalr	-154(ra) # 268 <memmove>
}
 30a:	60a2                	ld	ra,8(sp)
 30c:	6402                	ld	s0,0(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret

0000000000000312 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 312:	4885                	li	a7,1
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <exit>:
.global exit
exit:
 li a7, SYS_exit
 31a:	4889                	li	a7,2
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <wait>:
.global wait
wait:
 li a7, SYS_wait
 322:	488d                	li	a7,3
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32a:	4891                	li	a7,4
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <read>:
.global read
read:
 li a7, SYS_read
 332:	4895                	li	a7,5
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <write>:
.global write
write:
 li a7, SYS_write
 33a:	48c1                	li	a7,16
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <close>:
.global close
close:
 li a7, SYS_close
 342:	48d5                	li	a7,21
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <kill>:
.global kill
kill:
 li a7, SYS_kill
 34a:	4899                	li	a7,6
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <exec>:
.global exec
exec:
 li a7, SYS_exec
 352:	489d                	li	a7,7
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <open>:
.global open
open:
 li a7, SYS_open
 35a:	48bd                	li	a7,15
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 362:	48c5                	li	a7,17
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36a:	48c9                	li	a7,18
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 372:	48a1                	li	a7,8
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <link>:
.global link
link:
 li a7, SYS_link
 37a:	48cd                	li	a7,19
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 382:	48d1                	li	a7,20
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38a:	48a5                	li	a7,9
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <dup>:
.global dup
dup:
 li a7, SYS_dup
 392:	48a9                	li	a7,10
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39a:	48ad                	li	a7,11
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a2:	48b1                	li	a7,12
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3aa:	48b5                	li	a7,13
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b2:	48b9                	li	a7,14
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ba:	1101                	addi	sp,sp,-32
 3bc:	ec06                	sd	ra,24(sp)
 3be:	e822                	sd	s0,16(sp)
 3c0:	1000                	addi	s0,sp,32
 3c2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c6:	4605                	li	a2,1
 3c8:	fef40593          	addi	a1,s0,-17
 3cc:	00000097          	auipc	ra,0x0
 3d0:	f6e080e7          	jalr	-146(ra) # 33a <write>
}
 3d4:	60e2                	ld	ra,24(sp)
 3d6:	6442                	ld	s0,16(sp)
 3d8:	6105                	addi	sp,sp,32
 3da:	8082                	ret

00000000000003dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3dc:	7139                	addi	sp,sp,-64
 3de:	fc06                	sd	ra,56(sp)
 3e0:	f822                	sd	s0,48(sp)
 3e2:	f426                	sd	s1,40(sp)
 3e4:	f04a                	sd	s2,32(sp)
 3e6:	ec4e                	sd	s3,24(sp)
 3e8:	0080                	addi	s0,sp,64
 3ea:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ec:	c299                	beqz	a3,3f2 <printint+0x16>
 3ee:	0805c963          	bltz	a1,480 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f2:	2581                	sext.w	a1,a1
  neg = 0;
 3f4:	4881                	li	a7,0
 3f6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3fa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fc:	2601                	sext.w	a2,a2
 3fe:	00000517          	auipc	a0,0x0
 402:	4ba50513          	addi	a0,a0,1210 # 8b8 <digits>
 406:	883a                	mv	a6,a4
 408:	2705                	addiw	a4,a4,1
 40a:	02c5f7bb          	remuw	a5,a1,a2
 40e:	1782                	slli	a5,a5,0x20
 410:	9381                	srli	a5,a5,0x20
 412:	97aa                	add	a5,a5,a0
 414:	0007c783          	lbu	a5,0(a5)
 418:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 41c:	0005879b          	sext.w	a5,a1
 420:	02c5d5bb          	divuw	a1,a1,a2
 424:	0685                	addi	a3,a3,1
 426:	fec7f0e3          	bgeu	a5,a2,406 <printint+0x2a>
  if(neg)
 42a:	00088c63          	beqz	a7,442 <printint+0x66>
    buf[i++] = '-';
 42e:	fd070793          	addi	a5,a4,-48
 432:	00878733          	add	a4,a5,s0
 436:	02d00793          	li	a5,45
 43a:	fef70823          	sb	a5,-16(a4)
 43e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 442:	02e05863          	blez	a4,472 <printint+0x96>
 446:	fc040793          	addi	a5,s0,-64
 44a:	00e78933          	add	s2,a5,a4
 44e:	fff78993          	addi	s3,a5,-1
 452:	99ba                	add	s3,s3,a4
 454:	377d                	addiw	a4,a4,-1
 456:	1702                	slli	a4,a4,0x20
 458:	9301                	srli	a4,a4,0x20
 45a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 45e:	fff94583          	lbu	a1,-1(s2)
 462:	8526                	mv	a0,s1
 464:	00000097          	auipc	ra,0x0
 468:	f56080e7          	jalr	-170(ra) # 3ba <putc>
  while(--i >= 0)
 46c:	197d                	addi	s2,s2,-1
 46e:	ff3918e3          	bne	s2,s3,45e <printint+0x82>
}
 472:	70e2                	ld	ra,56(sp)
 474:	7442                	ld	s0,48(sp)
 476:	74a2                	ld	s1,40(sp)
 478:	7902                	ld	s2,32(sp)
 47a:	69e2                	ld	s3,24(sp)
 47c:	6121                	addi	sp,sp,64
 47e:	8082                	ret
    x = -xx;
 480:	40b005bb          	negw	a1,a1
    neg = 1;
 484:	4885                	li	a7,1
    x = -xx;
 486:	bf85                	j	3f6 <printint+0x1a>

0000000000000488 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 488:	715d                	addi	sp,sp,-80
 48a:	e486                	sd	ra,72(sp)
 48c:	e0a2                	sd	s0,64(sp)
 48e:	fc26                	sd	s1,56(sp)
 490:	f84a                	sd	s2,48(sp)
 492:	f44e                	sd	s3,40(sp)
 494:	f052                	sd	s4,32(sp)
 496:	ec56                	sd	s5,24(sp)
 498:	e85a                	sd	s6,16(sp)
 49a:	e45e                	sd	s7,8(sp)
 49c:	e062                	sd	s8,0(sp)
 49e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a0:	0005c903          	lbu	s2,0(a1)
 4a4:	18090c63          	beqz	s2,63c <vprintf+0x1b4>
 4a8:	8aaa                	mv	s5,a0
 4aa:	8bb2                	mv	s7,a2
 4ac:	00158493          	addi	s1,a1,1
  state = 0;
 4b0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b2:	02500a13          	li	s4,37
 4b6:	4b55                	li	s6,21
 4b8:	a839                	j	4d6 <vprintf+0x4e>
        putc(fd, c);
 4ba:	85ca                	mv	a1,s2
 4bc:	8556                	mv	a0,s5
 4be:	00000097          	auipc	ra,0x0
 4c2:	efc080e7          	jalr	-260(ra) # 3ba <putc>
 4c6:	a019                	j	4cc <vprintf+0x44>
    } else if(state == '%'){
 4c8:	01498d63          	beq	s3,s4,4e2 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 4cc:	0485                	addi	s1,s1,1
 4ce:	fff4c903          	lbu	s2,-1(s1)
 4d2:	16090563          	beqz	s2,63c <vprintf+0x1b4>
    if(state == 0){
 4d6:	fe0999e3          	bnez	s3,4c8 <vprintf+0x40>
      if(c == '%'){
 4da:	ff4910e3          	bne	s2,s4,4ba <vprintf+0x32>
        state = '%';
 4de:	89d2                	mv	s3,s4
 4e0:	b7f5                	j	4cc <vprintf+0x44>
      if(c == 'd'){
 4e2:	13490263          	beq	s2,s4,606 <vprintf+0x17e>
 4e6:	f9d9079b          	addiw	a5,s2,-99
 4ea:	0ff7f793          	zext.b	a5,a5
 4ee:	12fb6563          	bltu	s6,a5,618 <vprintf+0x190>
 4f2:	f9d9079b          	addiw	a5,s2,-99
 4f6:	0ff7f713          	zext.b	a4,a5
 4fa:	10eb6f63          	bltu	s6,a4,618 <vprintf+0x190>
 4fe:	00271793          	slli	a5,a4,0x2
 502:	00000717          	auipc	a4,0x0
 506:	35e70713          	addi	a4,a4,862 # 860 <malloc+0x126>
 50a:	97ba                	add	a5,a5,a4
 50c:	439c                	lw	a5,0(a5)
 50e:	97ba                	add	a5,a5,a4
 510:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 512:	008b8913          	addi	s2,s7,8
 516:	4685                	li	a3,1
 518:	4629                	li	a2,10
 51a:	000ba583          	lw	a1,0(s7)
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	ebc080e7          	jalr	-324(ra) # 3dc <printint>
 528:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 52a:	4981                	li	s3,0
 52c:	b745                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 52e:	008b8913          	addi	s2,s7,8
 532:	4681                	li	a3,0
 534:	4629                	li	a2,10
 536:	000ba583          	lw	a1,0(s7)
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	ea0080e7          	jalr	-352(ra) # 3dc <printint>
 544:	8bca                	mv	s7,s2
      state = 0;
 546:	4981                	li	s3,0
 548:	b751                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 54a:	008b8913          	addi	s2,s7,8
 54e:	4681                	li	a3,0
 550:	4641                	li	a2,16
 552:	000ba583          	lw	a1,0(s7)
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	e84080e7          	jalr	-380(ra) # 3dc <printint>
 560:	8bca                	mv	s7,s2
      state = 0;
 562:	4981                	li	s3,0
 564:	b7a5                	j	4cc <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 566:	008b8c13          	addi	s8,s7,8
 56a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 56e:	03000593          	li	a1,48
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	e46080e7          	jalr	-442(ra) # 3ba <putc>
  putc(fd, 'x');
 57c:	07800593          	li	a1,120
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e38080e7          	jalr	-456(ra) # 3ba <putc>
 58a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 58c:	00000b97          	auipc	s7,0x0
 590:	32cb8b93          	addi	s7,s7,812 # 8b8 <digits>
 594:	03c9d793          	srli	a5,s3,0x3c
 598:	97de                	add	a5,a5,s7
 59a:	0007c583          	lbu	a1,0(a5)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	e1a080e7          	jalr	-486(ra) # 3ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5a8:	0992                	slli	s3,s3,0x4
 5aa:	397d                	addiw	s2,s2,-1
 5ac:	fe0914e3          	bnez	s2,594 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5b0:	8be2                	mv	s7,s8
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	bf21                	j	4cc <vprintf+0x44>
        s = va_arg(ap, char*);
 5b6:	008b8993          	addi	s3,s7,8
 5ba:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5be:	02090163          	beqz	s2,5e0 <vprintf+0x158>
        while(*s != 0){
 5c2:	00094583          	lbu	a1,0(s2)
 5c6:	c9a5                	beqz	a1,636 <vprintf+0x1ae>
          putc(fd, *s);
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	df0080e7          	jalr	-528(ra) # 3ba <putc>
          s++;
 5d2:	0905                	addi	s2,s2,1
        while(*s != 0){
 5d4:	00094583          	lbu	a1,0(s2)
 5d8:	f9e5                	bnez	a1,5c8 <vprintf+0x140>
        s = va_arg(ap, char*);
 5da:	8bce                	mv	s7,s3
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b5fd                	j	4cc <vprintf+0x44>
          s = "(null)";
 5e0:	00000917          	auipc	s2,0x0
 5e4:	27890913          	addi	s2,s2,632 # 858 <malloc+0x11e>
        while(*s != 0){
 5e8:	02800593          	li	a1,40
 5ec:	bff1                	j	5c8 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	000bc583          	lbu	a1,0(s7)
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	dc2080e7          	jalr	-574(ra) # 3ba <putc>
 600:	8bca                	mv	s7,s2
      state = 0;
 602:	4981                	li	s3,0
 604:	b5e1                	j	4cc <vprintf+0x44>
        putc(fd, c);
 606:	02500593          	li	a1,37
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	dae080e7          	jalr	-594(ra) # 3ba <putc>
      state = 0;
 614:	4981                	li	s3,0
 616:	bd5d                	j	4cc <vprintf+0x44>
        putc(fd, '%');
 618:	02500593          	li	a1,37
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	d9c080e7          	jalr	-612(ra) # 3ba <putc>
        putc(fd, c);
 626:	85ca                	mv	a1,s2
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	d90080e7          	jalr	-624(ra) # 3ba <putc>
      state = 0;
 632:	4981                	li	s3,0
 634:	bd61                	j	4cc <vprintf+0x44>
        s = va_arg(ap, char*);
 636:	8bce                	mv	s7,s3
      state = 0;
 638:	4981                	li	s3,0
 63a:	bd49                	j	4cc <vprintf+0x44>
    }
  }
}
 63c:	60a6                	ld	ra,72(sp)
 63e:	6406                	ld	s0,64(sp)
 640:	74e2                	ld	s1,56(sp)
 642:	7942                	ld	s2,48(sp)
 644:	79a2                	ld	s3,40(sp)
 646:	7a02                	ld	s4,32(sp)
 648:	6ae2                	ld	s5,24(sp)
 64a:	6b42                	ld	s6,16(sp)
 64c:	6ba2                	ld	s7,8(sp)
 64e:	6c02                	ld	s8,0(sp)
 650:	6161                	addi	sp,sp,80
 652:	8082                	ret

0000000000000654 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 654:	715d                	addi	sp,sp,-80
 656:	ec06                	sd	ra,24(sp)
 658:	e822                	sd	s0,16(sp)
 65a:	1000                	addi	s0,sp,32
 65c:	e010                	sd	a2,0(s0)
 65e:	e414                	sd	a3,8(s0)
 660:	e818                	sd	a4,16(s0)
 662:	ec1c                	sd	a5,24(s0)
 664:	03043023          	sd	a6,32(s0)
 668:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 66c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 670:	8622                	mv	a2,s0
 672:	00000097          	auipc	ra,0x0
 676:	e16080e7          	jalr	-490(ra) # 488 <vprintf>
}
 67a:	60e2                	ld	ra,24(sp)
 67c:	6442                	ld	s0,16(sp)
 67e:	6161                	addi	sp,sp,80
 680:	8082                	ret

0000000000000682 <printf>:

void
printf(const char *fmt, ...)
{
 682:	711d                	addi	sp,sp,-96
 684:	ec06                	sd	ra,24(sp)
 686:	e822                	sd	s0,16(sp)
 688:	1000                	addi	s0,sp,32
 68a:	e40c                	sd	a1,8(s0)
 68c:	e810                	sd	a2,16(s0)
 68e:	ec14                	sd	a3,24(s0)
 690:	f018                	sd	a4,32(s0)
 692:	f41c                	sd	a5,40(s0)
 694:	03043823          	sd	a6,48(s0)
 698:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 69c:	00840613          	addi	a2,s0,8
 6a0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a4:	85aa                	mv	a1,a0
 6a6:	4505                	li	a0,1
 6a8:	00000097          	auipc	ra,0x0
 6ac:	de0080e7          	jalr	-544(ra) # 488 <vprintf>
}
 6b0:	60e2                	ld	ra,24(sp)
 6b2:	6442                	ld	s0,16(sp)
 6b4:	6125                	addi	sp,sp,96
 6b6:	8082                	ret

00000000000006b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b8:	1141                	addi	sp,sp,-16
 6ba:	e422                	sd	s0,8(sp)
 6bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	00000797          	auipc	a5,0x0
 6c6:	20e7b783          	ld	a5,526(a5) # 8d0 <freep>
 6ca:	a02d                	j	6f4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6cc:	4618                	lw	a4,8(a2)
 6ce:	9f2d                	addw	a4,a4,a1
 6d0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d4:	6398                	ld	a4,0(a5)
 6d6:	6310                	ld	a2,0(a4)
 6d8:	a83d                	j	716 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6da:	ff852703          	lw	a4,-8(a0)
 6de:	9f31                	addw	a4,a4,a2
 6e0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6e2:	ff053683          	ld	a3,-16(a0)
 6e6:	a091                	j	72a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e8:	6398                	ld	a4,0(a5)
 6ea:	00e7e463          	bltu	a5,a4,6f2 <free+0x3a>
 6ee:	00e6ea63          	bltu	a3,a4,702 <free+0x4a>
{
 6f2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f4:	fed7fae3          	bgeu	a5,a3,6e8 <free+0x30>
 6f8:	6398                	ld	a4,0(a5)
 6fa:	00e6e463          	bltu	a3,a4,702 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fe:	fee7eae3          	bltu	a5,a4,6f2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 702:	ff852583          	lw	a1,-8(a0)
 706:	6390                	ld	a2,0(a5)
 708:	02059813          	slli	a6,a1,0x20
 70c:	01c85713          	srli	a4,a6,0x1c
 710:	9736                	add	a4,a4,a3
 712:	fae60de3          	beq	a2,a4,6cc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 716:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 71a:	4790                	lw	a2,8(a5)
 71c:	02061593          	slli	a1,a2,0x20
 720:	01c5d713          	srli	a4,a1,0x1c
 724:	973e                	add	a4,a4,a5
 726:	fae68ae3          	beq	a3,a4,6da <free+0x22>
    p->s.ptr = bp->s.ptr;
 72a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 72c:	00000717          	auipc	a4,0x0
 730:	1af73223          	sd	a5,420(a4) # 8d0 <freep>
}
 734:	6422                	ld	s0,8(sp)
 736:	0141                	addi	sp,sp,16
 738:	8082                	ret

000000000000073a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 73a:	7139                	addi	sp,sp,-64
 73c:	fc06                	sd	ra,56(sp)
 73e:	f822                	sd	s0,48(sp)
 740:	f426                	sd	s1,40(sp)
 742:	f04a                	sd	s2,32(sp)
 744:	ec4e                	sd	s3,24(sp)
 746:	e852                	sd	s4,16(sp)
 748:	e456                	sd	s5,8(sp)
 74a:	e05a                	sd	s6,0(sp)
 74c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74e:	02051493          	slli	s1,a0,0x20
 752:	9081                	srli	s1,s1,0x20
 754:	04bd                	addi	s1,s1,15
 756:	8091                	srli	s1,s1,0x4
 758:	0014899b          	addiw	s3,s1,1
 75c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 75e:	00000517          	auipc	a0,0x0
 762:	17253503          	ld	a0,370(a0) # 8d0 <freep>
 766:	c515                	beqz	a0,792 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 768:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 76a:	4798                	lw	a4,8(a5)
 76c:	02977f63          	bgeu	a4,s1,7aa <malloc+0x70>
  if(nu < 4096)
 770:	8a4e                	mv	s4,s3
 772:	0009871b          	sext.w	a4,s3
 776:	6685                	lui	a3,0x1
 778:	00d77363          	bgeu	a4,a3,77e <malloc+0x44>
 77c:	6a05                	lui	s4,0x1
 77e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 782:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 786:	00000917          	auipc	s2,0x0
 78a:	14a90913          	addi	s2,s2,330 # 8d0 <freep>
  if(p == (char*)-1)
 78e:	5afd                	li	s5,-1
 790:	a895                	j	804 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 792:	00000797          	auipc	a5,0x0
 796:	14678793          	addi	a5,a5,326 # 8d8 <base>
 79a:	00000717          	auipc	a4,0x0
 79e:	12f73b23          	sd	a5,310(a4) # 8d0 <freep>
 7a2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7a4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7a8:	b7e1                	j	770 <malloc+0x36>
      if(p->s.size == nunits)
 7aa:	02e48c63          	beq	s1,a4,7e2 <malloc+0xa8>
        p->s.size -= nunits;
 7ae:	4137073b          	subw	a4,a4,s3
 7b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7b4:	02071693          	slli	a3,a4,0x20
 7b8:	01c6d713          	srli	a4,a3,0x1c
 7bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7c2:	00000717          	auipc	a4,0x0
 7c6:	10a73723          	sd	a0,270(a4) # 8d0 <freep>
      return (void*)(p + 1);
 7ca:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ce:	70e2                	ld	ra,56(sp)
 7d0:	7442                	ld	s0,48(sp)
 7d2:	74a2                	ld	s1,40(sp)
 7d4:	7902                	ld	s2,32(sp)
 7d6:	69e2                	ld	s3,24(sp)
 7d8:	6a42                	ld	s4,16(sp)
 7da:	6aa2                	ld	s5,8(sp)
 7dc:	6b02                	ld	s6,0(sp)
 7de:	6121                	addi	sp,sp,64
 7e0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7e2:	6398                	ld	a4,0(a5)
 7e4:	e118                	sd	a4,0(a0)
 7e6:	bff1                	j	7c2 <malloc+0x88>
  hp->s.size = nu;
 7e8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ec:	0541                	addi	a0,a0,16
 7ee:	00000097          	auipc	ra,0x0
 7f2:	eca080e7          	jalr	-310(ra) # 6b8 <free>
  return freep;
 7f6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7fa:	d971                	beqz	a0,7ce <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fe:	4798                	lw	a4,8(a5)
 800:	fa9775e3          	bgeu	a4,s1,7aa <malloc+0x70>
    if(p == freep)
 804:	00093703          	ld	a4,0(s2)
 808:	853e                	mv	a0,a5
 80a:	fef719e3          	bne	a4,a5,7fc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 80e:	8552                	mv	a0,s4
 810:	00000097          	auipc	ra,0x0
 814:	b92080e7          	jalr	-1134(ra) # 3a2 <sbrk>
  if(p == (char*)-1)
 818:	fd5518e3          	bne	a0,s5,7e8 <malloc+0xae>
        return 0;
 81c:	4501                	li	a0,0
 81e:	bf45                	j	7ce <malloc+0x94>
