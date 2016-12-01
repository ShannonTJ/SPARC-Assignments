!AUTHOR: Shannon TJ 10101385
!VERSION: Nov 9, 2015

!PROGRAM DESCRIPTION: This program creates two newBox structures called "first" and "second". The initial values 
!(origin points, width, height, and area) of the structures are printed. When all of the values are equal, the program
!moves the origin points of the first structure and expands the dimensions/area of the second structure. The final values 
!of the structures are then printed. 

include(macro_defs.m)

!DEFINES STRUCTURES:
begin_struct(point)
field(x, 4)
field(y, 4)
end_struct(point)

begin_struct(dimension)
field(width, 4)
field(height, 4)
end_struct(dimension)

begin_struct(box)
field(origin, align_of_point, size_of_point)
field(size, align_of_dimension, size_of_dimension)
field(area, 4)
end_struct(box)

!DEFINES BOX STRUCTURES 
local_var
var(first_s, align_of_box, size_of_box)         
var(second_s, align_of_box, size_of_box)
var(b_s, align_of_box, size_of_box)

!FORMATS PRINT STATEMENTS
fmtinitial: 	
		.asciz "Initial Box Values:\n" 								!global data for printf statement 
		.align 4 													!realign string by 4
fmtchanged: 	
		.asciz "\nChanged Box Values:\n" 							!global data for printf statement 
		.align 4 													!realign string by 4
fmtprintBox1:
		.asciz "\nBox %s origin = (%d, %d) "						!global data for printf statement
		.align 4													!realign string by 4
fmtprintBox2:
		.asciz "width = %d height = %d area = %d\n" 				!global data for printf statement
		.align 4													!realign string by 4
first: 	
		.asciz "first" 											!global data for printf statement
		.align 4
second:	
		.asciz "second"							    			!global data for printf statement	
		.align 4 													!realign string by 4	
.global main
main:
	save 	%sp, (-92 + last_sym) & -8, %sp							!saves the state of the calling routine 
	
	!PRINTS HEADER
	set 	fmtinitial, %o0 										!1st argument to printf
	call 	printf													!calls printf function 
	nop 															!delay slot, cannot be optimized 
	
	!CREATES NEWBOX STRUCTURES
	add		%fp, first_s, %o0										!gets address of first_s 
	call 	newBox 													!calls newBox  
	st 		%o0, [%sp + 64]											!delay slot, stores first_s on stack 
	
	add		%fp, second_s, %o0										!get address of second_s 
	call 	newBox 													!calls newBox
	st 		%o0, [%sp + 64]											!delay slot, stores second_s on stack 
	
	!PRINTS INITIAL NEWBOX VALUES
	set 	first, %o0												!delay slot, moves "first" into %o1 
	call 	printBox 												!prints values in first_s
	add		%fp, first_s, %o1										!gets address of first_s
	
	set 	second, %o0 											!delay slot, moves "second" into %o1 
	call 	printBox 												!prints values in second_s 
	add		%fp, second_s, %o1										!gets address of second_s 
	
	!CHECKS IF ALL NEWBOX VALUES ARE EQUAL
	add		%fp, first_s, %o0										!gets address of first_s
	call 	equal 													!calls equal, compares values in first_s and second_s
	add		%fp, second_s, %o1										!delay slot, gets address of second_s
	mov 	%o0, %l0 												!stores true/false result (0 = false, 1 = true)
	
	!CHECKS IF EQUAL TO 1
	cmp 	%l0, 1 													!checks if result != 1
	bne 	next 													!skips if not equal 
	
	!CHANGES FIRST'S ORIGIN TO (-5, 7)
	add		%fp, first_s, %o0										!delay slot, gets address of first_s 
	mov 	-5, %o1 												!%o1 = -5
	call 	move 													!calls move
	mov 	7, %o2													!delay slot, %o2 = 7
	
	!CHANGES SECOND'S WIDTH, HEIGHT, AND AREA
	add		%fp, second_s, %o0										!gets address of first_s 
	call 	expand 													!calls expand
	mov 	3, %o1													!delay slot, %o1 = 3
	
	
