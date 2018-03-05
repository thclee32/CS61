;=================================================
; Name: Lee, Thomas
; Email:  tlee066@ucr.edu
; 
; Lab: lab 6
; Lab section: xx
; TA: Jason Goulding
;=================================================
;Instructions
;--------------------------

.orig x3000
LD R3,DATA_PTR
LD R4,VALUE
LD R5,CNT

LOOP
    STR R4,R3,#0
    ADD R3,R3,#0
    ADD R4,R4,R4
    ADD R5,R5,#-1
    BRnp LOOP

LD R3,DATA_PTR
LD R5,CNT

PRINT
    LD R1,PTR_3200
    JSRR R1
    ADD R3,R3,#1
    ADD R5,R5,#-1
    BRp PRINT




HALT


;------------
;local data
;------------
CNT .FILL #10
VALUE .FILL #1
DATA_PTR .FILL ARRAY
PTR_3200 .FILL x3200

;------------------
;subroutine
;------------------
.orig x3200

ST R7,BACKUP_R7_3200
ST R3,BACKUP_R3_3200
ST R3,BACKUP_R4_3200
LDR R1,R3,#0

LD R2,NEWLINE_CNT
LD R4,SPACE_CNT
LD R5,NEWLINE_CNT




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


LD R3,BACKUP_R3_3200
LD R4,BACKUP_R4_3200
LD R7,BACKUP_R7_3200
;--------------------
;subroutine data
;--------------------
BACKUP_R7_3200 .BLKW #1
BACKUP_R3_3200 .BLKW #1
BACKUP_R4_3200 .BLKW #1
NEWLINE_CNT .FILL #16
SPACE_CNT .FILL #4
ZERO .FILL #48
ONE .FILL #49
CHAR_B .STRINGZ "b"
SPACE .STRINGZ " "
NEWLINE .STRINGZ "\n"

;--------------------
;remote data
;--------------------
.orig x4000
ARRAY .BLKW #10

.end
