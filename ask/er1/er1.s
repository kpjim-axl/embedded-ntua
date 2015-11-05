.text

/* NOTE: START OF print_list */
.align 4
.global print_list
.type print_list, %function
print_list:
	push {r0,r1,r2,r4,r5,r6, lr}
	mov r5, r0
	mov r6, #0					/* int i */
.LloopPRINT:	
	ldr r4, [r5, #4]				/* r4 = lst->next			*/
	cmp r4, #0					/* if (list->next == NULL)	*/
	beq .LexitPRINTLIST				/*	break 				*/
	ldr r0, =str7					/* r0: "%d. %d\n"			*/
	ldr r2, [r4, #0]				/* r2: lst->next->data		*/
	mov r1, r6					/* r1: i */
	bl printf
	ldr r5, [r5, #4]
	adds r6, r6, #1				/* i++					*/
	b .LloopPRINT
	
.LexitPRINTLIST:
	pop {r0,r1,r2,r4,r5,r6, pc}
.size print_list, .-print_list
/* NOTE: END OF print_list */

/*********************************************************/

/* NOTE: START OF read_list */
.align 4
.global read_list
.type read_list, %function
read_list:
	push {r0,r1,r3,r4,r5,r7,lr}
	sub sp, sp, #4
	mov r5, r0				/* r5 = lst */
	mov r7, #-1
	
	ldr r0, =str1
	bl puts
	
.Lloop1READLIST:
	add r7, r7, #1
	ldr r0, =str6 			/* r0: "%d" */
	add r1, sp, #0				/* r1 = &k */
	bl scanf				/* scanf("%d", &k); */
	ldr r3, [sp, #0]			/* r3 = k */
	
	cmp r3, #0				/* if (k<0) break; */
	blt .LexitREADLIST
	
	mov r0, #8			/* sizeof(struct node) = 8 */
	bl malloc
	/* temp1->data = k; */
	str r3, [r0, #0]

	mov r4, r5			/* r4 = lst */
.Lloop2READLIST:
	ldr r1, [r4, #4]		/* r1 = temp2->next */
	cmp r1, #0
	beq .LbreakREADLIST
	ldr r1, [r1, #0]		/* r1: temp2->next->data */
	cmp r1, r3			/* if (temp2->next->data <= k) break */
	ble .LbreakREADLIST
	ldr r4, [r4, #4]
	b .Lloop2READLIST
	
.LbreakREADLIST:
	/* r4: deixnei sto node pou prepei na vrethei prin to kainourio */
	ldr r1, [r4, #4]		/* r1: temp2->next */
	str r1, [r0, #4]		/* temp1->next = temp2->next */
	str r0, [r4, #4]		/* temp2->next = temp1 */
	
	b .Lloop1READLIST

.LexitREADLIST:
	str r7, [r5, #0] /* lst->data = number of nodes */
	add sp, sp, #4
	pop {r0,r1,r3,r4,r5,r7, pc}
.size read_list, .-read_list
/* NOTE: END OF read_list */

/*********************************************************/

/* NOTE: START OF reduction */
.align 4
.global reduction
.type reduction, %function
reduction:
	push {r0, lr}
	sub sp, sp, #4
	mov r5, r0
.Lwhile:
	ldr r0, =str3		/* printf("Give blabla\n"); */
	bl puts
	
	ldr r0, =str6		/* %d */
	add r1, sp, #0
	bl scanf
	
	ldr r1, [sp, #0]	/* r1: scanfed k */
	
	/* if (k<0) break; */
	cmp r1, #0
	blt .LbreakWHILE
	
	ldr r2, [r5, #0]	/* r2: number of list elements (starting from 1) */
	
	/* if (elements_of_list < k) break; */
	cmp r1, r2
	bge .Lwhile
	
	/* if (lst->next == NULL) break;
	 * vasika an ftasoume sto shmeio na yparxei 1 element
	 * kai dwthei egkyros arithmos, apla epistrefoume kai
	 * afhnoume to programma na teleiwsei 						*/
	cmp r2, #1
	beq .LbreakWHILE
	
	mov r0, r5
.Lfor:					/* for (;k>0;k--) { r0 = r0->next; } 	*/
	cmp r1, #0
	beq .LbreakFOR
	ldr r0, [r0, #4]
	sub r1, r1, #1
	b .Lfor
.LbreakFOR:
	ldr r4, [r0, #4]		/* r4: temp2->next 					*/
	ldr r3, [r4, #4]		/* r3: r4->next			 		*/
	str r3, [r0, #4]		/* temp2->next = r4->next 			*/
	mov r0, r4			/* free r4->next 					*/
	bl free
	ldr r0, [r5, #0]
	sub r0, r0, #1			/* lst->data -- 					*/
	str r0, [r5, #0]	
	
	ldr r0, =str4
	bl puts
	mov r0, r5
	bl print_list
	b .Lwhile
.LbreakWHILE:
	add sp, sp, #4
	pop {r0,pc}
.size reduction, .-reduction
/* NOTE: END OF reduction */

/*********************************************************/

/* NOTE: START OF main */
.align 4
.global main
.type main, %function
main:
	push {lr}
	mov r0, #8
	bl malloc
	mov r1, #0
	str r1, [r0, #4]
 	bl read_list
	
	ldr r1, [r0, #0]
	mov r5,r0
	ldr r0, =str2
	bl printf
	mov r0,r5
	
	bl print_list
	
	bl reduction
	
	ldr r0, =str5
	bl puts
	pop	{pc}
.size main, .-main


.data

str1: .ascii "Give positive numbers to insert to the list or a negative to stop:\000"
str2: .ascii "You gave %d elements\012\000"
str3: .ascii "Give an id to delete from the list or a negative number to terminate the program:\000"
str4: .ascii "The renewed list is:\000"
str5: .ascii "Bye!\000"
str6: .ascii "%d\000"
str7: .ascii "%d. %d\012\000"
