;=================================================
; Name: Lee, Thomas
; Email:  tlee066@ucr.edu
; 
; Lab: lab 5
; Lab section: xx
; TA: Jason Goulding
; 5;=================================================
;Instructions
;----------------------------
.orig x3000

LD R3,ARRAY_PTR		;loads first array address into r2
LD R1,NUMBER_ONE	;loads 1 into r1
LD R4,POPULATE_CNT	;counter starting at 10
LD R5,#48

POPULATE_LOOP		;populate array 
    STR R1,R3,#0	;stores r1 into r3
    ADD R1,R1,R1	;increment number to be put in (increasing by one power)
    ADD R3,R3,#1
    ADD R4,R4,#-1	;increment array address
    BRp POPULATE_LOOP	;go back if counter hasn't reached zero
    
LD R3,ARRAY_PTR
LDR R1,R3,#0
LD R2, NEWLINE_CNT		;newline counter, starts at 16
				;this is the overall counter for the program
				;which will see if we've printed all 16 bits
				;of the number
LD R4, SPACE_CNT		;space counter, starts at 4
LD R5, NEWLINE_CNT		;added another counter to keep program from
				;outputting an extra space at the end
LD R6,POPULATE_CNT		;starts at 10, decrements until all 10 
				;values in array are printed


PRINT_B
    LEA R0,CHAR_B
    PUTS
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
    ADD R7,R2,#0		;using register 7 to check if we've printed 16 bits
    BRp PRINT_SHIFT_LOOP	;if value is not zero, continue printing


PRINT_NEWLINE			;print newline at end
    LEA R0,NEWLINE
    PUTS


    LD R5,NEWLINE_CNT
    ADD R3,R3,#1
    LDR R1,R3,#0
    LD R4,SPACE_CNT
    LD R2,NEWLINE_CNT
    ADD R6,R6,#-1			;decrement r6
    BRp PRINT_B

LEA R0,NEWLINE
PUTS


    


HALT
;-------------------
;Local data
;-------------------
NUMBER_ONE .FILL #1
NEWLINE .STRINGZ "\n"
POPULATE_CNT .FILL #10
ARRAY_PTR .FILL x4000

NEWLINE_CNT .FILL #16
SPACE_CNT .FILL #4
ZERO .FILL #48
ONE .FILL #49
CHAR_B .STRINGZ "b"

SPACE .STRINGZ " "


;------------------
;Remote data
;-----------------
.orig x4000
ARRAY .BLKW #10

.end