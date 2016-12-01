!AUTHOR: Shannon TJ 10101385
!VERSION: Nov 9, 2015

!PROGRAM DESCRIPTION:

include(macro_defs.m)

fmtstack: 	
		.asciz "### Stack Operations ###\n\n" 								!global data for printf statement 
		.align 4 	
fmtoptions: 	
		.asciz "Press 1 - Push, 2 - Pop, 3 - Display, 4 - Exit\n" 			!global data for printf statement 
		.align 4 	
fmtselect: 	
		.asciz "Your option? " 												!global data for printf statement 
		.align 4 	
fmtcase1: 	
		.asciz "\nEnter the positive integer value to be pushed: " 			!global data for printf statement 
		.align 4 
fmtcase2: 	
		.asciz "\n_Popped value is %d\n" 									!global data for printf statement 
		.align 4 
fmtcase4: 	
		.asciz "\nTerminating program\n" 									!global data for printf statement 
		.align 4 
fmtdefault: 	
		.asciz "\nInvalid option! Try again.\n" 							!global data for printf statement 
		.align 4 
fmtreturn: 	
		.asciz "\nPress the return key to continue..." 						!global data for printf statement 
		.align 4 
fmtoverflow: 	
		.asciz "\nPress the return key to continue..." 						!global data for printf statement 
		.align 4 
