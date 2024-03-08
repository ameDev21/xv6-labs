
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <xargs>:
#include "kernel/param.h"
#include "user/user.h"

#define MAXBUF 100

void xargs(char* cmd_p[], int argc, char line_p[MAXARG][MAXBUF], int l_argc) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char* merged[argc+l_argc];
   a:	00d588bb          	addw	a7,a1,a3
   e:	0008879b          	sext.w	a5,a7
  12:	078e                	slli	a5,a5,0x3
  14:	07bd                	addi	a5,a5,15
  16:	9bc1                	andi	a5,a5,-16
  18:	40f10133          	sub	sp,sp,a5
  1c:	848a                	mv	s1,sp
  int j = 0;
  for (int i = 1; i < argc; ++i) {
  1e:	4785                	li	a5,1
  20:	02b7d363          	bge	a5,a1,46 <xargs+0x46>
  24:	00850793          	addi	a5,a0,8
  28:	8726                	mv	a4,s1
  2a:	ffe5881b          	addiw	a6,a1,-2
  2e:	02081313          	slli	t1,a6,0x20
  32:	01d35813          	srli	a6,t1,0x1d
  36:	0541                	addi	a0,a0,16
  38:	982a                	add	a6,a6,a0
    merged[j] = cmd_p[i];
  3a:	6388                	ld	a0,0(a5)
  3c:	e308                	sd	a0,0(a4)
  for (int i = 1; i < argc; ++i) {
  3e:	07a1                	addi	a5,a5,8
  40:	0721                	addi	a4,a4,8
  42:	ff079ce3          	bne	a5,a6,3a <xargs+0x3a>
    ++j;
  }
  j = 0;
  for (int i = argc - 1; j < l_argc; ++i) {
  46:	02d05263          	blez	a3,6a <xargs+0x6a>
  4a:	8732                	mv	a4,a2
  4c:	058e                	slli	a1,a1,0x3
  4e:	00b487b3          	add	a5,s1,a1
  52:	06400593          	li	a1,100
  56:	02b686b3          	mul	a3,a3,a1
  5a:	9636                	add	a2,a2,a3
    merged[i] = line_p[j];
  5c:	fee7bc23          	sd	a4,-8(a5)
  for (int i = argc - 1; j < l_argc; ++i) {
  60:	06470713          	addi	a4,a4,100
  64:	07a1                	addi	a5,a5,8
  66:	fec71be3          	bne	a4,a2,5c <xargs+0x5c>
    j++;
  }
  merged[l_argc+argc - 1] = 0;
  6a:	38fd                	addiw	a7,a7,-1
  6c:	088e                	slli	a7,a7,0x3
  6e:	98a6                	add	a7,a7,s1
  70:	0008b023          	sd	zero,0(a7)
  if (fork() == 0) {
  74:	00000097          	auipc	ra,0x0
  78:	35e080e7          	jalr	862(ra) # 3d2 <fork>
  7c:	ed11                	bnez	a0,98 <xargs+0x98>
    exec(merged[0], merged);
  7e:	85a6                	mv	a1,s1
  80:	6088                	ld	a0,0(s1)
  82:	00000097          	auipc	ra,0x0
  86:	390080e7          	jalr	912(ra) # 412 <exec>
  } else {
    wait(0);
  }
}
  8a:	fe040113          	addi	sp,s0,-32
  8e:	60e2                	ld	ra,24(sp)
  90:	6442                	ld	s0,16(sp)
  92:	64a2                	ld	s1,8(sp)
  94:	6105                	addi	sp,sp,32
  96:	8082                	ret
    wait(0);
  98:	4501                	li	a0,0
  9a:	00000097          	auipc	ra,0x0
  9e:	348080e7          	jalr	840(ra) # 3e2 <wait>
}
  a2:	b7e5                	j	8a <xargs+0x8a>

00000000000000a4 <main>:

