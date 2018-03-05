;=================================================
; Name: Lee, Thomas
; Email:  tlee066@ucr.edu
; 
; Lab: lab 4
; Lab section: xx
; TA: Jason Goulding
; 
;=================================================

;Instructions
;-----------------------------------
.orig x3000


LD R1,COUNT
ADD R1,R1,#10			;using R1 as counter, start at 10
LEA R2,ARRAY

DO_WHILE_LOOP
    GETC			;get character from user
    STR R0,R2,#0		;put character into array
    

    ADD R2,R2,#1		;increment array pointer by 1
    ADD R1,R1,#-1		;decrement counter, run loop until it reaches 0
    BRp DO_WHILE_LOOP
END_DO_WHILE_LOOP

LD R0,NEWLINE			;output newline before output
OUT
  

LD R1,COUNT
ADD R1,R1,#10			;start counter at 10
LEA R2,ARRAY			;load first array address into r2


    PRINT_LOOP
	LDR R0,R2,#0		;put r2 contents into r0
        OUT			;output

        
        LD R0,NEWLINE		;newline
        OUT

        
        ADD R2,R2,#1		;next value in array
        ADD R1,R1,#-1		;count down to 0
        BRp PRINT_LOOP
    END_PRINT_LOOP



HALT



;-----------------------------------
;Local data
;-----------------------------------
ARRAY	.BLKW	#10
COUNT 	.FILL	#0

NEWLINE	.STRINGZ "\n"

.end