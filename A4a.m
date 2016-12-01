!AUTHOR: Shannon TJ 10101385
!VERSION: Nov 23, 2015

!PROGRAM DESCRIPTION: This program contains all of the functions and global variables for A4Main.c. It is called by the main C 
!program (and receives an input in the case of the push function) to perform actions on stack_m. It can push a max of 5 items onto 
!the stack, pop items off of the stack, and display the stack's contents. It also displays error messages for invalid options 
!(i.e. when an empty stack is being popped).

include(macro_defs.m)

!DEFINES READ-WRITE MEMORY 
.section ".data"
.align 4
.global stack_m 
stack_m: .skip 5*4 

.global top_m
top_m: 	.word -1 

.align 4

!DEFINES READ-ONLY MEMORY 
.section ".text"
overflow:	
		.asciz "\nStack overflow! Cannot push value onto stack.\n"
		.align 4
		
underflow:	
		.asciz "\nStack underflow! Cannot pop an empty stack.\n"
		.align 4

empty:	
		.asciz "\nEmpty stack\n"
		.align 4
current:	
		.asciz "\nCurrent stack contents:\n"
		.align 4
stackdisplay:
		.asciz "  %d"
		.align 4
stacktop:	
		.asciz " <-- top of stack"
		.align 4
newline: 
		.asciz "\n"
		.align 4
		
.global push 
push:
	save 	%sp, -96, %sp 								!Shifts window mapping 
	
	!MOVE TOP INTO %l0 
	sethi 	%hi(top_m), %o0      						!Get high part of address
	ld 		[%o0 + %lo(top_m)], %l0 					!Get low part of address
	
	!CHECK IF STACK IS FULL 
	call 	stackFull 									!Check if stack is full 
	mov 	%i0, %l1 									!Delay slot, move input value into %l1 
	cmp		%o0, 1 										!If %o0 = 1 
	be 		pushfull									!Skip to overflow message  
	
	inc 	%l0  										!Delay slot, top++
	
	!CHANGE DATA IN TOP_M
	set 	top_m, %o0 									!get top_m's address 
	st 		%l0, [%o0]									!top_m = new top value
	
	!CHANGE DATA IN STACK_M 
	sll 	%l0, 2, %o1         						!%o1 = top * 4  
	set 	stack_m, %o2								!%o2 = stack address 
	add 	%o2, %o1, %o2 								!%o2 = stack address + (top*4)
	st 		%l1, [%o2]									!stack[top] = value 
	
	ret 												!Return to calling code 
	restore 											!Restore window mapping 
	
pushfull: 
	!PRINT OVERFLOW HEADER 
	set		overflow, %o0 								!Print overflow message 
	call 	printf 										!Call printf 
	nop													!Delay slot, cannot be optimized 
	ret													!Return to calling code
	restore 											!Restore window mapping 

.global pop 
pop:
	save	%sp, -96, %sp 								!Shifts window mapping 
	
	!MOVE TOP INTO %l0 
	sethi 	%hi(top_m), %o0      						!Get high part of address
	ld 		[%o0 + %lo(top_m)], %l0 					!Get low part of address
	
	!CHECK IF STACK IS EMPTY 
	call 	stackEmpty 									!Check if stack is empty  
	clr 	%l1 										!Delay slot, initialize int value 
	cmp 	%o0, 1 										!If %o0 = 1 
	be 		popempty									!Skip to underflow message  
	
	!CHANGE DATA IN STACK_M 
	sll 	%l0, 2, %o1         						!Delay slot, %o1 = top * 4  
	set 	stack_m, %o2								!%o2 = stack address 
	add 	%o2, %o1, %o2 								!%o2 = stack address + (top*4)
	ld 		[%o2], %l1									!value = stack[top]
	
	!CHANGE DATA IN TOP_M 
	sub 	%l0, 1, %l0 								!top--  
	set 	top_m, %o0 									!get top_m's address 
	st 		%l0, [%o0]									!top_m = new top value
	
	!RETURN INT VALUE 
	mov 	%l1, %i0 									!Return value in %l1 
	ret 												!Return to calling code 
	restore 											!Restore window mapping 
	
popempty:
	!PRINT UNDERFLOW HEADER
	set 	underflow, %o0 								!Print underflow message 
	call 	printf										!Call printf 
	mov 	-1, %i0 									!Delay slot, return -1
	ret 												!Return to calling code 
	restore 											!Restore window mapping 
	