int
main(int argc, char *argv[])
{
  a4:	81010113          	addi	sp,sp,-2032
  a8:	7e113423          	sd	ra,2024(sp)
  ac:	7e813023          	sd	s0,2016(sp)
  b0:	7c913c23          	sd	s1,2008(sp)
  b4:	7d213823          	sd	s2,2000(sp)
  b8:	7d313423          	sd	s3,1992(sp)
  bc:	7d413023          	sd	s4,1984(sp)
  c0:	7b513c23          	sd	s5,1976(sp)
  c4:	7b613823          	sd	s6,1968(sp)
  c8:	7b713423          	sd	s7,1960(sp)
  cc:	7b813023          	sd	s8,1952(sp)
  d0:	79913c23          	sd	s9,1944(sp)
  d4:	79a13823          	sd	s10,1936(sp)
  d8:	7f010413          	addi	s0,sp,2032
  dc:	b0010113          	addi	sp,sp,-1280
  e0:	8d2a                	mv	s10,a0
  e2:	8cae                	mv	s9,a1
  char l_argv[MAXARG][MAXBUF];
  char ch;
  int i = 0;
  int j = 0;
  e4:	4481                	li	s1,0
  int i = 0;
  e6:	4981                	li	s3,0
  while (read(0, &ch, 1)) {
  e8:	7afd                	lui	s5,0xfffff
  ea:	31fa8793          	addi	a5,s5,799 # fffffffffffff31f <__global_pointer$+0xffffffffffffe1ce>
  ee:	00878a33          	add	s4,a5,s0
    if (ch == '\n') {
  f2:	fa0a8793          	addi	a5,s5,-96
  f6:	00878933          	add	s2,a5,s0
  fa:	4b29                	li	s6,10
      ++i;
      xargs(argv, argc, l_argv, i);
      i = 0;
      j = 0;
      memset(l_argv, 0, MAXARG * sizeof(char*));
    } else if (ch == ' ') {
  fc:	02000b93          	li	s7,32
      ++i;
      j = 0;
    } else {
      l_argv[i][j++] = ch;
 100:	06400c13          	li	s8,100
      xargs(argv, argc, l_argv, i);
 104:	320a8793          	addi	a5,s5,800
 108:	00878ab3          	add	s5,a5,s0
  while (read(0, &ch, 1)) {
 10c:	a03d                	j	13a <main+0x96>
      xargs(argv, argc, l_argv, i);
 10e:	0019869b          	addiw	a3,s3,1
 112:	8656                	mv	a2,s5
 114:	85ea                	mv	a1,s10
 116:	8566                	mv	a0,s9
 118:	00000097          	auipc	ra,0x0
 11c:	ee8080e7          	jalr	-280(ra) # 0 <xargs>
      memset(l_argv, 0, MAXARG * sizeof(char*));
 120:	10000613          	li	a2,256
 124:	4581                	li	a1,0
 126:	8556                	mv	a0,s5
 128:	00000097          	auipc	ra,0x0
 12c:	0b8080e7          	jalr	184(ra) # 1e0 <memset>
      j = 0;
 130:	4481                	li	s1,0
      i = 0;
 132:	4981                	li	s3,0
 134:	a019                	j	13a <main+0x96>
      ++i;
 136:	2985                	addiw	s3,s3,1
      j = 0;
 138:	4481                	li	s1,0
  while (read(0, &ch, 1)) {
 13a:	4605                	li	a2,1
 13c:	85d2                	mv	a1,s4
 13e:	4501                	li	a0,0
 140:	00000097          	auipc	ra,0x0
 144:	2b2080e7          	jalr	690(ra) # 3f2 <read>
 148:	cd19                	beqz	a0,166 <main+0xc2>
    if (ch == '\n') {
 14a:	37f94783          	lbu	a5,895(s2)
 14e:	fd6780e3          	beq	a5,s6,10e <main+0x6a>
    } else if (ch == ' ') {
 152:	ff7782e3          	beq	a5,s7,136 <main+0x92>
      l_argv[i][j++] = ch;
 156:	03898733          	mul	a4,s3,s8
 15a:	974a                	add	a4,a4,s2
 15c:	9726                	add	a4,a4,s1
 15e:	38f70023          	sb	a5,896(a4)
 162:	2485                	addiw	s1,s1,1
 164:	bfd9                	j	13a <main+0x96>
    }
  }
  exit(0);
 166:	00000097          	auipc	ra,0x0
 16a:	274080e7          	jalr	628(ra) # 3da <exit>

000000000000016e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0x8>
    ;
  return os;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb91                	beqz	a5,1a8 <strcmp+0x1e>
 196:	0005c703          	lbu	a4,0(a1)
 19a:	00f71763          	bne	a4,a5,1a8 <strcmp+0x1e>
    p++, q++;
 19e:	0505                	addi	a0,a0,1
 1a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbe5                	bnez	a5,196 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a8:	0005c503          	lbu	a0,0(a1)
}
 1ac:	40a7853b          	subw	a0,a5,a0
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strlen>:

uint
strlen(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cf91                	beqz	a5,1dc <strlen+0x26>
 1c2:	0505                	addi	a0,a0,1
 1c4:	87aa                	mv	a5,a0
 1c6:	86be                	mv	a3,a5
 1c8:	0785                	addi	a5,a5,1
 1ca:	fff7c703          	lbu	a4,-1(a5)
 1ce:	ff65                	bnez	a4,1c6 <strlen+0x10>
 1d0:	40a6853b          	subw	a0,a3,a0
 1d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret
  for(n = 0; s[n]; n++)
 1dc:	4501                	li	a0,0
 1de:	bfe5                	j	1d6 <strlen+0x20>

00000000000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e422                	sd	s0,8(sp)
 1e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e6:	ca19                	beqz	a2,1fc <memset+0x1c>
 1e8:	87aa                	mv	a5,a0
 1ea:	1602                	slli	a2,a2,0x20
 1ec:	9201                	srli	a2,a2,0x20
 1ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f6:	0785                	addi	a5,a5,1
 1f8:	fee79de3          	bne	a5,a4,1f2 <memset+0x12>
  }
  return dst;
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <strchr>:

char*
strchr(const char *s, char c)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  for(; *s; s++)
 208:	00054783          	lbu	a5,0(a0)
 20c:	cb99                	beqz	a5,222 <strchr+0x20>
    if(*s == c)
 20e:	00f58763          	beq	a1,a5,21c <strchr+0x1a>
  for(; *s; s++)
 212:	0505                	addi	a0,a0,1
 214:	00054783          	lbu	a5,0(a0)
 218:	fbfd                	bnez	a5,20e <strchr+0xc>
      return (char*)s;
  return 0;
 21a:	4501                	li	a0,0
}
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  return 0;
 222:	4501                	li	a0,0
 224:	bfe5                	j	21c <strchr+0x1a>

0000000000000226 <gets>:

char*
gets(char *buf, int max)
{
 226:	711d                	addi	sp,sp,-96
 228:	ec86                	sd	ra,88(sp)
 22a:	e8a2                	sd	s0,80(sp)
 22c:	e4a6                	sd	s1,72(sp)
 22e:	e0ca                	sd	s2,64(sp)
 230:	fc4e                	sd	s3,56(sp)
 232:	f852                	sd	s4,48(sp)
 234:	f456                	sd	s5,40(sp)
 236:	f05a                	sd	s6,32(sp)
 238:	ec5e                	sd	s7,24(sp)
 23a:	1080                	addi	s0,sp,96
 23c:	8baa                	mv	s7,a0
 23e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 240:	892a                	mv	s2,a0
 242:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 244:	4aa9                	li	s5,10
 246:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 248:	89a6                	mv	s3,s1
 24a:	2485                	addiw	s1,s1,1
 24c:	0344d863          	bge	s1,s4,27c <gets+0x56>
    cc = read(0, &c, 1);
 250:	4605                	li	a2,1
 252:	faf40593          	addi	a1,s0,-81
 256:	4501                	li	a0,0
 258:	00000097          	auipc	ra,0x0
 25c:	19a080e7          	jalr	410(ra) # 3f2 <read>
    if(cc < 1)
 260:	00a05e63          	blez	a0,27c <gets+0x56>
    buf[i++] = c;
 264:	faf44783          	lbu	a5,-81(s0)
 268:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 26c:	01578763          	beq	a5,s5,27a <gets+0x54>
 270:	0905                	addi	s2,s2,1
 272:	fd679be3          	bne	a5,s6,248 <gets+0x22>
  for(i=0; i+1 < max; ){
 276:	89a6                	mv	s3,s1
 278:	a011                	j	27c <gets+0x56>
 27a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 27c:	99de                	add	s3,s3,s7
 27e:	00098023          	sb	zero,0(s3)
  return buf;
}
 282:	855e                	mv	a0,s7
 284:	60e6                	ld	ra,88(sp)
 286:	6446                	ld	s0,80(sp)
 288:	64a6                	ld	s1,72(sp)
 28a:	6906                	ld	s2,64(sp)
 28c:	79e2                	ld	s3,56(sp)
 28e:	7a42                	ld	s4,48(sp)
 290:	7aa2                	ld	s5,40(sp)
 292:	7b02                	ld	s6,32(sp)
 294:	6be2                	ld	s7,24(sp)
 296:	6125                	addi	sp,sp,96
 298:	8082                	ret

000000000000029a <stat>:

int
stat(const char *n, struct stat *st)
{
 29a:	1101                	addi	sp,sp,-32
 29c:	ec06                	sd	ra,24(sp)
 29e:	e822                	sd	s0,16(sp)
 2a0:	e426                	sd	s1,8(sp)
 2a2:	e04a                	sd	s2,0(sp)
 2a4:	1000                	addi	s0,sp,32
 2a6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a8:	4581                	li	a1,0
 2aa:	00000097          	auipc	ra,0x0
 2ae:	170080e7          	jalr	368(ra) # 41a <open>
  if(fd < 0)
 2b2:	02054563          	bltz	a0,2dc <stat+0x42>
 2b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b8:	85ca                	mv	a1,s2
 2ba:	00000097          	auipc	ra,0x0
 2be:	178080e7          	jalr	376(ra) # 432 <fstat>
 2c2:	892a                	mv	s2,a0
  close(fd);
 2c4:	8526                	mv	a0,s1
 2c6:	00000097          	auipc	ra,0x0
 2ca:	13c080e7          	jalr	316(ra) # 402 <close>
  return r;
}
 2ce:	854a                	mv	a0,s2
 2d0:	60e2                	ld	ra,24(sp)
 2d2:	6442                	ld	s0,16(sp)
 2d4:	64a2                	ld	s1,8(sp)
 2d6:	6902                	ld	s2,0(sp)
 2d8:	6105                	addi	sp,sp,32
 2da:	8082                	ret
    return -1;
 2dc:	597d                	li	s2,-1
 2de:	bfc5                	j	2ce <stat+0x34>

00000000000002e0 <atoi>:

int
atoi(const char *s)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e6:	00054683          	lbu	a3,0(a0)
 2ea:	fd06879b          	addiw	a5,a3,-48
 2ee:	0ff7f793          	zext.b	a5,a5
 2f2:	4625                	li	a2,9
 2f4:	02f66863          	bltu	a2,a5,324 <atoi+0x44>
 2f8:	872a                	mv	a4,a0
  n = 0;
 2fa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2fc:	0705                	addi	a4,a4,1
 2fe:	0025179b          	slliw	a5,a0,0x2
 302:	9fa9                	addw	a5,a5,a0
 304:	0017979b          	slliw	a5,a5,0x1
 308:	9fb5                	addw	a5,a5,a3
 30a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 30e:	00074683          	lbu	a3,0(a4)
 312:	fd06879b          	addiw	a5,a3,-48
 316:	0ff7f793          	zext.b	a5,a5
 31a:	fef671e3          	bgeu	a2,a5,2fc <atoi+0x1c>
  return n;
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret
  n = 0;
 324:	4501                	li	a0,0
 326:	bfe5                	j	31e <atoi+0x3e>

0000000000000328 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e422                	sd	s0,8(sp)
 32c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 32e:	02b57463          	bgeu	a0,a1,356 <memmove+0x2e>
    while(n-- > 0)
 332:	00c05f63          	blez	a2,350 <memmove+0x28>
 336:	1602                	slli	a2,a2,0x20
 338:	9201                	srli	a2,a2,0x20
 33a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 33e:	872a                	mv	a4,a0
      *dst++ = *src++;
 340:	0585                	addi	a1,a1,1
 342:	0705                	addi	a4,a4,1
 344:	fff5c683          	lbu	a3,-1(a1)
 348:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 34c:	fee79ae3          	bne	a5,a4,340 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
    dst += n;
 356:	00c50733          	add	a4,a0,a2
    src += n;
 35a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 35c:	fec05ae3          	blez	a2,350 <memmove+0x28>
 360:	fff6079b          	addiw	a5,a2,-1
 364:	1782                	slli	a5,a5,0x20
 366:	9381                	srli	a5,a5,0x20
 368:	fff7c793          	not	a5,a5
 36c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36e:	15fd                	addi	a1,a1,-1
 370:	177d                	addi	a4,a4,-1
 372:	0005c683          	lbu	a3,0(a1)
 376:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 37a:	fee79ae3          	bne	a5,a4,36e <memmove+0x46>
 37e:	bfc9                	j	350 <memmove+0x28>

0000000000000380 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e422                	sd	s0,8(sp)
 384:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 386:	ca05                	beqz	a2,3b6 <memcmp+0x36>
 388:	fff6069b          	addiw	a3,a2,-1
 38c:	1682                	slli	a3,a3,0x20
 38e:	9281                	srli	a3,a3,0x20
 390:	0685                	addi	a3,a3,1
 392:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 394:	00054783          	lbu	a5,0(a0)
 398:	0005c703          	lbu	a4,0(a1)
 39c:	00e79863          	bne	a5,a4,3ac <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3a0:	0505                	addi	a0,a0,1
    p2++;
 3a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a4:	fed518e3          	bne	a0,a3,394 <memcmp+0x14>
  }
  return 0;
 3a8:	4501                	li	a0,0
 3aa:	a019                	j	3b0 <memcmp+0x30>
      return *p1 - *p2;
 3ac:	40e7853b          	subw	a0,a5,a4
}
 3b0:	6422                	ld	s0,8(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret
  return 0;
 3b6:	4501                	li	a0,0
 3b8:	bfe5                	j	3b0 <memcmp+0x30>

00000000000003ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e406                	sd	ra,8(sp)
 3be:	e022                	sd	s0,0(sp)
 3c0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c2:	00000097          	auipc	ra,0x0
 3c6:	f66080e7          	jalr	-154(ra) # 328 <memmove>
}
 3ca:	60a2                	ld	ra,8(sp)
 3cc:	6402                	ld	s0,0(sp)
 3ce:	0141                	addi	sp,sp,16
 3d0:	8082                	ret

00000000000003d2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3d2:	4885                	li	a7,1
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <exit>:
.global exit
exit:
 li a7, SYS_exit
 3da:	4889                	li	a7,2
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e2:	488d                	li	a7,3
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ea:	4891                	li	a7,4
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <read>:
.global read
read:
 li a7, SYS_read
 3f2:	4895                	li	a7,5
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <write>:
.global write
write:
 li a7, SYS_write
 3fa:	48c1                	li	a7,16
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <close>:
.global close
close:
 li a7, SYS_close
 402:	48d5                	li	a7,21
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <kill>:
.global kill
kill:
 li a7, SYS_kill
 40a:	4899                	li	a7,6
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <exec>:
.global exec
exec:
 li a7, SYS_exec
 412:	489d                	li	a7,7
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <open>:
.global open
open:
 li a7, SYS_open
 41a:	48bd                	li	a7,15
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 422:	48c5                	li	a7,17
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 42a:	48c9                	li	a7,18
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 432:	48a1                	li	a7,8
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <link>:
.global link
link:
 li a7, SYS_link
 43a:	48cd                	li	a7,19
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 442:	48d1                	li	a7,20
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 44a:	48a5                	li	a7,9
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <dup>:
.global dup
dup:
 li a7, SYS_dup
 452:	48a9                	li	a7,10
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 45a:	48ad                	li	a7,11
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 462:	48b1                	li	a7,12
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 46a:	48b5                	li	a7,13
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 472:	48b9                	li	a7,14
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 47a:	1101                	addi	sp,sp,-32
 47c:	ec06                	sd	ra,24(sp)
 47e:	e822                	sd	s0,16(sp)
 480:	1000                	addi	s0,sp,32
 482:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 486:	4605                	li	a2,1
 488:	fef40593          	addi	a1,s0,-17
 48c:	00000097          	auipc	ra,0x0
 490:	f6e080e7          	jalr	-146(ra) # 3fa <write>
}
 494:	60e2                	ld	ra,24(sp)
 496:	6442                	ld	s0,16(sp)
 498:	6105                	addi	sp,sp,32
 49a:	8082                	ret

