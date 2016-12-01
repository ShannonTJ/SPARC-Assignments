!AUTHOR: Shannon TJ 10101385
!VERSION: Nov 20, 2015

!PROGRAM DESCRIPTION: This program reads 3 numeric arguments from the command line (not including the program name). It matches the 
!first number to a month, the second number to a date with an appropriate suffix (st, nd, rd, th), and the third to a year. It prints
!output as a string of the form: month datesuffix, year (where date and year are integers, month and suffix are strings). 
!The program also performs error checking so that the month argument must be from 0-11, the date argument must be from 0-31, and the 
!year argument must be from 1000-3000. If an incorrect number of arguments are entered, the program will output another error message
!indicating the correct way to input the command line arguments. 

include(macro_defs.m)

!DEFINES READ-WRITE MEMORY 
.section ".data"
.align 4
.global month
month: 	
		.word jan_m, feb_m, mar_m, apr_m, may_m, jun_m
		.word jul_m, aug_m, sep_m, oct_m, nov_m, dec_m
		
jan_m: 	.asciz "January"
feb_m: 	.asciz "February"
mar_m: 	.asciz "March"
apr_m:	.asciz "April"
may_m:	.asciz "May"
jun_m: 	.asciz "June"
jul_m: 	.asciz "July"
aug_m: 	.asciz "August"
sep_m: 	.asciz "September"
oct_m:	.asciz "October"
nov_m:	.asciz "November"
dec_m:	.asciz "December"
		.align 4
		
!DEFINES READ-ONLY MEMORY 
.section ".text"
fmt:	
		.asciz "%s %d%s, %d\n"
		.align 4
		
errorprint: 
		.asciz "ERROR: Invalid input. Exiting program...\n"
		.align 4
errorprint2:
		.asciz "ERROR: Input should be in the form: mm dd yyyy\n"
		.align 4
st:
		.asciz "st"
		.align 4
		
nd:
		.asciz "nd"
		.align 4
		
rd: 
		.asciz "rd"
		.align 4
		
th:
		.asciz "th"
		.align 4
		
debug:
		.asciz "%s\n"
		.align 4
		
.global main
main: 	
	save	%sp, -92 & -8, %sp 							!Saves state of calling routine
	
	!CHECK IF ARGUMENT NUMBER IS VALID 
	cmp 	%i0, 4 										!Check if number of arguments != 4
	bne 	argumenterror 								!Branch to error message 
	
	!GET MONTH INTEGER (1, 2, 3...)
	ld  	[%i1 + 4], %o0     						    !Delay slot, get month string from command line 	
	call 	atoi 		       							!Convert month string to integer value 
	nop 												!Delay slot, cannot be optimized 
	mov 	%o0, %l0 									!%l0 = month integer 
	
	!CHECK MONTH IS A VALID NUMBER
	cmp     %l0, 0										!Check if month < 0 
	bl 		error										!Branch to error message  
	
	cmp 	%l0, 11										!Delay slot, check if month > 11 
	bg 		error 										!Branch to error message  
	
	!GET DAY INTEGER (1, 2, 3...)
	ld  	[%i1 + 8], %o0      						!Delay slot, get day string from command line 	    
	call 	atoi 		        						!Convert day string to integer value 
	nop 												!Delay slot, cannot be optimized
	mov 	%o0, %l1 									!%l1 = day integer 
	
	!CHECK DAY IS A VALID NUMBER 
	cmp 	%l1, 1										!Check if day < 1 
	bl 		error 										!Branch to error message 
	
	cmp 	%l1, 31										!Delay slot, check if day > 31 
	bg 		error 										!Branch to error message 
	
	!GET YEAR INTEGER (1000, 1001, 1002...)
	ld  	[%i1 + 12], %o0      						!Delay slot, get year string from command line 	    
	call 	atoi 		        						!Convert year string to integer value 
	nop 												!Delay slot, cannot be optimized
	mov 	%o0, %l2 									!%l2 = year integer
	
	!CHECK YEAR IS A VALID NUMBER 
	cmp 	%l2, 1000									!Check if year < 1000
	bl 		error 										!Branch to error message
	
	cmp 	%l2, 3000									!Delay slot, check if year > 3000
	bg 		error 										!Branch to error message
	
	!GET MONTH STRING (JANUARY, FEBRUARY...)
	
	sll 	%l0, 2, %l0         						!Delay slot, leftshift month integer by 2 
	set 	month, %o1 		    						!Find month's address in the array
	add 	%o1, %l0, %o1 								!Add offset to month's address
	ld 		[%o1], %l0 									!%l0 = month string 
	
	!GET DAY STRING (ST, ND, RD, TH)
	!Identify strings ending with "st" 
	cmp 	%l1, 1										!Check if day = 1 
	be 		first										!Branch to first  
	
	cmp 	%l1, 21										!Delay slot, check if day = 21 
	be 		first 										!Branch to first 
	
	cmp 	%l1, 31 									!Delay slot, check if day = 31 
	be 		first 										!Branch to first 
	
	!Identify strings ending with "nd" 
	cmp 	%l1, 2										!Delay slot, check if day = 2 
	be 		second										!Branch to second  
	
	cmp 	%l1, 22										!Delay slot, check if day = 22 
	be 		second										!Branch to second   
	
	!Identify strings ending with "rd"
	cmp 	%l1, 3 										!Delay slot, check if day = 3 
	be 		third 										!Branch to third 
	
	cmp 	%l1, 23 									!Delay slot, check if day = 23 
	be 		third 										!Branch to third  
	
	!Identify strings ending with "th"
	cmp 	%l1, 4 										!Delay slot, check for remaining numbers, all ending with "th"
	bge 	fourth 										!Branch to fourth 
	nop 
	
first:
	set 	st, %l3 									!Format string with "st"
	ba 		next 										!Skip to next 
	nop 												!Delay slot, cannot be optimized
	
second: 
	set 	nd, %l3										!Format string with "nd"
	ba 		next 										!Skip to next 
	nop 												!Delay slot, cannot be optimized
	
third:
	set 	rd, %l3 									!Format string with "rd"
	ba 		next 										!Skip to next 
	nop 												!Delay slot, cannot be optimized
	
fourth:
	set 	th, %l3										!Format string with "th"
	ba 		next 										!Skip to next 
	nop													!Delay slot, cannot be optimized
	
next: 
	
	!PRINT FINAL OUTPUT
	set 	fmt, %o0									!1st argument to printf
	mov 	%l0, %o1 									!2nd argument to printf
	mov 	%l1, %o2 									!3rd argument to printf
	mov 	%l3, %o3									!4th argument to printf
	call 	printf										!Call printf 
	mov 	%l2, %o4									!Delay slot, 5th argument to printf
	
	mov 	1, %g1										!Ends program 
	ta		0 											!Ends program 
	
argumenterror: 
	
	!PRINT ERROR MESSAGE 
	set 	errorprint2, %o0 							!Get error message 
	call 	printf										!Calls printf 
	nop 												!Delay slot, cannot be optimized
	
	mov 	1, %g1 										!Ends program 
	ta 		0 											!Ends program 
	
error: 
	
	!PRINT ERROR MESSAGE 
	set 	errorprint, %o0 							!Get error message 
	call 	printf										!Calls printf 
	nop 												!Delay slot, cannot be optimized
	
	mov 	1, %g1 										!Ends program 
	ta 		0 											!Ends program 
	
	
