	.arch armv7-a
	.eabi_attribute 27, 3
	.eabi_attribute 28, 1
	.fpu neon
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"er2.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"/dev/pts/2\000"
	.align	2
.LC1:
	.ascii	"%s\000"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 136
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #136
	mov	r3, #0
	str	r3, [fp, #-8]
	mov	r0, #64
	bl	malloc
	mov	r3, r0
	str	r3, [fp, #-12]
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	movw	r1, #258
	bl	open
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bge	.L2
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	bl	perror
	mvn	r0, #0
	bl	exit
.L2:
	sub	r3, fp, #76
	ldr	r0, [fp, #-16]
	mov	r1, r3
	bl	tcgetattr
	sub	r3, fp, #136
	mov	r0, r3
	mov	r1, #0
	mov	r2, #60
	bl	memset
	movw	r3, #2237
	str	r3, [fp, #-128]
	mov	r3, #260
	str	r3, [fp, #-136]
	mov	r3, #0
	str	r3, [fp, #-132]
	mov	r3, #0
	str	r3, [fp, #-124]
	mov	r3, #4
	strb	r3, [fp, #-115]
	mov	r3, #1
	strb	r3, [fp, #-113]
	ldr	r0, [fp, #-16]
	mov	r1, #0
	bl	tcflush
	sub	r3, fp, #136
	ldr	r0, [fp, #-16]
	mov	r1, #0
	mov	r2, r3
	bl	tcsetattr
	mov	r0, #1
	ldr	r1, [fp, #-12]
	mov	r2, #63
	bl	read
	str	r0, [fp, #-8]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	ldr	r2, [fp, #-12]
	add	r3, r2, r3
	mov	r2, #0
	strb	r2, [r3]
	ldr	r0, [fp, #-16]
	ldr	r1, [fp, #-12]
	mov	r2, #64
	bl	write
	ldr	r0, [fp, #-16]
	mov	r1, #0
	bl	tcflush
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L3
.L6:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-12]
	add	r3, r2, r3
	ldr	r0, [fp, #-16]
	mov	r1, r3
	mov	r2, #1
	bl	read
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-12]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L4
	b	.L5
.L4:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L3:
	ldr	r3, [fp, #-8]
	cmp	r3, #63
	ble	.L6
.L5:
	movw	r0, #:lower16:.LC1
	movt	r0, #:upper16:.LC1
	ldr	r1, [fp, #-12]
	bl	printf
	sub	r3, fp, #76
	ldr	r0, [fp, #-16]
	mov	r1, #0
	mov	r2, r3
	bl	tcsetattr
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	ldmfd	sp!, {fp, pc}
	.size	main, .-main
	.ident	"GCC: (crosstool-NG 1.20.0) 4.9.2"
	.section	.note.GNU-stack,"",%progbits