next: 
	!PRINTS HEADER
	set 	fmtchanged, %o0 										!1st argument to printf
	call 	printf													!calls printf function 
	nop 															!delay slot, cannot be optimized
	
	!PRINTS CHANGED NEWBOX VALUES
	set 	first, %o0												!delay slot, moves "first" into %o1 
	call 	printBox 												!prints values in first_s
	add		%fp, first_s, %o1										!gets address of first_s
	
	set 	second, %o0 											!delay slot, moves "second" into %o1 
	call 	printBox 												!prints values in second_s 
	add		%fp, second_s, %o1										!gets address of second_s 
	
	
	!ENDS PROGRAM 
	mov 	1, %g1 													!ends program 
	ta 		0														!ends program 
	
	
.global newBox
newBox: 
	save	%sp, (-92 + last_sym) & -8, %sp 						!shifts window mapping by 16 
	
	ld		[%fp + 64], %o0 										!gets structure address 
	mov 	1, %l0 													!delay slot, %l0 = 1 
	
	!SETS POINT FIELDS IN SUBROUTINE
	st  	%g0, [%fp + b_s + box_origin + point_x]  				!b.origin.x = 0
	st   	%g0, [%fp + b_s + box_origin + point_y]					!b.origin.y = 0 
	
	!SETS POINT FIELDS IN MAIN 
	ld 		[%fp + b_s + box_origin + point_x], %o1 				!%o1 = 0 
	st 		%o1, [%o0 + box_origin + point_x]						!point x = 0 in main 
	
	ld 		[%fp + b_s + box_origin + point_y], %o1 				!%o1 = 0 
	st 		%o1, [%o0 + box_origin + point_y]						!point y = 0 in main 
	
	!SETS DIMENSION FIELDS IN SUBROUTINE
	st 		%l0, [%fp + b_s + box_size + dimension_width]			!b.size.width = 1    
	st 		%l0, [%fp + b_s + box_size + dimension_height]			!b.size.height = 1   
	
	!SETS DIMENSION FIELDS IN MAIN 
	ld 		[%fp + b_s + box_size + dimension_width], %o2 			!%o2 = 1 
	st 		%o2, [%o0 + box_size + dimension_width]					!width = 1 in main 
	
	ld 		[%fp + b_s + box_size + dimension_height], %o2 			!%o2 = 1 
	st 		%o2, [%o0 + box_size + dimension_height]				!height = 1 in main 
	
	mov 	%o0, %l0 												!preserves %o0 value in %l0 
	
	!SETS AREA FIELD IN SUBROUTINE
	ld 		[%fp + b_s + box_size + dimension_width], %o0			!loads box width into %o0 
	call 	.mul													!b.size.width * b.size.height 
	ld		[%fp + b_s + box_size + dimension_height], %o1			!delay slot, loads box height into %o1 
	st 		%o0, [%fp + b_s + box_area] 							!b.area = b.size.width * b.size.height 
	
	!SETS AREA FIELD IN MAIN 
	ld 		[%fp + b_s + box_area], %o1 							!%o1 = 1 
	st 		%o1, [%l0 + box_area]									!area = 1 in main 
	
	!RETURNS TO CALLING CODE 
	ret																!return to calling code 
	restore 														!delay slot, restores window mapping													!delay slot, restores window mapping 

.global printBox
printBox:
	save	%sp, (-92 + last_sym) & -8, %sp 						!shifts window mapping by 16 
	
	!LOADS NEWBOX VALUES INTO L REGISTERS
	ld		[%i1 + box_origin + point_x], %l1 						!%l1 = point x value 
	ld 		[%i1 + box_origin + point_y], %l2						!%l2 = point y value 
	ld 		[%i1 + box_size + dimension_width], %l3					!%l3 = width value 
	ld 		[%i1 + box_size + dimension_height], %l4				!%l4 = height value 
	ld 		[%i1 + box_area], %l5 									!%l5 = area value 
	
	!PRINTS NEWBOX VALUES 
	set		fmtprintBox1, %o0 										!1st argument to printf
	mov 	%i0, %o1 	
	mov 	%l1, %o2												!3rd argument to printf	
	call 	printf													!calls printf
	mov 	%l2, %o3												!delay slot, 4th argument to printf
	
	set		fmtprintBox2, %o0 										!1st argument to printf
	mov 	%l3, %o1												!2nd argument to printf
	mov 	%l4, %o2												!3rd argument to printf
	call 	printf													!calls printf
	mov     %l5, %o3												!delay slot, 4th argument to printf
	
	!RETURNS TO CALLING CODE 
	ret																!return to calling code
	restore 														!delay slot, restores window mapping 	
	
