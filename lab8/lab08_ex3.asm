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
;Instructions
;--------------
LD R0, PTR_ARRAY

LD R1, PTR_GET_STRING
JSRR R1

PUTS

LD R1, PTR_IS_A_PALINDROME
JSRR R1

LD R0, NEWLINE
OUT

HALT
;--------------
;Local Data
;--------------
PTR_ARRAY .FILL x4000
PTR_GET_STRING .FILL x3200
PTR_IS_A_PALINDROME .FILL x3400
NEWLINE .FILL #10

;---------------
;SUB_GET_STRING
;---------------
.orig x3200

ST R0, BACKUP_R0_3200
ST R7, BACKUP_R7_3200

LD R3, MINUS_10
ADD R1,R0,#0

STORE
    GETC
    OUT
    ADD R6,R0,#0
    ADD R6,R6,R3
    BRz STORE_NULL

    ADD R5,R5,#1
    STR R0,R1,#0
    ADD R1,R1,#1
    ADD R0,R0,R3
    BRnp STORE

STORE_NULL
  LD R3, NULL
  STR R3,R1,#0

LD R0, BACKUP_R0_3200
LD R7, BACKUP_R7_3200

RET
;--------------------
;subroutine data
;--------------------
BACKUP_R0_3200 .BLKW #1
BACKUP_R7_3200 .BLKW #1
MINUS_10 .FILL #-10
NULL .FILL #0

;-------------
;SUB_IS_A_PALINDROME
;-------------
.orig x3400

ST R0, BACKUP_R0_3400
ST R5, BACKUP_R5_3400
ST R7, BACKUP_R7_3400

AND R1,R1,#0
AND R3,R3,#0
ADD R4,R4,#1 ;palindrome flag

ADD R6,R5,R0 ;make r6 end last character in the array
ADD R6,R6,#-1

CHECK_UPPERCASE
    LDR R1,R0,#0
    LD R2,NEG97
    ADD R1,R1,R2
    BRzp CHANGE_TO_UPPERCASE
    BRn IS_ALREADY_UPPERCASE

TEST
    LD R0,BACKUP_R0_3400
    LD R5,BACKUP_R5_3400

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
    AND R4,R4,R0

CHANGE_TO_UPPERCASE
    LDR R1,R0,#0
    LD R2,NEG32
    ADD R1,R1,R2
    STR R1,R0,#0
    ADD R0,R0,#1
    ADD R5,R5,#-1
    BRp CHECK_UPPERCASE
    BRz TEST

IS_ALREADY_UPPERCASE
    ADD R0,R0,#1
    ADD R5,R5,#-1
    BRp CHECK_UPPERCASE
    BRz TEST

END
    LD R0,NEWLINEE
    OUT
    LD R0,ASCII
    ADD R0,R0,R4
    OUT
    
LD R0, BACKUP_R0_3400
LD R5, BACKUP_R5_3400
LD R7, BACKUP_R7_3400

RET


;-------------------------
;SUB_IS_A_PALINDROME Data
;-------------------------
BACKUP_R0_3400 .BLKW #1
BACKUP_R5_3400 .BLKW #1
BACKUP_R7_3400 .BLKW #1
ASCII .FILL #48
NEWLINEE .FILL #10
NEG32 .FILL #-32
NEG97 .FILL #-97


.end