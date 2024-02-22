
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

/* the time is computed in tick (notion of time of the xv6 kernel) */
int 
main(int argc, char *argv[]) {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
char *echoargv[] = { "echo", "no", "argument", "given", 0 };
   8:	00001797          	auipc	a5,0x1
   c:	80078793          	addi	a5,a5,-2048 # 808 <malloc+0x114>
  10:	0007b803          	ld	a6,0(a5)
  14:	6790                	ld	a2,8(a5)
  16:	6b94                	ld	a3,16(a5)
  18:	6f98                	ld	a4,24(a5)
  1a:	739c                	ld	a5,32(a5)
  1c:	fd043423          	sd	a6,-56(s0)
  20:	fcc43823          	sd	a2,-48(s0)
  24:	fcd43c23          	sd	a3,-40(s0)
  28:	fee43023          	sd	a4,-32(s0)
  2c:	fef43423          	sd	a5,-24(s0)
  if (argc >= 2)
  30:	4785                	li	a5,1
  32:	02a7d063          	bge	a5,a0,52 <main+0x52>
    sleep(atoi(argv[1]));
  36:	6588                	ld	a0,8(a1)
  38:	00000097          	auipc	ra,0x0
  3c:	1a2080e7          	jalr	418(ra) # 1da <atoi>
  40:	00000097          	auipc	ra,0x0
  44:	324080e7          	jalr	804(ra) # 364 <sleep>
  else 
    exec("echo", echoargv);
  exit(0);
  48:	4501                	li	a0,0
  4a:	00000097          	auipc	ra,0x0
  4e:	28a080e7          	jalr	650(ra) # 2d4 <exit>
    exec("echo", echoargv);
  52:	fc840593          	addi	a1,s0,-56
  56:	00000517          	auipc	a0,0x0
  5a:	78a50513          	addi	a0,a0,1930 # 7e0 <malloc+0xec>
  5e:	00000097          	auipc	ra,0x0
  62:	2ae080e7          	jalr	686(ra) # 30c <exec>
  66:	b7cd                	j	48 <main+0x48>

0000000000000068 <strcpy>:
  68:	1141                	addi	sp,sp,-16
  6a:	e422                	sd	s0,8(sp)
  6c:	0800                	addi	s0,sp,16
  6e:	87aa                	mv	a5,a0
  70:	0585                	addi	a1,a1,1
  72:	0785                	addi	a5,a5,1
  74:	fff5c703          	lbu	a4,-1(a1)
  78:	fee78fa3          	sb	a4,-1(a5)
  7c:	fb75                	bnez	a4,70 <strcpy+0x8>
  7e:	6422                	ld	s0,8(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strcmp>:
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  8a:	00054783          	lbu	a5,0(a0)
  8e:	cb91                	beqz	a5,a2 <strcmp+0x1e>
  90:	0005c703          	lbu	a4,0(a1)
  94:	00f71763          	bne	a4,a5,a2 <strcmp+0x1e>
  98:	0505                	addi	a0,a0,1
  9a:	0585                	addi	a1,a1,1
  9c:	00054783          	lbu	a5,0(a0)
  a0:	fbe5                	bnez	a5,90 <strcmp+0xc>
  a2:	0005c503          	lbu	a0,0(a1)
  a6:	40a7853b          	subw	a0,a5,a0
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strlen>:
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strlen+0x26>
  bc:	0505                	addi	a0,a0,1
  be:	87aa                	mv	a5,a0
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x10>
  ca:	40a6853b          	subw	a0,a3,a0
  ce:	2505                	addiw	a0,a0,1
  d0:	6422                	ld	s0,8(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  d6:	4501                	li	a0,0
  d8:	bfe5                	j	d0 <strlen+0x20>

00000000000000da <memset>:
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  e0:	ca19                	beqz	a2,f6 <memset+0x1c>
  e2:	87aa                	mv	a5,a0
  e4:	1602                	slli	a2,a2,0x20
  e6:	9201                	srli	a2,a2,0x20
  e8:	00a60733          	add	a4,a2,a0
  ec:	00b78023          	sb	a1,0(a5)
  f0:	0785                	addi	a5,a5,1
  f2:	fee79de3          	bne	a5,a4,ec <memset+0x12>
  f6:	6422                	ld	s0,8(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret

00000000000000fc <strchr>:
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
 102:	00054783          	lbu	a5,0(a0)
 106:	cb99                	beqz	a5,11c <strchr+0x20>
 108:	00f58763          	beq	a1,a5,116 <strchr+0x1a>
 10c:	0505                	addi	a0,a0,1
 10e:	00054783          	lbu	a5,0(a0)
 112:	fbfd                	bnez	a5,108 <strchr+0xc>
 114:	4501                	li	a0,0
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret
 11c:	4501                	li	a0,0
 11e:	bfe5                	j	116 <strchr+0x1a>

0000000000000120 <gets>:
 120:	711d                	addi	sp,sp,-96
 122:	ec86                	sd	ra,88(sp)
 124:	e8a2                	sd	s0,80(sp)
 126:	e4a6                	sd	s1,72(sp)
 128:	e0ca                	sd	s2,64(sp)
 12a:	fc4e                	sd	s3,56(sp)
 12c:	f852                	sd	s4,48(sp)
 12e:	f456                	sd	s5,40(sp)
 130:	f05a                	sd	s6,32(sp)
 132:	ec5e                	sd	s7,24(sp)
 134:	1080                	addi	s0,sp,96
 136:	8baa                	mv	s7,a0
 138:	8a2e                	mv	s4,a1
 13a:	892a                	mv	s2,a0
 13c:	4481                	li	s1,0
 13e:	4aa9                	li	s5,10
 140:	4b35                	li	s6,13
 142:	89a6                	mv	s3,s1
 144:	2485                	addiw	s1,s1,1
 146:	0344d863          	bge	s1,s4,176 <gets+0x56>
 14a:	4605                	li	a2,1
 14c:	faf40593          	addi	a1,s0,-81
 150:	4501                	li	a0,0
 152:	00000097          	auipc	ra,0x0
 156:	19a080e7          	jalr	410(ra) # 2ec <read>
 15a:	00a05e63          	blez	a0,176 <gets+0x56>
 15e:	faf44783          	lbu	a5,-81(s0)
 162:	00f90023          	sb	a5,0(s2)
 166:	01578763          	beq	a5,s5,174 <gets+0x54>
 16a:	0905                	addi	s2,s2,1
 16c:	fd679be3          	bne	a5,s6,142 <gets+0x22>
 170:	89a6                	mv	s3,s1
 172:	a011                	j	176 <gets+0x56>
 174:	89a6                	mv	s3,s1
 176:	99de                	add	s3,s3,s7
 178:	00098023          	sb	zero,0(s3)
 17c:	855e                	mv	a0,s7
 17e:	60e6                	ld	ra,88(sp)
 180:	6446                	ld	s0,80(sp)
 182:	64a6                	ld	s1,72(sp)
 184:	6906                	ld	s2,64(sp)
 186:	79e2                	ld	s3,56(sp)
 188:	7a42                	ld	s4,48(sp)
 18a:	7aa2                	ld	s5,40(sp)
 18c:	7b02                	ld	s6,32(sp)
 18e:	6be2                	ld	s7,24(sp)
 190:	6125                	addi	sp,sp,96
 192:	8082                	ret

0000000000000194 <stat>:
 194:	1101                	addi	sp,sp,-32
 196:	ec06                	sd	ra,24(sp)
 198:	e822                	sd	s0,16(sp)
 19a:	e426                	sd	s1,8(sp)
 19c:	e04a                	sd	s2,0(sp)
 19e:	1000                	addi	s0,sp,32
 1a0:	892e                	mv	s2,a1
 1a2:	4581                	li	a1,0
 1a4:	00000097          	auipc	ra,0x0
 1a8:	170080e7          	jalr	368(ra) # 314 <open>
 1ac:	02054563          	bltz	a0,1d6 <stat+0x42>
 1b0:	84aa                	mv	s1,a0
 1b2:	85ca                	mv	a1,s2
 1b4:	00000097          	auipc	ra,0x0
 1b8:	178080e7          	jalr	376(ra) # 32c <fstat>
 1bc:	892a                	mv	s2,a0
 1be:	8526                	mv	a0,s1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	13c080e7          	jalr	316(ra) # 2fc <close>
 1c8:	854a                	mv	a0,s2
 1ca:	60e2                	ld	ra,24(sp)
 1cc:	6442                	ld	s0,16(sp)
 1ce:	64a2                	ld	s1,8(sp)
 1d0:	6902                	ld	s2,0(sp)
 1d2:	6105                	addi	sp,sp,32
 1d4:	8082                	ret
 1d6:	597d                	li	s2,-1
 1d8:	bfc5                	j	1c8 <stat+0x34>

00000000000001da <atoi>:
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
 1e0:	00054683          	lbu	a3,0(a0)
 1e4:	fd06879b          	addiw	a5,a3,-48
 1e8:	0ff7f793          	zext.b	a5,a5
 1ec:	4625                	li	a2,9
 1ee:	02f66863          	bltu	a2,a5,21e <atoi+0x44>
 1f2:	872a                	mv	a4,a0
 1f4:	4501                	li	a0,0
 1f6:	0705                	addi	a4,a4,1
 1f8:	0025179b          	slliw	a5,a0,0x2
 1fc:	9fa9                	addw	a5,a5,a0
 1fe:	0017979b          	slliw	a5,a5,0x1
 202:	9fb5                	addw	a5,a5,a3
 204:	fd07851b          	addiw	a0,a5,-48
 208:	00074683          	lbu	a3,0(a4)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	fef671e3          	bgeu	a2,a5,1f6 <atoi+0x1c>
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <atoi+0x3e>

0000000000000222 <memmove>:
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
 228:	02b57463          	bgeu	a0,a1,250 <memmove+0x2e>
 22c:	00c05f63          	blez	a2,24a <memmove+0x28>
 230:	1602                	slli	a2,a2,0x20
 232:	9201                	srli	a2,a2,0x20
 234:	00c507b3          	add	a5,a0,a2
 238:	872a                	mv	a4,a0
 23a:	0585                	addi	a1,a1,1
 23c:	0705                	addi	a4,a4,1
 23e:	fff5c683          	lbu	a3,-1(a1)
 242:	fed70fa3          	sb	a3,-1(a4)
 246:	fee79ae3          	bne	a5,a4,23a <memmove+0x18>
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
 250:	00c50733          	add	a4,a0,a2
 254:	95b2                	add	a1,a1,a2
 256:	fec05ae3          	blez	a2,24a <memmove+0x28>
 25a:	fff6079b          	addiw	a5,a2,-1
 25e:	1782                	slli	a5,a5,0x20
 260:	9381                	srli	a5,a5,0x20
 262:	fff7c793          	not	a5,a5
 266:	97ba                	add	a5,a5,a4
 268:	15fd                	addi	a1,a1,-1
 26a:	177d                	addi	a4,a4,-1
 26c:	0005c683          	lbu	a3,0(a1)
 270:	00d70023          	sb	a3,0(a4)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x46>
 278:	bfc9                	j	24a <memmove+0x28>

000000000000027a <memcmp>:
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
 280:	ca05                	beqz	a2,2b0 <memcmp+0x36>
 282:	fff6069b          	addiw	a3,a2,-1
 286:	1682                	slli	a3,a3,0x20
 288:	9281                	srli	a3,a3,0x20
 28a:	0685                	addi	a3,a3,1
 28c:	96aa                	add	a3,a3,a0
 28e:	00054783          	lbu	a5,0(a0)
 292:	0005c703          	lbu	a4,0(a1)
 296:	00e79863          	bne	a5,a4,2a6 <memcmp+0x2c>
 29a:	0505                	addi	a0,a0,1
 29c:	0585                	addi	a1,a1,1
 29e:	fed518e3          	bne	a0,a3,28e <memcmp+0x14>
 2a2:	4501                	li	a0,0
 2a4:	a019                	j	2aa <memcmp+0x30>
 2a6:	40e7853b          	subw	a0,a5,a4
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <memcmp+0x30>

00000000000002b4 <memcpy>:
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
 2bc:	00000097          	auipc	ra,0x0
 2c0:	f66080e7          	jalr	-154(ra) # 222 <memmove>
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <fork>:
 2cc:	4885                	li	a7,1
 2ce:	00000073          	ecall
 2d2:	8082                	ret

00000000000002d4 <exit>:
 2d4:	4889                	li	a7,2
 2d6:	00000073          	ecall
 2da:	8082                	ret

00000000000002dc <wait>:
 2dc:	488d                	li	a7,3
 2de:	00000073          	ecall
 2e2:	8082                	ret

00000000000002e4 <pipe>:
 2e4:	4891                	li	a7,4
 2e6:	00000073          	ecall
 2ea:	8082                	ret

00000000000002ec <read>:
 2ec:	4895                	li	a7,5
 2ee:	00000073          	ecall
 2f2:	8082                	ret

00000000000002f4 <write>:
 2f4:	48c1                	li	a7,16
 2f6:	00000073          	ecall
 2fa:	8082                	ret

00000000000002fc <close>:
 2fc:	48d5                	li	a7,21
 2fe:	00000073          	ecall
 302:	8082                	ret

0000000000000304 <kill>:
 304:	4899                	li	a7,6
 306:	00000073          	ecall
 30a:	8082                	ret

000000000000030c <exec>:
 30c:	489d                	li	a7,7
 30e:	00000073          	ecall
 312:	8082                	ret

0000000000000314 <open>:
 314:	48bd                	li	a7,15
 316:	00000073          	ecall
 31a:	8082                	ret

000000000000031c <mknod>:
 31c:	48c5                	li	a7,17
 31e:	00000073          	ecall
 322:	8082                	ret

0000000000000324 <unlink>:
 324:	48c9                	li	a7,18
 326:	00000073          	ecall
 32a:	8082                	ret

000000000000032c <fstat>:
 32c:	48a1                	li	a7,8
 32e:	00000073          	ecall
 332:	8082                	ret

0000000000000334 <link>:
 334:	48cd                	li	a7,19
 336:	00000073          	ecall
 33a:	8082                	ret

000000000000033c <mkdir>:
 33c:	48d1                	li	a7,20
 33e:	00000073          	ecall
 342:	8082                	ret

0000000000000344 <chdir>:
 344:	48a5                	li	a7,9
 346:	00000073          	ecall
 34a:	8082                	ret

000000000000034c <dup>:
 34c:	48a9                	li	a7,10
 34e:	00000073          	ecall
 352:	8082                	ret

0000000000000354 <getpid>:
 354:	48ad                	li	a7,11
 356:	00000073          	ecall
 35a:	8082                	ret

000000000000035c <sbrk>:
 35c:	48b1                	li	a7,12
 35e:	00000073          	ecall
 362:	8082                	ret

0000000000000364 <sleep>:
 364:	48b5                	li	a7,13
 366:	00000073          	ecall
 36a:	8082                	ret

000000000000036c <uptime>:
 36c:	48b9                	li	a7,14
 36e:	00000073          	ecall
 372:	8082                	ret

0000000000000374 <putc>:
 374:	1101                	addi	sp,sp,-32
 376:	ec06                	sd	ra,24(sp)
 378:	e822                	sd	s0,16(sp)
 37a:	1000                	addi	s0,sp,32
 37c:	feb407a3          	sb	a1,-17(s0)
 380:	4605                	li	a2,1
 382:	fef40593          	addi	a1,s0,-17
 386:	00000097          	auipc	ra,0x0
 38a:	f6e080e7          	jalr	-146(ra) # 2f4 <write>
 38e:	60e2                	ld	ra,24(sp)
 390:	6442                	ld	s0,16(sp)
 392:	6105                	addi	sp,sp,32
 394:	8082                	ret

0000000000000396 <printint>:
 396:	7139                	addi	sp,sp,-64
 398:	fc06                	sd	ra,56(sp)
 39a:	f822                	sd	s0,48(sp)
 39c:	f426                	sd	s1,40(sp)
 39e:	f04a                	sd	s2,32(sp)
 3a0:	ec4e                	sd	s3,24(sp)
 3a2:	0080                	addi	s0,sp,64
 3a4:	84aa                	mv	s1,a0
 3a6:	c299                	beqz	a3,3ac <printint+0x16>
 3a8:	0805c963          	bltz	a1,43a <printint+0xa4>
 3ac:	2581                	sext.w	a1,a1
 3ae:	4881                	li	a7,0
 3b0:	fc040693          	addi	a3,s0,-64
 3b4:	4701                	li	a4,0
 3b6:	2601                	sext.w	a2,a2
 3b8:	00000517          	auipc	a0,0x0
 3bc:	4d850513          	addi	a0,a0,1240 # 890 <digits>
 3c0:	883a                	mv	a6,a4
 3c2:	2705                	addiw	a4,a4,1
 3c4:	02c5f7bb          	remuw	a5,a1,a2
 3c8:	1782                	slli	a5,a5,0x20
 3ca:	9381                	srli	a5,a5,0x20
 3cc:	97aa                	add	a5,a5,a0
 3ce:	0007c783          	lbu	a5,0(a5)
 3d2:	00f68023          	sb	a5,0(a3)
 3d6:	0005879b          	sext.w	a5,a1
 3da:	02c5d5bb          	divuw	a1,a1,a2
 3de:	0685                	addi	a3,a3,1
 3e0:	fec7f0e3          	bgeu	a5,a2,3c0 <printint+0x2a>
 3e4:	00088c63          	beqz	a7,3fc <printint+0x66>
 3e8:	fd070793          	addi	a5,a4,-48
 3ec:	00878733          	add	a4,a5,s0
 3f0:	02d00793          	li	a5,45
 3f4:	fef70823          	sb	a5,-16(a4)
 3f8:	0028071b          	addiw	a4,a6,2
 3fc:	02e05863          	blez	a4,42c <printint+0x96>
 400:	fc040793          	addi	a5,s0,-64
 404:	00e78933          	add	s2,a5,a4
 408:	fff78993          	addi	s3,a5,-1
 40c:	99ba                	add	s3,s3,a4
 40e:	377d                	addiw	a4,a4,-1
 410:	1702                	slli	a4,a4,0x20
 412:	9301                	srli	a4,a4,0x20
 414:	40e989b3          	sub	s3,s3,a4
 418:	fff94583          	lbu	a1,-1(s2)
 41c:	8526                	mv	a0,s1
 41e:	00000097          	auipc	ra,0x0
 422:	f56080e7          	jalr	-170(ra) # 374 <putc>
 426:	197d                	addi	s2,s2,-1
 428:	ff3918e3          	bne	s2,s3,418 <printint+0x82>
 42c:	70e2                	ld	ra,56(sp)
 42e:	7442                	ld	s0,48(sp)
 430:	74a2                	ld	s1,40(sp)
 432:	7902                	ld	s2,32(sp)
 434:	69e2                	ld	s3,24(sp)
 436:	6121                	addi	sp,sp,64
 438:	8082                	ret
 43a:	40b005bb          	negw	a1,a1
 43e:	4885                	li	a7,1
 440:	bf85                	j	3b0 <printint+0x1a>

0000000000000442 <vprintf>:
 442:	715d                	addi	sp,sp,-80
 444:	e486                	sd	ra,72(sp)
 446:	e0a2                	sd	s0,64(sp)
 448:	fc26                	sd	s1,56(sp)
 44a:	f84a                	sd	s2,48(sp)
 44c:	f44e                	sd	s3,40(sp)
 44e:	f052                	sd	s4,32(sp)
 450:	ec56                	sd	s5,24(sp)
 452:	e85a                	sd	s6,16(sp)
 454:	e45e                	sd	s7,8(sp)
 456:	e062                	sd	s8,0(sp)
 458:	0880                	addi	s0,sp,80
 45a:	0005c903          	lbu	s2,0(a1)
 45e:	18090c63          	beqz	s2,5f6 <vprintf+0x1b4>
 462:	8aaa                	mv	s5,a0
 464:	8bb2                	mv	s7,a2
 466:	00158493          	addi	s1,a1,1
 46a:	4981                	li	s3,0
 46c:	02500a13          	li	s4,37
 470:	4b55                	li	s6,21
 472:	a839                	j	490 <vprintf+0x4e>
 474:	85ca                	mv	a1,s2
 476:	8556                	mv	a0,s5
 478:	00000097          	auipc	ra,0x0
 47c:	efc080e7          	jalr	-260(ra) # 374 <putc>
 480:	a019                	j	486 <vprintf+0x44>
 482:	01498d63          	beq	s3,s4,49c <vprintf+0x5a>
 486:	0485                	addi	s1,s1,1
 488:	fff4c903          	lbu	s2,-1(s1)
 48c:	16090563          	beqz	s2,5f6 <vprintf+0x1b4>
 490:	fe0999e3          	bnez	s3,482 <vprintf+0x40>
 494:	ff4910e3          	bne	s2,s4,474 <vprintf+0x32>
 498:	89d2                	mv	s3,s4
 49a:	b7f5                	j	486 <vprintf+0x44>
 49c:	13490263          	beq	s2,s4,5c0 <vprintf+0x17e>
 4a0:	f9d9079b          	addiw	a5,s2,-99
 4a4:	0ff7f793          	zext.b	a5,a5
 4a8:	12fb6563          	bltu	s6,a5,5d2 <vprintf+0x190>
 4ac:	f9d9079b          	addiw	a5,s2,-99
 4b0:	0ff7f713          	zext.b	a4,a5
 4b4:	10eb6f63          	bltu	s6,a4,5d2 <vprintf+0x190>
 4b8:	00271793          	slli	a5,a4,0x2
 4bc:	00000717          	auipc	a4,0x0
 4c0:	37c70713          	addi	a4,a4,892 # 838 <malloc+0x144>
 4c4:	97ba                	add	a5,a5,a4
 4c6:	439c                	lw	a5,0(a5)
 4c8:	97ba                	add	a5,a5,a4
 4ca:	8782                	jr	a5
 4cc:	008b8913          	addi	s2,s7,8
 4d0:	4685                	li	a3,1
 4d2:	4629                	li	a2,10
 4d4:	000ba583          	lw	a1,0(s7)
 4d8:	8556                	mv	a0,s5
 4da:	00000097          	auipc	ra,0x0
 4de:	ebc080e7          	jalr	-324(ra) # 396 <printint>
 4e2:	8bca                	mv	s7,s2
 4e4:	4981                	li	s3,0
 4e6:	b745                	j	486 <vprintf+0x44>
 4e8:	008b8913          	addi	s2,s7,8
 4ec:	4681                	li	a3,0
 4ee:	4629                	li	a2,10
 4f0:	000ba583          	lw	a1,0(s7)
 4f4:	8556                	mv	a0,s5
 4f6:	00000097          	auipc	ra,0x0
 4fa:	ea0080e7          	jalr	-352(ra) # 396 <printint>
 4fe:	8bca                	mv	s7,s2
 500:	4981                	li	s3,0
 502:	b751                	j	486 <vprintf+0x44>
 504:	008b8913          	addi	s2,s7,8
 508:	4681                	li	a3,0
 50a:	4641                	li	a2,16
 50c:	000ba583          	lw	a1,0(s7)
 510:	8556                	mv	a0,s5
 512:	00000097          	auipc	ra,0x0
 516:	e84080e7          	jalr	-380(ra) # 396 <printint>
 51a:	8bca                	mv	s7,s2
 51c:	4981                	li	s3,0
 51e:	b7a5                	j	486 <vprintf+0x44>
 520:	008b8c13          	addi	s8,s7,8
 524:	000bb983          	ld	s3,0(s7)
 528:	03000593          	li	a1,48
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	e46080e7          	jalr	-442(ra) # 374 <putc>
 536:	07800593          	li	a1,120
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e38080e7          	jalr	-456(ra) # 374 <putc>
 544:	4941                	li	s2,16
 546:	00000b97          	auipc	s7,0x0
 54a:	34ab8b93          	addi	s7,s7,842 # 890 <digits>
 54e:	03c9d793          	srli	a5,s3,0x3c
 552:	97de                	add	a5,a5,s7
 554:	0007c583          	lbu	a1,0(a5)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e1a080e7          	jalr	-486(ra) # 374 <putc>
 562:	0992                	slli	s3,s3,0x4
 564:	397d                	addiw	s2,s2,-1
 566:	fe0914e3          	bnez	s2,54e <vprintf+0x10c>
 56a:	8be2                	mv	s7,s8
 56c:	4981                	li	s3,0
 56e:	bf21                	j	486 <vprintf+0x44>
 570:	008b8993          	addi	s3,s7,8
 574:	000bb903          	ld	s2,0(s7)
 578:	02090163          	beqz	s2,59a <vprintf+0x158>
 57c:	00094583          	lbu	a1,0(s2)
 580:	c9a5                	beqz	a1,5f0 <vprintf+0x1ae>
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	df0080e7          	jalr	-528(ra) # 374 <putc>
 58c:	0905                	addi	s2,s2,1
 58e:	00094583          	lbu	a1,0(s2)
 592:	f9e5                	bnez	a1,582 <vprintf+0x140>
 594:	8bce                	mv	s7,s3
 596:	4981                	li	s3,0
 598:	b5fd                	j	486 <vprintf+0x44>
 59a:	00000917          	auipc	s2,0x0
 59e:	29690913          	addi	s2,s2,662 # 830 <malloc+0x13c>
 5a2:	02800593          	li	a1,40
 5a6:	bff1                	j	582 <vprintf+0x140>
 5a8:	008b8913          	addi	s2,s7,8
 5ac:	000bc583          	lbu	a1,0(s7)
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	dc2080e7          	jalr	-574(ra) # 374 <putc>
 5ba:	8bca                	mv	s7,s2
 5bc:	4981                	li	s3,0
 5be:	b5e1                	j	486 <vprintf+0x44>
 5c0:	02500593          	li	a1,37
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	dae080e7          	jalr	-594(ra) # 374 <putc>
 5ce:	4981                	li	s3,0
 5d0:	bd5d                	j	486 <vprintf+0x44>
 5d2:	02500593          	li	a1,37
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	d9c080e7          	jalr	-612(ra) # 374 <putc>
 5e0:	85ca                	mv	a1,s2
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	d90080e7          	jalr	-624(ra) # 374 <putc>
 5ec:	4981                	li	s3,0
 5ee:	bd61                	j	486 <vprintf+0x44>
 5f0:	8bce                	mv	s7,s3
 5f2:	4981                	li	s3,0
 5f4:	bd49                	j	486 <vprintf+0x44>
 5f6:	60a6                	ld	ra,72(sp)
 5f8:	6406                	ld	s0,64(sp)
 5fa:	74e2                	ld	s1,56(sp)
 5fc:	7942                	ld	s2,48(sp)
 5fe:	79a2                	ld	s3,40(sp)
 600:	7a02                	ld	s4,32(sp)
 602:	6ae2                	ld	s5,24(sp)
 604:	6b42                	ld	s6,16(sp)
 606:	6ba2                	ld	s7,8(sp)
 608:	6c02                	ld	s8,0(sp)
 60a:	6161                	addi	sp,sp,80
 60c:	8082                	ret

000000000000060e <fprintf>:
 60e:	715d                	addi	sp,sp,-80
 610:	ec06                	sd	ra,24(sp)
 612:	e822                	sd	s0,16(sp)
 614:	1000                	addi	s0,sp,32
 616:	e010                	sd	a2,0(s0)
 618:	e414                	sd	a3,8(s0)
 61a:	e818                	sd	a4,16(s0)
 61c:	ec1c                	sd	a5,24(s0)
 61e:	03043023          	sd	a6,32(s0)
 622:	03143423          	sd	a7,40(s0)
 626:	fe843423          	sd	s0,-24(s0)
 62a:	8622                	mv	a2,s0
 62c:	00000097          	auipc	ra,0x0
 630:	e16080e7          	jalr	-490(ra) # 442 <vprintf>
 634:	60e2                	ld	ra,24(sp)
 636:	6442                	ld	s0,16(sp)
 638:	6161                	addi	sp,sp,80
 63a:	8082                	ret

000000000000063c <printf>:
 63c:	711d                	addi	sp,sp,-96
 63e:	ec06                	sd	ra,24(sp)
 640:	e822                	sd	s0,16(sp)
 642:	1000                	addi	s0,sp,32
 644:	e40c                	sd	a1,8(s0)
 646:	e810                	sd	a2,16(s0)
 648:	ec14                	sd	a3,24(s0)
 64a:	f018                	sd	a4,32(s0)
 64c:	f41c                	sd	a5,40(s0)
 64e:	03043823          	sd	a6,48(s0)
 652:	03143c23          	sd	a7,56(s0)
 656:	00840613          	addi	a2,s0,8
 65a:	fec43423          	sd	a2,-24(s0)
 65e:	85aa                	mv	a1,a0
 660:	4505                	li	a0,1
 662:	00000097          	auipc	ra,0x0
 666:	de0080e7          	jalr	-544(ra) # 442 <vprintf>
 66a:	60e2                	ld	ra,24(sp)
 66c:	6442                	ld	s0,16(sp)
 66e:	6125                	addi	sp,sp,96
 670:	8082                	ret

0000000000000672 <free>:
 672:	1141                	addi	sp,sp,-16
 674:	e422                	sd	s0,8(sp)
 676:	0800                	addi	s0,sp,16
 678:	ff050693          	addi	a3,a0,-16
 67c:	00000797          	auipc	a5,0x0
 680:	22c7b783          	ld	a5,556(a5) # 8a8 <freep>
 684:	a02d                	j	6ae <free+0x3c>
 686:	4618                	lw	a4,8(a2)
 688:	9f2d                	addw	a4,a4,a1
 68a:	fee52c23          	sw	a4,-8(a0)
 68e:	6398                	ld	a4,0(a5)
 690:	6310                	ld	a2,0(a4)
 692:	a83d                	j	6d0 <free+0x5e>
 694:	ff852703          	lw	a4,-8(a0)
 698:	9f31                	addw	a4,a4,a2
 69a:	c798                	sw	a4,8(a5)
 69c:	ff053683          	ld	a3,-16(a0)
 6a0:	a091                	j	6e4 <free+0x72>
 6a2:	6398                	ld	a4,0(a5)
 6a4:	00e7e463          	bltu	a5,a4,6ac <free+0x3a>
 6a8:	00e6ea63          	bltu	a3,a4,6bc <free+0x4a>
 6ac:	87ba                	mv	a5,a4
 6ae:	fed7fae3          	bgeu	a5,a3,6a2 <free+0x30>
 6b2:	6398                	ld	a4,0(a5)
 6b4:	00e6e463          	bltu	a3,a4,6bc <free+0x4a>
 6b8:	fee7eae3          	bltu	a5,a4,6ac <free+0x3a>
 6bc:	ff852583          	lw	a1,-8(a0)
 6c0:	6390                	ld	a2,0(a5)
 6c2:	02059813          	slli	a6,a1,0x20
 6c6:	01c85713          	srli	a4,a6,0x1c
 6ca:	9736                	add	a4,a4,a3
 6cc:	fae60de3          	beq	a2,a4,686 <free+0x14>
 6d0:	fec53823          	sd	a2,-16(a0)
 6d4:	4790                	lw	a2,8(a5)
 6d6:	02061593          	slli	a1,a2,0x20
 6da:	01c5d713          	srli	a4,a1,0x1c
 6de:	973e                	add	a4,a4,a5
 6e0:	fae68ae3          	beq	a3,a4,694 <free+0x22>
 6e4:	e394                	sd	a3,0(a5)
 6e6:	00000717          	auipc	a4,0x0
 6ea:	1cf73123          	sd	a5,450(a4) # 8a8 <freep>
 6ee:	6422                	ld	s0,8(sp)
 6f0:	0141                	addi	sp,sp,16
 6f2:	8082                	ret

00000000000006f4 <malloc>:
 6f4:	7139                	addi	sp,sp,-64
 6f6:	fc06                	sd	ra,56(sp)
 6f8:	f822                	sd	s0,48(sp)
 6fa:	f426                	sd	s1,40(sp)
 6fc:	f04a                	sd	s2,32(sp)
 6fe:	ec4e                	sd	s3,24(sp)
 700:	e852                	sd	s4,16(sp)
 702:	e456                	sd	s5,8(sp)
 704:	e05a                	sd	s6,0(sp)
 706:	0080                	addi	s0,sp,64
 708:	02051493          	slli	s1,a0,0x20
 70c:	9081                	srli	s1,s1,0x20
 70e:	04bd                	addi	s1,s1,15
 710:	8091                	srli	s1,s1,0x4
 712:	0014899b          	addiw	s3,s1,1
 716:	0485                	addi	s1,s1,1
 718:	00000517          	auipc	a0,0x0
 71c:	19053503          	ld	a0,400(a0) # 8a8 <freep>
 720:	c515                	beqz	a0,74c <malloc+0x58>
 722:	611c                	ld	a5,0(a0)
 724:	4798                	lw	a4,8(a5)
 726:	02977f63          	bgeu	a4,s1,764 <malloc+0x70>
 72a:	8a4e                	mv	s4,s3
 72c:	0009871b          	sext.w	a4,s3
 730:	6685                	lui	a3,0x1
 732:	00d77363          	bgeu	a4,a3,738 <malloc+0x44>
 736:	6a05                	lui	s4,0x1
 738:	000a0b1b          	sext.w	s6,s4
 73c:	004a1a1b          	slliw	s4,s4,0x4
 740:	00000917          	auipc	s2,0x0
 744:	16890913          	addi	s2,s2,360 # 8a8 <freep>
 748:	5afd                	li	s5,-1
 74a:	a895                	j	7be <malloc+0xca>
 74c:	00000797          	auipc	a5,0x0
 750:	16478793          	addi	a5,a5,356 # 8b0 <base>
 754:	00000717          	auipc	a4,0x0
 758:	14f73a23          	sd	a5,340(a4) # 8a8 <freep>
 75c:	e39c                	sd	a5,0(a5)
 75e:	0007a423          	sw	zero,8(a5)
 762:	b7e1                	j	72a <malloc+0x36>
 764:	02e48c63          	beq	s1,a4,79c <malloc+0xa8>
 768:	4137073b          	subw	a4,a4,s3
 76c:	c798                	sw	a4,8(a5)
 76e:	02071693          	slli	a3,a4,0x20
 772:	01c6d713          	srli	a4,a3,0x1c
 776:	97ba                	add	a5,a5,a4
 778:	0137a423          	sw	s3,8(a5)
 77c:	00000717          	auipc	a4,0x0
 780:	12a73623          	sd	a0,300(a4) # 8a8 <freep>
 784:	01078513          	addi	a0,a5,16
 788:	70e2                	ld	ra,56(sp)
 78a:	7442                	ld	s0,48(sp)
 78c:	74a2                	ld	s1,40(sp)
 78e:	7902                	ld	s2,32(sp)
 790:	69e2                	ld	s3,24(sp)
 792:	6a42                	ld	s4,16(sp)
 794:	6aa2                	ld	s5,8(sp)
 796:	6b02                	ld	s6,0(sp)
 798:	6121                	addi	sp,sp,64
 79a:	8082                	ret
 79c:	6398                	ld	a4,0(a5)
 79e:	e118                	sd	a4,0(a0)
 7a0:	bff1                	j	77c <malloc+0x88>
 7a2:	01652423          	sw	s6,8(a0)
 7a6:	0541                	addi	a0,a0,16
 7a8:	00000097          	auipc	ra,0x0
 7ac:	eca080e7          	jalr	-310(ra) # 672 <free>
 7b0:	00093503          	ld	a0,0(s2)
 7b4:	d971                	beqz	a0,788 <malloc+0x94>
 7b6:	611c                	ld	a5,0(a0)
 7b8:	4798                	lw	a4,8(a5)
 7ba:	fa9775e3          	bgeu	a4,s1,764 <malloc+0x70>
 7be:	00093703          	ld	a4,0(s2)
 7c2:	853e                	mv	a0,a5
 7c4:	fef719e3          	bne	a4,a5,7b6 <malloc+0xc2>
 7c8:	8552                	mv	a0,s4
 7ca:	00000097          	auipc	ra,0x0
 7ce:	b92080e7          	jalr	-1134(ra) # 35c <sbrk>
 7d2:	fd5518e3          	bne	a0,s5,7a2 <malloc+0xae>
 7d6:	4501                	li	a0,0
 7d8:	bf45                	j	788 <malloc+0x94>