000000000000049c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49c:	7139                	addi	sp,sp,-64
 49e:	fc06                	sd	ra,56(sp)
 4a0:	f822                	sd	s0,48(sp)
 4a2:	f426                	sd	s1,40(sp)
 4a4:	f04a                	sd	s2,32(sp)
 4a6:	ec4e                	sd	s3,24(sp)
 4a8:	0080                	addi	s0,sp,64
 4aa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ac:	c299                	beqz	a3,4b2 <printint+0x16>
 4ae:	0805c963          	bltz	a1,540 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4b2:	2581                	sext.w	a1,a1
  neg = 0;
 4b4:	4881                	li	a7,0
 4b6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4ba:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4bc:	2601                	sext.w	a2,a2
 4be:	00000517          	auipc	a0,0x0
 4c2:	48250513          	addi	a0,a0,1154 # 940 <digits>
 4c6:	883a                	mv	a6,a4
 4c8:	2705                	addiw	a4,a4,1
 4ca:	02c5f7bb          	remuw	a5,a1,a2
 4ce:	1782                	slli	a5,a5,0x20
 4d0:	9381                	srli	a5,a5,0x20
 4d2:	97aa                	add	a5,a5,a0
 4d4:	0007c783          	lbu	a5,0(a5)
 4d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4dc:	0005879b          	sext.w	a5,a1
 4e0:	02c5d5bb          	divuw	a1,a1,a2
 4e4:	0685                	addi	a3,a3,1
 4e6:	fec7f0e3          	bgeu	a5,a2,4c6 <printint+0x2a>
  if(neg)
 4ea:	00088c63          	beqz	a7,502 <printint+0x66>
    buf[i++] = '-';
 4ee:	fd070793          	addi	a5,a4,-48
 4f2:	00878733          	add	a4,a5,s0
 4f6:	02d00793          	li	a5,45
 4fa:	fef70823          	sb	a5,-16(a4)
 4fe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 502:	02e05863          	blez	a4,532 <printint+0x96>
 506:	fc040793          	addi	a5,s0,-64
 50a:	00e78933          	add	s2,a5,a4
 50e:	fff78993          	addi	s3,a5,-1
 512:	99ba                	add	s3,s3,a4
 514:	377d                	addiw	a4,a4,-1
 516:	1702                	slli	a4,a4,0x20
 518:	9301                	srli	a4,a4,0x20
 51a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 51e:	fff94583          	lbu	a1,-1(s2)
 522:	8526                	mv	a0,s1
 524:	00000097          	auipc	ra,0x0
 528:	f56080e7          	jalr	-170(ra) # 47a <putc>
  while(--i >= 0)
 52c:	197d                	addi	s2,s2,-1
 52e:	ff3918e3          	bne	s2,s3,51e <printint+0x82>
}
 532:	70e2                	ld	ra,56(sp)
 534:	7442                	ld	s0,48(sp)
 536:	74a2                	ld	s1,40(sp)
 538:	7902                	ld	s2,32(sp)
 53a:	69e2                	ld	s3,24(sp)
 53c:	6121                	addi	sp,sp,64
 53e:	8082                	ret
    x = -xx;
 540:	40b005bb          	negw	a1,a1
    neg = 1;
 544:	4885                	li	a7,1
    x = -xx;
 546:	bf85                	j	4b6 <printint+0x1a>