.global stackFull
stackFull:
	save 	%sp, -96, %sp 								!Shifts window mapping 
	
	!MOVE TOP INTO %l0 
	sethi 	%hi(top_m), %o0      						!Get high part of address
	ld 		[%o0 + %lo(top_m)], %l0 					!Get low part of address
	
	!CHECK IF TOP = 4 
	cmp 	%l0, 4										!If top = 4 
	be,a 	donefull 									!Skip to donefull 
	mov 	1, %i0 										!Delay slot, return 1 
	
	!RETURN 0 (FALSE)
	mov 	0, %i0 										!Return 0
	ret 												!Return to calling code 
	restore 											!Restore window mapping 
	
donefull:
	!RETURN 1 (TRUE)
	ret 												!Return to calling code 
	restore 											!Restore window mapping 
	
.global stackEmpty
stackEmpty:
	save 	%sp, -96, %sp 								!Shifts window mapping 
	
	!MOVE TOP INTO %l0 
	sethi 	%hi(top_m), %o0      						!Get high part of address
	ld 		[%o0 + %lo(top_m)], %l0 					!Get low part of address
	
	!CHECK IF TOP = -1 
	cmp 	%l0, -1 									!If top = -1 
	be,a 	doneempty 									!Skip to doneempty 
	mov 	1, %i0 										!Delay slot, return 1 
	
	!RETURN 0 (FALSE)
	mov 	0, %i0 										!Return 0 
	ret 												!Return to calling code
	restore 											!Restore window mapping 
	
doneempty: 
	!RETURN 1 (TRUE)
	ret 												!Return to calling code 
	restore 											!Restore window mapping 
	
.global display 
display: 
	save 	%sp, -96, %sp 								!Shifts window mapping 
	
	!MOVE TOP INTO %l0 
	sethi 	%hi(top_m), %o0      						!Get high part of address
	ld 		[%o0 + %lo(top_m)], %l0 					!Get low part of address
	
	!CHECK IF STACK IS EMPTY 
	call 	stackEmpty 									!Check if stack is empty 
	clr 	%l1 										!Delay slot, initialize int i 
	
	cmp 	%o0, 1 										!If %o0 = 1 
	be 		donedisplay 								!Skip to donedisplay 
	mov 	%l0, %l1 									!Delay slot, i = top  
	
	!PRINT HEADER 
	set		current, %o0  								!Print "Current" message 
	
loop:
	!GET VALUE OF STACK[I]
	sll 	%l1, 2, %o1         						!%o1 = i * 4  
	set 	stack_m, %o2								!%o2 = stack address 
	add 	%o2, %o1, %o2 								!%o2 = stack address + (i*4)
	ld 		[%o2], %l2									!%l2 = stack[i]
	
	!PRINT STACK[I]
	set 	stackdisplay, %o0							!1st argument to printf
	call 	printf										!Call printf 
	mov 	%l2, %o1 									!Delay slot, 2nd argument to printf  
	
	!CHECK IF TOP != I 
	cmp 	%l0, %l1 									!If top != i
	bne 	loop2 										!Skip to loop2 
	nop													!Delay slot, cannot be optimized 
	
	!INDICATE AN ELEMENT IS THE STACK TOP 
	set 	stacktop, %o0 								!1st argument to printf 
	call 	printf 										!Call printf 
	nop 												!Delay slot, cannot be optimized 
	
loop2: 
	!PRINT ON NEW LINE 
	set 	newline, %o0 								!1st argument to printf 
	call 	printf 										!Call printf 
	sub		%l1, 1, %l1 								!Delay slot, i--
	
	!CHECK IF I < 0 
	cmp 	%l1, 0 										!If %l1 < 0 
	bl 		doneloop									!End loop 
	nop													!Delay slot, cannot be optimized 
	
	!RESTART LOOP 
	ba		loop										!Restart loop 
	nop 												!Delay slot, cannot be optimized 
	
doneloop: 	
	!FINISH LOOP 
	ret 												!Return to calling code 
	restore 											!Restore window mapping 
	
donedisplay:
	!PRINT EMPTY MESSAGE 
	set 	empty, %o0 									!1st argument to printf 
	call 	printf 										!Call printf 
	nop 												!Delay slot, cannot be optimized 
	ret 												!Return to calling code 
	restore 											!Restore window mapping 
	
	