.global equal 
equal:	
	save	%sp, (-92 + last_sym) & -8, %sp 						!shifts window mapping by 16 
	
	ld		[%i0 + box_origin + point_x], %o2 						!%o2 = first's point x
	ld		[%i1 + box_origin + point_x], %o3 						!%o3 = seconds point x
	
	!COMPARES POINT X VALUES 
	cmp 	%o2, %o3        										!compares point x of both structures 
	bne 	false													!skips if not equal 
	
	ld 		[%i0 + box_origin + point_y], %o4 						!delay slot, %o4 = first's point y 
	ld 		[%i1 + box_origin + point_y], %o5 						!%o5 = second's point y
	
	!COMPARES POINT Y VALUES 
	cmp 	%o4, %o5												!compares point y of both structures 
	bne 	false  													!skips if not equal 
	
	ld 		[%i0 + box_size + dimension_width], %o2 				!delay slot, %o2 = first's width  
	ld 		[%i1 + box_size + dimension_width], %o3					!%o3 = second's width 
	
	!COMPARES WIDTH VALUES 
	cmp 	%o2, %o3 												!compares width of both structures 
	bne		false  													!skips if not equal 
	
	ld 		[%i0 + box_size + dimension_height], %o4 				!delay slot, %o4 = first's height 
	ld 		[%i1 + box_size + dimension_height], %o5				!%o5 = second's height 
	
	!COMPARES HEIGHT VALUES 
	cmp 	%o4, %o5												!compares height of both structures 
	bne 	false 													!skips if not equal 
	nop 															!delay slot, cannot be optimized 
	
	!SETS TRUTH VALUE TO TRUE 
	mov 	1, %i0 													!delay slot, %o0 = 1 in main 
	ret																!return to calling code
	restore 														!delay slot, restores window mapping 
	
false:
	!SETS TRUTH VALUE TO FALSE
	mov 	0, %i0													!delay slot, %o0 = 0 in main 
	ret																!return to calling code
	restore 														!delay slot, restores window mapping 
	
	
.global move
move: 
	save	%sp, (-92 + last_sym) & -8, %sp 						!shifts window mapping by 16  
	
	!LOADS FIRST'S POINT VALUES 
	ld 		[%i0 + box_origin + point_x], %o1 						!%o1 = first's point x = 0
	ld 		[%i0 + box_origin + point_y], %o2 						!%o2 = first's point y = 0
	
	!CHANGES POINT VALUES 
	add 	%o1, %i1, %o1 											!%o1 = 0 + -5
	add 	%o2, %i2, %o2 											!%o2 = 0 + 7
	
	!CHANGES POINT VALUES IN MAIN 
	st 		%o1, [%i0 + box_origin + point_x]						!point x = -5 in main 
	st 		%o2, [%i0 + box_origin + point_y]						!point y = 7 in main 
	
	ret 															!return to calling code
	restore 														!delay slot, restores window mapping 
	
.global expand 
expand: 
	save	%sp, (-92 + last_sym) & -8, %sp 						!shifts window mapping by 16  
	
	!CHANGES SECOND'S WIDTH 
	ld 		[%i0 + box_size + dimension_width], %o0 				!%o0 = second's width = 1 
	call 	.mul 													!%o0 = 1*3 = 3 
	mov 	%i1, %o1 												!delay slot, moves 3 into %o1 
	st 		%o0, [%i0 + box_size + dimension_width] 				!width = 3 
	
	!CHANGES SECOND'S HEIGHT 
	ld 		[%i0 + box_size + dimension_height], %o0 				!%o0 = second's height = 1 
	call 	.mul 													!%o0 = 1*3 = 3
	mov 	%i1, %o1 												!delay slot, moves 3 into %o1 
	st 		%o0, [%i0 + box_size + dimension_height] 				!height = 3 
	
	!CHANGES SECOND'S AREA 
	ld 		[%i0 + box_size + dimension_width], %o0 				!%o0 = 3 
	call 	.mul 													!%o0 = 3*3 = 9 
	ld 		[%i0 + box_size + dimension_height], %o1 				!delay slot, %o1 = 3 
	st 		%o0, [%i0 + box_area]									!area = 9 
	
	ret 															!return to calling code
	restore 														!delay slot, restores window mapping 
	