0000000000000548 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 548:	715d                	addi	sp,sp,-80
 54a:	e486                	sd	ra,72(sp)
 54c:	e0a2                	sd	s0,64(sp)
 54e:	fc26                	sd	s1,56(sp)
 550:	f84a                	sd	s2,48(sp)
 552:	f44e                	sd	s3,40(sp)
 554:	f052                	sd	s4,32(sp)
 556:	ec56                	sd	s5,24(sp)
 558:	e85a                	sd	s6,16(sp)
 55a:	e45e                	sd	s7,8(sp)
 55c:	e062                	sd	s8,0(sp)
 55e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 560:	0005c903          	lbu	s2,0(a1)
 564:	18090c63          	beqz	s2,6fc <vprintf+0x1b4>
 568:	8aaa                	mv	s5,a0
 56a:	8bb2                	mv	s7,a2
 56c:	00158493          	addi	s1,a1,1
  state = 0;
 570:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 572:	02500a13          	li	s4,37
 576:	4b55                	li	s6,21
 578:	a839                	j	596 <vprintf+0x4e>
        putc(fd, c);
 57a:	85ca                	mv	a1,s2
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	efc080e7          	jalr	-260(ra) # 47a <putc>
 586:	a019                	j	58c <vprintf+0x44>
    } else if(state == '%'){
 588:	01498d63          	beq	s3,s4,5a2 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 58c:	0485                	addi	s1,s1,1
 58e:	fff4c903          	lbu	s2,-1(s1)
 592:	16090563          	beqz	s2,6fc <vprintf+0x1b4>
    if(state == 0){
 596:	fe0999e3          	bnez	s3,588 <vprintf+0x40>
      if(c == '%'){
 59a:	ff4910e3          	bne	s2,s4,57a <vprintf+0x32>
        state = '%';
 59e:	89d2                	mv	s3,s4
 5a0:	b7f5                	j	58c <vprintf+0x44>
      if(c == 'd'){
 5a2:	13490263          	beq	s2,s4,6c6 <vprintf+0x17e>
 5a6:	f9d9079b          	addiw	a5,s2,-99
 5aa:	0ff7f793          	zext.b	a5,a5
 5ae:	12fb6563          	bltu	s6,a5,6d8 <vprintf+0x190>
 5b2:	f9d9079b          	addiw	a5,s2,-99
 5b6:	0ff7f713          	zext.b	a4,a5
 5ba:	10eb6f63          	bltu	s6,a4,6d8 <vprintf+0x190>
 5be:	00271793          	slli	a5,a4,0x2
 5c2:	00000717          	auipc	a4,0x0
 5c6:	32670713          	addi	a4,a4,806 # 8e8 <malloc+0xee>
 5ca:	97ba                	add	a5,a5,a4
 5cc:	439c                	lw	a5,0(a5)
 5ce:	97ba                	add	a5,a5,a4
 5d0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4685                	li	a3,1
 5d8:	4629                	li	a2,10
 5da:	000ba583          	lw	a1,0(s7)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	ebc080e7          	jalr	-324(ra) # 49c <printint>
 5e8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b745                	j	58c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4629                	li	a2,10
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	ea0080e7          	jalr	-352(ra) # 49c <printint>
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	b751                	j	58c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 60a:	008b8913          	addi	s2,s7,8
 60e:	4681                	li	a3,0
 610:	4641                	li	a2,16
 612:	000ba583          	lw	a1,0(s7)
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	e84080e7          	jalr	-380(ra) # 49c <printint>
 620:	8bca                	mv	s7,s2
      state = 0;
 622:	4981                	li	s3,0
 624:	b7a5                	j	58c <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 626:	008b8c13          	addi	s8,s7,8
 62a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 62e:	03000593          	li	a1,48
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	e46080e7          	jalr	-442(ra) # 47a <putc>
  putc(fd, 'x');
 63c:	07800593          	li	a1,120
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	e38080e7          	jalr	-456(ra) # 47a <putc>
 64a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 64c:	00000b97          	auipc	s7,0x0
 650:	2f4b8b93          	addi	s7,s7,756 # 940 <digits>
 654:	03c9d793          	srli	a5,s3,0x3c
 658:	97de                	add	a5,a5,s7
 65a:	0007c583          	lbu	a1,0(a5)
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	e1a080e7          	jalr	-486(ra) # 47a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 668:	0992                	slli	s3,s3,0x4
 66a:	397d                	addiw	s2,s2,-1
 66c:	fe0914e3          	bnez	s2,654 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 670:	8be2                	mv	s7,s8
      state = 0;
 672:	4981                	li	s3,0
 674:	bf21                	j	58c <vprintf+0x44>
        s = va_arg(ap, char*);
 676:	008b8993          	addi	s3,s7,8
 67a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 67e:	02090163          	beqz	s2,6a0 <vprintf+0x158>
        while(*s != 0){
 682:	00094583          	lbu	a1,0(s2)
 686:	c9a5                	beqz	a1,6f6 <vprintf+0x1ae>
          putc(fd, *s);
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	df0080e7          	jalr	-528(ra) # 47a <putc>
          s++;
 692:	0905                	addi	s2,s2,1
        while(*s != 0){
 694:	00094583          	lbu	a1,0(s2)
 698:	f9e5                	bnez	a1,688 <vprintf+0x140>
        s = va_arg(ap, char*);
 69a:	8bce                	mv	s7,s3
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b5fd                	j	58c <vprintf+0x44>
          s = "(null)";
 6a0:	00000917          	auipc	s2,0x0
 6a4:	24090913          	addi	s2,s2,576 # 8e0 <malloc+0xe6>
        while(*s != 0){
 6a8:	02800593          	li	a1,40
 6ac:	bff1                	j	688 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 6ae:	008b8913          	addi	s2,s7,8
 6b2:	000bc583          	lbu	a1,0(s7)
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	dc2080e7          	jalr	-574(ra) # 47a <putc>
 6c0:	8bca                	mv	s7,s2
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b5e1                	j	58c <vprintf+0x44>
        putc(fd, c);
 6c6:	02500593          	li	a1,37
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	dae080e7          	jalr	-594(ra) # 47a <putc>
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bd5d                	j	58c <vprintf+0x44>
        putc(fd, '%');
 6d8:	02500593          	li	a1,37
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	d9c080e7          	jalr	-612(ra) # 47a <putc>
        putc(fd, c);
 6e6:	85ca                	mv	a1,s2
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	d90080e7          	jalr	-624(ra) # 47a <putc>
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bd61                	j	58c <vprintf+0x44>
        s = va_arg(ap, char*);
 6f6:	8bce                	mv	s7,s3
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	bd49                	j	58c <vprintf+0x44>
    }
  }
}
 6fc:	60a6                	ld	ra,72(sp)
 6fe:	6406                	ld	s0,64(sp)
 700:	74e2                	ld	s1,56(sp)
 702:	7942                	ld	s2,48(sp)
 704:	79a2                	ld	s3,40(sp)
 706:	7a02                	ld	s4,32(sp)
 708:	6ae2                	ld	s5,24(sp)
 70a:	6b42                	ld	s6,16(sp)
 70c:	6ba2                	ld	s7,8(sp)
 70e:	6c02                	ld	s8,0(sp)
 710:	6161                	addi	sp,sp,80
 712:	8082                	ret

0000000000000714 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 714:	715d                	addi	sp,sp,-80
 716:	ec06                	sd	ra,24(sp)
 718:	e822                	sd	s0,16(sp)
 71a:	1000                	addi	s0,sp,32
 71c:	e010                	sd	a2,0(s0)
 71e:	e414                	sd	a3,8(s0)
 720:	e818                	sd	a4,16(s0)
 722:	ec1c                	sd	a5,24(s0)
 724:	03043023          	sd	a6,32(s0)
 728:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 72c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 730:	8622                	mv	a2,s0
 732:	00000097          	auipc	ra,0x0
 736:	e16080e7          	jalr	-490(ra) # 548 <vprintf>
}
 73a:	60e2                	ld	ra,24(sp)
 73c:	6442                	ld	s0,16(sp)
 73e:	6161                	addi	sp,sp,80
 740:	8082                	ret

0000000000000742 <printf>:

void
printf(const char *fmt, ...)
{
 742:	711d                	addi	sp,sp,-96
 744:	ec06                	sd	ra,24(sp)
 746:	e822                	sd	s0,16(sp)
 748:	1000                	addi	s0,sp,32
 74a:	e40c                	sd	a1,8(s0)
 74c:	e810                	sd	a2,16(s0)
 74e:	ec14                	sd	a3,24(s0)
 750:	f018                	sd	a4,32(s0)
 752:	f41c                	sd	a5,40(s0)
 754:	03043823          	sd	a6,48(s0)
 758:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 75c:	00840613          	addi	a2,s0,8
 760:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 764:	85aa                	mv	a1,a0
 766:	4505                	li	a0,1
 768:	00000097          	auipc	ra,0x0
 76c:	de0080e7          	jalr	-544(ra) # 548 <vprintf>
}
 770:	60e2                	ld	ra,24(sp)
 772:	6442                	ld	s0,16(sp)
 774:	6125                	addi	sp,sp,96
 776:	8082                	ret

0000000000000778 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	1141                	addi	sp,sp,-16
 77a:	e422                	sd	s0,8(sp)
 77c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 782:	00000797          	auipc	a5,0x0
 786:	1d67b783          	ld	a5,470(a5) # 958 <freep>
 78a:	a02d                	j	7b4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 78c:	4618                	lw	a4,8(a2)
 78e:	9f2d                	addw	a4,a4,a1
 790:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 794:	6398                	ld	a4,0(a5)
 796:	6310                	ld	a2,0(a4)
 798:	a83d                	j	7d6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 79a:	ff852703          	lw	a4,-8(a0)
 79e:	9f31                	addw	a4,a4,a2
 7a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a2:	ff053683          	ld	a3,-16(a0)
 7a6:	a091                	j	7ea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	6398                	ld	a4,0(a5)
 7aa:	00e7e463          	bltu	a5,a4,7b2 <free+0x3a>
 7ae:	00e6ea63          	bltu	a3,a4,7c2 <free+0x4a>
{
 7b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	fed7fae3          	bgeu	a5,a3,7a8 <free+0x30>
 7b8:	6398                	ld	a4,0(a5)
 7ba:	00e6e463          	bltu	a3,a4,7c2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	fee7eae3          	bltu	a5,a4,7b2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7c2:	ff852583          	lw	a1,-8(a0)
 7c6:	6390                	ld	a2,0(a5)
 7c8:	02059813          	slli	a6,a1,0x20
 7cc:	01c85713          	srli	a4,a6,0x1c
 7d0:	9736                	add	a4,a4,a3
 7d2:	fae60de3          	beq	a2,a4,78c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7da:	4790                	lw	a2,8(a5)
 7dc:	02061593          	slli	a1,a2,0x20
 7e0:	01c5d713          	srli	a4,a1,0x1c
 7e4:	973e                	add	a4,a4,a5
 7e6:	fae68ae3          	beq	a3,a4,79a <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ec:	00000717          	auipc	a4,0x0
 7f0:	16f73623          	sd	a5,364(a4) # 958 <freep>
}
 7f4:	6422                	ld	s0,8(sp)
 7f6:	0141                	addi	sp,sp,16
 7f8:	8082                	ret

00000000000007fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7fa:	7139                	addi	sp,sp,-64
 7fc:	fc06                	sd	ra,56(sp)
 7fe:	f822                	sd	s0,48(sp)
 800:	f426                	sd	s1,40(sp)
 802:	f04a                	sd	s2,32(sp)
 804:	ec4e                	sd	s3,24(sp)
 806:	e852                	sd	s4,16(sp)
 808:	e456                	sd	s5,8(sp)
 80a:	e05a                	sd	s6,0(sp)
 80c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80e:	02051493          	slli	s1,a0,0x20
 812:	9081                	srli	s1,s1,0x20
 814:	04bd                	addi	s1,s1,15
 816:	8091                	srli	s1,s1,0x4
 818:	0014899b          	addiw	s3,s1,1
 81c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 81e:	00000517          	auipc	a0,0x0
 822:	13a53503          	ld	a0,314(a0) # 958 <freep>
 826:	c515                	beqz	a0,852 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82a:	4798                	lw	a4,8(a5)
 82c:	02977f63          	bgeu	a4,s1,86a <malloc+0x70>
  if(nu < 4096)
 830:	8a4e                	mv	s4,s3
 832:	0009871b          	sext.w	a4,s3
 836:	6685                	lui	a3,0x1
 838:	00d77363          	bgeu	a4,a3,83e <malloc+0x44>
 83c:	6a05                	lui	s4,0x1
 83e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 842:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 846:	00000917          	auipc	s2,0x0
 84a:	11290913          	addi	s2,s2,274 # 958 <freep>
  if(p == (char*)-1)
 84e:	5afd                	li	s5,-1
 850:	a895                	j	8c4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 852:	00000797          	auipc	a5,0x0
 856:	10e78793          	addi	a5,a5,270 # 960 <base>
 85a:	00000717          	auipc	a4,0x0
 85e:	0ef73f23          	sd	a5,254(a4) # 958 <freep>
 862:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 864:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 868:	b7e1                	j	830 <malloc+0x36>
      if(p->s.size == nunits)
 86a:	02e48c63          	beq	s1,a4,8a2 <malloc+0xa8>
        p->s.size -= nunits;
 86e:	4137073b          	subw	a4,a4,s3
 872:	c798                	sw	a4,8(a5)
        p += p->s.size;
 874:	02071693          	slli	a3,a4,0x20
 878:	01c6d713          	srli	a4,a3,0x1c
 87c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 882:	00000717          	auipc	a4,0x0
 886:	0ca73b23          	sd	a0,214(a4) # 958 <freep>
      return (void*)(p + 1);
 88a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 88e:	70e2                	ld	ra,56(sp)
 890:	7442                	ld	s0,48(sp)
 892:	74a2                	ld	s1,40(sp)
 894:	7902                	ld	s2,32(sp)
 896:	69e2                	ld	s3,24(sp)
 898:	6a42                	ld	s4,16(sp)
 89a:	6aa2                	ld	s5,8(sp)
 89c:	6b02                	ld	s6,0(sp)
 89e:	6121                	addi	sp,sp,64
 8a0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8a2:	6398                	ld	a4,0(a5)
 8a4:	e118                	sd	a4,0(a0)
 8a6:	bff1                	j	882 <malloc+0x88>
  hp->s.size = nu;
 8a8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ac:	0541                	addi	a0,a0,16
 8ae:	00000097          	auipc	ra,0x0
 8b2:	eca080e7          	jalr	-310(ra) # 778 <free>
  return freep;
 8b6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ba:	d971                	beqz	a0,88e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8be:	4798                	lw	a4,8(a5)
 8c0:	fa9775e3          	bgeu	a4,s1,86a <malloc+0x70>
    if(p == freep)
 8c4:	00093703          	ld	a4,0(s2)
 8c8:	853e                	mv	a0,a5
 8ca:	fef719e3          	bne	a4,a5,8bc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8ce:	8552                	mv	a0,s4
 8d0:	00000097          	auipc	ra,0x0
 8d4:	b92080e7          	jalr	-1134(ra) # 462 <sbrk>
  if(p == (char*)-1)
 8d8:	fd5518e3          	bne	a0,s5,8a8 <malloc+0xae>
        return 0;
 8dc:	4501                	li	a0,0
 8de:	bf45                	j	88e <malloc+0x94>
