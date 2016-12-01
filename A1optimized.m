!AUTHOR: Shannon TJ 10101385
!VERSION: Sept 26, 2015

!PROGRAM DESCRIPTION:
!This optimized program finds the minimum of y = 2x^3 - 18x^2 + 10x + 39 in the range -2 <= x <= 11 
!by stepping through the range one by one in a loop and testing. Printf function displays the 
!values of x, y, and the current minimum on each loop iteration. Puts the value of the minimum 
!into register %l0 at the end of the program. 

!DEFINES MACROS:
define(a0, -2)							!replaces a0 with -2
define(a1, 10)							!replaces a1 with 10
define(a2, 2) 							!replaces a2 with 2
define(a3, 18)							!replaces a3 with 18
define(a4, 11)							!replaces a4 with 11
define(x_r, l0)                         !replaces x_r with l0
define(x1_r, l1)						!replaces x1_r with l1
define(x2_r, l2)						!replaces x2_r with l2
define(x3_r, l3)						!replaces x3_r with l3
define(y_r, l4)							!replaces y_r with l4
define(min_r, l5)						!replaces min_r with l5

!FORMATS PRINT STATEMENT:
fmt: 	
		.asciz "X is: %d\nY is: %d\nMinimum is: %d\n\n" !global data for print f statement
		.align 4 			   		  				    !realign string by 4
		
.global main
!INITIALIZES VARIABLE VALUES:
main:
	save	%sp, -96, %sp 				!saves the state of the calling routine
	
	mov 	a0, %x_r				    !moves initial x value (x = -2) into %l0
	clr 	%y_r						!moves initial y value into %l4
	clr 	%min_r						!moves initial minimum value into %l5
	
loop: 
	!LOOP STATEMENTS	
	cmp		%x_r, a4 					!compares current x value to 11
	bg		doneloop					!skips loop when x > 11
	
	!CALCULATES 10x
	mov 	%x_r, %o0					!delay slot, moves current x value into %o0
	call	.mul						!multiplies 10*x, puts result in %o0
	mov		a1, %o1						!delay slot, moves 10 into %o1
	mov 	%o0, %x1_r					!moves 10x result into %l1
	
	!CALCULATES x^2
	mov 	%x_r, %o0 					!moves the current x value into %o0
	call	.mul						!multiplies x by itself, puts result in %o0
	mov 	%x_r, %o1					!delay slot, moves the current x value into %o1
	mov 	%o0, %x2_r					!moves x^2 result into %l2
	
	!CALCULATES x^3
	mov 	%x_r, %o0					!moves current x value into %o0
	call 	.mul						!multiplies x by x^2, puts result in %o0
	mov 	%x2_r, %o1					!delay slot, moves x^2 value into %o1
	mov 	%o0, %x3_r                  !moves x^3 result into %l3
	
	!CALCULATES 2x^3
	mov 	%x3_r, %o0 					!moves x^3 into %o0
	call	.mul						!multiplies 2 by x^3, puts result in %o0
	mov 	a2, %o1 					!delay slot, moves 2 into %o1 
	mov 	%o0, %x3_r					!moves 2x^3 result into %l3, replacing previous x^3 value
	
	!CALCULATES 18x^2
	mov 	%x2_r, %o0 					!moves x^2 into %o0
	call	.mul						!multiplies 18 by x^2, puts result in %o0
	mov 	a3, %o1 					!delay slot, moves 18 into %o1
	mov 	%o0, %x2_r					!moves 18x^2 result into %l2, replacing previous x^2 value
	
	!CALCULATES 2x^3 - 18x^2 + 10x + 39
	sub		%x3_r, %x2_r, %y_r 	        !stores (2x^3 - 18x^2) in %l4 	
	add		%y_r, %x1_r, %y_r			!stores (2x^3 - 18x^2 + 10x) in %l4
	add		%y_r, 39, %y_r				!stores (2x^3 - 18x^2 + 10x + 39) in %l4
	
	!IF STATEMENT
	cmp 	%min_r, %y_r				!compares current minimum value to current y value
	ble		next						!skips if statement when min <= y
	nop									!delay slot, can't be optimized
	mov 	%y_r, %min_r				!copies the current y value into the current minimum value
	
next:
	!PRINT STATEMENT
	set 	fmt, %o0					!1st argument to printf
	mov 	%x_r, %o1					!2nd argument to printf, prints x value
	mov 	%y_r, %o2					!3rd argument to printf, prints y value
	call 	printf						!calls printf function
	mov		%min_r, %o3					!delay slot, 4th argument to printf, prints minimum value
	
	ba		loop						!returns to beginning of loop
	inc 	%x_r						!delay slot, increments current x value by 1
	
doneloop: 
	mov 	%min_r, %x_r				!puts minimum value into %l0
	
	mov 	1, %g1  					!ends program
	ta		0							!ends program
	
