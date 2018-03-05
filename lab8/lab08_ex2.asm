;=================================================
; Name: Lee, Thomas
; Email:  tlee066@ucr.edu
; 
; Lab: lab 8
; Lab section: xx
; TA: Jason Goulding
; 
;=================================================
.orig x3000
;--------------
;instructions
;--------------
LD R0,PTR_ARRAY

LD R1,PTR_GET_STRING

JSRR R1

PUTS

LD R1,PTR_IS_A_PALINDROME
JSRR R1

LD R0,NEWLINE

OUT



HALT
;---------------
;local data
;---------------
PTR_ARRAY .FILL x4000
PTR_GET_STRING .FILL x3200
PTR_IS_A_PALINDROME .FILL x3400
NEWLINE .FILL #10


;-------------------
;SUB_GET_STRING
;-------------------
.orig x3200
ST R7,BACKUP_R7_3200
ST R0,BACKUP_R0_3200
ST R1,BACKUP_R1_3200
ST R2,BACKUP_R2_3200


ADD R2,R0,#0		;put array address somewhere else to use getc and out
LD R1,LENGTH_COUNT	;start length counter at 0
LD R3,NEGNEWLINE	;store newline check in r3

GET_STRING_LOOP_3200
    GETC
    OUT		;echos to console if you want
    
    ADD R6,R0,#0
    ADD R6,R6,R3	;using r6 to check for newline
    BRz END_NULL_3200	;if zero, then it is a newline. send to end_null
    
    STR R0,R2,#0	;store char into array
    ADD R2,R2,#1	;increment array address
    ADD R1,R1,#1 	;increment counter
    BRnp GET_STRING_LOOP_3200	;if not zero, get another input


END_NULL_3200
    ADD R5,R1,#0	;store length of array into r5
    LD R3,NULL		
    STR R3,R2,#0	;store null into last part of array


LD R7,BACKUP_R7_3200	
LD R0,BACKUP_R0_3200
LD R1,BACKUP_R1_3200
LD R2,BACKUP_R2_3200

RET
;------------------
;subroutine data
;------------------
BACKUP_R7_3200 .BLKW #1
BACKUP_R0_3200 .BLKW #1
BACKUP_R1_3200 .BLKW #1
BACKUP_R2_3200 .BLKW #1
LENGTH_COUNT .FILL #0
NEGNEWLINE .FILL #-10
NULL .FILL #0



;------------------
;SUB_IS_A_PALINDROME
;------------------
.orig x3400

ST R0,BACKUP_R0_3400
ST R7,BACKUP_R7_3400

AND R1,R1,#0
AND R3,R3,#0
ADD R4,R4,#1

ADD R6,R5,R0		;make r6 end last character in array
ADD R6,R6,#-1

PALINDROME
    LDR R1,R0,#0
    LDR R3,R6,#0
    NOT R3,R3
    ADD R3,R3,#1
    ADD R1,R1,R3
    BRnp NOT_PALINDROME
    ADD R0,R0,#1
    ADD R6,R6,#-1
    ADD R5,R5,#-1
    BRnp PALINDROME
    BRz END


NOT_PALINDROME
    AND R4,R4,#0

END
    LD R0,NEWLINEE
    OUT
    LD R0,ASCII
    ADD R0,R0,R4
    OUT

LD R0,BACKUP_R0_3400
LD R7,BACKUP_R7_3400

RET

;-------------------
;subroutine 2 data
;-------------------
BACKUP_R0_3400 .BLKW #1
BACKUP_R7_3400 .BLKW #1
ASCII .FILL #48
NEWLINEE .FILL #10


.end