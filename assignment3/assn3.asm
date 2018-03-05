;=================================================
; Name: Lee, Thomas
; Email: tlee066@ucr.edu
; 
; Assignment name: Assignment 3
; Lab section: xx
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team.
;
;=================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, Convert_addr		; R6 <-- Address pointer for Convert
LDR R1, R6, #0			; R1 <-- VARIABLE Convert 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
LD R2, NEWLINE_CNT		;newline counter, starts at 16
				;this is the overall counter for the program
				;which will see if we've printed all 16 bits
				;of the number
LD R4, SPACE_CNT		;space counter, starts at 4
LD R5, NEWLINE_CNT		;added another counter to keep program from
				;outputting an extra space at the end


				;this is the biggest loop, like main in c++
				;reads MSB and sends to print pos/neg branches
PRINT_SHIFT_LOOP		
    ADD R1,R1,#0		;resets R1
    BRzp PRINT_ZERO		;if left shifted number is pos, print a zero
    ADD R1,R1,#0		;resets R1
    BRn PRINT_ONE		;if left shifted number is neg, print a one


PRINT_ZERO			;this branch prints a zero
    LD R0,ZERO			;load zero and output
    OUT
    ADD R1,R1,R1		;left shift
    ADD R5,R5,#-1		;extra space decrement
    BRz PRINT_NEWLINE
    ADD R4,R4,#-1		;decrement space counter by 1
    BRz PRINT_SPACE		;if we've printed 4 numbers, print a space
    ADD R2,R2,#-1
    BRp PRINT_SHIFT_LOOP	;if we haven't printed 16 bits, go to beginning


PRINT_ONE			;this branch prints a one
    LD R0,ONE			;load one and output
    OUT
    ADD R1,R1,R1		;left shift
    ADD R5,R5,#-1		;extra space decrement
    BRz PRINT_NEWLINE
    ADD R4,R4,#-1		;decrement space counter by 1
    BRz PRINT_SPACE		;if we've printed 4 numbers, print a space
    ADD R2,R2,#-1
    BRp PRINT_SHIFT_LOOP	;if we haven't printed 16 bits, go to beginning

PRINT_SPACE			;this branch prints a space
    LEA R0,SPACE		;load space string and output
    PUTS
    LD R4,SPACE_CNT		;resets space counter to 4
    ADD R1,R1,#0		;reset R1
    ADD R3,R2,#0		;using register 3 to check if we've printed 16 bits
    BRp PRINT_SHIFT_LOOP	;if value is not zero, continue printing


PRINT_NEWLINE			;end of program, end with a newline
    LEA R0,NEWLINE
    PUTS
    



HALT
;---------------	
;Data
;---------------
Convert_addr .FILL xD000	; The address of where to find the data


NEWLINE_CNT .FILL #16		;newline counter
SPACE_CNT .FILL #4		;space counter
ZERO .FILL #48			;zero string for output
ONE .FILL #49			;one string for output
NEWLINE .STRINGZ "\n"


SPACE .STRINGZ " "		;space string

.ORIG xD000			; Remote data
Convert .FILL #-32768		; <----!!!NUMBER TO BE CONVERTED TO BINARY!!!
;---------------	
;END of PROGRAM
;---------------	
.END
