;=================================================
; Name: Lee, Thomas
; Email:  tlee066@ucr.edu
; 
; Lab: lab 6
; Lab section: xx
; TA: Jason Goulding
;=================================================
;instructions
;-----------------------------------------
.orig x3000

LEA R0,PROMPT
PUTS


INPUTLOOP
    LD R3,PTR_3200
    JSRR R3
    
END_INPUTLOOP


HALT
;--------------
;local data
;--------------
PROMPT .STRINGZ "Enter a 16-bit binary number starting with b"
PTR_3200 .FILL x3200
CNT .FILL #16

;--------------------
;subroutine 1 get characters and put into R2
;--------------------
.orig x3200
ST R7,BACKUP_R7_3200
ST R5,BACKUP_R5_3200
ST R3,BACKUP_R3_3200

;GETC
;ADD R2,R2,R2
;ADD R2,R2,R0

LD R2,DEC_0

LD R5,COUNTER

GETC_LOOP		;gets user input of 16 bits, pushes one by one into R2
    GETC 
    ADD R2,R2,R2
    ADD R2,R2,R0
    ADD R5,R5,#-1
    BRp GETC_LOOP

END_GETC_LOOP




LD R7,BACKUP_R7_3200
LD R5,BACKUP_R5_3200
LD R3,BACKUP_R3_3200

;--------------------
;subroutine data
;--------------------
BACKUP_R7_3200 .BLKW #1
BACKUP_R3_3200 .BLKW #1
BACKUP_R5_3200 .BLKW #1
COUNTER .FILL #16
DEC_0 .FILL #0



;--------------------
;remote data
;--------------------
.orig x4000

.end