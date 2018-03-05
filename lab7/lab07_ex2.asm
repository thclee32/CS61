;=================================================
; Name: Lee, Thomas
; Email:  tlee066@ucr.edu
; 
; Lab: lab 7
; Lab section: xx
; TA: Jason Goulding
; 
;=================================================
.orig x3000
;-------------
;Instructions
;-------------
LEA R0, Prompt
PUTS
LD R0, NEWLINE
OUT

LD R1, count_Ones
JSRR R1

LD R0, NEWLINE
OUT

LEA R0, num_Ones
PUTS

LD R0, ASCII
ADD R0,R0,R3
OUT

LD R0, NEWLINE
OUT

HALT
;-------------
;Local Data
;-------------
count_Ones .FILL x3200
NEWLINE .FILL #10
ASCII .FILL #48
Prompt .STRINGZ "Enter any single character: "
num_Ones .STRINGZ "The number of 1's is: "
;-------------
;Count 1's
;-------------
.orig x3200
ST R7, Backup_R7_3200
LD R3, COUNTER
LD R4, BIN_COUNT


GETC
OUT

AND R1,R1,#0
ADD R1,R0,#0

CHECK
    ADD R1,R1,#0
    BRzp IS_ZERO
    ADD R1,R1,#0
    BRn IS_ONE

IS_ZERO
    ADD R1,R1,R1
    ADD R4,R4,#-1
    BRz END
    BRp CHECK

IS_ONE
    ADD R1,R1,R1
    ADD R3,R3,#1
    ADD R4,R4,#-1
    BRz END
    BRp CHECK

END
  
LD R7, Backup_R7_3200

RET
;---------------
;Count 1's Data
;---------------
Backup_R7_3200 .BLKW #1
BIN_COUNT .FILL #16
COUNTER .FILL #0
;----------------
;End of Program
;----------------
.END