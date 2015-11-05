.text

/* idea ths find_most_freq_char einai na dhmiourghsei enan pinaka 256 thesewn ('h 127) -ton chars- pou tha apo8hkeuei counters
 * kathe fora poy tha diavazetai enas charakthras tha phgainoume sto antistoixo counter (chars + ascii_code) kai tha au3anei th
 * timh tou kata 1. Sto telos diapername mia fora ton pinaka gia na broume ton megalytero counter */

.align 4
.global find_most_freq_char
.type find_most_freq_char, %function
find_most_freq_char:
	push {r2,r3,r5,lr}
	mov r5, r0
	
	mov r0, #512		/* 128 theseis mnhmhs */
	mov r1, #1
	bl calloc
	/* se auto to shmeio ston r0 brisketai h dieuth tou prwtou stoixeiou enos pinaka chars */
	/* enw ston r5 vrisketai h arxh tou input string */
.LforFIND1:
	ldrb r2, [r5, #0]
	cmp r2, #0
	beq .LbreakFIND1
	add r2, r2, r0
	
	/* chars[c]++; sto r2 vrisketai h thesh tou char sth mnhmh (chars + ascii_offset) */
	ldr r3, [r2, #0]
	add r3, r3, #1
	str r3, [r2, #0]
	
	add r5, r5, #1
	b .LforFIND1

.LbreakFIND1:
	mov r4, #33		/* ston r4 kratame ton charakthra me tis perissoters emfaniseis */
	mov r3, #0		/* kai ston r3 th syxnothta tou */
	mov r1, #33	
	add r5, r0, #33 /* 3ekiname apo to Space kai meta (sto paradeigma den metraei Spaces, gi auto 3ekinaw apo to '!' */
.LforFIND2:
	ldrb r2, [r5, #0]
	cmp r2, r3		/* ston r3 exoume ton max */
	movgt r3, r2		/* an o counter einai megalyteros apo ton prohgoumeno max */
	subgt r4, r5, r0	/* tote ananewse ton kai krata ton kainourio char */
	add r5, r5, #1
	add r1, r1, #1
	cmp r1, #255
	bne .LforFIND2
	
	mov r0, r4
	mov r1, r3
	pop {r2,r3,r5,pc}
.size find_most_freq_char, .-find_most_freq_char

.align 4
.global main
.type main, %function
main:
	push {lr}
	
	sub sp, sp, #8

/* Gia kapoio logo pou den katalavainw, tis mises fores h malloc skaei
 * gi auto apenergopoiw to diavasma twn current rythmisewn kathws etsi k
 * alliws den einai toso shmantiko gia thn efarmogh mas */
/* 	mov r0, #18 */
/* 	bl malloc */
/* 	str r0, [sp, #4] */
		
	/* open syscall: open to /dev/ttyAMA0 me O_RDWR (2) */
	ldr r0, =ttyfile
	mov r1, #2
	mov r7, #5
	swi 0
	str r0, [sp, #0]		/* to fd apo8hkeuetai */
	
	/* pare tis palies ry8mhseis ths serial */
/* 	ldr r1, [sp, #4] */
/* 	bl tcgetattr */
	
	
	/* arxikopoihsh klp klp */
	mov r1, #0
	bl tcflush
	ldr r0, [sp, #0]
	mov r1, #0
	ldr r2, =opt
	bl tcsetattr
	
	/* read syscall: diavase apo th serial port (canonical input -> h read epistrefei kai me '\n' */
	ldr r0, [sp, #0]
	ldr r1, =inp
	mov r2, #63
	mov r7, #3
	swi 0
	
	ldr r0, =inp
	bl find_most_freq_char

	/* etoimase to string pou tha steileis */
	
	mov r3, r1
	mov r2, r0
	ldr r0, =write
	cmp r1, #0		/* last minute edit: an to string htan keno steile allo mhnyma */
	ldreq r1, =format_kenh
	ldrne r1, =format
	bl sprintf
	
	/* write syscall: grapse sth serial port to mynhma sou */
	ldr r0, [sp, #0]
	ldr r1, =write
	mov r2, #len
	mov r7, #4
	swi 0
	
	/* epanefere th serial stis prohgoumenes ry8mhseis ths */
/* 	ldr r0, [sp, #0] */
/* 	mov r1, #0 */
/* 	ldr r2, [sp, #4] */
/* 	bl tcsetattr */
	
	/* close syscall */
	ldr r0, [sp, #0]
	mov r7, #6
	swi 0
	
	add sp, sp, #8
	pop {pc}
.size main, .-main

.data
	
ttyfile: .ascii "/dev/ttyAMA0\000"
inp: .ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\000"
format_kenh: .ascii "Give me something next time!!\012\000"
format : .ascii "The most frequent character is\012\042%c\042\012and it appeared %d times\012\000"
write: .ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\000"
len= .-write

opt:
	.word  0x00000104			/* c_iflag = IGNPAR | ICRNL				*/
	.word  0x00000000			/* c_oflag = 0							*/
	.word  0x000008bd			/* c_cflag = BRATE | CS8 | CLOCAL | CREAD	*/
	.word  0x00000002			/* c_lflag = ICANON						*/
	.byte  0x00				/* c_line				*/
	.word  0x00000000			/* c_cc[0-3]			*/
	.word  0x00010004			/* c_cc[4-7]			*/
	.word  0x00000000			/* c_cc[8-11]			*/
	.word  0x00000000			/* c_cc[12-15]			*/
	.word  0x00000000			/* c_cc[16-19]			*/
	.word  0x00000000			/* c_cc[20-23]			*/
	.word  0x00000000			/* c_cc[24-27]			*/
	.word  0x00000000			/* c_cc[28-31]			*/
	.byte  0x00				/* padding			*/
	.hword 0x00				/* padding */
	.word  0x00000000			/* c_ispeed */
	.word  0x00000000			/* c_ospeed */
