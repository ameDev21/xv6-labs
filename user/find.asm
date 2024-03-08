
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	336080e7          	jalr	822(ra) # 346 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	30a080e7          	jalr	778(ra) # 346 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2e8080e7          	jalr	744(ra) # 346 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	af298993          	addi	s3,s3,-1294 # b58 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	442080e7          	jalr	1090(ra) # 4b8 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2c6080e7          	jalr	710(ra) # 346 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2b8080e7          	jalr	696(ra) # 346 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	2c8080e7          	jalr	712(ra) # 370 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <find>:

void
find(char *path, char *fname)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  d8:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  da:	4581                	li	a1,0
  dc:	00000097          	auipc	ra,0x0
  e0:	4ce080e7          	jalr	1230(ra) # 5aa <open>
  e4:	06054d63          	bltz	a0,15e <find+0xaa>
  e8:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  ea:	d9840593          	addi	a1,s0,-616
  ee:	00000097          	auipc	ra,0x0
  f2:	4d4080e7          	jalr	1236(ra) # 5c2 <fstat>
  f6:	06054f63          	bltz	a0,174 <find+0xc0>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  fa:	da041783          	lh	a5,-608(s0)
  fe:	4705                	li	a4,1
 100:	08e78a63          	beq	a5,a4,194 <find+0xe0>
 104:	4709                	li	a4,2
 106:	02e79663          	bne	a5,a4,132 <find+0x7e>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 10a:	854a                	mv	a0,s2
 10c:	00000097          	auipc	ra,0x0
 110:	ef4080e7          	jalr	-268(ra) # 0 <fmtname>
 114:	85aa                	mv	a1,a0
 116:	da843703          	ld	a4,-600(s0)
 11a:	d9c42683          	lw	a3,-612(s0)
 11e:	da041603          	lh	a2,-608(s0)
 122:	00001517          	auipc	a0,0x1
 126:	97e50513          	addi	a0,a0,-1666 # aa0 <malloc+0x116>
 12a:	00000097          	auipc	ra,0x0
 12e:	7a8080e7          	jalr	1960(ra) # 8d2 <printf>
        }
      }
    }
    break;
  }
  close(fd);
 132:	8526                	mv	a0,s1
 134:	00000097          	auipc	ra,0x0
 138:	45e080e7          	jalr	1118(ra) # 592 <close>
}
 13c:	26813083          	ld	ra,616(sp)
 140:	26013403          	ld	s0,608(sp)
 144:	25813483          	ld	s1,600(sp)
 148:	25013903          	ld	s2,592(sp)
 14c:	24813983          	ld	s3,584(sp)
 150:	24013a03          	ld	s4,576(sp)
 154:	23813a83          	ld	s5,568(sp)
 158:	27010113          	addi	sp,sp,624
 15c:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 15e:	864a                	mv	a2,s2
 160:	00001597          	auipc	a1,0x1
 164:	91058593          	addi	a1,a1,-1776 # a70 <malloc+0xe6>
 168:	4509                	li	a0,2
 16a:	00000097          	auipc	ra,0x0
 16e:	73a080e7          	jalr	1850(ra) # 8a4 <fprintf>
    return;
 172:	b7e9                	j	13c <find+0x88>
    fprintf(2, "ls: cannot stat %s\n", path);
 174:	864a                	mv	a2,s2
 176:	00001597          	auipc	a1,0x1
 17a:	91258593          	addi	a1,a1,-1774 # a88 <malloc+0xfe>
 17e:	4509                	li	a0,2
 180:	00000097          	auipc	ra,0x0
 184:	724080e7          	jalr	1828(ra) # 8a4 <fprintf>
    close(fd);
 188:	8526                	mv	a0,s1
 18a:	00000097          	auipc	ra,0x0
 18e:	408080e7          	jalr	1032(ra) # 592 <close>
    return;
 192:	b76d                	j	13c <find+0x88>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 194:	854a                	mv	a0,s2
 196:	00000097          	auipc	ra,0x0
 19a:	1b0080e7          	jalr	432(ra) # 346 <strlen>
 19e:	2541                	addiw	a0,a0,16
 1a0:	20000793          	li	a5,512
 1a4:	00a7fb63          	bgeu	a5,a0,1ba <find+0x106>
      printf("ls: path too long\n");
 1a8:	00001517          	auipc	a0,0x1
 1ac:	90850513          	addi	a0,a0,-1784 # ab0 <malloc+0x126>
 1b0:	00000097          	auipc	ra,0x0
 1b4:	722080e7          	jalr	1826(ra) # 8d2 <printf>
      break;
 1b8:	bfad                	j	132 <find+0x7e>
    strcpy(buf, path);
 1ba:	85ca                	mv	a1,s2
 1bc:	dc040513          	addi	a0,s0,-576
 1c0:	00000097          	auipc	ra,0x0
 1c4:	13e080e7          	jalr	318(ra) # 2fe <strcpy>
    p = buf+strlen(buf);
 1c8:	dc040513          	addi	a0,s0,-576
 1cc:	00000097          	auipc	ra,0x0
 1d0:	17a080e7          	jalr	378(ra) # 346 <strlen>
 1d4:	1502                	slli	a0,a0,0x20
 1d6:	9101                	srli	a0,a0,0x20
 1d8:	dc040793          	addi	a5,s0,-576
 1dc:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1e0:	00190a13          	addi	s4,s2,1
 1e4:	02f00793          	li	a5,47
 1e8:	00f90023          	sb	a5,0(s2)
      if (st.type == 1 && strcmp(p, ".") && strcmp(p, "..")) {
 1ec:	4a85                	li	s5,1
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ee:	4641                	li	a2,16
 1f0:	db040593          	addi	a1,s0,-592
 1f4:	8526                	mv	a0,s1
 1f6:	00000097          	auipc	ra,0x0
 1fa:	38c080e7          	jalr	908(ra) # 582 <read>
 1fe:	47c1                	li	a5,16
 200:	f2f519e3          	bne	a0,a5,132 <find+0x7e>
      if(de.inum == 0)
 204:	db045783          	lhu	a5,-592(s0)
 208:	d3fd                	beqz	a5,1ee <find+0x13a>
      memmove(p, de.name, DIRSIZ);
 20a:	4639                	li	a2,14
 20c:	db240593          	addi	a1,s0,-590
 210:	8552                	mv	a0,s4
 212:	00000097          	auipc	ra,0x0
 216:	2a6080e7          	jalr	678(ra) # 4b8 <memmove>
      p[DIRSIZ] = 0;
 21a:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 21e:	d9840593          	addi	a1,s0,-616
 222:	dc040513          	addi	a0,s0,-576
 226:	00000097          	auipc	ra,0x0
 22a:	204080e7          	jalr	516(ra) # 42a <stat>
 22e:	02054b63          	bltz	a0,264 <find+0x1b0>
      if (st.type == 1 && strcmp(p, ".") && strcmp(p, "..")) {
 232:	da041783          	lh	a5,-608(s0)
 236:	05578263          	beq	a5,s5,27a <find+0x1c6>
        if (!strcmp(de.name, fname)) {
 23a:	85ce                	mv	a1,s3
 23c:	db240513          	addi	a0,s0,-590
 240:	00000097          	auipc	ra,0x0
 244:	0da080e7          	jalr	218(ra) # 31a <strcmp>
 248:	f15d                	bnez	a0,1ee <find+0x13a>
          buf[sizeof(buf) - 2] = '\n';
 24a:	47a9                	li	a5,10
 24c:	faf40f23          	sb	a5,-66(s0)
          write(1, buf, buf_size);
 250:	1ff00613          	li	a2,511
 254:	dc040593          	addi	a1,s0,-576
 258:	4505                	li	a0,1
 25a:	00000097          	auipc	ra,0x0
 25e:	330080e7          	jalr	816(ra) # 58a <write>
 262:	b771                	j	1ee <find+0x13a>
        printf("ls: cannot stat %s\n", buf);
 264:	dc040593          	addi	a1,s0,-576
 268:	00001517          	auipc	a0,0x1
 26c:	82050513          	addi	a0,a0,-2016 # a88 <malloc+0xfe>
 270:	00000097          	auipc	ra,0x0
 274:	662080e7          	jalr	1634(ra) # 8d2 <printf>
        continue;
 278:	bf9d                	j	1ee <find+0x13a>
      if (st.type == 1 && strcmp(p, ".") && strcmp(p, "..")) {
 27a:	00001597          	auipc	a1,0x1
 27e:	84e58593          	addi	a1,a1,-1970 # ac8 <malloc+0x13e>
 282:	8552                	mv	a0,s4
 284:	00000097          	auipc	ra,0x0
 288:	096080e7          	jalr	150(ra) # 31a <strcmp>
 28c:	d55d                	beqz	a0,23a <find+0x186>
 28e:	00001597          	auipc	a1,0x1
 292:	84258593          	addi	a1,a1,-1982 # ad0 <malloc+0x146>
 296:	8552                	mv	a0,s4
 298:	00000097          	auipc	ra,0x0
 29c:	082080e7          	jalr	130(ra) # 31a <strcmp>
 2a0:	dd49                	beqz	a0,23a <find+0x186>
        find(buf, fname);
 2a2:	85ce                	mv	a1,s3
 2a4:	dc040513          	addi	a0,s0,-576
 2a8:	00000097          	auipc	ra,0x0
 2ac:	e0c080e7          	jalr	-500(ra) # b4 <find>
 2b0:	bf3d                	j	1ee <find+0x13a>

00000000000002b2 <main>:

int
main(int argc, char *argv[]) {
 2b2:	7179                	addi	sp,sp,-48
 2b4:	f406                	sd	ra,40(sp)
 2b6:	f022                	sd	s0,32(sp)
 2b8:	ec26                	sd	s1,24(sp)
 2ba:	e84a                	sd	s2,16(sp)
 2bc:	e44e                	sd	s3,8(sp)
 2be:	1800                	addi	s0,sp,48
  /* close(1); */
  /* int fd = open("output.txt", 1); */
  /* close(0); */
  /* dup(fd); */
  /* dup(fd[0]); */
  for (int i = 1; i < argc; ++i) {
 2c0:	4785                	li	a5,1
 2c2:	02a7d963          	bge	a5,a0,2f4 <main+0x42>
 2c6:	00858493          	addi	s1,a1,8
 2ca:	ffe5091b          	addiw	s2,a0,-2
 2ce:	02091793          	slli	a5,s2,0x20
 2d2:	01d7d913          	srli	s2,a5,0x1d
 2d6:	05c1                	addi	a1,a1,16
 2d8:	992e                	add	s2,s2,a1
    find(".", argv[i]);
 2da:	00000997          	auipc	s3,0x0
 2de:	7ee98993          	addi	s3,s3,2030 # ac8 <malloc+0x13e>
 2e2:	608c                	ld	a1,0(s1)
 2e4:	854e                	mv	a0,s3
 2e6:	00000097          	auipc	ra,0x0
 2ea:	dce080e7          	jalr	-562(ra) # b4 <find>
  for (int i = 1; i < argc; ++i) {
 2ee:	04a1                	addi	s1,s1,8
 2f0:	ff2499e3          	bne	s1,s2,2e2 <main+0x30>
  }
  exit(0);
 2f4:	4501                	li	a0,0
 2f6:	00000097          	auipc	ra,0x0
 2fa:	274080e7          	jalr	628(ra) # 56a <exit>

00000000000002fe <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 304:	87aa                	mv	a5,a0
 306:	0585                	addi	a1,a1,1
 308:	0785                	addi	a5,a5,1
 30a:	fff5c703          	lbu	a4,-1(a1)
 30e:	fee78fa3          	sb	a4,-1(a5)
 312:	fb75                	bnez	a4,306 <strcpy+0x8>
    ;
  return os;
}
 314:	6422                	ld	s0,8(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 320:	00054783          	lbu	a5,0(a0)
 324:	cb91                	beqz	a5,338 <strcmp+0x1e>
 326:	0005c703          	lbu	a4,0(a1)
 32a:	00f71763          	bne	a4,a5,338 <strcmp+0x1e>
    p++, q++;
 32e:	0505                	addi	a0,a0,1
 330:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 332:	00054783          	lbu	a5,0(a0)
 336:	fbe5                	bnez	a5,326 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 338:	0005c503          	lbu	a0,0(a1)
}
 33c:	40a7853b          	subw	a0,a5,a0
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret

0000000000000346 <strlen>:

uint
strlen(const char *s)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 34c:	00054783          	lbu	a5,0(a0)
 350:	cf91                	beqz	a5,36c <strlen+0x26>
 352:	0505                	addi	a0,a0,1
 354:	87aa                	mv	a5,a0
 356:	86be                	mv	a3,a5
 358:	0785                	addi	a5,a5,1
 35a:	fff7c703          	lbu	a4,-1(a5)
 35e:	ff65                	bnez	a4,356 <strlen+0x10>
 360:	40a6853b          	subw	a0,a3,a0
 364:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
  for(n = 0; s[n]; n++)
 36c:	4501                	li	a0,0
 36e:	bfe5                	j	366 <strlen+0x20>

0000000000000370 <memset>:

void*
memset(void *dst, int c, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 376:	ca19                	beqz	a2,38c <memset+0x1c>
 378:	87aa                	mv	a5,a0
 37a:	1602                	slli	a2,a2,0x20
 37c:	9201                	srli	a2,a2,0x20
 37e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 382:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 386:	0785                	addi	a5,a5,1
 388:	fee79de3          	bne	a5,a4,382 <memset+0x12>
  }
  return dst;
}
 38c:	6422                	ld	s0,8(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret

0000000000000392 <strchr>:

char*
strchr(const char *s, char c)
{
 392:	1141                	addi	sp,sp,-16
 394:	e422                	sd	s0,8(sp)
 396:	0800                	addi	s0,sp,16
  for(; *s; s++)
 398:	00054783          	lbu	a5,0(a0)
 39c:	cb99                	beqz	a5,3b2 <strchr+0x20>
    if(*s == c)
 39e:	00f58763          	beq	a1,a5,3ac <strchr+0x1a>
  for(; *s; s++)
 3a2:	0505                	addi	a0,a0,1
 3a4:	00054783          	lbu	a5,0(a0)
 3a8:	fbfd                	bnez	a5,39e <strchr+0xc>
      return (char*)s;
  return 0;
 3aa:	4501                	li	a0,0
}
 3ac:	6422                	ld	s0,8(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
  return 0;
 3b2:	4501                	li	a0,0
 3b4:	bfe5                	j	3ac <strchr+0x1a>

00000000000003b6 <gets>:

char*
gets(char *buf, int max)
{
 3b6:	711d                	addi	sp,sp,-96
 3b8:	ec86                	sd	ra,88(sp)
 3ba:	e8a2                	sd	s0,80(sp)
 3bc:	e4a6                	sd	s1,72(sp)
 3be:	e0ca                	sd	s2,64(sp)
 3c0:	fc4e                	sd	s3,56(sp)
 3c2:	f852                	sd	s4,48(sp)
 3c4:	f456                	sd	s5,40(sp)
 3c6:	f05a                	sd	s6,32(sp)
 3c8:	ec5e                	sd	s7,24(sp)
 3ca:	1080                	addi	s0,sp,96
 3cc:	8baa                	mv	s7,a0
 3ce:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3d0:	892a                	mv	s2,a0
 3d2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3d4:	4aa9                	li	s5,10
 3d6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3d8:	89a6                	mv	s3,s1
 3da:	2485                	addiw	s1,s1,1
 3dc:	0344d863          	bge	s1,s4,40c <gets+0x56>
    cc = read(0, &c, 1);
 3e0:	4605                	li	a2,1
 3e2:	faf40593          	addi	a1,s0,-81
 3e6:	4501                	li	a0,0
 3e8:	00000097          	auipc	ra,0x0
 3ec:	19a080e7          	jalr	410(ra) # 582 <read>
    if(cc < 1)
 3f0:	00a05e63          	blez	a0,40c <gets+0x56>
    buf[i++] = c;
 3f4:	faf44783          	lbu	a5,-81(s0)
 3f8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3fc:	01578763          	beq	a5,s5,40a <gets+0x54>
 400:	0905                	addi	s2,s2,1
 402:	fd679be3          	bne	a5,s6,3d8 <gets+0x22>
  for(i=0; i+1 < max; ){
 406:	89a6                	mv	s3,s1
 408:	a011                	j	40c <gets+0x56>
 40a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 40c:	99de                	add	s3,s3,s7
 40e:	00098023          	sb	zero,0(s3)
  return buf;
}
 412:	855e                	mv	a0,s7
 414:	60e6                	ld	ra,88(sp)
 416:	6446                	ld	s0,80(sp)
 418:	64a6                	ld	s1,72(sp)
 41a:	6906                	ld	s2,64(sp)
 41c:	79e2                	ld	s3,56(sp)
 41e:	7a42                	ld	s4,48(sp)
 420:	7aa2                	ld	s5,40(sp)
 422:	7b02                	ld	s6,32(sp)
 424:	6be2                	ld	s7,24(sp)
 426:	6125                	addi	sp,sp,96
 428:	8082                	ret

000000000000042a <stat>:

int
stat(const char *n, struct stat *st)
{
 42a:	1101                	addi	sp,sp,-32
 42c:	ec06                	sd	ra,24(sp)
 42e:	e822                	sd	s0,16(sp)
 430:	e426                	sd	s1,8(sp)
 432:	e04a                	sd	s2,0(sp)
 434:	1000                	addi	s0,sp,32
 436:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 438:	4581                	li	a1,0
 43a:	00000097          	auipc	ra,0x0
 43e:	170080e7          	jalr	368(ra) # 5aa <open>
  if(fd < 0)
 442:	02054563          	bltz	a0,46c <stat+0x42>
 446:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 448:	85ca                	mv	a1,s2
 44a:	00000097          	auipc	ra,0x0
 44e:	178080e7          	jalr	376(ra) # 5c2 <fstat>
 452:	892a                	mv	s2,a0
  close(fd);
 454:	8526                	mv	a0,s1
 456:	00000097          	auipc	ra,0x0
 45a:	13c080e7          	jalr	316(ra) # 592 <close>
  return r;
}
 45e:	854a                	mv	a0,s2
 460:	60e2                	ld	ra,24(sp)
 462:	6442                	ld	s0,16(sp)
 464:	64a2                	ld	s1,8(sp)
 466:	6902                	ld	s2,0(sp)
 468:	6105                	addi	sp,sp,32
 46a:	8082                	ret
    return -1;
 46c:	597d                	li	s2,-1
 46e:	bfc5                	j	45e <stat+0x34>

0000000000000470 <atoi>:

int
atoi(const char *s)
{
 470:	1141                	addi	sp,sp,-16
 472:	e422                	sd	s0,8(sp)
 474:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 476:	00054683          	lbu	a3,0(a0)
 47a:	fd06879b          	addiw	a5,a3,-48
 47e:	0ff7f793          	zext.b	a5,a5
 482:	4625                	li	a2,9
 484:	02f66863          	bltu	a2,a5,4b4 <atoi+0x44>
 488:	872a                	mv	a4,a0
  n = 0;
 48a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 48c:	0705                	addi	a4,a4,1
 48e:	0025179b          	slliw	a5,a0,0x2
 492:	9fa9                	addw	a5,a5,a0
 494:	0017979b          	slliw	a5,a5,0x1
 498:	9fb5                	addw	a5,a5,a3
 49a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 49e:	00074683          	lbu	a3,0(a4)
 4a2:	fd06879b          	addiw	a5,a3,-48
 4a6:	0ff7f793          	zext.b	a5,a5
 4aa:	fef671e3          	bgeu	a2,a5,48c <atoi+0x1c>
  return n;
}
 4ae:	6422                	ld	s0,8(sp)
 4b0:	0141                	addi	sp,sp,16
 4b2:	8082                	ret
  n = 0;
 4b4:	4501                	li	a0,0
 4b6:	bfe5                	j	4ae <atoi+0x3e>

00000000000004b8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b8:	1141                	addi	sp,sp,-16
 4ba:	e422                	sd	s0,8(sp)
 4bc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4be:	02b57463          	bgeu	a0,a1,4e6 <memmove+0x2e>
    while(n-- > 0)
 4c2:	00c05f63          	blez	a2,4e0 <memmove+0x28>
 4c6:	1602                	slli	a2,a2,0x20
 4c8:	9201                	srli	a2,a2,0x20
 4ca:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4ce:	872a                	mv	a4,a0
      *dst++ = *src++;
 4d0:	0585                	addi	a1,a1,1
 4d2:	0705                	addi	a4,a4,1
 4d4:	fff5c683          	lbu	a3,-1(a1)
 4d8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4dc:	fee79ae3          	bne	a5,a4,4d0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4e0:	6422                	ld	s0,8(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret
    dst += n;
 4e6:	00c50733          	add	a4,a0,a2
    src += n;
 4ea:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4ec:	fec05ae3          	blez	a2,4e0 <memmove+0x28>
 4f0:	fff6079b          	addiw	a5,a2,-1
 4f4:	1782                	slli	a5,a5,0x20
 4f6:	9381                	srli	a5,a5,0x20
 4f8:	fff7c793          	not	a5,a5
 4fc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4fe:	15fd                	addi	a1,a1,-1
 500:	177d                	addi	a4,a4,-1
 502:	0005c683          	lbu	a3,0(a1)
 506:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 50a:	fee79ae3          	bne	a5,a4,4fe <memmove+0x46>
 50e:	bfc9                	j	4e0 <memmove+0x28>

0000000000000510 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 510:	1141                	addi	sp,sp,-16
 512:	e422                	sd	s0,8(sp)
 514:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 516:	ca05                	beqz	a2,546 <memcmp+0x36>
 518:	fff6069b          	addiw	a3,a2,-1
 51c:	1682                	slli	a3,a3,0x20
 51e:	9281                	srli	a3,a3,0x20
 520:	0685                	addi	a3,a3,1
 522:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 524:	00054783          	lbu	a5,0(a0)
 528:	0005c703          	lbu	a4,0(a1)
 52c:	00e79863          	bne	a5,a4,53c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 530:	0505                	addi	a0,a0,1
    p2++;
 532:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 534:	fed518e3          	bne	a0,a3,524 <memcmp+0x14>
  }
  return 0;
 538:	4501                	li	a0,0
 53a:	a019                	j	540 <memcmp+0x30>
      return *p1 - *p2;
 53c:	40e7853b          	subw	a0,a5,a4
}
 540:	6422                	ld	s0,8(sp)
 542:	0141                	addi	sp,sp,16
 544:	8082                	ret
  return 0;
 546:	4501                	li	a0,0
 548:	bfe5                	j	540 <memcmp+0x30>

000000000000054a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 54a:	1141                	addi	sp,sp,-16
 54c:	e406                	sd	ra,8(sp)
 54e:	e022                	sd	s0,0(sp)
 550:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 552:	00000097          	auipc	ra,0x0
 556:	f66080e7          	jalr	-154(ra) # 4b8 <memmove>
}
 55a:	60a2                	ld	ra,8(sp)
 55c:	6402                	ld	s0,0(sp)
 55e:	0141                	addi	sp,sp,16
 560:	8082                	ret

0000000000000562 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 562:	4885                	li	a7,1
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <exit>:
.global exit
exit:
 li a7, SYS_exit
 56a:	4889                	li	a7,2
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <wait>:
.global wait
wait:
 li a7, SYS_wait
 572:	488d                	li	a7,3
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57a:	4891                	li	a7,4
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <read>:
.global read
read:
 li a7, SYS_read
 582:	4895                	li	a7,5
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <write>:
.global write
write:
 li a7, SYS_write
 58a:	48c1                	li	a7,16
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <close>:
.global close
close:
 li a7, SYS_close
 592:	48d5                	li	a7,21
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <kill>:
.global kill
kill:
 li a7, SYS_kill
 59a:	4899                	li	a7,6
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a2:	489d                	li	a7,7
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <open>:
.global open
open:
 li a7, SYS_open
 5aa:	48bd                	li	a7,15
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b2:	48c5                	li	a7,17
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ba:	48c9                	li	a7,18
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c2:	48a1                	li	a7,8
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <link>:
.global link
link:
 li a7, SYS_link
 5ca:	48cd                	li	a7,19
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d2:	48d1                	li	a7,20
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5da:	48a5                	li	a7,9
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e2:	48a9                	li	a7,10
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ea:	48ad                	li	a7,11
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5f2:	48b1                	li	a7,12
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5fa:	48b5                	li	a7,13
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 602:	48b9                	li	a7,14
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 60a:	1101                	addi	sp,sp,-32
 60c:	ec06                	sd	ra,24(sp)
 60e:	e822                	sd	s0,16(sp)
 610:	1000                	addi	s0,sp,32
 612:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 616:	4605                	li	a2,1
 618:	fef40593          	addi	a1,s0,-17
 61c:	00000097          	auipc	ra,0x0
 620:	f6e080e7          	jalr	-146(ra) # 58a <write>
}
 624:	60e2                	ld	ra,24(sp)
 626:	6442                	ld	s0,16(sp)
 628:	6105                	addi	sp,sp,32
 62a:	8082                	ret

000000000000062c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62c:	7139                	addi	sp,sp,-64
 62e:	fc06                	sd	ra,56(sp)
 630:	f822                	sd	s0,48(sp)
 632:	f426                	sd	s1,40(sp)
 634:	f04a                	sd	s2,32(sp)
 636:	ec4e                	sd	s3,24(sp)
 638:	0080                	addi	s0,sp,64
 63a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 63c:	c299                	beqz	a3,642 <printint+0x16>
 63e:	0805c963          	bltz	a1,6d0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 642:	2581                	sext.w	a1,a1
  neg = 0;
 644:	4881                	li	a7,0
 646:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 64a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 64c:	2601                	sext.w	a2,a2
 64e:	00000517          	auipc	a0,0x0
 652:	4ea50513          	addi	a0,a0,1258 # b38 <digits>
 656:	883a                	mv	a6,a4
 658:	2705                	addiw	a4,a4,1
 65a:	02c5f7bb          	remuw	a5,a1,a2
 65e:	1782                	slli	a5,a5,0x20
 660:	9381                	srli	a5,a5,0x20
 662:	97aa                	add	a5,a5,a0
 664:	0007c783          	lbu	a5,0(a5)
 668:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 66c:	0005879b          	sext.w	a5,a1
 670:	02c5d5bb          	divuw	a1,a1,a2
 674:	0685                	addi	a3,a3,1
 676:	fec7f0e3          	bgeu	a5,a2,656 <printint+0x2a>
  if(neg)
 67a:	00088c63          	beqz	a7,692 <printint+0x66>
    buf[i++] = '-';
 67e:	fd070793          	addi	a5,a4,-48
 682:	00878733          	add	a4,a5,s0
 686:	02d00793          	li	a5,45
 68a:	fef70823          	sb	a5,-16(a4)
 68e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 692:	02e05863          	blez	a4,6c2 <printint+0x96>
 696:	fc040793          	addi	a5,s0,-64
 69a:	00e78933          	add	s2,a5,a4
 69e:	fff78993          	addi	s3,a5,-1
 6a2:	99ba                	add	s3,s3,a4
 6a4:	377d                	addiw	a4,a4,-1
 6a6:	1702                	slli	a4,a4,0x20
 6a8:	9301                	srli	a4,a4,0x20
 6aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ae:	fff94583          	lbu	a1,-1(s2)
 6b2:	8526                	mv	a0,s1
 6b4:	00000097          	auipc	ra,0x0
 6b8:	f56080e7          	jalr	-170(ra) # 60a <putc>
  while(--i >= 0)
 6bc:	197d                	addi	s2,s2,-1
 6be:	ff3918e3          	bne	s2,s3,6ae <printint+0x82>
}
 6c2:	70e2                	ld	ra,56(sp)
 6c4:	7442                	ld	s0,48(sp)
 6c6:	74a2                	ld	s1,40(sp)
 6c8:	7902                	ld	s2,32(sp)
 6ca:	69e2                	ld	s3,24(sp)
 6cc:	6121                	addi	sp,sp,64
 6ce:	8082                	ret
    x = -xx;
 6d0:	40b005bb          	negw	a1,a1
    neg = 1;
 6d4:	4885                	li	a7,1
    x = -xx;
 6d6:	bf85                	j	646 <printint+0x1a>

00000000000006d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6d8:	715d                	addi	sp,sp,-80
 6da:	e486                	sd	ra,72(sp)
 6dc:	e0a2                	sd	s0,64(sp)
 6de:	fc26                	sd	s1,56(sp)
 6e0:	f84a                	sd	s2,48(sp)
 6e2:	f44e                	sd	s3,40(sp)
 6e4:	f052                	sd	s4,32(sp)
 6e6:	ec56                	sd	s5,24(sp)
 6e8:	e85a                	sd	s6,16(sp)
 6ea:	e45e                	sd	s7,8(sp)
 6ec:	e062                	sd	s8,0(sp)
 6ee:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6f0:	0005c903          	lbu	s2,0(a1)
 6f4:	18090c63          	beqz	s2,88c <vprintf+0x1b4>
 6f8:	8aaa                	mv	s5,a0
 6fa:	8bb2                	mv	s7,a2
 6fc:	00158493          	addi	s1,a1,1
  state = 0;
 700:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 702:	02500a13          	li	s4,37
 706:	4b55                	li	s6,21
 708:	a839                	j	726 <vprintf+0x4e>
        putc(fd, c);
 70a:	85ca                	mv	a1,s2
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	efc080e7          	jalr	-260(ra) # 60a <putc>
 716:	a019                	j	71c <vprintf+0x44>
    } else if(state == '%'){
 718:	01498d63          	beq	s3,s4,732 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 71c:	0485                	addi	s1,s1,1
 71e:	fff4c903          	lbu	s2,-1(s1)
 722:	16090563          	beqz	s2,88c <vprintf+0x1b4>
    if(state == 0){
 726:	fe0999e3          	bnez	s3,718 <vprintf+0x40>
      if(c == '%'){
 72a:	ff4910e3          	bne	s2,s4,70a <vprintf+0x32>
        state = '%';
 72e:	89d2                	mv	s3,s4
 730:	b7f5                	j	71c <vprintf+0x44>
      if(c == 'd'){
 732:	13490263          	beq	s2,s4,856 <vprintf+0x17e>
 736:	f9d9079b          	addiw	a5,s2,-99
 73a:	0ff7f793          	zext.b	a5,a5
 73e:	12fb6563          	bltu	s6,a5,868 <vprintf+0x190>
 742:	f9d9079b          	addiw	a5,s2,-99
 746:	0ff7f713          	zext.b	a4,a5
 74a:	10eb6f63          	bltu	s6,a4,868 <vprintf+0x190>
 74e:	00271793          	slli	a5,a4,0x2
 752:	00000717          	auipc	a4,0x0
 756:	38e70713          	addi	a4,a4,910 # ae0 <malloc+0x156>
 75a:	97ba                	add	a5,a5,a4
 75c:	439c                	lw	a5,0(a5)
 75e:	97ba                	add	a5,a5,a4
 760:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 762:	008b8913          	addi	s2,s7,8
 766:	4685                	li	a3,1
 768:	4629                	li	a2,10
 76a:	000ba583          	lw	a1,0(s7)
 76e:	8556                	mv	a0,s5
 770:	00000097          	auipc	ra,0x0
 774:	ebc080e7          	jalr	-324(ra) # 62c <printint>
 778:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 77a:	4981                	li	s3,0
 77c:	b745                	j	71c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 77e:	008b8913          	addi	s2,s7,8
 782:	4681                	li	a3,0
 784:	4629                	li	a2,10
 786:	000ba583          	lw	a1,0(s7)
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	ea0080e7          	jalr	-352(ra) # 62c <printint>
 794:	8bca                	mv	s7,s2
      state = 0;
 796:	4981                	li	s3,0
 798:	b751                	j	71c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 79a:	008b8913          	addi	s2,s7,8
 79e:	4681                	li	a3,0
 7a0:	4641                	li	a2,16
 7a2:	000ba583          	lw	a1,0(s7)
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e84080e7          	jalr	-380(ra) # 62c <printint>
 7b0:	8bca                	mv	s7,s2
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	b7a5                	j	71c <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 7b6:	008b8c13          	addi	s8,s7,8
 7ba:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7be:	03000593          	li	a1,48
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	e46080e7          	jalr	-442(ra) # 60a <putc>
  putc(fd, 'x');
 7cc:	07800593          	li	a1,120
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e38080e7          	jalr	-456(ra) # 60a <putc>
 7da:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7dc:	00000b97          	auipc	s7,0x0
 7e0:	35cb8b93          	addi	s7,s7,860 # b38 <digits>
 7e4:	03c9d793          	srli	a5,s3,0x3c
 7e8:	97de                	add	a5,a5,s7
 7ea:	0007c583          	lbu	a1,0(a5)
 7ee:	8556                	mv	a0,s5
 7f0:	00000097          	auipc	ra,0x0
 7f4:	e1a080e7          	jalr	-486(ra) # 60a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7f8:	0992                	slli	s3,s3,0x4
 7fa:	397d                	addiw	s2,s2,-1
 7fc:	fe0914e3          	bnez	s2,7e4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 800:	8be2                	mv	s7,s8
      state = 0;
 802:	4981                	li	s3,0
 804:	bf21                	j	71c <vprintf+0x44>
        s = va_arg(ap, char*);
 806:	008b8993          	addi	s3,s7,8
 80a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 80e:	02090163          	beqz	s2,830 <vprintf+0x158>
        while(*s != 0){
 812:	00094583          	lbu	a1,0(s2)
 816:	c9a5                	beqz	a1,886 <vprintf+0x1ae>
          putc(fd, *s);
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	df0080e7          	jalr	-528(ra) # 60a <putc>
          s++;
 822:	0905                	addi	s2,s2,1
        while(*s != 0){
 824:	00094583          	lbu	a1,0(s2)
 828:	f9e5                	bnez	a1,818 <vprintf+0x140>
        s = va_arg(ap, char*);
 82a:	8bce                	mv	s7,s3
      state = 0;
 82c:	4981                	li	s3,0
 82e:	b5fd                	j	71c <vprintf+0x44>
          s = "(null)";
 830:	00000917          	auipc	s2,0x0
 834:	2a890913          	addi	s2,s2,680 # ad8 <malloc+0x14e>
        while(*s != 0){
 838:	02800593          	li	a1,40
 83c:	bff1                	j	818 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 83e:	008b8913          	addi	s2,s7,8
 842:	000bc583          	lbu	a1,0(s7)
 846:	8556                	mv	a0,s5
 848:	00000097          	auipc	ra,0x0
 84c:	dc2080e7          	jalr	-574(ra) # 60a <putc>
 850:	8bca                	mv	s7,s2
      state = 0;
 852:	4981                	li	s3,0
 854:	b5e1                	j	71c <vprintf+0x44>
        putc(fd, c);
 856:	02500593          	li	a1,37
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	dae080e7          	jalr	-594(ra) # 60a <putc>
      state = 0;
 864:	4981                	li	s3,0
 866:	bd5d                	j	71c <vprintf+0x44>
        putc(fd, '%');
 868:	02500593          	li	a1,37
 86c:	8556                	mv	a0,s5
 86e:	00000097          	auipc	ra,0x0
 872:	d9c080e7          	jalr	-612(ra) # 60a <putc>
        putc(fd, c);
 876:	85ca                	mv	a1,s2
 878:	8556                	mv	a0,s5
 87a:	00000097          	auipc	ra,0x0
 87e:	d90080e7          	jalr	-624(ra) # 60a <putc>
      state = 0;
 882:	4981                	li	s3,0
 884:	bd61                	j	71c <vprintf+0x44>
        s = va_arg(ap, char*);
 886:	8bce                	mv	s7,s3
      state = 0;
 888:	4981                	li	s3,0
 88a:	bd49                	j	71c <vprintf+0x44>
    }
  }
}
 88c:	60a6                	ld	ra,72(sp)
 88e:	6406                	ld	s0,64(sp)
 890:	74e2                	ld	s1,56(sp)
 892:	7942                	ld	s2,48(sp)
 894:	79a2                	ld	s3,40(sp)
 896:	7a02                	ld	s4,32(sp)
 898:	6ae2                	ld	s5,24(sp)
 89a:	6b42                	ld	s6,16(sp)
 89c:	6ba2                	ld	s7,8(sp)
 89e:	6c02                	ld	s8,0(sp)
 8a0:	6161                	addi	sp,sp,80
 8a2:	8082                	ret

00000000000008a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a4:	715d                	addi	sp,sp,-80
 8a6:	ec06                	sd	ra,24(sp)
 8a8:	e822                	sd	s0,16(sp)
 8aa:	1000                	addi	s0,sp,32
 8ac:	e010                	sd	a2,0(s0)
 8ae:	e414                	sd	a3,8(s0)
 8b0:	e818                	sd	a4,16(s0)
 8b2:	ec1c                	sd	a5,24(s0)
 8b4:	03043023          	sd	a6,32(s0)
 8b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c0:	8622                	mv	a2,s0
 8c2:	00000097          	auipc	ra,0x0
 8c6:	e16080e7          	jalr	-490(ra) # 6d8 <vprintf>
}
 8ca:	60e2                	ld	ra,24(sp)
 8cc:	6442                	ld	s0,16(sp)
 8ce:	6161                	addi	sp,sp,80
 8d0:	8082                	ret

00000000000008d2 <printf>:

void
printf(const char *fmt, ...)
{
 8d2:	711d                	addi	sp,sp,-96
 8d4:	ec06                	sd	ra,24(sp)
 8d6:	e822                	sd	s0,16(sp)
 8d8:	1000                	addi	s0,sp,32
 8da:	e40c                	sd	a1,8(s0)
 8dc:	e810                	sd	a2,16(s0)
 8de:	ec14                	sd	a3,24(s0)
 8e0:	f018                	sd	a4,32(s0)
 8e2:	f41c                	sd	a5,40(s0)
 8e4:	03043823          	sd	a6,48(s0)
 8e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ec:	00840613          	addi	a2,s0,8
 8f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f4:	85aa                	mv	a1,a0
 8f6:	4505                	li	a0,1
 8f8:	00000097          	auipc	ra,0x0
 8fc:	de0080e7          	jalr	-544(ra) # 6d8 <vprintf>
}
 900:	60e2                	ld	ra,24(sp)
 902:	6442                	ld	s0,16(sp)
 904:	6125                	addi	sp,sp,96
 906:	8082                	ret

0000000000000908 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 908:	1141                	addi	sp,sp,-16
 90a:	e422                	sd	s0,8(sp)
 90c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 912:	00000797          	auipc	a5,0x0
 916:	23e7b783          	ld	a5,574(a5) # b50 <freep>
 91a:	a02d                	j	944 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 91c:	4618                	lw	a4,8(a2)
 91e:	9f2d                	addw	a4,a4,a1
 920:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 924:	6398                	ld	a4,0(a5)
 926:	6310                	ld	a2,0(a4)
 928:	a83d                	j	966 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 92a:	ff852703          	lw	a4,-8(a0)
 92e:	9f31                	addw	a4,a4,a2
 930:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 932:	ff053683          	ld	a3,-16(a0)
 936:	a091                	j	97a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 938:	6398                	ld	a4,0(a5)
 93a:	00e7e463          	bltu	a5,a4,942 <free+0x3a>
 93e:	00e6ea63          	bltu	a3,a4,952 <free+0x4a>
{
 942:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 944:	fed7fae3          	bgeu	a5,a3,938 <free+0x30>
 948:	6398                	ld	a4,0(a5)
 94a:	00e6e463          	bltu	a3,a4,952 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94e:	fee7eae3          	bltu	a5,a4,942 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 952:	ff852583          	lw	a1,-8(a0)
 956:	6390                	ld	a2,0(a5)
 958:	02059813          	slli	a6,a1,0x20
 95c:	01c85713          	srli	a4,a6,0x1c
 960:	9736                	add	a4,a4,a3
 962:	fae60de3          	beq	a2,a4,91c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 966:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 96a:	4790                	lw	a2,8(a5)
 96c:	02061593          	slli	a1,a2,0x20
 970:	01c5d713          	srli	a4,a1,0x1c
 974:	973e                	add	a4,a4,a5
 976:	fae68ae3          	beq	a3,a4,92a <free+0x22>
    p->s.ptr = bp->s.ptr;
 97a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 97c:	00000717          	auipc	a4,0x0
 980:	1cf73a23          	sd	a5,468(a4) # b50 <freep>
}
 984:	6422                	ld	s0,8(sp)
 986:	0141                	addi	sp,sp,16
 988:	8082                	ret

000000000000098a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 98a:	7139                	addi	sp,sp,-64
 98c:	fc06                	sd	ra,56(sp)
 98e:	f822                	sd	s0,48(sp)
 990:	f426                	sd	s1,40(sp)
 992:	f04a                	sd	s2,32(sp)
 994:	ec4e                	sd	s3,24(sp)
 996:	e852                	sd	s4,16(sp)
 998:	e456                	sd	s5,8(sp)
 99a:	e05a                	sd	s6,0(sp)
 99c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 99e:	02051493          	slli	s1,a0,0x20
 9a2:	9081                	srli	s1,s1,0x20
 9a4:	04bd                	addi	s1,s1,15
 9a6:	8091                	srli	s1,s1,0x4
 9a8:	0014899b          	addiw	s3,s1,1
 9ac:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9ae:	00000517          	auipc	a0,0x0
 9b2:	1a253503          	ld	a0,418(a0) # b50 <freep>
 9b6:	c515                	beqz	a0,9e2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ba:	4798                	lw	a4,8(a5)
 9bc:	02977f63          	bgeu	a4,s1,9fa <malloc+0x70>
  if(nu < 4096)
 9c0:	8a4e                	mv	s4,s3
 9c2:	0009871b          	sext.w	a4,s3
 9c6:	6685                	lui	a3,0x1
 9c8:	00d77363          	bgeu	a4,a3,9ce <malloc+0x44>
 9cc:	6a05                	lui	s4,0x1
 9ce:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9d2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d6:	00000917          	auipc	s2,0x0
 9da:	17a90913          	addi	s2,s2,378 # b50 <freep>
  if(p == (char*)-1)
 9de:	5afd                	li	s5,-1
 9e0:	a895                	j	a54 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9e2:	00000797          	auipc	a5,0x0
 9e6:	18678793          	addi	a5,a5,390 # b68 <base>
 9ea:	00000717          	auipc	a4,0x0
 9ee:	16f73323          	sd	a5,358(a4) # b50 <freep>
 9f2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9f8:	b7e1                	j	9c0 <malloc+0x36>
      if(p->s.size == nunits)
 9fa:	02e48c63          	beq	s1,a4,a32 <malloc+0xa8>
        p->s.size -= nunits;
 9fe:	4137073b          	subw	a4,a4,s3
 a02:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a04:	02071693          	slli	a3,a4,0x20
 a08:	01c6d713          	srli	a4,a3,0x1c
 a0c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a0e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a12:	00000717          	auipc	a4,0x0
 a16:	12a73f23          	sd	a0,318(a4) # b50 <freep>
      return (void*)(p + 1);
 a1a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a1e:	70e2                	ld	ra,56(sp)
 a20:	7442                	ld	s0,48(sp)
 a22:	74a2                	ld	s1,40(sp)
 a24:	7902                	ld	s2,32(sp)
 a26:	69e2                	ld	s3,24(sp)
 a28:	6a42                	ld	s4,16(sp)
 a2a:	6aa2                	ld	s5,8(sp)
 a2c:	6b02                	ld	s6,0(sp)
 a2e:	6121                	addi	sp,sp,64
 a30:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a32:	6398                	ld	a4,0(a5)
 a34:	e118                	sd	a4,0(a0)
 a36:	bff1                	j	a12 <malloc+0x88>
  hp->s.size = nu;
 a38:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a3c:	0541                	addi	a0,a0,16
 a3e:	00000097          	auipc	ra,0x0
 a42:	eca080e7          	jalr	-310(ra) # 908 <free>
  return freep;
 a46:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a4a:	d971                	beqz	a0,a1e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a4e:	4798                	lw	a4,8(a5)
 a50:	fa9775e3          	bgeu	a4,s1,9fa <malloc+0x70>
    if(p == freep)
 a54:	00093703          	ld	a4,0(s2)
 a58:	853e                	mv	a0,a5
 a5a:	fef719e3          	bne	a4,a5,a4c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a5e:	8552                	mv	a0,s4
 a60:	00000097          	auipc	ra,0x0
 a64:	b92080e7          	jalr	-1134(ra) # 5f2 <sbrk>
  if(p == (char*)-1)
 a68:	fd5518e3          	bne	a0,s5,a38 <malloc+0xae>
        return 0;
 a6c:	4501                	li	a0,0
 a6e:	bf45                	j	a1e <malloc+0x94>
