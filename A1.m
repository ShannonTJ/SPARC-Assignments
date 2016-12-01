!AUTHOR: Shannon TJ 10101385
!VERSION: Sept 26, 2015

!PROGRAM DESCRIPTION:
!This unoptimized program finds the minimum of y = 2x^3 - 18x^2 + 10x + 39 in the range -2 <= x <= 11 
!by stepping through the range one by one in a loop and testing. Printf function displays the 
!values of x, y, and the current minimum on each loop iteration. Puts the value of the minimum 
!into register %l0 at the end of the program. 

!FORMATS PRINT STATEMENT:
fmt: 	
		.asciz "X is: %d\nY is: %d\nMinimum is: %d\n\n" !global data for print f statement
		.align 4 			   		  				    !realign string by 4
		
.global main
!INITIALIZES VARIABLE VALUES:
main:
	save	%sp, -96, %sp 				!saves the state of the calling routine
	
	mov 	-2, %l0				    	!moves initial x value (x = -2) into %l0
	clr 	%l4						    !moves initial y value into %l4
	clr 	%l5						    !moves initial minimum value into %l5
	
loop: 
	!LOOP STATEMENTS	
	cmp		%l0, 11 					!compares current x value to 11
	bg		doneloop					!skips loop when x > 11
	nop
	
	!CALCULATES 10x
	mov 	%l0, %o0					!moves current x value into %o0
	mov		10, %o1						!moves 10 into %o1
	call	.mul						!multiplies 10*x
	nop									!puts result into %o0
	mov 	%o0, %l1					!moves 10x result into %l1
	
	!CALCULATES x^2
	mov 	%l0, %o0 					!moves the current x value into %o0
	mov 	%l0, %o1					!moves the current x value into %o1
	call	.mul						!multiplies x by itself
	nop									!puts result into %o0
	mov 	%o0, %l2					!moves x^2 result into %l2
	
	!CALCULATES x^3
	mov 	%l0, %o0					!moves current x value into %o0
	mov 	%l2, %o1					!moves x^2 value into %o1
	call 	.mul						!multiplies x by x^2
	nop                                 !puts result into %o0
	mov 	%o0, %l3                    !moves x^3 result into %l3
	
	!CALCULATES 2x^3
	mov 	%l3, %o0 					!moves x^3 into %o0
	mov 	2, %o1 						!moves 2 into %o1 
	call	.mul						!multiplies 2 by x^3
	nop 								!puts result into %o0
	mov 	%o0, %l3					!moves 2x^3 result into %l3, replacing previous x^3 value
	
	!CALCULATES 18x^2
	mov 	%l2, %o0 					!moves x^2 into %o0
	mov 	18, %o1 					!moves 18 into %o1
	call	.mul						!multiplies 18 by x^2
	nop									!puts result into %o0
	mov 	%o0, %l2					!moves 18x^2 result into %l2, replacing previous x^2 value
	
	!CALCULATES 2x^3 - 18x^2 + 10x + 39
	sub		%l3, %l2, %l4 	            !stores (2x^3 - 18x^2) in %l4 	
	add		%l4, %l1, %l4				!stores (2x^3 - 18x^2 + 10x) in %l4
	add		%l4, 39, %l4				!stores (2x^3 - 18x^2 + 10x + 39) in %l4
	
	!IF STATEMENT
	cmp 	%l5, %l4					!compares current minimum value to current y value
	ble		next						!skips if statement when min <= y
	nop									!delay slot
	mov 	%l4, %l5					!copies the current y value into the current minimum value
	
next:
	!PRINT STATEMENT
	set 	fmt, %o0					!1st argument to printf
	mov 	%l0, %o1					!2nd argument to printf, prints x value
	mov 	%l4, %o2					!3rd argument to printf, prints y value
	mov		%l5, %o3					!4th argument to printf, prints minimum value
	call 	printf						!calls printf function
	nop									!delay slot
	
	inc 	%l0							!increments current x value by 1
	ba		loop						!returns to beginning of loop
	nop
	
doneloop: 
	mov 	%l5, %l0					!puts minimum value into %l0
	
	mov 	1, %g1  					!ends program
	ta		0							!ends program
	
