;=================================================
; Name: Lee, Thomas
; Email:  tlee066@ucr.edu
; 
; Lab: lab 8
; Lab section: xx
; TA: Jason Goulding
;=================================================
.orig x3000
;---------------------
;Instructions
;----------------------
LEA R0,PROMPT
PUTS

LD R0,NEWLINE
OUT

LD R0,PTR_ARRAY

LD R1,GET_STRING_PTR
JSRR R1

PUTS

LD R0,NEWLINE
OUT


HALT
;---------------------
;local data
;---------------------
PROMPT .STRINGZ "Enter a string terminated by the ENTER key."
GET_STRING_PTR .FILL x3200
NEWLINE .FILL #10
PTR_ARRAY .FILL x4000


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