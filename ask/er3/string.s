.text

/* STRCMP: sygkrinoume byte-byte ta 2 strings. Kathe fora elegxoume an to ena apo ta 2 einai '\0' (opote tha einai kai to allo)
 * kai analoga epistrefoume 0 (ta 2 strings einai idia). An vroume pws 2 chars diaferoun, ta sygkrinoume kai an o ascii tou prwtou
 * char einai mikroteros apo auton tou deuterou, epistrefoume -1. diaforetika epistrefoume +1. */
.align 4
.global strcmp
.type strcmp, %function
strcmp:
	push {r2,r3, lr}
.LforCMP:
	ldrb r2, [r0, #0]
	ldrb r3, [r1, #0]
	cmp r2, r3
	bne .LbreakCMP
	
	cmp r2, #0
	beq .LretZERO
	
	add r0, r0, #1
	add r1, r1, #1
	
	b .LforCMP

.LbreakCMP:
	blt .LretNEG
	
	mov r0, #1
	pop {r2,r3, pc}

.LretNEG:
	mov r0, #-1
	pop {r2,r3, pc}

.LretZERO:
	mov r0, #0
	pop {r2,r3, pc}
.size strcmp, .-strcmp


/* STRLEN: Ksekiname apo thn arxh toy string. Gia kathe byte au3anoume ton counter kata 1
 * kai phgainoume parakatw. Otan vroume ton charakthra '\0' epistrefoume ton counter */
.align 4
.global strlen
.type strlen, %function
strlen:
	push {r1,r2, lr}
	mov r2, #0
.LforLEN:
	ldrb r1, [r0, #0]
	cmp r1, #0
	beq .LbreakLEN
	add r2, r2, #1
	add r0, r0, #1
	b .LforLEN
.LbreakLEN:
	mov r0, r2
	pop {r1,r2, pc}
.size strlen, .-strlen

/* STRCPY: Ksekiname apo thn arxh tou string src (r1). Fernoume to char ston r2 kai to grafoume sto dest.
 * an o char einai '\0' feugoume, diaforetika au3anoume kata 1 ta src kai dest */
.align 4
.global strcpy
.type strcpy, %function
strcpy:
	push {r2, r5, lr}
	mov r5, r0

.LloopCPY:
	ldrb r2, [r1, #0]
	cmp r2, #0
	beq .LbreakCPY
	strb r2, [r5, #0]
	add r5, r5, #1
	add r1, r1, #1
	b .LloopCPY
.LbreakCPY:
	strb r2, [r5, #0]
	pop {r2,r5, pc}
.size strcpy, .-strcpy

/* STRCAT: Prwta psaxnoume to NULL char sto dest (paromoia skepsh me ta parapanw). Epeita ekteloume strcpy
 * gia na antigrapsoume to src san synexeia dest. */
.align 4
.global strcat
.type strcat, %function
strcat:
	push {r2, r5, lr}
	mov r5, r0
.LloopCAT:
	ldrb r2, [r0, #0]
	cmp r2, #0
	beq .LbreakCAT
	add r0, r0, #1
	b .LloopCAT
.LbreakCAT:
	bl strcpy	/* copy src to the end of dest */
	mov r0, r5
	pop {r2, r5, pc}
.size strcat, .-strcat
