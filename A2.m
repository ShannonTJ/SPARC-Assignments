!AUTHOR: Shannon TJ 10101385
!VERSION: Oct 26, 2015

!PROGRAM DESCRIPTION: This program takes an array of size 40 and initializes all positions to random positive integers (mod 256).
!The random unsorted array is printed. Next, the program sorts the array using the insertion sort algorithm given on the assignment. 
!Finally, the sorted array is printed. 

!DEFINES MACROS
define(local_var, `define(last_sym, 0)')
define(`var', `define(`last_sym', eval((last_sym - ifelse($3,,$2,$3)) & -$2)) $1 = last_sym')

local_var
var(ary_s, 4, 40*4)							!assigns offsets for array with 40 4-byte elements

define(i_r, l0)                             !replace i_r with l0 
define(j_r, l1)								!replace j_r with l1 
define(tmp_r, l2)							!replace tmp_r with l2 

!FORMATS PRINT STATEMENTS
fmt: 	
		.asciz "v[%-d]: %d\n" 				!global data for printf statement 
		.align 4 			  				!realign by 4
		
fmtspace:
		.asciz "\n\n" 						!global data for printf statement 
		.align 4 							!realign by 4
fmtsorted:
		.asciz "SORTED ARRAY:\n"  			!global data for printf statement 
		.align 4 							!realign by 4
	
!INITIALIZES REGISTERS
.global main
main:
	save	%sp, (-92 + last_sym) & -8, %sp !allocates room for forty 4 byte variables 
	
	clr 	%i_r							!clears contents of register %i_r
	clr 	%j_r							!clears contents of register %j_r
	clr 	%tmp_r 							!clears contents of register %tmp_r 
	
!PRINTS THE RANDOMIZED ARRAY 
printrandom:
	call 	rand 							!calls random function, stores in %o0 
	nop										!delay slot, cannot be optimized 
	
	and 	%o0, 0xFF, %o0      			!%o0 = rand & 0xFF 
	
	!STORES v[i] IN %o3 
	sll 	%i_r, 2, %o1 					!%o1 = i * 4 
	add 	%fp, %o1, %o1 					!%o1 = %fp + (i*4)
	st 		%o0, [%o1 + ary_s]				!v[i] = rand & 0xFF 
	mov 	%o0, %o3						!moves v[i] into %o3
	
	set 	fmt, %o0						!1st argument to printf
	mov		%i_r, %o1						!2nd argument to printf (value of i)
	call 	printf							!calls printf function 
	mov    	%o3, %o2						!delay slot, 3rd argument to printf (value of v[i]) 
	
	!LOGIC CHECK: i < 40 
	cmp 	%i_r, 40 						!compares current i value to 40
	ble 	printrandom						!skips loop when i > 40 
	inc 	%i_r 							!delay slot, increments i 
	
!PRINTS ON NEW LINE, CLEARS I REGISTER
clear1:
	set 	fmtspace, %o0 					!1st argument to printf 
	call 	printf							!calls printf function 
	clr 	%i_r 							!delay slot, clears contents of register %i_r
	
sortouter:
	!LOGIC CHECK: i < 40 
	cmp 	%i_r, 40 						!compares current i value to 40 
	bg 		clear2 							!skips loop when i > 40 
	
	!INITIALIZES v[i]
	sll 	%i_r, 2, %o0 					!delay slot, %o0 = i * 4
	add 	%fp, %o0, %o0					!%o0 = %fp + (i*4)
	ld 		[%o0 + ary_s], %o0 				!loads v[i] into %o0 
	
	!INITIALIZES TMP AND J VALUES
	mov 	%o0, %tmp_r						!moves v[i] into tmp register (tmp = v[i])
	mov 	%i_r, %j_r						!moves i value into j register (j = i)
	
sortinner:	
	!INITIALIZES v[j]
	sll 	%j_r, 2, %o2 					!%o2 = j * 4
	add 	%fp, %o2, %i2   				!%i2 = %fp + (j*4)
	ld 		[%i2 + ary_s], %o2 				!loads v[j] into %o2
	
	!LOGIC CHECK: j > 0
	cmp 	%j_r, 0  						!compares current j value to 0 
	ble 	sortouter2    					!goes back to outer loop when j =< 0 
	nop										!delay slot, cannot be optimized
	
	!INITIALIZES v[j-1]
	sll 	%j_r, 2, %o1 					!%o1 = j * 4
	add 	%fp, %o1, %i1					!%i1 = %fp + (j*4)
	ld 		[%i1 + ary_s - 4], %o1 			!loads v[j-1] into %o1 
	
	!LOGIC CHECK: tmp < v[j-1]
	cmp 	%tmp_r, %o1 					!compares current tmp value to v[j-1] 				
	bge 	sortouter2						!goes back to outer loop when tmp >= v[j-1]
	nop										!delay slot, cannot be optimized 
	
	!STORES v[j-1] IN v[j]
	st 		%o1, [%i2 + ary_s]				!stores v[j-1] in v[j]
	
	ba 		sortinner 						!restarts inner loop
	add 	%j_r, -1, %j_r 					!delay slot, decrements j by 1 									
	
sortouter2:
	!STORES TMP IN v[j]
	st		%tmp_r, [%i2 + ary_s]			!stores tmp in v[j]
	
	ba 		sortouter						!restarts outer loop 
	inc 	%i_r 							!delay slot, increments i
	
!PRINTS ON NEW LINE, CLEARS I REGISTER 
clear2:	
	set 	fmtsorted, %o0 					!1st argument to printf 
	call 	printf							!calls printf function 
	clr 	%i_r 							!delay slot, clears contents of register %i_r
	
!PRINTS THE SORTED ARRAY 
printsorted:
	!LOGIC CHECK: i < 40 
	cmp 	%i_r, 40 						!compares current i value to 40
	bg 		done							!skips loop when i > 40 
	
	!STORES v[i] IN %o3 
	sll 	%i_r, 2, %o1 					!delay slot, %o1 = i * 4 
	add 	%fp, %o1, %o1 					!%o1 = %fp + (i*4)
	ld 		[%o1 + ary_s], %o3				!moves v[i] value into %o3
	
	set 	fmt, %o0						!1st argument to printf
	mov		%i_r, %o1						!2nd argument to printf (value of i)
	call 	printf							!calls printf function 
	mov    	%o3, %o2						!delay slot, 3rd argument to printf (value of v[i])
	
	ba 		printsorted						!calls printf function 
	inc 	%i_r 							!delay slot, increments i 
	
!ENDS PROGRAM 
done:
	mov 	1, %g1 							!ends program 
	ta		0								!ends program
