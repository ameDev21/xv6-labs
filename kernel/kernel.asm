
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	89013103          	ld	sp,-1904(sp) # 80008890 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	680050ef          	jal	ra,80005696 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d2078793          	addi	a5,a5,-736 # 80021d50 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	89090913          	addi	s2,s2,-1904 # 800088e0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	024080e7          	jalr	36(ra) # 8000607e <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	0c4080e7          	jalr	196(ra) # 80006132 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	abc080e7          	jalr	-1348(ra) # 80005b46 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00008517          	auipc	a0,0x8
    800000f2:	7f250513          	addi	a0,a0,2034 # 800088e0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	ef8080e7          	jalr	-264(ra) # 80005fee <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	c4e50513          	addi	a0,a0,-946 # 80021d50 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7bc48493          	addi	s1,s1,1980 # 800088e0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	f50080e7          	jalr	-176(ra) # 8000607e <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7a450513          	addi	a0,a0,1956 # 800088e0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	fec080e7          	jalr	-20(ra) # 80006132 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	77850513          	addi	a0,a0,1912 # 800088e0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	fc2080e7          	jalr	-62(ra) # 80006132 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd2b1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	87aa                	mv	a5,a0
    8000028e:	86b2                	mv	a3,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	00d05963          	blez	a3,800002a4 <strncpy+0x1e>
    80000296:	0785                	addi	a5,a5,1
    80000298:	0005c703          	lbu	a4,0(a1)
    8000029c:	fee78fa3          	sb	a4,-1(a5)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f775                	bnez	a4,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	873e                	mv	a4,a5
    800002a6:	9fb5                	addw	a5,a5,a3
    800002a8:	37fd                	addiw	a5,a5,-1
    800002aa:	00c05963          	blez	a2,800002bc <strncpy+0x36>
    *s++ = 0;
    800002ae:	0705                	addi	a4,a4,1
    800002b0:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002b4:	40e786bb          	subw	a3,a5,a4
    800002b8:	fed04be3          	bgtz	a3,800002ae <strncpy+0x28>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	86be                	mv	a3,a5
    80000306:	0785                	addi	a5,a5,1
    80000308:	fff7c703          	lbu	a4,-1(a5)
    8000030c:	ff65                	bnez	a4,80000304 <strlen+0x10>
    8000030e:	40a6853b          	subw	a0,a3,a0
    80000312:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	b00080e7          	jalr	-1280(ra) # 80000e26 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	58270713          	addi	a4,a4,1410 # 800088b0 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	ae4080e7          	jalr	-1308(ra) # 80000e26 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	83c080e7          	jalr	-1988(ra) # 80005b90 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	78c080e7          	jalr	1932(ra) # 80001af0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	ce4080e7          	jalr	-796(ra) # 80005050 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fd4080e7          	jalr	-44(ra) # 80001348 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	6da080e7          	jalr	1754(ra) # 80005a56 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	9ec080e7          	jalr	-1556(ra) # 80005d70 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00005097          	auipc	ra,0x5
    80000398:	7fc080e7          	jalr	2044(ra) # 80005b90 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00005097          	auipc	ra,0x5
    800003a8:	7ec080e7          	jalr	2028(ra) # 80005b90 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00005097          	auipc	ra,0x5
    800003b8:	7dc080e7          	jalr	2012(ra) # 80005b90 <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d22080e7          	jalr	-734(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	326080e7          	jalr	806(ra) # 800006ea <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	99e080e7          	jalr	-1634(ra) # 80000d72 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	6ec080e7          	jalr	1772(ra) # 80001ac8 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	70c080e7          	jalr	1804(ra) # 80001af0 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	c4e080e7          	jalr	-946(ra) # 8000503a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	c5c080e7          	jalr	-932(ra) # 80005050 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	e50080e7          	jalr	-432(ra) # 8000224c <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	4ee080e7          	jalr	1262(ra) # 800028f2 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	464080e7          	jalr	1124(ra) # 80003870 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	d44080e7          	jalr	-700(ra) # 80005158 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d0e080e7          	jalr	-754(ra) # 8000112a <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	48f72323          	sw	a5,1158(a4) # 800088b0 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	47a7b783          	ld	a5,1146(a5) # 800088b8 <kernel_pagetable>
    80000446:	83b1                	srli	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	slli	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	addi	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	6bc080e7          	jalr	1724(ra) # 80005b46 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c84080e7          	jalr	-892(ra) # 8000011a <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd4080e7          	jalr	-812(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srli	a5,s1,0xc
    800004b2:	07aa                	slli	a5,a5,0xa
    800004b4:	0017e793          	ori	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd2a7>
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	andi	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srli	s1,s1,0xa
    800004da:	04b2                	slli	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srli	a0,s3,0xc
    800004e2:	1ff57513          	andi	a0,a0,511
    800004e6:	050e                	slli	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	addi	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	83a9                	srli	a5,a5,0xa
    8000053a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	addi	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055a:	c639                	beqz	a2,800005a8 <mappages+0x64>
    8000055c:	8aaa                	mv	s5,a0
    8000055e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000560:	777d                	lui	a4,0xfffff
    80000562:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000566:	fff58993          	addi	s3,a1,-1
    8000056a:	99b2                	add	s3,s3,a2
    8000056c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000570:	893e                	mv	s2,a5
    80000572:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	andi	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srli	s1,s1,0xc
    80000594:	04aa                	slli	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	ori	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	596080e7          	jalr	1430(ra) # 80005b46 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	586080e7          	jalr	1414(ra) # 80005b46 <panic>
      return -1;
    800005c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ca:	60a6                	ld	ra,72(sp)
    800005cc:	6406                	ld	s0,64(sp)
    800005ce:	74e2                	ld	s1,56(sp)
    800005d0:	7942                	ld	s2,48(sp)
    800005d2:	79a2                	ld	s3,40(sp)
    800005d4:	7a02                	ld	s4,32(sp)
    800005d6:	6ae2                	ld	s5,24(sp)
    800005d8:	6b42                	ld	s6,16(sp)
    800005da:	6ba2                	ld	s7,8(sp)
    800005dc:	6161                	addi	sp,sp,80
    800005de:	8082                	ret
  return 0;
    800005e0:	4501                	li	a0,0
    800005e2:	b7e5                	j	800005ca <mappages+0x86>

00000000800005e4 <kvmmap>:
{
    800005e4:	1141                	addi	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	addi	s0,sp,16
    800005ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ee:	86b2                	mv	a3,a2
    800005f0:	863e                	mv	a2,a5
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	f52080e7          	jalr	-174(ra) # 80000544 <mappages>
    800005fa:	e509                	bnez	a0,80000604 <kvmmap+0x20>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	addi	sp,sp,16
    80000602:	8082                	ret
    panic("kvmmap");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	addi	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	00005097          	auipc	ra,0x5
    80000610:	53a080e7          	jalr	1338(ra) # 80005b46 <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	afa080e7          	jalr	-1286(ra) # 8000011a <kalloc>
    80000628:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062a:	6605                	lui	a2,0x1
    8000062c:	4581                	li	a1,0
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	b4c080e7          	jalr	-1204(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000636:	4719                	li	a4,6
    80000638:	6685                	lui	a3,0x1
    8000063a:	10000637          	lui	a2,0x10000
    8000063e:	100005b7          	lui	a1,0x10000
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	fa0080e7          	jalr	-96(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10001637          	lui	a2,0x10001
    80000654:	100015b7          	lui	a1,0x10001
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f8a080e7          	jalr	-118(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	004006b7          	lui	a3,0x400
    80000668:	0c000637          	lui	a2,0xc000
    8000066c:	0c0005b7          	lui	a1,0xc000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f72080e7          	jalr	-142(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067a:	00008917          	auipc	s2,0x8
    8000067e:	98690913          	addi	s2,s2,-1658 # 80008000 <etext>
    80000682:	4729                	li	a4,10
    80000684:	80008697          	auipc	a3,0x80008
    80000688:	97c68693          	addi	a3,a3,-1668 # 8000 <_entry-0x7fff8000>
    8000068c:	4605                	li	a2,1
    8000068e:	067e                	slli	a2,a2,0x1f
    80000690:	85b2                	mv	a1,a2
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f50080e7          	jalr	-176(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	46c5                	li	a3,17
    800006a0:	06ee                	slli	a3,a3,0x1b
    800006a2:	412686b3          	sub	a3,a3,s2
    800006a6:	864a                	mv	a2,s2
    800006a8:	85ca                	mv	a1,s2
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f38080e7          	jalr	-200(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b4:	4729                	li	a4,10
    800006b6:	6685                	lui	a3,0x1
    800006b8:	00007617          	auipc	a2,0x7
    800006bc:	94860613          	addi	a2,a2,-1720 # 80007000 <_trampoline>
    800006c0:	040005b7          	lui	a1,0x4000
    800006c4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c6:	05b2                	slli	a1,a1,0xc
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f1a080e7          	jalr	-230(ra) # 800005e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	608080e7          	jalr	1544(ra) # 80000cdc <proc_mapstacks>
}
    800006dc:	8526                	mv	a0,s1
    800006de:	60e2                	ld	ra,24(sp)
    800006e0:	6442                	ld	s0,16(sp)
    800006e2:	64a2                	ld	s1,8(sp)
    800006e4:	6902                	ld	s2,0(sp)
    800006e6:	6105                	addi	sp,sp,32
    800006e8:	8082                	ret

00000000800006ea <kvminit>:
{
    800006ea:	1141                	addi	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f22080e7          	jalr	-222(ra) # 80000614 <kvmmake>
    800006fa:	00008797          	auipc	a5,0x8
    800006fe:	1aa7bf23          	sd	a0,446(a5) # 800088b8 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	addi	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070a:	715d                	addi	sp,sp,-80
    8000070c:	e486                	sd	ra,72(sp)
    8000070e:	e0a2                	sd	s0,64(sp)
    80000710:	fc26                	sd	s1,56(sp)
    80000712:	f84a                	sd	s2,48(sp)
    80000714:	f44e                	sd	s3,40(sp)
    80000716:	f052                	sd	s4,32(sp)
    80000718:	ec56                	sd	s5,24(sp)
    8000071a:	e85a                	sd	s6,16(sp)
    8000071c:	e45e                	sd	s7,8(sp)
    8000071e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000720:	03459793          	slli	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072c:	0632                	slli	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	6b05                	lui	s6,0x1
    80000736:	0735e263          	bltu	a1,s3,8000079a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073a:	60a6                	ld	ra,72(sp)
    8000073c:	6406                	ld	s0,64(sp)
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
    8000074c:	6161                	addi	sp,sp,80
    8000074e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	93050513          	addi	a0,a0,-1744 # 80008080 <etext+0x80>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	3ee080e7          	jalr	1006(ra) # 80005b46 <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	3de080e7          	jalr	990(ra) # 80005b46 <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	3ce080e7          	jalr	974(ra) # 80005b46 <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	3be080e7          	jalr	958(ra) # 80005b46 <panic>
    *pte = 0;
    80000790:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000794:	995a                	add	s2,s2,s6
    80000796:	fb3972e3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079a:	4601                	li	a2,0
    8000079c:	85ca                	mv	a1,s2
    8000079e:	8552                	mv	a0,s4
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	cbc080e7          	jalr	-836(ra) # 8000045c <walk>
    800007a8:	84aa                	mv	s1,a0
    800007aa:	d95d                	beqz	a0,80000760 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ac:	6108                	ld	a0,0(a0)
    800007ae:	00157793          	andi	a5,a0,1
    800007b2:	dfdd                	beqz	a5,80000770 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b4:	3ff57793          	andi	a5,a0,1023
    800007b8:	fd7784e3          	beq	a5,s7,80000780 <uvmunmap+0x76>
    if(do_free){
    800007bc:	fc0a8ae3          	beqz	s5,80000790 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c2:	0532                	slli	a0,a0,0xc
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	858080e7          	jalr	-1960(ra) # 8000001c <kfree>
    800007cc:	b7d1                	j	80000790 <uvmunmap+0x86>

00000000800007ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	942080e7          	jalr	-1726(ra) # 8000011a <kalloc>
    800007e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e2:	c519                	beqz	a0,800007f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e4:	6605                	lui	a2,0x1
    800007e6:	4581                	li	a1,0
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	992080e7          	jalr	-1646(ra) # 8000017a <memset>
  return pagetable;
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fc:	7179                	addi	sp,sp,-48
    800007fe:	f406                	sd	ra,40(sp)
    80000800:	f022                	sd	s0,32(sp)
    80000802:	ec26                	sd	s1,24(sp)
    80000804:	e84a                	sd	s2,16(sp)
    80000806:	e44e                	sd	s3,8(sp)
    80000808:	e052                	sd	s4,0(sp)
    8000080a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080c:	6785                	lui	a5,0x1
    8000080e:	04f67863          	bgeu	a2,a5,8000085e <uvmfirst+0x62>
    80000812:	8a2a                	mv	s4,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	902080e7          	jalr	-1790(ra) # 8000011a <kalloc>
    80000820:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	954080e7          	jalr	-1708(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082e:	4779                	li	a4,30
    80000830:	86ca                	mv	a3,s2
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	8552                	mv	a0,s4
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	d0c080e7          	jalr	-756(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000840:	8626                	mv	a2,s1
    80000842:	85ce                	mv	a1,s3
    80000844:	854a                	mv	a0,s2
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	990080e7          	jalr	-1648(ra) # 800001d6 <memmove>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6a02                	ld	s4,0(sp)
    8000085a:	6145                	addi	sp,sp,48
    8000085c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	87a50513          	addi	a0,a0,-1926 # 800080d8 <etext+0xd8>
    80000866:	00005097          	auipc	ra,0x5
    8000086a:	2e0080e7          	jalr	736(ra) # 80005b46 <panic>

000000008000086e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086e:	1101                	addi	sp,sp,-32
    80000870:	ec06                	sd	ra,24(sp)
    80000872:	e822                	sd	s0,16(sp)
    80000874:	e426                	sd	s1,8(sp)
    80000876:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000878:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087a:	00b67d63          	bgeu	a2,a1,80000894 <uvmdealloc+0x26>
    8000087e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000880:	6785                	lui	a5,0x1
    80000882:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000884:	00f60733          	add	a4,a2,a5
    80000888:	76fd                	lui	a3,0xfffff
    8000088a:	8f75                	and	a4,a4,a3
    8000088c:	97ae                	add	a5,a5,a1
    8000088e:	8ff5                	and	a5,a5,a3
    80000890:	00f76863          	bltu	a4,a5,800008a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000894:	8526                	mv	a0,s1
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a0:	8f99                	sub	a5,a5,a4
    800008a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a4:	4685                	li	a3,1
    800008a6:	0007861b          	sext.w	a2,a5
    800008aa:	85ba                	mv	a1,a4
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	e5e080e7          	jalr	-418(ra) # 8000070a <uvmunmap>
    800008b4:	b7c5                	j	80000894 <uvmdealloc+0x26>

00000000800008b6 <uvmalloc>:
  if(newsz < oldsz)
    800008b6:	0ab66563          	bltu	a2,a1,80000960 <uvmalloc+0xaa>
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	f426                	sd	s1,40(sp)
    800008c2:	f04a                	sd	s2,32(sp)
    800008c4:	ec4e                	sd	s3,24(sp)
    800008c6:	e852                	sd	s4,16(sp)
    800008c8:	e456                	sd	s5,8(sp)
    800008ca:	e05a                	sd	s6,0(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f363          	bgeu	s3,a2,80000964 <uvmalloc+0xae>
    800008e2:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c51d                	beqz	a0,80000920 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000900:	875a                	mv	a4,s6
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c3a080e7          	jalr	-966(ra) # 80000544 <mappages>
    80000912:	e90d                	bnez	a0,80000944 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x32>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	a809                	j	80000930 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000920:	864e                	mv	a2,s3
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	f48080e7          	jalr	-184(ra) # 8000086e <uvmdealloc>
      return 0;
    8000092e:	4501                	li	a0,0
}
    80000930:	70e2                	ld	ra,56(sp)
    80000932:	7442                	ld	s0,48(sp)
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
    80000938:	69e2                	ld	s3,24(sp)
    8000093a:	6a42                	ld	s4,16(sp)
    8000093c:	6aa2                	ld	s5,8(sp)
    8000093e:	6b02                	ld	s6,0(sp)
    80000940:	6121                	addi	sp,sp,64
    80000942:	8082                	ret
      kfree(mem);
    80000944:	8526                	mv	a0,s1
    80000946:	fffff097          	auipc	ra,0xfffff
    8000094a:	6d6080e7          	jalr	1750(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	864e                	mv	a2,s3
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f1a080e7          	jalr	-230(ra) # 8000086e <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
    8000095e:	bfc9                	j	80000930 <uvmalloc+0x7a>
    return oldsz;
    80000960:	852e                	mv	a0,a1
}
    80000962:	8082                	ret
  return newsz;
    80000964:	8532                	mv	a0,a2
    80000966:	b7e9                	j	80000930 <uvmalloc+0x7a>

0000000080000968 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000968:	7179                	addi	sp,sp,-48
    8000096a:	f406                	sd	ra,40(sp)
    8000096c:	f022                	sd	s0,32(sp)
    8000096e:	ec26                	sd	s1,24(sp)
    80000970:	e84a                	sd	s2,16(sp)
    80000972:	e44e                	sd	s3,8(sp)
    80000974:	e052                	sd	s4,0(sp)
    80000976:	1800                	addi	s0,sp,48
    80000978:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097a:	84aa                	mv	s1,a0
    8000097c:	6905                	lui	s2,0x1
    8000097e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000980:	4985                	li	s3,1
    80000982:	a829                	j	8000099c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000984:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000986:	00c79513          	slli	a0,a5,0xc
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	fde080e7          	jalr	-34(ra) # 80000968 <freewalk>
      pagetable[i] = 0;
    80000992:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000996:	04a1                	addi	s1,s1,8
    80000998:	03248163          	beq	s1,s2,800009ba <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099e:	00f7f713          	andi	a4,a5,15
    800009a2:	ff3701e3          	beq	a4,s3,80000984 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a6:	8b85                	andi	a5,a5,1
    800009a8:	d7fd                	beqz	a5,80000996 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009aa:	00007517          	auipc	a0,0x7
    800009ae:	74e50513          	addi	a0,a0,1870 # 800080f8 <etext+0xf8>
    800009b2:	00005097          	auipc	ra,0x5
    800009b6:	194080e7          	jalr	404(ra) # 80005b46 <panic>
    }
  }
  kfree((void*)pagetable);
    800009ba:	8552                	mv	a0,s4
    800009bc:	fffff097          	auipc	ra,0xfffff
    800009c0:	660080e7          	jalr	1632(ra) # 8000001c <kfree>
}
    800009c4:	70a2                	ld	ra,40(sp)
    800009c6:	7402                	ld	s0,32(sp)
    800009c8:	64e2                	ld	s1,24(sp)
    800009ca:	6942                	ld	s2,16(sp)
    800009cc:	69a2                	ld	s3,8(sp)
    800009ce:	6a02                	ld	s4,0(sp)
    800009d0:	6145                	addi	sp,sp,48
    800009d2:	8082                	ret

00000000800009d4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d4:	1101                	addi	sp,sp,-32
    800009d6:	ec06                	sd	ra,24(sp)
    800009d8:	e822                	sd	s0,16(sp)
    800009da:	e426                	sd	s1,8(sp)
    800009dc:	1000                	addi	s0,sp,32
    800009de:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e0:	e999                	bnez	a1,800009f6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e2:	8526                	mv	a0,s1
    800009e4:	00000097          	auipc	ra,0x0
    800009e8:	f84080e7          	jalr	-124(ra) # 80000968 <freewalk>
}
    800009ec:	60e2                	ld	ra,24(sp)
    800009ee:	6442                	ld	s0,16(sp)
    800009f0:	64a2                	ld	s1,8(sp)
    800009f2:	6105                	addi	sp,sp,32
    800009f4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f6:	6785                	lui	a5,0x1
    800009f8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fa:	95be                	add	a1,a1,a5
    800009fc:	4685                	li	a3,1
    800009fe:	00c5d613          	srli	a2,a1,0xc
    80000a02:	4581                	li	a1,0
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	d06080e7          	jalr	-762(ra) # 8000070a <uvmunmap>
    80000a0c:	bfd9                	j	800009e2 <uvmfree+0xe>

0000000080000a0e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a0e:	c679                	beqz	a2,80000adc <uvmcopy+0xce>
{
    80000a10:	715d                	addi	sp,sp,-80
    80000a12:	e486                	sd	ra,72(sp)
    80000a14:	e0a2                	sd	s0,64(sp)
    80000a16:	fc26                	sd	s1,56(sp)
    80000a18:	f84a                	sd	s2,48(sp)
    80000a1a:	f44e                	sd	s3,40(sp)
    80000a1c:	f052                	sd	s4,32(sp)
    80000a1e:	ec56                	sd	s5,24(sp)
    80000a20:	e85a                	sd	s6,16(sp)
    80000a22:	e45e                	sd	s7,8(sp)
    80000a24:	0880                	addi	s0,sp,80
    80000a26:	8b2a                	mv	s6,a0
    80000a28:	8aae                	mv	s5,a1
    80000a2a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a2c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a2e:	4601                	li	a2,0
    80000a30:	85ce                	mv	a1,s3
    80000a32:	855a                	mv	a0,s6
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	a28080e7          	jalr	-1496(ra) # 8000045c <walk>
    80000a3c:	c531                	beqz	a0,80000a88 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a3e:	6118                	ld	a4,0(a0)
    80000a40:	00177793          	andi	a5,a4,1
    80000a44:	cbb1                	beqz	a5,80000a98 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a46:	00a75593          	srli	a1,a4,0xa
    80000a4a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a4e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a52:	fffff097          	auipc	ra,0xfffff
    80000a56:	6c8080e7          	jalr	1736(ra) # 8000011a <kalloc>
    80000a5a:	892a                	mv	s2,a0
    80000a5c:	c939                	beqz	a0,80000ab2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a5e:	6605                	lui	a2,0x1
    80000a60:	85de                	mv	a1,s7
    80000a62:	fffff097          	auipc	ra,0xfffff
    80000a66:	774080e7          	jalr	1908(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6a:	8726                	mv	a4,s1
    80000a6c:	86ca                	mv	a3,s2
    80000a6e:	6605                	lui	a2,0x1
    80000a70:	85ce                	mv	a1,s3
    80000a72:	8556                	mv	a0,s5
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	ad0080e7          	jalr	-1328(ra) # 80000544 <mappages>
    80000a7c:	e515                	bnez	a0,80000aa8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a7e:	6785                	lui	a5,0x1
    80000a80:	99be                	add	s3,s3,a5
    80000a82:	fb49e6e3          	bltu	s3,s4,80000a2e <uvmcopy+0x20>
    80000a86:	a081                	j	80000ac6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	68050513          	addi	a0,a0,1664 # 80008108 <etext+0x108>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	0b6080e7          	jalr	182(ra) # 80005b46 <panic>
      panic("uvmcopy: page not present");
    80000a98:	00007517          	auipc	a0,0x7
    80000a9c:	69050513          	addi	a0,a0,1680 # 80008128 <etext+0x128>
    80000aa0:	00005097          	auipc	ra,0x5
    80000aa4:	0a6080e7          	jalr	166(ra) # 80005b46 <panic>
      kfree(mem);
    80000aa8:	854a                	mv	a0,s2
    80000aaa:	fffff097          	auipc	ra,0xfffff
    80000aae:	572080e7          	jalr	1394(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab2:	4685                	li	a3,1
    80000ab4:	00c9d613          	srli	a2,s3,0xc
    80000ab8:	4581                	li	a1,0
    80000aba:	8556                	mv	a0,s5
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	c4e080e7          	jalr	-946(ra) # 8000070a <uvmunmap>
  return -1;
    80000ac4:	557d                	li	a0,-1
}
    80000ac6:	60a6                	ld	ra,72(sp)
    80000ac8:	6406                	ld	s0,64(sp)
    80000aca:	74e2                	ld	s1,56(sp)
    80000acc:	7942                	ld	s2,48(sp)
    80000ace:	79a2                	ld	s3,40(sp)
    80000ad0:	7a02                	ld	s4,32(sp)
    80000ad2:	6ae2                	ld	s5,24(sp)
    80000ad4:	6b42                	ld	s6,16(sp)
    80000ad6:	6ba2                	ld	s7,8(sp)
    80000ad8:	6161                	addi	sp,sp,80
    80000ada:	8082                	ret
  return 0;
    80000adc:	4501                	li	a0,0
}
    80000ade:	8082                	ret

0000000080000ae0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae0:	1141                	addi	sp,sp,-16
    80000ae2:	e406                	sd	ra,8(sp)
    80000ae4:	e022                	sd	s0,0(sp)
    80000ae6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae8:	4601                	li	a2,0
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	972080e7          	jalr	-1678(ra) # 8000045c <walk>
  if(pte == 0)
    80000af2:	c901                	beqz	a0,80000b02 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af4:	611c                	ld	a5,0(a0)
    80000af6:	9bbd                	andi	a5,a5,-17
    80000af8:	e11c                	sd	a5,0(a0)
}
    80000afa:	60a2                	ld	ra,8(sp)
    80000afc:	6402                	ld	s0,0(sp)
    80000afe:	0141                	addi	sp,sp,16
    80000b00:	8082                	ret
    panic("uvmclear");
    80000b02:	00007517          	auipc	a0,0x7
    80000b06:	64650513          	addi	a0,a0,1606 # 80008148 <etext+0x148>
    80000b0a:	00005097          	auipc	ra,0x5
    80000b0e:	03c080e7          	jalr	60(ra) # 80005b46 <panic>

0000000080000b12 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b12:	c6bd                	beqz	a3,80000b80 <copyout+0x6e>
{
    80000b14:	715d                	addi	sp,sp,-80
    80000b16:	e486                	sd	ra,72(sp)
    80000b18:	e0a2                	sd	s0,64(sp)
    80000b1a:	fc26                	sd	s1,56(sp)
    80000b1c:	f84a                	sd	s2,48(sp)
    80000b1e:	f44e                	sd	s3,40(sp)
    80000b20:	f052                	sd	s4,32(sp)
    80000b22:	ec56                	sd	s5,24(sp)
    80000b24:	e85a                	sd	s6,16(sp)
    80000b26:	e45e                	sd	s7,8(sp)
    80000b28:	e062                	sd	s8,0(sp)
    80000b2a:	0880                	addi	s0,sp,80
    80000b2c:	8b2a                	mv	s6,a0
    80000b2e:	8c2e                	mv	s8,a1
    80000b30:	8a32                	mv	s4,a2
    80000b32:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b34:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b36:	6a85                	lui	s5,0x1
    80000b38:	a015                	j	80000b5c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3a:	9562                	add	a0,a0,s8
    80000b3c:	0004861b          	sext.w	a2,s1
    80000b40:	85d2                	mv	a1,s4
    80000b42:	41250533          	sub	a0,a0,s2
    80000b46:	fffff097          	auipc	ra,0xfffff
    80000b4a:	690080e7          	jalr	1680(ra) # 800001d6 <memmove>

    len -= n;
    80000b4e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b52:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b54:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b58:	02098263          	beqz	s3,80000b7c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b5c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b60:	85ca                	mv	a1,s2
    80000b62:	855a                	mv	a0,s6
    80000b64:	00000097          	auipc	ra,0x0
    80000b68:	99e080e7          	jalr	-1634(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000b6c:	cd01                	beqz	a0,80000b84 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b6e:	418904b3          	sub	s1,s2,s8
    80000b72:	94d6                	add	s1,s1,s5
    80000b74:	fc99f3e3          	bgeu	s3,s1,80000b3a <copyout+0x28>
    80000b78:	84ce                	mv	s1,s3
    80000b7a:	b7c1                	j	80000b3a <copyout+0x28>
  }
  return 0;
    80000b7c:	4501                	li	a0,0
    80000b7e:	a021                	j	80000b86 <copyout+0x74>
    80000b80:	4501                	li	a0,0
}
    80000b82:	8082                	ret
      return -1;
    80000b84:	557d                	li	a0,-1
}
    80000b86:	60a6                	ld	ra,72(sp)
    80000b88:	6406                	ld	s0,64(sp)
    80000b8a:	74e2                	ld	s1,56(sp)
    80000b8c:	7942                	ld	s2,48(sp)
    80000b8e:	79a2                	ld	s3,40(sp)
    80000b90:	7a02                	ld	s4,32(sp)
    80000b92:	6ae2                	ld	s5,24(sp)
    80000b94:	6b42                	ld	s6,16(sp)
    80000b96:	6ba2                	ld	s7,8(sp)
    80000b98:	6c02                	ld	s8,0(sp)
    80000b9a:	6161                	addi	sp,sp,80
    80000b9c:	8082                	ret

0000000080000b9e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b9e:	caa5                	beqz	a3,80000c0e <copyin+0x70>
{
    80000ba0:	715d                	addi	sp,sp,-80
    80000ba2:	e486                	sd	ra,72(sp)
    80000ba4:	e0a2                	sd	s0,64(sp)
    80000ba6:	fc26                	sd	s1,56(sp)
    80000ba8:	f84a                	sd	s2,48(sp)
    80000baa:	f44e                	sd	s3,40(sp)
    80000bac:	f052                	sd	s4,32(sp)
    80000bae:	ec56                	sd	s5,24(sp)
    80000bb0:	e85a                	sd	s6,16(sp)
    80000bb2:	e45e                	sd	s7,8(sp)
    80000bb4:	e062                	sd	s8,0(sp)
    80000bb6:	0880                	addi	s0,sp,80
    80000bb8:	8b2a                	mv	s6,a0
    80000bba:	8a2e                	mv	s4,a1
    80000bbc:	8c32                	mv	s8,a2
    80000bbe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc2:	6a85                	lui	s5,0x1
    80000bc4:	a01d                	j	80000bea <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc6:	018505b3          	add	a1,a0,s8
    80000bca:	0004861b          	sext.w	a2,s1
    80000bce:	412585b3          	sub	a1,a1,s2
    80000bd2:	8552                	mv	a0,s4
    80000bd4:	fffff097          	auipc	ra,0xfffff
    80000bd8:	602080e7          	jalr	1538(ra) # 800001d6 <memmove>

    len -= n;
    80000bdc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be6:	02098263          	beqz	s3,80000c0a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bea:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bee:	85ca                	mv	a1,s2
    80000bf0:	855a                	mv	a0,s6
    80000bf2:	00000097          	auipc	ra,0x0
    80000bf6:	910080e7          	jalr	-1776(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000bfa:	cd01                	beqz	a0,80000c12 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bfc:	418904b3          	sub	s1,s2,s8
    80000c00:	94d6                	add	s1,s1,s5
    80000c02:	fc99f2e3          	bgeu	s3,s1,80000bc6 <copyin+0x28>
    80000c06:	84ce                	mv	s1,s3
    80000c08:	bf7d                	j	80000bc6 <copyin+0x28>
  }
  return 0;
    80000c0a:	4501                	li	a0,0
    80000c0c:	a021                	j	80000c14 <copyin+0x76>
    80000c0e:	4501                	li	a0,0
}
    80000c10:	8082                	ret
      return -1;
    80000c12:	557d                	li	a0,-1
}
    80000c14:	60a6                	ld	ra,72(sp)
    80000c16:	6406                	ld	s0,64(sp)
    80000c18:	74e2                	ld	s1,56(sp)
    80000c1a:	7942                	ld	s2,48(sp)
    80000c1c:	79a2                	ld	s3,40(sp)
    80000c1e:	7a02                	ld	s4,32(sp)
    80000c20:	6ae2                	ld	s5,24(sp)
    80000c22:	6b42                	ld	s6,16(sp)
    80000c24:	6ba2                	ld	s7,8(sp)
    80000c26:	6c02                	ld	s8,0(sp)
    80000c28:	6161                	addi	sp,sp,80
    80000c2a:	8082                	ret

0000000080000c2c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2c:	c2dd                	beqz	a3,80000cd2 <copyinstr+0xa6>
{
    80000c2e:	715d                	addi	sp,sp,-80
    80000c30:	e486                	sd	ra,72(sp)
    80000c32:	e0a2                	sd	s0,64(sp)
    80000c34:	fc26                	sd	s1,56(sp)
    80000c36:	f84a                	sd	s2,48(sp)
    80000c38:	f44e                	sd	s3,40(sp)
    80000c3a:	f052                	sd	s4,32(sp)
    80000c3c:	ec56                	sd	s5,24(sp)
    80000c3e:	e85a                	sd	s6,16(sp)
    80000c40:	e45e                	sd	s7,8(sp)
    80000c42:	0880                	addi	s0,sp,80
    80000c44:	8a2a                	mv	s4,a0
    80000c46:	8b2e                	mv	s6,a1
    80000c48:	8bb2                	mv	s7,a2
    80000c4a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4e:	6985                	lui	s3,0x1
    80000c50:	a02d                	j	80000c7a <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c52:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c56:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c58:	37fd                	addiw	a5,a5,-1
    80000c5a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c5e:	60a6                	ld	ra,72(sp)
    80000c60:	6406                	ld	s0,64(sp)
    80000c62:	74e2                	ld	s1,56(sp)
    80000c64:	7942                	ld	s2,48(sp)
    80000c66:	79a2                	ld	s3,40(sp)
    80000c68:	7a02                	ld	s4,32(sp)
    80000c6a:	6ae2                	ld	s5,24(sp)
    80000c6c:	6b42                	ld	s6,16(sp)
    80000c6e:	6ba2                	ld	s7,8(sp)
    80000c70:	6161                	addi	sp,sp,80
    80000c72:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c74:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c78:	c8a9                	beqz	s1,80000cca <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c7a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c7e:	85ca                	mv	a1,s2
    80000c80:	8552                	mv	a0,s4
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	880080e7          	jalr	-1920(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c8a:	c131                	beqz	a0,80000cce <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c8c:	417906b3          	sub	a3,s2,s7
    80000c90:	96ce                	add	a3,a3,s3
    80000c92:	00d4f363          	bgeu	s1,a3,80000c98 <copyinstr+0x6c>
    80000c96:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c98:	955e                	add	a0,a0,s7
    80000c9a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c9e:	daf9                	beqz	a3,80000c74 <copyinstr+0x48>
    80000ca0:	87da                	mv	a5,s6
    80000ca2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ca8:	96da                	add	a3,a3,s6
    80000caa:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cac:	00f60733          	add	a4,a2,a5
    80000cb0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd2b0>
    80000cb4:	df59                	beqz	a4,80000c52 <copyinstr+0x26>
        *dst = *p;
    80000cb6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cba:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cbc:	fed797e3          	bne	a5,a3,80000caa <copyinstr+0x7e>
    80000cc0:	14fd                	addi	s1,s1,-1
    80000cc2:	94c2                	add	s1,s1,a6
      --max;
    80000cc4:	8c8d                	sub	s1,s1,a1
      dst++;
    80000cc6:	8b3e                	mv	s6,a5
    80000cc8:	b775                	j	80000c74 <copyinstr+0x48>
    80000cca:	4781                	li	a5,0
    80000ccc:	b771                	j	80000c58 <copyinstr+0x2c>
      return -1;
    80000cce:	557d                	li	a0,-1
    80000cd0:	b779                	j	80000c5e <copyinstr+0x32>
  int got_null = 0;
    80000cd2:	4781                	li	a5,0
  if(got_null){
    80000cd4:	37fd                	addiw	a5,a5,-1
    80000cd6:	0007851b          	sext.w	a0,a5
}
    80000cda:	8082                	ret

0000000080000cdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cdc:	7139                	addi	sp,sp,-64
    80000cde:	fc06                	sd	ra,56(sp)
    80000ce0:	f822                	sd	s0,48(sp)
    80000ce2:	f426                	sd	s1,40(sp)
    80000ce4:	f04a                	sd	s2,32(sp)
    80000ce6:	ec4e                	sd	s3,24(sp)
    80000ce8:	e852                	sd	s4,16(sp)
    80000cea:	e456                	sd	s5,8(sp)
    80000cec:	e05a                	sd	s6,0(sp)
    80000cee:	0080                	addi	s0,sp,64
    80000cf0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	00008497          	auipc	s1,0x8
    80000cf6:	03e48493          	addi	s1,s1,62 # 80008d30 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfa:	8b26                	mv	s6,s1
    80000cfc:	00007a97          	auipc	s5,0x7
    80000d00:	304a8a93          	addi	s5,s5,772 # 80008000 <etext>
    80000d04:	04000937          	lui	s2,0x4000
    80000d08:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d0a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	0000ea17          	auipc	s4,0xe
    80000d10:	a24a0a13          	addi	s4,s4,-1500 # 8000e730 <tickslock>
    char *pa = kalloc();
    80000d14:	fffff097          	auipc	ra,0xfffff
    80000d18:	406080e7          	jalr	1030(ra) # 8000011a <kalloc>
    80000d1c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d1e:	c131                	beqz	a0,80000d62 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d20:	416485b3          	sub	a1,s1,s6
    80000d24:	858d                	srai	a1,a1,0x3
    80000d26:	000ab783          	ld	a5,0(s5)
    80000d2a:	02f585b3          	mul	a1,a1,a5
    80000d2e:	2585                	addiw	a1,a1,1
    80000d30:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d34:	4719                	li	a4,6
    80000d36:	6685                	lui	a3,0x1
    80000d38:	40b905b3          	sub	a1,s2,a1
    80000d3c:	854e                	mv	a0,s3
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	8a6080e7          	jalr	-1882(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d46:	16848493          	addi	s1,s1,360
    80000d4a:	fd4495e3          	bne	s1,s4,80000d14 <proc_mapstacks+0x38>
  }
}
    80000d4e:	70e2                	ld	ra,56(sp)
    80000d50:	7442                	ld	s0,48(sp)
    80000d52:	74a2                	ld	s1,40(sp)
    80000d54:	7902                	ld	s2,32(sp)
    80000d56:	69e2                	ld	s3,24(sp)
    80000d58:	6a42                	ld	s4,16(sp)
    80000d5a:	6aa2                	ld	s5,8(sp)
    80000d5c:	6b02                	ld	s6,0(sp)
    80000d5e:	6121                	addi	sp,sp,64
    80000d60:	8082                	ret
      panic("kalloc");
    80000d62:	00007517          	auipc	a0,0x7
    80000d66:	3f650513          	addi	a0,a0,1014 # 80008158 <etext+0x158>
    80000d6a:	00005097          	auipc	ra,0x5
    80000d6e:	ddc080e7          	jalr	-548(ra) # 80005b46 <panic>

0000000080000d72 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d72:	7139                	addi	sp,sp,-64
    80000d74:	fc06                	sd	ra,56(sp)
    80000d76:	f822                	sd	s0,48(sp)
    80000d78:	f426                	sd	s1,40(sp)
    80000d7a:	f04a                	sd	s2,32(sp)
    80000d7c:	ec4e                	sd	s3,24(sp)
    80000d7e:	e852                	sd	s4,16(sp)
    80000d80:	e456                	sd	s5,8(sp)
    80000d82:	e05a                	sd	s6,0(sp)
    80000d84:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d86:	00007597          	auipc	a1,0x7
    80000d8a:	3da58593          	addi	a1,a1,986 # 80008160 <etext+0x160>
    80000d8e:	00008517          	auipc	a0,0x8
    80000d92:	b7250513          	addi	a0,a0,-1166 # 80008900 <pid_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	258080e7          	jalr	600(ra) # 80005fee <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9e:	00007597          	auipc	a1,0x7
    80000da2:	3ca58593          	addi	a1,a1,970 # 80008168 <etext+0x168>
    80000da6:	00008517          	auipc	a0,0x8
    80000daa:	b7250513          	addi	a0,a0,-1166 # 80008918 <wait_lock>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	240080e7          	jalr	576(ra) # 80005fee <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	00008497          	auipc	s1,0x8
    80000dba:	f7a48493          	addi	s1,s1,-134 # 80008d30 <proc>
      initlock(&p->lock, "proc");
    80000dbe:	00007b17          	auipc	s6,0x7
    80000dc2:	3bab0b13          	addi	s6,s6,954 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc6:	8aa6                	mv	s5,s1
    80000dc8:	00007a17          	auipc	s4,0x7
    80000dcc:	238a0a13          	addi	s4,s4,568 # 80008000 <etext>
    80000dd0:	04000937          	lui	s2,0x4000
    80000dd4:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dd6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd8:	0000e997          	auipc	s3,0xe
    80000ddc:	95898993          	addi	s3,s3,-1704 # 8000e730 <tickslock>
      initlock(&p->lock, "proc");
    80000de0:	85da                	mv	a1,s6
    80000de2:	8526                	mv	a0,s1
    80000de4:	00005097          	auipc	ra,0x5
    80000de8:	20a080e7          	jalr	522(ra) # 80005fee <initlock>
      p->state = UNUSED;
    80000dec:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df0:	415487b3          	sub	a5,s1,s5
    80000df4:	878d                	srai	a5,a5,0x3
    80000df6:	000a3703          	ld	a4,0(s4)
    80000dfa:	02e787b3          	mul	a5,a5,a4
    80000dfe:	2785                	addiw	a5,a5,1
    80000e00:	00d7979b          	slliw	a5,a5,0xd
    80000e04:	40f907b3          	sub	a5,s2,a5
    80000e08:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	16848493          	addi	s1,s1,360
    80000e0e:	fd3499e3          	bne	s1,s3,80000de0 <procinit+0x6e>
  }
}
    80000e12:	70e2                	ld	ra,56(sp)
    80000e14:	7442                	ld	s0,48(sp)
    80000e16:	74a2                	ld	s1,40(sp)
    80000e18:	7902                	ld	s2,32(sp)
    80000e1a:	69e2                	ld	s3,24(sp)
    80000e1c:	6a42                	ld	s4,16(sp)
    80000e1e:	6aa2                	ld	s5,8(sp)
    80000e20:	6b02                	ld	s6,0(sp)
    80000e22:	6121                	addi	sp,sp,64
    80000e24:	8082                	ret

0000000080000e26 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e2e:	2501                	sext.w	a0,a0
    80000e30:	6422                	ld	s0,8(sp)
    80000e32:	0141                	addi	sp,sp,16
    80000e34:	8082                	ret

0000000080000e36 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
    80000e3c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e42:	00008517          	auipc	a0,0x8
    80000e46:	aee50513          	addi	a0,a0,-1298 # 80008930 <cpus>
    80000e4a:	953e                	add	a0,a0,a5
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e52:	1101                	addi	sp,sp,-32
    80000e54:	ec06                	sd	ra,24(sp)
    80000e56:	e822                	sd	s0,16(sp)
    80000e58:	e426                	sd	s1,8(sp)
    80000e5a:	1000                	addi	s0,sp,32
  push_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	1d6080e7          	jalr	470(ra) # 80006032 <push_off>
    80000e64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e66:	2781                	sext.w	a5,a5
    80000e68:	079e                	slli	a5,a5,0x7
    80000e6a:	00008717          	auipc	a4,0x8
    80000e6e:	a9670713          	addi	a4,a4,-1386 # 80008900 <pid_lock>
    80000e72:	97ba                	add	a5,a5,a4
    80000e74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	25c080e7          	jalr	604(ra) # 800060d2 <pop_off>
  return p;
}
    80000e7e:	8526                	mv	a0,s1
    80000e80:	60e2                	ld	ra,24(sp)
    80000e82:	6442                	ld	s0,16(sp)
    80000e84:	64a2                	ld	s1,8(sp)
    80000e86:	6105                	addi	sp,sp,32
    80000e88:	8082                	ret

0000000080000e8a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e8a:	1141                	addi	sp,sp,-16
    80000e8c:	e406                	sd	ra,8(sp)
    80000e8e:	e022                	sd	s0,0(sp)
    80000e90:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e92:	00000097          	auipc	ra,0x0
    80000e96:	fc0080e7          	jalr	-64(ra) # 80000e52 <myproc>
    80000e9a:	00005097          	auipc	ra,0x5
    80000e9e:	298080e7          	jalr	664(ra) # 80006132 <release>

  if (first) {
    80000ea2:	00008797          	auipc	a5,0x8
    80000ea6:	99e7a783          	lw	a5,-1634(a5) # 80008840 <first.1>
    80000eaa:	eb89                	bnez	a5,80000ebc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eac:	00001097          	auipc	ra,0x1
    80000eb0:	c5c080e7          	jalr	-932(ra) # 80001b08 <usertrapret>
}
    80000eb4:	60a2                	ld	ra,8(sp)
    80000eb6:	6402                	ld	s0,0(sp)
    80000eb8:	0141                	addi	sp,sp,16
    80000eba:	8082                	ret
    first = 0;
    80000ebc:	00008797          	auipc	a5,0x8
    80000ec0:	9807a223          	sw	zero,-1660(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000ec4:	4505                	li	a0,1
    80000ec6:	00002097          	auipc	ra,0x2
    80000eca:	9ac080e7          	jalr	-1620(ra) # 80002872 <fsinit>
    80000ece:	bff9                	j	80000eac <forkret+0x22>

0000000080000ed0 <allocpid>:
{
    80000ed0:	1101                	addi	sp,sp,-32
    80000ed2:	ec06                	sd	ra,24(sp)
    80000ed4:	e822                	sd	s0,16(sp)
    80000ed6:	e426                	sd	s1,8(sp)
    80000ed8:	e04a                	sd	s2,0(sp)
    80000eda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000edc:	00008917          	auipc	s2,0x8
    80000ee0:	a2490913          	addi	s2,s2,-1500 # 80008900 <pid_lock>
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	198080e7          	jalr	408(ra) # 8000607e <acquire>
  pid = nextpid;
    80000eee:	00008797          	auipc	a5,0x8
    80000ef2:	95678793          	addi	a5,a5,-1706 # 80008844 <nextpid>
    80000ef6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef8:	0014871b          	addiw	a4,s1,1
    80000efc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efe:	854a                	mv	a0,s2
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	232080e7          	jalr	562(ra) # 80006132 <release>
}
    80000f08:	8526                	mv	a0,s1
    80000f0a:	60e2                	ld	ra,24(sp)
    80000f0c:	6442                	ld	s0,16(sp)
    80000f0e:	64a2                	ld	s1,8(sp)
    80000f10:	6902                	ld	s2,0(sp)
    80000f12:	6105                	addi	sp,sp,32
    80000f14:	8082                	ret

0000000080000f16 <proc_pagetable>:
{
    80000f16:	1101                	addi	sp,sp,-32
    80000f18:	ec06                	sd	ra,24(sp)
    80000f1a:	e822                	sd	s0,16(sp)
    80000f1c:	e426                	sd	s1,8(sp)
    80000f1e:	e04a                	sd	s2,0(sp)
    80000f20:	1000                	addi	s0,sp,32
    80000f22:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	8aa080e7          	jalr	-1878(ra) # 800007ce <uvmcreate>
    80000f2c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f2e:	c121                	beqz	a0,80000f6e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f30:	4729                	li	a4,10
    80000f32:	00006697          	auipc	a3,0x6
    80000f36:	0ce68693          	addi	a3,a3,206 # 80007000 <_trampoline>
    80000f3a:	6605                	lui	a2,0x1
    80000f3c:	040005b7          	lui	a1,0x4000
    80000f40:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f42:	05b2                	slli	a1,a1,0xc
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	600080e7          	jalr	1536(ra) # 80000544 <mappages>
    80000f4c:	02054863          	bltz	a0,80000f7c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f50:	4719                	li	a4,6
    80000f52:	05893683          	ld	a3,88(s2)
    80000f56:	6605                	lui	a2,0x1
    80000f58:	020005b7          	lui	a1,0x2000
    80000f5c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f5e:	05b6                	slli	a1,a1,0xd
    80000f60:	8526                	mv	a0,s1
    80000f62:	fffff097          	auipc	ra,0xfffff
    80000f66:	5e2080e7          	jalr	1506(ra) # 80000544 <mappages>
    80000f6a:	02054163          	bltz	a0,80000f8c <proc_pagetable+0x76>
}
    80000f6e:	8526                	mv	a0,s1
    80000f70:	60e2                	ld	ra,24(sp)
    80000f72:	6442                	ld	s0,16(sp)
    80000f74:	64a2                	ld	s1,8(sp)
    80000f76:	6902                	ld	s2,0(sp)
    80000f78:	6105                	addi	sp,sp,32
    80000f7a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7c:	4581                	li	a1,0
    80000f7e:	8526                	mv	a0,s1
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	a54080e7          	jalr	-1452(ra) # 800009d4 <uvmfree>
    return 0;
    80000f88:	4481                	li	s1,0
    80000f8a:	b7d5                	j	80000f6e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8c:	4681                	li	a3,0
    80000f8e:	4605                	li	a2,1
    80000f90:	040005b7          	lui	a1,0x4000
    80000f94:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f96:	05b2                	slli	a1,a1,0xc
    80000f98:	8526                	mv	a0,s1
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	770080e7          	jalr	1904(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa2:	4581                	li	a1,0
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	a2e080e7          	jalr	-1490(ra) # 800009d4 <uvmfree>
    return 0;
    80000fae:	4481                	li	s1,0
    80000fb0:	bf7d                	j	80000f6e <proc_pagetable+0x58>

0000000080000fb2 <proc_freepagetable>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	e04a                	sd	s2,0(sp)
    80000fbc:	1000                	addi	s0,sp,32
    80000fbe:	84aa                	mv	s1,a0
    80000fc0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc2:	4681                	li	a3,0
    80000fc4:	4605                	li	a2,1
    80000fc6:	040005b7          	lui	a1,0x4000
    80000fca:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fcc:	05b2                	slli	a1,a1,0xc
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	73c080e7          	jalr	1852(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd6:	4681                	li	a3,0
    80000fd8:	4605                	li	a2,1
    80000fda:	020005b7          	lui	a1,0x2000
    80000fde:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe0:	05b6                	slli	a1,a1,0xd
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	726080e7          	jalr	1830(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80000fec:	85ca                	mv	a1,s2
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	9e4080e7          	jalr	-1564(ra) # 800009d4 <uvmfree>
}
    80000ff8:	60e2                	ld	ra,24(sp)
    80000ffa:	6442                	ld	s0,16(sp)
    80000ffc:	64a2                	ld	s1,8(sp)
    80000ffe:	6902                	ld	s2,0(sp)
    80001000:	6105                	addi	sp,sp,32
    80001002:	8082                	ret

0000000080001004 <freeproc>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001010:	6d28                	ld	a0,88(a0)
    80001012:	c509                	beqz	a0,8000101c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	008080e7          	jalr	8(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001020:	68a8                	ld	a0,80(s1)
    80001022:	c511                	beqz	a0,8000102e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001024:	64ac                	ld	a1,72(s1)
    80001026:	00000097          	auipc	ra,0x0
    8000102a:	f8c080e7          	jalr	-116(ra) # 80000fb2 <proc_freepagetable>
  p->pagetable = 0;
    8000102e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001032:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001036:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000103a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000103e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001042:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001046:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000104a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000104e:	0004ac23          	sw	zero,24(s1)
}
    80001052:	60e2                	ld	ra,24(sp)
    80001054:	6442                	ld	s0,16(sp)
    80001056:	64a2                	ld	s1,8(sp)
    80001058:	6105                	addi	sp,sp,32
    8000105a:	8082                	ret

000000008000105c <allocproc>:
{
    8000105c:	1101                	addi	sp,sp,-32
    8000105e:	ec06                	sd	ra,24(sp)
    80001060:	e822                	sd	s0,16(sp)
    80001062:	e426                	sd	s1,8(sp)
    80001064:	e04a                	sd	s2,0(sp)
    80001066:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001068:	00008497          	auipc	s1,0x8
    8000106c:	cc848493          	addi	s1,s1,-824 # 80008d30 <proc>
    80001070:	0000d917          	auipc	s2,0xd
    80001074:	6c090913          	addi	s2,s2,1728 # 8000e730 <tickslock>
    acquire(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	004080e7          	jalr	4(ra) # 8000607e <acquire>
    if(p->state == UNUSED) {
    80001082:	4c9c                	lw	a5,24(s1)
    80001084:	cf81                	beqz	a5,8000109c <allocproc+0x40>
      release(&p->lock);
    80001086:	8526                	mv	a0,s1
    80001088:	00005097          	auipc	ra,0x5
    8000108c:	0aa080e7          	jalr	170(ra) # 80006132 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001090:	16848493          	addi	s1,s1,360
    80001094:	ff2492e3          	bne	s1,s2,80001078 <allocproc+0x1c>
  return 0;
    80001098:	4481                	li	s1,0
    8000109a:	a889                	j	800010ec <allocproc+0x90>
  p->pid = allocpid();
    8000109c:	00000097          	auipc	ra,0x0
    800010a0:	e34080e7          	jalr	-460(ra) # 80000ed0 <allocpid>
    800010a4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a6:	4785                	li	a5,1
    800010a8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	070080e7          	jalr	112(ra) # 8000011a <kalloc>
    800010b2:	892a                	mv	s2,a0
    800010b4:	eca8                	sd	a0,88(s1)
    800010b6:	c131                	beqz	a0,800010fa <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00000097          	auipc	ra,0x0
    800010be:	e5c080e7          	jalr	-420(ra) # 80000f16 <proc_pagetable>
    800010c2:	892a                	mv	s2,a0
    800010c4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c6:	c531                	beqz	a0,80001112 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010c8:	07000613          	li	a2,112
    800010cc:	4581                	li	a1,0
    800010ce:	06048513          	addi	a0,s1,96
    800010d2:	fffff097          	auipc	ra,0xfffff
    800010d6:	0a8080e7          	jalr	168(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010da:	00000797          	auipc	a5,0x0
    800010de:	db078793          	addi	a5,a5,-592 # 80000e8a <forkret>
    800010e2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e4:	60bc                	ld	a5,64(s1)
    800010e6:	6705                	lui	a4,0x1
    800010e8:	97ba                	add	a5,a5,a4
    800010ea:	f4bc                	sd	a5,104(s1)
}
    800010ec:	8526                	mv	a0,s1
    800010ee:	60e2                	ld	ra,24(sp)
    800010f0:	6442                	ld	s0,16(sp)
    800010f2:	64a2                	ld	s1,8(sp)
    800010f4:	6902                	ld	s2,0(sp)
    800010f6:	6105                	addi	sp,sp,32
    800010f8:	8082                	ret
    freeproc(p);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	f08080e7          	jalr	-248(ra) # 80001004 <freeproc>
    release(&p->lock);
    80001104:	8526                	mv	a0,s1
    80001106:	00005097          	auipc	ra,0x5
    8000110a:	02c080e7          	jalr	44(ra) # 80006132 <release>
    return 0;
    8000110e:	84ca                	mv	s1,s2
    80001110:	bff1                	j	800010ec <allocproc+0x90>
    freeproc(p);
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	ef0080e7          	jalr	-272(ra) # 80001004 <freeproc>
    release(&p->lock);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00005097          	auipc	ra,0x5
    80001122:	014080e7          	jalr	20(ra) # 80006132 <release>
    return 0;
    80001126:	84ca                	mv	s1,s2
    80001128:	b7d1                	j	800010ec <allocproc+0x90>

000000008000112a <userinit>:
{
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	e426                	sd	s1,8(sp)
    80001132:	1000                	addi	s0,sp,32
  p = allocproc();
    80001134:	00000097          	auipc	ra,0x0
    80001138:	f28080e7          	jalr	-216(ra) # 8000105c <allocproc>
    8000113c:	84aa                	mv	s1,a0
  initproc = p;
    8000113e:	00007797          	auipc	a5,0x7
    80001142:	78a7b123          	sd	a0,1922(a5) # 800088c0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001146:	03400613          	li	a2,52
    8000114a:	00007597          	auipc	a1,0x7
    8000114e:	70658593          	addi	a1,a1,1798 # 80008850 <initcode>
    80001152:	6928                	ld	a0,80(a0)
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	6a8080e7          	jalr	1704(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    8000115c:	6785                	lui	a5,0x1
    8000115e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001160:	6cb8                	ld	a4,88(s1)
    80001162:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001166:	6cb8                	ld	a4,88(s1)
    80001168:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116a:	4641                	li	a2,16
    8000116c:	00007597          	auipc	a1,0x7
    80001170:	01458593          	addi	a1,a1,20 # 80008180 <etext+0x180>
    80001174:	15848513          	addi	a0,s1,344
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	14a080e7          	jalr	330(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001180:	00007517          	auipc	a0,0x7
    80001184:	01050513          	addi	a0,a0,16 # 80008190 <etext+0x190>
    80001188:	00002097          	auipc	ra,0x2
    8000118c:	108080e7          	jalr	264(ra) # 80003290 <namei>
    80001190:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001194:	478d                	li	a5,3
    80001196:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001198:	8526                	mv	a0,s1
    8000119a:	00005097          	auipc	ra,0x5
    8000119e:	f98080e7          	jalr	-104(ra) # 80006132 <release>
}
    800011a2:	60e2                	ld	ra,24(sp)
    800011a4:	6442                	ld	s0,16(sp)
    800011a6:	64a2                	ld	s1,8(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret

00000000800011ac <growproc>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	e04a                	sd	s2,0(sp)
    800011b6:	1000                	addi	s0,sp,32
    800011b8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	c98080e7          	jalr	-872(ra) # 80000e52 <myproc>
    800011c2:	84aa                	mv	s1,a0
  sz = p->sz;
    800011c4:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011c6:	01204c63          	bgtz	s2,800011de <growproc+0x32>
  } else if(n < 0){
    800011ca:	02094663          	bltz	s2,800011f6 <growproc+0x4a>
  p->sz = sz;
    800011ce:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011de:	4691                	li	a3,4
    800011e0:	00b90633          	add	a2,s2,a1
    800011e4:	6928                	ld	a0,80(a0)
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	6d0080e7          	jalr	1744(ra) # 800008b6 <uvmalloc>
    800011ee:	85aa                	mv	a1,a0
    800011f0:	fd79                	bnez	a0,800011ce <growproc+0x22>
      return -1;
    800011f2:	557d                	li	a0,-1
    800011f4:	bff9                	j	800011d2 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f6:	00b90633          	add	a2,s2,a1
    800011fa:	6928                	ld	a0,80(a0)
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	672080e7          	jalr	1650(ra) # 8000086e <uvmdealloc>
    80001204:	85aa                	mv	a1,a0
    80001206:	b7e1                	j	800011ce <growproc+0x22>

0000000080001208 <fork>:
{
    80001208:	7139                	addi	sp,sp,-64
    8000120a:	fc06                	sd	ra,56(sp)
    8000120c:	f822                	sd	s0,48(sp)
    8000120e:	f426                	sd	s1,40(sp)
    80001210:	f04a                	sd	s2,32(sp)
    80001212:	ec4e                	sd	s3,24(sp)
    80001214:	e852                	sd	s4,16(sp)
    80001216:	e456                	sd	s5,8(sp)
    80001218:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	c38080e7          	jalr	-968(ra) # 80000e52 <myproc>
    80001222:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001224:	00000097          	auipc	ra,0x0
    80001228:	e38080e7          	jalr	-456(ra) # 8000105c <allocproc>
    8000122c:	10050c63          	beqz	a0,80001344 <fork+0x13c>
    80001230:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001232:	048ab603          	ld	a2,72(s5)
    80001236:	692c                	ld	a1,80(a0)
    80001238:	050ab503          	ld	a0,80(s5)
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	7d2080e7          	jalr	2002(ra) # 80000a0e <uvmcopy>
    80001244:	04054863          	bltz	a0,80001294 <fork+0x8c>
  np->sz = p->sz;
    80001248:	048ab783          	ld	a5,72(s5)
    8000124c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001250:	058ab683          	ld	a3,88(s5)
    80001254:	87b6                	mv	a5,a3
    80001256:	058a3703          	ld	a4,88(s4)
    8000125a:	12068693          	addi	a3,a3,288
    8000125e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001262:	6788                	ld	a0,8(a5)
    80001264:	6b8c                	ld	a1,16(a5)
    80001266:	6f90                	ld	a2,24(a5)
    80001268:	01073023          	sd	a6,0(a4)
    8000126c:	e708                	sd	a0,8(a4)
    8000126e:	eb0c                	sd	a1,16(a4)
    80001270:	ef10                	sd	a2,24(a4)
    80001272:	02078793          	addi	a5,a5,32
    80001276:	02070713          	addi	a4,a4,32
    8000127a:	fed792e3          	bne	a5,a3,8000125e <fork+0x56>
  np->trapframe->a0 = 0;
    8000127e:	058a3783          	ld	a5,88(s4)
    80001282:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001286:	0d0a8493          	addi	s1,s5,208
    8000128a:	0d0a0913          	addi	s2,s4,208
    8000128e:	150a8993          	addi	s3,s5,336
    80001292:	a00d                	j	800012b4 <fork+0xac>
    freeproc(np);
    80001294:	8552                	mv	a0,s4
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	d6e080e7          	jalr	-658(ra) # 80001004 <freeproc>
    release(&np->lock);
    8000129e:	8552                	mv	a0,s4
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	e92080e7          	jalr	-366(ra) # 80006132 <release>
    return -1;
    800012a8:	597d                	li	s2,-1
    800012aa:	a059                	j	80001330 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012ac:	04a1                	addi	s1,s1,8
    800012ae:	0921                	addi	s2,s2,8
    800012b0:	01348b63          	beq	s1,s3,800012c6 <fork+0xbe>
    if(p->ofile[i])
    800012b4:	6088                	ld	a0,0(s1)
    800012b6:	d97d                	beqz	a0,800012ac <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b8:	00002097          	auipc	ra,0x2
    800012bc:	64a080e7          	jalr	1610(ra) # 80003902 <filedup>
    800012c0:	00a93023          	sd	a0,0(s2)
    800012c4:	b7e5                	j	800012ac <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012c6:	150ab503          	ld	a0,336(s5)
    800012ca:	00001097          	auipc	ra,0x1
    800012ce:	7e2080e7          	jalr	2018(ra) # 80002aac <idup>
    800012d2:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012d6:	4641                	li	a2,16
    800012d8:	158a8593          	addi	a1,s5,344
    800012dc:	158a0513          	addi	a0,s4,344
    800012e0:	fffff097          	auipc	ra,0xfffff
    800012e4:	fe2080e7          	jalr	-30(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800012e8:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012ec:	8552                	mv	a0,s4
    800012ee:	00005097          	auipc	ra,0x5
    800012f2:	e44080e7          	jalr	-444(ra) # 80006132 <release>
  acquire(&wait_lock);
    800012f6:	00007497          	auipc	s1,0x7
    800012fa:	62248493          	addi	s1,s1,1570 # 80008918 <wait_lock>
    800012fe:	8526                	mv	a0,s1
    80001300:	00005097          	auipc	ra,0x5
    80001304:	d7e080e7          	jalr	-642(ra) # 8000607e <acquire>
  np->parent = p;
    80001308:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	e24080e7          	jalr	-476(ra) # 80006132 <release>
  acquire(&np->lock);
    80001316:	8552                	mv	a0,s4
    80001318:	00005097          	auipc	ra,0x5
    8000131c:	d66080e7          	jalr	-666(ra) # 8000607e <acquire>
  np->state = RUNNABLE;
    80001320:	478d                	li	a5,3
    80001322:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001326:	8552                	mv	a0,s4
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	e0a080e7          	jalr	-502(ra) # 80006132 <release>
}
    80001330:	854a                	mv	a0,s2
    80001332:	70e2                	ld	ra,56(sp)
    80001334:	7442                	ld	s0,48(sp)
    80001336:	74a2                	ld	s1,40(sp)
    80001338:	7902                	ld	s2,32(sp)
    8000133a:	69e2                	ld	s3,24(sp)
    8000133c:	6a42                	ld	s4,16(sp)
    8000133e:	6aa2                	ld	s5,8(sp)
    80001340:	6121                	addi	sp,sp,64
    80001342:	8082                	ret
    return -1;
    80001344:	597d                	li	s2,-1
    80001346:	b7ed                	j	80001330 <fork+0x128>

0000000080001348 <scheduler>:
{
    80001348:	7139                	addi	sp,sp,-64
    8000134a:	fc06                	sd	ra,56(sp)
    8000134c:	f822                	sd	s0,48(sp)
    8000134e:	f426                	sd	s1,40(sp)
    80001350:	f04a                	sd	s2,32(sp)
    80001352:	ec4e                	sd	s3,24(sp)
    80001354:	e852                	sd	s4,16(sp)
    80001356:	e456                	sd	s5,8(sp)
    80001358:	e05a                	sd	s6,0(sp)
    8000135a:	0080                	addi	s0,sp,64
    8000135c:	8792                	mv	a5,tp
  int id = r_tp();
    8000135e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001360:	00779a93          	slli	s5,a5,0x7
    80001364:	00007717          	auipc	a4,0x7
    80001368:	59c70713          	addi	a4,a4,1436 # 80008900 <pid_lock>
    8000136c:	9756                	add	a4,a4,s5
    8000136e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001372:	00007717          	auipc	a4,0x7
    80001376:	5c670713          	addi	a4,a4,1478 # 80008938 <cpus+0x8>
    8000137a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000137c:	498d                	li	s3,3
        p->state = RUNNING;
    8000137e:	4b11                	li	s6,4
        c->proc = p;
    80001380:	079e                	slli	a5,a5,0x7
    80001382:	00007a17          	auipc	s4,0x7
    80001386:	57ea0a13          	addi	s4,s4,1406 # 80008900 <pid_lock>
    8000138a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000138c:	0000d917          	auipc	s2,0xd
    80001390:	3a490913          	addi	s2,s2,932 # 8000e730 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001394:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001398:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000139c:	10079073          	csrw	sstatus,a5
    800013a0:	00008497          	auipc	s1,0x8
    800013a4:	99048493          	addi	s1,s1,-1648 # 80008d30 <proc>
    800013a8:	a811                	j	800013bc <scheduler+0x74>
      release(&p->lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	00005097          	auipc	ra,0x5
    800013b0:	d86080e7          	jalr	-634(ra) # 80006132 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013b4:	16848493          	addi	s1,s1,360
    800013b8:	fd248ee3          	beq	s1,s2,80001394 <scheduler+0x4c>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	00005097          	auipc	ra,0x5
    800013c2:	cc0080e7          	jalr	-832(ra) # 8000607e <acquire>
      if(p->state == RUNNABLE) {
    800013c6:	4c9c                	lw	a5,24(s1)
    800013c8:	ff3791e3          	bne	a5,s3,800013aa <scheduler+0x62>
        p->state = RUNNING;
    800013cc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013d4:	06048593          	addi	a1,s1,96
    800013d8:	8556                	mv	a0,s5
    800013da:	00000097          	auipc	ra,0x0
    800013de:	684080e7          	jalr	1668(ra) # 80001a5e <swtch>
        c->proc = 0;
    800013e2:	020a3823          	sd	zero,48(s4)
    800013e6:	b7d1                	j	800013aa <scheduler+0x62>

00000000800013e8 <sched>:
{
    800013e8:	7179                	addi	sp,sp,-48
    800013ea:	f406                	sd	ra,40(sp)
    800013ec:	f022                	sd	s0,32(sp)
    800013ee:	ec26                	sd	s1,24(sp)
    800013f0:	e84a                	sd	s2,16(sp)
    800013f2:	e44e                	sd	s3,8(sp)
    800013f4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f6:	00000097          	auipc	ra,0x0
    800013fa:	a5c080e7          	jalr	-1444(ra) # 80000e52 <myproc>
    800013fe:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001400:	00005097          	auipc	ra,0x5
    80001404:	c04080e7          	jalr	-1020(ra) # 80006004 <holding>
    80001408:	c93d                	beqz	a0,8000147e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000140a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000140c:	2781                	sext.w	a5,a5
    8000140e:	079e                	slli	a5,a5,0x7
    80001410:	00007717          	auipc	a4,0x7
    80001414:	4f070713          	addi	a4,a4,1264 # 80008900 <pid_lock>
    80001418:	97ba                	add	a5,a5,a4
    8000141a:	0a87a703          	lw	a4,168(a5)
    8000141e:	4785                	li	a5,1
    80001420:	06f71763          	bne	a4,a5,8000148e <sched+0xa6>
  if(p->state == RUNNING)
    80001424:	4c98                	lw	a4,24(s1)
    80001426:	4791                	li	a5,4
    80001428:	06f70b63          	beq	a4,a5,8000149e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001430:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001432:	efb5                	bnez	a5,800014ae <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001434:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001436:	00007917          	auipc	s2,0x7
    8000143a:	4ca90913          	addi	s2,s2,1226 # 80008900 <pid_lock>
    8000143e:	2781                	sext.w	a5,a5
    80001440:	079e                	slli	a5,a5,0x7
    80001442:	97ca                	add	a5,a5,s2
    80001444:	0ac7a983          	lw	s3,172(a5)
    80001448:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000144a:	2781                	sext.w	a5,a5
    8000144c:	079e                	slli	a5,a5,0x7
    8000144e:	00007597          	auipc	a1,0x7
    80001452:	4ea58593          	addi	a1,a1,1258 # 80008938 <cpus+0x8>
    80001456:	95be                	add	a1,a1,a5
    80001458:	06048513          	addi	a0,s1,96
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	602080e7          	jalr	1538(ra) # 80001a5e <swtch>
    80001464:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	993e                	add	s2,s2,a5
    8000146c:	0b392623          	sw	s3,172(s2)
}
    80001470:	70a2                	ld	ra,40(sp)
    80001472:	7402                	ld	s0,32(sp)
    80001474:	64e2                	ld	s1,24(sp)
    80001476:	6942                	ld	s2,16(sp)
    80001478:	69a2                	ld	s3,8(sp)
    8000147a:	6145                	addi	sp,sp,48
    8000147c:	8082                	ret
    panic("sched p->lock");
    8000147e:	00007517          	auipc	a0,0x7
    80001482:	d1a50513          	addi	a0,a0,-742 # 80008198 <etext+0x198>
    80001486:	00004097          	auipc	ra,0x4
    8000148a:	6c0080e7          	jalr	1728(ra) # 80005b46 <panic>
    panic("sched locks");
    8000148e:	00007517          	auipc	a0,0x7
    80001492:	d1a50513          	addi	a0,a0,-742 # 800081a8 <etext+0x1a8>
    80001496:	00004097          	auipc	ra,0x4
    8000149a:	6b0080e7          	jalr	1712(ra) # 80005b46 <panic>
    panic("sched running");
    8000149e:	00007517          	auipc	a0,0x7
    800014a2:	d1a50513          	addi	a0,a0,-742 # 800081b8 <etext+0x1b8>
    800014a6:	00004097          	auipc	ra,0x4
    800014aa:	6a0080e7          	jalr	1696(ra) # 80005b46 <panic>
    panic("sched interruptible");
    800014ae:	00007517          	auipc	a0,0x7
    800014b2:	d1a50513          	addi	a0,a0,-742 # 800081c8 <etext+0x1c8>
    800014b6:	00004097          	auipc	ra,0x4
    800014ba:	690080e7          	jalr	1680(ra) # 80005b46 <panic>

00000000800014be <yield>:
{
    800014be:	1101                	addi	sp,sp,-32
    800014c0:	ec06                	sd	ra,24(sp)
    800014c2:	e822                	sd	s0,16(sp)
    800014c4:	e426                	sd	s1,8(sp)
    800014c6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014c8:	00000097          	auipc	ra,0x0
    800014cc:	98a080e7          	jalr	-1654(ra) # 80000e52 <myproc>
    800014d0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d2:	00005097          	auipc	ra,0x5
    800014d6:	bac080e7          	jalr	-1108(ra) # 8000607e <acquire>
  p->state = RUNNABLE;
    800014da:	478d                	li	a5,3
    800014dc:	cc9c                	sw	a5,24(s1)
  sched();
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	f0a080e7          	jalr	-246(ra) # 800013e8 <sched>
  release(&p->lock);
    800014e6:	8526                	mv	a0,s1
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	c4a080e7          	jalr	-950(ra) # 80006132 <release>
}
    800014f0:	60e2                	ld	ra,24(sp)
    800014f2:	6442                	ld	s0,16(sp)
    800014f4:	64a2                	ld	s1,8(sp)
    800014f6:	6105                	addi	sp,sp,32
    800014f8:	8082                	ret

00000000800014fa <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014fa:	7179                	addi	sp,sp,-48
    800014fc:	f406                	sd	ra,40(sp)
    800014fe:	f022                	sd	s0,32(sp)
    80001500:	ec26                	sd	s1,24(sp)
    80001502:	e84a                	sd	s2,16(sp)
    80001504:	e44e                	sd	s3,8(sp)
    80001506:	1800                	addi	s0,sp,48
    80001508:	89aa                	mv	s3,a0
    8000150a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	946080e7          	jalr	-1722(ra) # 80000e52 <myproc>
    80001514:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	b68080e7          	jalr	-1176(ra) # 8000607e <acquire>
  release(lk);
    8000151e:	854a                	mv	a0,s2
    80001520:	00005097          	auipc	ra,0x5
    80001524:	c12080e7          	jalr	-1006(ra) # 80006132 <release>

  // Go to sleep.
  p->chan = chan;
    80001528:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000152c:	4789                	li	a5,2
    8000152e:	cc9c                	sw	a5,24(s1)

  sched();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	eb8080e7          	jalr	-328(ra) # 800013e8 <sched>

  // Tidy up.
  p->chan = 0;
    80001538:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	bf4080e7          	jalr	-1036(ra) # 80006132 <release>
  acquire(lk);
    80001546:	854a                	mv	a0,s2
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	b36080e7          	jalr	-1226(ra) # 8000607e <acquire>
}
    80001550:	70a2                	ld	ra,40(sp)
    80001552:	7402                	ld	s0,32(sp)
    80001554:	64e2                	ld	s1,24(sp)
    80001556:	6942                	ld	s2,16(sp)
    80001558:	69a2                	ld	s3,8(sp)
    8000155a:	6145                	addi	sp,sp,48
    8000155c:	8082                	ret

000000008000155e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000155e:	7139                	addi	sp,sp,-64
    80001560:	fc06                	sd	ra,56(sp)
    80001562:	f822                	sd	s0,48(sp)
    80001564:	f426                	sd	s1,40(sp)
    80001566:	f04a                	sd	s2,32(sp)
    80001568:	ec4e                	sd	s3,24(sp)
    8000156a:	e852                	sd	s4,16(sp)
    8000156c:	e456                	sd	s5,8(sp)
    8000156e:	0080                	addi	s0,sp,64
    80001570:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001572:	00007497          	auipc	s1,0x7
    80001576:	7be48493          	addi	s1,s1,1982 # 80008d30 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000157a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000157c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000157e:	0000d917          	auipc	s2,0xd
    80001582:	1b290913          	addi	s2,s2,434 # 8000e730 <tickslock>
    80001586:	a811                	j	8000159a <wakeup+0x3c>
      }
      release(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	ba8080e7          	jalr	-1112(ra) # 80006132 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001592:	16848493          	addi	s1,s1,360
    80001596:	03248663          	beq	s1,s2,800015c2 <wakeup+0x64>
    if(p != myproc()){
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	8b8080e7          	jalr	-1864(ra) # 80000e52 <myproc>
    800015a2:	fea488e3          	beq	s1,a0,80001592 <wakeup+0x34>
      acquire(&p->lock);
    800015a6:	8526                	mv	a0,s1
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	ad6080e7          	jalr	-1322(ra) # 8000607e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015b0:	4c9c                	lw	a5,24(s1)
    800015b2:	fd379be3          	bne	a5,s3,80001588 <wakeup+0x2a>
    800015b6:	709c                	ld	a5,32(s1)
    800015b8:	fd4798e3          	bne	a5,s4,80001588 <wakeup+0x2a>
        p->state = RUNNABLE;
    800015bc:	0154ac23          	sw	s5,24(s1)
    800015c0:	b7e1                	j	80001588 <wakeup+0x2a>
    }
  }
}
    800015c2:	70e2                	ld	ra,56(sp)
    800015c4:	7442                	ld	s0,48(sp)
    800015c6:	74a2                	ld	s1,40(sp)
    800015c8:	7902                	ld	s2,32(sp)
    800015ca:	69e2                	ld	s3,24(sp)
    800015cc:	6a42                	ld	s4,16(sp)
    800015ce:	6aa2                	ld	s5,8(sp)
    800015d0:	6121                	addi	sp,sp,64
    800015d2:	8082                	ret

00000000800015d4 <reparent>:
{
    800015d4:	7179                	addi	sp,sp,-48
    800015d6:	f406                	sd	ra,40(sp)
    800015d8:	f022                	sd	s0,32(sp)
    800015da:	ec26                	sd	s1,24(sp)
    800015dc:	e84a                	sd	s2,16(sp)
    800015de:	e44e                	sd	s3,8(sp)
    800015e0:	e052                	sd	s4,0(sp)
    800015e2:	1800                	addi	s0,sp,48
    800015e4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015e6:	00007497          	auipc	s1,0x7
    800015ea:	74a48493          	addi	s1,s1,1866 # 80008d30 <proc>
      pp->parent = initproc;
    800015ee:	00007a17          	auipc	s4,0x7
    800015f2:	2d2a0a13          	addi	s4,s4,722 # 800088c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f6:	0000d997          	auipc	s3,0xd
    800015fa:	13a98993          	addi	s3,s3,314 # 8000e730 <tickslock>
    800015fe:	a029                	j	80001608 <reparent+0x34>
    80001600:	16848493          	addi	s1,s1,360
    80001604:	01348d63          	beq	s1,s3,8000161e <reparent+0x4a>
    if(pp->parent == p){
    80001608:	7c9c                	ld	a5,56(s1)
    8000160a:	ff279be3          	bne	a5,s2,80001600 <reparent+0x2c>
      pp->parent = initproc;
    8000160e:	000a3503          	ld	a0,0(s4)
    80001612:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001614:	00000097          	auipc	ra,0x0
    80001618:	f4a080e7          	jalr	-182(ra) # 8000155e <wakeup>
    8000161c:	b7d5                	j	80001600 <reparent+0x2c>
}
    8000161e:	70a2                	ld	ra,40(sp)
    80001620:	7402                	ld	s0,32(sp)
    80001622:	64e2                	ld	s1,24(sp)
    80001624:	6942                	ld	s2,16(sp)
    80001626:	69a2                	ld	s3,8(sp)
    80001628:	6a02                	ld	s4,0(sp)
    8000162a:	6145                	addi	sp,sp,48
    8000162c:	8082                	ret

000000008000162e <exit>:
{
    8000162e:	7179                	addi	sp,sp,-48
    80001630:	f406                	sd	ra,40(sp)
    80001632:	f022                	sd	s0,32(sp)
    80001634:	ec26                	sd	s1,24(sp)
    80001636:	e84a                	sd	s2,16(sp)
    80001638:	e44e                	sd	s3,8(sp)
    8000163a:	e052                	sd	s4,0(sp)
    8000163c:	1800                	addi	s0,sp,48
    8000163e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001640:	00000097          	auipc	ra,0x0
    80001644:	812080e7          	jalr	-2030(ra) # 80000e52 <myproc>
    80001648:	89aa                	mv	s3,a0
  if(p == initproc)
    8000164a:	00007797          	auipc	a5,0x7
    8000164e:	2767b783          	ld	a5,630(a5) # 800088c0 <initproc>
    80001652:	0d050493          	addi	s1,a0,208
    80001656:	15050913          	addi	s2,a0,336
    8000165a:	02a79363          	bne	a5,a0,80001680 <exit+0x52>
    panic("init exiting");
    8000165e:	00007517          	auipc	a0,0x7
    80001662:	b8250513          	addi	a0,a0,-1150 # 800081e0 <etext+0x1e0>
    80001666:	00004097          	auipc	ra,0x4
    8000166a:	4e0080e7          	jalr	1248(ra) # 80005b46 <panic>
      fileclose(f);
    8000166e:	00002097          	auipc	ra,0x2
    80001672:	2e6080e7          	jalr	742(ra) # 80003954 <fileclose>
      p->ofile[fd] = 0;
    80001676:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000167a:	04a1                	addi	s1,s1,8
    8000167c:	01248563          	beq	s1,s2,80001686 <exit+0x58>
    if(p->ofile[fd]){
    80001680:	6088                	ld	a0,0(s1)
    80001682:	f575                	bnez	a0,8000166e <exit+0x40>
    80001684:	bfdd                	j	8000167a <exit+0x4c>
  begin_op();
    80001686:	00002097          	auipc	ra,0x2
    8000168a:	e0a080e7          	jalr	-502(ra) # 80003490 <begin_op>
  iput(p->cwd);
    8000168e:	1509b503          	ld	a0,336(s3)
    80001692:	00001097          	auipc	ra,0x1
    80001696:	612080e7          	jalr	1554(ra) # 80002ca4 <iput>
  end_op();
    8000169a:	00002097          	auipc	ra,0x2
    8000169e:	e70080e7          	jalr	-400(ra) # 8000350a <end_op>
  p->cwd = 0;
    800016a2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a6:	00007497          	auipc	s1,0x7
    800016aa:	27248493          	addi	s1,s1,626 # 80008918 <wait_lock>
    800016ae:	8526                	mv	a0,s1
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	9ce080e7          	jalr	-1586(ra) # 8000607e <acquire>
  reparent(p);
    800016b8:	854e                	mv	a0,s3
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	f1a080e7          	jalr	-230(ra) # 800015d4 <reparent>
  wakeup(p->parent);
    800016c2:	0389b503          	ld	a0,56(s3)
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	e98080e7          	jalr	-360(ra) # 8000155e <wakeup>
  acquire(&p->lock);
    800016ce:	854e                	mv	a0,s3
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	9ae080e7          	jalr	-1618(ra) # 8000607e <acquire>
  p->xstate = status;
    800016d8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016dc:	4795                	li	a5,5
    800016de:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016e2:	8526                	mv	a0,s1
    800016e4:	00005097          	auipc	ra,0x5
    800016e8:	a4e080e7          	jalr	-1458(ra) # 80006132 <release>
  sched();
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	cfc080e7          	jalr	-772(ra) # 800013e8 <sched>
  panic("zombie exit");
    800016f4:	00007517          	auipc	a0,0x7
    800016f8:	afc50513          	addi	a0,a0,-1284 # 800081f0 <etext+0x1f0>
    800016fc:	00004097          	auipc	ra,0x4
    80001700:	44a080e7          	jalr	1098(ra) # 80005b46 <panic>

0000000080001704 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001704:	7179                	addi	sp,sp,-48
    80001706:	f406                	sd	ra,40(sp)
    80001708:	f022                	sd	s0,32(sp)
    8000170a:	ec26                	sd	s1,24(sp)
    8000170c:	e84a                	sd	s2,16(sp)
    8000170e:	e44e                	sd	s3,8(sp)
    80001710:	1800                	addi	s0,sp,48
    80001712:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001714:	00007497          	auipc	s1,0x7
    80001718:	61c48493          	addi	s1,s1,1564 # 80008d30 <proc>
    8000171c:	0000d997          	auipc	s3,0xd
    80001720:	01498993          	addi	s3,s3,20 # 8000e730 <tickslock>
    acquire(&p->lock);
    80001724:	8526                	mv	a0,s1
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	958080e7          	jalr	-1704(ra) # 8000607e <acquire>
    if(p->pid == pid){
    8000172e:	589c                	lw	a5,48(s1)
    80001730:	01278d63          	beq	a5,s2,8000174a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001734:	8526                	mv	a0,s1
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	9fc080e7          	jalr	-1540(ra) # 80006132 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000173e:	16848493          	addi	s1,s1,360
    80001742:	ff3491e3          	bne	s1,s3,80001724 <kill+0x20>
  }
  return -1;
    80001746:	557d                	li	a0,-1
    80001748:	a829                	j	80001762 <kill+0x5e>
      p->killed = 1;
    8000174a:	4785                	li	a5,1
    8000174c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000174e:	4c98                	lw	a4,24(s1)
    80001750:	4789                	li	a5,2
    80001752:	00f70f63          	beq	a4,a5,80001770 <kill+0x6c>
      release(&p->lock);
    80001756:	8526                	mv	a0,s1
    80001758:	00005097          	auipc	ra,0x5
    8000175c:	9da080e7          	jalr	-1574(ra) # 80006132 <release>
      return 0;
    80001760:	4501                	li	a0,0
}
    80001762:	70a2                	ld	ra,40(sp)
    80001764:	7402                	ld	s0,32(sp)
    80001766:	64e2                	ld	s1,24(sp)
    80001768:	6942                	ld	s2,16(sp)
    8000176a:	69a2                	ld	s3,8(sp)
    8000176c:	6145                	addi	sp,sp,48
    8000176e:	8082                	ret
        p->state = RUNNABLE;
    80001770:	478d                	li	a5,3
    80001772:	cc9c                	sw	a5,24(s1)
    80001774:	b7cd                	j	80001756 <kill+0x52>

0000000080001776 <setkilled>:

void
setkilled(struct proc *p)
{
    80001776:	1101                	addi	sp,sp,-32
    80001778:	ec06                	sd	ra,24(sp)
    8000177a:	e822                	sd	s0,16(sp)
    8000177c:	e426                	sd	s1,8(sp)
    8000177e:	1000                	addi	s0,sp,32
    80001780:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001782:	00005097          	auipc	ra,0x5
    80001786:	8fc080e7          	jalr	-1796(ra) # 8000607e <acquire>
  p->killed = 1;
    8000178a:	4785                	li	a5,1
    8000178c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000178e:	8526                	mv	a0,s1
    80001790:	00005097          	auipc	ra,0x5
    80001794:	9a2080e7          	jalr	-1630(ra) # 80006132 <release>
}
    80001798:	60e2                	ld	ra,24(sp)
    8000179a:	6442                	ld	s0,16(sp)
    8000179c:	64a2                	ld	s1,8(sp)
    8000179e:	6105                	addi	sp,sp,32
    800017a0:	8082                	ret

00000000800017a2 <killed>:

int
killed(struct proc *p)
{
    800017a2:	1101                	addi	sp,sp,-32
    800017a4:	ec06                	sd	ra,24(sp)
    800017a6:	e822                	sd	s0,16(sp)
    800017a8:	e426                	sd	s1,8(sp)
    800017aa:	e04a                	sd	s2,0(sp)
    800017ac:	1000                	addi	s0,sp,32
    800017ae:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	8ce080e7          	jalr	-1842(ra) # 8000607e <acquire>
  k = p->killed;
    800017b8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017bc:	8526                	mv	a0,s1
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	974080e7          	jalr	-1676(ra) # 80006132 <release>
  return k;
}
    800017c6:	854a                	mv	a0,s2
    800017c8:	60e2                	ld	ra,24(sp)
    800017ca:	6442                	ld	s0,16(sp)
    800017cc:	64a2                	ld	s1,8(sp)
    800017ce:	6902                	ld	s2,0(sp)
    800017d0:	6105                	addi	sp,sp,32
    800017d2:	8082                	ret

00000000800017d4 <wait>:
{
    800017d4:	715d                	addi	sp,sp,-80
    800017d6:	e486                	sd	ra,72(sp)
    800017d8:	e0a2                	sd	s0,64(sp)
    800017da:	fc26                	sd	s1,56(sp)
    800017dc:	f84a                	sd	s2,48(sp)
    800017de:	f44e                	sd	s3,40(sp)
    800017e0:	f052                	sd	s4,32(sp)
    800017e2:	ec56                	sd	s5,24(sp)
    800017e4:	e85a                	sd	s6,16(sp)
    800017e6:	e45e                	sd	s7,8(sp)
    800017e8:	e062                	sd	s8,0(sp)
    800017ea:	0880                	addi	s0,sp,80
    800017ec:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017ee:	fffff097          	auipc	ra,0xfffff
    800017f2:	664080e7          	jalr	1636(ra) # 80000e52 <myproc>
    800017f6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017f8:	00007517          	auipc	a0,0x7
    800017fc:	12050513          	addi	a0,a0,288 # 80008918 <wait_lock>
    80001800:	00005097          	auipc	ra,0x5
    80001804:	87e080e7          	jalr	-1922(ra) # 8000607e <acquire>
    havekids = 0;
    80001808:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000180a:	4a15                	li	s4,5
        havekids = 1;
    8000180c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000180e:	0000d997          	auipc	s3,0xd
    80001812:	f2298993          	addi	s3,s3,-222 # 8000e730 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001816:	00007c17          	auipc	s8,0x7
    8000181a:	102c0c13          	addi	s8,s8,258 # 80008918 <wait_lock>
    8000181e:	a0d1                	j	800018e2 <wait+0x10e>
          pid = pp->pid;
    80001820:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001824:	000b0e63          	beqz	s6,80001840 <wait+0x6c>
    80001828:	4691                	li	a3,4
    8000182a:	02c48613          	addi	a2,s1,44
    8000182e:	85da                	mv	a1,s6
    80001830:	05093503          	ld	a0,80(s2)
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	2de080e7          	jalr	734(ra) # 80000b12 <copyout>
    8000183c:	04054163          	bltz	a0,8000187e <wait+0xaa>
          freeproc(pp);
    80001840:	8526                	mv	a0,s1
    80001842:	fffff097          	auipc	ra,0xfffff
    80001846:	7c2080e7          	jalr	1986(ra) # 80001004 <freeproc>
          release(&pp->lock);
    8000184a:	8526                	mv	a0,s1
    8000184c:	00005097          	auipc	ra,0x5
    80001850:	8e6080e7          	jalr	-1818(ra) # 80006132 <release>
          release(&wait_lock);
    80001854:	00007517          	auipc	a0,0x7
    80001858:	0c450513          	addi	a0,a0,196 # 80008918 <wait_lock>
    8000185c:	00005097          	auipc	ra,0x5
    80001860:	8d6080e7          	jalr	-1834(ra) # 80006132 <release>
}
    80001864:	854e                	mv	a0,s3
    80001866:	60a6                	ld	ra,72(sp)
    80001868:	6406                	ld	s0,64(sp)
    8000186a:	74e2                	ld	s1,56(sp)
    8000186c:	7942                	ld	s2,48(sp)
    8000186e:	79a2                	ld	s3,40(sp)
    80001870:	7a02                	ld	s4,32(sp)
    80001872:	6ae2                	ld	s5,24(sp)
    80001874:	6b42                	ld	s6,16(sp)
    80001876:	6ba2                	ld	s7,8(sp)
    80001878:	6c02                	ld	s8,0(sp)
    8000187a:	6161                	addi	sp,sp,80
    8000187c:	8082                	ret
            release(&pp->lock);
    8000187e:	8526                	mv	a0,s1
    80001880:	00005097          	auipc	ra,0x5
    80001884:	8b2080e7          	jalr	-1870(ra) # 80006132 <release>
            release(&wait_lock);
    80001888:	00007517          	auipc	a0,0x7
    8000188c:	09050513          	addi	a0,a0,144 # 80008918 <wait_lock>
    80001890:	00005097          	auipc	ra,0x5
    80001894:	8a2080e7          	jalr	-1886(ra) # 80006132 <release>
            return -1;
    80001898:	59fd                	li	s3,-1
    8000189a:	b7e9                	j	80001864 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000189c:	16848493          	addi	s1,s1,360
    800018a0:	03348463          	beq	s1,s3,800018c8 <wait+0xf4>
      if(pp->parent == p){
    800018a4:	7c9c                	ld	a5,56(s1)
    800018a6:	ff279be3          	bne	a5,s2,8000189c <wait+0xc8>
        acquire(&pp->lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00004097          	auipc	ra,0x4
    800018b0:	7d2080e7          	jalr	2002(ra) # 8000607e <acquire>
        if(pp->state == ZOMBIE){
    800018b4:	4c9c                	lw	a5,24(s1)
    800018b6:	f74785e3          	beq	a5,s4,80001820 <wait+0x4c>
        release(&pp->lock);
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	876080e7          	jalr	-1930(ra) # 80006132 <release>
        havekids = 1;
    800018c4:	8756                	mv	a4,s5
    800018c6:	bfd9                	j	8000189c <wait+0xc8>
    if(!havekids || killed(p)){
    800018c8:	c31d                	beqz	a4,800018ee <wait+0x11a>
    800018ca:	854a                	mv	a0,s2
    800018cc:	00000097          	auipc	ra,0x0
    800018d0:	ed6080e7          	jalr	-298(ra) # 800017a2 <killed>
    800018d4:	ed09                	bnez	a0,800018ee <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018d6:	85e2                	mv	a1,s8
    800018d8:	854a                	mv	a0,s2
    800018da:	00000097          	auipc	ra,0x0
    800018de:	c20080e7          	jalr	-992(ra) # 800014fa <sleep>
    havekids = 0;
    800018e2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e4:	00007497          	auipc	s1,0x7
    800018e8:	44c48493          	addi	s1,s1,1100 # 80008d30 <proc>
    800018ec:	bf65                	j	800018a4 <wait+0xd0>
      release(&wait_lock);
    800018ee:	00007517          	auipc	a0,0x7
    800018f2:	02a50513          	addi	a0,a0,42 # 80008918 <wait_lock>
    800018f6:	00005097          	auipc	ra,0x5
    800018fa:	83c080e7          	jalr	-1988(ra) # 80006132 <release>
      return -1;
    800018fe:	59fd                	li	s3,-1
    80001900:	b795                	j	80001864 <wait+0x90>

0000000080001902 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001902:	7179                	addi	sp,sp,-48
    80001904:	f406                	sd	ra,40(sp)
    80001906:	f022                	sd	s0,32(sp)
    80001908:	ec26                	sd	s1,24(sp)
    8000190a:	e84a                	sd	s2,16(sp)
    8000190c:	e44e                	sd	s3,8(sp)
    8000190e:	e052                	sd	s4,0(sp)
    80001910:	1800                	addi	s0,sp,48
    80001912:	84aa                	mv	s1,a0
    80001914:	892e                	mv	s2,a1
    80001916:	89b2                	mv	s3,a2
    80001918:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	538080e7          	jalr	1336(ra) # 80000e52 <myproc>
  if(user_dst){
    80001922:	c08d                	beqz	s1,80001944 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001924:	86d2                	mv	a3,s4
    80001926:	864e                	mv	a2,s3
    80001928:	85ca                	mv	a1,s2
    8000192a:	6928                	ld	a0,80(a0)
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	1e6080e7          	jalr	486(ra) # 80000b12 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001934:	70a2                	ld	ra,40(sp)
    80001936:	7402                	ld	s0,32(sp)
    80001938:	64e2                	ld	s1,24(sp)
    8000193a:	6942                	ld	s2,16(sp)
    8000193c:	69a2                	ld	s3,8(sp)
    8000193e:	6a02                	ld	s4,0(sp)
    80001940:	6145                	addi	sp,sp,48
    80001942:	8082                	ret
    memmove((char *)dst, src, len);
    80001944:	000a061b          	sext.w	a2,s4
    80001948:	85ce                	mv	a1,s3
    8000194a:	854a                	mv	a0,s2
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	88a080e7          	jalr	-1910(ra) # 800001d6 <memmove>
    return 0;
    80001954:	8526                	mv	a0,s1
    80001956:	bff9                	j	80001934 <either_copyout+0x32>

0000000080001958 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001958:	7179                	addi	sp,sp,-48
    8000195a:	f406                	sd	ra,40(sp)
    8000195c:	f022                	sd	s0,32(sp)
    8000195e:	ec26                	sd	s1,24(sp)
    80001960:	e84a                	sd	s2,16(sp)
    80001962:	e44e                	sd	s3,8(sp)
    80001964:	e052                	sd	s4,0(sp)
    80001966:	1800                	addi	s0,sp,48
    80001968:	892a                	mv	s2,a0
    8000196a:	84ae                	mv	s1,a1
    8000196c:	89b2                	mv	s3,a2
    8000196e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	4e2080e7          	jalr	1250(ra) # 80000e52 <myproc>
  if(user_src){
    80001978:	c08d                	beqz	s1,8000199a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197a:	86d2                	mv	a3,s4
    8000197c:	864e                	mv	a2,s3
    8000197e:	85ca                	mv	a1,s2
    80001980:	6928                	ld	a0,80(a0)
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	21c080e7          	jalr	540(ra) # 80000b9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000198a:	70a2                	ld	ra,40(sp)
    8000198c:	7402                	ld	s0,32(sp)
    8000198e:	64e2                	ld	s1,24(sp)
    80001990:	6942                	ld	s2,16(sp)
    80001992:	69a2                	ld	s3,8(sp)
    80001994:	6a02                	ld	s4,0(sp)
    80001996:	6145                	addi	sp,sp,48
    80001998:	8082                	ret
    memmove(dst, (char*)src, len);
    8000199a:	000a061b          	sext.w	a2,s4
    8000199e:	85ce                	mv	a1,s3
    800019a0:	854a                	mv	a0,s2
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	834080e7          	jalr	-1996(ra) # 800001d6 <memmove>
    return 0;
    800019aa:	8526                	mv	a0,s1
    800019ac:	bff9                	j	8000198a <either_copyin+0x32>

00000000800019ae <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ae:	715d                	addi	sp,sp,-80
    800019b0:	e486                	sd	ra,72(sp)
    800019b2:	e0a2                	sd	s0,64(sp)
    800019b4:	fc26                	sd	s1,56(sp)
    800019b6:	f84a                	sd	s2,48(sp)
    800019b8:	f44e                	sd	s3,40(sp)
    800019ba:	f052                	sd	s4,32(sp)
    800019bc:	ec56                	sd	s5,24(sp)
    800019be:	e85a                	sd	s6,16(sp)
    800019c0:	e45e                	sd	s7,8(sp)
    800019c2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c4:	00006517          	auipc	a0,0x6
    800019c8:	68450513          	addi	a0,a0,1668 # 80008048 <etext+0x48>
    800019cc:	00004097          	auipc	ra,0x4
    800019d0:	1c4080e7          	jalr	452(ra) # 80005b90 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d4:	00007497          	auipc	s1,0x7
    800019d8:	4b448493          	addi	s1,s1,1204 # 80008e88 <proc+0x158>
    800019dc:	0000d917          	auipc	s2,0xd
    800019e0:	eac90913          	addi	s2,s2,-340 # 8000e888 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e6:	00007997          	auipc	s3,0x7
    800019ea:	81a98993          	addi	s3,s3,-2022 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ee:	00007a97          	auipc	s5,0x7
    800019f2:	81aa8a93          	addi	s5,s5,-2022 # 80008208 <etext+0x208>
    printf("\n");
    800019f6:	00006a17          	auipc	s4,0x6
    800019fa:	652a0a13          	addi	s4,s4,1618 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fe:	00007b97          	auipc	s7,0x7
    80001a02:	84ab8b93          	addi	s7,s7,-1974 # 80008248 <states.0>
    80001a06:	a00d                	j	80001a28 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a08:	ed86a583          	lw	a1,-296(a3)
    80001a0c:	8556                	mv	a0,s5
    80001a0e:	00004097          	auipc	ra,0x4
    80001a12:	182080e7          	jalr	386(ra) # 80005b90 <printf>
    printf("\n");
    80001a16:	8552                	mv	a0,s4
    80001a18:	00004097          	auipc	ra,0x4
    80001a1c:	178080e7          	jalr	376(ra) # 80005b90 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a20:	16848493          	addi	s1,s1,360
    80001a24:	03248263          	beq	s1,s2,80001a48 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a28:	86a6                	mv	a3,s1
    80001a2a:	ec04a783          	lw	a5,-320(s1)
    80001a2e:	dbed                	beqz	a5,80001a20 <procdump+0x72>
      state = "???";
    80001a30:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a32:	fcfb6be3          	bltu	s6,a5,80001a08 <procdump+0x5a>
    80001a36:	02079713          	slli	a4,a5,0x20
    80001a3a:	01d75793          	srli	a5,a4,0x1d
    80001a3e:	97de                	add	a5,a5,s7
    80001a40:	6390                	ld	a2,0(a5)
    80001a42:	f279                	bnez	a2,80001a08 <procdump+0x5a>
      state = "???";
    80001a44:	864e                	mv	a2,s3
    80001a46:	b7c9                	j	80001a08 <procdump+0x5a>
  }
}
    80001a48:	60a6                	ld	ra,72(sp)
    80001a4a:	6406                	ld	s0,64(sp)
    80001a4c:	74e2                	ld	s1,56(sp)
    80001a4e:	7942                	ld	s2,48(sp)
    80001a50:	79a2                	ld	s3,40(sp)
    80001a52:	7a02                	ld	s4,32(sp)
    80001a54:	6ae2                	ld	s5,24(sp)
    80001a56:	6b42                	ld	s6,16(sp)
    80001a58:	6ba2                	ld	s7,8(sp)
    80001a5a:	6161                	addi	sp,sp,80
    80001a5c:	8082                	ret

0000000080001a5e <swtch>:
    80001a5e:	00153023          	sd	ra,0(a0)
    80001a62:	00253423          	sd	sp,8(a0)
    80001a66:	e900                	sd	s0,16(a0)
    80001a68:	ed04                	sd	s1,24(a0)
    80001a6a:	03253023          	sd	s2,32(a0)
    80001a6e:	03353423          	sd	s3,40(a0)
    80001a72:	03453823          	sd	s4,48(a0)
    80001a76:	03553c23          	sd	s5,56(a0)
    80001a7a:	05653023          	sd	s6,64(a0)
    80001a7e:	05753423          	sd	s7,72(a0)
    80001a82:	05853823          	sd	s8,80(a0)
    80001a86:	05953c23          	sd	s9,88(a0)
    80001a8a:	07a53023          	sd	s10,96(a0)
    80001a8e:	07b53423          	sd	s11,104(a0)
    80001a92:	0005b083          	ld	ra,0(a1)
    80001a96:	0085b103          	ld	sp,8(a1)
    80001a9a:	6980                	ld	s0,16(a1)
    80001a9c:	6d84                	ld	s1,24(a1)
    80001a9e:	0205b903          	ld	s2,32(a1)
    80001aa2:	0285b983          	ld	s3,40(a1)
    80001aa6:	0305ba03          	ld	s4,48(a1)
    80001aaa:	0385ba83          	ld	s5,56(a1)
    80001aae:	0405bb03          	ld	s6,64(a1)
    80001ab2:	0485bb83          	ld	s7,72(a1)
    80001ab6:	0505bc03          	ld	s8,80(a1)
    80001aba:	0585bc83          	ld	s9,88(a1)
    80001abe:	0605bd03          	ld	s10,96(a1)
    80001ac2:	0685bd83          	ld	s11,104(a1)
    80001ac6:	8082                	ret

0000000080001ac8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ac8:	1141                	addi	sp,sp,-16
    80001aca:	e406                	sd	ra,8(sp)
    80001acc:	e022                	sd	s0,0(sp)
    80001ace:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ad0:	00006597          	auipc	a1,0x6
    80001ad4:	7a858593          	addi	a1,a1,1960 # 80008278 <states.0+0x30>
    80001ad8:	0000d517          	auipc	a0,0xd
    80001adc:	c5850513          	addi	a0,a0,-936 # 8000e730 <tickslock>
    80001ae0:	00004097          	auipc	ra,0x4
    80001ae4:	50e080e7          	jalr	1294(ra) # 80005fee <initlock>
}
    80001ae8:	60a2                	ld	ra,8(sp)
    80001aea:	6402                	ld	s0,0(sp)
    80001aec:	0141                	addi	sp,sp,16
    80001aee:	8082                	ret

0000000080001af0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001af0:	1141                	addi	sp,sp,-16
    80001af2:	e422                	sd	s0,8(sp)
    80001af4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af6:	00003797          	auipc	a5,0x3
    80001afa:	48a78793          	addi	a5,a5,1162 # 80004f80 <kernelvec>
    80001afe:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b02:	6422                	ld	s0,8(sp)
    80001b04:	0141                	addi	sp,sp,16
    80001b06:	8082                	ret

0000000080001b08 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b08:	1141                	addi	sp,sp,-16
    80001b0a:	e406                	sd	ra,8(sp)
    80001b0c:	e022                	sd	s0,0(sp)
    80001b0e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b10:	fffff097          	auipc	ra,0xfffff
    80001b14:	342080e7          	jalr	834(ra) # 80000e52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b1c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b1e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b22:	00005697          	auipc	a3,0x5
    80001b26:	4de68693          	addi	a3,a3,1246 # 80007000 <_trampoline>
    80001b2a:	00005717          	auipc	a4,0x5
    80001b2e:	4d670713          	addi	a4,a4,1238 # 80007000 <_trampoline>
    80001b32:	8f15                	sub	a4,a4,a3
    80001b34:	040007b7          	lui	a5,0x4000
    80001b38:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b3a:	07b2                	slli	a5,a5,0xc
    80001b3c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b3e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b42:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b44:	18002673          	csrr	a2,satp
    80001b48:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b4a:	6d30                	ld	a2,88(a0)
    80001b4c:	6138                	ld	a4,64(a0)
    80001b4e:	6585                	lui	a1,0x1
    80001b50:	972e                	add	a4,a4,a1
    80001b52:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b54:	6d38                	ld	a4,88(a0)
    80001b56:	00000617          	auipc	a2,0x0
    80001b5a:	13460613          	addi	a2,a2,308 # 80001c8a <usertrap>
    80001b5e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b60:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b62:	8612                	mv	a2,tp
    80001b64:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b66:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b6a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b6e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b72:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b76:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b78:	6f18                	ld	a4,24(a4)
    80001b7a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b7e:	6928                	ld	a0,80(a0)
    80001b80:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b82:	00005717          	auipc	a4,0x5
    80001b86:	51a70713          	addi	a4,a4,1306 # 8000709c <userret>
    80001b8a:	8f15                	sub	a4,a4,a3
    80001b8c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b8e:	577d                	li	a4,-1
    80001b90:	177e                	slli	a4,a4,0x3f
    80001b92:	8d59                	or	a0,a0,a4
    80001b94:	9782                	jalr	a5
}
    80001b96:	60a2                	ld	ra,8(sp)
    80001b98:	6402                	ld	s0,0(sp)
    80001b9a:	0141                	addi	sp,sp,16
    80001b9c:	8082                	ret

0000000080001b9e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b9e:	1101                	addi	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ba8:	0000d497          	auipc	s1,0xd
    80001bac:	b8848493          	addi	s1,s1,-1144 # 8000e730 <tickslock>
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	00004097          	auipc	ra,0x4
    80001bb6:	4cc080e7          	jalr	1228(ra) # 8000607e <acquire>
  ticks++;
    80001bba:	00007517          	auipc	a0,0x7
    80001bbe:	d0e50513          	addi	a0,a0,-754 # 800088c8 <ticks>
    80001bc2:	411c                	lw	a5,0(a0)
    80001bc4:	2785                	addiw	a5,a5,1
    80001bc6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bc8:	00000097          	auipc	ra,0x0
    80001bcc:	996080e7          	jalr	-1642(ra) # 8000155e <wakeup>
  release(&tickslock);
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	00004097          	auipc	ra,0x4
    80001bd6:	560080e7          	jalr	1376(ra) # 80006132 <release>
}
    80001bda:	60e2                	ld	ra,24(sp)
    80001bdc:	6442                	ld	s0,16(sp)
    80001bde:	64a2                	ld	s1,8(sp)
    80001be0:	6105                	addi	sp,sp,32
    80001be2:	8082                	ret

0000000080001be4 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001be4:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001be8:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001bea:	0807df63          	bgez	a5,80001c88 <devintr+0xa4>
{
    80001bee:	1101                	addi	sp,sp,-32
    80001bf0:	ec06                	sd	ra,24(sp)
    80001bf2:	e822                	sd	s0,16(sp)
    80001bf4:	e426                	sd	s1,8(sp)
    80001bf6:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001bf8:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001bfc:	46a5                	li	a3,9
    80001bfe:	00d70d63          	beq	a4,a3,80001c18 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001c02:	577d                	li	a4,-1
    80001c04:	177e                	slli	a4,a4,0x3f
    80001c06:	0705                	addi	a4,a4,1
    return 0;
    80001c08:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c0a:	04e78e63          	beq	a5,a4,80001c66 <devintr+0x82>
  }
}
    80001c0e:	60e2                	ld	ra,24(sp)
    80001c10:	6442                	ld	s0,16(sp)
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	6105                	addi	sp,sp,32
    80001c16:	8082                	ret
    int irq = plic_claim();
    80001c18:	00003097          	auipc	ra,0x3
    80001c1c:	470080e7          	jalr	1136(ra) # 80005088 <plic_claim>
    80001c20:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c22:	47a9                	li	a5,10
    80001c24:	02f50763          	beq	a0,a5,80001c52 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001c28:	4785                	li	a5,1
    80001c2a:	02f50963          	beq	a0,a5,80001c5c <devintr+0x78>
    return 1;
    80001c2e:	4505                	li	a0,1
    } else if(irq){
    80001c30:	dcf9                	beqz	s1,80001c0e <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c32:	85a6                	mv	a1,s1
    80001c34:	00006517          	auipc	a0,0x6
    80001c38:	64c50513          	addi	a0,a0,1612 # 80008280 <states.0+0x38>
    80001c3c:	00004097          	auipc	ra,0x4
    80001c40:	f54080e7          	jalr	-172(ra) # 80005b90 <printf>
      plic_complete(irq);
    80001c44:	8526                	mv	a0,s1
    80001c46:	00003097          	auipc	ra,0x3
    80001c4a:	466080e7          	jalr	1126(ra) # 800050ac <plic_complete>
    return 1;
    80001c4e:	4505                	li	a0,1
    80001c50:	bf7d                	j	80001c0e <devintr+0x2a>
      uartintr();
    80001c52:	00004097          	auipc	ra,0x4
    80001c56:	34c080e7          	jalr	844(ra) # 80005f9e <uartintr>
    if(irq)
    80001c5a:	b7ed                	j	80001c44 <devintr+0x60>
      virtio_disk_intr();
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	916080e7          	jalr	-1770(ra) # 80005572 <virtio_disk_intr>
    if(irq)
    80001c64:	b7c5                	j	80001c44 <devintr+0x60>
    if(cpuid() == 0){
    80001c66:	fffff097          	auipc	ra,0xfffff
    80001c6a:	1c0080e7          	jalr	448(ra) # 80000e26 <cpuid>
    80001c6e:	c901                	beqz	a0,80001c7e <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c70:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c74:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c76:	14479073          	csrw	sip,a5
    return 2;
    80001c7a:	4509                	li	a0,2
    80001c7c:	bf49                	j	80001c0e <devintr+0x2a>
      clockintr();
    80001c7e:	00000097          	auipc	ra,0x0
    80001c82:	f20080e7          	jalr	-224(ra) # 80001b9e <clockintr>
    80001c86:	b7ed                	j	80001c70 <devintr+0x8c>
}
    80001c88:	8082                	ret

0000000080001c8a <usertrap>:
{
    80001c8a:	1101                	addi	sp,sp,-32
    80001c8c:	ec06                	sd	ra,24(sp)
    80001c8e:	e822                	sd	s0,16(sp)
    80001c90:	e426                	sd	s1,8(sp)
    80001c92:	e04a                	sd	s2,0(sp)
    80001c94:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c96:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c9a:	1007f793          	andi	a5,a5,256
    80001c9e:	e3b1                	bnez	a5,80001ce2 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca0:	00003797          	auipc	a5,0x3
    80001ca4:	2e078793          	addi	a5,a5,736 # 80004f80 <kernelvec>
    80001ca8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cac:	fffff097          	auipc	ra,0xfffff
    80001cb0:	1a6080e7          	jalr	422(ra) # 80000e52 <myproc>
    80001cb4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cb6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb8:	14102773          	csrr	a4,sepc
    80001cbc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cbe:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cc2:	47a1                	li	a5,8
    80001cc4:	02f70763          	beq	a4,a5,80001cf2 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cc8:	00000097          	auipc	ra,0x0
    80001ccc:	f1c080e7          	jalr	-228(ra) # 80001be4 <devintr>
    80001cd0:	892a                	mv	s2,a0
    80001cd2:	c151                	beqz	a0,80001d56 <usertrap+0xcc>
  if(killed(p))
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	acc080e7          	jalr	-1332(ra) # 800017a2 <killed>
    80001cde:	c929                	beqz	a0,80001d30 <usertrap+0xa6>
    80001ce0:	a099                	j	80001d26 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001ce2:	00006517          	auipc	a0,0x6
    80001ce6:	5be50513          	addi	a0,a0,1470 # 800082a0 <states.0+0x58>
    80001cea:	00004097          	auipc	ra,0x4
    80001cee:	e5c080e7          	jalr	-420(ra) # 80005b46 <panic>
    if(killed(p))
    80001cf2:	00000097          	auipc	ra,0x0
    80001cf6:	ab0080e7          	jalr	-1360(ra) # 800017a2 <killed>
    80001cfa:	e921                	bnez	a0,80001d4a <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001cfc:	6cb8                	ld	a4,88(s1)
    80001cfe:	6f1c                	ld	a5,24(a4)
    80001d00:	0791                	addi	a5,a5,4
    80001d02:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d04:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d08:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d0c:	10079073          	csrw	sstatus,a5
    syscall();
    80001d10:	00000097          	auipc	ra,0x0
    80001d14:	2d4080e7          	jalr	724(ra) # 80001fe4 <syscall>
  if(killed(p))
    80001d18:	8526                	mv	a0,s1
    80001d1a:	00000097          	auipc	ra,0x0
    80001d1e:	a88080e7          	jalr	-1400(ra) # 800017a2 <killed>
    80001d22:	c911                	beqz	a0,80001d36 <usertrap+0xac>
    80001d24:	4901                	li	s2,0
    exit(-1);
    80001d26:	557d                	li	a0,-1
    80001d28:	00000097          	auipc	ra,0x0
    80001d2c:	906080e7          	jalr	-1786(ra) # 8000162e <exit>
  if(which_dev == 2)
    80001d30:	4789                	li	a5,2
    80001d32:	04f90f63          	beq	s2,a5,80001d90 <usertrap+0x106>
  usertrapret();
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	dd2080e7          	jalr	-558(ra) # 80001b08 <usertrapret>
}
    80001d3e:	60e2                	ld	ra,24(sp)
    80001d40:	6442                	ld	s0,16(sp)
    80001d42:	64a2                	ld	s1,8(sp)
    80001d44:	6902                	ld	s2,0(sp)
    80001d46:	6105                	addi	sp,sp,32
    80001d48:	8082                	ret
      exit(-1);
    80001d4a:	557d                	li	a0,-1
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	8e2080e7          	jalr	-1822(ra) # 8000162e <exit>
    80001d54:	b765                	j	80001cfc <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d56:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d5a:	5890                	lw	a2,48(s1)
    80001d5c:	00006517          	auipc	a0,0x6
    80001d60:	56450513          	addi	a0,a0,1380 # 800082c0 <states.0+0x78>
    80001d64:	00004097          	auipc	ra,0x4
    80001d68:	e2c080e7          	jalr	-468(ra) # 80005b90 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d6c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d70:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d74:	00006517          	auipc	a0,0x6
    80001d78:	57c50513          	addi	a0,a0,1404 # 800082f0 <states.0+0xa8>
    80001d7c:	00004097          	auipc	ra,0x4
    80001d80:	e14080e7          	jalr	-492(ra) # 80005b90 <printf>
    setkilled(p);
    80001d84:	8526                	mv	a0,s1
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	9f0080e7          	jalr	-1552(ra) # 80001776 <setkilled>
    80001d8e:	b769                	j	80001d18 <usertrap+0x8e>
    yield();
    80001d90:	fffff097          	auipc	ra,0xfffff
    80001d94:	72e080e7          	jalr	1838(ra) # 800014be <yield>
    80001d98:	bf79                	j	80001d36 <usertrap+0xac>

0000000080001d9a <kerneltrap>:
{
    80001d9a:	7179                	addi	sp,sp,-48
    80001d9c:	f406                	sd	ra,40(sp)
    80001d9e:	f022                	sd	s0,32(sp)
    80001da0:	ec26                	sd	s1,24(sp)
    80001da2:	e84a                	sd	s2,16(sp)
    80001da4:	e44e                	sd	s3,8(sp)
    80001da6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dac:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001db4:	1004f793          	andi	a5,s1,256
    80001db8:	cb85                	beqz	a5,80001de8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dbe:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dc0:	ef85                	bnez	a5,80001df8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dc2:	00000097          	auipc	ra,0x0
    80001dc6:	e22080e7          	jalr	-478(ra) # 80001be4 <devintr>
    80001dca:	cd1d                	beqz	a0,80001e08 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dcc:	4789                	li	a5,2
    80001dce:	06f50a63          	beq	a0,a5,80001e42 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dd2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd6:	10049073          	csrw	sstatus,s1
}
    80001dda:	70a2                	ld	ra,40(sp)
    80001ddc:	7402                	ld	s0,32(sp)
    80001dde:	64e2                	ld	s1,24(sp)
    80001de0:	6942                	ld	s2,16(sp)
    80001de2:	69a2                	ld	s3,8(sp)
    80001de4:	6145                	addi	sp,sp,48
    80001de6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de8:	00006517          	auipc	a0,0x6
    80001dec:	52850513          	addi	a0,a0,1320 # 80008310 <states.0+0xc8>
    80001df0:	00004097          	auipc	ra,0x4
    80001df4:	d56080e7          	jalr	-682(ra) # 80005b46 <panic>
    panic("kerneltrap: interrupts enabled");
    80001df8:	00006517          	auipc	a0,0x6
    80001dfc:	54050513          	addi	a0,a0,1344 # 80008338 <states.0+0xf0>
    80001e00:	00004097          	auipc	ra,0x4
    80001e04:	d46080e7          	jalr	-698(ra) # 80005b46 <panic>
    printf("scause %p\n", scause);
    80001e08:	85ce                	mv	a1,s3
    80001e0a:	00006517          	auipc	a0,0x6
    80001e0e:	54e50513          	addi	a0,a0,1358 # 80008358 <states.0+0x110>
    80001e12:	00004097          	auipc	ra,0x4
    80001e16:	d7e080e7          	jalr	-642(ra) # 80005b90 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e1a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e1e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e22:	00006517          	auipc	a0,0x6
    80001e26:	54650513          	addi	a0,a0,1350 # 80008368 <states.0+0x120>
    80001e2a:	00004097          	auipc	ra,0x4
    80001e2e:	d66080e7          	jalr	-666(ra) # 80005b90 <printf>
    panic("kerneltrap");
    80001e32:	00006517          	auipc	a0,0x6
    80001e36:	54e50513          	addi	a0,a0,1358 # 80008380 <states.0+0x138>
    80001e3a:	00004097          	auipc	ra,0x4
    80001e3e:	d0c080e7          	jalr	-756(ra) # 80005b46 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	010080e7          	jalr	16(ra) # 80000e52 <myproc>
    80001e4a:	d541                	beqz	a0,80001dd2 <kerneltrap+0x38>
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	006080e7          	jalr	6(ra) # 80000e52 <myproc>
    80001e54:	4d18                	lw	a4,24(a0)
    80001e56:	4791                	li	a5,4
    80001e58:	f6f71de3          	bne	a4,a5,80001dd2 <kerneltrap+0x38>
    yield();
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	662080e7          	jalr	1634(ra) # 800014be <yield>
    80001e64:	b7bd                	j	80001dd2 <kerneltrap+0x38>

0000000080001e66 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e66:	1101                	addi	sp,sp,-32
    80001e68:	ec06                	sd	ra,24(sp)
    80001e6a:	e822                	sd	s0,16(sp)
    80001e6c:	e426                	sd	s1,8(sp)
    80001e6e:	1000                	addi	s0,sp,32
    80001e70:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	fe0080e7          	jalr	-32(ra) # 80000e52 <myproc>
  switch (n) {
    80001e7a:	4795                	li	a5,5
    80001e7c:	0497e163          	bltu	a5,s1,80001ebe <argraw+0x58>
    80001e80:	048a                	slli	s1,s1,0x2
    80001e82:	00006717          	auipc	a4,0x6
    80001e86:	53670713          	addi	a4,a4,1334 # 800083b8 <states.0+0x170>
    80001e8a:	94ba                	add	s1,s1,a4
    80001e8c:	409c                	lw	a5,0(s1)
    80001e8e:	97ba                	add	a5,a5,a4
    80001e90:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e92:	6d3c                	ld	a5,88(a0)
    80001e94:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e96:	60e2                	ld	ra,24(sp)
    80001e98:	6442                	ld	s0,16(sp)
    80001e9a:	64a2                	ld	s1,8(sp)
    80001e9c:	6105                	addi	sp,sp,32
    80001e9e:	8082                	ret
    return p->trapframe->a1;
    80001ea0:	6d3c                	ld	a5,88(a0)
    80001ea2:	7fa8                	ld	a0,120(a5)
    80001ea4:	bfcd                	j	80001e96 <argraw+0x30>
    return p->trapframe->a2;
    80001ea6:	6d3c                	ld	a5,88(a0)
    80001ea8:	63c8                	ld	a0,128(a5)
    80001eaa:	b7f5                	j	80001e96 <argraw+0x30>
    return p->trapframe->a3;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	67c8                	ld	a0,136(a5)
    80001eb0:	b7dd                	j	80001e96 <argraw+0x30>
    return p->trapframe->a4;
    80001eb2:	6d3c                	ld	a5,88(a0)
    80001eb4:	6bc8                	ld	a0,144(a5)
    80001eb6:	b7c5                	j	80001e96 <argraw+0x30>
    return p->trapframe->a5;
    80001eb8:	6d3c                	ld	a5,88(a0)
    80001eba:	6fc8                	ld	a0,152(a5)
    80001ebc:	bfe9                	j	80001e96 <argraw+0x30>
  panic("argraw");
    80001ebe:	00006517          	auipc	a0,0x6
    80001ec2:	4d250513          	addi	a0,a0,1234 # 80008390 <states.0+0x148>
    80001ec6:	00004097          	auipc	ra,0x4
    80001eca:	c80080e7          	jalr	-896(ra) # 80005b46 <panic>

0000000080001ece <fetchaddr>:
{
    80001ece:	1101                	addi	sp,sp,-32
    80001ed0:	ec06                	sd	ra,24(sp)
    80001ed2:	e822                	sd	s0,16(sp)
    80001ed4:	e426                	sd	s1,8(sp)
    80001ed6:	e04a                	sd	s2,0(sp)
    80001ed8:	1000                	addi	s0,sp,32
    80001eda:	84aa                	mv	s1,a0
    80001edc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	f74080e7          	jalr	-140(ra) # 80000e52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ee6:	653c                	ld	a5,72(a0)
    80001ee8:	02f4f863          	bgeu	s1,a5,80001f18 <fetchaddr+0x4a>
    80001eec:	00848713          	addi	a4,s1,8
    80001ef0:	02e7e663          	bltu	a5,a4,80001f1c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ef4:	46a1                	li	a3,8
    80001ef6:	8626                	mv	a2,s1
    80001ef8:	85ca                	mv	a1,s2
    80001efa:	6928                	ld	a0,80(a0)
    80001efc:	fffff097          	auipc	ra,0xfffff
    80001f00:	ca2080e7          	jalr	-862(ra) # 80000b9e <copyin>
    80001f04:	00a03533          	snez	a0,a0
    80001f08:	40a00533          	neg	a0,a0
}
    80001f0c:	60e2                	ld	ra,24(sp)
    80001f0e:	6442                	ld	s0,16(sp)
    80001f10:	64a2                	ld	s1,8(sp)
    80001f12:	6902                	ld	s2,0(sp)
    80001f14:	6105                	addi	sp,sp,32
    80001f16:	8082                	ret
    return -1;
    80001f18:	557d                	li	a0,-1
    80001f1a:	bfcd                	j	80001f0c <fetchaddr+0x3e>
    80001f1c:	557d                	li	a0,-1
    80001f1e:	b7fd                	j	80001f0c <fetchaddr+0x3e>

0000000080001f20 <fetchstr>:
{
    80001f20:	7179                	addi	sp,sp,-48
    80001f22:	f406                	sd	ra,40(sp)
    80001f24:	f022                	sd	s0,32(sp)
    80001f26:	ec26                	sd	s1,24(sp)
    80001f28:	e84a                	sd	s2,16(sp)
    80001f2a:	e44e                	sd	s3,8(sp)
    80001f2c:	1800                	addi	s0,sp,48
    80001f2e:	892a                	mv	s2,a0
    80001f30:	84ae                	mv	s1,a1
    80001f32:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	f1e080e7          	jalr	-226(ra) # 80000e52 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f3c:	86ce                	mv	a3,s3
    80001f3e:	864a                	mv	a2,s2
    80001f40:	85a6                	mv	a1,s1
    80001f42:	6928                	ld	a0,80(a0)
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	ce8080e7          	jalr	-792(ra) # 80000c2c <copyinstr>
    80001f4c:	00054e63          	bltz	a0,80001f68 <fetchstr+0x48>
  return strlen(buf);
    80001f50:	8526                	mv	a0,s1
    80001f52:	ffffe097          	auipc	ra,0xffffe
    80001f56:	3a2080e7          	jalr	930(ra) # 800002f4 <strlen>
}
    80001f5a:	70a2                	ld	ra,40(sp)
    80001f5c:	7402                	ld	s0,32(sp)
    80001f5e:	64e2                	ld	s1,24(sp)
    80001f60:	6942                	ld	s2,16(sp)
    80001f62:	69a2                	ld	s3,8(sp)
    80001f64:	6145                	addi	sp,sp,48
    80001f66:	8082                	ret
    return -1;
    80001f68:	557d                	li	a0,-1
    80001f6a:	bfc5                	j	80001f5a <fetchstr+0x3a>

0000000080001f6c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f6c:	1101                	addi	sp,sp,-32
    80001f6e:	ec06                	sd	ra,24(sp)
    80001f70:	e822                	sd	s0,16(sp)
    80001f72:	e426                	sd	s1,8(sp)
    80001f74:	1000                	addi	s0,sp,32
    80001f76:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f78:	00000097          	auipc	ra,0x0
    80001f7c:	eee080e7          	jalr	-274(ra) # 80001e66 <argraw>
    80001f80:	c088                	sw	a0,0(s1)
}
    80001f82:	60e2                	ld	ra,24(sp)
    80001f84:	6442                	ld	s0,16(sp)
    80001f86:	64a2                	ld	s1,8(sp)
    80001f88:	6105                	addi	sp,sp,32
    80001f8a:	8082                	ret

0000000080001f8c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f8c:	1101                	addi	sp,sp,-32
    80001f8e:	ec06                	sd	ra,24(sp)
    80001f90:	e822                	sd	s0,16(sp)
    80001f92:	e426                	sd	s1,8(sp)
    80001f94:	1000                	addi	s0,sp,32
    80001f96:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f98:	00000097          	auipc	ra,0x0
    80001f9c:	ece080e7          	jalr	-306(ra) # 80001e66 <argraw>
    80001fa0:	e088                	sd	a0,0(s1)
}
    80001fa2:	60e2                	ld	ra,24(sp)
    80001fa4:	6442                	ld	s0,16(sp)
    80001fa6:	64a2                	ld	s1,8(sp)
    80001fa8:	6105                	addi	sp,sp,32
    80001faa:	8082                	ret

0000000080001fac <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fac:	7179                	addi	sp,sp,-48
    80001fae:	f406                	sd	ra,40(sp)
    80001fb0:	f022                	sd	s0,32(sp)
    80001fb2:	ec26                	sd	s1,24(sp)
    80001fb4:	e84a                	sd	s2,16(sp)
    80001fb6:	1800                	addi	s0,sp,48
    80001fb8:	84ae                	mv	s1,a1
    80001fba:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fbc:	fd840593          	addi	a1,s0,-40
    80001fc0:	00000097          	auipc	ra,0x0
    80001fc4:	fcc080e7          	jalr	-52(ra) # 80001f8c <argaddr>
  return fetchstr(addr, buf, max);
    80001fc8:	864a                	mv	a2,s2
    80001fca:	85a6                	mv	a1,s1
    80001fcc:	fd843503          	ld	a0,-40(s0)
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	f50080e7          	jalr	-176(ra) # 80001f20 <fetchstr>
}
    80001fd8:	70a2                	ld	ra,40(sp)
    80001fda:	7402                	ld	s0,32(sp)
    80001fdc:	64e2                	ld	s1,24(sp)
    80001fde:	6942                	ld	s2,16(sp)
    80001fe0:	6145                	addi	sp,sp,48
    80001fe2:	8082                	ret

0000000080001fe4 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001fe4:	1101                	addi	sp,sp,-32
    80001fe6:	ec06                	sd	ra,24(sp)
    80001fe8:	e822                	sd	s0,16(sp)
    80001fea:	e426                	sd	s1,8(sp)
    80001fec:	e04a                	sd	s2,0(sp)
    80001fee:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	e62080e7          	jalr	-414(ra) # 80000e52 <myproc>
    80001ff8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001ffa:	05853903          	ld	s2,88(a0)
    80001ffe:	0a893783          	ld	a5,168(s2)
    80002002:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002006:	37fd                	addiw	a5,a5,-1
    80002008:	4751                	li	a4,20
    8000200a:	00f76f63          	bltu	a4,a5,80002028 <syscall+0x44>
    8000200e:	00369713          	slli	a4,a3,0x3
    80002012:	00006797          	auipc	a5,0x6
    80002016:	3be78793          	addi	a5,a5,958 # 800083d0 <syscalls>
    8000201a:	97ba                	add	a5,a5,a4
    8000201c:	639c                	ld	a5,0(a5)
    8000201e:	c789                	beqz	a5,80002028 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002020:	9782                	jalr	a5
    80002022:	06a93823          	sd	a0,112(s2)
    80002026:	a839                	j	80002044 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002028:	15848613          	addi	a2,s1,344
    8000202c:	588c                	lw	a1,48(s1)
    8000202e:	00006517          	auipc	a0,0x6
    80002032:	36a50513          	addi	a0,a0,874 # 80008398 <states.0+0x150>
    80002036:	00004097          	auipc	ra,0x4
    8000203a:	b5a080e7          	jalr	-1190(ra) # 80005b90 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000203e:	6cbc                	ld	a5,88(s1)
    80002040:	577d                	li	a4,-1
    80002042:	fbb8                	sd	a4,112(a5)
  }
}
    80002044:	60e2                	ld	ra,24(sp)
    80002046:	6442                	ld	s0,16(sp)
    80002048:	64a2                	ld	s1,8(sp)
    8000204a:	6902                	ld	s2,0(sp)
    8000204c:	6105                	addi	sp,sp,32
    8000204e:	8082                	ret

0000000080002050 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002050:	1101                	addi	sp,sp,-32
    80002052:	ec06                	sd	ra,24(sp)
    80002054:	e822                	sd	s0,16(sp)
    80002056:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002058:	fec40593          	addi	a1,s0,-20
    8000205c:	4501                	li	a0,0
    8000205e:	00000097          	auipc	ra,0x0
    80002062:	f0e080e7          	jalr	-242(ra) # 80001f6c <argint>
  exit(n);
    80002066:	fec42503          	lw	a0,-20(s0)
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	5c4080e7          	jalr	1476(ra) # 8000162e <exit>
  return 0;  // not reached
}
    80002072:	4501                	li	a0,0
    80002074:	60e2                	ld	ra,24(sp)
    80002076:	6442                	ld	s0,16(sp)
    80002078:	6105                	addi	sp,sp,32
    8000207a:	8082                	ret

000000008000207c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000207c:	1141                	addi	sp,sp,-16
    8000207e:	e406                	sd	ra,8(sp)
    80002080:	e022                	sd	s0,0(sp)
    80002082:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002084:	fffff097          	auipc	ra,0xfffff
    80002088:	dce080e7          	jalr	-562(ra) # 80000e52 <myproc>
}
    8000208c:	5908                	lw	a0,48(a0)
    8000208e:	60a2                	ld	ra,8(sp)
    80002090:	6402                	ld	s0,0(sp)
    80002092:	0141                	addi	sp,sp,16
    80002094:	8082                	ret

0000000080002096 <sys_fork>:

uint64
sys_fork(void)
{
    80002096:	1141                	addi	sp,sp,-16
    80002098:	e406                	sd	ra,8(sp)
    8000209a:	e022                	sd	s0,0(sp)
    8000209c:	0800                	addi	s0,sp,16
  return fork();
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	16a080e7          	jalr	362(ra) # 80001208 <fork>
}
    800020a6:	60a2                	ld	ra,8(sp)
    800020a8:	6402                	ld	s0,0(sp)
    800020aa:	0141                	addi	sp,sp,16
    800020ac:	8082                	ret

00000000800020ae <sys_wait>:

uint64
sys_wait(void)
{
    800020ae:	1101                	addi	sp,sp,-32
    800020b0:	ec06                	sd	ra,24(sp)
    800020b2:	e822                	sd	s0,16(sp)
    800020b4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020b6:	fe840593          	addi	a1,s0,-24
    800020ba:	4501                	li	a0,0
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	ed0080e7          	jalr	-304(ra) # 80001f8c <argaddr>
  return wait(p);
    800020c4:	fe843503          	ld	a0,-24(s0)
    800020c8:	fffff097          	auipc	ra,0xfffff
    800020cc:	70c080e7          	jalr	1804(ra) # 800017d4 <wait>
}
    800020d0:	60e2                	ld	ra,24(sp)
    800020d2:	6442                	ld	s0,16(sp)
    800020d4:	6105                	addi	sp,sp,32
    800020d6:	8082                	ret

00000000800020d8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d8:	7179                	addi	sp,sp,-48
    800020da:	f406                	sd	ra,40(sp)
    800020dc:	f022                	sd	s0,32(sp)
    800020de:	ec26                	sd	s1,24(sp)
    800020e0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020e2:	fdc40593          	addi	a1,s0,-36
    800020e6:	4501                	li	a0,0
    800020e8:	00000097          	auipc	ra,0x0
    800020ec:	e84080e7          	jalr	-380(ra) # 80001f6c <argint>
  addr = myproc()->sz;
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	d62080e7          	jalr	-670(ra) # 80000e52 <myproc>
    800020f8:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020fa:	fdc42503          	lw	a0,-36(s0)
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	0ae080e7          	jalr	174(ra) # 800011ac <growproc>
    80002106:	00054863          	bltz	a0,80002116 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000210a:	8526                	mv	a0,s1
    8000210c:	70a2                	ld	ra,40(sp)
    8000210e:	7402                	ld	s0,32(sp)
    80002110:	64e2                	ld	s1,24(sp)
    80002112:	6145                	addi	sp,sp,48
    80002114:	8082                	ret
    return -1;
    80002116:	54fd                	li	s1,-1
    80002118:	bfcd                	j	8000210a <sys_sbrk+0x32>

000000008000211a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000211a:	7139                	addi	sp,sp,-64
    8000211c:	fc06                	sd	ra,56(sp)
    8000211e:	f822                	sd	s0,48(sp)
    80002120:	f426                	sd	s1,40(sp)
    80002122:	f04a                	sd	s2,32(sp)
    80002124:	ec4e                	sd	s3,24(sp)
    80002126:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002128:	fcc40593          	addi	a1,s0,-52
    8000212c:	4501                	li	a0,0
    8000212e:	00000097          	auipc	ra,0x0
    80002132:	e3e080e7          	jalr	-450(ra) # 80001f6c <argint>
  if(n < 0)
    80002136:	fcc42783          	lw	a5,-52(s0)
    8000213a:	0607cf63          	bltz	a5,800021b8 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000213e:	0000c517          	auipc	a0,0xc
    80002142:	5f250513          	addi	a0,a0,1522 # 8000e730 <tickslock>
    80002146:	00004097          	auipc	ra,0x4
    8000214a:	f38080e7          	jalr	-200(ra) # 8000607e <acquire>
  ticks0 = ticks;
    8000214e:	00006917          	auipc	s2,0x6
    80002152:	77a92903          	lw	s2,1914(s2) # 800088c8 <ticks>
  while(ticks - ticks0 < n){
    80002156:	fcc42783          	lw	a5,-52(s0)
    8000215a:	cf9d                	beqz	a5,80002198 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000215c:	0000c997          	auipc	s3,0xc
    80002160:	5d498993          	addi	s3,s3,1492 # 8000e730 <tickslock>
    80002164:	00006497          	auipc	s1,0x6
    80002168:	76448493          	addi	s1,s1,1892 # 800088c8 <ticks>
    if(killed(myproc())){
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	ce6080e7          	jalr	-794(ra) # 80000e52 <myproc>
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	62e080e7          	jalr	1582(ra) # 800017a2 <killed>
    8000217c:	e129                	bnez	a0,800021be <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000217e:	85ce                	mv	a1,s3
    80002180:	8526                	mv	a0,s1
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	378080e7          	jalr	888(ra) # 800014fa <sleep>
  while(ticks - ticks0 < n){
    8000218a:	409c                	lw	a5,0(s1)
    8000218c:	412787bb          	subw	a5,a5,s2
    80002190:	fcc42703          	lw	a4,-52(s0)
    80002194:	fce7ece3          	bltu	a5,a4,8000216c <sys_sleep+0x52>
  }
  release(&tickslock);
    80002198:	0000c517          	auipc	a0,0xc
    8000219c:	59850513          	addi	a0,a0,1432 # 8000e730 <tickslock>
    800021a0:	00004097          	auipc	ra,0x4
    800021a4:	f92080e7          	jalr	-110(ra) # 80006132 <release>
  return 0;
    800021a8:	4501                	li	a0,0
}
    800021aa:	70e2                	ld	ra,56(sp)
    800021ac:	7442                	ld	s0,48(sp)
    800021ae:	74a2                	ld	s1,40(sp)
    800021b0:	7902                	ld	s2,32(sp)
    800021b2:	69e2                	ld	s3,24(sp)
    800021b4:	6121                	addi	sp,sp,64
    800021b6:	8082                	ret
    n = 0;
    800021b8:	fc042623          	sw	zero,-52(s0)
    800021bc:	b749                	j	8000213e <sys_sleep+0x24>
      release(&tickslock);
    800021be:	0000c517          	auipc	a0,0xc
    800021c2:	57250513          	addi	a0,a0,1394 # 8000e730 <tickslock>
    800021c6:	00004097          	auipc	ra,0x4
    800021ca:	f6c080e7          	jalr	-148(ra) # 80006132 <release>
      return -1;
    800021ce:	557d                	li	a0,-1
    800021d0:	bfe9                	j	800021aa <sys_sleep+0x90>

00000000800021d2 <sys_kill>:

uint64
sys_kill(void)
{
    800021d2:	1101                	addi	sp,sp,-32
    800021d4:	ec06                	sd	ra,24(sp)
    800021d6:	e822                	sd	s0,16(sp)
    800021d8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021da:	fec40593          	addi	a1,s0,-20
    800021de:	4501                	li	a0,0
    800021e0:	00000097          	auipc	ra,0x0
    800021e4:	d8c080e7          	jalr	-628(ra) # 80001f6c <argint>
  return kill(pid);
    800021e8:	fec42503          	lw	a0,-20(s0)
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	518080e7          	jalr	1304(ra) # 80001704 <kill>
}
    800021f4:	60e2                	ld	ra,24(sp)
    800021f6:	6442                	ld	s0,16(sp)
    800021f8:	6105                	addi	sp,sp,32
    800021fa:	8082                	ret

00000000800021fc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021fc:	1101                	addi	sp,sp,-32
    800021fe:	ec06                	sd	ra,24(sp)
    80002200:	e822                	sd	s0,16(sp)
    80002202:	e426                	sd	s1,8(sp)
    80002204:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002206:	0000c517          	auipc	a0,0xc
    8000220a:	52a50513          	addi	a0,a0,1322 # 8000e730 <tickslock>
    8000220e:	00004097          	auipc	ra,0x4
    80002212:	e70080e7          	jalr	-400(ra) # 8000607e <acquire>
  xticks = ticks;
    80002216:	00006497          	auipc	s1,0x6
    8000221a:	6b24a483          	lw	s1,1714(s1) # 800088c8 <ticks>
  release(&tickslock);
    8000221e:	0000c517          	auipc	a0,0xc
    80002222:	51250513          	addi	a0,a0,1298 # 8000e730 <tickslock>
    80002226:	00004097          	auipc	ra,0x4
    8000222a:	f0c080e7          	jalr	-244(ra) # 80006132 <release>
  return xticks;
}
    8000222e:	02049513          	slli	a0,s1,0x20
    80002232:	9101                	srli	a0,a0,0x20
    80002234:	60e2                	ld	ra,24(sp)
    80002236:	6442                	ld	s0,16(sp)
    80002238:	64a2                	ld	s1,8(sp)
    8000223a:	6105                	addi	sp,sp,32
    8000223c:	8082                	ret

000000008000223e <sys_trace>:


int sys_trace(int mask) {
    8000223e:	1141                	addi	sp,sp,-16
    80002240:	e422                	sd	s0,8(sp)
    80002242:	0800                	addi	s0,sp,16
  return 0;
}
    80002244:	4501                	li	a0,0
    80002246:	6422                	ld	s0,8(sp)
    80002248:	0141                	addi	sp,sp,16
    8000224a:	8082                	ret

000000008000224c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000224c:	7179                	addi	sp,sp,-48
    8000224e:	f406                	sd	ra,40(sp)
    80002250:	f022                	sd	s0,32(sp)
    80002252:	ec26                	sd	s1,24(sp)
    80002254:	e84a                	sd	s2,16(sp)
    80002256:	e44e                	sd	s3,8(sp)
    80002258:	e052                	sd	s4,0(sp)
    8000225a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000225c:	00006597          	auipc	a1,0x6
    80002260:	22458593          	addi	a1,a1,548 # 80008480 <syscalls+0xb0>
    80002264:	0000c517          	auipc	a0,0xc
    80002268:	4e450513          	addi	a0,a0,1252 # 8000e748 <bcache>
    8000226c:	00004097          	auipc	ra,0x4
    80002270:	d82080e7          	jalr	-638(ra) # 80005fee <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002274:	00014797          	auipc	a5,0x14
    80002278:	4d478793          	addi	a5,a5,1236 # 80016748 <bcache+0x8000>
    8000227c:	00014717          	auipc	a4,0x14
    80002280:	73470713          	addi	a4,a4,1844 # 800169b0 <bcache+0x8268>
    80002284:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002288:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000228c:	0000c497          	auipc	s1,0xc
    80002290:	4d448493          	addi	s1,s1,1236 # 8000e760 <bcache+0x18>
    b->next = bcache.head.next;
    80002294:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002296:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002298:	00006a17          	auipc	s4,0x6
    8000229c:	1f0a0a13          	addi	s4,s4,496 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    800022a0:	2b893783          	ld	a5,696(s2)
    800022a4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022a6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022aa:	85d2                	mv	a1,s4
    800022ac:	01048513          	addi	a0,s1,16
    800022b0:	00001097          	auipc	ra,0x1
    800022b4:	496080e7          	jalr	1174(ra) # 80003746 <initsleeplock>
    bcache.head.next->prev = b;
    800022b8:	2b893783          	ld	a5,696(s2)
    800022bc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022be:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022c2:	45848493          	addi	s1,s1,1112
    800022c6:	fd349de3          	bne	s1,s3,800022a0 <binit+0x54>
  }
}
    800022ca:	70a2                	ld	ra,40(sp)
    800022cc:	7402                	ld	s0,32(sp)
    800022ce:	64e2                	ld	s1,24(sp)
    800022d0:	6942                	ld	s2,16(sp)
    800022d2:	69a2                	ld	s3,8(sp)
    800022d4:	6a02                	ld	s4,0(sp)
    800022d6:	6145                	addi	sp,sp,48
    800022d8:	8082                	ret

00000000800022da <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022da:	7179                	addi	sp,sp,-48
    800022dc:	f406                	sd	ra,40(sp)
    800022de:	f022                	sd	s0,32(sp)
    800022e0:	ec26                	sd	s1,24(sp)
    800022e2:	e84a                	sd	s2,16(sp)
    800022e4:	e44e                	sd	s3,8(sp)
    800022e6:	1800                	addi	s0,sp,48
    800022e8:	892a                	mv	s2,a0
    800022ea:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022ec:	0000c517          	auipc	a0,0xc
    800022f0:	45c50513          	addi	a0,a0,1116 # 8000e748 <bcache>
    800022f4:	00004097          	auipc	ra,0x4
    800022f8:	d8a080e7          	jalr	-630(ra) # 8000607e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022fc:	00014497          	auipc	s1,0x14
    80002300:	7044b483          	ld	s1,1796(s1) # 80016a00 <bcache+0x82b8>
    80002304:	00014797          	auipc	a5,0x14
    80002308:	6ac78793          	addi	a5,a5,1708 # 800169b0 <bcache+0x8268>
    8000230c:	02f48f63          	beq	s1,a5,8000234a <bread+0x70>
    80002310:	873e                	mv	a4,a5
    80002312:	a021                	j	8000231a <bread+0x40>
    80002314:	68a4                	ld	s1,80(s1)
    80002316:	02e48a63          	beq	s1,a4,8000234a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000231a:	449c                	lw	a5,8(s1)
    8000231c:	ff279ce3          	bne	a5,s2,80002314 <bread+0x3a>
    80002320:	44dc                	lw	a5,12(s1)
    80002322:	ff3799e3          	bne	a5,s3,80002314 <bread+0x3a>
      b->refcnt++;
    80002326:	40bc                	lw	a5,64(s1)
    80002328:	2785                	addiw	a5,a5,1
    8000232a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000232c:	0000c517          	auipc	a0,0xc
    80002330:	41c50513          	addi	a0,a0,1052 # 8000e748 <bcache>
    80002334:	00004097          	auipc	ra,0x4
    80002338:	dfe080e7          	jalr	-514(ra) # 80006132 <release>
      acquiresleep(&b->lock);
    8000233c:	01048513          	addi	a0,s1,16
    80002340:	00001097          	auipc	ra,0x1
    80002344:	440080e7          	jalr	1088(ra) # 80003780 <acquiresleep>
      return b;
    80002348:	a8b9                	j	800023a6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000234a:	00014497          	auipc	s1,0x14
    8000234e:	6ae4b483          	ld	s1,1710(s1) # 800169f8 <bcache+0x82b0>
    80002352:	00014797          	auipc	a5,0x14
    80002356:	65e78793          	addi	a5,a5,1630 # 800169b0 <bcache+0x8268>
    8000235a:	00f48863          	beq	s1,a5,8000236a <bread+0x90>
    8000235e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002360:	40bc                	lw	a5,64(s1)
    80002362:	cf81                	beqz	a5,8000237a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002364:	64a4                	ld	s1,72(s1)
    80002366:	fee49de3          	bne	s1,a4,80002360 <bread+0x86>
  panic("bget: no buffers");
    8000236a:	00006517          	auipc	a0,0x6
    8000236e:	12650513          	addi	a0,a0,294 # 80008490 <syscalls+0xc0>
    80002372:	00003097          	auipc	ra,0x3
    80002376:	7d4080e7          	jalr	2004(ra) # 80005b46 <panic>
      b->dev = dev;
    8000237a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000237e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002382:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002386:	4785                	li	a5,1
    80002388:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000238a:	0000c517          	auipc	a0,0xc
    8000238e:	3be50513          	addi	a0,a0,958 # 8000e748 <bcache>
    80002392:	00004097          	auipc	ra,0x4
    80002396:	da0080e7          	jalr	-608(ra) # 80006132 <release>
      acquiresleep(&b->lock);
    8000239a:	01048513          	addi	a0,s1,16
    8000239e:	00001097          	auipc	ra,0x1
    800023a2:	3e2080e7          	jalr	994(ra) # 80003780 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023a6:	409c                	lw	a5,0(s1)
    800023a8:	cb89                	beqz	a5,800023ba <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023aa:	8526                	mv	a0,s1
    800023ac:	70a2                	ld	ra,40(sp)
    800023ae:	7402                	ld	s0,32(sp)
    800023b0:	64e2                	ld	s1,24(sp)
    800023b2:	6942                	ld	s2,16(sp)
    800023b4:	69a2                	ld	s3,8(sp)
    800023b6:	6145                	addi	sp,sp,48
    800023b8:	8082                	ret
    virtio_disk_rw(b, 0);
    800023ba:	4581                	li	a1,0
    800023bc:	8526                	mv	a0,s1
    800023be:	00003097          	auipc	ra,0x3
    800023c2:	f84080e7          	jalr	-124(ra) # 80005342 <virtio_disk_rw>
    b->valid = 1;
    800023c6:	4785                	li	a5,1
    800023c8:	c09c                	sw	a5,0(s1)
  return b;
    800023ca:	b7c5                	j	800023aa <bread+0xd0>

00000000800023cc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023cc:	1101                	addi	sp,sp,-32
    800023ce:	ec06                	sd	ra,24(sp)
    800023d0:	e822                	sd	s0,16(sp)
    800023d2:	e426                	sd	s1,8(sp)
    800023d4:	1000                	addi	s0,sp,32
    800023d6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023d8:	0541                	addi	a0,a0,16
    800023da:	00001097          	auipc	ra,0x1
    800023de:	440080e7          	jalr	1088(ra) # 8000381a <holdingsleep>
    800023e2:	cd01                	beqz	a0,800023fa <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023e4:	4585                	li	a1,1
    800023e6:	8526                	mv	a0,s1
    800023e8:	00003097          	auipc	ra,0x3
    800023ec:	f5a080e7          	jalr	-166(ra) # 80005342 <virtio_disk_rw>
}
    800023f0:	60e2                	ld	ra,24(sp)
    800023f2:	6442                	ld	s0,16(sp)
    800023f4:	64a2                	ld	s1,8(sp)
    800023f6:	6105                	addi	sp,sp,32
    800023f8:	8082                	ret
    panic("bwrite");
    800023fa:	00006517          	auipc	a0,0x6
    800023fe:	0ae50513          	addi	a0,a0,174 # 800084a8 <syscalls+0xd8>
    80002402:	00003097          	auipc	ra,0x3
    80002406:	744080e7          	jalr	1860(ra) # 80005b46 <panic>

000000008000240a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000240a:	1101                	addi	sp,sp,-32
    8000240c:	ec06                	sd	ra,24(sp)
    8000240e:	e822                	sd	s0,16(sp)
    80002410:	e426                	sd	s1,8(sp)
    80002412:	e04a                	sd	s2,0(sp)
    80002414:	1000                	addi	s0,sp,32
    80002416:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002418:	01050913          	addi	s2,a0,16
    8000241c:	854a                	mv	a0,s2
    8000241e:	00001097          	auipc	ra,0x1
    80002422:	3fc080e7          	jalr	1020(ra) # 8000381a <holdingsleep>
    80002426:	c925                	beqz	a0,80002496 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002428:	854a                	mv	a0,s2
    8000242a:	00001097          	auipc	ra,0x1
    8000242e:	3ac080e7          	jalr	940(ra) # 800037d6 <releasesleep>

  acquire(&bcache.lock);
    80002432:	0000c517          	auipc	a0,0xc
    80002436:	31650513          	addi	a0,a0,790 # 8000e748 <bcache>
    8000243a:	00004097          	auipc	ra,0x4
    8000243e:	c44080e7          	jalr	-956(ra) # 8000607e <acquire>
  b->refcnt--;
    80002442:	40bc                	lw	a5,64(s1)
    80002444:	37fd                	addiw	a5,a5,-1
    80002446:	0007871b          	sext.w	a4,a5
    8000244a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000244c:	e71d                	bnez	a4,8000247a <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000244e:	68b8                	ld	a4,80(s1)
    80002450:	64bc                	ld	a5,72(s1)
    80002452:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002454:	68b8                	ld	a4,80(s1)
    80002456:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002458:	00014797          	auipc	a5,0x14
    8000245c:	2f078793          	addi	a5,a5,752 # 80016748 <bcache+0x8000>
    80002460:	2b87b703          	ld	a4,696(a5)
    80002464:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002466:	00014717          	auipc	a4,0x14
    8000246a:	54a70713          	addi	a4,a4,1354 # 800169b0 <bcache+0x8268>
    8000246e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002470:	2b87b703          	ld	a4,696(a5)
    80002474:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002476:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000247a:	0000c517          	auipc	a0,0xc
    8000247e:	2ce50513          	addi	a0,a0,718 # 8000e748 <bcache>
    80002482:	00004097          	auipc	ra,0x4
    80002486:	cb0080e7          	jalr	-848(ra) # 80006132 <release>
}
    8000248a:	60e2                	ld	ra,24(sp)
    8000248c:	6442                	ld	s0,16(sp)
    8000248e:	64a2                	ld	s1,8(sp)
    80002490:	6902                	ld	s2,0(sp)
    80002492:	6105                	addi	sp,sp,32
    80002494:	8082                	ret
    panic("brelse");
    80002496:	00006517          	auipc	a0,0x6
    8000249a:	01a50513          	addi	a0,a0,26 # 800084b0 <syscalls+0xe0>
    8000249e:	00003097          	auipc	ra,0x3
    800024a2:	6a8080e7          	jalr	1704(ra) # 80005b46 <panic>

00000000800024a6 <bpin>:

void
bpin(struct buf *b) {
    800024a6:	1101                	addi	sp,sp,-32
    800024a8:	ec06                	sd	ra,24(sp)
    800024aa:	e822                	sd	s0,16(sp)
    800024ac:	e426                	sd	s1,8(sp)
    800024ae:	1000                	addi	s0,sp,32
    800024b0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024b2:	0000c517          	auipc	a0,0xc
    800024b6:	29650513          	addi	a0,a0,662 # 8000e748 <bcache>
    800024ba:	00004097          	auipc	ra,0x4
    800024be:	bc4080e7          	jalr	-1084(ra) # 8000607e <acquire>
  b->refcnt++;
    800024c2:	40bc                	lw	a5,64(s1)
    800024c4:	2785                	addiw	a5,a5,1
    800024c6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024c8:	0000c517          	auipc	a0,0xc
    800024cc:	28050513          	addi	a0,a0,640 # 8000e748 <bcache>
    800024d0:	00004097          	auipc	ra,0x4
    800024d4:	c62080e7          	jalr	-926(ra) # 80006132 <release>
}
    800024d8:	60e2                	ld	ra,24(sp)
    800024da:	6442                	ld	s0,16(sp)
    800024dc:	64a2                	ld	s1,8(sp)
    800024de:	6105                	addi	sp,sp,32
    800024e0:	8082                	ret

00000000800024e2 <bunpin>:

void
bunpin(struct buf *b) {
    800024e2:	1101                	addi	sp,sp,-32
    800024e4:	ec06                	sd	ra,24(sp)
    800024e6:	e822                	sd	s0,16(sp)
    800024e8:	e426                	sd	s1,8(sp)
    800024ea:	1000                	addi	s0,sp,32
    800024ec:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ee:	0000c517          	auipc	a0,0xc
    800024f2:	25a50513          	addi	a0,a0,602 # 8000e748 <bcache>
    800024f6:	00004097          	auipc	ra,0x4
    800024fa:	b88080e7          	jalr	-1144(ra) # 8000607e <acquire>
  b->refcnt--;
    800024fe:	40bc                	lw	a5,64(s1)
    80002500:	37fd                	addiw	a5,a5,-1
    80002502:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002504:	0000c517          	auipc	a0,0xc
    80002508:	24450513          	addi	a0,a0,580 # 8000e748 <bcache>
    8000250c:	00004097          	auipc	ra,0x4
    80002510:	c26080e7          	jalr	-986(ra) # 80006132 <release>
}
    80002514:	60e2                	ld	ra,24(sp)
    80002516:	6442                	ld	s0,16(sp)
    80002518:	64a2                	ld	s1,8(sp)
    8000251a:	6105                	addi	sp,sp,32
    8000251c:	8082                	ret

000000008000251e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000251e:	1101                	addi	sp,sp,-32
    80002520:	ec06                	sd	ra,24(sp)
    80002522:	e822                	sd	s0,16(sp)
    80002524:	e426                	sd	s1,8(sp)
    80002526:	e04a                	sd	s2,0(sp)
    80002528:	1000                	addi	s0,sp,32
    8000252a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000252c:	00d5d59b          	srliw	a1,a1,0xd
    80002530:	00015797          	auipc	a5,0x15
    80002534:	8f47a783          	lw	a5,-1804(a5) # 80016e24 <sb+0x1c>
    80002538:	9dbd                	addw	a1,a1,a5
    8000253a:	00000097          	auipc	ra,0x0
    8000253e:	da0080e7          	jalr	-608(ra) # 800022da <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002542:	0074f713          	andi	a4,s1,7
    80002546:	4785                	li	a5,1
    80002548:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000254c:	14ce                	slli	s1,s1,0x33
    8000254e:	90d9                	srli	s1,s1,0x36
    80002550:	00950733          	add	a4,a0,s1
    80002554:	05874703          	lbu	a4,88(a4)
    80002558:	00e7f6b3          	and	a3,a5,a4
    8000255c:	c69d                	beqz	a3,8000258a <bfree+0x6c>
    8000255e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002560:	94aa                	add	s1,s1,a0
    80002562:	fff7c793          	not	a5,a5
    80002566:	8f7d                	and	a4,a4,a5
    80002568:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000256c:	00001097          	auipc	ra,0x1
    80002570:	0f6080e7          	jalr	246(ra) # 80003662 <log_write>
  brelse(bp);
    80002574:	854a                	mv	a0,s2
    80002576:	00000097          	auipc	ra,0x0
    8000257a:	e94080e7          	jalr	-364(ra) # 8000240a <brelse>
}
    8000257e:	60e2                	ld	ra,24(sp)
    80002580:	6442                	ld	s0,16(sp)
    80002582:	64a2                	ld	s1,8(sp)
    80002584:	6902                	ld	s2,0(sp)
    80002586:	6105                	addi	sp,sp,32
    80002588:	8082                	ret
    panic("freeing free block");
    8000258a:	00006517          	auipc	a0,0x6
    8000258e:	f2e50513          	addi	a0,a0,-210 # 800084b8 <syscalls+0xe8>
    80002592:	00003097          	auipc	ra,0x3
    80002596:	5b4080e7          	jalr	1460(ra) # 80005b46 <panic>

000000008000259a <balloc>:
{
    8000259a:	711d                	addi	sp,sp,-96
    8000259c:	ec86                	sd	ra,88(sp)
    8000259e:	e8a2                	sd	s0,80(sp)
    800025a0:	e4a6                	sd	s1,72(sp)
    800025a2:	e0ca                	sd	s2,64(sp)
    800025a4:	fc4e                	sd	s3,56(sp)
    800025a6:	f852                	sd	s4,48(sp)
    800025a8:	f456                	sd	s5,40(sp)
    800025aa:	f05a                	sd	s6,32(sp)
    800025ac:	ec5e                	sd	s7,24(sp)
    800025ae:	e862                	sd	s8,16(sp)
    800025b0:	e466                	sd	s9,8(sp)
    800025b2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025b4:	00015797          	auipc	a5,0x15
    800025b8:	8587a783          	lw	a5,-1960(a5) # 80016e0c <sb+0x4>
    800025bc:	cff5                	beqz	a5,800026b8 <balloc+0x11e>
    800025be:	8baa                	mv	s7,a0
    800025c0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025c2:	00015b17          	auipc	s6,0x15
    800025c6:	846b0b13          	addi	s6,s6,-1978 # 80016e08 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ca:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025cc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ce:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025d0:	6c89                	lui	s9,0x2
    800025d2:	a061                	j	8000265a <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025d4:	97ca                	add	a5,a5,s2
    800025d6:	8e55                	or	a2,a2,a3
    800025d8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800025dc:	854a                	mv	a0,s2
    800025de:	00001097          	auipc	ra,0x1
    800025e2:	084080e7          	jalr	132(ra) # 80003662 <log_write>
        brelse(bp);
    800025e6:	854a                	mv	a0,s2
    800025e8:	00000097          	auipc	ra,0x0
    800025ec:	e22080e7          	jalr	-478(ra) # 8000240a <brelse>
  bp = bread(dev, bno);
    800025f0:	85a6                	mv	a1,s1
    800025f2:	855e                	mv	a0,s7
    800025f4:	00000097          	auipc	ra,0x0
    800025f8:	ce6080e7          	jalr	-794(ra) # 800022da <bread>
    800025fc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025fe:	40000613          	li	a2,1024
    80002602:	4581                	li	a1,0
    80002604:	05850513          	addi	a0,a0,88
    80002608:	ffffe097          	auipc	ra,0xffffe
    8000260c:	b72080e7          	jalr	-1166(ra) # 8000017a <memset>
  log_write(bp);
    80002610:	854a                	mv	a0,s2
    80002612:	00001097          	auipc	ra,0x1
    80002616:	050080e7          	jalr	80(ra) # 80003662 <log_write>
  brelse(bp);
    8000261a:	854a                	mv	a0,s2
    8000261c:	00000097          	auipc	ra,0x0
    80002620:	dee080e7          	jalr	-530(ra) # 8000240a <brelse>
}
    80002624:	8526                	mv	a0,s1
    80002626:	60e6                	ld	ra,88(sp)
    80002628:	6446                	ld	s0,80(sp)
    8000262a:	64a6                	ld	s1,72(sp)
    8000262c:	6906                	ld	s2,64(sp)
    8000262e:	79e2                	ld	s3,56(sp)
    80002630:	7a42                	ld	s4,48(sp)
    80002632:	7aa2                	ld	s5,40(sp)
    80002634:	7b02                	ld	s6,32(sp)
    80002636:	6be2                	ld	s7,24(sp)
    80002638:	6c42                	ld	s8,16(sp)
    8000263a:	6ca2                	ld	s9,8(sp)
    8000263c:	6125                	addi	sp,sp,96
    8000263e:	8082                	ret
    brelse(bp);
    80002640:	854a                	mv	a0,s2
    80002642:	00000097          	auipc	ra,0x0
    80002646:	dc8080e7          	jalr	-568(ra) # 8000240a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000264a:	015c87bb          	addw	a5,s9,s5
    8000264e:	00078a9b          	sext.w	s5,a5
    80002652:	004b2703          	lw	a4,4(s6)
    80002656:	06eaf163          	bgeu	s5,a4,800026b8 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000265a:	41fad79b          	sraiw	a5,s5,0x1f
    8000265e:	0137d79b          	srliw	a5,a5,0x13
    80002662:	015787bb          	addw	a5,a5,s5
    80002666:	40d7d79b          	sraiw	a5,a5,0xd
    8000266a:	01cb2583          	lw	a1,28(s6)
    8000266e:	9dbd                	addw	a1,a1,a5
    80002670:	855e                	mv	a0,s7
    80002672:	00000097          	auipc	ra,0x0
    80002676:	c68080e7          	jalr	-920(ra) # 800022da <bread>
    8000267a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000267c:	004b2503          	lw	a0,4(s6)
    80002680:	000a849b          	sext.w	s1,s5
    80002684:	8762                	mv	a4,s8
    80002686:	faa4fde3          	bgeu	s1,a0,80002640 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000268a:	00777693          	andi	a3,a4,7
    8000268e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002692:	41f7579b          	sraiw	a5,a4,0x1f
    80002696:	01d7d79b          	srliw	a5,a5,0x1d
    8000269a:	9fb9                	addw	a5,a5,a4
    8000269c:	4037d79b          	sraiw	a5,a5,0x3
    800026a0:	00f90633          	add	a2,s2,a5
    800026a4:	05864603          	lbu	a2,88(a2)
    800026a8:	00c6f5b3          	and	a1,a3,a2
    800026ac:	d585                	beqz	a1,800025d4 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ae:	2705                	addiw	a4,a4,1
    800026b0:	2485                	addiw	s1,s1,1
    800026b2:	fd471ae3          	bne	a4,s4,80002686 <balloc+0xec>
    800026b6:	b769                	j	80002640 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800026b8:	00006517          	auipc	a0,0x6
    800026bc:	e1850513          	addi	a0,a0,-488 # 800084d0 <syscalls+0x100>
    800026c0:	00003097          	auipc	ra,0x3
    800026c4:	4d0080e7          	jalr	1232(ra) # 80005b90 <printf>
  return 0;
    800026c8:	4481                	li	s1,0
    800026ca:	bfa9                	j	80002624 <balloc+0x8a>

00000000800026cc <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026cc:	7179                	addi	sp,sp,-48
    800026ce:	f406                	sd	ra,40(sp)
    800026d0:	f022                	sd	s0,32(sp)
    800026d2:	ec26                	sd	s1,24(sp)
    800026d4:	e84a                	sd	s2,16(sp)
    800026d6:	e44e                	sd	s3,8(sp)
    800026d8:	e052                	sd	s4,0(sp)
    800026da:	1800                	addi	s0,sp,48
    800026dc:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026de:	47ad                	li	a5,11
    800026e0:	02b7e863          	bltu	a5,a1,80002710 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800026e4:	02059793          	slli	a5,a1,0x20
    800026e8:	01e7d593          	srli	a1,a5,0x1e
    800026ec:	00b504b3          	add	s1,a0,a1
    800026f0:	0504a903          	lw	s2,80(s1)
    800026f4:	06091e63          	bnez	s2,80002770 <bmap+0xa4>
      addr = balloc(ip->dev);
    800026f8:	4108                	lw	a0,0(a0)
    800026fa:	00000097          	auipc	ra,0x0
    800026fe:	ea0080e7          	jalr	-352(ra) # 8000259a <balloc>
    80002702:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002706:	06090563          	beqz	s2,80002770 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    8000270a:	0524a823          	sw	s2,80(s1)
    8000270e:	a08d                	j	80002770 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002710:	ff45849b          	addiw	s1,a1,-12
    80002714:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002718:	0ff00793          	li	a5,255
    8000271c:	08e7e563          	bltu	a5,a4,800027a6 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002720:	08052903          	lw	s2,128(a0)
    80002724:	00091d63          	bnez	s2,8000273e <bmap+0x72>
      addr = balloc(ip->dev);
    80002728:	4108                	lw	a0,0(a0)
    8000272a:	00000097          	auipc	ra,0x0
    8000272e:	e70080e7          	jalr	-400(ra) # 8000259a <balloc>
    80002732:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002736:	02090d63          	beqz	s2,80002770 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000273a:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000273e:	85ca                	mv	a1,s2
    80002740:	0009a503          	lw	a0,0(s3)
    80002744:	00000097          	auipc	ra,0x0
    80002748:	b96080e7          	jalr	-1130(ra) # 800022da <bread>
    8000274c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000274e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002752:	02049713          	slli	a4,s1,0x20
    80002756:	01e75593          	srli	a1,a4,0x1e
    8000275a:	00b784b3          	add	s1,a5,a1
    8000275e:	0004a903          	lw	s2,0(s1)
    80002762:	02090063          	beqz	s2,80002782 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002766:	8552                	mv	a0,s4
    80002768:	00000097          	auipc	ra,0x0
    8000276c:	ca2080e7          	jalr	-862(ra) # 8000240a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002770:	854a                	mv	a0,s2
    80002772:	70a2                	ld	ra,40(sp)
    80002774:	7402                	ld	s0,32(sp)
    80002776:	64e2                	ld	s1,24(sp)
    80002778:	6942                	ld	s2,16(sp)
    8000277a:	69a2                	ld	s3,8(sp)
    8000277c:	6a02                	ld	s4,0(sp)
    8000277e:	6145                	addi	sp,sp,48
    80002780:	8082                	ret
      addr = balloc(ip->dev);
    80002782:	0009a503          	lw	a0,0(s3)
    80002786:	00000097          	auipc	ra,0x0
    8000278a:	e14080e7          	jalr	-492(ra) # 8000259a <balloc>
    8000278e:	0005091b          	sext.w	s2,a0
      if(addr){
    80002792:	fc090ae3          	beqz	s2,80002766 <bmap+0x9a>
        a[bn] = addr;
    80002796:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000279a:	8552                	mv	a0,s4
    8000279c:	00001097          	auipc	ra,0x1
    800027a0:	ec6080e7          	jalr	-314(ra) # 80003662 <log_write>
    800027a4:	b7c9                	j	80002766 <bmap+0x9a>
  panic("bmap: out of range");
    800027a6:	00006517          	auipc	a0,0x6
    800027aa:	d4250513          	addi	a0,a0,-702 # 800084e8 <syscalls+0x118>
    800027ae:	00003097          	auipc	ra,0x3
    800027b2:	398080e7          	jalr	920(ra) # 80005b46 <panic>

00000000800027b6 <iget>:
{
    800027b6:	7179                	addi	sp,sp,-48
    800027b8:	f406                	sd	ra,40(sp)
    800027ba:	f022                	sd	s0,32(sp)
    800027bc:	ec26                	sd	s1,24(sp)
    800027be:	e84a                	sd	s2,16(sp)
    800027c0:	e44e                	sd	s3,8(sp)
    800027c2:	e052                	sd	s4,0(sp)
    800027c4:	1800                	addi	s0,sp,48
    800027c6:	89aa                	mv	s3,a0
    800027c8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027ca:	00014517          	auipc	a0,0x14
    800027ce:	65e50513          	addi	a0,a0,1630 # 80016e28 <itable>
    800027d2:	00004097          	auipc	ra,0x4
    800027d6:	8ac080e7          	jalr	-1876(ra) # 8000607e <acquire>
  empty = 0;
    800027da:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027dc:	00014497          	auipc	s1,0x14
    800027e0:	66448493          	addi	s1,s1,1636 # 80016e40 <itable+0x18>
    800027e4:	00016697          	auipc	a3,0x16
    800027e8:	0ec68693          	addi	a3,a3,236 # 800188d0 <log>
    800027ec:	a039                	j	800027fa <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027ee:	02090b63          	beqz	s2,80002824 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027f2:	08848493          	addi	s1,s1,136
    800027f6:	02d48a63          	beq	s1,a3,8000282a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027fa:	449c                	lw	a5,8(s1)
    800027fc:	fef059e3          	blez	a5,800027ee <iget+0x38>
    80002800:	4098                	lw	a4,0(s1)
    80002802:	ff3716e3          	bne	a4,s3,800027ee <iget+0x38>
    80002806:	40d8                	lw	a4,4(s1)
    80002808:	ff4713e3          	bne	a4,s4,800027ee <iget+0x38>
      ip->ref++;
    8000280c:	2785                	addiw	a5,a5,1
    8000280e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002810:	00014517          	auipc	a0,0x14
    80002814:	61850513          	addi	a0,a0,1560 # 80016e28 <itable>
    80002818:	00004097          	auipc	ra,0x4
    8000281c:	91a080e7          	jalr	-1766(ra) # 80006132 <release>
      return ip;
    80002820:	8926                	mv	s2,s1
    80002822:	a03d                	j	80002850 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002824:	f7f9                	bnez	a5,800027f2 <iget+0x3c>
    80002826:	8926                	mv	s2,s1
    80002828:	b7e9                	j	800027f2 <iget+0x3c>
  if(empty == 0)
    8000282a:	02090c63          	beqz	s2,80002862 <iget+0xac>
  ip->dev = dev;
    8000282e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002832:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002836:	4785                	li	a5,1
    80002838:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000283c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002840:	00014517          	auipc	a0,0x14
    80002844:	5e850513          	addi	a0,a0,1512 # 80016e28 <itable>
    80002848:	00004097          	auipc	ra,0x4
    8000284c:	8ea080e7          	jalr	-1814(ra) # 80006132 <release>
}
    80002850:	854a                	mv	a0,s2
    80002852:	70a2                	ld	ra,40(sp)
    80002854:	7402                	ld	s0,32(sp)
    80002856:	64e2                	ld	s1,24(sp)
    80002858:	6942                	ld	s2,16(sp)
    8000285a:	69a2                	ld	s3,8(sp)
    8000285c:	6a02                	ld	s4,0(sp)
    8000285e:	6145                	addi	sp,sp,48
    80002860:	8082                	ret
    panic("iget: no inodes");
    80002862:	00006517          	auipc	a0,0x6
    80002866:	c9e50513          	addi	a0,a0,-866 # 80008500 <syscalls+0x130>
    8000286a:	00003097          	auipc	ra,0x3
    8000286e:	2dc080e7          	jalr	732(ra) # 80005b46 <panic>

0000000080002872 <fsinit>:
fsinit(int dev) {
    80002872:	7179                	addi	sp,sp,-48
    80002874:	f406                	sd	ra,40(sp)
    80002876:	f022                	sd	s0,32(sp)
    80002878:	ec26                	sd	s1,24(sp)
    8000287a:	e84a                	sd	s2,16(sp)
    8000287c:	e44e                	sd	s3,8(sp)
    8000287e:	1800                	addi	s0,sp,48
    80002880:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002882:	4585                	li	a1,1
    80002884:	00000097          	auipc	ra,0x0
    80002888:	a56080e7          	jalr	-1450(ra) # 800022da <bread>
    8000288c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000288e:	00014997          	auipc	s3,0x14
    80002892:	57a98993          	addi	s3,s3,1402 # 80016e08 <sb>
    80002896:	02000613          	li	a2,32
    8000289a:	05850593          	addi	a1,a0,88
    8000289e:	854e                	mv	a0,s3
    800028a0:	ffffe097          	auipc	ra,0xffffe
    800028a4:	936080e7          	jalr	-1738(ra) # 800001d6 <memmove>
  brelse(bp);
    800028a8:	8526                	mv	a0,s1
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	b60080e7          	jalr	-1184(ra) # 8000240a <brelse>
  if(sb.magic != FSMAGIC)
    800028b2:	0009a703          	lw	a4,0(s3)
    800028b6:	102037b7          	lui	a5,0x10203
    800028ba:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028be:	02f71263          	bne	a4,a5,800028e2 <fsinit+0x70>
  initlog(dev, &sb);
    800028c2:	00014597          	auipc	a1,0x14
    800028c6:	54658593          	addi	a1,a1,1350 # 80016e08 <sb>
    800028ca:	854a                	mv	a0,s2
    800028cc:	00001097          	auipc	ra,0x1
    800028d0:	b2c080e7          	jalr	-1236(ra) # 800033f8 <initlog>
}
    800028d4:	70a2                	ld	ra,40(sp)
    800028d6:	7402                	ld	s0,32(sp)
    800028d8:	64e2                	ld	s1,24(sp)
    800028da:	6942                	ld	s2,16(sp)
    800028dc:	69a2                	ld	s3,8(sp)
    800028de:	6145                	addi	sp,sp,48
    800028e0:	8082                	ret
    panic("invalid file system");
    800028e2:	00006517          	auipc	a0,0x6
    800028e6:	c2e50513          	addi	a0,a0,-978 # 80008510 <syscalls+0x140>
    800028ea:	00003097          	auipc	ra,0x3
    800028ee:	25c080e7          	jalr	604(ra) # 80005b46 <panic>

00000000800028f2 <iinit>:
{
    800028f2:	7179                	addi	sp,sp,-48
    800028f4:	f406                	sd	ra,40(sp)
    800028f6:	f022                	sd	s0,32(sp)
    800028f8:	ec26                	sd	s1,24(sp)
    800028fa:	e84a                	sd	s2,16(sp)
    800028fc:	e44e                	sd	s3,8(sp)
    800028fe:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002900:	00006597          	auipc	a1,0x6
    80002904:	c2858593          	addi	a1,a1,-984 # 80008528 <syscalls+0x158>
    80002908:	00014517          	auipc	a0,0x14
    8000290c:	52050513          	addi	a0,a0,1312 # 80016e28 <itable>
    80002910:	00003097          	auipc	ra,0x3
    80002914:	6de080e7          	jalr	1758(ra) # 80005fee <initlock>
  for(i = 0; i < NINODE; i++) {
    80002918:	00014497          	auipc	s1,0x14
    8000291c:	53848493          	addi	s1,s1,1336 # 80016e50 <itable+0x28>
    80002920:	00016997          	auipc	s3,0x16
    80002924:	fc098993          	addi	s3,s3,-64 # 800188e0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002928:	00006917          	auipc	s2,0x6
    8000292c:	c0890913          	addi	s2,s2,-1016 # 80008530 <syscalls+0x160>
    80002930:	85ca                	mv	a1,s2
    80002932:	8526                	mv	a0,s1
    80002934:	00001097          	auipc	ra,0x1
    80002938:	e12080e7          	jalr	-494(ra) # 80003746 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000293c:	08848493          	addi	s1,s1,136
    80002940:	ff3498e3          	bne	s1,s3,80002930 <iinit+0x3e>
}
    80002944:	70a2                	ld	ra,40(sp)
    80002946:	7402                	ld	s0,32(sp)
    80002948:	64e2                	ld	s1,24(sp)
    8000294a:	6942                	ld	s2,16(sp)
    8000294c:	69a2                	ld	s3,8(sp)
    8000294e:	6145                	addi	sp,sp,48
    80002950:	8082                	ret

0000000080002952 <ialloc>:
{
    80002952:	7139                	addi	sp,sp,-64
    80002954:	fc06                	sd	ra,56(sp)
    80002956:	f822                	sd	s0,48(sp)
    80002958:	f426                	sd	s1,40(sp)
    8000295a:	f04a                	sd	s2,32(sp)
    8000295c:	ec4e                	sd	s3,24(sp)
    8000295e:	e852                	sd	s4,16(sp)
    80002960:	e456                	sd	s5,8(sp)
    80002962:	e05a                	sd	s6,0(sp)
    80002964:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002966:	00014717          	auipc	a4,0x14
    8000296a:	4ae72703          	lw	a4,1198(a4) # 80016e14 <sb+0xc>
    8000296e:	4785                	li	a5,1
    80002970:	04e7f863          	bgeu	a5,a4,800029c0 <ialloc+0x6e>
    80002974:	8aaa                	mv	s5,a0
    80002976:	8b2e                	mv	s6,a1
    80002978:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000297a:	00014a17          	auipc	s4,0x14
    8000297e:	48ea0a13          	addi	s4,s4,1166 # 80016e08 <sb>
    80002982:	00495593          	srli	a1,s2,0x4
    80002986:	018a2783          	lw	a5,24(s4)
    8000298a:	9dbd                	addw	a1,a1,a5
    8000298c:	8556                	mv	a0,s5
    8000298e:	00000097          	auipc	ra,0x0
    80002992:	94c080e7          	jalr	-1716(ra) # 800022da <bread>
    80002996:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002998:	05850993          	addi	s3,a0,88
    8000299c:	00f97793          	andi	a5,s2,15
    800029a0:	079a                	slli	a5,a5,0x6
    800029a2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029a4:	00099783          	lh	a5,0(s3)
    800029a8:	cf9d                	beqz	a5,800029e6 <ialloc+0x94>
    brelse(bp);
    800029aa:	00000097          	auipc	ra,0x0
    800029ae:	a60080e7          	jalr	-1440(ra) # 8000240a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029b2:	0905                	addi	s2,s2,1
    800029b4:	00ca2703          	lw	a4,12(s4)
    800029b8:	0009079b          	sext.w	a5,s2
    800029bc:	fce7e3e3          	bltu	a5,a4,80002982 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    800029c0:	00006517          	auipc	a0,0x6
    800029c4:	b7850513          	addi	a0,a0,-1160 # 80008538 <syscalls+0x168>
    800029c8:	00003097          	auipc	ra,0x3
    800029cc:	1c8080e7          	jalr	456(ra) # 80005b90 <printf>
  return 0;
    800029d0:	4501                	li	a0,0
}
    800029d2:	70e2                	ld	ra,56(sp)
    800029d4:	7442                	ld	s0,48(sp)
    800029d6:	74a2                	ld	s1,40(sp)
    800029d8:	7902                	ld	s2,32(sp)
    800029da:	69e2                	ld	s3,24(sp)
    800029dc:	6a42                	ld	s4,16(sp)
    800029de:	6aa2                	ld	s5,8(sp)
    800029e0:	6b02                	ld	s6,0(sp)
    800029e2:	6121                	addi	sp,sp,64
    800029e4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029e6:	04000613          	li	a2,64
    800029ea:	4581                	li	a1,0
    800029ec:	854e                	mv	a0,s3
    800029ee:	ffffd097          	auipc	ra,0xffffd
    800029f2:	78c080e7          	jalr	1932(ra) # 8000017a <memset>
      dip->type = type;
    800029f6:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029fa:	8526                	mv	a0,s1
    800029fc:	00001097          	auipc	ra,0x1
    80002a00:	c66080e7          	jalr	-922(ra) # 80003662 <log_write>
      brelse(bp);
    80002a04:	8526                	mv	a0,s1
    80002a06:	00000097          	auipc	ra,0x0
    80002a0a:	a04080e7          	jalr	-1532(ra) # 8000240a <brelse>
      return iget(dev, inum);
    80002a0e:	0009059b          	sext.w	a1,s2
    80002a12:	8556                	mv	a0,s5
    80002a14:	00000097          	auipc	ra,0x0
    80002a18:	da2080e7          	jalr	-606(ra) # 800027b6 <iget>
    80002a1c:	bf5d                	j	800029d2 <ialloc+0x80>

0000000080002a1e <iupdate>:
{
    80002a1e:	1101                	addi	sp,sp,-32
    80002a20:	ec06                	sd	ra,24(sp)
    80002a22:	e822                	sd	s0,16(sp)
    80002a24:	e426                	sd	s1,8(sp)
    80002a26:	e04a                	sd	s2,0(sp)
    80002a28:	1000                	addi	s0,sp,32
    80002a2a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a2c:	415c                	lw	a5,4(a0)
    80002a2e:	0047d79b          	srliw	a5,a5,0x4
    80002a32:	00014597          	auipc	a1,0x14
    80002a36:	3ee5a583          	lw	a1,1006(a1) # 80016e20 <sb+0x18>
    80002a3a:	9dbd                	addw	a1,a1,a5
    80002a3c:	4108                	lw	a0,0(a0)
    80002a3e:	00000097          	auipc	ra,0x0
    80002a42:	89c080e7          	jalr	-1892(ra) # 800022da <bread>
    80002a46:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a48:	05850793          	addi	a5,a0,88
    80002a4c:	40d8                	lw	a4,4(s1)
    80002a4e:	8b3d                	andi	a4,a4,15
    80002a50:	071a                	slli	a4,a4,0x6
    80002a52:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a54:	04449703          	lh	a4,68(s1)
    80002a58:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a5c:	04649703          	lh	a4,70(s1)
    80002a60:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a64:	04849703          	lh	a4,72(s1)
    80002a68:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a6c:	04a49703          	lh	a4,74(s1)
    80002a70:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a74:	44f8                	lw	a4,76(s1)
    80002a76:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a78:	03400613          	li	a2,52
    80002a7c:	05048593          	addi	a1,s1,80
    80002a80:	00c78513          	addi	a0,a5,12
    80002a84:	ffffd097          	auipc	ra,0xffffd
    80002a88:	752080e7          	jalr	1874(ra) # 800001d6 <memmove>
  log_write(bp);
    80002a8c:	854a                	mv	a0,s2
    80002a8e:	00001097          	auipc	ra,0x1
    80002a92:	bd4080e7          	jalr	-1068(ra) # 80003662 <log_write>
  brelse(bp);
    80002a96:	854a                	mv	a0,s2
    80002a98:	00000097          	auipc	ra,0x0
    80002a9c:	972080e7          	jalr	-1678(ra) # 8000240a <brelse>
}
    80002aa0:	60e2                	ld	ra,24(sp)
    80002aa2:	6442                	ld	s0,16(sp)
    80002aa4:	64a2                	ld	s1,8(sp)
    80002aa6:	6902                	ld	s2,0(sp)
    80002aa8:	6105                	addi	sp,sp,32
    80002aaa:	8082                	ret

0000000080002aac <idup>:
{
    80002aac:	1101                	addi	sp,sp,-32
    80002aae:	ec06                	sd	ra,24(sp)
    80002ab0:	e822                	sd	s0,16(sp)
    80002ab2:	e426                	sd	s1,8(sp)
    80002ab4:	1000                	addi	s0,sp,32
    80002ab6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ab8:	00014517          	auipc	a0,0x14
    80002abc:	37050513          	addi	a0,a0,880 # 80016e28 <itable>
    80002ac0:	00003097          	auipc	ra,0x3
    80002ac4:	5be080e7          	jalr	1470(ra) # 8000607e <acquire>
  ip->ref++;
    80002ac8:	449c                	lw	a5,8(s1)
    80002aca:	2785                	addiw	a5,a5,1
    80002acc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ace:	00014517          	auipc	a0,0x14
    80002ad2:	35a50513          	addi	a0,a0,858 # 80016e28 <itable>
    80002ad6:	00003097          	auipc	ra,0x3
    80002ada:	65c080e7          	jalr	1628(ra) # 80006132 <release>
}
    80002ade:	8526                	mv	a0,s1
    80002ae0:	60e2                	ld	ra,24(sp)
    80002ae2:	6442                	ld	s0,16(sp)
    80002ae4:	64a2                	ld	s1,8(sp)
    80002ae6:	6105                	addi	sp,sp,32
    80002ae8:	8082                	ret

0000000080002aea <ilock>:
{
    80002aea:	1101                	addi	sp,sp,-32
    80002aec:	ec06                	sd	ra,24(sp)
    80002aee:	e822                	sd	s0,16(sp)
    80002af0:	e426                	sd	s1,8(sp)
    80002af2:	e04a                	sd	s2,0(sp)
    80002af4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002af6:	c115                	beqz	a0,80002b1a <ilock+0x30>
    80002af8:	84aa                	mv	s1,a0
    80002afa:	451c                	lw	a5,8(a0)
    80002afc:	00f05f63          	blez	a5,80002b1a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b00:	0541                	addi	a0,a0,16
    80002b02:	00001097          	auipc	ra,0x1
    80002b06:	c7e080e7          	jalr	-898(ra) # 80003780 <acquiresleep>
  if(ip->valid == 0){
    80002b0a:	40bc                	lw	a5,64(s1)
    80002b0c:	cf99                	beqz	a5,80002b2a <ilock+0x40>
}
    80002b0e:	60e2                	ld	ra,24(sp)
    80002b10:	6442                	ld	s0,16(sp)
    80002b12:	64a2                	ld	s1,8(sp)
    80002b14:	6902                	ld	s2,0(sp)
    80002b16:	6105                	addi	sp,sp,32
    80002b18:	8082                	ret
    panic("ilock");
    80002b1a:	00006517          	auipc	a0,0x6
    80002b1e:	a3650513          	addi	a0,a0,-1482 # 80008550 <syscalls+0x180>
    80002b22:	00003097          	auipc	ra,0x3
    80002b26:	024080e7          	jalr	36(ra) # 80005b46 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b2a:	40dc                	lw	a5,4(s1)
    80002b2c:	0047d79b          	srliw	a5,a5,0x4
    80002b30:	00014597          	auipc	a1,0x14
    80002b34:	2f05a583          	lw	a1,752(a1) # 80016e20 <sb+0x18>
    80002b38:	9dbd                	addw	a1,a1,a5
    80002b3a:	4088                	lw	a0,0(s1)
    80002b3c:	fffff097          	auipc	ra,0xfffff
    80002b40:	79e080e7          	jalr	1950(ra) # 800022da <bread>
    80002b44:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b46:	05850593          	addi	a1,a0,88
    80002b4a:	40dc                	lw	a5,4(s1)
    80002b4c:	8bbd                	andi	a5,a5,15
    80002b4e:	079a                	slli	a5,a5,0x6
    80002b50:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b52:	00059783          	lh	a5,0(a1)
    80002b56:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b5a:	00259783          	lh	a5,2(a1)
    80002b5e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b62:	00459783          	lh	a5,4(a1)
    80002b66:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b6a:	00659783          	lh	a5,6(a1)
    80002b6e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b72:	459c                	lw	a5,8(a1)
    80002b74:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b76:	03400613          	li	a2,52
    80002b7a:	05b1                	addi	a1,a1,12
    80002b7c:	05048513          	addi	a0,s1,80
    80002b80:	ffffd097          	auipc	ra,0xffffd
    80002b84:	656080e7          	jalr	1622(ra) # 800001d6 <memmove>
    brelse(bp);
    80002b88:	854a                	mv	a0,s2
    80002b8a:	00000097          	auipc	ra,0x0
    80002b8e:	880080e7          	jalr	-1920(ra) # 8000240a <brelse>
    ip->valid = 1;
    80002b92:	4785                	li	a5,1
    80002b94:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b96:	04449783          	lh	a5,68(s1)
    80002b9a:	fbb5                	bnez	a5,80002b0e <ilock+0x24>
      panic("ilock: no type");
    80002b9c:	00006517          	auipc	a0,0x6
    80002ba0:	9bc50513          	addi	a0,a0,-1604 # 80008558 <syscalls+0x188>
    80002ba4:	00003097          	auipc	ra,0x3
    80002ba8:	fa2080e7          	jalr	-94(ra) # 80005b46 <panic>

0000000080002bac <iunlock>:
{
    80002bac:	1101                	addi	sp,sp,-32
    80002bae:	ec06                	sd	ra,24(sp)
    80002bb0:	e822                	sd	s0,16(sp)
    80002bb2:	e426                	sd	s1,8(sp)
    80002bb4:	e04a                	sd	s2,0(sp)
    80002bb6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bb8:	c905                	beqz	a0,80002be8 <iunlock+0x3c>
    80002bba:	84aa                	mv	s1,a0
    80002bbc:	01050913          	addi	s2,a0,16
    80002bc0:	854a                	mv	a0,s2
    80002bc2:	00001097          	auipc	ra,0x1
    80002bc6:	c58080e7          	jalr	-936(ra) # 8000381a <holdingsleep>
    80002bca:	cd19                	beqz	a0,80002be8 <iunlock+0x3c>
    80002bcc:	449c                	lw	a5,8(s1)
    80002bce:	00f05d63          	blez	a5,80002be8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bd2:	854a                	mv	a0,s2
    80002bd4:	00001097          	auipc	ra,0x1
    80002bd8:	c02080e7          	jalr	-1022(ra) # 800037d6 <releasesleep>
}
    80002bdc:	60e2                	ld	ra,24(sp)
    80002bde:	6442                	ld	s0,16(sp)
    80002be0:	64a2                	ld	s1,8(sp)
    80002be2:	6902                	ld	s2,0(sp)
    80002be4:	6105                	addi	sp,sp,32
    80002be6:	8082                	ret
    panic("iunlock");
    80002be8:	00006517          	auipc	a0,0x6
    80002bec:	98050513          	addi	a0,a0,-1664 # 80008568 <syscalls+0x198>
    80002bf0:	00003097          	auipc	ra,0x3
    80002bf4:	f56080e7          	jalr	-170(ra) # 80005b46 <panic>

0000000080002bf8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bf8:	7179                	addi	sp,sp,-48
    80002bfa:	f406                	sd	ra,40(sp)
    80002bfc:	f022                	sd	s0,32(sp)
    80002bfe:	ec26                	sd	s1,24(sp)
    80002c00:	e84a                	sd	s2,16(sp)
    80002c02:	e44e                	sd	s3,8(sp)
    80002c04:	e052                	sd	s4,0(sp)
    80002c06:	1800                	addi	s0,sp,48
    80002c08:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c0a:	05050493          	addi	s1,a0,80
    80002c0e:	08050913          	addi	s2,a0,128
    80002c12:	a021                	j	80002c1a <itrunc+0x22>
    80002c14:	0491                	addi	s1,s1,4
    80002c16:	01248d63          	beq	s1,s2,80002c30 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c1a:	408c                	lw	a1,0(s1)
    80002c1c:	dde5                	beqz	a1,80002c14 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c1e:	0009a503          	lw	a0,0(s3)
    80002c22:	00000097          	auipc	ra,0x0
    80002c26:	8fc080e7          	jalr	-1796(ra) # 8000251e <bfree>
      ip->addrs[i] = 0;
    80002c2a:	0004a023          	sw	zero,0(s1)
    80002c2e:	b7dd                	j	80002c14 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c30:	0809a583          	lw	a1,128(s3)
    80002c34:	e185                	bnez	a1,80002c54 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c36:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c3a:	854e                	mv	a0,s3
    80002c3c:	00000097          	auipc	ra,0x0
    80002c40:	de2080e7          	jalr	-542(ra) # 80002a1e <iupdate>
}
    80002c44:	70a2                	ld	ra,40(sp)
    80002c46:	7402                	ld	s0,32(sp)
    80002c48:	64e2                	ld	s1,24(sp)
    80002c4a:	6942                	ld	s2,16(sp)
    80002c4c:	69a2                	ld	s3,8(sp)
    80002c4e:	6a02                	ld	s4,0(sp)
    80002c50:	6145                	addi	sp,sp,48
    80002c52:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c54:	0009a503          	lw	a0,0(s3)
    80002c58:	fffff097          	auipc	ra,0xfffff
    80002c5c:	682080e7          	jalr	1666(ra) # 800022da <bread>
    80002c60:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c62:	05850493          	addi	s1,a0,88
    80002c66:	45850913          	addi	s2,a0,1112
    80002c6a:	a021                	j	80002c72 <itrunc+0x7a>
    80002c6c:	0491                	addi	s1,s1,4
    80002c6e:	01248b63          	beq	s1,s2,80002c84 <itrunc+0x8c>
      if(a[j])
    80002c72:	408c                	lw	a1,0(s1)
    80002c74:	dde5                	beqz	a1,80002c6c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c76:	0009a503          	lw	a0,0(s3)
    80002c7a:	00000097          	auipc	ra,0x0
    80002c7e:	8a4080e7          	jalr	-1884(ra) # 8000251e <bfree>
    80002c82:	b7ed                	j	80002c6c <itrunc+0x74>
    brelse(bp);
    80002c84:	8552                	mv	a0,s4
    80002c86:	fffff097          	auipc	ra,0xfffff
    80002c8a:	784080e7          	jalr	1924(ra) # 8000240a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c8e:	0809a583          	lw	a1,128(s3)
    80002c92:	0009a503          	lw	a0,0(s3)
    80002c96:	00000097          	auipc	ra,0x0
    80002c9a:	888080e7          	jalr	-1912(ra) # 8000251e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c9e:	0809a023          	sw	zero,128(s3)
    80002ca2:	bf51                	j	80002c36 <itrunc+0x3e>

0000000080002ca4 <iput>:
{
    80002ca4:	1101                	addi	sp,sp,-32
    80002ca6:	ec06                	sd	ra,24(sp)
    80002ca8:	e822                	sd	s0,16(sp)
    80002caa:	e426                	sd	s1,8(sp)
    80002cac:	e04a                	sd	s2,0(sp)
    80002cae:	1000                	addi	s0,sp,32
    80002cb0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cb2:	00014517          	auipc	a0,0x14
    80002cb6:	17650513          	addi	a0,a0,374 # 80016e28 <itable>
    80002cba:	00003097          	auipc	ra,0x3
    80002cbe:	3c4080e7          	jalr	964(ra) # 8000607e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cc2:	4498                	lw	a4,8(s1)
    80002cc4:	4785                	li	a5,1
    80002cc6:	02f70363          	beq	a4,a5,80002cec <iput+0x48>
  ip->ref--;
    80002cca:	449c                	lw	a5,8(s1)
    80002ccc:	37fd                	addiw	a5,a5,-1
    80002cce:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cd0:	00014517          	auipc	a0,0x14
    80002cd4:	15850513          	addi	a0,a0,344 # 80016e28 <itable>
    80002cd8:	00003097          	auipc	ra,0x3
    80002cdc:	45a080e7          	jalr	1114(ra) # 80006132 <release>
}
    80002ce0:	60e2                	ld	ra,24(sp)
    80002ce2:	6442                	ld	s0,16(sp)
    80002ce4:	64a2                	ld	s1,8(sp)
    80002ce6:	6902                	ld	s2,0(sp)
    80002ce8:	6105                	addi	sp,sp,32
    80002cea:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cec:	40bc                	lw	a5,64(s1)
    80002cee:	dff1                	beqz	a5,80002cca <iput+0x26>
    80002cf0:	04a49783          	lh	a5,74(s1)
    80002cf4:	fbf9                	bnez	a5,80002cca <iput+0x26>
    acquiresleep(&ip->lock);
    80002cf6:	01048913          	addi	s2,s1,16
    80002cfa:	854a                	mv	a0,s2
    80002cfc:	00001097          	auipc	ra,0x1
    80002d00:	a84080e7          	jalr	-1404(ra) # 80003780 <acquiresleep>
    release(&itable.lock);
    80002d04:	00014517          	auipc	a0,0x14
    80002d08:	12450513          	addi	a0,a0,292 # 80016e28 <itable>
    80002d0c:	00003097          	auipc	ra,0x3
    80002d10:	426080e7          	jalr	1062(ra) # 80006132 <release>
    itrunc(ip);
    80002d14:	8526                	mv	a0,s1
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	ee2080e7          	jalr	-286(ra) # 80002bf8 <itrunc>
    ip->type = 0;
    80002d1e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d22:	8526                	mv	a0,s1
    80002d24:	00000097          	auipc	ra,0x0
    80002d28:	cfa080e7          	jalr	-774(ra) # 80002a1e <iupdate>
    ip->valid = 0;
    80002d2c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d30:	854a                	mv	a0,s2
    80002d32:	00001097          	auipc	ra,0x1
    80002d36:	aa4080e7          	jalr	-1372(ra) # 800037d6 <releasesleep>
    acquire(&itable.lock);
    80002d3a:	00014517          	auipc	a0,0x14
    80002d3e:	0ee50513          	addi	a0,a0,238 # 80016e28 <itable>
    80002d42:	00003097          	auipc	ra,0x3
    80002d46:	33c080e7          	jalr	828(ra) # 8000607e <acquire>
    80002d4a:	b741                	j	80002cca <iput+0x26>

0000000080002d4c <iunlockput>:
{
    80002d4c:	1101                	addi	sp,sp,-32
    80002d4e:	ec06                	sd	ra,24(sp)
    80002d50:	e822                	sd	s0,16(sp)
    80002d52:	e426                	sd	s1,8(sp)
    80002d54:	1000                	addi	s0,sp,32
    80002d56:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d58:	00000097          	auipc	ra,0x0
    80002d5c:	e54080e7          	jalr	-428(ra) # 80002bac <iunlock>
  iput(ip);
    80002d60:	8526                	mv	a0,s1
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	f42080e7          	jalr	-190(ra) # 80002ca4 <iput>
}
    80002d6a:	60e2                	ld	ra,24(sp)
    80002d6c:	6442                	ld	s0,16(sp)
    80002d6e:	64a2                	ld	s1,8(sp)
    80002d70:	6105                	addi	sp,sp,32
    80002d72:	8082                	ret

0000000080002d74 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d74:	1141                	addi	sp,sp,-16
    80002d76:	e422                	sd	s0,8(sp)
    80002d78:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d7a:	411c                	lw	a5,0(a0)
    80002d7c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d7e:	415c                	lw	a5,4(a0)
    80002d80:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d82:	04451783          	lh	a5,68(a0)
    80002d86:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d8a:	04a51783          	lh	a5,74(a0)
    80002d8e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d92:	04c56783          	lwu	a5,76(a0)
    80002d96:	e99c                	sd	a5,16(a1)
}
    80002d98:	6422                	ld	s0,8(sp)
    80002d9a:	0141                	addi	sp,sp,16
    80002d9c:	8082                	ret

0000000080002d9e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d9e:	457c                	lw	a5,76(a0)
    80002da0:	0ed7e963          	bltu	a5,a3,80002e92 <readi+0xf4>
{
    80002da4:	7159                	addi	sp,sp,-112
    80002da6:	f486                	sd	ra,104(sp)
    80002da8:	f0a2                	sd	s0,96(sp)
    80002daa:	eca6                	sd	s1,88(sp)
    80002dac:	e8ca                	sd	s2,80(sp)
    80002dae:	e4ce                	sd	s3,72(sp)
    80002db0:	e0d2                	sd	s4,64(sp)
    80002db2:	fc56                	sd	s5,56(sp)
    80002db4:	f85a                	sd	s6,48(sp)
    80002db6:	f45e                	sd	s7,40(sp)
    80002db8:	f062                	sd	s8,32(sp)
    80002dba:	ec66                	sd	s9,24(sp)
    80002dbc:	e86a                	sd	s10,16(sp)
    80002dbe:	e46e                	sd	s11,8(sp)
    80002dc0:	1880                	addi	s0,sp,112
    80002dc2:	8b2a                	mv	s6,a0
    80002dc4:	8bae                	mv	s7,a1
    80002dc6:	8a32                	mv	s4,a2
    80002dc8:	84b6                	mv	s1,a3
    80002dca:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002dcc:	9f35                	addw	a4,a4,a3
    return 0;
    80002dce:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dd0:	0ad76063          	bltu	a4,a3,80002e70 <readi+0xd2>
  if(off + n > ip->size)
    80002dd4:	00e7f463          	bgeu	a5,a4,80002ddc <readi+0x3e>
    n = ip->size - off;
    80002dd8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ddc:	0a0a8963          	beqz	s5,80002e8e <readi+0xf0>
    80002de0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002de2:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002de6:	5c7d                	li	s8,-1
    80002de8:	a82d                	j	80002e22 <readi+0x84>
    80002dea:	020d1d93          	slli	s11,s10,0x20
    80002dee:	020ddd93          	srli	s11,s11,0x20
    80002df2:	05890613          	addi	a2,s2,88
    80002df6:	86ee                	mv	a3,s11
    80002df8:	963a                	add	a2,a2,a4
    80002dfa:	85d2                	mv	a1,s4
    80002dfc:	855e                	mv	a0,s7
    80002dfe:	fffff097          	auipc	ra,0xfffff
    80002e02:	b04080e7          	jalr	-1276(ra) # 80001902 <either_copyout>
    80002e06:	05850d63          	beq	a0,s8,80002e60 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e0a:	854a                	mv	a0,s2
    80002e0c:	fffff097          	auipc	ra,0xfffff
    80002e10:	5fe080e7          	jalr	1534(ra) # 8000240a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e14:	013d09bb          	addw	s3,s10,s3
    80002e18:	009d04bb          	addw	s1,s10,s1
    80002e1c:	9a6e                	add	s4,s4,s11
    80002e1e:	0559f763          	bgeu	s3,s5,80002e6c <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e22:	00a4d59b          	srliw	a1,s1,0xa
    80002e26:	855a                	mv	a0,s6
    80002e28:	00000097          	auipc	ra,0x0
    80002e2c:	8a4080e7          	jalr	-1884(ra) # 800026cc <bmap>
    80002e30:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e34:	cd85                	beqz	a1,80002e6c <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e36:	000b2503          	lw	a0,0(s6)
    80002e3a:	fffff097          	auipc	ra,0xfffff
    80002e3e:	4a0080e7          	jalr	1184(ra) # 800022da <bread>
    80002e42:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e44:	3ff4f713          	andi	a4,s1,1023
    80002e48:	40ec87bb          	subw	a5,s9,a4
    80002e4c:	413a86bb          	subw	a3,s5,s3
    80002e50:	8d3e                	mv	s10,a5
    80002e52:	2781                	sext.w	a5,a5
    80002e54:	0006861b          	sext.w	a2,a3
    80002e58:	f8f679e3          	bgeu	a2,a5,80002dea <readi+0x4c>
    80002e5c:	8d36                	mv	s10,a3
    80002e5e:	b771                	j	80002dea <readi+0x4c>
      brelse(bp);
    80002e60:	854a                	mv	a0,s2
    80002e62:	fffff097          	auipc	ra,0xfffff
    80002e66:	5a8080e7          	jalr	1448(ra) # 8000240a <brelse>
      tot = -1;
    80002e6a:	59fd                	li	s3,-1
  }
  return tot;
    80002e6c:	0009851b          	sext.w	a0,s3
}
    80002e70:	70a6                	ld	ra,104(sp)
    80002e72:	7406                	ld	s0,96(sp)
    80002e74:	64e6                	ld	s1,88(sp)
    80002e76:	6946                	ld	s2,80(sp)
    80002e78:	69a6                	ld	s3,72(sp)
    80002e7a:	6a06                	ld	s4,64(sp)
    80002e7c:	7ae2                	ld	s5,56(sp)
    80002e7e:	7b42                	ld	s6,48(sp)
    80002e80:	7ba2                	ld	s7,40(sp)
    80002e82:	7c02                	ld	s8,32(sp)
    80002e84:	6ce2                	ld	s9,24(sp)
    80002e86:	6d42                	ld	s10,16(sp)
    80002e88:	6da2                	ld	s11,8(sp)
    80002e8a:	6165                	addi	sp,sp,112
    80002e8c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e8e:	89d6                	mv	s3,s5
    80002e90:	bff1                	j	80002e6c <readi+0xce>
    return 0;
    80002e92:	4501                	li	a0,0
}
    80002e94:	8082                	ret

0000000080002e96 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e96:	457c                	lw	a5,76(a0)
    80002e98:	10d7e863          	bltu	a5,a3,80002fa8 <writei+0x112>
{
    80002e9c:	7159                	addi	sp,sp,-112
    80002e9e:	f486                	sd	ra,104(sp)
    80002ea0:	f0a2                	sd	s0,96(sp)
    80002ea2:	eca6                	sd	s1,88(sp)
    80002ea4:	e8ca                	sd	s2,80(sp)
    80002ea6:	e4ce                	sd	s3,72(sp)
    80002ea8:	e0d2                	sd	s4,64(sp)
    80002eaa:	fc56                	sd	s5,56(sp)
    80002eac:	f85a                	sd	s6,48(sp)
    80002eae:	f45e                	sd	s7,40(sp)
    80002eb0:	f062                	sd	s8,32(sp)
    80002eb2:	ec66                	sd	s9,24(sp)
    80002eb4:	e86a                	sd	s10,16(sp)
    80002eb6:	e46e                	sd	s11,8(sp)
    80002eb8:	1880                	addi	s0,sp,112
    80002eba:	8aaa                	mv	s5,a0
    80002ebc:	8bae                	mv	s7,a1
    80002ebe:	8a32                	mv	s4,a2
    80002ec0:	8936                	mv	s2,a3
    80002ec2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ec4:	00e687bb          	addw	a5,a3,a4
    80002ec8:	0ed7e263          	bltu	a5,a3,80002fac <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ecc:	00043737          	lui	a4,0x43
    80002ed0:	0ef76063          	bltu	a4,a5,80002fb0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ed4:	0c0b0863          	beqz	s6,80002fa4 <writei+0x10e>
    80002ed8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eda:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ede:	5c7d                	li	s8,-1
    80002ee0:	a091                	j	80002f24 <writei+0x8e>
    80002ee2:	020d1d93          	slli	s11,s10,0x20
    80002ee6:	020ddd93          	srli	s11,s11,0x20
    80002eea:	05848513          	addi	a0,s1,88
    80002eee:	86ee                	mv	a3,s11
    80002ef0:	8652                	mv	a2,s4
    80002ef2:	85de                	mv	a1,s7
    80002ef4:	953a                	add	a0,a0,a4
    80002ef6:	fffff097          	auipc	ra,0xfffff
    80002efa:	a62080e7          	jalr	-1438(ra) # 80001958 <either_copyin>
    80002efe:	07850263          	beq	a0,s8,80002f62 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f02:	8526                	mv	a0,s1
    80002f04:	00000097          	auipc	ra,0x0
    80002f08:	75e080e7          	jalr	1886(ra) # 80003662 <log_write>
    brelse(bp);
    80002f0c:	8526                	mv	a0,s1
    80002f0e:	fffff097          	auipc	ra,0xfffff
    80002f12:	4fc080e7          	jalr	1276(ra) # 8000240a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f16:	013d09bb          	addw	s3,s10,s3
    80002f1a:	012d093b          	addw	s2,s10,s2
    80002f1e:	9a6e                	add	s4,s4,s11
    80002f20:	0569f663          	bgeu	s3,s6,80002f6c <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f24:	00a9559b          	srliw	a1,s2,0xa
    80002f28:	8556                	mv	a0,s5
    80002f2a:	fffff097          	auipc	ra,0xfffff
    80002f2e:	7a2080e7          	jalr	1954(ra) # 800026cc <bmap>
    80002f32:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f36:	c99d                	beqz	a1,80002f6c <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f38:	000aa503          	lw	a0,0(s5)
    80002f3c:	fffff097          	auipc	ra,0xfffff
    80002f40:	39e080e7          	jalr	926(ra) # 800022da <bread>
    80002f44:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f46:	3ff97713          	andi	a4,s2,1023
    80002f4a:	40ec87bb          	subw	a5,s9,a4
    80002f4e:	413b06bb          	subw	a3,s6,s3
    80002f52:	8d3e                	mv	s10,a5
    80002f54:	2781                	sext.w	a5,a5
    80002f56:	0006861b          	sext.w	a2,a3
    80002f5a:	f8f674e3          	bgeu	a2,a5,80002ee2 <writei+0x4c>
    80002f5e:	8d36                	mv	s10,a3
    80002f60:	b749                	j	80002ee2 <writei+0x4c>
      brelse(bp);
    80002f62:	8526                	mv	a0,s1
    80002f64:	fffff097          	auipc	ra,0xfffff
    80002f68:	4a6080e7          	jalr	1190(ra) # 8000240a <brelse>
  }

  if(off > ip->size)
    80002f6c:	04caa783          	lw	a5,76(s5)
    80002f70:	0127f463          	bgeu	a5,s2,80002f78 <writei+0xe2>
    ip->size = off;
    80002f74:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f78:	8556                	mv	a0,s5
    80002f7a:	00000097          	auipc	ra,0x0
    80002f7e:	aa4080e7          	jalr	-1372(ra) # 80002a1e <iupdate>

  return tot;
    80002f82:	0009851b          	sext.w	a0,s3
}
    80002f86:	70a6                	ld	ra,104(sp)
    80002f88:	7406                	ld	s0,96(sp)
    80002f8a:	64e6                	ld	s1,88(sp)
    80002f8c:	6946                	ld	s2,80(sp)
    80002f8e:	69a6                	ld	s3,72(sp)
    80002f90:	6a06                	ld	s4,64(sp)
    80002f92:	7ae2                	ld	s5,56(sp)
    80002f94:	7b42                	ld	s6,48(sp)
    80002f96:	7ba2                	ld	s7,40(sp)
    80002f98:	7c02                	ld	s8,32(sp)
    80002f9a:	6ce2                	ld	s9,24(sp)
    80002f9c:	6d42                	ld	s10,16(sp)
    80002f9e:	6da2                	ld	s11,8(sp)
    80002fa0:	6165                	addi	sp,sp,112
    80002fa2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fa4:	89da                	mv	s3,s6
    80002fa6:	bfc9                	j	80002f78 <writei+0xe2>
    return -1;
    80002fa8:	557d                	li	a0,-1
}
    80002faa:	8082                	ret
    return -1;
    80002fac:	557d                	li	a0,-1
    80002fae:	bfe1                	j	80002f86 <writei+0xf0>
    return -1;
    80002fb0:	557d                	li	a0,-1
    80002fb2:	bfd1                	j	80002f86 <writei+0xf0>

0000000080002fb4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fb4:	1141                	addi	sp,sp,-16
    80002fb6:	e406                	sd	ra,8(sp)
    80002fb8:	e022                	sd	s0,0(sp)
    80002fba:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fbc:	4639                	li	a2,14
    80002fbe:	ffffd097          	auipc	ra,0xffffd
    80002fc2:	28c080e7          	jalr	652(ra) # 8000024a <strncmp>
}
    80002fc6:	60a2                	ld	ra,8(sp)
    80002fc8:	6402                	ld	s0,0(sp)
    80002fca:	0141                	addi	sp,sp,16
    80002fcc:	8082                	ret

0000000080002fce <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fce:	7139                	addi	sp,sp,-64
    80002fd0:	fc06                	sd	ra,56(sp)
    80002fd2:	f822                	sd	s0,48(sp)
    80002fd4:	f426                	sd	s1,40(sp)
    80002fd6:	f04a                	sd	s2,32(sp)
    80002fd8:	ec4e                	sd	s3,24(sp)
    80002fda:	e852                	sd	s4,16(sp)
    80002fdc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fde:	04451703          	lh	a4,68(a0)
    80002fe2:	4785                	li	a5,1
    80002fe4:	00f71a63          	bne	a4,a5,80002ff8 <dirlookup+0x2a>
    80002fe8:	892a                	mv	s2,a0
    80002fea:	89ae                	mv	s3,a1
    80002fec:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fee:	457c                	lw	a5,76(a0)
    80002ff0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ff2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff4:	e79d                	bnez	a5,80003022 <dirlookup+0x54>
    80002ff6:	a8a5                	j	8000306e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002ff8:	00005517          	auipc	a0,0x5
    80002ffc:	57850513          	addi	a0,a0,1400 # 80008570 <syscalls+0x1a0>
    80003000:	00003097          	auipc	ra,0x3
    80003004:	b46080e7          	jalr	-1210(ra) # 80005b46 <panic>
      panic("dirlookup read");
    80003008:	00005517          	auipc	a0,0x5
    8000300c:	58050513          	addi	a0,a0,1408 # 80008588 <syscalls+0x1b8>
    80003010:	00003097          	auipc	ra,0x3
    80003014:	b36080e7          	jalr	-1226(ra) # 80005b46 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003018:	24c1                	addiw	s1,s1,16
    8000301a:	04c92783          	lw	a5,76(s2)
    8000301e:	04f4f763          	bgeu	s1,a5,8000306c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003022:	4741                	li	a4,16
    80003024:	86a6                	mv	a3,s1
    80003026:	fc040613          	addi	a2,s0,-64
    8000302a:	4581                	li	a1,0
    8000302c:	854a                	mv	a0,s2
    8000302e:	00000097          	auipc	ra,0x0
    80003032:	d70080e7          	jalr	-656(ra) # 80002d9e <readi>
    80003036:	47c1                	li	a5,16
    80003038:	fcf518e3          	bne	a0,a5,80003008 <dirlookup+0x3a>
    if(de.inum == 0)
    8000303c:	fc045783          	lhu	a5,-64(s0)
    80003040:	dfe1                	beqz	a5,80003018 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003042:	fc240593          	addi	a1,s0,-62
    80003046:	854e                	mv	a0,s3
    80003048:	00000097          	auipc	ra,0x0
    8000304c:	f6c080e7          	jalr	-148(ra) # 80002fb4 <namecmp>
    80003050:	f561                	bnez	a0,80003018 <dirlookup+0x4a>
      if(poff)
    80003052:	000a0463          	beqz	s4,8000305a <dirlookup+0x8c>
        *poff = off;
    80003056:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000305a:	fc045583          	lhu	a1,-64(s0)
    8000305e:	00092503          	lw	a0,0(s2)
    80003062:	fffff097          	auipc	ra,0xfffff
    80003066:	754080e7          	jalr	1876(ra) # 800027b6 <iget>
    8000306a:	a011                	j	8000306e <dirlookup+0xa0>
  return 0;
    8000306c:	4501                	li	a0,0
}
    8000306e:	70e2                	ld	ra,56(sp)
    80003070:	7442                	ld	s0,48(sp)
    80003072:	74a2                	ld	s1,40(sp)
    80003074:	7902                	ld	s2,32(sp)
    80003076:	69e2                	ld	s3,24(sp)
    80003078:	6a42                	ld	s4,16(sp)
    8000307a:	6121                	addi	sp,sp,64
    8000307c:	8082                	ret

000000008000307e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000307e:	711d                	addi	sp,sp,-96
    80003080:	ec86                	sd	ra,88(sp)
    80003082:	e8a2                	sd	s0,80(sp)
    80003084:	e4a6                	sd	s1,72(sp)
    80003086:	e0ca                	sd	s2,64(sp)
    80003088:	fc4e                	sd	s3,56(sp)
    8000308a:	f852                	sd	s4,48(sp)
    8000308c:	f456                	sd	s5,40(sp)
    8000308e:	f05a                	sd	s6,32(sp)
    80003090:	ec5e                	sd	s7,24(sp)
    80003092:	e862                	sd	s8,16(sp)
    80003094:	e466                	sd	s9,8(sp)
    80003096:	1080                	addi	s0,sp,96
    80003098:	84aa                	mv	s1,a0
    8000309a:	8b2e                	mv	s6,a1
    8000309c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000309e:	00054703          	lbu	a4,0(a0)
    800030a2:	02f00793          	li	a5,47
    800030a6:	02f70263          	beq	a4,a5,800030ca <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030aa:	ffffe097          	auipc	ra,0xffffe
    800030ae:	da8080e7          	jalr	-600(ra) # 80000e52 <myproc>
    800030b2:	15053503          	ld	a0,336(a0)
    800030b6:	00000097          	auipc	ra,0x0
    800030ba:	9f6080e7          	jalr	-1546(ra) # 80002aac <idup>
    800030be:	8a2a                	mv	s4,a0
  while(*path == '/')
    800030c0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800030c4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030c6:	4b85                	li	s7,1
    800030c8:	a875                	j	80003184 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800030ca:	4585                	li	a1,1
    800030cc:	4505                	li	a0,1
    800030ce:	fffff097          	auipc	ra,0xfffff
    800030d2:	6e8080e7          	jalr	1768(ra) # 800027b6 <iget>
    800030d6:	8a2a                	mv	s4,a0
    800030d8:	b7e5                	j	800030c0 <namex+0x42>
      iunlockput(ip);
    800030da:	8552                	mv	a0,s4
    800030dc:	00000097          	auipc	ra,0x0
    800030e0:	c70080e7          	jalr	-912(ra) # 80002d4c <iunlockput>
      return 0;
    800030e4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030e6:	8552                	mv	a0,s4
    800030e8:	60e6                	ld	ra,88(sp)
    800030ea:	6446                	ld	s0,80(sp)
    800030ec:	64a6                	ld	s1,72(sp)
    800030ee:	6906                	ld	s2,64(sp)
    800030f0:	79e2                	ld	s3,56(sp)
    800030f2:	7a42                	ld	s4,48(sp)
    800030f4:	7aa2                	ld	s5,40(sp)
    800030f6:	7b02                	ld	s6,32(sp)
    800030f8:	6be2                	ld	s7,24(sp)
    800030fa:	6c42                	ld	s8,16(sp)
    800030fc:	6ca2                	ld	s9,8(sp)
    800030fe:	6125                	addi	sp,sp,96
    80003100:	8082                	ret
      iunlock(ip);
    80003102:	8552                	mv	a0,s4
    80003104:	00000097          	auipc	ra,0x0
    80003108:	aa8080e7          	jalr	-1368(ra) # 80002bac <iunlock>
      return ip;
    8000310c:	bfe9                	j	800030e6 <namex+0x68>
      iunlockput(ip);
    8000310e:	8552                	mv	a0,s4
    80003110:	00000097          	auipc	ra,0x0
    80003114:	c3c080e7          	jalr	-964(ra) # 80002d4c <iunlockput>
      return 0;
    80003118:	8a4e                	mv	s4,s3
    8000311a:	b7f1                	j	800030e6 <namex+0x68>
  len = path - s;
    8000311c:	40998633          	sub	a2,s3,s1
    80003120:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003124:	099c5863          	bge	s8,s9,800031b4 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003128:	4639                	li	a2,14
    8000312a:	85a6                	mv	a1,s1
    8000312c:	8556                	mv	a0,s5
    8000312e:	ffffd097          	auipc	ra,0xffffd
    80003132:	0a8080e7          	jalr	168(ra) # 800001d6 <memmove>
    80003136:	84ce                	mv	s1,s3
  while(*path == '/')
    80003138:	0004c783          	lbu	a5,0(s1)
    8000313c:	01279763          	bne	a5,s2,8000314a <namex+0xcc>
    path++;
    80003140:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003142:	0004c783          	lbu	a5,0(s1)
    80003146:	ff278de3          	beq	a5,s2,80003140 <namex+0xc2>
    ilock(ip);
    8000314a:	8552                	mv	a0,s4
    8000314c:	00000097          	auipc	ra,0x0
    80003150:	99e080e7          	jalr	-1634(ra) # 80002aea <ilock>
    if(ip->type != T_DIR){
    80003154:	044a1783          	lh	a5,68(s4)
    80003158:	f97791e3          	bne	a5,s7,800030da <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000315c:	000b0563          	beqz	s6,80003166 <namex+0xe8>
    80003160:	0004c783          	lbu	a5,0(s1)
    80003164:	dfd9                	beqz	a5,80003102 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003166:	4601                	li	a2,0
    80003168:	85d6                	mv	a1,s5
    8000316a:	8552                	mv	a0,s4
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	e62080e7          	jalr	-414(ra) # 80002fce <dirlookup>
    80003174:	89aa                	mv	s3,a0
    80003176:	dd41                	beqz	a0,8000310e <namex+0x90>
    iunlockput(ip);
    80003178:	8552                	mv	a0,s4
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	bd2080e7          	jalr	-1070(ra) # 80002d4c <iunlockput>
    ip = next;
    80003182:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003184:	0004c783          	lbu	a5,0(s1)
    80003188:	01279763          	bne	a5,s2,80003196 <namex+0x118>
    path++;
    8000318c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000318e:	0004c783          	lbu	a5,0(s1)
    80003192:	ff278de3          	beq	a5,s2,8000318c <namex+0x10e>
  if(*path == 0)
    80003196:	cb9d                	beqz	a5,800031cc <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003198:	0004c783          	lbu	a5,0(s1)
    8000319c:	89a6                	mv	s3,s1
  len = path - s;
    8000319e:	4c81                	li	s9,0
    800031a0:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800031a2:	01278963          	beq	a5,s2,800031b4 <namex+0x136>
    800031a6:	dbbd                	beqz	a5,8000311c <namex+0x9e>
    path++;
    800031a8:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800031aa:	0009c783          	lbu	a5,0(s3)
    800031ae:	ff279ce3          	bne	a5,s2,800031a6 <namex+0x128>
    800031b2:	b7ad                	j	8000311c <namex+0x9e>
    memmove(name, s, len);
    800031b4:	2601                	sext.w	a2,a2
    800031b6:	85a6                	mv	a1,s1
    800031b8:	8556                	mv	a0,s5
    800031ba:	ffffd097          	auipc	ra,0xffffd
    800031be:	01c080e7          	jalr	28(ra) # 800001d6 <memmove>
    name[len] = 0;
    800031c2:	9cd6                	add	s9,s9,s5
    800031c4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800031c8:	84ce                	mv	s1,s3
    800031ca:	b7bd                	j	80003138 <namex+0xba>
  if(nameiparent){
    800031cc:	f00b0de3          	beqz	s6,800030e6 <namex+0x68>
    iput(ip);
    800031d0:	8552                	mv	a0,s4
    800031d2:	00000097          	auipc	ra,0x0
    800031d6:	ad2080e7          	jalr	-1326(ra) # 80002ca4 <iput>
    return 0;
    800031da:	4a01                	li	s4,0
    800031dc:	b729                	j	800030e6 <namex+0x68>

00000000800031de <dirlink>:
{
    800031de:	7139                	addi	sp,sp,-64
    800031e0:	fc06                	sd	ra,56(sp)
    800031e2:	f822                	sd	s0,48(sp)
    800031e4:	f426                	sd	s1,40(sp)
    800031e6:	f04a                	sd	s2,32(sp)
    800031e8:	ec4e                	sd	s3,24(sp)
    800031ea:	e852                	sd	s4,16(sp)
    800031ec:	0080                	addi	s0,sp,64
    800031ee:	892a                	mv	s2,a0
    800031f0:	8a2e                	mv	s4,a1
    800031f2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031f4:	4601                	li	a2,0
    800031f6:	00000097          	auipc	ra,0x0
    800031fa:	dd8080e7          	jalr	-552(ra) # 80002fce <dirlookup>
    800031fe:	e93d                	bnez	a0,80003274 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003200:	04c92483          	lw	s1,76(s2)
    80003204:	c49d                	beqz	s1,80003232 <dirlink+0x54>
    80003206:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003208:	4741                	li	a4,16
    8000320a:	86a6                	mv	a3,s1
    8000320c:	fc040613          	addi	a2,s0,-64
    80003210:	4581                	li	a1,0
    80003212:	854a                	mv	a0,s2
    80003214:	00000097          	auipc	ra,0x0
    80003218:	b8a080e7          	jalr	-1142(ra) # 80002d9e <readi>
    8000321c:	47c1                	li	a5,16
    8000321e:	06f51163          	bne	a0,a5,80003280 <dirlink+0xa2>
    if(de.inum == 0)
    80003222:	fc045783          	lhu	a5,-64(s0)
    80003226:	c791                	beqz	a5,80003232 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003228:	24c1                	addiw	s1,s1,16
    8000322a:	04c92783          	lw	a5,76(s2)
    8000322e:	fcf4ede3          	bltu	s1,a5,80003208 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003232:	4639                	li	a2,14
    80003234:	85d2                	mv	a1,s4
    80003236:	fc240513          	addi	a0,s0,-62
    8000323a:	ffffd097          	auipc	ra,0xffffd
    8000323e:	04c080e7          	jalr	76(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003242:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003246:	4741                	li	a4,16
    80003248:	86a6                	mv	a3,s1
    8000324a:	fc040613          	addi	a2,s0,-64
    8000324e:	4581                	li	a1,0
    80003250:	854a                	mv	a0,s2
    80003252:	00000097          	auipc	ra,0x0
    80003256:	c44080e7          	jalr	-956(ra) # 80002e96 <writei>
    8000325a:	1541                	addi	a0,a0,-16
    8000325c:	00a03533          	snez	a0,a0
    80003260:	40a00533          	neg	a0,a0
}
    80003264:	70e2                	ld	ra,56(sp)
    80003266:	7442                	ld	s0,48(sp)
    80003268:	74a2                	ld	s1,40(sp)
    8000326a:	7902                	ld	s2,32(sp)
    8000326c:	69e2                	ld	s3,24(sp)
    8000326e:	6a42                	ld	s4,16(sp)
    80003270:	6121                	addi	sp,sp,64
    80003272:	8082                	ret
    iput(ip);
    80003274:	00000097          	auipc	ra,0x0
    80003278:	a30080e7          	jalr	-1488(ra) # 80002ca4 <iput>
    return -1;
    8000327c:	557d                	li	a0,-1
    8000327e:	b7dd                	j	80003264 <dirlink+0x86>
      panic("dirlink read");
    80003280:	00005517          	auipc	a0,0x5
    80003284:	31850513          	addi	a0,a0,792 # 80008598 <syscalls+0x1c8>
    80003288:	00003097          	auipc	ra,0x3
    8000328c:	8be080e7          	jalr	-1858(ra) # 80005b46 <panic>

0000000080003290 <namei>:

struct inode*
namei(char *path)
{
    80003290:	1101                	addi	sp,sp,-32
    80003292:	ec06                	sd	ra,24(sp)
    80003294:	e822                	sd	s0,16(sp)
    80003296:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003298:	fe040613          	addi	a2,s0,-32
    8000329c:	4581                	li	a1,0
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	de0080e7          	jalr	-544(ra) # 8000307e <namex>
}
    800032a6:	60e2                	ld	ra,24(sp)
    800032a8:	6442                	ld	s0,16(sp)
    800032aa:	6105                	addi	sp,sp,32
    800032ac:	8082                	ret

00000000800032ae <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032ae:	1141                	addi	sp,sp,-16
    800032b0:	e406                	sd	ra,8(sp)
    800032b2:	e022                	sd	s0,0(sp)
    800032b4:	0800                	addi	s0,sp,16
    800032b6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032b8:	4585                	li	a1,1
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	dc4080e7          	jalr	-572(ra) # 8000307e <namex>
}
    800032c2:	60a2                	ld	ra,8(sp)
    800032c4:	6402                	ld	s0,0(sp)
    800032c6:	0141                	addi	sp,sp,16
    800032c8:	8082                	ret

00000000800032ca <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032ca:	1101                	addi	sp,sp,-32
    800032cc:	ec06                	sd	ra,24(sp)
    800032ce:	e822                	sd	s0,16(sp)
    800032d0:	e426                	sd	s1,8(sp)
    800032d2:	e04a                	sd	s2,0(sp)
    800032d4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032d6:	00015917          	auipc	s2,0x15
    800032da:	5fa90913          	addi	s2,s2,1530 # 800188d0 <log>
    800032de:	01892583          	lw	a1,24(s2)
    800032e2:	02892503          	lw	a0,40(s2)
    800032e6:	fffff097          	auipc	ra,0xfffff
    800032ea:	ff4080e7          	jalr	-12(ra) # 800022da <bread>
    800032ee:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032f0:	02c92603          	lw	a2,44(s2)
    800032f4:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032f6:	00c05f63          	blez	a2,80003314 <write_head+0x4a>
    800032fa:	00015717          	auipc	a4,0x15
    800032fe:	60670713          	addi	a4,a4,1542 # 80018900 <log+0x30>
    80003302:	87aa                	mv	a5,a0
    80003304:	060a                	slli	a2,a2,0x2
    80003306:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003308:	4314                	lw	a3,0(a4)
    8000330a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000330c:	0711                	addi	a4,a4,4
    8000330e:	0791                	addi	a5,a5,4
    80003310:	fec79ce3          	bne	a5,a2,80003308 <write_head+0x3e>
  }
  bwrite(buf);
    80003314:	8526                	mv	a0,s1
    80003316:	fffff097          	auipc	ra,0xfffff
    8000331a:	0b6080e7          	jalr	182(ra) # 800023cc <bwrite>
  brelse(buf);
    8000331e:	8526                	mv	a0,s1
    80003320:	fffff097          	auipc	ra,0xfffff
    80003324:	0ea080e7          	jalr	234(ra) # 8000240a <brelse>
}
    80003328:	60e2                	ld	ra,24(sp)
    8000332a:	6442                	ld	s0,16(sp)
    8000332c:	64a2                	ld	s1,8(sp)
    8000332e:	6902                	ld	s2,0(sp)
    80003330:	6105                	addi	sp,sp,32
    80003332:	8082                	ret

0000000080003334 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003334:	00015797          	auipc	a5,0x15
    80003338:	5c87a783          	lw	a5,1480(a5) # 800188fc <log+0x2c>
    8000333c:	0af05d63          	blez	a5,800033f6 <install_trans+0xc2>
{
    80003340:	7139                	addi	sp,sp,-64
    80003342:	fc06                	sd	ra,56(sp)
    80003344:	f822                	sd	s0,48(sp)
    80003346:	f426                	sd	s1,40(sp)
    80003348:	f04a                	sd	s2,32(sp)
    8000334a:	ec4e                	sd	s3,24(sp)
    8000334c:	e852                	sd	s4,16(sp)
    8000334e:	e456                	sd	s5,8(sp)
    80003350:	e05a                	sd	s6,0(sp)
    80003352:	0080                	addi	s0,sp,64
    80003354:	8b2a                	mv	s6,a0
    80003356:	00015a97          	auipc	s5,0x15
    8000335a:	5aaa8a93          	addi	s5,s5,1450 # 80018900 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000335e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003360:	00015997          	auipc	s3,0x15
    80003364:	57098993          	addi	s3,s3,1392 # 800188d0 <log>
    80003368:	a00d                	j	8000338a <install_trans+0x56>
    brelse(lbuf);
    8000336a:	854a                	mv	a0,s2
    8000336c:	fffff097          	auipc	ra,0xfffff
    80003370:	09e080e7          	jalr	158(ra) # 8000240a <brelse>
    brelse(dbuf);
    80003374:	8526                	mv	a0,s1
    80003376:	fffff097          	auipc	ra,0xfffff
    8000337a:	094080e7          	jalr	148(ra) # 8000240a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000337e:	2a05                	addiw	s4,s4,1
    80003380:	0a91                	addi	s5,s5,4
    80003382:	02c9a783          	lw	a5,44(s3)
    80003386:	04fa5e63          	bge	s4,a5,800033e2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000338a:	0189a583          	lw	a1,24(s3)
    8000338e:	014585bb          	addw	a1,a1,s4
    80003392:	2585                	addiw	a1,a1,1
    80003394:	0289a503          	lw	a0,40(s3)
    80003398:	fffff097          	auipc	ra,0xfffff
    8000339c:	f42080e7          	jalr	-190(ra) # 800022da <bread>
    800033a0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033a2:	000aa583          	lw	a1,0(s5)
    800033a6:	0289a503          	lw	a0,40(s3)
    800033aa:	fffff097          	auipc	ra,0xfffff
    800033ae:	f30080e7          	jalr	-208(ra) # 800022da <bread>
    800033b2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033b4:	40000613          	li	a2,1024
    800033b8:	05890593          	addi	a1,s2,88
    800033bc:	05850513          	addi	a0,a0,88
    800033c0:	ffffd097          	auipc	ra,0xffffd
    800033c4:	e16080e7          	jalr	-490(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033c8:	8526                	mv	a0,s1
    800033ca:	fffff097          	auipc	ra,0xfffff
    800033ce:	002080e7          	jalr	2(ra) # 800023cc <bwrite>
    if(recovering == 0)
    800033d2:	f80b1ce3          	bnez	s6,8000336a <install_trans+0x36>
      bunpin(dbuf);
    800033d6:	8526                	mv	a0,s1
    800033d8:	fffff097          	auipc	ra,0xfffff
    800033dc:	10a080e7          	jalr	266(ra) # 800024e2 <bunpin>
    800033e0:	b769                	j	8000336a <install_trans+0x36>
}
    800033e2:	70e2                	ld	ra,56(sp)
    800033e4:	7442                	ld	s0,48(sp)
    800033e6:	74a2                	ld	s1,40(sp)
    800033e8:	7902                	ld	s2,32(sp)
    800033ea:	69e2                	ld	s3,24(sp)
    800033ec:	6a42                	ld	s4,16(sp)
    800033ee:	6aa2                	ld	s5,8(sp)
    800033f0:	6b02                	ld	s6,0(sp)
    800033f2:	6121                	addi	sp,sp,64
    800033f4:	8082                	ret
    800033f6:	8082                	ret

00000000800033f8 <initlog>:
{
    800033f8:	7179                	addi	sp,sp,-48
    800033fa:	f406                	sd	ra,40(sp)
    800033fc:	f022                	sd	s0,32(sp)
    800033fe:	ec26                	sd	s1,24(sp)
    80003400:	e84a                	sd	s2,16(sp)
    80003402:	e44e                	sd	s3,8(sp)
    80003404:	1800                	addi	s0,sp,48
    80003406:	892a                	mv	s2,a0
    80003408:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000340a:	00015497          	auipc	s1,0x15
    8000340e:	4c648493          	addi	s1,s1,1222 # 800188d0 <log>
    80003412:	00005597          	auipc	a1,0x5
    80003416:	19658593          	addi	a1,a1,406 # 800085a8 <syscalls+0x1d8>
    8000341a:	8526                	mv	a0,s1
    8000341c:	00003097          	auipc	ra,0x3
    80003420:	bd2080e7          	jalr	-1070(ra) # 80005fee <initlock>
  log.start = sb->logstart;
    80003424:	0149a583          	lw	a1,20(s3)
    80003428:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000342a:	0109a783          	lw	a5,16(s3)
    8000342e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003430:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003434:	854a                	mv	a0,s2
    80003436:	fffff097          	auipc	ra,0xfffff
    8000343a:	ea4080e7          	jalr	-348(ra) # 800022da <bread>
  log.lh.n = lh->n;
    8000343e:	4d30                	lw	a2,88(a0)
    80003440:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003442:	00c05f63          	blez	a2,80003460 <initlog+0x68>
    80003446:	87aa                	mv	a5,a0
    80003448:	00015717          	auipc	a4,0x15
    8000344c:	4b870713          	addi	a4,a4,1208 # 80018900 <log+0x30>
    80003450:	060a                	slli	a2,a2,0x2
    80003452:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003454:	4ff4                	lw	a3,92(a5)
    80003456:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003458:	0791                	addi	a5,a5,4
    8000345a:	0711                	addi	a4,a4,4
    8000345c:	fec79ce3          	bne	a5,a2,80003454 <initlog+0x5c>
  brelse(buf);
    80003460:	fffff097          	auipc	ra,0xfffff
    80003464:	faa080e7          	jalr	-86(ra) # 8000240a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003468:	4505                	li	a0,1
    8000346a:	00000097          	auipc	ra,0x0
    8000346e:	eca080e7          	jalr	-310(ra) # 80003334 <install_trans>
  log.lh.n = 0;
    80003472:	00015797          	auipc	a5,0x15
    80003476:	4807a523          	sw	zero,1162(a5) # 800188fc <log+0x2c>
  write_head(); // clear the log
    8000347a:	00000097          	auipc	ra,0x0
    8000347e:	e50080e7          	jalr	-432(ra) # 800032ca <write_head>
}
    80003482:	70a2                	ld	ra,40(sp)
    80003484:	7402                	ld	s0,32(sp)
    80003486:	64e2                	ld	s1,24(sp)
    80003488:	6942                	ld	s2,16(sp)
    8000348a:	69a2                	ld	s3,8(sp)
    8000348c:	6145                	addi	sp,sp,48
    8000348e:	8082                	ret

0000000080003490 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003490:	1101                	addi	sp,sp,-32
    80003492:	ec06                	sd	ra,24(sp)
    80003494:	e822                	sd	s0,16(sp)
    80003496:	e426                	sd	s1,8(sp)
    80003498:	e04a                	sd	s2,0(sp)
    8000349a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000349c:	00015517          	auipc	a0,0x15
    800034a0:	43450513          	addi	a0,a0,1076 # 800188d0 <log>
    800034a4:	00003097          	auipc	ra,0x3
    800034a8:	bda080e7          	jalr	-1062(ra) # 8000607e <acquire>
  while(1){
    if(log.committing){
    800034ac:	00015497          	auipc	s1,0x15
    800034b0:	42448493          	addi	s1,s1,1060 # 800188d0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034b4:	4979                	li	s2,30
    800034b6:	a039                	j	800034c4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034b8:	85a6                	mv	a1,s1
    800034ba:	8526                	mv	a0,s1
    800034bc:	ffffe097          	auipc	ra,0xffffe
    800034c0:	03e080e7          	jalr	62(ra) # 800014fa <sleep>
    if(log.committing){
    800034c4:	50dc                	lw	a5,36(s1)
    800034c6:	fbed                	bnez	a5,800034b8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034c8:	5098                	lw	a4,32(s1)
    800034ca:	2705                	addiw	a4,a4,1
    800034cc:	0027179b          	slliw	a5,a4,0x2
    800034d0:	9fb9                	addw	a5,a5,a4
    800034d2:	0017979b          	slliw	a5,a5,0x1
    800034d6:	54d4                	lw	a3,44(s1)
    800034d8:	9fb5                	addw	a5,a5,a3
    800034da:	00f95963          	bge	s2,a5,800034ec <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034de:	85a6                	mv	a1,s1
    800034e0:	8526                	mv	a0,s1
    800034e2:	ffffe097          	auipc	ra,0xffffe
    800034e6:	018080e7          	jalr	24(ra) # 800014fa <sleep>
    800034ea:	bfe9                	j	800034c4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800034ec:	00015517          	auipc	a0,0x15
    800034f0:	3e450513          	addi	a0,a0,996 # 800188d0 <log>
    800034f4:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800034f6:	00003097          	auipc	ra,0x3
    800034fa:	c3c080e7          	jalr	-964(ra) # 80006132 <release>
      break;
    }
  }
}
    800034fe:	60e2                	ld	ra,24(sp)
    80003500:	6442                	ld	s0,16(sp)
    80003502:	64a2                	ld	s1,8(sp)
    80003504:	6902                	ld	s2,0(sp)
    80003506:	6105                	addi	sp,sp,32
    80003508:	8082                	ret

000000008000350a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000350a:	7139                	addi	sp,sp,-64
    8000350c:	fc06                	sd	ra,56(sp)
    8000350e:	f822                	sd	s0,48(sp)
    80003510:	f426                	sd	s1,40(sp)
    80003512:	f04a                	sd	s2,32(sp)
    80003514:	ec4e                	sd	s3,24(sp)
    80003516:	e852                	sd	s4,16(sp)
    80003518:	e456                	sd	s5,8(sp)
    8000351a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000351c:	00015497          	auipc	s1,0x15
    80003520:	3b448493          	addi	s1,s1,948 # 800188d0 <log>
    80003524:	8526                	mv	a0,s1
    80003526:	00003097          	auipc	ra,0x3
    8000352a:	b58080e7          	jalr	-1192(ra) # 8000607e <acquire>
  log.outstanding -= 1;
    8000352e:	509c                	lw	a5,32(s1)
    80003530:	37fd                	addiw	a5,a5,-1
    80003532:	0007891b          	sext.w	s2,a5
    80003536:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003538:	50dc                	lw	a5,36(s1)
    8000353a:	e7b9                	bnez	a5,80003588 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000353c:	04091e63          	bnez	s2,80003598 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003540:	00015497          	auipc	s1,0x15
    80003544:	39048493          	addi	s1,s1,912 # 800188d0 <log>
    80003548:	4785                	li	a5,1
    8000354a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000354c:	8526                	mv	a0,s1
    8000354e:	00003097          	auipc	ra,0x3
    80003552:	be4080e7          	jalr	-1052(ra) # 80006132 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003556:	54dc                	lw	a5,44(s1)
    80003558:	06f04763          	bgtz	a5,800035c6 <end_op+0xbc>
    acquire(&log.lock);
    8000355c:	00015497          	auipc	s1,0x15
    80003560:	37448493          	addi	s1,s1,884 # 800188d0 <log>
    80003564:	8526                	mv	a0,s1
    80003566:	00003097          	auipc	ra,0x3
    8000356a:	b18080e7          	jalr	-1256(ra) # 8000607e <acquire>
    log.committing = 0;
    8000356e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003572:	8526                	mv	a0,s1
    80003574:	ffffe097          	auipc	ra,0xffffe
    80003578:	fea080e7          	jalr	-22(ra) # 8000155e <wakeup>
    release(&log.lock);
    8000357c:	8526                	mv	a0,s1
    8000357e:	00003097          	auipc	ra,0x3
    80003582:	bb4080e7          	jalr	-1100(ra) # 80006132 <release>
}
    80003586:	a03d                	j	800035b4 <end_op+0xaa>
    panic("log.committing");
    80003588:	00005517          	auipc	a0,0x5
    8000358c:	02850513          	addi	a0,a0,40 # 800085b0 <syscalls+0x1e0>
    80003590:	00002097          	auipc	ra,0x2
    80003594:	5b6080e7          	jalr	1462(ra) # 80005b46 <panic>
    wakeup(&log);
    80003598:	00015497          	auipc	s1,0x15
    8000359c:	33848493          	addi	s1,s1,824 # 800188d0 <log>
    800035a0:	8526                	mv	a0,s1
    800035a2:	ffffe097          	auipc	ra,0xffffe
    800035a6:	fbc080e7          	jalr	-68(ra) # 8000155e <wakeup>
  release(&log.lock);
    800035aa:	8526                	mv	a0,s1
    800035ac:	00003097          	auipc	ra,0x3
    800035b0:	b86080e7          	jalr	-1146(ra) # 80006132 <release>
}
    800035b4:	70e2                	ld	ra,56(sp)
    800035b6:	7442                	ld	s0,48(sp)
    800035b8:	74a2                	ld	s1,40(sp)
    800035ba:	7902                	ld	s2,32(sp)
    800035bc:	69e2                	ld	s3,24(sp)
    800035be:	6a42                	ld	s4,16(sp)
    800035c0:	6aa2                	ld	s5,8(sp)
    800035c2:	6121                	addi	sp,sp,64
    800035c4:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035c6:	00015a97          	auipc	s5,0x15
    800035ca:	33aa8a93          	addi	s5,s5,826 # 80018900 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035ce:	00015a17          	auipc	s4,0x15
    800035d2:	302a0a13          	addi	s4,s4,770 # 800188d0 <log>
    800035d6:	018a2583          	lw	a1,24(s4)
    800035da:	012585bb          	addw	a1,a1,s2
    800035de:	2585                	addiw	a1,a1,1
    800035e0:	028a2503          	lw	a0,40(s4)
    800035e4:	fffff097          	auipc	ra,0xfffff
    800035e8:	cf6080e7          	jalr	-778(ra) # 800022da <bread>
    800035ec:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800035ee:	000aa583          	lw	a1,0(s5)
    800035f2:	028a2503          	lw	a0,40(s4)
    800035f6:	fffff097          	auipc	ra,0xfffff
    800035fa:	ce4080e7          	jalr	-796(ra) # 800022da <bread>
    800035fe:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003600:	40000613          	li	a2,1024
    80003604:	05850593          	addi	a1,a0,88
    80003608:	05848513          	addi	a0,s1,88
    8000360c:	ffffd097          	auipc	ra,0xffffd
    80003610:	bca080e7          	jalr	-1078(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003614:	8526                	mv	a0,s1
    80003616:	fffff097          	auipc	ra,0xfffff
    8000361a:	db6080e7          	jalr	-586(ra) # 800023cc <bwrite>
    brelse(from);
    8000361e:	854e                	mv	a0,s3
    80003620:	fffff097          	auipc	ra,0xfffff
    80003624:	dea080e7          	jalr	-534(ra) # 8000240a <brelse>
    brelse(to);
    80003628:	8526                	mv	a0,s1
    8000362a:	fffff097          	auipc	ra,0xfffff
    8000362e:	de0080e7          	jalr	-544(ra) # 8000240a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003632:	2905                	addiw	s2,s2,1
    80003634:	0a91                	addi	s5,s5,4
    80003636:	02ca2783          	lw	a5,44(s4)
    8000363a:	f8f94ee3          	blt	s2,a5,800035d6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000363e:	00000097          	auipc	ra,0x0
    80003642:	c8c080e7          	jalr	-884(ra) # 800032ca <write_head>
    install_trans(0); // Now install writes to home locations
    80003646:	4501                	li	a0,0
    80003648:	00000097          	auipc	ra,0x0
    8000364c:	cec080e7          	jalr	-788(ra) # 80003334 <install_trans>
    log.lh.n = 0;
    80003650:	00015797          	auipc	a5,0x15
    80003654:	2a07a623          	sw	zero,684(a5) # 800188fc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003658:	00000097          	auipc	ra,0x0
    8000365c:	c72080e7          	jalr	-910(ra) # 800032ca <write_head>
    80003660:	bdf5                	j	8000355c <end_op+0x52>

0000000080003662 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003662:	1101                	addi	sp,sp,-32
    80003664:	ec06                	sd	ra,24(sp)
    80003666:	e822                	sd	s0,16(sp)
    80003668:	e426                	sd	s1,8(sp)
    8000366a:	e04a                	sd	s2,0(sp)
    8000366c:	1000                	addi	s0,sp,32
    8000366e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003670:	00015917          	auipc	s2,0x15
    80003674:	26090913          	addi	s2,s2,608 # 800188d0 <log>
    80003678:	854a                	mv	a0,s2
    8000367a:	00003097          	auipc	ra,0x3
    8000367e:	a04080e7          	jalr	-1532(ra) # 8000607e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003682:	02c92603          	lw	a2,44(s2)
    80003686:	47f5                	li	a5,29
    80003688:	06c7c563          	blt	a5,a2,800036f2 <log_write+0x90>
    8000368c:	00015797          	auipc	a5,0x15
    80003690:	2607a783          	lw	a5,608(a5) # 800188ec <log+0x1c>
    80003694:	37fd                	addiw	a5,a5,-1
    80003696:	04f65e63          	bge	a2,a5,800036f2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000369a:	00015797          	auipc	a5,0x15
    8000369e:	2567a783          	lw	a5,598(a5) # 800188f0 <log+0x20>
    800036a2:	06f05063          	blez	a5,80003702 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036a6:	4781                	li	a5,0
    800036a8:	06c05563          	blez	a2,80003712 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036ac:	44cc                	lw	a1,12(s1)
    800036ae:	00015717          	auipc	a4,0x15
    800036b2:	25270713          	addi	a4,a4,594 # 80018900 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036b6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036b8:	4314                	lw	a3,0(a4)
    800036ba:	04b68c63          	beq	a3,a1,80003712 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036be:	2785                	addiw	a5,a5,1
    800036c0:	0711                	addi	a4,a4,4
    800036c2:	fef61be3          	bne	a2,a5,800036b8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036c6:	0621                	addi	a2,a2,8
    800036c8:	060a                	slli	a2,a2,0x2
    800036ca:	00015797          	auipc	a5,0x15
    800036ce:	20678793          	addi	a5,a5,518 # 800188d0 <log>
    800036d2:	97b2                	add	a5,a5,a2
    800036d4:	44d8                	lw	a4,12(s1)
    800036d6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036d8:	8526                	mv	a0,s1
    800036da:	fffff097          	auipc	ra,0xfffff
    800036de:	dcc080e7          	jalr	-564(ra) # 800024a6 <bpin>
    log.lh.n++;
    800036e2:	00015717          	auipc	a4,0x15
    800036e6:	1ee70713          	addi	a4,a4,494 # 800188d0 <log>
    800036ea:	575c                	lw	a5,44(a4)
    800036ec:	2785                	addiw	a5,a5,1
    800036ee:	d75c                	sw	a5,44(a4)
    800036f0:	a82d                	j	8000372a <log_write+0xc8>
    panic("too big a transaction");
    800036f2:	00005517          	auipc	a0,0x5
    800036f6:	ece50513          	addi	a0,a0,-306 # 800085c0 <syscalls+0x1f0>
    800036fa:	00002097          	auipc	ra,0x2
    800036fe:	44c080e7          	jalr	1100(ra) # 80005b46 <panic>
    panic("log_write outside of trans");
    80003702:	00005517          	auipc	a0,0x5
    80003706:	ed650513          	addi	a0,a0,-298 # 800085d8 <syscalls+0x208>
    8000370a:	00002097          	auipc	ra,0x2
    8000370e:	43c080e7          	jalr	1084(ra) # 80005b46 <panic>
  log.lh.block[i] = b->blockno;
    80003712:	00878693          	addi	a3,a5,8
    80003716:	068a                	slli	a3,a3,0x2
    80003718:	00015717          	auipc	a4,0x15
    8000371c:	1b870713          	addi	a4,a4,440 # 800188d0 <log>
    80003720:	9736                	add	a4,a4,a3
    80003722:	44d4                	lw	a3,12(s1)
    80003724:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003726:	faf609e3          	beq	a2,a5,800036d8 <log_write+0x76>
  }
  release(&log.lock);
    8000372a:	00015517          	auipc	a0,0x15
    8000372e:	1a650513          	addi	a0,a0,422 # 800188d0 <log>
    80003732:	00003097          	auipc	ra,0x3
    80003736:	a00080e7          	jalr	-1536(ra) # 80006132 <release>
}
    8000373a:	60e2                	ld	ra,24(sp)
    8000373c:	6442                	ld	s0,16(sp)
    8000373e:	64a2                	ld	s1,8(sp)
    80003740:	6902                	ld	s2,0(sp)
    80003742:	6105                	addi	sp,sp,32
    80003744:	8082                	ret

0000000080003746 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003746:	1101                	addi	sp,sp,-32
    80003748:	ec06                	sd	ra,24(sp)
    8000374a:	e822                	sd	s0,16(sp)
    8000374c:	e426                	sd	s1,8(sp)
    8000374e:	e04a                	sd	s2,0(sp)
    80003750:	1000                	addi	s0,sp,32
    80003752:	84aa                	mv	s1,a0
    80003754:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003756:	00005597          	auipc	a1,0x5
    8000375a:	ea258593          	addi	a1,a1,-350 # 800085f8 <syscalls+0x228>
    8000375e:	0521                	addi	a0,a0,8
    80003760:	00003097          	auipc	ra,0x3
    80003764:	88e080e7          	jalr	-1906(ra) # 80005fee <initlock>
  lk->name = name;
    80003768:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000376c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003770:	0204a423          	sw	zero,40(s1)
}
    80003774:	60e2                	ld	ra,24(sp)
    80003776:	6442                	ld	s0,16(sp)
    80003778:	64a2                	ld	s1,8(sp)
    8000377a:	6902                	ld	s2,0(sp)
    8000377c:	6105                	addi	sp,sp,32
    8000377e:	8082                	ret

0000000080003780 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003780:	1101                	addi	sp,sp,-32
    80003782:	ec06                	sd	ra,24(sp)
    80003784:	e822                	sd	s0,16(sp)
    80003786:	e426                	sd	s1,8(sp)
    80003788:	e04a                	sd	s2,0(sp)
    8000378a:	1000                	addi	s0,sp,32
    8000378c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000378e:	00850913          	addi	s2,a0,8
    80003792:	854a                	mv	a0,s2
    80003794:	00003097          	auipc	ra,0x3
    80003798:	8ea080e7          	jalr	-1814(ra) # 8000607e <acquire>
  while (lk->locked) {
    8000379c:	409c                	lw	a5,0(s1)
    8000379e:	cb89                	beqz	a5,800037b0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037a0:	85ca                	mv	a1,s2
    800037a2:	8526                	mv	a0,s1
    800037a4:	ffffe097          	auipc	ra,0xffffe
    800037a8:	d56080e7          	jalr	-682(ra) # 800014fa <sleep>
  while (lk->locked) {
    800037ac:	409c                	lw	a5,0(s1)
    800037ae:	fbed                	bnez	a5,800037a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037b0:	4785                	li	a5,1
    800037b2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037b4:	ffffd097          	auipc	ra,0xffffd
    800037b8:	69e080e7          	jalr	1694(ra) # 80000e52 <myproc>
    800037bc:	591c                	lw	a5,48(a0)
    800037be:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037c0:	854a                	mv	a0,s2
    800037c2:	00003097          	auipc	ra,0x3
    800037c6:	970080e7          	jalr	-1680(ra) # 80006132 <release>
}
    800037ca:	60e2                	ld	ra,24(sp)
    800037cc:	6442                	ld	s0,16(sp)
    800037ce:	64a2                	ld	s1,8(sp)
    800037d0:	6902                	ld	s2,0(sp)
    800037d2:	6105                	addi	sp,sp,32
    800037d4:	8082                	ret

00000000800037d6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037d6:	1101                	addi	sp,sp,-32
    800037d8:	ec06                	sd	ra,24(sp)
    800037da:	e822                	sd	s0,16(sp)
    800037dc:	e426                	sd	s1,8(sp)
    800037de:	e04a                	sd	s2,0(sp)
    800037e0:	1000                	addi	s0,sp,32
    800037e2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037e4:	00850913          	addi	s2,a0,8
    800037e8:	854a                	mv	a0,s2
    800037ea:	00003097          	auipc	ra,0x3
    800037ee:	894080e7          	jalr	-1900(ra) # 8000607e <acquire>
  lk->locked = 0;
    800037f2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037f6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800037fa:	8526                	mv	a0,s1
    800037fc:	ffffe097          	auipc	ra,0xffffe
    80003800:	d62080e7          	jalr	-670(ra) # 8000155e <wakeup>
  release(&lk->lk);
    80003804:	854a                	mv	a0,s2
    80003806:	00003097          	auipc	ra,0x3
    8000380a:	92c080e7          	jalr	-1748(ra) # 80006132 <release>
}
    8000380e:	60e2                	ld	ra,24(sp)
    80003810:	6442                	ld	s0,16(sp)
    80003812:	64a2                	ld	s1,8(sp)
    80003814:	6902                	ld	s2,0(sp)
    80003816:	6105                	addi	sp,sp,32
    80003818:	8082                	ret

000000008000381a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000381a:	7179                	addi	sp,sp,-48
    8000381c:	f406                	sd	ra,40(sp)
    8000381e:	f022                	sd	s0,32(sp)
    80003820:	ec26                	sd	s1,24(sp)
    80003822:	e84a                	sd	s2,16(sp)
    80003824:	e44e                	sd	s3,8(sp)
    80003826:	1800                	addi	s0,sp,48
    80003828:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000382a:	00850913          	addi	s2,a0,8
    8000382e:	854a                	mv	a0,s2
    80003830:	00003097          	auipc	ra,0x3
    80003834:	84e080e7          	jalr	-1970(ra) # 8000607e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003838:	409c                	lw	a5,0(s1)
    8000383a:	ef99                	bnez	a5,80003858 <holdingsleep+0x3e>
    8000383c:	4481                	li	s1,0
  release(&lk->lk);
    8000383e:	854a                	mv	a0,s2
    80003840:	00003097          	auipc	ra,0x3
    80003844:	8f2080e7          	jalr	-1806(ra) # 80006132 <release>
  return r;
}
    80003848:	8526                	mv	a0,s1
    8000384a:	70a2                	ld	ra,40(sp)
    8000384c:	7402                	ld	s0,32(sp)
    8000384e:	64e2                	ld	s1,24(sp)
    80003850:	6942                	ld	s2,16(sp)
    80003852:	69a2                	ld	s3,8(sp)
    80003854:	6145                	addi	sp,sp,48
    80003856:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003858:	0284a983          	lw	s3,40(s1)
    8000385c:	ffffd097          	auipc	ra,0xffffd
    80003860:	5f6080e7          	jalr	1526(ra) # 80000e52 <myproc>
    80003864:	5904                	lw	s1,48(a0)
    80003866:	413484b3          	sub	s1,s1,s3
    8000386a:	0014b493          	seqz	s1,s1
    8000386e:	bfc1                	j	8000383e <holdingsleep+0x24>

0000000080003870 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003870:	1141                	addi	sp,sp,-16
    80003872:	e406                	sd	ra,8(sp)
    80003874:	e022                	sd	s0,0(sp)
    80003876:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003878:	00005597          	auipc	a1,0x5
    8000387c:	d9058593          	addi	a1,a1,-624 # 80008608 <syscalls+0x238>
    80003880:	00015517          	auipc	a0,0x15
    80003884:	19850513          	addi	a0,a0,408 # 80018a18 <ftable>
    80003888:	00002097          	auipc	ra,0x2
    8000388c:	766080e7          	jalr	1894(ra) # 80005fee <initlock>
}
    80003890:	60a2                	ld	ra,8(sp)
    80003892:	6402                	ld	s0,0(sp)
    80003894:	0141                	addi	sp,sp,16
    80003896:	8082                	ret

0000000080003898 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003898:	1101                	addi	sp,sp,-32
    8000389a:	ec06                	sd	ra,24(sp)
    8000389c:	e822                	sd	s0,16(sp)
    8000389e:	e426                	sd	s1,8(sp)
    800038a0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038a2:	00015517          	auipc	a0,0x15
    800038a6:	17650513          	addi	a0,a0,374 # 80018a18 <ftable>
    800038aa:	00002097          	auipc	ra,0x2
    800038ae:	7d4080e7          	jalr	2004(ra) # 8000607e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038b2:	00015497          	auipc	s1,0x15
    800038b6:	17e48493          	addi	s1,s1,382 # 80018a30 <ftable+0x18>
    800038ba:	00016717          	auipc	a4,0x16
    800038be:	11670713          	addi	a4,a4,278 # 800199d0 <disk>
    if(f->ref == 0){
    800038c2:	40dc                	lw	a5,4(s1)
    800038c4:	cf99                	beqz	a5,800038e2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038c6:	02848493          	addi	s1,s1,40
    800038ca:	fee49ce3          	bne	s1,a4,800038c2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038ce:	00015517          	auipc	a0,0x15
    800038d2:	14a50513          	addi	a0,a0,330 # 80018a18 <ftable>
    800038d6:	00003097          	auipc	ra,0x3
    800038da:	85c080e7          	jalr	-1956(ra) # 80006132 <release>
  return 0;
    800038de:	4481                	li	s1,0
    800038e0:	a819                	j	800038f6 <filealloc+0x5e>
      f->ref = 1;
    800038e2:	4785                	li	a5,1
    800038e4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800038e6:	00015517          	auipc	a0,0x15
    800038ea:	13250513          	addi	a0,a0,306 # 80018a18 <ftable>
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	844080e7          	jalr	-1980(ra) # 80006132 <release>
}
    800038f6:	8526                	mv	a0,s1
    800038f8:	60e2                	ld	ra,24(sp)
    800038fa:	6442                	ld	s0,16(sp)
    800038fc:	64a2                	ld	s1,8(sp)
    800038fe:	6105                	addi	sp,sp,32
    80003900:	8082                	ret

0000000080003902 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003902:	1101                	addi	sp,sp,-32
    80003904:	ec06                	sd	ra,24(sp)
    80003906:	e822                	sd	s0,16(sp)
    80003908:	e426                	sd	s1,8(sp)
    8000390a:	1000                	addi	s0,sp,32
    8000390c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000390e:	00015517          	auipc	a0,0x15
    80003912:	10a50513          	addi	a0,a0,266 # 80018a18 <ftable>
    80003916:	00002097          	auipc	ra,0x2
    8000391a:	768080e7          	jalr	1896(ra) # 8000607e <acquire>
  if(f->ref < 1)
    8000391e:	40dc                	lw	a5,4(s1)
    80003920:	02f05263          	blez	a5,80003944 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003924:	2785                	addiw	a5,a5,1
    80003926:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003928:	00015517          	auipc	a0,0x15
    8000392c:	0f050513          	addi	a0,a0,240 # 80018a18 <ftable>
    80003930:	00003097          	auipc	ra,0x3
    80003934:	802080e7          	jalr	-2046(ra) # 80006132 <release>
  return f;
}
    80003938:	8526                	mv	a0,s1
    8000393a:	60e2                	ld	ra,24(sp)
    8000393c:	6442                	ld	s0,16(sp)
    8000393e:	64a2                	ld	s1,8(sp)
    80003940:	6105                	addi	sp,sp,32
    80003942:	8082                	ret
    panic("filedup");
    80003944:	00005517          	auipc	a0,0x5
    80003948:	ccc50513          	addi	a0,a0,-820 # 80008610 <syscalls+0x240>
    8000394c:	00002097          	auipc	ra,0x2
    80003950:	1fa080e7          	jalr	506(ra) # 80005b46 <panic>

0000000080003954 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003954:	7139                	addi	sp,sp,-64
    80003956:	fc06                	sd	ra,56(sp)
    80003958:	f822                	sd	s0,48(sp)
    8000395a:	f426                	sd	s1,40(sp)
    8000395c:	f04a                	sd	s2,32(sp)
    8000395e:	ec4e                	sd	s3,24(sp)
    80003960:	e852                	sd	s4,16(sp)
    80003962:	e456                	sd	s5,8(sp)
    80003964:	0080                	addi	s0,sp,64
    80003966:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003968:	00015517          	auipc	a0,0x15
    8000396c:	0b050513          	addi	a0,a0,176 # 80018a18 <ftable>
    80003970:	00002097          	auipc	ra,0x2
    80003974:	70e080e7          	jalr	1806(ra) # 8000607e <acquire>
  if(f->ref < 1)
    80003978:	40dc                	lw	a5,4(s1)
    8000397a:	06f05163          	blez	a5,800039dc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000397e:	37fd                	addiw	a5,a5,-1
    80003980:	0007871b          	sext.w	a4,a5
    80003984:	c0dc                	sw	a5,4(s1)
    80003986:	06e04363          	bgtz	a4,800039ec <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000398a:	0004a903          	lw	s2,0(s1)
    8000398e:	0094ca83          	lbu	s5,9(s1)
    80003992:	0104ba03          	ld	s4,16(s1)
    80003996:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000399a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000399e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039a2:	00015517          	auipc	a0,0x15
    800039a6:	07650513          	addi	a0,a0,118 # 80018a18 <ftable>
    800039aa:	00002097          	auipc	ra,0x2
    800039ae:	788080e7          	jalr	1928(ra) # 80006132 <release>

  if(ff.type == FD_PIPE){
    800039b2:	4785                	li	a5,1
    800039b4:	04f90d63          	beq	s2,a5,80003a0e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039b8:	3979                	addiw	s2,s2,-2
    800039ba:	4785                	li	a5,1
    800039bc:	0527e063          	bltu	a5,s2,800039fc <fileclose+0xa8>
    begin_op();
    800039c0:	00000097          	auipc	ra,0x0
    800039c4:	ad0080e7          	jalr	-1328(ra) # 80003490 <begin_op>
    iput(ff.ip);
    800039c8:	854e                	mv	a0,s3
    800039ca:	fffff097          	auipc	ra,0xfffff
    800039ce:	2da080e7          	jalr	730(ra) # 80002ca4 <iput>
    end_op();
    800039d2:	00000097          	auipc	ra,0x0
    800039d6:	b38080e7          	jalr	-1224(ra) # 8000350a <end_op>
    800039da:	a00d                	j	800039fc <fileclose+0xa8>
    panic("fileclose");
    800039dc:	00005517          	auipc	a0,0x5
    800039e0:	c3c50513          	addi	a0,a0,-964 # 80008618 <syscalls+0x248>
    800039e4:	00002097          	auipc	ra,0x2
    800039e8:	162080e7          	jalr	354(ra) # 80005b46 <panic>
    release(&ftable.lock);
    800039ec:	00015517          	auipc	a0,0x15
    800039f0:	02c50513          	addi	a0,a0,44 # 80018a18 <ftable>
    800039f4:	00002097          	auipc	ra,0x2
    800039f8:	73e080e7          	jalr	1854(ra) # 80006132 <release>
  }
}
    800039fc:	70e2                	ld	ra,56(sp)
    800039fe:	7442                	ld	s0,48(sp)
    80003a00:	74a2                	ld	s1,40(sp)
    80003a02:	7902                	ld	s2,32(sp)
    80003a04:	69e2                	ld	s3,24(sp)
    80003a06:	6a42                	ld	s4,16(sp)
    80003a08:	6aa2                	ld	s5,8(sp)
    80003a0a:	6121                	addi	sp,sp,64
    80003a0c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a0e:	85d6                	mv	a1,s5
    80003a10:	8552                	mv	a0,s4
    80003a12:	00000097          	auipc	ra,0x0
    80003a16:	348080e7          	jalr	840(ra) # 80003d5a <pipeclose>
    80003a1a:	b7cd                	j	800039fc <fileclose+0xa8>

0000000080003a1c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a1c:	715d                	addi	sp,sp,-80
    80003a1e:	e486                	sd	ra,72(sp)
    80003a20:	e0a2                	sd	s0,64(sp)
    80003a22:	fc26                	sd	s1,56(sp)
    80003a24:	f84a                	sd	s2,48(sp)
    80003a26:	f44e                	sd	s3,40(sp)
    80003a28:	0880                	addi	s0,sp,80
    80003a2a:	84aa                	mv	s1,a0
    80003a2c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a2e:	ffffd097          	auipc	ra,0xffffd
    80003a32:	424080e7          	jalr	1060(ra) # 80000e52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a36:	409c                	lw	a5,0(s1)
    80003a38:	37f9                	addiw	a5,a5,-2
    80003a3a:	4705                	li	a4,1
    80003a3c:	04f76763          	bltu	a4,a5,80003a8a <filestat+0x6e>
    80003a40:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a42:	6c88                	ld	a0,24(s1)
    80003a44:	fffff097          	auipc	ra,0xfffff
    80003a48:	0a6080e7          	jalr	166(ra) # 80002aea <ilock>
    stati(f->ip, &st);
    80003a4c:	fb840593          	addi	a1,s0,-72
    80003a50:	6c88                	ld	a0,24(s1)
    80003a52:	fffff097          	auipc	ra,0xfffff
    80003a56:	322080e7          	jalr	802(ra) # 80002d74 <stati>
    iunlock(f->ip);
    80003a5a:	6c88                	ld	a0,24(s1)
    80003a5c:	fffff097          	auipc	ra,0xfffff
    80003a60:	150080e7          	jalr	336(ra) # 80002bac <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a64:	46e1                	li	a3,24
    80003a66:	fb840613          	addi	a2,s0,-72
    80003a6a:	85ce                	mv	a1,s3
    80003a6c:	05093503          	ld	a0,80(s2)
    80003a70:	ffffd097          	auipc	ra,0xffffd
    80003a74:	0a2080e7          	jalr	162(ra) # 80000b12 <copyout>
    80003a78:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a7c:	60a6                	ld	ra,72(sp)
    80003a7e:	6406                	ld	s0,64(sp)
    80003a80:	74e2                	ld	s1,56(sp)
    80003a82:	7942                	ld	s2,48(sp)
    80003a84:	79a2                	ld	s3,40(sp)
    80003a86:	6161                	addi	sp,sp,80
    80003a88:	8082                	ret
  return -1;
    80003a8a:	557d                	li	a0,-1
    80003a8c:	bfc5                	j	80003a7c <filestat+0x60>

0000000080003a8e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003a8e:	7179                	addi	sp,sp,-48
    80003a90:	f406                	sd	ra,40(sp)
    80003a92:	f022                	sd	s0,32(sp)
    80003a94:	ec26                	sd	s1,24(sp)
    80003a96:	e84a                	sd	s2,16(sp)
    80003a98:	e44e                	sd	s3,8(sp)
    80003a9a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003a9c:	00854783          	lbu	a5,8(a0)
    80003aa0:	c3d5                	beqz	a5,80003b44 <fileread+0xb6>
    80003aa2:	84aa                	mv	s1,a0
    80003aa4:	89ae                	mv	s3,a1
    80003aa6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003aa8:	411c                	lw	a5,0(a0)
    80003aaa:	4705                	li	a4,1
    80003aac:	04e78963          	beq	a5,a4,80003afe <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ab0:	470d                	li	a4,3
    80003ab2:	04e78d63          	beq	a5,a4,80003b0c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ab6:	4709                	li	a4,2
    80003ab8:	06e79e63          	bne	a5,a4,80003b34 <fileread+0xa6>
    ilock(f->ip);
    80003abc:	6d08                	ld	a0,24(a0)
    80003abe:	fffff097          	auipc	ra,0xfffff
    80003ac2:	02c080e7          	jalr	44(ra) # 80002aea <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ac6:	874a                	mv	a4,s2
    80003ac8:	5094                	lw	a3,32(s1)
    80003aca:	864e                	mv	a2,s3
    80003acc:	4585                	li	a1,1
    80003ace:	6c88                	ld	a0,24(s1)
    80003ad0:	fffff097          	auipc	ra,0xfffff
    80003ad4:	2ce080e7          	jalr	718(ra) # 80002d9e <readi>
    80003ad8:	892a                	mv	s2,a0
    80003ada:	00a05563          	blez	a0,80003ae4 <fileread+0x56>
      f->off += r;
    80003ade:	509c                	lw	a5,32(s1)
    80003ae0:	9fa9                	addw	a5,a5,a0
    80003ae2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ae4:	6c88                	ld	a0,24(s1)
    80003ae6:	fffff097          	auipc	ra,0xfffff
    80003aea:	0c6080e7          	jalr	198(ra) # 80002bac <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003aee:	854a                	mv	a0,s2
    80003af0:	70a2                	ld	ra,40(sp)
    80003af2:	7402                	ld	s0,32(sp)
    80003af4:	64e2                	ld	s1,24(sp)
    80003af6:	6942                	ld	s2,16(sp)
    80003af8:	69a2                	ld	s3,8(sp)
    80003afa:	6145                	addi	sp,sp,48
    80003afc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003afe:	6908                	ld	a0,16(a0)
    80003b00:	00000097          	auipc	ra,0x0
    80003b04:	3c2080e7          	jalr	962(ra) # 80003ec2 <piperead>
    80003b08:	892a                	mv	s2,a0
    80003b0a:	b7d5                	j	80003aee <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b0c:	02451783          	lh	a5,36(a0)
    80003b10:	03079693          	slli	a3,a5,0x30
    80003b14:	92c1                	srli	a3,a3,0x30
    80003b16:	4725                	li	a4,9
    80003b18:	02d76863          	bltu	a4,a3,80003b48 <fileread+0xba>
    80003b1c:	0792                	slli	a5,a5,0x4
    80003b1e:	00015717          	auipc	a4,0x15
    80003b22:	e5a70713          	addi	a4,a4,-422 # 80018978 <devsw>
    80003b26:	97ba                	add	a5,a5,a4
    80003b28:	639c                	ld	a5,0(a5)
    80003b2a:	c38d                	beqz	a5,80003b4c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b2c:	4505                	li	a0,1
    80003b2e:	9782                	jalr	a5
    80003b30:	892a                	mv	s2,a0
    80003b32:	bf75                	j	80003aee <fileread+0x60>
    panic("fileread");
    80003b34:	00005517          	auipc	a0,0x5
    80003b38:	af450513          	addi	a0,a0,-1292 # 80008628 <syscalls+0x258>
    80003b3c:	00002097          	auipc	ra,0x2
    80003b40:	00a080e7          	jalr	10(ra) # 80005b46 <panic>
    return -1;
    80003b44:	597d                	li	s2,-1
    80003b46:	b765                	j	80003aee <fileread+0x60>
      return -1;
    80003b48:	597d                	li	s2,-1
    80003b4a:	b755                	j	80003aee <fileread+0x60>
    80003b4c:	597d                	li	s2,-1
    80003b4e:	b745                	j	80003aee <fileread+0x60>

0000000080003b50 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003b50:	00954783          	lbu	a5,9(a0)
    80003b54:	10078e63          	beqz	a5,80003c70 <filewrite+0x120>
{
    80003b58:	715d                	addi	sp,sp,-80
    80003b5a:	e486                	sd	ra,72(sp)
    80003b5c:	e0a2                	sd	s0,64(sp)
    80003b5e:	fc26                	sd	s1,56(sp)
    80003b60:	f84a                	sd	s2,48(sp)
    80003b62:	f44e                	sd	s3,40(sp)
    80003b64:	f052                	sd	s4,32(sp)
    80003b66:	ec56                	sd	s5,24(sp)
    80003b68:	e85a                	sd	s6,16(sp)
    80003b6a:	e45e                	sd	s7,8(sp)
    80003b6c:	e062                	sd	s8,0(sp)
    80003b6e:	0880                	addi	s0,sp,80
    80003b70:	892a                	mv	s2,a0
    80003b72:	8b2e                	mv	s6,a1
    80003b74:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b76:	411c                	lw	a5,0(a0)
    80003b78:	4705                	li	a4,1
    80003b7a:	02e78263          	beq	a5,a4,80003b9e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b7e:	470d                	li	a4,3
    80003b80:	02e78563          	beq	a5,a4,80003baa <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b84:	4709                	li	a4,2
    80003b86:	0ce79d63          	bne	a5,a4,80003c60 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003b8a:	0ac05b63          	blez	a2,80003c40 <filewrite+0xf0>
    int i = 0;
    80003b8e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003b90:	6b85                	lui	s7,0x1
    80003b92:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003b96:	6c05                	lui	s8,0x1
    80003b98:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003b9c:	a851                	j	80003c30 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003b9e:	6908                	ld	a0,16(a0)
    80003ba0:	00000097          	auipc	ra,0x0
    80003ba4:	22a080e7          	jalr	554(ra) # 80003dca <pipewrite>
    80003ba8:	a045                	j	80003c48 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003baa:	02451783          	lh	a5,36(a0)
    80003bae:	03079693          	slli	a3,a5,0x30
    80003bb2:	92c1                	srli	a3,a3,0x30
    80003bb4:	4725                	li	a4,9
    80003bb6:	0ad76f63          	bltu	a4,a3,80003c74 <filewrite+0x124>
    80003bba:	0792                	slli	a5,a5,0x4
    80003bbc:	00015717          	auipc	a4,0x15
    80003bc0:	dbc70713          	addi	a4,a4,-580 # 80018978 <devsw>
    80003bc4:	97ba                	add	a5,a5,a4
    80003bc6:	679c                	ld	a5,8(a5)
    80003bc8:	cbc5                	beqz	a5,80003c78 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003bca:	4505                	li	a0,1
    80003bcc:	9782                	jalr	a5
    80003bce:	a8ad                	j	80003c48 <filewrite+0xf8>
      if(n1 > max)
    80003bd0:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003bd4:	00000097          	auipc	ra,0x0
    80003bd8:	8bc080e7          	jalr	-1860(ra) # 80003490 <begin_op>
      ilock(f->ip);
    80003bdc:	01893503          	ld	a0,24(s2)
    80003be0:	fffff097          	auipc	ra,0xfffff
    80003be4:	f0a080e7          	jalr	-246(ra) # 80002aea <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003be8:	8756                	mv	a4,s5
    80003bea:	02092683          	lw	a3,32(s2)
    80003bee:	01698633          	add	a2,s3,s6
    80003bf2:	4585                	li	a1,1
    80003bf4:	01893503          	ld	a0,24(s2)
    80003bf8:	fffff097          	auipc	ra,0xfffff
    80003bfc:	29e080e7          	jalr	670(ra) # 80002e96 <writei>
    80003c00:	84aa                	mv	s1,a0
    80003c02:	00a05763          	blez	a0,80003c10 <filewrite+0xc0>
        f->off += r;
    80003c06:	02092783          	lw	a5,32(s2)
    80003c0a:	9fa9                	addw	a5,a5,a0
    80003c0c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c10:	01893503          	ld	a0,24(s2)
    80003c14:	fffff097          	auipc	ra,0xfffff
    80003c18:	f98080e7          	jalr	-104(ra) # 80002bac <iunlock>
      end_op();
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	8ee080e7          	jalr	-1810(ra) # 8000350a <end_op>

      if(r != n1){
    80003c24:	009a9f63          	bne	s5,s1,80003c42 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003c28:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c2c:	0149db63          	bge	s3,s4,80003c42 <filewrite+0xf2>
      int n1 = n - i;
    80003c30:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003c34:	0004879b          	sext.w	a5,s1
    80003c38:	f8fbdce3          	bge	s7,a5,80003bd0 <filewrite+0x80>
    80003c3c:	84e2                	mv	s1,s8
    80003c3e:	bf49                	j	80003bd0 <filewrite+0x80>
    int i = 0;
    80003c40:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c42:	033a1d63          	bne	s4,s3,80003c7c <filewrite+0x12c>
    80003c46:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c48:	60a6                	ld	ra,72(sp)
    80003c4a:	6406                	ld	s0,64(sp)
    80003c4c:	74e2                	ld	s1,56(sp)
    80003c4e:	7942                	ld	s2,48(sp)
    80003c50:	79a2                	ld	s3,40(sp)
    80003c52:	7a02                	ld	s4,32(sp)
    80003c54:	6ae2                	ld	s5,24(sp)
    80003c56:	6b42                	ld	s6,16(sp)
    80003c58:	6ba2                	ld	s7,8(sp)
    80003c5a:	6c02                	ld	s8,0(sp)
    80003c5c:	6161                	addi	sp,sp,80
    80003c5e:	8082                	ret
    panic("filewrite");
    80003c60:	00005517          	auipc	a0,0x5
    80003c64:	9d850513          	addi	a0,a0,-1576 # 80008638 <syscalls+0x268>
    80003c68:	00002097          	auipc	ra,0x2
    80003c6c:	ede080e7          	jalr	-290(ra) # 80005b46 <panic>
    return -1;
    80003c70:	557d                	li	a0,-1
}
    80003c72:	8082                	ret
      return -1;
    80003c74:	557d                	li	a0,-1
    80003c76:	bfc9                	j	80003c48 <filewrite+0xf8>
    80003c78:	557d                	li	a0,-1
    80003c7a:	b7f9                	j	80003c48 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003c7c:	557d                	li	a0,-1
    80003c7e:	b7e9                	j	80003c48 <filewrite+0xf8>

0000000080003c80 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003c80:	7179                	addi	sp,sp,-48
    80003c82:	f406                	sd	ra,40(sp)
    80003c84:	f022                	sd	s0,32(sp)
    80003c86:	ec26                	sd	s1,24(sp)
    80003c88:	e84a                	sd	s2,16(sp)
    80003c8a:	e44e                	sd	s3,8(sp)
    80003c8c:	e052                	sd	s4,0(sp)
    80003c8e:	1800                	addi	s0,sp,48
    80003c90:	84aa                	mv	s1,a0
    80003c92:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003c94:	0005b023          	sd	zero,0(a1)
    80003c98:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003c9c:	00000097          	auipc	ra,0x0
    80003ca0:	bfc080e7          	jalr	-1028(ra) # 80003898 <filealloc>
    80003ca4:	e088                	sd	a0,0(s1)
    80003ca6:	c551                	beqz	a0,80003d32 <pipealloc+0xb2>
    80003ca8:	00000097          	auipc	ra,0x0
    80003cac:	bf0080e7          	jalr	-1040(ra) # 80003898 <filealloc>
    80003cb0:	00aa3023          	sd	a0,0(s4)
    80003cb4:	c92d                	beqz	a0,80003d26 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003cb6:	ffffc097          	auipc	ra,0xffffc
    80003cba:	464080e7          	jalr	1124(ra) # 8000011a <kalloc>
    80003cbe:	892a                	mv	s2,a0
    80003cc0:	c125                	beqz	a0,80003d20 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003cc2:	4985                	li	s3,1
    80003cc4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003cc8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ccc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003cd0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003cd4:	00005597          	auipc	a1,0x5
    80003cd8:	97458593          	addi	a1,a1,-1676 # 80008648 <syscalls+0x278>
    80003cdc:	00002097          	auipc	ra,0x2
    80003ce0:	312080e7          	jalr	786(ra) # 80005fee <initlock>
  (*f0)->type = FD_PIPE;
    80003ce4:	609c                	ld	a5,0(s1)
    80003ce6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003cea:	609c                	ld	a5,0(s1)
    80003cec:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003cf0:	609c                	ld	a5,0(s1)
    80003cf2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003cf6:	609c                	ld	a5,0(s1)
    80003cf8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003cfc:	000a3783          	ld	a5,0(s4)
    80003d00:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d04:	000a3783          	ld	a5,0(s4)
    80003d08:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d0c:	000a3783          	ld	a5,0(s4)
    80003d10:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d14:	000a3783          	ld	a5,0(s4)
    80003d18:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d1c:	4501                	li	a0,0
    80003d1e:	a025                	j	80003d46 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d20:	6088                	ld	a0,0(s1)
    80003d22:	e501                	bnez	a0,80003d2a <pipealloc+0xaa>
    80003d24:	a039                	j	80003d32 <pipealloc+0xb2>
    80003d26:	6088                	ld	a0,0(s1)
    80003d28:	c51d                	beqz	a0,80003d56 <pipealloc+0xd6>
    fileclose(*f0);
    80003d2a:	00000097          	auipc	ra,0x0
    80003d2e:	c2a080e7          	jalr	-982(ra) # 80003954 <fileclose>
  if(*f1)
    80003d32:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d36:	557d                	li	a0,-1
  if(*f1)
    80003d38:	c799                	beqz	a5,80003d46 <pipealloc+0xc6>
    fileclose(*f1);
    80003d3a:	853e                	mv	a0,a5
    80003d3c:	00000097          	auipc	ra,0x0
    80003d40:	c18080e7          	jalr	-1000(ra) # 80003954 <fileclose>
  return -1;
    80003d44:	557d                	li	a0,-1
}
    80003d46:	70a2                	ld	ra,40(sp)
    80003d48:	7402                	ld	s0,32(sp)
    80003d4a:	64e2                	ld	s1,24(sp)
    80003d4c:	6942                	ld	s2,16(sp)
    80003d4e:	69a2                	ld	s3,8(sp)
    80003d50:	6a02                	ld	s4,0(sp)
    80003d52:	6145                	addi	sp,sp,48
    80003d54:	8082                	ret
  return -1;
    80003d56:	557d                	li	a0,-1
    80003d58:	b7fd                	j	80003d46 <pipealloc+0xc6>

0000000080003d5a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d5a:	1101                	addi	sp,sp,-32
    80003d5c:	ec06                	sd	ra,24(sp)
    80003d5e:	e822                	sd	s0,16(sp)
    80003d60:	e426                	sd	s1,8(sp)
    80003d62:	e04a                	sd	s2,0(sp)
    80003d64:	1000                	addi	s0,sp,32
    80003d66:	84aa                	mv	s1,a0
    80003d68:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d6a:	00002097          	auipc	ra,0x2
    80003d6e:	314080e7          	jalr	788(ra) # 8000607e <acquire>
  if(writable){
    80003d72:	02090d63          	beqz	s2,80003dac <pipeclose+0x52>
    pi->writeopen = 0;
    80003d76:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d7a:	21848513          	addi	a0,s1,536
    80003d7e:	ffffd097          	auipc	ra,0xffffd
    80003d82:	7e0080e7          	jalr	2016(ra) # 8000155e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003d86:	2204b783          	ld	a5,544(s1)
    80003d8a:	eb95                	bnez	a5,80003dbe <pipeclose+0x64>
    release(&pi->lock);
    80003d8c:	8526                	mv	a0,s1
    80003d8e:	00002097          	auipc	ra,0x2
    80003d92:	3a4080e7          	jalr	932(ra) # 80006132 <release>
    kfree((char*)pi);
    80003d96:	8526                	mv	a0,s1
    80003d98:	ffffc097          	auipc	ra,0xffffc
    80003d9c:	284080e7          	jalr	644(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003da0:	60e2                	ld	ra,24(sp)
    80003da2:	6442                	ld	s0,16(sp)
    80003da4:	64a2                	ld	s1,8(sp)
    80003da6:	6902                	ld	s2,0(sp)
    80003da8:	6105                	addi	sp,sp,32
    80003daa:	8082                	ret
    pi->readopen = 0;
    80003dac:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003db0:	21c48513          	addi	a0,s1,540
    80003db4:	ffffd097          	auipc	ra,0xffffd
    80003db8:	7aa080e7          	jalr	1962(ra) # 8000155e <wakeup>
    80003dbc:	b7e9                	j	80003d86 <pipeclose+0x2c>
    release(&pi->lock);
    80003dbe:	8526                	mv	a0,s1
    80003dc0:	00002097          	auipc	ra,0x2
    80003dc4:	372080e7          	jalr	882(ra) # 80006132 <release>
}
    80003dc8:	bfe1                	j	80003da0 <pipeclose+0x46>

0000000080003dca <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003dca:	711d                	addi	sp,sp,-96
    80003dcc:	ec86                	sd	ra,88(sp)
    80003dce:	e8a2                	sd	s0,80(sp)
    80003dd0:	e4a6                	sd	s1,72(sp)
    80003dd2:	e0ca                	sd	s2,64(sp)
    80003dd4:	fc4e                	sd	s3,56(sp)
    80003dd6:	f852                	sd	s4,48(sp)
    80003dd8:	f456                	sd	s5,40(sp)
    80003dda:	f05a                	sd	s6,32(sp)
    80003ddc:	ec5e                	sd	s7,24(sp)
    80003dde:	e862                	sd	s8,16(sp)
    80003de0:	1080                	addi	s0,sp,96
    80003de2:	84aa                	mv	s1,a0
    80003de4:	8aae                	mv	s5,a1
    80003de6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003de8:	ffffd097          	auipc	ra,0xffffd
    80003dec:	06a080e7          	jalr	106(ra) # 80000e52 <myproc>
    80003df0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003df2:	8526                	mv	a0,s1
    80003df4:	00002097          	auipc	ra,0x2
    80003df8:	28a080e7          	jalr	650(ra) # 8000607e <acquire>
  while(i < n){
    80003dfc:	0b405663          	blez	s4,80003ea8 <pipewrite+0xde>
  int i = 0;
    80003e00:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e02:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e04:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e08:	21c48b93          	addi	s7,s1,540
    80003e0c:	a089                	j	80003e4e <pipewrite+0x84>
      release(&pi->lock);
    80003e0e:	8526                	mv	a0,s1
    80003e10:	00002097          	auipc	ra,0x2
    80003e14:	322080e7          	jalr	802(ra) # 80006132 <release>
      return -1;
    80003e18:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e1a:	854a                	mv	a0,s2
    80003e1c:	60e6                	ld	ra,88(sp)
    80003e1e:	6446                	ld	s0,80(sp)
    80003e20:	64a6                	ld	s1,72(sp)
    80003e22:	6906                	ld	s2,64(sp)
    80003e24:	79e2                	ld	s3,56(sp)
    80003e26:	7a42                	ld	s4,48(sp)
    80003e28:	7aa2                	ld	s5,40(sp)
    80003e2a:	7b02                	ld	s6,32(sp)
    80003e2c:	6be2                	ld	s7,24(sp)
    80003e2e:	6c42                	ld	s8,16(sp)
    80003e30:	6125                	addi	sp,sp,96
    80003e32:	8082                	ret
      wakeup(&pi->nread);
    80003e34:	8562                	mv	a0,s8
    80003e36:	ffffd097          	auipc	ra,0xffffd
    80003e3a:	728080e7          	jalr	1832(ra) # 8000155e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e3e:	85a6                	mv	a1,s1
    80003e40:	855e                	mv	a0,s7
    80003e42:	ffffd097          	auipc	ra,0xffffd
    80003e46:	6b8080e7          	jalr	1720(ra) # 800014fa <sleep>
  while(i < n){
    80003e4a:	07495063          	bge	s2,s4,80003eaa <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003e4e:	2204a783          	lw	a5,544(s1)
    80003e52:	dfd5                	beqz	a5,80003e0e <pipewrite+0x44>
    80003e54:	854e                	mv	a0,s3
    80003e56:	ffffe097          	auipc	ra,0xffffe
    80003e5a:	94c080e7          	jalr	-1716(ra) # 800017a2 <killed>
    80003e5e:	f945                	bnez	a0,80003e0e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e60:	2184a783          	lw	a5,536(s1)
    80003e64:	21c4a703          	lw	a4,540(s1)
    80003e68:	2007879b          	addiw	a5,a5,512
    80003e6c:	fcf704e3          	beq	a4,a5,80003e34 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e70:	4685                	li	a3,1
    80003e72:	01590633          	add	a2,s2,s5
    80003e76:	faf40593          	addi	a1,s0,-81
    80003e7a:	0509b503          	ld	a0,80(s3)
    80003e7e:	ffffd097          	auipc	ra,0xffffd
    80003e82:	d20080e7          	jalr	-736(ra) # 80000b9e <copyin>
    80003e86:	03650263          	beq	a0,s6,80003eaa <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003e8a:	21c4a783          	lw	a5,540(s1)
    80003e8e:	0017871b          	addiw	a4,a5,1
    80003e92:	20e4ae23          	sw	a4,540(s1)
    80003e96:	1ff7f793          	andi	a5,a5,511
    80003e9a:	97a6                	add	a5,a5,s1
    80003e9c:	faf44703          	lbu	a4,-81(s0)
    80003ea0:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ea4:	2905                	addiw	s2,s2,1
    80003ea6:	b755                	j	80003e4a <pipewrite+0x80>
  int i = 0;
    80003ea8:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003eaa:	21848513          	addi	a0,s1,536
    80003eae:	ffffd097          	auipc	ra,0xffffd
    80003eb2:	6b0080e7          	jalr	1712(ra) # 8000155e <wakeup>
  release(&pi->lock);
    80003eb6:	8526                	mv	a0,s1
    80003eb8:	00002097          	auipc	ra,0x2
    80003ebc:	27a080e7          	jalr	634(ra) # 80006132 <release>
  return i;
    80003ec0:	bfa9                	j	80003e1a <pipewrite+0x50>

0000000080003ec2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ec2:	715d                	addi	sp,sp,-80
    80003ec4:	e486                	sd	ra,72(sp)
    80003ec6:	e0a2                	sd	s0,64(sp)
    80003ec8:	fc26                	sd	s1,56(sp)
    80003eca:	f84a                	sd	s2,48(sp)
    80003ecc:	f44e                	sd	s3,40(sp)
    80003ece:	f052                	sd	s4,32(sp)
    80003ed0:	ec56                	sd	s5,24(sp)
    80003ed2:	e85a                	sd	s6,16(sp)
    80003ed4:	0880                	addi	s0,sp,80
    80003ed6:	84aa                	mv	s1,a0
    80003ed8:	892e                	mv	s2,a1
    80003eda:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003edc:	ffffd097          	auipc	ra,0xffffd
    80003ee0:	f76080e7          	jalr	-138(ra) # 80000e52 <myproc>
    80003ee4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ee6:	8526                	mv	a0,s1
    80003ee8:	00002097          	auipc	ra,0x2
    80003eec:	196080e7          	jalr	406(ra) # 8000607e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ef0:	2184a703          	lw	a4,536(s1)
    80003ef4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ef8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003efc:	02f71763          	bne	a4,a5,80003f2a <piperead+0x68>
    80003f00:	2244a783          	lw	a5,548(s1)
    80003f04:	c39d                	beqz	a5,80003f2a <piperead+0x68>
    if(killed(pr)){
    80003f06:	8552                	mv	a0,s4
    80003f08:	ffffe097          	auipc	ra,0xffffe
    80003f0c:	89a080e7          	jalr	-1894(ra) # 800017a2 <killed>
    80003f10:	e949                	bnez	a0,80003fa2 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f12:	85a6                	mv	a1,s1
    80003f14:	854e                	mv	a0,s3
    80003f16:	ffffd097          	auipc	ra,0xffffd
    80003f1a:	5e4080e7          	jalr	1508(ra) # 800014fa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f1e:	2184a703          	lw	a4,536(s1)
    80003f22:	21c4a783          	lw	a5,540(s1)
    80003f26:	fcf70de3          	beq	a4,a5,80003f00 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f2a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f2c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f2e:	05505463          	blez	s5,80003f76 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80003f32:	2184a783          	lw	a5,536(s1)
    80003f36:	21c4a703          	lw	a4,540(s1)
    80003f3a:	02f70e63          	beq	a4,a5,80003f76 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f3e:	0017871b          	addiw	a4,a5,1
    80003f42:	20e4ac23          	sw	a4,536(s1)
    80003f46:	1ff7f793          	andi	a5,a5,511
    80003f4a:	97a6                	add	a5,a5,s1
    80003f4c:	0187c783          	lbu	a5,24(a5)
    80003f50:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f54:	4685                	li	a3,1
    80003f56:	fbf40613          	addi	a2,s0,-65
    80003f5a:	85ca                	mv	a1,s2
    80003f5c:	050a3503          	ld	a0,80(s4)
    80003f60:	ffffd097          	auipc	ra,0xffffd
    80003f64:	bb2080e7          	jalr	-1102(ra) # 80000b12 <copyout>
    80003f68:	01650763          	beq	a0,s6,80003f76 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f6c:	2985                	addiw	s3,s3,1
    80003f6e:	0905                	addi	s2,s2,1
    80003f70:	fd3a91e3          	bne	s5,s3,80003f32 <piperead+0x70>
    80003f74:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f76:	21c48513          	addi	a0,s1,540
    80003f7a:	ffffd097          	auipc	ra,0xffffd
    80003f7e:	5e4080e7          	jalr	1508(ra) # 8000155e <wakeup>
  release(&pi->lock);
    80003f82:	8526                	mv	a0,s1
    80003f84:	00002097          	auipc	ra,0x2
    80003f88:	1ae080e7          	jalr	430(ra) # 80006132 <release>
  return i;
}
    80003f8c:	854e                	mv	a0,s3
    80003f8e:	60a6                	ld	ra,72(sp)
    80003f90:	6406                	ld	s0,64(sp)
    80003f92:	74e2                	ld	s1,56(sp)
    80003f94:	7942                	ld	s2,48(sp)
    80003f96:	79a2                	ld	s3,40(sp)
    80003f98:	7a02                	ld	s4,32(sp)
    80003f9a:	6ae2                	ld	s5,24(sp)
    80003f9c:	6b42                	ld	s6,16(sp)
    80003f9e:	6161                	addi	sp,sp,80
    80003fa0:	8082                	ret
      release(&pi->lock);
    80003fa2:	8526                	mv	a0,s1
    80003fa4:	00002097          	auipc	ra,0x2
    80003fa8:	18e080e7          	jalr	398(ra) # 80006132 <release>
      return -1;
    80003fac:	59fd                	li	s3,-1
    80003fae:	bff9                	j	80003f8c <piperead+0xca>

0000000080003fb0 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003fb0:	1141                	addi	sp,sp,-16
    80003fb2:	e422                	sd	s0,8(sp)
    80003fb4:	0800                	addi	s0,sp,16
    80003fb6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003fb8:	8905                	andi	a0,a0,1
    80003fba:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003fbc:	8b89                	andi	a5,a5,2
    80003fbe:	c399                	beqz	a5,80003fc4 <flags2perm+0x14>
      perm |= PTE_W;
    80003fc0:	00456513          	ori	a0,a0,4
    return perm;
}
    80003fc4:	6422                	ld	s0,8(sp)
    80003fc6:	0141                	addi	sp,sp,16
    80003fc8:	8082                	ret

0000000080003fca <exec>:

int
exec(char *path, char **argv)
{
    80003fca:	df010113          	addi	sp,sp,-528
    80003fce:	20113423          	sd	ra,520(sp)
    80003fd2:	20813023          	sd	s0,512(sp)
    80003fd6:	ffa6                	sd	s1,504(sp)
    80003fd8:	fbca                	sd	s2,496(sp)
    80003fda:	f7ce                	sd	s3,488(sp)
    80003fdc:	f3d2                	sd	s4,480(sp)
    80003fde:	efd6                	sd	s5,472(sp)
    80003fe0:	ebda                	sd	s6,464(sp)
    80003fe2:	e7de                	sd	s7,456(sp)
    80003fe4:	e3e2                	sd	s8,448(sp)
    80003fe6:	ff66                	sd	s9,440(sp)
    80003fe8:	fb6a                	sd	s10,432(sp)
    80003fea:	f76e                	sd	s11,424(sp)
    80003fec:	0c00                	addi	s0,sp,528
    80003fee:	892a                	mv	s2,a0
    80003ff0:	dea43c23          	sd	a0,-520(s0)
    80003ff4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003ff8:	ffffd097          	auipc	ra,0xffffd
    80003ffc:	e5a080e7          	jalr	-422(ra) # 80000e52 <myproc>
    80004000:	84aa                	mv	s1,a0

  begin_op();
    80004002:	fffff097          	auipc	ra,0xfffff
    80004006:	48e080e7          	jalr	1166(ra) # 80003490 <begin_op>

  if((ip = namei(path)) == 0){
    8000400a:	854a                	mv	a0,s2
    8000400c:	fffff097          	auipc	ra,0xfffff
    80004010:	284080e7          	jalr	644(ra) # 80003290 <namei>
    80004014:	c92d                	beqz	a0,80004086 <exec+0xbc>
    80004016:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004018:	fffff097          	auipc	ra,0xfffff
    8000401c:	ad2080e7          	jalr	-1326(ra) # 80002aea <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004020:	04000713          	li	a4,64
    80004024:	4681                	li	a3,0
    80004026:	e5040613          	addi	a2,s0,-432
    8000402a:	4581                	li	a1,0
    8000402c:	8552                	mv	a0,s4
    8000402e:	fffff097          	auipc	ra,0xfffff
    80004032:	d70080e7          	jalr	-656(ra) # 80002d9e <readi>
    80004036:	04000793          	li	a5,64
    8000403a:	00f51a63          	bne	a0,a5,8000404e <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000403e:	e5042703          	lw	a4,-432(s0)
    80004042:	464c47b7          	lui	a5,0x464c4
    80004046:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000404a:	04f70463          	beq	a4,a5,80004092 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000404e:	8552                	mv	a0,s4
    80004050:	fffff097          	auipc	ra,0xfffff
    80004054:	cfc080e7          	jalr	-772(ra) # 80002d4c <iunlockput>
    end_op();
    80004058:	fffff097          	auipc	ra,0xfffff
    8000405c:	4b2080e7          	jalr	1202(ra) # 8000350a <end_op>
  }
  return -1;
    80004060:	557d                	li	a0,-1
}
    80004062:	20813083          	ld	ra,520(sp)
    80004066:	20013403          	ld	s0,512(sp)
    8000406a:	74fe                	ld	s1,504(sp)
    8000406c:	795e                	ld	s2,496(sp)
    8000406e:	79be                	ld	s3,488(sp)
    80004070:	7a1e                	ld	s4,480(sp)
    80004072:	6afe                	ld	s5,472(sp)
    80004074:	6b5e                	ld	s6,464(sp)
    80004076:	6bbe                	ld	s7,456(sp)
    80004078:	6c1e                	ld	s8,448(sp)
    8000407a:	7cfa                	ld	s9,440(sp)
    8000407c:	7d5a                	ld	s10,432(sp)
    8000407e:	7dba                	ld	s11,424(sp)
    80004080:	21010113          	addi	sp,sp,528
    80004084:	8082                	ret
    end_op();
    80004086:	fffff097          	auipc	ra,0xfffff
    8000408a:	484080e7          	jalr	1156(ra) # 8000350a <end_op>
    return -1;
    8000408e:	557d                	li	a0,-1
    80004090:	bfc9                	j	80004062 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004092:	8526                	mv	a0,s1
    80004094:	ffffd097          	auipc	ra,0xffffd
    80004098:	e82080e7          	jalr	-382(ra) # 80000f16 <proc_pagetable>
    8000409c:	8b2a                	mv	s6,a0
    8000409e:	d945                	beqz	a0,8000404e <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040a0:	e7042d03          	lw	s10,-400(s0)
    800040a4:	e8845783          	lhu	a5,-376(s0)
    800040a8:	10078463          	beqz	a5,800041b0 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040ac:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040ae:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800040b0:	6c85                	lui	s9,0x1
    800040b2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800040b6:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800040ba:	6a85                	lui	s5,0x1
    800040bc:	a0b5                	j	80004128 <exec+0x15e>
      panic("loadseg: address should exist");
    800040be:	00004517          	auipc	a0,0x4
    800040c2:	59250513          	addi	a0,a0,1426 # 80008650 <syscalls+0x280>
    800040c6:	00002097          	auipc	ra,0x2
    800040ca:	a80080e7          	jalr	-1408(ra) # 80005b46 <panic>
    if(sz - i < PGSIZE)
    800040ce:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040d0:	8726                	mv	a4,s1
    800040d2:	012c06bb          	addw	a3,s8,s2
    800040d6:	4581                	li	a1,0
    800040d8:	8552                	mv	a0,s4
    800040da:	fffff097          	auipc	ra,0xfffff
    800040de:	cc4080e7          	jalr	-828(ra) # 80002d9e <readi>
    800040e2:	2501                	sext.w	a0,a0
    800040e4:	24a49863          	bne	s1,a0,80004334 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    800040e8:	012a893b          	addw	s2,s5,s2
    800040ec:	03397563          	bgeu	s2,s3,80004116 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    800040f0:	02091593          	slli	a1,s2,0x20
    800040f4:	9181                	srli	a1,a1,0x20
    800040f6:	95de                	add	a1,a1,s7
    800040f8:	855a                	mv	a0,s6
    800040fa:	ffffc097          	auipc	ra,0xffffc
    800040fe:	408080e7          	jalr	1032(ra) # 80000502 <walkaddr>
    80004102:	862a                	mv	a2,a0
    if(pa == 0)
    80004104:	dd4d                	beqz	a0,800040be <exec+0xf4>
    if(sz - i < PGSIZE)
    80004106:	412984bb          	subw	s1,s3,s2
    8000410a:	0004879b          	sext.w	a5,s1
    8000410e:	fcfcf0e3          	bgeu	s9,a5,800040ce <exec+0x104>
    80004112:	84d6                	mv	s1,s5
    80004114:	bf6d                	j	800040ce <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004116:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000411a:	2d85                	addiw	s11,s11,1
    8000411c:	038d0d1b          	addiw	s10,s10,56
    80004120:	e8845783          	lhu	a5,-376(s0)
    80004124:	08fdd763          	bge	s11,a5,800041b2 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004128:	2d01                	sext.w	s10,s10
    8000412a:	03800713          	li	a4,56
    8000412e:	86ea                	mv	a3,s10
    80004130:	e1840613          	addi	a2,s0,-488
    80004134:	4581                	li	a1,0
    80004136:	8552                	mv	a0,s4
    80004138:	fffff097          	auipc	ra,0xfffff
    8000413c:	c66080e7          	jalr	-922(ra) # 80002d9e <readi>
    80004140:	03800793          	li	a5,56
    80004144:	1ef51663          	bne	a0,a5,80004330 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80004148:	e1842783          	lw	a5,-488(s0)
    8000414c:	4705                	li	a4,1
    8000414e:	fce796e3          	bne	a5,a4,8000411a <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004152:	e4043483          	ld	s1,-448(s0)
    80004156:	e3843783          	ld	a5,-456(s0)
    8000415a:	1ef4e863          	bltu	s1,a5,8000434a <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000415e:	e2843783          	ld	a5,-472(s0)
    80004162:	94be                	add	s1,s1,a5
    80004164:	1ef4e663          	bltu	s1,a5,80004350 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80004168:	df043703          	ld	a4,-528(s0)
    8000416c:	8ff9                	and	a5,a5,a4
    8000416e:	1e079463          	bnez	a5,80004356 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004172:	e1c42503          	lw	a0,-484(s0)
    80004176:	00000097          	auipc	ra,0x0
    8000417a:	e3a080e7          	jalr	-454(ra) # 80003fb0 <flags2perm>
    8000417e:	86aa                	mv	a3,a0
    80004180:	8626                	mv	a2,s1
    80004182:	85ca                	mv	a1,s2
    80004184:	855a                	mv	a0,s6
    80004186:	ffffc097          	auipc	ra,0xffffc
    8000418a:	730080e7          	jalr	1840(ra) # 800008b6 <uvmalloc>
    8000418e:	e0a43423          	sd	a0,-504(s0)
    80004192:	1c050563          	beqz	a0,8000435c <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004196:	e2843b83          	ld	s7,-472(s0)
    8000419a:	e2042c03          	lw	s8,-480(s0)
    8000419e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800041a2:	00098463          	beqz	s3,800041aa <exec+0x1e0>
    800041a6:	4901                	li	s2,0
    800041a8:	b7a1                	j	800040f0 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800041aa:	e0843903          	ld	s2,-504(s0)
    800041ae:	b7b5                	j	8000411a <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041b0:	4901                	li	s2,0
  iunlockput(ip);
    800041b2:	8552                	mv	a0,s4
    800041b4:	fffff097          	auipc	ra,0xfffff
    800041b8:	b98080e7          	jalr	-1128(ra) # 80002d4c <iunlockput>
  end_op();
    800041bc:	fffff097          	auipc	ra,0xfffff
    800041c0:	34e080e7          	jalr	846(ra) # 8000350a <end_op>
  p = myproc();
    800041c4:	ffffd097          	auipc	ra,0xffffd
    800041c8:	c8e080e7          	jalr	-882(ra) # 80000e52 <myproc>
    800041cc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041ce:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800041d2:	6985                	lui	s3,0x1
    800041d4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800041d6:	99ca                	add	s3,s3,s2
    800041d8:	77fd                	lui	a5,0xfffff
    800041da:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041de:	4691                	li	a3,4
    800041e0:	6609                	lui	a2,0x2
    800041e2:	964e                	add	a2,a2,s3
    800041e4:	85ce                	mv	a1,s3
    800041e6:	855a                	mv	a0,s6
    800041e8:	ffffc097          	auipc	ra,0xffffc
    800041ec:	6ce080e7          	jalr	1742(ra) # 800008b6 <uvmalloc>
    800041f0:	892a                	mv	s2,a0
    800041f2:	e0a43423          	sd	a0,-504(s0)
    800041f6:	e509                	bnez	a0,80004200 <exec+0x236>
  if(pagetable)
    800041f8:	e1343423          	sd	s3,-504(s0)
    800041fc:	4a01                	li	s4,0
    800041fe:	aa1d                	j	80004334 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004200:	75f9                	lui	a1,0xffffe
    80004202:	95aa                	add	a1,a1,a0
    80004204:	855a                	mv	a0,s6
    80004206:	ffffd097          	auipc	ra,0xffffd
    8000420a:	8da080e7          	jalr	-1830(ra) # 80000ae0 <uvmclear>
  stackbase = sp - PGSIZE;
    8000420e:	7bfd                	lui	s7,0xfffff
    80004210:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004212:	e0043783          	ld	a5,-512(s0)
    80004216:	6388                	ld	a0,0(a5)
    80004218:	c52d                	beqz	a0,80004282 <exec+0x2b8>
    8000421a:	e9040993          	addi	s3,s0,-368
    8000421e:	f9040c13          	addi	s8,s0,-112
    80004222:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004224:	ffffc097          	auipc	ra,0xffffc
    80004228:	0d0080e7          	jalr	208(ra) # 800002f4 <strlen>
    8000422c:	0015079b          	addiw	a5,a0,1
    80004230:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004234:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004238:	13796563          	bltu	s2,s7,80004362 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000423c:	e0043d03          	ld	s10,-512(s0)
    80004240:	000d3a03          	ld	s4,0(s10)
    80004244:	8552                	mv	a0,s4
    80004246:	ffffc097          	auipc	ra,0xffffc
    8000424a:	0ae080e7          	jalr	174(ra) # 800002f4 <strlen>
    8000424e:	0015069b          	addiw	a3,a0,1
    80004252:	8652                	mv	a2,s4
    80004254:	85ca                	mv	a1,s2
    80004256:	855a                	mv	a0,s6
    80004258:	ffffd097          	auipc	ra,0xffffd
    8000425c:	8ba080e7          	jalr	-1862(ra) # 80000b12 <copyout>
    80004260:	10054363          	bltz	a0,80004366 <exec+0x39c>
    ustack[argc] = sp;
    80004264:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004268:	0485                	addi	s1,s1,1
    8000426a:	008d0793          	addi	a5,s10,8
    8000426e:	e0f43023          	sd	a5,-512(s0)
    80004272:	008d3503          	ld	a0,8(s10)
    80004276:	c909                	beqz	a0,80004288 <exec+0x2be>
    if(argc >= MAXARG)
    80004278:	09a1                	addi	s3,s3,8
    8000427a:	fb8995e3          	bne	s3,s8,80004224 <exec+0x25a>
  ip = 0;
    8000427e:	4a01                	li	s4,0
    80004280:	a855                	j	80004334 <exec+0x36a>
  sp = sz;
    80004282:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004286:	4481                	li	s1,0
  ustack[argc] = 0;
    80004288:	00349793          	slli	a5,s1,0x3
    8000428c:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd240>
    80004290:	97a2                	add	a5,a5,s0
    80004292:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004296:	00148693          	addi	a3,s1,1
    8000429a:	068e                	slli	a3,a3,0x3
    8000429c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042a0:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800042a4:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800042a8:	f57968e3          	bltu	s2,s7,800041f8 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042ac:	e9040613          	addi	a2,s0,-368
    800042b0:	85ca                	mv	a1,s2
    800042b2:	855a                	mv	a0,s6
    800042b4:	ffffd097          	auipc	ra,0xffffd
    800042b8:	85e080e7          	jalr	-1954(ra) # 80000b12 <copyout>
    800042bc:	0a054763          	bltz	a0,8000436a <exec+0x3a0>
  p->trapframe->a1 = sp;
    800042c0:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800042c4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042c8:	df843783          	ld	a5,-520(s0)
    800042cc:	0007c703          	lbu	a4,0(a5)
    800042d0:	cf11                	beqz	a4,800042ec <exec+0x322>
    800042d2:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042d4:	02f00693          	li	a3,47
    800042d8:	a039                	j	800042e6 <exec+0x31c>
      last = s+1;
    800042da:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800042de:	0785                	addi	a5,a5,1
    800042e0:	fff7c703          	lbu	a4,-1(a5)
    800042e4:	c701                	beqz	a4,800042ec <exec+0x322>
    if(*s == '/')
    800042e6:	fed71ce3          	bne	a4,a3,800042de <exec+0x314>
    800042ea:	bfc5                	j	800042da <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    800042ec:	4641                	li	a2,16
    800042ee:	df843583          	ld	a1,-520(s0)
    800042f2:	158a8513          	addi	a0,s5,344
    800042f6:	ffffc097          	auipc	ra,0xffffc
    800042fa:	fcc080e7          	jalr	-52(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    800042fe:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004302:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004306:	e0843783          	ld	a5,-504(s0)
    8000430a:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000430e:	058ab783          	ld	a5,88(s5)
    80004312:	e6843703          	ld	a4,-408(s0)
    80004316:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004318:	058ab783          	ld	a5,88(s5)
    8000431c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004320:	85e6                	mv	a1,s9
    80004322:	ffffd097          	auipc	ra,0xffffd
    80004326:	c90080e7          	jalr	-880(ra) # 80000fb2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000432a:	0004851b          	sext.w	a0,s1
    8000432e:	bb15                	j	80004062 <exec+0x98>
    80004330:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004334:	e0843583          	ld	a1,-504(s0)
    80004338:	855a                	mv	a0,s6
    8000433a:	ffffd097          	auipc	ra,0xffffd
    8000433e:	c78080e7          	jalr	-904(ra) # 80000fb2 <proc_freepagetable>
  return -1;
    80004342:	557d                	li	a0,-1
  if(ip){
    80004344:	d00a0fe3          	beqz	s4,80004062 <exec+0x98>
    80004348:	b319                	j	8000404e <exec+0x84>
    8000434a:	e1243423          	sd	s2,-504(s0)
    8000434e:	b7dd                	j	80004334 <exec+0x36a>
    80004350:	e1243423          	sd	s2,-504(s0)
    80004354:	b7c5                	j	80004334 <exec+0x36a>
    80004356:	e1243423          	sd	s2,-504(s0)
    8000435a:	bfe9                	j	80004334 <exec+0x36a>
    8000435c:	e1243423          	sd	s2,-504(s0)
    80004360:	bfd1                	j	80004334 <exec+0x36a>
  ip = 0;
    80004362:	4a01                	li	s4,0
    80004364:	bfc1                	j	80004334 <exec+0x36a>
    80004366:	4a01                	li	s4,0
  if(pagetable)
    80004368:	b7f1                	j	80004334 <exec+0x36a>
  sz = sz1;
    8000436a:	e0843983          	ld	s3,-504(s0)
    8000436e:	b569                	j	800041f8 <exec+0x22e>

0000000080004370 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004370:	7179                	addi	sp,sp,-48
    80004372:	f406                	sd	ra,40(sp)
    80004374:	f022                	sd	s0,32(sp)
    80004376:	ec26                	sd	s1,24(sp)
    80004378:	e84a                	sd	s2,16(sp)
    8000437a:	1800                	addi	s0,sp,48
    8000437c:	892e                	mv	s2,a1
    8000437e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004380:	fdc40593          	addi	a1,s0,-36
    80004384:	ffffe097          	auipc	ra,0xffffe
    80004388:	be8080e7          	jalr	-1048(ra) # 80001f6c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000438c:	fdc42703          	lw	a4,-36(s0)
    80004390:	47bd                	li	a5,15
    80004392:	02e7eb63          	bltu	a5,a4,800043c8 <argfd+0x58>
    80004396:	ffffd097          	auipc	ra,0xffffd
    8000439a:	abc080e7          	jalr	-1348(ra) # 80000e52 <myproc>
    8000439e:	fdc42703          	lw	a4,-36(s0)
    800043a2:	01a70793          	addi	a5,a4,26
    800043a6:	078e                	slli	a5,a5,0x3
    800043a8:	953e                	add	a0,a0,a5
    800043aa:	611c                	ld	a5,0(a0)
    800043ac:	c385                	beqz	a5,800043cc <argfd+0x5c>
    return -1;
  if(pfd)
    800043ae:	00090463          	beqz	s2,800043b6 <argfd+0x46>
    *pfd = fd;
    800043b2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043b6:	4501                	li	a0,0
  if(pf)
    800043b8:	c091                	beqz	s1,800043bc <argfd+0x4c>
    *pf = f;
    800043ba:	e09c                	sd	a5,0(s1)
}
    800043bc:	70a2                	ld	ra,40(sp)
    800043be:	7402                	ld	s0,32(sp)
    800043c0:	64e2                	ld	s1,24(sp)
    800043c2:	6942                	ld	s2,16(sp)
    800043c4:	6145                	addi	sp,sp,48
    800043c6:	8082                	ret
    return -1;
    800043c8:	557d                	li	a0,-1
    800043ca:	bfcd                	j	800043bc <argfd+0x4c>
    800043cc:	557d                	li	a0,-1
    800043ce:	b7fd                	j	800043bc <argfd+0x4c>

00000000800043d0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800043d0:	1101                	addi	sp,sp,-32
    800043d2:	ec06                	sd	ra,24(sp)
    800043d4:	e822                	sd	s0,16(sp)
    800043d6:	e426                	sd	s1,8(sp)
    800043d8:	1000                	addi	s0,sp,32
    800043da:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800043dc:	ffffd097          	auipc	ra,0xffffd
    800043e0:	a76080e7          	jalr	-1418(ra) # 80000e52 <myproc>
    800043e4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800043e6:	0d050793          	addi	a5,a0,208
    800043ea:	4501                	li	a0,0
    800043ec:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800043ee:	6398                	ld	a4,0(a5)
    800043f0:	cb19                	beqz	a4,80004406 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800043f2:	2505                	addiw	a0,a0,1
    800043f4:	07a1                	addi	a5,a5,8
    800043f6:	fed51ce3          	bne	a0,a3,800043ee <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800043fa:	557d                	li	a0,-1
}
    800043fc:	60e2                	ld	ra,24(sp)
    800043fe:	6442                	ld	s0,16(sp)
    80004400:	64a2                	ld	s1,8(sp)
    80004402:	6105                	addi	sp,sp,32
    80004404:	8082                	ret
      p->ofile[fd] = f;
    80004406:	01a50793          	addi	a5,a0,26
    8000440a:	078e                	slli	a5,a5,0x3
    8000440c:	963e                	add	a2,a2,a5
    8000440e:	e204                	sd	s1,0(a2)
      return fd;
    80004410:	b7f5                	j	800043fc <fdalloc+0x2c>

0000000080004412 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004412:	715d                	addi	sp,sp,-80
    80004414:	e486                	sd	ra,72(sp)
    80004416:	e0a2                	sd	s0,64(sp)
    80004418:	fc26                	sd	s1,56(sp)
    8000441a:	f84a                	sd	s2,48(sp)
    8000441c:	f44e                	sd	s3,40(sp)
    8000441e:	f052                	sd	s4,32(sp)
    80004420:	ec56                	sd	s5,24(sp)
    80004422:	e85a                	sd	s6,16(sp)
    80004424:	0880                	addi	s0,sp,80
    80004426:	8b2e                	mv	s6,a1
    80004428:	89b2                	mv	s3,a2
    8000442a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000442c:	fb040593          	addi	a1,s0,-80
    80004430:	fffff097          	auipc	ra,0xfffff
    80004434:	e7e080e7          	jalr	-386(ra) # 800032ae <nameiparent>
    80004438:	84aa                	mv	s1,a0
    8000443a:	14050b63          	beqz	a0,80004590 <create+0x17e>
    return 0;

  ilock(dp);
    8000443e:	ffffe097          	auipc	ra,0xffffe
    80004442:	6ac080e7          	jalr	1708(ra) # 80002aea <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004446:	4601                	li	a2,0
    80004448:	fb040593          	addi	a1,s0,-80
    8000444c:	8526                	mv	a0,s1
    8000444e:	fffff097          	auipc	ra,0xfffff
    80004452:	b80080e7          	jalr	-1152(ra) # 80002fce <dirlookup>
    80004456:	8aaa                	mv	s5,a0
    80004458:	c921                	beqz	a0,800044a8 <create+0x96>
    iunlockput(dp);
    8000445a:	8526                	mv	a0,s1
    8000445c:	fffff097          	auipc	ra,0xfffff
    80004460:	8f0080e7          	jalr	-1808(ra) # 80002d4c <iunlockput>
    ilock(ip);
    80004464:	8556                	mv	a0,s5
    80004466:	ffffe097          	auipc	ra,0xffffe
    8000446a:	684080e7          	jalr	1668(ra) # 80002aea <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000446e:	4789                	li	a5,2
    80004470:	02fb1563          	bne	s6,a5,8000449a <create+0x88>
    80004474:	044ad783          	lhu	a5,68(s5)
    80004478:	37f9                	addiw	a5,a5,-2
    8000447a:	17c2                	slli	a5,a5,0x30
    8000447c:	93c1                	srli	a5,a5,0x30
    8000447e:	4705                	li	a4,1
    80004480:	00f76d63          	bltu	a4,a5,8000449a <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004484:	8556                	mv	a0,s5
    80004486:	60a6                	ld	ra,72(sp)
    80004488:	6406                	ld	s0,64(sp)
    8000448a:	74e2                	ld	s1,56(sp)
    8000448c:	7942                	ld	s2,48(sp)
    8000448e:	79a2                	ld	s3,40(sp)
    80004490:	7a02                	ld	s4,32(sp)
    80004492:	6ae2                	ld	s5,24(sp)
    80004494:	6b42                	ld	s6,16(sp)
    80004496:	6161                	addi	sp,sp,80
    80004498:	8082                	ret
    iunlockput(ip);
    8000449a:	8556                	mv	a0,s5
    8000449c:	fffff097          	auipc	ra,0xfffff
    800044a0:	8b0080e7          	jalr	-1872(ra) # 80002d4c <iunlockput>
    return 0;
    800044a4:	4a81                	li	s5,0
    800044a6:	bff9                	j	80004484 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800044a8:	85da                	mv	a1,s6
    800044aa:	4088                	lw	a0,0(s1)
    800044ac:	ffffe097          	auipc	ra,0xffffe
    800044b0:	4a6080e7          	jalr	1190(ra) # 80002952 <ialloc>
    800044b4:	8a2a                	mv	s4,a0
    800044b6:	c529                	beqz	a0,80004500 <create+0xee>
  ilock(ip);
    800044b8:	ffffe097          	auipc	ra,0xffffe
    800044bc:	632080e7          	jalr	1586(ra) # 80002aea <ilock>
  ip->major = major;
    800044c0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800044c4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800044c8:	4905                	li	s2,1
    800044ca:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800044ce:	8552                	mv	a0,s4
    800044d0:	ffffe097          	auipc	ra,0xffffe
    800044d4:	54e080e7          	jalr	1358(ra) # 80002a1e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800044d8:	032b0b63          	beq	s6,s2,8000450e <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800044dc:	004a2603          	lw	a2,4(s4)
    800044e0:	fb040593          	addi	a1,s0,-80
    800044e4:	8526                	mv	a0,s1
    800044e6:	fffff097          	auipc	ra,0xfffff
    800044ea:	cf8080e7          	jalr	-776(ra) # 800031de <dirlink>
    800044ee:	06054f63          	bltz	a0,8000456c <create+0x15a>
  iunlockput(dp);
    800044f2:	8526                	mv	a0,s1
    800044f4:	fffff097          	auipc	ra,0xfffff
    800044f8:	858080e7          	jalr	-1960(ra) # 80002d4c <iunlockput>
  return ip;
    800044fc:	8ad2                	mv	s5,s4
    800044fe:	b759                	j	80004484 <create+0x72>
    iunlockput(dp);
    80004500:	8526                	mv	a0,s1
    80004502:	fffff097          	auipc	ra,0xfffff
    80004506:	84a080e7          	jalr	-1974(ra) # 80002d4c <iunlockput>
    return 0;
    8000450a:	8ad2                	mv	s5,s4
    8000450c:	bfa5                	j	80004484 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000450e:	004a2603          	lw	a2,4(s4)
    80004512:	00004597          	auipc	a1,0x4
    80004516:	15e58593          	addi	a1,a1,350 # 80008670 <syscalls+0x2a0>
    8000451a:	8552                	mv	a0,s4
    8000451c:	fffff097          	auipc	ra,0xfffff
    80004520:	cc2080e7          	jalr	-830(ra) # 800031de <dirlink>
    80004524:	04054463          	bltz	a0,8000456c <create+0x15a>
    80004528:	40d0                	lw	a2,4(s1)
    8000452a:	00004597          	auipc	a1,0x4
    8000452e:	14e58593          	addi	a1,a1,334 # 80008678 <syscalls+0x2a8>
    80004532:	8552                	mv	a0,s4
    80004534:	fffff097          	auipc	ra,0xfffff
    80004538:	caa080e7          	jalr	-854(ra) # 800031de <dirlink>
    8000453c:	02054863          	bltz	a0,8000456c <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004540:	004a2603          	lw	a2,4(s4)
    80004544:	fb040593          	addi	a1,s0,-80
    80004548:	8526                	mv	a0,s1
    8000454a:	fffff097          	auipc	ra,0xfffff
    8000454e:	c94080e7          	jalr	-876(ra) # 800031de <dirlink>
    80004552:	00054d63          	bltz	a0,8000456c <create+0x15a>
    dp->nlink++;  // for ".."
    80004556:	04a4d783          	lhu	a5,74(s1)
    8000455a:	2785                	addiw	a5,a5,1
    8000455c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004560:	8526                	mv	a0,s1
    80004562:	ffffe097          	auipc	ra,0xffffe
    80004566:	4bc080e7          	jalr	1212(ra) # 80002a1e <iupdate>
    8000456a:	b761                	j	800044f2 <create+0xe0>
  ip->nlink = 0;
    8000456c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004570:	8552                	mv	a0,s4
    80004572:	ffffe097          	auipc	ra,0xffffe
    80004576:	4ac080e7          	jalr	1196(ra) # 80002a1e <iupdate>
  iunlockput(ip);
    8000457a:	8552                	mv	a0,s4
    8000457c:	ffffe097          	auipc	ra,0xffffe
    80004580:	7d0080e7          	jalr	2000(ra) # 80002d4c <iunlockput>
  iunlockput(dp);
    80004584:	8526                	mv	a0,s1
    80004586:	ffffe097          	auipc	ra,0xffffe
    8000458a:	7c6080e7          	jalr	1990(ra) # 80002d4c <iunlockput>
  return 0;
    8000458e:	bddd                	j	80004484 <create+0x72>
    return 0;
    80004590:	8aaa                	mv	s5,a0
    80004592:	bdcd                	j	80004484 <create+0x72>

0000000080004594 <sys_dup>:
{
    80004594:	7179                	addi	sp,sp,-48
    80004596:	f406                	sd	ra,40(sp)
    80004598:	f022                	sd	s0,32(sp)
    8000459a:	ec26                	sd	s1,24(sp)
    8000459c:	e84a                	sd	s2,16(sp)
    8000459e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045a0:	fd840613          	addi	a2,s0,-40
    800045a4:	4581                	li	a1,0
    800045a6:	4501                	li	a0,0
    800045a8:	00000097          	auipc	ra,0x0
    800045ac:	dc8080e7          	jalr	-568(ra) # 80004370 <argfd>
    return -1;
    800045b0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045b2:	02054363          	bltz	a0,800045d8 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800045b6:	fd843903          	ld	s2,-40(s0)
    800045ba:	854a                	mv	a0,s2
    800045bc:	00000097          	auipc	ra,0x0
    800045c0:	e14080e7          	jalr	-492(ra) # 800043d0 <fdalloc>
    800045c4:	84aa                	mv	s1,a0
    return -1;
    800045c6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800045c8:	00054863          	bltz	a0,800045d8 <sys_dup+0x44>
  filedup(f);
    800045cc:	854a                	mv	a0,s2
    800045ce:	fffff097          	auipc	ra,0xfffff
    800045d2:	334080e7          	jalr	820(ra) # 80003902 <filedup>
  return fd;
    800045d6:	87a6                	mv	a5,s1
}
    800045d8:	853e                	mv	a0,a5
    800045da:	70a2                	ld	ra,40(sp)
    800045dc:	7402                	ld	s0,32(sp)
    800045de:	64e2                	ld	s1,24(sp)
    800045e0:	6942                	ld	s2,16(sp)
    800045e2:	6145                	addi	sp,sp,48
    800045e4:	8082                	ret

00000000800045e6 <sys_read>:
{
    800045e6:	7179                	addi	sp,sp,-48
    800045e8:	f406                	sd	ra,40(sp)
    800045ea:	f022                	sd	s0,32(sp)
    800045ec:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800045ee:	fd840593          	addi	a1,s0,-40
    800045f2:	4505                	li	a0,1
    800045f4:	ffffe097          	auipc	ra,0xffffe
    800045f8:	998080e7          	jalr	-1640(ra) # 80001f8c <argaddr>
  argint(2, &n);
    800045fc:	fe440593          	addi	a1,s0,-28
    80004600:	4509                	li	a0,2
    80004602:	ffffe097          	auipc	ra,0xffffe
    80004606:	96a080e7          	jalr	-1686(ra) # 80001f6c <argint>
  if(argfd(0, 0, &f) < 0)
    8000460a:	fe840613          	addi	a2,s0,-24
    8000460e:	4581                	li	a1,0
    80004610:	4501                	li	a0,0
    80004612:	00000097          	auipc	ra,0x0
    80004616:	d5e080e7          	jalr	-674(ra) # 80004370 <argfd>
    8000461a:	87aa                	mv	a5,a0
    return -1;
    8000461c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000461e:	0007cc63          	bltz	a5,80004636 <sys_read+0x50>
  return fileread(f, p, n);
    80004622:	fe442603          	lw	a2,-28(s0)
    80004626:	fd843583          	ld	a1,-40(s0)
    8000462a:	fe843503          	ld	a0,-24(s0)
    8000462e:	fffff097          	auipc	ra,0xfffff
    80004632:	460080e7          	jalr	1120(ra) # 80003a8e <fileread>
}
    80004636:	70a2                	ld	ra,40(sp)
    80004638:	7402                	ld	s0,32(sp)
    8000463a:	6145                	addi	sp,sp,48
    8000463c:	8082                	ret

000000008000463e <sys_write>:
{
    8000463e:	7179                	addi	sp,sp,-48
    80004640:	f406                	sd	ra,40(sp)
    80004642:	f022                	sd	s0,32(sp)
    80004644:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004646:	fd840593          	addi	a1,s0,-40
    8000464a:	4505                	li	a0,1
    8000464c:	ffffe097          	auipc	ra,0xffffe
    80004650:	940080e7          	jalr	-1728(ra) # 80001f8c <argaddr>
  argint(2, &n);
    80004654:	fe440593          	addi	a1,s0,-28
    80004658:	4509                	li	a0,2
    8000465a:	ffffe097          	auipc	ra,0xffffe
    8000465e:	912080e7          	jalr	-1774(ra) # 80001f6c <argint>
  if(argfd(0, 0, &f) < 0)
    80004662:	fe840613          	addi	a2,s0,-24
    80004666:	4581                	li	a1,0
    80004668:	4501                	li	a0,0
    8000466a:	00000097          	auipc	ra,0x0
    8000466e:	d06080e7          	jalr	-762(ra) # 80004370 <argfd>
    80004672:	87aa                	mv	a5,a0
    return -1;
    80004674:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004676:	0007cc63          	bltz	a5,8000468e <sys_write+0x50>
  return filewrite(f, p, n);
    8000467a:	fe442603          	lw	a2,-28(s0)
    8000467e:	fd843583          	ld	a1,-40(s0)
    80004682:	fe843503          	ld	a0,-24(s0)
    80004686:	fffff097          	auipc	ra,0xfffff
    8000468a:	4ca080e7          	jalr	1226(ra) # 80003b50 <filewrite>
}
    8000468e:	70a2                	ld	ra,40(sp)
    80004690:	7402                	ld	s0,32(sp)
    80004692:	6145                	addi	sp,sp,48
    80004694:	8082                	ret

0000000080004696 <sys_close>:
{
    80004696:	1101                	addi	sp,sp,-32
    80004698:	ec06                	sd	ra,24(sp)
    8000469a:	e822                	sd	s0,16(sp)
    8000469c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000469e:	fe040613          	addi	a2,s0,-32
    800046a2:	fec40593          	addi	a1,s0,-20
    800046a6:	4501                	li	a0,0
    800046a8:	00000097          	auipc	ra,0x0
    800046ac:	cc8080e7          	jalr	-824(ra) # 80004370 <argfd>
    return -1;
    800046b0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046b2:	02054463          	bltz	a0,800046da <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046b6:	ffffc097          	auipc	ra,0xffffc
    800046ba:	79c080e7          	jalr	1948(ra) # 80000e52 <myproc>
    800046be:	fec42783          	lw	a5,-20(s0)
    800046c2:	07e9                	addi	a5,a5,26
    800046c4:	078e                	slli	a5,a5,0x3
    800046c6:	953e                	add	a0,a0,a5
    800046c8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800046cc:	fe043503          	ld	a0,-32(s0)
    800046d0:	fffff097          	auipc	ra,0xfffff
    800046d4:	284080e7          	jalr	644(ra) # 80003954 <fileclose>
  return 0;
    800046d8:	4781                	li	a5,0
}
    800046da:	853e                	mv	a0,a5
    800046dc:	60e2                	ld	ra,24(sp)
    800046de:	6442                	ld	s0,16(sp)
    800046e0:	6105                	addi	sp,sp,32
    800046e2:	8082                	ret

00000000800046e4 <sys_fstat>:
{
    800046e4:	1101                	addi	sp,sp,-32
    800046e6:	ec06                	sd	ra,24(sp)
    800046e8:	e822                	sd	s0,16(sp)
    800046ea:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800046ec:	fe040593          	addi	a1,s0,-32
    800046f0:	4505                	li	a0,1
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	89a080e7          	jalr	-1894(ra) # 80001f8c <argaddr>
  if(argfd(0, 0, &f) < 0)
    800046fa:	fe840613          	addi	a2,s0,-24
    800046fe:	4581                	li	a1,0
    80004700:	4501                	li	a0,0
    80004702:	00000097          	auipc	ra,0x0
    80004706:	c6e080e7          	jalr	-914(ra) # 80004370 <argfd>
    8000470a:	87aa                	mv	a5,a0
    return -1;
    8000470c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000470e:	0007ca63          	bltz	a5,80004722 <sys_fstat+0x3e>
  return filestat(f, st);
    80004712:	fe043583          	ld	a1,-32(s0)
    80004716:	fe843503          	ld	a0,-24(s0)
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	302080e7          	jalr	770(ra) # 80003a1c <filestat>
}
    80004722:	60e2                	ld	ra,24(sp)
    80004724:	6442                	ld	s0,16(sp)
    80004726:	6105                	addi	sp,sp,32
    80004728:	8082                	ret

000000008000472a <sys_link>:
{
    8000472a:	7169                	addi	sp,sp,-304
    8000472c:	f606                	sd	ra,296(sp)
    8000472e:	f222                	sd	s0,288(sp)
    80004730:	ee26                	sd	s1,280(sp)
    80004732:	ea4a                	sd	s2,272(sp)
    80004734:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004736:	08000613          	li	a2,128
    8000473a:	ed040593          	addi	a1,s0,-304
    8000473e:	4501                	li	a0,0
    80004740:	ffffe097          	auipc	ra,0xffffe
    80004744:	86c080e7          	jalr	-1940(ra) # 80001fac <argstr>
    return -1;
    80004748:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000474a:	10054e63          	bltz	a0,80004866 <sys_link+0x13c>
    8000474e:	08000613          	li	a2,128
    80004752:	f5040593          	addi	a1,s0,-176
    80004756:	4505                	li	a0,1
    80004758:	ffffe097          	auipc	ra,0xffffe
    8000475c:	854080e7          	jalr	-1964(ra) # 80001fac <argstr>
    return -1;
    80004760:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004762:	10054263          	bltz	a0,80004866 <sys_link+0x13c>
  begin_op();
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	d2a080e7          	jalr	-726(ra) # 80003490 <begin_op>
  if((ip = namei(old)) == 0){
    8000476e:	ed040513          	addi	a0,s0,-304
    80004772:	fffff097          	auipc	ra,0xfffff
    80004776:	b1e080e7          	jalr	-1250(ra) # 80003290 <namei>
    8000477a:	84aa                	mv	s1,a0
    8000477c:	c551                	beqz	a0,80004808 <sys_link+0xde>
  ilock(ip);
    8000477e:	ffffe097          	auipc	ra,0xffffe
    80004782:	36c080e7          	jalr	876(ra) # 80002aea <ilock>
  if(ip->type == T_DIR){
    80004786:	04449703          	lh	a4,68(s1)
    8000478a:	4785                	li	a5,1
    8000478c:	08f70463          	beq	a4,a5,80004814 <sys_link+0xea>
  ip->nlink++;
    80004790:	04a4d783          	lhu	a5,74(s1)
    80004794:	2785                	addiw	a5,a5,1
    80004796:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000479a:	8526                	mv	a0,s1
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	282080e7          	jalr	642(ra) # 80002a1e <iupdate>
  iunlock(ip);
    800047a4:	8526                	mv	a0,s1
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	406080e7          	jalr	1030(ra) # 80002bac <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047ae:	fd040593          	addi	a1,s0,-48
    800047b2:	f5040513          	addi	a0,s0,-176
    800047b6:	fffff097          	auipc	ra,0xfffff
    800047ba:	af8080e7          	jalr	-1288(ra) # 800032ae <nameiparent>
    800047be:	892a                	mv	s2,a0
    800047c0:	c935                	beqz	a0,80004834 <sys_link+0x10a>
  ilock(dp);
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	328080e7          	jalr	808(ra) # 80002aea <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800047ca:	00092703          	lw	a4,0(s2)
    800047ce:	409c                	lw	a5,0(s1)
    800047d0:	04f71d63          	bne	a4,a5,8000482a <sys_link+0x100>
    800047d4:	40d0                	lw	a2,4(s1)
    800047d6:	fd040593          	addi	a1,s0,-48
    800047da:	854a                	mv	a0,s2
    800047dc:	fffff097          	auipc	ra,0xfffff
    800047e0:	a02080e7          	jalr	-1534(ra) # 800031de <dirlink>
    800047e4:	04054363          	bltz	a0,8000482a <sys_link+0x100>
  iunlockput(dp);
    800047e8:	854a                	mv	a0,s2
    800047ea:	ffffe097          	auipc	ra,0xffffe
    800047ee:	562080e7          	jalr	1378(ra) # 80002d4c <iunlockput>
  iput(ip);
    800047f2:	8526                	mv	a0,s1
    800047f4:	ffffe097          	auipc	ra,0xffffe
    800047f8:	4b0080e7          	jalr	1200(ra) # 80002ca4 <iput>
  end_op();
    800047fc:	fffff097          	auipc	ra,0xfffff
    80004800:	d0e080e7          	jalr	-754(ra) # 8000350a <end_op>
  return 0;
    80004804:	4781                	li	a5,0
    80004806:	a085                	j	80004866 <sys_link+0x13c>
    end_op();
    80004808:	fffff097          	auipc	ra,0xfffff
    8000480c:	d02080e7          	jalr	-766(ra) # 8000350a <end_op>
    return -1;
    80004810:	57fd                	li	a5,-1
    80004812:	a891                	j	80004866 <sys_link+0x13c>
    iunlockput(ip);
    80004814:	8526                	mv	a0,s1
    80004816:	ffffe097          	auipc	ra,0xffffe
    8000481a:	536080e7          	jalr	1334(ra) # 80002d4c <iunlockput>
    end_op();
    8000481e:	fffff097          	auipc	ra,0xfffff
    80004822:	cec080e7          	jalr	-788(ra) # 8000350a <end_op>
    return -1;
    80004826:	57fd                	li	a5,-1
    80004828:	a83d                	j	80004866 <sys_link+0x13c>
    iunlockput(dp);
    8000482a:	854a                	mv	a0,s2
    8000482c:	ffffe097          	auipc	ra,0xffffe
    80004830:	520080e7          	jalr	1312(ra) # 80002d4c <iunlockput>
  ilock(ip);
    80004834:	8526                	mv	a0,s1
    80004836:	ffffe097          	auipc	ra,0xffffe
    8000483a:	2b4080e7          	jalr	692(ra) # 80002aea <ilock>
  ip->nlink--;
    8000483e:	04a4d783          	lhu	a5,74(s1)
    80004842:	37fd                	addiw	a5,a5,-1
    80004844:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004848:	8526                	mv	a0,s1
    8000484a:	ffffe097          	auipc	ra,0xffffe
    8000484e:	1d4080e7          	jalr	468(ra) # 80002a1e <iupdate>
  iunlockput(ip);
    80004852:	8526                	mv	a0,s1
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	4f8080e7          	jalr	1272(ra) # 80002d4c <iunlockput>
  end_op();
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	cae080e7          	jalr	-850(ra) # 8000350a <end_op>
  return -1;
    80004864:	57fd                	li	a5,-1
}
    80004866:	853e                	mv	a0,a5
    80004868:	70b2                	ld	ra,296(sp)
    8000486a:	7412                	ld	s0,288(sp)
    8000486c:	64f2                	ld	s1,280(sp)
    8000486e:	6952                	ld	s2,272(sp)
    80004870:	6155                	addi	sp,sp,304
    80004872:	8082                	ret

0000000080004874 <sys_unlink>:
{
    80004874:	7151                	addi	sp,sp,-240
    80004876:	f586                	sd	ra,232(sp)
    80004878:	f1a2                	sd	s0,224(sp)
    8000487a:	eda6                	sd	s1,216(sp)
    8000487c:	e9ca                	sd	s2,208(sp)
    8000487e:	e5ce                	sd	s3,200(sp)
    80004880:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004882:	08000613          	li	a2,128
    80004886:	f3040593          	addi	a1,s0,-208
    8000488a:	4501                	li	a0,0
    8000488c:	ffffd097          	auipc	ra,0xffffd
    80004890:	720080e7          	jalr	1824(ra) # 80001fac <argstr>
    80004894:	18054163          	bltz	a0,80004a16 <sys_unlink+0x1a2>
  begin_op();
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	bf8080e7          	jalr	-1032(ra) # 80003490 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048a0:	fb040593          	addi	a1,s0,-80
    800048a4:	f3040513          	addi	a0,s0,-208
    800048a8:	fffff097          	auipc	ra,0xfffff
    800048ac:	a06080e7          	jalr	-1530(ra) # 800032ae <nameiparent>
    800048b0:	84aa                	mv	s1,a0
    800048b2:	c979                	beqz	a0,80004988 <sys_unlink+0x114>
  ilock(dp);
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	236080e7          	jalr	566(ra) # 80002aea <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048bc:	00004597          	auipc	a1,0x4
    800048c0:	db458593          	addi	a1,a1,-588 # 80008670 <syscalls+0x2a0>
    800048c4:	fb040513          	addi	a0,s0,-80
    800048c8:	ffffe097          	auipc	ra,0xffffe
    800048cc:	6ec080e7          	jalr	1772(ra) # 80002fb4 <namecmp>
    800048d0:	14050a63          	beqz	a0,80004a24 <sys_unlink+0x1b0>
    800048d4:	00004597          	auipc	a1,0x4
    800048d8:	da458593          	addi	a1,a1,-604 # 80008678 <syscalls+0x2a8>
    800048dc:	fb040513          	addi	a0,s0,-80
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	6d4080e7          	jalr	1748(ra) # 80002fb4 <namecmp>
    800048e8:	12050e63          	beqz	a0,80004a24 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800048ec:	f2c40613          	addi	a2,s0,-212
    800048f0:	fb040593          	addi	a1,s0,-80
    800048f4:	8526                	mv	a0,s1
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	6d8080e7          	jalr	1752(ra) # 80002fce <dirlookup>
    800048fe:	892a                	mv	s2,a0
    80004900:	12050263          	beqz	a0,80004a24 <sys_unlink+0x1b0>
  ilock(ip);
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	1e6080e7          	jalr	486(ra) # 80002aea <ilock>
  if(ip->nlink < 1)
    8000490c:	04a91783          	lh	a5,74(s2)
    80004910:	08f05263          	blez	a5,80004994 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004914:	04491703          	lh	a4,68(s2)
    80004918:	4785                	li	a5,1
    8000491a:	08f70563          	beq	a4,a5,800049a4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000491e:	4641                	li	a2,16
    80004920:	4581                	li	a1,0
    80004922:	fc040513          	addi	a0,s0,-64
    80004926:	ffffc097          	auipc	ra,0xffffc
    8000492a:	854080e7          	jalr	-1964(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000492e:	4741                	li	a4,16
    80004930:	f2c42683          	lw	a3,-212(s0)
    80004934:	fc040613          	addi	a2,s0,-64
    80004938:	4581                	li	a1,0
    8000493a:	8526                	mv	a0,s1
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	55a080e7          	jalr	1370(ra) # 80002e96 <writei>
    80004944:	47c1                	li	a5,16
    80004946:	0af51563          	bne	a0,a5,800049f0 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000494a:	04491703          	lh	a4,68(s2)
    8000494e:	4785                	li	a5,1
    80004950:	0af70863          	beq	a4,a5,80004a00 <sys_unlink+0x18c>
  iunlockput(dp);
    80004954:	8526                	mv	a0,s1
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	3f6080e7          	jalr	1014(ra) # 80002d4c <iunlockput>
  ip->nlink--;
    8000495e:	04a95783          	lhu	a5,74(s2)
    80004962:	37fd                	addiw	a5,a5,-1
    80004964:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004968:	854a                	mv	a0,s2
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	0b4080e7          	jalr	180(ra) # 80002a1e <iupdate>
  iunlockput(ip);
    80004972:	854a                	mv	a0,s2
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	3d8080e7          	jalr	984(ra) # 80002d4c <iunlockput>
  end_op();
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	b8e080e7          	jalr	-1138(ra) # 8000350a <end_op>
  return 0;
    80004984:	4501                	li	a0,0
    80004986:	a84d                	j	80004a38 <sys_unlink+0x1c4>
    end_op();
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	b82080e7          	jalr	-1150(ra) # 8000350a <end_op>
    return -1;
    80004990:	557d                	li	a0,-1
    80004992:	a05d                	j	80004a38 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004994:	00004517          	auipc	a0,0x4
    80004998:	cec50513          	addi	a0,a0,-788 # 80008680 <syscalls+0x2b0>
    8000499c:	00001097          	auipc	ra,0x1
    800049a0:	1aa080e7          	jalr	426(ra) # 80005b46 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049a4:	04c92703          	lw	a4,76(s2)
    800049a8:	02000793          	li	a5,32
    800049ac:	f6e7f9e3          	bgeu	a5,a4,8000491e <sys_unlink+0xaa>
    800049b0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049b4:	4741                	li	a4,16
    800049b6:	86ce                	mv	a3,s3
    800049b8:	f1840613          	addi	a2,s0,-232
    800049bc:	4581                	li	a1,0
    800049be:	854a                	mv	a0,s2
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	3de080e7          	jalr	990(ra) # 80002d9e <readi>
    800049c8:	47c1                	li	a5,16
    800049ca:	00f51b63          	bne	a0,a5,800049e0 <sys_unlink+0x16c>
    if(de.inum != 0)
    800049ce:	f1845783          	lhu	a5,-232(s0)
    800049d2:	e7a1                	bnez	a5,80004a1a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049d4:	29c1                	addiw	s3,s3,16
    800049d6:	04c92783          	lw	a5,76(s2)
    800049da:	fcf9ede3          	bltu	s3,a5,800049b4 <sys_unlink+0x140>
    800049de:	b781                	j	8000491e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800049e0:	00004517          	auipc	a0,0x4
    800049e4:	cb850513          	addi	a0,a0,-840 # 80008698 <syscalls+0x2c8>
    800049e8:	00001097          	auipc	ra,0x1
    800049ec:	15e080e7          	jalr	350(ra) # 80005b46 <panic>
    panic("unlink: writei");
    800049f0:	00004517          	auipc	a0,0x4
    800049f4:	cc050513          	addi	a0,a0,-832 # 800086b0 <syscalls+0x2e0>
    800049f8:	00001097          	auipc	ra,0x1
    800049fc:	14e080e7          	jalr	334(ra) # 80005b46 <panic>
    dp->nlink--;
    80004a00:	04a4d783          	lhu	a5,74(s1)
    80004a04:	37fd                	addiw	a5,a5,-1
    80004a06:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a0a:	8526                	mv	a0,s1
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	012080e7          	jalr	18(ra) # 80002a1e <iupdate>
    80004a14:	b781                	j	80004954 <sys_unlink+0xe0>
    return -1;
    80004a16:	557d                	li	a0,-1
    80004a18:	a005                	j	80004a38 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a1a:	854a                	mv	a0,s2
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	330080e7          	jalr	816(ra) # 80002d4c <iunlockput>
  iunlockput(dp);
    80004a24:	8526                	mv	a0,s1
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	326080e7          	jalr	806(ra) # 80002d4c <iunlockput>
  end_op();
    80004a2e:	fffff097          	auipc	ra,0xfffff
    80004a32:	adc080e7          	jalr	-1316(ra) # 8000350a <end_op>
  return -1;
    80004a36:	557d                	li	a0,-1
}
    80004a38:	70ae                	ld	ra,232(sp)
    80004a3a:	740e                	ld	s0,224(sp)
    80004a3c:	64ee                	ld	s1,216(sp)
    80004a3e:	694e                	ld	s2,208(sp)
    80004a40:	69ae                	ld	s3,200(sp)
    80004a42:	616d                	addi	sp,sp,240
    80004a44:	8082                	ret

0000000080004a46 <sys_open>:

uint64
sys_open(void)
{
    80004a46:	7131                	addi	sp,sp,-192
    80004a48:	fd06                	sd	ra,184(sp)
    80004a4a:	f922                	sd	s0,176(sp)
    80004a4c:	f526                	sd	s1,168(sp)
    80004a4e:	f14a                	sd	s2,160(sp)
    80004a50:	ed4e                	sd	s3,152(sp)
    80004a52:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004a54:	f4c40593          	addi	a1,s0,-180
    80004a58:	4505                	li	a0,1
    80004a5a:	ffffd097          	auipc	ra,0xffffd
    80004a5e:	512080e7          	jalr	1298(ra) # 80001f6c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a62:	08000613          	li	a2,128
    80004a66:	f5040593          	addi	a1,s0,-176
    80004a6a:	4501                	li	a0,0
    80004a6c:	ffffd097          	auipc	ra,0xffffd
    80004a70:	540080e7          	jalr	1344(ra) # 80001fac <argstr>
    80004a74:	87aa                	mv	a5,a0
    return -1;
    80004a76:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a78:	0a07c863          	bltz	a5,80004b28 <sys_open+0xe2>

  begin_op();
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	a14080e7          	jalr	-1516(ra) # 80003490 <begin_op>

  if(omode & O_CREATE){
    80004a84:	f4c42783          	lw	a5,-180(s0)
    80004a88:	2007f793          	andi	a5,a5,512
    80004a8c:	cbdd                	beqz	a5,80004b42 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004a8e:	4681                	li	a3,0
    80004a90:	4601                	li	a2,0
    80004a92:	4589                	li	a1,2
    80004a94:	f5040513          	addi	a0,s0,-176
    80004a98:	00000097          	auipc	ra,0x0
    80004a9c:	97a080e7          	jalr	-1670(ra) # 80004412 <create>
    80004aa0:	84aa                	mv	s1,a0
    if(ip == 0){
    80004aa2:	c951                	beqz	a0,80004b36 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004aa4:	04449703          	lh	a4,68(s1)
    80004aa8:	478d                	li	a5,3
    80004aaa:	00f71763          	bne	a4,a5,80004ab8 <sys_open+0x72>
    80004aae:	0464d703          	lhu	a4,70(s1)
    80004ab2:	47a5                	li	a5,9
    80004ab4:	0ce7ec63          	bltu	a5,a4,80004b8c <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	de0080e7          	jalr	-544(ra) # 80003898 <filealloc>
    80004ac0:	892a                	mv	s2,a0
    80004ac2:	c56d                	beqz	a0,80004bac <sys_open+0x166>
    80004ac4:	00000097          	auipc	ra,0x0
    80004ac8:	90c080e7          	jalr	-1780(ra) # 800043d0 <fdalloc>
    80004acc:	89aa                	mv	s3,a0
    80004ace:	0c054a63          	bltz	a0,80004ba2 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ad2:	04449703          	lh	a4,68(s1)
    80004ad6:	478d                	li	a5,3
    80004ad8:	0ef70563          	beq	a4,a5,80004bc2 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004adc:	4789                	li	a5,2
    80004ade:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004ae2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004ae6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004aea:	f4c42783          	lw	a5,-180(s0)
    80004aee:	0017c713          	xori	a4,a5,1
    80004af2:	8b05                	andi	a4,a4,1
    80004af4:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004af8:	0037f713          	andi	a4,a5,3
    80004afc:	00e03733          	snez	a4,a4
    80004b00:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b04:	4007f793          	andi	a5,a5,1024
    80004b08:	c791                	beqz	a5,80004b14 <sys_open+0xce>
    80004b0a:	04449703          	lh	a4,68(s1)
    80004b0e:	4789                	li	a5,2
    80004b10:	0cf70063          	beq	a4,a5,80004bd0 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004b14:	8526                	mv	a0,s1
    80004b16:	ffffe097          	auipc	ra,0xffffe
    80004b1a:	096080e7          	jalr	150(ra) # 80002bac <iunlock>
  end_op();
    80004b1e:	fffff097          	auipc	ra,0xfffff
    80004b22:	9ec080e7          	jalr	-1556(ra) # 8000350a <end_op>

  return fd;
    80004b26:	854e                	mv	a0,s3
}
    80004b28:	70ea                	ld	ra,184(sp)
    80004b2a:	744a                	ld	s0,176(sp)
    80004b2c:	74aa                	ld	s1,168(sp)
    80004b2e:	790a                	ld	s2,160(sp)
    80004b30:	69ea                	ld	s3,152(sp)
    80004b32:	6129                	addi	sp,sp,192
    80004b34:	8082                	ret
      end_op();
    80004b36:	fffff097          	auipc	ra,0xfffff
    80004b3a:	9d4080e7          	jalr	-1580(ra) # 8000350a <end_op>
      return -1;
    80004b3e:	557d                	li	a0,-1
    80004b40:	b7e5                	j	80004b28 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004b42:	f5040513          	addi	a0,s0,-176
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	74a080e7          	jalr	1866(ra) # 80003290 <namei>
    80004b4e:	84aa                	mv	s1,a0
    80004b50:	c905                	beqz	a0,80004b80 <sys_open+0x13a>
    ilock(ip);
    80004b52:	ffffe097          	auipc	ra,0xffffe
    80004b56:	f98080e7          	jalr	-104(ra) # 80002aea <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b5a:	04449703          	lh	a4,68(s1)
    80004b5e:	4785                	li	a5,1
    80004b60:	f4f712e3          	bne	a4,a5,80004aa4 <sys_open+0x5e>
    80004b64:	f4c42783          	lw	a5,-180(s0)
    80004b68:	dba1                	beqz	a5,80004ab8 <sys_open+0x72>
      iunlockput(ip);
    80004b6a:	8526                	mv	a0,s1
    80004b6c:	ffffe097          	auipc	ra,0xffffe
    80004b70:	1e0080e7          	jalr	480(ra) # 80002d4c <iunlockput>
      end_op();
    80004b74:	fffff097          	auipc	ra,0xfffff
    80004b78:	996080e7          	jalr	-1642(ra) # 8000350a <end_op>
      return -1;
    80004b7c:	557d                	li	a0,-1
    80004b7e:	b76d                	j	80004b28 <sys_open+0xe2>
      end_op();
    80004b80:	fffff097          	auipc	ra,0xfffff
    80004b84:	98a080e7          	jalr	-1654(ra) # 8000350a <end_op>
      return -1;
    80004b88:	557d                	li	a0,-1
    80004b8a:	bf79                	j	80004b28 <sys_open+0xe2>
    iunlockput(ip);
    80004b8c:	8526                	mv	a0,s1
    80004b8e:	ffffe097          	auipc	ra,0xffffe
    80004b92:	1be080e7          	jalr	446(ra) # 80002d4c <iunlockput>
    end_op();
    80004b96:	fffff097          	auipc	ra,0xfffff
    80004b9a:	974080e7          	jalr	-1676(ra) # 8000350a <end_op>
    return -1;
    80004b9e:	557d                	li	a0,-1
    80004ba0:	b761                	j	80004b28 <sys_open+0xe2>
      fileclose(f);
    80004ba2:	854a                	mv	a0,s2
    80004ba4:	fffff097          	auipc	ra,0xfffff
    80004ba8:	db0080e7          	jalr	-592(ra) # 80003954 <fileclose>
    iunlockput(ip);
    80004bac:	8526                	mv	a0,s1
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	19e080e7          	jalr	414(ra) # 80002d4c <iunlockput>
    end_op();
    80004bb6:	fffff097          	auipc	ra,0xfffff
    80004bba:	954080e7          	jalr	-1708(ra) # 8000350a <end_op>
    return -1;
    80004bbe:	557d                	li	a0,-1
    80004bc0:	b7a5                	j	80004b28 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004bc2:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004bc6:	04649783          	lh	a5,70(s1)
    80004bca:	02f91223          	sh	a5,36(s2)
    80004bce:	bf21                	j	80004ae6 <sys_open+0xa0>
    itrunc(ip);
    80004bd0:	8526                	mv	a0,s1
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	026080e7          	jalr	38(ra) # 80002bf8 <itrunc>
    80004bda:	bf2d                	j	80004b14 <sys_open+0xce>

0000000080004bdc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004bdc:	7175                	addi	sp,sp,-144
    80004bde:	e506                	sd	ra,136(sp)
    80004be0:	e122                	sd	s0,128(sp)
    80004be2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004be4:	fffff097          	auipc	ra,0xfffff
    80004be8:	8ac080e7          	jalr	-1876(ra) # 80003490 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004bec:	08000613          	li	a2,128
    80004bf0:	f7040593          	addi	a1,s0,-144
    80004bf4:	4501                	li	a0,0
    80004bf6:	ffffd097          	auipc	ra,0xffffd
    80004bfa:	3b6080e7          	jalr	950(ra) # 80001fac <argstr>
    80004bfe:	02054963          	bltz	a0,80004c30 <sys_mkdir+0x54>
    80004c02:	4681                	li	a3,0
    80004c04:	4601                	li	a2,0
    80004c06:	4585                	li	a1,1
    80004c08:	f7040513          	addi	a0,s0,-144
    80004c0c:	00000097          	auipc	ra,0x0
    80004c10:	806080e7          	jalr	-2042(ra) # 80004412 <create>
    80004c14:	cd11                	beqz	a0,80004c30 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c16:	ffffe097          	auipc	ra,0xffffe
    80004c1a:	136080e7          	jalr	310(ra) # 80002d4c <iunlockput>
  end_op();
    80004c1e:	fffff097          	auipc	ra,0xfffff
    80004c22:	8ec080e7          	jalr	-1812(ra) # 8000350a <end_op>
  return 0;
    80004c26:	4501                	li	a0,0
}
    80004c28:	60aa                	ld	ra,136(sp)
    80004c2a:	640a                	ld	s0,128(sp)
    80004c2c:	6149                	addi	sp,sp,144
    80004c2e:	8082                	ret
    end_op();
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	8da080e7          	jalr	-1830(ra) # 8000350a <end_op>
    return -1;
    80004c38:	557d                	li	a0,-1
    80004c3a:	b7fd                	j	80004c28 <sys_mkdir+0x4c>

0000000080004c3c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c3c:	7135                	addi	sp,sp,-160
    80004c3e:	ed06                	sd	ra,152(sp)
    80004c40:	e922                	sd	s0,144(sp)
    80004c42:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c44:	fffff097          	auipc	ra,0xfffff
    80004c48:	84c080e7          	jalr	-1972(ra) # 80003490 <begin_op>
  argint(1, &major);
    80004c4c:	f6c40593          	addi	a1,s0,-148
    80004c50:	4505                	li	a0,1
    80004c52:	ffffd097          	auipc	ra,0xffffd
    80004c56:	31a080e7          	jalr	794(ra) # 80001f6c <argint>
  argint(2, &minor);
    80004c5a:	f6840593          	addi	a1,s0,-152
    80004c5e:	4509                	li	a0,2
    80004c60:	ffffd097          	auipc	ra,0xffffd
    80004c64:	30c080e7          	jalr	780(ra) # 80001f6c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c68:	08000613          	li	a2,128
    80004c6c:	f7040593          	addi	a1,s0,-144
    80004c70:	4501                	li	a0,0
    80004c72:	ffffd097          	auipc	ra,0xffffd
    80004c76:	33a080e7          	jalr	826(ra) # 80001fac <argstr>
    80004c7a:	02054b63          	bltz	a0,80004cb0 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004c7e:	f6841683          	lh	a3,-152(s0)
    80004c82:	f6c41603          	lh	a2,-148(s0)
    80004c86:	458d                	li	a1,3
    80004c88:	f7040513          	addi	a0,s0,-144
    80004c8c:	fffff097          	auipc	ra,0xfffff
    80004c90:	786080e7          	jalr	1926(ra) # 80004412 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c94:	cd11                	beqz	a0,80004cb0 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c96:	ffffe097          	auipc	ra,0xffffe
    80004c9a:	0b6080e7          	jalr	182(ra) # 80002d4c <iunlockput>
  end_op();
    80004c9e:	fffff097          	auipc	ra,0xfffff
    80004ca2:	86c080e7          	jalr	-1940(ra) # 8000350a <end_op>
  return 0;
    80004ca6:	4501                	li	a0,0
}
    80004ca8:	60ea                	ld	ra,152(sp)
    80004caa:	644a                	ld	s0,144(sp)
    80004cac:	610d                	addi	sp,sp,160
    80004cae:	8082                	ret
    end_op();
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	85a080e7          	jalr	-1958(ra) # 8000350a <end_op>
    return -1;
    80004cb8:	557d                	li	a0,-1
    80004cba:	b7fd                	j	80004ca8 <sys_mknod+0x6c>

0000000080004cbc <sys_chdir>:

uint64
sys_chdir(void)
{
    80004cbc:	7135                	addi	sp,sp,-160
    80004cbe:	ed06                	sd	ra,152(sp)
    80004cc0:	e922                	sd	s0,144(sp)
    80004cc2:	e526                	sd	s1,136(sp)
    80004cc4:	e14a                	sd	s2,128(sp)
    80004cc6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004cc8:	ffffc097          	auipc	ra,0xffffc
    80004ccc:	18a080e7          	jalr	394(ra) # 80000e52 <myproc>
    80004cd0:	892a                	mv	s2,a0
  
  begin_op();
    80004cd2:	ffffe097          	auipc	ra,0xffffe
    80004cd6:	7be080e7          	jalr	1982(ra) # 80003490 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004cda:	08000613          	li	a2,128
    80004cde:	f6040593          	addi	a1,s0,-160
    80004ce2:	4501                	li	a0,0
    80004ce4:	ffffd097          	auipc	ra,0xffffd
    80004ce8:	2c8080e7          	jalr	712(ra) # 80001fac <argstr>
    80004cec:	04054b63          	bltz	a0,80004d42 <sys_chdir+0x86>
    80004cf0:	f6040513          	addi	a0,s0,-160
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	59c080e7          	jalr	1436(ra) # 80003290 <namei>
    80004cfc:	84aa                	mv	s1,a0
    80004cfe:	c131                	beqz	a0,80004d42 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d00:	ffffe097          	auipc	ra,0xffffe
    80004d04:	dea080e7          	jalr	-534(ra) # 80002aea <ilock>
  if(ip->type != T_DIR){
    80004d08:	04449703          	lh	a4,68(s1)
    80004d0c:	4785                	li	a5,1
    80004d0e:	04f71063          	bne	a4,a5,80004d4e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d12:	8526                	mv	a0,s1
    80004d14:	ffffe097          	auipc	ra,0xffffe
    80004d18:	e98080e7          	jalr	-360(ra) # 80002bac <iunlock>
  iput(p->cwd);
    80004d1c:	15093503          	ld	a0,336(s2)
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	f84080e7          	jalr	-124(ra) # 80002ca4 <iput>
  end_op();
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	7e2080e7          	jalr	2018(ra) # 8000350a <end_op>
  p->cwd = ip;
    80004d30:	14993823          	sd	s1,336(s2)
  return 0;
    80004d34:	4501                	li	a0,0
}
    80004d36:	60ea                	ld	ra,152(sp)
    80004d38:	644a                	ld	s0,144(sp)
    80004d3a:	64aa                	ld	s1,136(sp)
    80004d3c:	690a                	ld	s2,128(sp)
    80004d3e:	610d                	addi	sp,sp,160
    80004d40:	8082                	ret
    end_op();
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	7c8080e7          	jalr	1992(ra) # 8000350a <end_op>
    return -1;
    80004d4a:	557d                	li	a0,-1
    80004d4c:	b7ed                	j	80004d36 <sys_chdir+0x7a>
    iunlockput(ip);
    80004d4e:	8526                	mv	a0,s1
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	ffc080e7          	jalr	-4(ra) # 80002d4c <iunlockput>
    end_op();
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	7b2080e7          	jalr	1970(ra) # 8000350a <end_op>
    return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	bfd1                	j	80004d36 <sys_chdir+0x7a>

0000000080004d64 <sys_exec>:

uint64
sys_exec(void)
{
    80004d64:	7121                	addi	sp,sp,-448
    80004d66:	ff06                	sd	ra,440(sp)
    80004d68:	fb22                	sd	s0,432(sp)
    80004d6a:	f726                	sd	s1,424(sp)
    80004d6c:	f34a                	sd	s2,416(sp)
    80004d6e:	ef4e                	sd	s3,408(sp)
    80004d70:	eb52                	sd	s4,400(sp)
    80004d72:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004d74:	e4840593          	addi	a1,s0,-440
    80004d78:	4505                	li	a0,1
    80004d7a:	ffffd097          	auipc	ra,0xffffd
    80004d7e:	212080e7          	jalr	530(ra) # 80001f8c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004d82:	08000613          	li	a2,128
    80004d86:	f5040593          	addi	a1,s0,-176
    80004d8a:	4501                	li	a0,0
    80004d8c:	ffffd097          	auipc	ra,0xffffd
    80004d90:	220080e7          	jalr	544(ra) # 80001fac <argstr>
    80004d94:	87aa                	mv	a5,a0
    return -1;
    80004d96:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004d98:	0c07c263          	bltz	a5,80004e5c <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004d9c:	10000613          	li	a2,256
    80004da0:	4581                	li	a1,0
    80004da2:	e5040513          	addi	a0,s0,-432
    80004da6:	ffffb097          	auipc	ra,0xffffb
    80004daa:	3d4080e7          	jalr	980(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004dae:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004db2:	89a6                	mv	s3,s1
    80004db4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004db6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004dba:	00391513          	slli	a0,s2,0x3
    80004dbe:	e4040593          	addi	a1,s0,-448
    80004dc2:	e4843783          	ld	a5,-440(s0)
    80004dc6:	953e                	add	a0,a0,a5
    80004dc8:	ffffd097          	auipc	ra,0xffffd
    80004dcc:	106080e7          	jalr	262(ra) # 80001ece <fetchaddr>
    80004dd0:	02054a63          	bltz	a0,80004e04 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004dd4:	e4043783          	ld	a5,-448(s0)
    80004dd8:	c3b9                	beqz	a5,80004e1e <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004dda:	ffffb097          	auipc	ra,0xffffb
    80004dde:	340080e7          	jalr	832(ra) # 8000011a <kalloc>
    80004de2:	85aa                	mv	a1,a0
    80004de4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004de8:	cd11                	beqz	a0,80004e04 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004dea:	6605                	lui	a2,0x1
    80004dec:	e4043503          	ld	a0,-448(s0)
    80004df0:	ffffd097          	auipc	ra,0xffffd
    80004df4:	130080e7          	jalr	304(ra) # 80001f20 <fetchstr>
    80004df8:	00054663          	bltz	a0,80004e04 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004dfc:	0905                	addi	s2,s2,1
    80004dfe:	09a1                	addi	s3,s3,8
    80004e00:	fb491de3          	bne	s2,s4,80004dba <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e04:	f5040913          	addi	s2,s0,-176
    80004e08:	6088                	ld	a0,0(s1)
    80004e0a:	c921                	beqz	a0,80004e5a <sys_exec+0xf6>
    kfree(argv[i]);
    80004e0c:	ffffb097          	auipc	ra,0xffffb
    80004e10:	210080e7          	jalr	528(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e14:	04a1                	addi	s1,s1,8
    80004e16:	ff2499e3          	bne	s1,s2,80004e08 <sys_exec+0xa4>
  return -1;
    80004e1a:	557d                	li	a0,-1
    80004e1c:	a081                	j	80004e5c <sys_exec+0xf8>
      argv[i] = 0;
    80004e1e:	0009079b          	sext.w	a5,s2
    80004e22:	078e                	slli	a5,a5,0x3
    80004e24:	fd078793          	addi	a5,a5,-48
    80004e28:	97a2                	add	a5,a5,s0
    80004e2a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004e2e:	e5040593          	addi	a1,s0,-432
    80004e32:	f5040513          	addi	a0,s0,-176
    80004e36:	fffff097          	auipc	ra,0xfffff
    80004e3a:	194080e7          	jalr	404(ra) # 80003fca <exec>
    80004e3e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e40:	f5040993          	addi	s3,s0,-176
    80004e44:	6088                	ld	a0,0(s1)
    80004e46:	c901                	beqz	a0,80004e56 <sys_exec+0xf2>
    kfree(argv[i]);
    80004e48:	ffffb097          	auipc	ra,0xffffb
    80004e4c:	1d4080e7          	jalr	468(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e50:	04a1                	addi	s1,s1,8
    80004e52:	ff3499e3          	bne	s1,s3,80004e44 <sys_exec+0xe0>
  return ret;
    80004e56:	854a                	mv	a0,s2
    80004e58:	a011                	j	80004e5c <sys_exec+0xf8>
  return -1;
    80004e5a:	557d                	li	a0,-1
}
    80004e5c:	70fa                	ld	ra,440(sp)
    80004e5e:	745a                	ld	s0,432(sp)
    80004e60:	74ba                	ld	s1,424(sp)
    80004e62:	791a                	ld	s2,416(sp)
    80004e64:	69fa                	ld	s3,408(sp)
    80004e66:	6a5a                	ld	s4,400(sp)
    80004e68:	6139                	addi	sp,sp,448
    80004e6a:	8082                	ret

0000000080004e6c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e6c:	7139                	addi	sp,sp,-64
    80004e6e:	fc06                	sd	ra,56(sp)
    80004e70:	f822                	sd	s0,48(sp)
    80004e72:	f426                	sd	s1,40(sp)
    80004e74:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004e76:	ffffc097          	auipc	ra,0xffffc
    80004e7a:	fdc080e7          	jalr	-36(ra) # 80000e52 <myproc>
    80004e7e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004e80:	fd840593          	addi	a1,s0,-40
    80004e84:	4501                	li	a0,0
    80004e86:	ffffd097          	auipc	ra,0xffffd
    80004e8a:	106080e7          	jalr	262(ra) # 80001f8c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004e8e:	fc840593          	addi	a1,s0,-56
    80004e92:	fd040513          	addi	a0,s0,-48
    80004e96:	fffff097          	auipc	ra,0xfffff
    80004e9a:	dea080e7          	jalr	-534(ra) # 80003c80 <pipealloc>
    return -1;
    80004e9e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004ea0:	0c054463          	bltz	a0,80004f68 <sys_pipe+0xfc>
  fd0 = -1;
    80004ea4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004ea8:	fd043503          	ld	a0,-48(s0)
    80004eac:	fffff097          	auipc	ra,0xfffff
    80004eb0:	524080e7          	jalr	1316(ra) # 800043d0 <fdalloc>
    80004eb4:	fca42223          	sw	a0,-60(s0)
    80004eb8:	08054b63          	bltz	a0,80004f4e <sys_pipe+0xe2>
    80004ebc:	fc843503          	ld	a0,-56(s0)
    80004ec0:	fffff097          	auipc	ra,0xfffff
    80004ec4:	510080e7          	jalr	1296(ra) # 800043d0 <fdalloc>
    80004ec8:	fca42023          	sw	a0,-64(s0)
    80004ecc:	06054863          	bltz	a0,80004f3c <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ed0:	4691                	li	a3,4
    80004ed2:	fc440613          	addi	a2,s0,-60
    80004ed6:	fd843583          	ld	a1,-40(s0)
    80004eda:	68a8                	ld	a0,80(s1)
    80004edc:	ffffc097          	auipc	ra,0xffffc
    80004ee0:	c36080e7          	jalr	-970(ra) # 80000b12 <copyout>
    80004ee4:	02054063          	bltz	a0,80004f04 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004ee8:	4691                	li	a3,4
    80004eea:	fc040613          	addi	a2,s0,-64
    80004eee:	fd843583          	ld	a1,-40(s0)
    80004ef2:	0591                	addi	a1,a1,4
    80004ef4:	68a8                	ld	a0,80(s1)
    80004ef6:	ffffc097          	auipc	ra,0xffffc
    80004efa:	c1c080e7          	jalr	-996(ra) # 80000b12 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004efe:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f00:	06055463          	bgez	a0,80004f68 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f04:	fc442783          	lw	a5,-60(s0)
    80004f08:	07e9                	addi	a5,a5,26
    80004f0a:	078e                	slli	a5,a5,0x3
    80004f0c:	97a6                	add	a5,a5,s1
    80004f0e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f12:	fc042783          	lw	a5,-64(s0)
    80004f16:	07e9                	addi	a5,a5,26
    80004f18:	078e                	slli	a5,a5,0x3
    80004f1a:	94be                	add	s1,s1,a5
    80004f1c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f20:	fd043503          	ld	a0,-48(s0)
    80004f24:	fffff097          	auipc	ra,0xfffff
    80004f28:	a30080e7          	jalr	-1488(ra) # 80003954 <fileclose>
    fileclose(wf);
    80004f2c:	fc843503          	ld	a0,-56(s0)
    80004f30:	fffff097          	auipc	ra,0xfffff
    80004f34:	a24080e7          	jalr	-1500(ra) # 80003954 <fileclose>
    return -1;
    80004f38:	57fd                	li	a5,-1
    80004f3a:	a03d                	j	80004f68 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004f3c:	fc442783          	lw	a5,-60(s0)
    80004f40:	0007c763          	bltz	a5,80004f4e <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004f44:	07e9                	addi	a5,a5,26
    80004f46:	078e                	slli	a5,a5,0x3
    80004f48:	97a6                	add	a5,a5,s1
    80004f4a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004f4e:	fd043503          	ld	a0,-48(s0)
    80004f52:	fffff097          	auipc	ra,0xfffff
    80004f56:	a02080e7          	jalr	-1534(ra) # 80003954 <fileclose>
    fileclose(wf);
    80004f5a:	fc843503          	ld	a0,-56(s0)
    80004f5e:	fffff097          	auipc	ra,0xfffff
    80004f62:	9f6080e7          	jalr	-1546(ra) # 80003954 <fileclose>
    return -1;
    80004f66:	57fd                	li	a5,-1
}
    80004f68:	853e                	mv	a0,a5
    80004f6a:	70e2                	ld	ra,56(sp)
    80004f6c:	7442                	ld	s0,48(sp)
    80004f6e:	74a2                	ld	s1,40(sp)
    80004f70:	6121                	addi	sp,sp,64
    80004f72:	8082                	ret
	...

0000000080004f80 <kernelvec>:
    80004f80:	7111                	addi	sp,sp,-256
    80004f82:	e006                	sd	ra,0(sp)
    80004f84:	e40a                	sd	sp,8(sp)
    80004f86:	e80e                	sd	gp,16(sp)
    80004f88:	ec12                	sd	tp,24(sp)
    80004f8a:	f016                	sd	t0,32(sp)
    80004f8c:	f41a                	sd	t1,40(sp)
    80004f8e:	f81e                	sd	t2,48(sp)
    80004f90:	fc22                	sd	s0,56(sp)
    80004f92:	e0a6                	sd	s1,64(sp)
    80004f94:	e4aa                	sd	a0,72(sp)
    80004f96:	e8ae                	sd	a1,80(sp)
    80004f98:	ecb2                	sd	a2,88(sp)
    80004f9a:	f0b6                	sd	a3,96(sp)
    80004f9c:	f4ba                	sd	a4,104(sp)
    80004f9e:	f8be                	sd	a5,112(sp)
    80004fa0:	fcc2                	sd	a6,120(sp)
    80004fa2:	e146                	sd	a7,128(sp)
    80004fa4:	e54a                	sd	s2,136(sp)
    80004fa6:	e94e                	sd	s3,144(sp)
    80004fa8:	ed52                	sd	s4,152(sp)
    80004faa:	f156                	sd	s5,160(sp)
    80004fac:	f55a                	sd	s6,168(sp)
    80004fae:	f95e                	sd	s7,176(sp)
    80004fb0:	fd62                	sd	s8,184(sp)
    80004fb2:	e1e6                	sd	s9,192(sp)
    80004fb4:	e5ea                	sd	s10,200(sp)
    80004fb6:	e9ee                	sd	s11,208(sp)
    80004fb8:	edf2                	sd	t3,216(sp)
    80004fba:	f1f6                	sd	t4,224(sp)
    80004fbc:	f5fa                	sd	t5,232(sp)
    80004fbe:	f9fe                	sd	t6,240(sp)
    80004fc0:	ddbfc0ef          	jal	ra,80001d9a <kerneltrap>
    80004fc4:	6082                	ld	ra,0(sp)
    80004fc6:	6122                	ld	sp,8(sp)
    80004fc8:	61c2                	ld	gp,16(sp)
    80004fca:	7282                	ld	t0,32(sp)
    80004fcc:	7322                	ld	t1,40(sp)
    80004fce:	73c2                	ld	t2,48(sp)
    80004fd0:	7462                	ld	s0,56(sp)
    80004fd2:	6486                	ld	s1,64(sp)
    80004fd4:	6526                	ld	a0,72(sp)
    80004fd6:	65c6                	ld	a1,80(sp)
    80004fd8:	6666                	ld	a2,88(sp)
    80004fda:	7686                	ld	a3,96(sp)
    80004fdc:	7726                	ld	a4,104(sp)
    80004fde:	77c6                	ld	a5,112(sp)
    80004fe0:	7866                	ld	a6,120(sp)
    80004fe2:	688a                	ld	a7,128(sp)
    80004fe4:	692a                	ld	s2,136(sp)
    80004fe6:	69ca                	ld	s3,144(sp)
    80004fe8:	6a6a                	ld	s4,152(sp)
    80004fea:	7a8a                	ld	s5,160(sp)
    80004fec:	7b2a                	ld	s6,168(sp)
    80004fee:	7bca                	ld	s7,176(sp)
    80004ff0:	7c6a                	ld	s8,184(sp)
    80004ff2:	6c8e                	ld	s9,192(sp)
    80004ff4:	6d2e                	ld	s10,200(sp)
    80004ff6:	6dce                	ld	s11,208(sp)
    80004ff8:	6e6e                	ld	t3,216(sp)
    80004ffa:	7e8e                	ld	t4,224(sp)
    80004ffc:	7f2e                	ld	t5,232(sp)
    80004ffe:	7fce                	ld	t6,240(sp)
    80005000:	6111                	addi	sp,sp,256
    80005002:	10200073          	sret
    80005006:	00000013          	nop
    8000500a:	00000013          	nop
    8000500e:	0001                	nop

0000000080005010 <timervec>:
    80005010:	34051573          	csrrw	a0,mscratch,a0
    80005014:	e10c                	sd	a1,0(a0)
    80005016:	e510                	sd	a2,8(a0)
    80005018:	e914                	sd	a3,16(a0)
    8000501a:	6d0c                	ld	a1,24(a0)
    8000501c:	7110                	ld	a2,32(a0)
    8000501e:	6194                	ld	a3,0(a1)
    80005020:	96b2                	add	a3,a3,a2
    80005022:	e194                	sd	a3,0(a1)
    80005024:	4589                	li	a1,2
    80005026:	14459073          	csrw	sip,a1
    8000502a:	6914                	ld	a3,16(a0)
    8000502c:	6510                	ld	a2,8(a0)
    8000502e:	610c                	ld	a1,0(a0)
    80005030:	34051573          	csrrw	a0,mscratch,a0
    80005034:	30200073          	mret
	...

000000008000503a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000503a:	1141                	addi	sp,sp,-16
    8000503c:	e422                	sd	s0,8(sp)
    8000503e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005040:	0c0007b7          	lui	a5,0xc000
    80005044:	4705                	li	a4,1
    80005046:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005048:	c3d8                	sw	a4,4(a5)
}
    8000504a:	6422                	ld	s0,8(sp)
    8000504c:	0141                	addi	sp,sp,16
    8000504e:	8082                	ret

0000000080005050 <plicinithart>:

void
plicinithart(void)
{
    80005050:	1141                	addi	sp,sp,-16
    80005052:	e406                	sd	ra,8(sp)
    80005054:	e022                	sd	s0,0(sp)
    80005056:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005058:	ffffc097          	auipc	ra,0xffffc
    8000505c:	dce080e7          	jalr	-562(ra) # 80000e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005060:	0085171b          	slliw	a4,a0,0x8
    80005064:	0c0027b7          	lui	a5,0xc002
    80005068:	97ba                	add	a5,a5,a4
    8000506a:	40200713          	li	a4,1026
    8000506e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005072:	00d5151b          	slliw	a0,a0,0xd
    80005076:	0c2017b7          	lui	a5,0xc201
    8000507a:	97aa                	add	a5,a5,a0
    8000507c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005080:	60a2                	ld	ra,8(sp)
    80005082:	6402                	ld	s0,0(sp)
    80005084:	0141                	addi	sp,sp,16
    80005086:	8082                	ret

0000000080005088 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005088:	1141                	addi	sp,sp,-16
    8000508a:	e406                	sd	ra,8(sp)
    8000508c:	e022                	sd	s0,0(sp)
    8000508e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005090:	ffffc097          	auipc	ra,0xffffc
    80005094:	d96080e7          	jalr	-618(ra) # 80000e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005098:	00d5151b          	slliw	a0,a0,0xd
    8000509c:	0c2017b7          	lui	a5,0xc201
    800050a0:	97aa                	add	a5,a5,a0
  return irq;
}
    800050a2:	43c8                	lw	a0,4(a5)
    800050a4:	60a2                	ld	ra,8(sp)
    800050a6:	6402                	ld	s0,0(sp)
    800050a8:	0141                	addi	sp,sp,16
    800050aa:	8082                	ret

00000000800050ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050ac:	1101                	addi	sp,sp,-32
    800050ae:	ec06                	sd	ra,24(sp)
    800050b0:	e822                	sd	s0,16(sp)
    800050b2:	e426                	sd	s1,8(sp)
    800050b4:	1000                	addi	s0,sp,32
    800050b6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800050b8:	ffffc097          	auipc	ra,0xffffc
    800050bc:	d6e080e7          	jalr	-658(ra) # 80000e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800050c0:	00d5151b          	slliw	a0,a0,0xd
    800050c4:	0c2017b7          	lui	a5,0xc201
    800050c8:	97aa                	add	a5,a5,a0
    800050ca:	c3c4                	sw	s1,4(a5)
}
    800050cc:	60e2                	ld	ra,24(sp)
    800050ce:	6442                	ld	s0,16(sp)
    800050d0:	64a2                	ld	s1,8(sp)
    800050d2:	6105                	addi	sp,sp,32
    800050d4:	8082                	ret

00000000800050d6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800050d6:	1141                	addi	sp,sp,-16
    800050d8:	e406                	sd	ra,8(sp)
    800050da:	e022                	sd	s0,0(sp)
    800050dc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800050de:	479d                	li	a5,7
    800050e0:	04a7cc63          	blt	a5,a0,80005138 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800050e4:	00015797          	auipc	a5,0x15
    800050e8:	8ec78793          	addi	a5,a5,-1812 # 800199d0 <disk>
    800050ec:	97aa                	add	a5,a5,a0
    800050ee:	0187c783          	lbu	a5,24(a5)
    800050f2:	ebb9                	bnez	a5,80005148 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800050f4:	00451693          	slli	a3,a0,0x4
    800050f8:	00015797          	auipc	a5,0x15
    800050fc:	8d878793          	addi	a5,a5,-1832 # 800199d0 <disk>
    80005100:	6398                	ld	a4,0(a5)
    80005102:	9736                	add	a4,a4,a3
    80005104:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005108:	6398                	ld	a4,0(a5)
    8000510a:	9736                	add	a4,a4,a3
    8000510c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005110:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005114:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005118:	97aa                	add	a5,a5,a0
    8000511a:	4705                	li	a4,1
    8000511c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005120:	00015517          	auipc	a0,0x15
    80005124:	8c850513          	addi	a0,a0,-1848 # 800199e8 <disk+0x18>
    80005128:	ffffc097          	auipc	ra,0xffffc
    8000512c:	436080e7          	jalr	1078(ra) # 8000155e <wakeup>
}
    80005130:	60a2                	ld	ra,8(sp)
    80005132:	6402                	ld	s0,0(sp)
    80005134:	0141                	addi	sp,sp,16
    80005136:	8082                	ret
    panic("free_desc 1");
    80005138:	00003517          	auipc	a0,0x3
    8000513c:	58850513          	addi	a0,a0,1416 # 800086c0 <syscalls+0x2f0>
    80005140:	00001097          	auipc	ra,0x1
    80005144:	a06080e7          	jalr	-1530(ra) # 80005b46 <panic>
    panic("free_desc 2");
    80005148:	00003517          	auipc	a0,0x3
    8000514c:	58850513          	addi	a0,a0,1416 # 800086d0 <syscalls+0x300>
    80005150:	00001097          	auipc	ra,0x1
    80005154:	9f6080e7          	jalr	-1546(ra) # 80005b46 <panic>

0000000080005158 <virtio_disk_init>:
{
    80005158:	1101                	addi	sp,sp,-32
    8000515a:	ec06                	sd	ra,24(sp)
    8000515c:	e822                	sd	s0,16(sp)
    8000515e:	e426                	sd	s1,8(sp)
    80005160:	e04a                	sd	s2,0(sp)
    80005162:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005164:	00003597          	auipc	a1,0x3
    80005168:	57c58593          	addi	a1,a1,1404 # 800086e0 <syscalls+0x310>
    8000516c:	00015517          	auipc	a0,0x15
    80005170:	98c50513          	addi	a0,a0,-1652 # 80019af8 <disk+0x128>
    80005174:	00001097          	auipc	ra,0x1
    80005178:	e7a080e7          	jalr	-390(ra) # 80005fee <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000517c:	100017b7          	lui	a5,0x10001
    80005180:	4398                	lw	a4,0(a5)
    80005182:	2701                	sext.w	a4,a4
    80005184:	747277b7          	lui	a5,0x74727
    80005188:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000518c:	14f71b63          	bne	a4,a5,800052e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005190:	100017b7          	lui	a5,0x10001
    80005194:	43dc                	lw	a5,4(a5)
    80005196:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005198:	4709                	li	a4,2
    8000519a:	14e79463          	bne	a5,a4,800052e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000519e:	100017b7          	lui	a5,0x10001
    800051a2:	479c                	lw	a5,8(a5)
    800051a4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051a6:	12e79e63          	bne	a5,a4,800052e2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051aa:	100017b7          	lui	a5,0x10001
    800051ae:	47d8                	lw	a4,12(a5)
    800051b0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051b2:	554d47b7          	lui	a5,0x554d4
    800051b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800051ba:	12f71463          	bne	a4,a5,800052e2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051be:	100017b7          	lui	a5,0x10001
    800051c2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051c6:	4705                	li	a4,1
    800051c8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051ca:	470d                	li	a4,3
    800051cc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800051ce:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800051d0:	c7ffe6b7          	lui	a3,0xc7ffe
    800051d4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdca0f>
    800051d8:	8f75                	and	a4,a4,a3
    800051da:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051dc:	472d                	li	a4,11
    800051de:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800051e0:	5bbc                	lw	a5,112(a5)
    800051e2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800051e6:	8ba1                	andi	a5,a5,8
    800051e8:	10078563          	beqz	a5,800052f2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800051ec:	100017b7          	lui	a5,0x10001
    800051f0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800051f4:	43fc                	lw	a5,68(a5)
    800051f6:	2781                	sext.w	a5,a5
    800051f8:	10079563          	bnez	a5,80005302 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800051fc:	100017b7          	lui	a5,0x10001
    80005200:	5bdc                	lw	a5,52(a5)
    80005202:	2781                	sext.w	a5,a5
  if(max == 0)
    80005204:	10078763          	beqz	a5,80005312 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005208:	471d                	li	a4,7
    8000520a:	10f77c63          	bgeu	a4,a5,80005322 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000520e:	ffffb097          	auipc	ra,0xffffb
    80005212:	f0c080e7          	jalr	-244(ra) # 8000011a <kalloc>
    80005216:	00014497          	auipc	s1,0x14
    8000521a:	7ba48493          	addi	s1,s1,1978 # 800199d0 <disk>
    8000521e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005220:	ffffb097          	auipc	ra,0xffffb
    80005224:	efa080e7          	jalr	-262(ra) # 8000011a <kalloc>
    80005228:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000522a:	ffffb097          	auipc	ra,0xffffb
    8000522e:	ef0080e7          	jalr	-272(ra) # 8000011a <kalloc>
    80005232:	87aa                	mv	a5,a0
    80005234:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005236:	6088                	ld	a0,0(s1)
    80005238:	cd6d                	beqz	a0,80005332 <virtio_disk_init+0x1da>
    8000523a:	00014717          	auipc	a4,0x14
    8000523e:	79e73703          	ld	a4,1950(a4) # 800199d8 <disk+0x8>
    80005242:	cb65                	beqz	a4,80005332 <virtio_disk_init+0x1da>
    80005244:	c7fd                	beqz	a5,80005332 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005246:	6605                	lui	a2,0x1
    80005248:	4581                	li	a1,0
    8000524a:	ffffb097          	auipc	ra,0xffffb
    8000524e:	f30080e7          	jalr	-208(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005252:	00014497          	auipc	s1,0x14
    80005256:	77e48493          	addi	s1,s1,1918 # 800199d0 <disk>
    8000525a:	6605                	lui	a2,0x1
    8000525c:	4581                	li	a1,0
    8000525e:	6488                	ld	a0,8(s1)
    80005260:	ffffb097          	auipc	ra,0xffffb
    80005264:	f1a080e7          	jalr	-230(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005268:	6605                	lui	a2,0x1
    8000526a:	4581                	li	a1,0
    8000526c:	6888                	ld	a0,16(s1)
    8000526e:	ffffb097          	auipc	ra,0xffffb
    80005272:	f0c080e7          	jalr	-244(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005276:	100017b7          	lui	a5,0x10001
    8000527a:	4721                	li	a4,8
    8000527c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000527e:	4098                	lw	a4,0(s1)
    80005280:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005284:	40d8                	lw	a4,4(s1)
    80005286:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000528a:	6498                	ld	a4,8(s1)
    8000528c:	0007069b          	sext.w	a3,a4
    80005290:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005294:	9701                	srai	a4,a4,0x20
    80005296:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000529a:	6898                	ld	a4,16(s1)
    8000529c:	0007069b          	sext.w	a3,a4
    800052a0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052a4:	9701                	srai	a4,a4,0x20
    800052a6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052aa:	4705                	li	a4,1
    800052ac:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800052ae:	00e48c23          	sb	a4,24(s1)
    800052b2:	00e48ca3          	sb	a4,25(s1)
    800052b6:	00e48d23          	sb	a4,26(s1)
    800052ba:	00e48da3          	sb	a4,27(s1)
    800052be:	00e48e23          	sb	a4,28(s1)
    800052c2:	00e48ea3          	sb	a4,29(s1)
    800052c6:	00e48f23          	sb	a4,30(s1)
    800052ca:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800052ce:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d2:	0727a823          	sw	s2,112(a5)
}
    800052d6:	60e2                	ld	ra,24(sp)
    800052d8:	6442                	ld	s0,16(sp)
    800052da:	64a2                	ld	s1,8(sp)
    800052dc:	6902                	ld	s2,0(sp)
    800052de:	6105                	addi	sp,sp,32
    800052e0:	8082                	ret
    panic("could not find virtio disk");
    800052e2:	00003517          	auipc	a0,0x3
    800052e6:	40e50513          	addi	a0,a0,1038 # 800086f0 <syscalls+0x320>
    800052ea:	00001097          	auipc	ra,0x1
    800052ee:	85c080e7          	jalr	-1956(ra) # 80005b46 <panic>
    panic("virtio disk FEATURES_OK unset");
    800052f2:	00003517          	auipc	a0,0x3
    800052f6:	41e50513          	addi	a0,a0,1054 # 80008710 <syscalls+0x340>
    800052fa:	00001097          	auipc	ra,0x1
    800052fe:	84c080e7          	jalr	-1972(ra) # 80005b46 <panic>
    panic("virtio disk should not be ready");
    80005302:	00003517          	auipc	a0,0x3
    80005306:	42e50513          	addi	a0,a0,1070 # 80008730 <syscalls+0x360>
    8000530a:	00001097          	auipc	ra,0x1
    8000530e:	83c080e7          	jalr	-1988(ra) # 80005b46 <panic>
    panic("virtio disk has no queue 0");
    80005312:	00003517          	auipc	a0,0x3
    80005316:	43e50513          	addi	a0,a0,1086 # 80008750 <syscalls+0x380>
    8000531a:	00001097          	auipc	ra,0x1
    8000531e:	82c080e7          	jalr	-2004(ra) # 80005b46 <panic>
    panic("virtio disk max queue too short");
    80005322:	00003517          	auipc	a0,0x3
    80005326:	44e50513          	addi	a0,a0,1102 # 80008770 <syscalls+0x3a0>
    8000532a:	00001097          	auipc	ra,0x1
    8000532e:	81c080e7          	jalr	-2020(ra) # 80005b46 <panic>
    panic("virtio disk kalloc");
    80005332:	00003517          	auipc	a0,0x3
    80005336:	45e50513          	addi	a0,a0,1118 # 80008790 <syscalls+0x3c0>
    8000533a:	00001097          	auipc	ra,0x1
    8000533e:	80c080e7          	jalr	-2036(ra) # 80005b46 <panic>

0000000080005342 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005342:	7159                	addi	sp,sp,-112
    80005344:	f486                	sd	ra,104(sp)
    80005346:	f0a2                	sd	s0,96(sp)
    80005348:	eca6                	sd	s1,88(sp)
    8000534a:	e8ca                	sd	s2,80(sp)
    8000534c:	e4ce                	sd	s3,72(sp)
    8000534e:	e0d2                	sd	s4,64(sp)
    80005350:	fc56                	sd	s5,56(sp)
    80005352:	f85a                	sd	s6,48(sp)
    80005354:	f45e                	sd	s7,40(sp)
    80005356:	f062                	sd	s8,32(sp)
    80005358:	ec66                	sd	s9,24(sp)
    8000535a:	e86a                	sd	s10,16(sp)
    8000535c:	1880                	addi	s0,sp,112
    8000535e:	8a2a                	mv	s4,a0
    80005360:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005362:	00c52c83          	lw	s9,12(a0)
    80005366:	001c9c9b          	slliw	s9,s9,0x1
    8000536a:	1c82                	slli	s9,s9,0x20
    8000536c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005370:	00014517          	auipc	a0,0x14
    80005374:	78850513          	addi	a0,a0,1928 # 80019af8 <disk+0x128>
    80005378:	00001097          	auipc	ra,0x1
    8000537c:	d06080e7          	jalr	-762(ra) # 8000607e <acquire>
  for(int i = 0; i < 3; i++){
    80005380:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005382:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005384:	00014b17          	auipc	s6,0x14
    80005388:	64cb0b13          	addi	s6,s6,1612 # 800199d0 <disk>
  for(int i = 0; i < 3; i++){
    8000538c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000538e:	00014c17          	auipc	s8,0x14
    80005392:	76ac0c13          	addi	s8,s8,1898 # 80019af8 <disk+0x128>
    80005396:	a095                	j	800053fa <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005398:	00fb0733          	add	a4,s6,a5
    8000539c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053a0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800053a2:	0207c563          	bltz	a5,800053cc <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800053a6:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800053a8:	0591                	addi	a1,a1,4
    800053aa:	05560d63          	beq	a2,s5,80005404 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800053ae:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800053b0:	00014717          	auipc	a4,0x14
    800053b4:	62070713          	addi	a4,a4,1568 # 800199d0 <disk>
    800053b8:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800053ba:	01874683          	lbu	a3,24(a4)
    800053be:	fee9                	bnez	a3,80005398 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    800053c0:	2785                	addiw	a5,a5,1
    800053c2:	0705                	addi	a4,a4,1
    800053c4:	fe979be3          	bne	a5,s1,800053ba <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    800053c8:	57fd                	li	a5,-1
    800053ca:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800053cc:	00c05e63          	blez	a2,800053e8 <virtio_disk_rw+0xa6>
    800053d0:	060a                	slli	a2,a2,0x2
    800053d2:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800053d6:	0009a503          	lw	a0,0(s3)
    800053da:	00000097          	auipc	ra,0x0
    800053de:	cfc080e7          	jalr	-772(ra) # 800050d6 <free_desc>
      for(int j = 0; j < i; j++)
    800053e2:	0991                	addi	s3,s3,4
    800053e4:	ffa999e3          	bne	s3,s10,800053d6 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053e8:	85e2                	mv	a1,s8
    800053ea:	00014517          	auipc	a0,0x14
    800053ee:	5fe50513          	addi	a0,a0,1534 # 800199e8 <disk+0x18>
    800053f2:	ffffc097          	auipc	ra,0xffffc
    800053f6:	108080e7          	jalr	264(ra) # 800014fa <sleep>
  for(int i = 0; i < 3; i++){
    800053fa:	f9040993          	addi	s3,s0,-112
{
    800053fe:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005400:	864a                	mv	a2,s2
    80005402:	b775                	j	800053ae <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005404:	f9042503          	lw	a0,-112(s0)
    80005408:	00a50713          	addi	a4,a0,10
    8000540c:	0712                	slli	a4,a4,0x4

  if(write)
    8000540e:	00014797          	auipc	a5,0x14
    80005412:	5c278793          	addi	a5,a5,1474 # 800199d0 <disk>
    80005416:	00e786b3          	add	a3,a5,a4
    8000541a:	01703633          	snez	a2,s7
    8000541e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005420:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005424:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005428:	f6070613          	addi	a2,a4,-160
    8000542c:	6394                	ld	a3,0(a5)
    8000542e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005430:	00870593          	addi	a1,a4,8
    80005434:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005436:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005438:	0007b803          	ld	a6,0(a5)
    8000543c:	9642                	add	a2,a2,a6
    8000543e:	46c1                	li	a3,16
    80005440:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005442:	4585                	li	a1,1
    80005444:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005448:	f9442683          	lw	a3,-108(s0)
    8000544c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005450:	0692                	slli	a3,a3,0x4
    80005452:	9836                	add	a6,a6,a3
    80005454:	058a0613          	addi	a2,s4,88
    80005458:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000545c:	0007b803          	ld	a6,0(a5)
    80005460:	96c2                	add	a3,a3,a6
    80005462:	40000613          	li	a2,1024
    80005466:	c690                	sw	a2,8(a3)
  if(write)
    80005468:	001bb613          	seqz	a2,s7
    8000546c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005470:	00166613          	ori	a2,a2,1
    80005474:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005478:	f9842603          	lw	a2,-104(s0)
    8000547c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005480:	00250693          	addi	a3,a0,2
    80005484:	0692                	slli	a3,a3,0x4
    80005486:	96be                	add	a3,a3,a5
    80005488:	58fd                	li	a7,-1
    8000548a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000548e:	0612                	slli	a2,a2,0x4
    80005490:	9832                	add	a6,a6,a2
    80005492:	f9070713          	addi	a4,a4,-112
    80005496:	973e                	add	a4,a4,a5
    80005498:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000549c:	6398                	ld	a4,0(a5)
    8000549e:	9732                	add	a4,a4,a2
    800054a0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054a2:	4609                	li	a2,2
    800054a4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800054a8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054ac:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800054b0:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054b4:	6794                	ld	a3,8(a5)
    800054b6:	0026d703          	lhu	a4,2(a3)
    800054ba:	8b1d                	andi	a4,a4,7
    800054bc:	0706                	slli	a4,a4,0x1
    800054be:	96ba                	add	a3,a3,a4
    800054c0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800054c4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054c8:	6798                	ld	a4,8(a5)
    800054ca:	00275783          	lhu	a5,2(a4)
    800054ce:	2785                	addiw	a5,a5,1
    800054d0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054d4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800054d8:	100017b7          	lui	a5,0x10001
    800054dc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800054e0:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800054e4:	00014917          	auipc	s2,0x14
    800054e8:	61490913          	addi	s2,s2,1556 # 80019af8 <disk+0x128>
  while(b->disk == 1) {
    800054ec:	4485                	li	s1,1
    800054ee:	00b79c63          	bne	a5,a1,80005506 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800054f2:	85ca                	mv	a1,s2
    800054f4:	8552                	mv	a0,s4
    800054f6:	ffffc097          	auipc	ra,0xffffc
    800054fa:	004080e7          	jalr	4(ra) # 800014fa <sleep>
  while(b->disk == 1) {
    800054fe:	004a2783          	lw	a5,4(s4)
    80005502:	fe9788e3          	beq	a5,s1,800054f2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005506:	f9042903          	lw	s2,-112(s0)
    8000550a:	00290713          	addi	a4,s2,2
    8000550e:	0712                	slli	a4,a4,0x4
    80005510:	00014797          	auipc	a5,0x14
    80005514:	4c078793          	addi	a5,a5,1216 # 800199d0 <disk>
    80005518:	97ba                	add	a5,a5,a4
    8000551a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000551e:	00014997          	auipc	s3,0x14
    80005522:	4b298993          	addi	s3,s3,1202 # 800199d0 <disk>
    80005526:	00491713          	slli	a4,s2,0x4
    8000552a:	0009b783          	ld	a5,0(s3)
    8000552e:	97ba                	add	a5,a5,a4
    80005530:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005534:	854a                	mv	a0,s2
    80005536:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000553a:	00000097          	auipc	ra,0x0
    8000553e:	b9c080e7          	jalr	-1124(ra) # 800050d6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005542:	8885                	andi	s1,s1,1
    80005544:	f0ed                	bnez	s1,80005526 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005546:	00014517          	auipc	a0,0x14
    8000554a:	5b250513          	addi	a0,a0,1458 # 80019af8 <disk+0x128>
    8000554e:	00001097          	auipc	ra,0x1
    80005552:	be4080e7          	jalr	-1052(ra) # 80006132 <release>
}
    80005556:	70a6                	ld	ra,104(sp)
    80005558:	7406                	ld	s0,96(sp)
    8000555a:	64e6                	ld	s1,88(sp)
    8000555c:	6946                	ld	s2,80(sp)
    8000555e:	69a6                	ld	s3,72(sp)
    80005560:	6a06                	ld	s4,64(sp)
    80005562:	7ae2                	ld	s5,56(sp)
    80005564:	7b42                	ld	s6,48(sp)
    80005566:	7ba2                	ld	s7,40(sp)
    80005568:	7c02                	ld	s8,32(sp)
    8000556a:	6ce2                	ld	s9,24(sp)
    8000556c:	6d42                	ld	s10,16(sp)
    8000556e:	6165                	addi	sp,sp,112
    80005570:	8082                	ret

0000000080005572 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005572:	1101                	addi	sp,sp,-32
    80005574:	ec06                	sd	ra,24(sp)
    80005576:	e822                	sd	s0,16(sp)
    80005578:	e426                	sd	s1,8(sp)
    8000557a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000557c:	00014497          	auipc	s1,0x14
    80005580:	45448493          	addi	s1,s1,1108 # 800199d0 <disk>
    80005584:	00014517          	auipc	a0,0x14
    80005588:	57450513          	addi	a0,a0,1396 # 80019af8 <disk+0x128>
    8000558c:	00001097          	auipc	ra,0x1
    80005590:	af2080e7          	jalr	-1294(ra) # 8000607e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005594:	10001737          	lui	a4,0x10001
    80005598:	533c                	lw	a5,96(a4)
    8000559a:	8b8d                	andi	a5,a5,3
    8000559c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000559e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055a2:	689c                	ld	a5,16(s1)
    800055a4:	0204d703          	lhu	a4,32(s1)
    800055a8:	0027d783          	lhu	a5,2(a5)
    800055ac:	04f70863          	beq	a4,a5,800055fc <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800055b0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055b4:	6898                	ld	a4,16(s1)
    800055b6:	0204d783          	lhu	a5,32(s1)
    800055ba:	8b9d                	andi	a5,a5,7
    800055bc:	078e                	slli	a5,a5,0x3
    800055be:	97ba                	add	a5,a5,a4
    800055c0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800055c2:	00278713          	addi	a4,a5,2
    800055c6:	0712                	slli	a4,a4,0x4
    800055c8:	9726                	add	a4,a4,s1
    800055ca:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800055ce:	e721                	bnez	a4,80005616 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800055d0:	0789                	addi	a5,a5,2
    800055d2:	0792                	slli	a5,a5,0x4
    800055d4:	97a6                	add	a5,a5,s1
    800055d6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800055d8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800055dc:	ffffc097          	auipc	ra,0xffffc
    800055e0:	f82080e7          	jalr	-126(ra) # 8000155e <wakeup>

    disk.used_idx += 1;
    800055e4:	0204d783          	lhu	a5,32(s1)
    800055e8:	2785                	addiw	a5,a5,1
    800055ea:	17c2                	slli	a5,a5,0x30
    800055ec:	93c1                	srli	a5,a5,0x30
    800055ee:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800055f2:	6898                	ld	a4,16(s1)
    800055f4:	00275703          	lhu	a4,2(a4)
    800055f8:	faf71ce3          	bne	a4,a5,800055b0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800055fc:	00014517          	auipc	a0,0x14
    80005600:	4fc50513          	addi	a0,a0,1276 # 80019af8 <disk+0x128>
    80005604:	00001097          	auipc	ra,0x1
    80005608:	b2e080e7          	jalr	-1234(ra) # 80006132 <release>
}
    8000560c:	60e2                	ld	ra,24(sp)
    8000560e:	6442                	ld	s0,16(sp)
    80005610:	64a2                	ld	s1,8(sp)
    80005612:	6105                	addi	sp,sp,32
    80005614:	8082                	ret
      panic("virtio_disk_intr status");
    80005616:	00003517          	auipc	a0,0x3
    8000561a:	19250513          	addi	a0,a0,402 # 800087a8 <syscalls+0x3d8>
    8000561e:	00000097          	auipc	ra,0x0
    80005622:	528080e7          	jalr	1320(ra) # 80005b46 <panic>

0000000080005626 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005626:	1141                	addi	sp,sp,-16
    80005628:	e422                	sd	s0,8(sp)
    8000562a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000562c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005630:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005634:	0037979b          	slliw	a5,a5,0x3
    80005638:	02004737          	lui	a4,0x2004
    8000563c:	97ba                	add	a5,a5,a4
    8000563e:	0200c737          	lui	a4,0x200c
    80005642:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005646:	000f4637          	lui	a2,0xf4
    8000564a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000564e:	9732                	add	a4,a4,a2
    80005650:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005652:	00259693          	slli	a3,a1,0x2
    80005656:	96ae                	add	a3,a3,a1
    80005658:	068e                	slli	a3,a3,0x3
    8000565a:	00014717          	auipc	a4,0x14
    8000565e:	4b670713          	addi	a4,a4,1206 # 80019b10 <timer_scratch>
    80005662:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005664:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005666:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005668:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000566c:	00000797          	auipc	a5,0x0
    80005670:	9a478793          	addi	a5,a5,-1628 # 80005010 <timervec>
    80005674:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005678:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000567c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005680:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005684:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005688:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000568c:	30479073          	csrw	mie,a5
}
    80005690:	6422                	ld	s0,8(sp)
    80005692:	0141                	addi	sp,sp,16
    80005694:	8082                	ret

0000000080005696 <start>:
{
    80005696:	1141                	addi	sp,sp,-16
    80005698:	e406                	sd	ra,8(sp)
    8000569a:	e022                	sd	s0,0(sp)
    8000569c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000569e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800056a2:	7779                	lui	a4,0xffffe
    800056a4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdcaaf>
    800056a8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800056aa:	6705                	lui	a4,0x1
    800056ac:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800056b0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056b2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800056b6:	ffffb797          	auipc	a5,0xffffb
    800056ba:	c6878793          	addi	a5,a5,-920 # 8000031e <main>
    800056be:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800056c2:	4781                	li	a5,0
    800056c4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800056c8:	67c1                	lui	a5,0x10
    800056ca:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800056cc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800056d0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800056d4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800056d8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800056dc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800056e0:	57fd                	li	a5,-1
    800056e2:	83a9                	srli	a5,a5,0xa
    800056e4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800056e8:	47bd                	li	a5,15
    800056ea:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800056ee:	00000097          	auipc	ra,0x0
    800056f2:	f38080e7          	jalr	-200(ra) # 80005626 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056f6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800056fa:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800056fc:	823e                	mv	tp,a5
  asm volatile("mret");
    800056fe:	30200073          	mret
}
    80005702:	60a2                	ld	ra,8(sp)
    80005704:	6402                	ld	s0,0(sp)
    80005706:	0141                	addi	sp,sp,16
    80005708:	8082                	ret

000000008000570a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000570a:	715d                	addi	sp,sp,-80
    8000570c:	e486                	sd	ra,72(sp)
    8000570e:	e0a2                	sd	s0,64(sp)
    80005710:	fc26                	sd	s1,56(sp)
    80005712:	f84a                	sd	s2,48(sp)
    80005714:	f44e                	sd	s3,40(sp)
    80005716:	f052                	sd	s4,32(sp)
    80005718:	ec56                	sd	s5,24(sp)
    8000571a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000571c:	04c05763          	blez	a2,8000576a <consolewrite+0x60>
    80005720:	8a2a                	mv	s4,a0
    80005722:	84ae                	mv	s1,a1
    80005724:	89b2                	mv	s3,a2
    80005726:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005728:	5afd                	li	s5,-1
    8000572a:	4685                	li	a3,1
    8000572c:	8626                	mv	a2,s1
    8000572e:	85d2                	mv	a1,s4
    80005730:	fbf40513          	addi	a0,s0,-65
    80005734:	ffffc097          	auipc	ra,0xffffc
    80005738:	224080e7          	jalr	548(ra) # 80001958 <either_copyin>
    8000573c:	01550d63          	beq	a0,s5,80005756 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005740:	fbf44503          	lbu	a0,-65(s0)
    80005744:	00000097          	auipc	ra,0x0
    80005748:	780080e7          	jalr	1920(ra) # 80005ec4 <uartputc>
  for(i = 0; i < n; i++){
    8000574c:	2905                	addiw	s2,s2,1
    8000574e:	0485                	addi	s1,s1,1
    80005750:	fd299de3          	bne	s3,s2,8000572a <consolewrite+0x20>
    80005754:	894e                	mv	s2,s3
  }

  return i;
}
    80005756:	854a                	mv	a0,s2
    80005758:	60a6                	ld	ra,72(sp)
    8000575a:	6406                	ld	s0,64(sp)
    8000575c:	74e2                	ld	s1,56(sp)
    8000575e:	7942                	ld	s2,48(sp)
    80005760:	79a2                	ld	s3,40(sp)
    80005762:	7a02                	ld	s4,32(sp)
    80005764:	6ae2                	ld	s5,24(sp)
    80005766:	6161                	addi	sp,sp,80
    80005768:	8082                	ret
  for(i = 0; i < n; i++){
    8000576a:	4901                	li	s2,0
    8000576c:	b7ed                	j	80005756 <consolewrite+0x4c>

000000008000576e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000576e:	711d                	addi	sp,sp,-96
    80005770:	ec86                	sd	ra,88(sp)
    80005772:	e8a2                	sd	s0,80(sp)
    80005774:	e4a6                	sd	s1,72(sp)
    80005776:	e0ca                	sd	s2,64(sp)
    80005778:	fc4e                	sd	s3,56(sp)
    8000577a:	f852                	sd	s4,48(sp)
    8000577c:	f456                	sd	s5,40(sp)
    8000577e:	f05a                	sd	s6,32(sp)
    80005780:	ec5e                	sd	s7,24(sp)
    80005782:	1080                	addi	s0,sp,96
    80005784:	8aaa                	mv	s5,a0
    80005786:	8a2e                	mv	s4,a1
    80005788:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000578a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000578e:	0001c517          	auipc	a0,0x1c
    80005792:	4c250513          	addi	a0,a0,1218 # 80021c50 <cons>
    80005796:	00001097          	auipc	ra,0x1
    8000579a:	8e8080e7          	jalr	-1816(ra) # 8000607e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000579e:	0001c497          	auipc	s1,0x1c
    800057a2:	4b248493          	addi	s1,s1,1202 # 80021c50 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800057a6:	0001c917          	auipc	s2,0x1c
    800057aa:	54290913          	addi	s2,s2,1346 # 80021ce8 <cons+0x98>
  while(n > 0){
    800057ae:	09305263          	blez	s3,80005832 <consoleread+0xc4>
    while(cons.r == cons.w){
    800057b2:	0984a783          	lw	a5,152(s1)
    800057b6:	09c4a703          	lw	a4,156(s1)
    800057ba:	02f71763          	bne	a4,a5,800057e8 <consoleread+0x7a>
      if(killed(myproc())){
    800057be:	ffffb097          	auipc	ra,0xffffb
    800057c2:	694080e7          	jalr	1684(ra) # 80000e52 <myproc>
    800057c6:	ffffc097          	auipc	ra,0xffffc
    800057ca:	fdc080e7          	jalr	-36(ra) # 800017a2 <killed>
    800057ce:	ed2d                	bnez	a0,80005848 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800057d0:	85a6                	mv	a1,s1
    800057d2:	854a                	mv	a0,s2
    800057d4:	ffffc097          	auipc	ra,0xffffc
    800057d8:	d26080e7          	jalr	-730(ra) # 800014fa <sleep>
    while(cons.r == cons.w){
    800057dc:	0984a783          	lw	a5,152(s1)
    800057e0:	09c4a703          	lw	a4,156(s1)
    800057e4:	fcf70de3          	beq	a4,a5,800057be <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800057e8:	0001c717          	auipc	a4,0x1c
    800057ec:	46870713          	addi	a4,a4,1128 # 80021c50 <cons>
    800057f0:	0017869b          	addiw	a3,a5,1
    800057f4:	08d72c23          	sw	a3,152(a4)
    800057f8:	07f7f693          	andi	a3,a5,127
    800057fc:	9736                	add	a4,a4,a3
    800057fe:	01874703          	lbu	a4,24(a4)
    80005802:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005806:	4691                	li	a3,4
    80005808:	06db8463          	beq	s7,a3,80005870 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000580c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005810:	4685                	li	a3,1
    80005812:	faf40613          	addi	a2,s0,-81
    80005816:	85d2                	mv	a1,s4
    80005818:	8556                	mv	a0,s5
    8000581a:	ffffc097          	auipc	ra,0xffffc
    8000581e:	0e8080e7          	jalr	232(ra) # 80001902 <either_copyout>
    80005822:	57fd                	li	a5,-1
    80005824:	00f50763          	beq	a0,a5,80005832 <consoleread+0xc4>
      break;

    dst++;
    80005828:	0a05                	addi	s4,s4,1
    --n;
    8000582a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000582c:	47a9                	li	a5,10
    8000582e:	f8fb90e3          	bne	s7,a5,800057ae <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005832:	0001c517          	auipc	a0,0x1c
    80005836:	41e50513          	addi	a0,a0,1054 # 80021c50 <cons>
    8000583a:	00001097          	auipc	ra,0x1
    8000583e:	8f8080e7          	jalr	-1800(ra) # 80006132 <release>

  return target - n;
    80005842:	413b053b          	subw	a0,s6,s3
    80005846:	a811                	j	8000585a <consoleread+0xec>
        release(&cons.lock);
    80005848:	0001c517          	auipc	a0,0x1c
    8000584c:	40850513          	addi	a0,a0,1032 # 80021c50 <cons>
    80005850:	00001097          	auipc	ra,0x1
    80005854:	8e2080e7          	jalr	-1822(ra) # 80006132 <release>
        return -1;
    80005858:	557d                	li	a0,-1
}
    8000585a:	60e6                	ld	ra,88(sp)
    8000585c:	6446                	ld	s0,80(sp)
    8000585e:	64a6                	ld	s1,72(sp)
    80005860:	6906                	ld	s2,64(sp)
    80005862:	79e2                	ld	s3,56(sp)
    80005864:	7a42                	ld	s4,48(sp)
    80005866:	7aa2                	ld	s5,40(sp)
    80005868:	7b02                	ld	s6,32(sp)
    8000586a:	6be2                	ld	s7,24(sp)
    8000586c:	6125                	addi	sp,sp,96
    8000586e:	8082                	ret
      if(n < target){
    80005870:	0009871b          	sext.w	a4,s3
    80005874:	fb677fe3          	bgeu	a4,s6,80005832 <consoleread+0xc4>
        cons.r--;
    80005878:	0001c717          	auipc	a4,0x1c
    8000587c:	46f72823          	sw	a5,1136(a4) # 80021ce8 <cons+0x98>
    80005880:	bf4d                	j	80005832 <consoleread+0xc4>

0000000080005882 <consputc>:
{
    80005882:	1141                	addi	sp,sp,-16
    80005884:	e406                	sd	ra,8(sp)
    80005886:	e022                	sd	s0,0(sp)
    80005888:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000588a:	10000793          	li	a5,256
    8000588e:	00f50a63          	beq	a0,a5,800058a2 <consputc+0x20>
    uartputc_sync(c);
    80005892:	00000097          	auipc	ra,0x0
    80005896:	560080e7          	jalr	1376(ra) # 80005df2 <uartputc_sync>
}
    8000589a:	60a2                	ld	ra,8(sp)
    8000589c:	6402                	ld	s0,0(sp)
    8000589e:	0141                	addi	sp,sp,16
    800058a0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800058a2:	4521                	li	a0,8
    800058a4:	00000097          	auipc	ra,0x0
    800058a8:	54e080e7          	jalr	1358(ra) # 80005df2 <uartputc_sync>
    800058ac:	02000513          	li	a0,32
    800058b0:	00000097          	auipc	ra,0x0
    800058b4:	542080e7          	jalr	1346(ra) # 80005df2 <uartputc_sync>
    800058b8:	4521                	li	a0,8
    800058ba:	00000097          	auipc	ra,0x0
    800058be:	538080e7          	jalr	1336(ra) # 80005df2 <uartputc_sync>
    800058c2:	bfe1                	j	8000589a <consputc+0x18>

00000000800058c4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800058c4:	1101                	addi	sp,sp,-32
    800058c6:	ec06                	sd	ra,24(sp)
    800058c8:	e822                	sd	s0,16(sp)
    800058ca:	e426                	sd	s1,8(sp)
    800058cc:	e04a                	sd	s2,0(sp)
    800058ce:	1000                	addi	s0,sp,32
    800058d0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800058d2:	0001c517          	auipc	a0,0x1c
    800058d6:	37e50513          	addi	a0,a0,894 # 80021c50 <cons>
    800058da:	00000097          	auipc	ra,0x0
    800058de:	7a4080e7          	jalr	1956(ra) # 8000607e <acquire>

  switch(c){
    800058e2:	47d5                	li	a5,21
    800058e4:	0af48663          	beq	s1,a5,80005990 <consoleintr+0xcc>
    800058e8:	0297ca63          	blt	a5,s1,8000591c <consoleintr+0x58>
    800058ec:	47a1                	li	a5,8
    800058ee:	0ef48763          	beq	s1,a5,800059dc <consoleintr+0x118>
    800058f2:	47c1                	li	a5,16
    800058f4:	10f49a63          	bne	s1,a5,80005a08 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800058f8:	ffffc097          	auipc	ra,0xffffc
    800058fc:	0b6080e7          	jalr	182(ra) # 800019ae <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005900:	0001c517          	auipc	a0,0x1c
    80005904:	35050513          	addi	a0,a0,848 # 80021c50 <cons>
    80005908:	00001097          	auipc	ra,0x1
    8000590c:	82a080e7          	jalr	-2006(ra) # 80006132 <release>
}
    80005910:	60e2                	ld	ra,24(sp)
    80005912:	6442                	ld	s0,16(sp)
    80005914:	64a2                	ld	s1,8(sp)
    80005916:	6902                	ld	s2,0(sp)
    80005918:	6105                	addi	sp,sp,32
    8000591a:	8082                	ret
  switch(c){
    8000591c:	07f00793          	li	a5,127
    80005920:	0af48e63          	beq	s1,a5,800059dc <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005924:	0001c717          	auipc	a4,0x1c
    80005928:	32c70713          	addi	a4,a4,812 # 80021c50 <cons>
    8000592c:	0a072783          	lw	a5,160(a4)
    80005930:	09872703          	lw	a4,152(a4)
    80005934:	9f99                	subw	a5,a5,a4
    80005936:	07f00713          	li	a4,127
    8000593a:	fcf763e3          	bltu	a4,a5,80005900 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000593e:	47b5                	li	a5,13
    80005940:	0cf48763          	beq	s1,a5,80005a0e <consoleintr+0x14a>
      consputc(c);
    80005944:	8526                	mv	a0,s1
    80005946:	00000097          	auipc	ra,0x0
    8000594a:	f3c080e7          	jalr	-196(ra) # 80005882 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000594e:	0001c797          	auipc	a5,0x1c
    80005952:	30278793          	addi	a5,a5,770 # 80021c50 <cons>
    80005956:	0a07a683          	lw	a3,160(a5)
    8000595a:	0016871b          	addiw	a4,a3,1
    8000595e:	0007061b          	sext.w	a2,a4
    80005962:	0ae7a023          	sw	a4,160(a5)
    80005966:	07f6f693          	andi	a3,a3,127
    8000596a:	97b6                	add	a5,a5,a3
    8000596c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005970:	47a9                	li	a5,10
    80005972:	0cf48563          	beq	s1,a5,80005a3c <consoleintr+0x178>
    80005976:	4791                	li	a5,4
    80005978:	0cf48263          	beq	s1,a5,80005a3c <consoleintr+0x178>
    8000597c:	0001c797          	auipc	a5,0x1c
    80005980:	36c7a783          	lw	a5,876(a5) # 80021ce8 <cons+0x98>
    80005984:	9f1d                	subw	a4,a4,a5
    80005986:	08000793          	li	a5,128
    8000598a:	f6f71be3          	bne	a4,a5,80005900 <consoleintr+0x3c>
    8000598e:	a07d                	j	80005a3c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005990:	0001c717          	auipc	a4,0x1c
    80005994:	2c070713          	addi	a4,a4,704 # 80021c50 <cons>
    80005998:	0a072783          	lw	a5,160(a4)
    8000599c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059a0:	0001c497          	auipc	s1,0x1c
    800059a4:	2b048493          	addi	s1,s1,688 # 80021c50 <cons>
    while(cons.e != cons.w &&
    800059a8:	4929                	li	s2,10
    800059aa:	f4f70be3          	beq	a4,a5,80005900 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059ae:	37fd                	addiw	a5,a5,-1
    800059b0:	07f7f713          	andi	a4,a5,127
    800059b4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800059b6:	01874703          	lbu	a4,24(a4)
    800059ba:	f52703e3          	beq	a4,s2,80005900 <consoleintr+0x3c>
      cons.e--;
    800059be:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800059c2:	10000513          	li	a0,256
    800059c6:	00000097          	auipc	ra,0x0
    800059ca:	ebc080e7          	jalr	-324(ra) # 80005882 <consputc>
    while(cons.e != cons.w &&
    800059ce:	0a04a783          	lw	a5,160(s1)
    800059d2:	09c4a703          	lw	a4,156(s1)
    800059d6:	fcf71ce3          	bne	a4,a5,800059ae <consoleintr+0xea>
    800059da:	b71d                	j	80005900 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800059dc:	0001c717          	auipc	a4,0x1c
    800059e0:	27470713          	addi	a4,a4,628 # 80021c50 <cons>
    800059e4:	0a072783          	lw	a5,160(a4)
    800059e8:	09c72703          	lw	a4,156(a4)
    800059ec:	f0f70ae3          	beq	a4,a5,80005900 <consoleintr+0x3c>
      cons.e--;
    800059f0:	37fd                	addiw	a5,a5,-1
    800059f2:	0001c717          	auipc	a4,0x1c
    800059f6:	2ef72f23          	sw	a5,766(a4) # 80021cf0 <cons+0xa0>
      consputc(BACKSPACE);
    800059fa:	10000513          	li	a0,256
    800059fe:	00000097          	auipc	ra,0x0
    80005a02:	e84080e7          	jalr	-380(ra) # 80005882 <consputc>
    80005a06:	bded                	j	80005900 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a08:	ee048ce3          	beqz	s1,80005900 <consoleintr+0x3c>
    80005a0c:	bf21                	j	80005924 <consoleintr+0x60>
      consputc(c);
    80005a0e:	4529                	li	a0,10
    80005a10:	00000097          	auipc	ra,0x0
    80005a14:	e72080e7          	jalr	-398(ra) # 80005882 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a18:	0001c797          	auipc	a5,0x1c
    80005a1c:	23878793          	addi	a5,a5,568 # 80021c50 <cons>
    80005a20:	0a07a703          	lw	a4,160(a5)
    80005a24:	0017069b          	addiw	a3,a4,1
    80005a28:	0006861b          	sext.w	a2,a3
    80005a2c:	0ad7a023          	sw	a3,160(a5)
    80005a30:	07f77713          	andi	a4,a4,127
    80005a34:	97ba                	add	a5,a5,a4
    80005a36:	4729                	li	a4,10
    80005a38:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a3c:	0001c797          	auipc	a5,0x1c
    80005a40:	2ac7a823          	sw	a2,688(a5) # 80021cec <cons+0x9c>
        wakeup(&cons.r);
    80005a44:	0001c517          	auipc	a0,0x1c
    80005a48:	2a450513          	addi	a0,a0,676 # 80021ce8 <cons+0x98>
    80005a4c:	ffffc097          	auipc	ra,0xffffc
    80005a50:	b12080e7          	jalr	-1262(ra) # 8000155e <wakeup>
    80005a54:	b575                	j	80005900 <consoleintr+0x3c>

0000000080005a56 <consoleinit>:

void
consoleinit(void)
{
    80005a56:	1141                	addi	sp,sp,-16
    80005a58:	e406                	sd	ra,8(sp)
    80005a5a:	e022                	sd	s0,0(sp)
    80005a5c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005a5e:	00003597          	auipc	a1,0x3
    80005a62:	d6258593          	addi	a1,a1,-670 # 800087c0 <syscalls+0x3f0>
    80005a66:	0001c517          	auipc	a0,0x1c
    80005a6a:	1ea50513          	addi	a0,a0,490 # 80021c50 <cons>
    80005a6e:	00000097          	auipc	ra,0x0
    80005a72:	580080e7          	jalr	1408(ra) # 80005fee <initlock>

  uartinit();
    80005a76:	00000097          	auipc	ra,0x0
    80005a7a:	32c080e7          	jalr	812(ra) # 80005da2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005a7e:	00013797          	auipc	a5,0x13
    80005a82:	efa78793          	addi	a5,a5,-262 # 80018978 <devsw>
    80005a86:	00000717          	auipc	a4,0x0
    80005a8a:	ce870713          	addi	a4,a4,-792 # 8000576e <consoleread>
    80005a8e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005a90:	00000717          	auipc	a4,0x0
    80005a94:	c7a70713          	addi	a4,a4,-902 # 8000570a <consolewrite>
    80005a98:	ef98                	sd	a4,24(a5)
}
    80005a9a:	60a2                	ld	ra,8(sp)
    80005a9c:	6402                	ld	s0,0(sp)
    80005a9e:	0141                	addi	sp,sp,16
    80005aa0:	8082                	ret

0000000080005aa2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005aa2:	7179                	addi	sp,sp,-48
    80005aa4:	f406                	sd	ra,40(sp)
    80005aa6:	f022                	sd	s0,32(sp)
    80005aa8:	ec26                	sd	s1,24(sp)
    80005aaa:	e84a                	sd	s2,16(sp)
    80005aac:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005aae:	c219                	beqz	a2,80005ab4 <printint+0x12>
    80005ab0:	08054763          	bltz	a0,80005b3e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005ab4:	2501                	sext.w	a0,a0
    80005ab6:	4881                	li	a7,0
    80005ab8:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005abc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005abe:	2581                	sext.w	a1,a1
    80005ac0:	00003617          	auipc	a2,0x3
    80005ac4:	d3060613          	addi	a2,a2,-720 # 800087f0 <digits>
    80005ac8:	883a                	mv	a6,a4
    80005aca:	2705                	addiw	a4,a4,1
    80005acc:	02b577bb          	remuw	a5,a0,a1
    80005ad0:	1782                	slli	a5,a5,0x20
    80005ad2:	9381                	srli	a5,a5,0x20
    80005ad4:	97b2                	add	a5,a5,a2
    80005ad6:	0007c783          	lbu	a5,0(a5)
    80005ada:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ade:	0005079b          	sext.w	a5,a0
    80005ae2:	02b5553b          	divuw	a0,a0,a1
    80005ae6:	0685                	addi	a3,a3,1
    80005ae8:	feb7f0e3          	bgeu	a5,a1,80005ac8 <printint+0x26>

  if(sign)
    80005aec:	00088c63          	beqz	a7,80005b04 <printint+0x62>
    buf[i++] = '-';
    80005af0:	fe070793          	addi	a5,a4,-32
    80005af4:	00878733          	add	a4,a5,s0
    80005af8:	02d00793          	li	a5,45
    80005afc:	fef70823          	sb	a5,-16(a4)
    80005b00:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005b04:	02e05763          	blez	a4,80005b32 <printint+0x90>
    80005b08:	fd040793          	addi	a5,s0,-48
    80005b0c:	00e784b3          	add	s1,a5,a4
    80005b10:	fff78913          	addi	s2,a5,-1
    80005b14:	993a                	add	s2,s2,a4
    80005b16:	377d                	addiw	a4,a4,-1
    80005b18:	1702                	slli	a4,a4,0x20
    80005b1a:	9301                	srli	a4,a4,0x20
    80005b1c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b20:	fff4c503          	lbu	a0,-1(s1)
    80005b24:	00000097          	auipc	ra,0x0
    80005b28:	d5e080e7          	jalr	-674(ra) # 80005882 <consputc>
  while(--i >= 0)
    80005b2c:	14fd                	addi	s1,s1,-1
    80005b2e:	ff2499e3          	bne	s1,s2,80005b20 <printint+0x7e>
}
    80005b32:	70a2                	ld	ra,40(sp)
    80005b34:	7402                	ld	s0,32(sp)
    80005b36:	64e2                	ld	s1,24(sp)
    80005b38:	6942                	ld	s2,16(sp)
    80005b3a:	6145                	addi	sp,sp,48
    80005b3c:	8082                	ret
    x = -xx;
    80005b3e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b42:	4885                	li	a7,1
    x = -xx;
    80005b44:	bf95                	j	80005ab8 <printint+0x16>

0000000080005b46 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b46:	1101                	addi	sp,sp,-32
    80005b48:	ec06                	sd	ra,24(sp)
    80005b4a:	e822                	sd	s0,16(sp)
    80005b4c:	e426                	sd	s1,8(sp)
    80005b4e:	1000                	addi	s0,sp,32
    80005b50:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005b52:	0001c797          	auipc	a5,0x1c
    80005b56:	1a07af23          	sw	zero,446(a5) # 80021d10 <pr+0x18>
  printf("panic: ");
    80005b5a:	00003517          	auipc	a0,0x3
    80005b5e:	c6e50513          	addi	a0,a0,-914 # 800087c8 <syscalls+0x3f8>
    80005b62:	00000097          	auipc	ra,0x0
    80005b66:	02e080e7          	jalr	46(ra) # 80005b90 <printf>
  printf(s);
    80005b6a:	8526                	mv	a0,s1
    80005b6c:	00000097          	auipc	ra,0x0
    80005b70:	024080e7          	jalr	36(ra) # 80005b90 <printf>
  printf("\n");
    80005b74:	00002517          	auipc	a0,0x2
    80005b78:	4d450513          	addi	a0,a0,1236 # 80008048 <etext+0x48>
    80005b7c:	00000097          	auipc	ra,0x0
    80005b80:	014080e7          	jalr	20(ra) # 80005b90 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005b84:	4785                	li	a5,1
    80005b86:	00003717          	auipc	a4,0x3
    80005b8a:	d4f72323          	sw	a5,-698(a4) # 800088cc <panicked>
  for(;;)
    80005b8e:	a001                	j	80005b8e <panic+0x48>

0000000080005b90 <printf>:
{
    80005b90:	7131                	addi	sp,sp,-192
    80005b92:	fc86                	sd	ra,120(sp)
    80005b94:	f8a2                	sd	s0,112(sp)
    80005b96:	f4a6                	sd	s1,104(sp)
    80005b98:	f0ca                	sd	s2,96(sp)
    80005b9a:	ecce                	sd	s3,88(sp)
    80005b9c:	e8d2                	sd	s4,80(sp)
    80005b9e:	e4d6                	sd	s5,72(sp)
    80005ba0:	e0da                	sd	s6,64(sp)
    80005ba2:	fc5e                	sd	s7,56(sp)
    80005ba4:	f862                	sd	s8,48(sp)
    80005ba6:	f466                	sd	s9,40(sp)
    80005ba8:	f06a                	sd	s10,32(sp)
    80005baa:	ec6e                	sd	s11,24(sp)
    80005bac:	0100                	addi	s0,sp,128
    80005bae:	8a2a                	mv	s4,a0
    80005bb0:	e40c                	sd	a1,8(s0)
    80005bb2:	e810                	sd	a2,16(s0)
    80005bb4:	ec14                	sd	a3,24(s0)
    80005bb6:	f018                	sd	a4,32(s0)
    80005bb8:	f41c                	sd	a5,40(s0)
    80005bba:	03043823          	sd	a6,48(s0)
    80005bbe:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005bc2:	0001cd97          	auipc	s11,0x1c
    80005bc6:	14edad83          	lw	s11,334(s11) # 80021d10 <pr+0x18>
  if(locking)
    80005bca:	020d9b63          	bnez	s11,80005c00 <printf+0x70>
  if (fmt == 0)
    80005bce:	040a0263          	beqz	s4,80005c12 <printf+0x82>
  va_start(ap, fmt);
    80005bd2:	00840793          	addi	a5,s0,8
    80005bd6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005bda:	000a4503          	lbu	a0,0(s4)
    80005bde:	14050f63          	beqz	a0,80005d3c <printf+0x1ac>
    80005be2:	4981                	li	s3,0
    if(c != '%'){
    80005be4:	02500a93          	li	s5,37
    switch(c){
    80005be8:	07000b93          	li	s7,112
  consputc('x');
    80005bec:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005bee:	00003b17          	auipc	s6,0x3
    80005bf2:	c02b0b13          	addi	s6,s6,-1022 # 800087f0 <digits>
    switch(c){
    80005bf6:	07300c93          	li	s9,115
    80005bfa:	06400c13          	li	s8,100
    80005bfe:	a82d                	j	80005c38 <printf+0xa8>
    acquire(&pr.lock);
    80005c00:	0001c517          	auipc	a0,0x1c
    80005c04:	0f850513          	addi	a0,a0,248 # 80021cf8 <pr>
    80005c08:	00000097          	auipc	ra,0x0
    80005c0c:	476080e7          	jalr	1142(ra) # 8000607e <acquire>
    80005c10:	bf7d                	j	80005bce <printf+0x3e>
    panic("null fmt");
    80005c12:	00003517          	auipc	a0,0x3
    80005c16:	bc650513          	addi	a0,a0,-1082 # 800087d8 <syscalls+0x408>
    80005c1a:	00000097          	auipc	ra,0x0
    80005c1e:	f2c080e7          	jalr	-212(ra) # 80005b46 <panic>
      consputc(c);
    80005c22:	00000097          	auipc	ra,0x0
    80005c26:	c60080e7          	jalr	-928(ra) # 80005882 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c2a:	2985                	addiw	s3,s3,1
    80005c2c:	013a07b3          	add	a5,s4,s3
    80005c30:	0007c503          	lbu	a0,0(a5)
    80005c34:	10050463          	beqz	a0,80005d3c <printf+0x1ac>
    if(c != '%'){
    80005c38:	ff5515e3          	bne	a0,s5,80005c22 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c3c:	2985                	addiw	s3,s3,1
    80005c3e:	013a07b3          	add	a5,s4,s3
    80005c42:	0007c783          	lbu	a5,0(a5)
    80005c46:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005c4a:	cbed                	beqz	a5,80005d3c <printf+0x1ac>
    switch(c){
    80005c4c:	05778a63          	beq	a5,s7,80005ca0 <printf+0x110>
    80005c50:	02fbf663          	bgeu	s7,a5,80005c7c <printf+0xec>
    80005c54:	09978863          	beq	a5,s9,80005ce4 <printf+0x154>
    80005c58:	07800713          	li	a4,120
    80005c5c:	0ce79563          	bne	a5,a4,80005d26 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005c60:	f8843783          	ld	a5,-120(s0)
    80005c64:	00878713          	addi	a4,a5,8
    80005c68:	f8e43423          	sd	a4,-120(s0)
    80005c6c:	4605                	li	a2,1
    80005c6e:	85ea                	mv	a1,s10
    80005c70:	4388                	lw	a0,0(a5)
    80005c72:	00000097          	auipc	ra,0x0
    80005c76:	e30080e7          	jalr	-464(ra) # 80005aa2 <printint>
      break;
    80005c7a:	bf45                	j	80005c2a <printf+0x9a>
    switch(c){
    80005c7c:	09578f63          	beq	a5,s5,80005d1a <printf+0x18a>
    80005c80:	0b879363          	bne	a5,s8,80005d26 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005c84:	f8843783          	ld	a5,-120(s0)
    80005c88:	00878713          	addi	a4,a5,8
    80005c8c:	f8e43423          	sd	a4,-120(s0)
    80005c90:	4605                	li	a2,1
    80005c92:	45a9                	li	a1,10
    80005c94:	4388                	lw	a0,0(a5)
    80005c96:	00000097          	auipc	ra,0x0
    80005c9a:	e0c080e7          	jalr	-500(ra) # 80005aa2 <printint>
      break;
    80005c9e:	b771                	j	80005c2a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ca0:	f8843783          	ld	a5,-120(s0)
    80005ca4:	00878713          	addi	a4,a5,8
    80005ca8:	f8e43423          	sd	a4,-120(s0)
    80005cac:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005cb0:	03000513          	li	a0,48
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	bce080e7          	jalr	-1074(ra) # 80005882 <consputc>
  consputc('x');
    80005cbc:	07800513          	li	a0,120
    80005cc0:	00000097          	auipc	ra,0x0
    80005cc4:	bc2080e7          	jalr	-1086(ra) # 80005882 <consputc>
    80005cc8:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cca:	03c95793          	srli	a5,s2,0x3c
    80005cce:	97da                	add	a5,a5,s6
    80005cd0:	0007c503          	lbu	a0,0(a5)
    80005cd4:	00000097          	auipc	ra,0x0
    80005cd8:	bae080e7          	jalr	-1106(ra) # 80005882 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005cdc:	0912                	slli	s2,s2,0x4
    80005cde:	34fd                	addiw	s1,s1,-1
    80005ce0:	f4ed                	bnez	s1,80005cca <printf+0x13a>
    80005ce2:	b7a1                	j	80005c2a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005ce4:	f8843783          	ld	a5,-120(s0)
    80005ce8:	00878713          	addi	a4,a5,8
    80005cec:	f8e43423          	sd	a4,-120(s0)
    80005cf0:	6384                	ld	s1,0(a5)
    80005cf2:	cc89                	beqz	s1,80005d0c <printf+0x17c>
      for(; *s; s++)
    80005cf4:	0004c503          	lbu	a0,0(s1)
    80005cf8:	d90d                	beqz	a0,80005c2a <printf+0x9a>
        consputc(*s);
    80005cfa:	00000097          	auipc	ra,0x0
    80005cfe:	b88080e7          	jalr	-1144(ra) # 80005882 <consputc>
      for(; *s; s++)
    80005d02:	0485                	addi	s1,s1,1
    80005d04:	0004c503          	lbu	a0,0(s1)
    80005d08:	f96d                	bnez	a0,80005cfa <printf+0x16a>
    80005d0a:	b705                	j	80005c2a <printf+0x9a>
        s = "(null)";
    80005d0c:	00003497          	auipc	s1,0x3
    80005d10:	ac448493          	addi	s1,s1,-1340 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005d14:	02800513          	li	a0,40
    80005d18:	b7cd                	j	80005cfa <printf+0x16a>
      consputc('%');
    80005d1a:	8556                	mv	a0,s5
    80005d1c:	00000097          	auipc	ra,0x0
    80005d20:	b66080e7          	jalr	-1178(ra) # 80005882 <consputc>
      break;
    80005d24:	b719                	j	80005c2a <printf+0x9a>
      consputc('%');
    80005d26:	8556                	mv	a0,s5
    80005d28:	00000097          	auipc	ra,0x0
    80005d2c:	b5a080e7          	jalr	-1190(ra) # 80005882 <consputc>
      consputc(c);
    80005d30:	8526                	mv	a0,s1
    80005d32:	00000097          	auipc	ra,0x0
    80005d36:	b50080e7          	jalr	-1200(ra) # 80005882 <consputc>
      break;
    80005d3a:	bdc5                	j	80005c2a <printf+0x9a>
  if(locking)
    80005d3c:	020d9163          	bnez	s11,80005d5e <printf+0x1ce>
}
    80005d40:	70e6                	ld	ra,120(sp)
    80005d42:	7446                	ld	s0,112(sp)
    80005d44:	74a6                	ld	s1,104(sp)
    80005d46:	7906                	ld	s2,96(sp)
    80005d48:	69e6                	ld	s3,88(sp)
    80005d4a:	6a46                	ld	s4,80(sp)
    80005d4c:	6aa6                	ld	s5,72(sp)
    80005d4e:	6b06                	ld	s6,64(sp)
    80005d50:	7be2                	ld	s7,56(sp)
    80005d52:	7c42                	ld	s8,48(sp)
    80005d54:	7ca2                	ld	s9,40(sp)
    80005d56:	7d02                	ld	s10,32(sp)
    80005d58:	6de2                	ld	s11,24(sp)
    80005d5a:	6129                	addi	sp,sp,192
    80005d5c:	8082                	ret
    release(&pr.lock);
    80005d5e:	0001c517          	auipc	a0,0x1c
    80005d62:	f9a50513          	addi	a0,a0,-102 # 80021cf8 <pr>
    80005d66:	00000097          	auipc	ra,0x0
    80005d6a:	3cc080e7          	jalr	972(ra) # 80006132 <release>
}
    80005d6e:	bfc9                	j	80005d40 <printf+0x1b0>

0000000080005d70 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d70:	1101                	addi	sp,sp,-32
    80005d72:	ec06                	sd	ra,24(sp)
    80005d74:	e822                	sd	s0,16(sp)
    80005d76:	e426                	sd	s1,8(sp)
    80005d78:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d7a:	0001c497          	auipc	s1,0x1c
    80005d7e:	f7e48493          	addi	s1,s1,-130 # 80021cf8 <pr>
    80005d82:	00003597          	auipc	a1,0x3
    80005d86:	a6658593          	addi	a1,a1,-1434 # 800087e8 <syscalls+0x418>
    80005d8a:	8526                	mv	a0,s1
    80005d8c:	00000097          	auipc	ra,0x0
    80005d90:	262080e7          	jalr	610(ra) # 80005fee <initlock>
  pr.locking = 1;
    80005d94:	4785                	li	a5,1
    80005d96:	cc9c                	sw	a5,24(s1)
}
    80005d98:	60e2                	ld	ra,24(sp)
    80005d9a:	6442                	ld	s0,16(sp)
    80005d9c:	64a2                	ld	s1,8(sp)
    80005d9e:	6105                	addi	sp,sp,32
    80005da0:	8082                	ret

0000000080005da2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005da2:	1141                	addi	sp,sp,-16
    80005da4:	e406                	sd	ra,8(sp)
    80005da6:	e022                	sd	s0,0(sp)
    80005da8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005daa:	100007b7          	lui	a5,0x10000
    80005dae:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005db2:	f8000713          	li	a4,-128
    80005db6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005dba:	470d                	li	a4,3
    80005dbc:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005dc0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005dc4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005dc8:	469d                	li	a3,7
    80005dca:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005dce:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005dd2:	00003597          	auipc	a1,0x3
    80005dd6:	a3658593          	addi	a1,a1,-1482 # 80008808 <digits+0x18>
    80005dda:	0001c517          	auipc	a0,0x1c
    80005dde:	f3e50513          	addi	a0,a0,-194 # 80021d18 <uart_tx_lock>
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	20c080e7          	jalr	524(ra) # 80005fee <initlock>
}
    80005dea:	60a2                	ld	ra,8(sp)
    80005dec:	6402                	ld	s0,0(sp)
    80005dee:	0141                	addi	sp,sp,16
    80005df0:	8082                	ret

0000000080005df2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005df2:	1101                	addi	sp,sp,-32
    80005df4:	ec06                	sd	ra,24(sp)
    80005df6:	e822                	sd	s0,16(sp)
    80005df8:	e426                	sd	s1,8(sp)
    80005dfa:	1000                	addi	s0,sp,32
    80005dfc:	84aa                	mv	s1,a0
  push_off();
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	234080e7          	jalr	564(ra) # 80006032 <push_off>

  if(panicked){
    80005e06:	00003797          	auipc	a5,0x3
    80005e0a:	ac67a783          	lw	a5,-1338(a5) # 800088cc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e0e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e12:	c391                	beqz	a5,80005e16 <uartputc_sync+0x24>
    for(;;)
    80005e14:	a001                	j	80005e14 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e16:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e1a:	0207f793          	andi	a5,a5,32
    80005e1e:	dfe5                	beqz	a5,80005e16 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e20:	0ff4f513          	zext.b	a0,s1
    80005e24:	100007b7          	lui	a5,0x10000
    80005e28:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e2c:	00000097          	auipc	ra,0x0
    80005e30:	2a6080e7          	jalr	678(ra) # 800060d2 <pop_off>
}
    80005e34:	60e2                	ld	ra,24(sp)
    80005e36:	6442                	ld	s0,16(sp)
    80005e38:	64a2                	ld	s1,8(sp)
    80005e3a:	6105                	addi	sp,sp,32
    80005e3c:	8082                	ret

0000000080005e3e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e3e:	00003797          	auipc	a5,0x3
    80005e42:	a927b783          	ld	a5,-1390(a5) # 800088d0 <uart_tx_r>
    80005e46:	00003717          	auipc	a4,0x3
    80005e4a:	a9273703          	ld	a4,-1390(a4) # 800088d8 <uart_tx_w>
    80005e4e:	06f70a63          	beq	a4,a5,80005ec2 <uartstart+0x84>
{
    80005e52:	7139                	addi	sp,sp,-64
    80005e54:	fc06                	sd	ra,56(sp)
    80005e56:	f822                	sd	s0,48(sp)
    80005e58:	f426                	sd	s1,40(sp)
    80005e5a:	f04a                	sd	s2,32(sp)
    80005e5c:	ec4e                	sd	s3,24(sp)
    80005e5e:	e852                	sd	s4,16(sp)
    80005e60:	e456                	sd	s5,8(sp)
    80005e62:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e64:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e68:	0001ca17          	auipc	s4,0x1c
    80005e6c:	eb0a0a13          	addi	s4,s4,-336 # 80021d18 <uart_tx_lock>
    uart_tx_r += 1;
    80005e70:	00003497          	auipc	s1,0x3
    80005e74:	a6048493          	addi	s1,s1,-1440 # 800088d0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005e78:	00003997          	auipc	s3,0x3
    80005e7c:	a6098993          	addi	s3,s3,-1440 # 800088d8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e80:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005e84:	02077713          	andi	a4,a4,32
    80005e88:	c705                	beqz	a4,80005eb0 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e8a:	01f7f713          	andi	a4,a5,31
    80005e8e:	9752                	add	a4,a4,s4
    80005e90:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005e94:	0785                	addi	a5,a5,1
    80005e96:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005e98:	8526                	mv	a0,s1
    80005e9a:	ffffb097          	auipc	ra,0xffffb
    80005e9e:	6c4080e7          	jalr	1732(ra) # 8000155e <wakeup>
    
    WriteReg(THR, c);
    80005ea2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005ea6:	609c                	ld	a5,0(s1)
    80005ea8:	0009b703          	ld	a4,0(s3)
    80005eac:	fcf71ae3          	bne	a4,a5,80005e80 <uartstart+0x42>
  }
}
    80005eb0:	70e2                	ld	ra,56(sp)
    80005eb2:	7442                	ld	s0,48(sp)
    80005eb4:	74a2                	ld	s1,40(sp)
    80005eb6:	7902                	ld	s2,32(sp)
    80005eb8:	69e2                	ld	s3,24(sp)
    80005eba:	6a42                	ld	s4,16(sp)
    80005ebc:	6aa2                	ld	s5,8(sp)
    80005ebe:	6121                	addi	sp,sp,64
    80005ec0:	8082                	ret
    80005ec2:	8082                	ret

0000000080005ec4 <uartputc>:
{
    80005ec4:	7179                	addi	sp,sp,-48
    80005ec6:	f406                	sd	ra,40(sp)
    80005ec8:	f022                	sd	s0,32(sp)
    80005eca:	ec26                	sd	s1,24(sp)
    80005ecc:	e84a                	sd	s2,16(sp)
    80005ece:	e44e                	sd	s3,8(sp)
    80005ed0:	e052                	sd	s4,0(sp)
    80005ed2:	1800                	addi	s0,sp,48
    80005ed4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005ed6:	0001c517          	auipc	a0,0x1c
    80005eda:	e4250513          	addi	a0,a0,-446 # 80021d18 <uart_tx_lock>
    80005ede:	00000097          	auipc	ra,0x0
    80005ee2:	1a0080e7          	jalr	416(ra) # 8000607e <acquire>
  if(panicked){
    80005ee6:	00003797          	auipc	a5,0x3
    80005eea:	9e67a783          	lw	a5,-1562(a5) # 800088cc <panicked>
    80005eee:	e7c9                	bnez	a5,80005f78 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ef0:	00003717          	auipc	a4,0x3
    80005ef4:	9e873703          	ld	a4,-1560(a4) # 800088d8 <uart_tx_w>
    80005ef8:	00003797          	auipc	a5,0x3
    80005efc:	9d87b783          	ld	a5,-1576(a5) # 800088d0 <uart_tx_r>
    80005f00:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f04:	0001c997          	auipc	s3,0x1c
    80005f08:	e1498993          	addi	s3,s3,-492 # 80021d18 <uart_tx_lock>
    80005f0c:	00003497          	auipc	s1,0x3
    80005f10:	9c448493          	addi	s1,s1,-1596 # 800088d0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f14:	00003917          	auipc	s2,0x3
    80005f18:	9c490913          	addi	s2,s2,-1596 # 800088d8 <uart_tx_w>
    80005f1c:	00e79f63          	bne	a5,a4,80005f3a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f20:	85ce                	mv	a1,s3
    80005f22:	8526                	mv	a0,s1
    80005f24:	ffffb097          	auipc	ra,0xffffb
    80005f28:	5d6080e7          	jalr	1494(ra) # 800014fa <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f2c:	00093703          	ld	a4,0(s2)
    80005f30:	609c                	ld	a5,0(s1)
    80005f32:	02078793          	addi	a5,a5,32
    80005f36:	fee785e3          	beq	a5,a4,80005f20 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f3a:	0001c497          	auipc	s1,0x1c
    80005f3e:	dde48493          	addi	s1,s1,-546 # 80021d18 <uart_tx_lock>
    80005f42:	01f77793          	andi	a5,a4,31
    80005f46:	97a6                	add	a5,a5,s1
    80005f48:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005f4c:	0705                	addi	a4,a4,1
    80005f4e:	00003797          	auipc	a5,0x3
    80005f52:	98e7b523          	sd	a4,-1654(a5) # 800088d8 <uart_tx_w>
  uartstart();
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	ee8080e7          	jalr	-280(ra) # 80005e3e <uartstart>
  release(&uart_tx_lock);
    80005f5e:	8526                	mv	a0,s1
    80005f60:	00000097          	auipc	ra,0x0
    80005f64:	1d2080e7          	jalr	466(ra) # 80006132 <release>
}
    80005f68:	70a2                	ld	ra,40(sp)
    80005f6a:	7402                	ld	s0,32(sp)
    80005f6c:	64e2                	ld	s1,24(sp)
    80005f6e:	6942                	ld	s2,16(sp)
    80005f70:	69a2                	ld	s3,8(sp)
    80005f72:	6a02                	ld	s4,0(sp)
    80005f74:	6145                	addi	sp,sp,48
    80005f76:	8082                	ret
    for(;;)
    80005f78:	a001                	j	80005f78 <uartputc+0xb4>

0000000080005f7a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005f7a:	1141                	addi	sp,sp,-16
    80005f7c:	e422                	sd	s0,8(sp)
    80005f7e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005f80:	100007b7          	lui	a5,0x10000
    80005f84:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005f88:	8b85                	andi	a5,a5,1
    80005f8a:	cb81                	beqz	a5,80005f9a <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80005f8c:	100007b7          	lui	a5,0x10000
    80005f90:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005f94:	6422                	ld	s0,8(sp)
    80005f96:	0141                	addi	sp,sp,16
    80005f98:	8082                	ret
    return -1;
    80005f9a:	557d                	li	a0,-1
    80005f9c:	bfe5                	j	80005f94 <uartgetc+0x1a>

0000000080005f9e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005f9e:	1101                	addi	sp,sp,-32
    80005fa0:	ec06                	sd	ra,24(sp)
    80005fa2:	e822                	sd	s0,16(sp)
    80005fa4:	e426                	sd	s1,8(sp)
    80005fa6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005fa8:	54fd                	li	s1,-1
    80005faa:	a029                	j	80005fb4 <uartintr+0x16>
      break;
    consoleintr(c);
    80005fac:	00000097          	auipc	ra,0x0
    80005fb0:	918080e7          	jalr	-1768(ra) # 800058c4 <consoleintr>
    int c = uartgetc();
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	fc6080e7          	jalr	-58(ra) # 80005f7a <uartgetc>
    if(c == -1)
    80005fbc:	fe9518e3          	bne	a0,s1,80005fac <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005fc0:	0001c497          	auipc	s1,0x1c
    80005fc4:	d5848493          	addi	s1,s1,-680 # 80021d18 <uart_tx_lock>
    80005fc8:	8526                	mv	a0,s1
    80005fca:	00000097          	auipc	ra,0x0
    80005fce:	0b4080e7          	jalr	180(ra) # 8000607e <acquire>
  uartstart();
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	e6c080e7          	jalr	-404(ra) # 80005e3e <uartstart>
  release(&uart_tx_lock);
    80005fda:	8526                	mv	a0,s1
    80005fdc:	00000097          	auipc	ra,0x0
    80005fe0:	156080e7          	jalr	342(ra) # 80006132 <release>
}
    80005fe4:	60e2                	ld	ra,24(sp)
    80005fe6:	6442                	ld	s0,16(sp)
    80005fe8:	64a2                	ld	s1,8(sp)
    80005fea:	6105                	addi	sp,sp,32
    80005fec:	8082                	ret

0000000080005fee <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005fee:	1141                	addi	sp,sp,-16
    80005ff0:	e422                	sd	s0,8(sp)
    80005ff2:	0800                	addi	s0,sp,16
  lk->name = name;
    80005ff4:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005ff6:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005ffa:	00053823          	sd	zero,16(a0)
}
    80005ffe:	6422                	ld	s0,8(sp)
    80006000:	0141                	addi	sp,sp,16
    80006002:	8082                	ret

0000000080006004 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006004:	411c                	lw	a5,0(a0)
    80006006:	e399                	bnez	a5,8000600c <holding+0x8>
    80006008:	4501                	li	a0,0
  return r;
}
    8000600a:	8082                	ret
{
    8000600c:	1101                	addi	sp,sp,-32
    8000600e:	ec06                	sd	ra,24(sp)
    80006010:	e822                	sd	s0,16(sp)
    80006012:	e426                	sd	s1,8(sp)
    80006014:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006016:	6904                	ld	s1,16(a0)
    80006018:	ffffb097          	auipc	ra,0xffffb
    8000601c:	e1e080e7          	jalr	-482(ra) # 80000e36 <mycpu>
    80006020:	40a48533          	sub	a0,s1,a0
    80006024:	00153513          	seqz	a0,a0
}
    80006028:	60e2                	ld	ra,24(sp)
    8000602a:	6442                	ld	s0,16(sp)
    8000602c:	64a2                	ld	s1,8(sp)
    8000602e:	6105                	addi	sp,sp,32
    80006030:	8082                	ret

0000000080006032 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006032:	1101                	addi	sp,sp,-32
    80006034:	ec06                	sd	ra,24(sp)
    80006036:	e822                	sd	s0,16(sp)
    80006038:	e426                	sd	s1,8(sp)
    8000603a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000603c:	100024f3          	csrr	s1,sstatus
    80006040:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006044:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006046:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000604a:	ffffb097          	auipc	ra,0xffffb
    8000604e:	dec080e7          	jalr	-532(ra) # 80000e36 <mycpu>
    80006052:	5d3c                	lw	a5,120(a0)
    80006054:	cf89                	beqz	a5,8000606e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006056:	ffffb097          	auipc	ra,0xffffb
    8000605a:	de0080e7          	jalr	-544(ra) # 80000e36 <mycpu>
    8000605e:	5d3c                	lw	a5,120(a0)
    80006060:	2785                	addiw	a5,a5,1
    80006062:	dd3c                	sw	a5,120(a0)
}
    80006064:	60e2                	ld	ra,24(sp)
    80006066:	6442                	ld	s0,16(sp)
    80006068:	64a2                	ld	s1,8(sp)
    8000606a:	6105                	addi	sp,sp,32
    8000606c:	8082                	ret
    mycpu()->intena = old;
    8000606e:	ffffb097          	auipc	ra,0xffffb
    80006072:	dc8080e7          	jalr	-568(ra) # 80000e36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006076:	8085                	srli	s1,s1,0x1
    80006078:	8885                	andi	s1,s1,1
    8000607a:	dd64                	sw	s1,124(a0)
    8000607c:	bfe9                	j	80006056 <push_off+0x24>

000000008000607e <acquire>:
{
    8000607e:	1101                	addi	sp,sp,-32
    80006080:	ec06                	sd	ra,24(sp)
    80006082:	e822                	sd	s0,16(sp)
    80006084:	e426                	sd	s1,8(sp)
    80006086:	1000                	addi	s0,sp,32
    80006088:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	fa8080e7          	jalr	-88(ra) # 80006032 <push_off>
  if(holding(lk))
    80006092:	8526                	mv	a0,s1
    80006094:	00000097          	auipc	ra,0x0
    80006098:	f70080e7          	jalr	-144(ra) # 80006004 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000609c:	4705                	li	a4,1
  if(holding(lk))
    8000609e:	e115                	bnez	a0,800060c2 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060a0:	87ba                	mv	a5,a4
    800060a2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800060a6:	2781                	sext.w	a5,a5
    800060a8:	ffe5                	bnez	a5,800060a0 <acquire+0x22>
  __sync_synchronize();
    800060aa:	0ff0000f          	fence
  lk->cpu = mycpu();
    800060ae:	ffffb097          	auipc	ra,0xffffb
    800060b2:	d88080e7          	jalr	-632(ra) # 80000e36 <mycpu>
    800060b6:	e888                	sd	a0,16(s1)
}
    800060b8:	60e2                	ld	ra,24(sp)
    800060ba:	6442                	ld	s0,16(sp)
    800060bc:	64a2                	ld	s1,8(sp)
    800060be:	6105                	addi	sp,sp,32
    800060c0:	8082                	ret
    panic("acquire");
    800060c2:	00002517          	auipc	a0,0x2
    800060c6:	74e50513          	addi	a0,a0,1870 # 80008810 <digits+0x20>
    800060ca:	00000097          	auipc	ra,0x0
    800060ce:	a7c080e7          	jalr	-1412(ra) # 80005b46 <panic>

00000000800060d2 <pop_off>:

void
pop_off(void)
{
    800060d2:	1141                	addi	sp,sp,-16
    800060d4:	e406                	sd	ra,8(sp)
    800060d6:	e022                	sd	s0,0(sp)
    800060d8:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800060da:	ffffb097          	auipc	ra,0xffffb
    800060de:	d5c080e7          	jalr	-676(ra) # 80000e36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060e2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800060e6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800060e8:	e78d                	bnez	a5,80006112 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800060ea:	5d3c                	lw	a5,120(a0)
    800060ec:	02f05b63          	blez	a5,80006122 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800060f0:	37fd                	addiw	a5,a5,-1
    800060f2:	0007871b          	sext.w	a4,a5
    800060f6:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800060f8:	eb09                	bnez	a4,8000610a <pop_off+0x38>
    800060fa:	5d7c                	lw	a5,124(a0)
    800060fc:	c799                	beqz	a5,8000610a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006102:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006106:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000610a:	60a2                	ld	ra,8(sp)
    8000610c:	6402                	ld	s0,0(sp)
    8000610e:	0141                	addi	sp,sp,16
    80006110:	8082                	ret
    panic("pop_off - interruptible");
    80006112:	00002517          	auipc	a0,0x2
    80006116:	70650513          	addi	a0,a0,1798 # 80008818 <digits+0x28>
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	a2c080e7          	jalr	-1492(ra) # 80005b46 <panic>
    panic("pop_off");
    80006122:	00002517          	auipc	a0,0x2
    80006126:	70e50513          	addi	a0,a0,1806 # 80008830 <digits+0x40>
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	a1c080e7          	jalr	-1508(ra) # 80005b46 <panic>

0000000080006132 <release>:
{
    80006132:	1101                	addi	sp,sp,-32
    80006134:	ec06                	sd	ra,24(sp)
    80006136:	e822                	sd	s0,16(sp)
    80006138:	e426                	sd	s1,8(sp)
    8000613a:	1000                	addi	s0,sp,32
    8000613c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	ec6080e7          	jalr	-314(ra) # 80006004 <holding>
    80006146:	c115                	beqz	a0,8000616a <release+0x38>
  lk->cpu = 0;
    80006148:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000614c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006150:	0f50000f          	fence	iorw,ow
    80006154:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	f7a080e7          	jalr	-134(ra) # 800060d2 <pop_off>
}
    80006160:	60e2                	ld	ra,24(sp)
    80006162:	6442                	ld	s0,16(sp)
    80006164:	64a2                	ld	s1,8(sp)
    80006166:	6105                	addi	sp,sp,32
    80006168:	8082                	ret
    panic("release");
    8000616a:	00002517          	auipc	a0,0x2
    8000616e:	6ce50513          	addi	a0,a0,1742 # 80008838 <digits+0x48>
    80006172:	00000097          	auipc	ra,0x0
    80006176:	9d4080e7          	jalr	-1580(ra) # 80005b46 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
