;=================================================
; Name: Lee, Thomas
; Email:  tlee066@ucr.edu
; 
; Lab: lab 9
; Lab section: xx
; TA: Jason Goulding
; 
;=================================================
.orig x3000
;---------------
;Instructions
;---------------
LD    R4,BASE
LD    R5,MAX
LD    R6,TOS

ADD   R0,R0,#1

LD    R1,ADDR_SUB_STACK_PUSH
JSRR  R1
ST    R6,TOS
ADD   R0,R0,#1

JSRR  R1
ST    R6,TOS
ADD   R0,R0,#1

JSRR  R1
ST    R6,TOS
ADD   R0,R0,#1

LD    R1,ADDR_SUB_STACK_POP
JSRR R1
ADD R6,R6,#-1
ST R6,TOS

JSRR R1
ADD R6,R6,#-1
ST R6,TOS

JSRR R1
ADD R6,R6,#-1
ST R6,TOS

HALT
;---------------
;Local Data
;---------------
ADDR_SUB_STACK_PUSH .FILL x3200
ADDR_SUB_STACK_POP .FILL x3400
BASE .FILL xA000
MAX .FILL xA005
TOS .FILL xA000

;-----------------
;SUB_STACK_PUSH
;-----------------
.orig x3200
    ST    R7,BACKUP_R7_3200

    NOT   R3,R6
    ADD   R3,R3,#1
    ADD   R3,R3,R5
    BRnz  OVERFLOW
    ADD R6,R6,#1
    STR   R0,R6,#0
    BRnzp END_PUSH

OVERFLOW
    LEA   R0,OVERFLOW_ERROR
    PUTS
END_PUSH
    LD    R7,BACKUP_R7_3200

RET
;-----------------
;STACK_PUSH Data
;-----------------
BACKUP_R7_3200 .BLKW #1
OVERFLOW_ERROR .STRINGZ "Error:Overflow!\n"

.orig xA000
    STACK .BLKW #5

;---------------
;SUB_STACK_POP
;---------------
.orig x3400
    ST    R7,BACKUP_R7_3400

    NOT   R3,R6
    ADD   R3,R3,#1
    ADD   R3,R3,R4
    BRz   UNDERFLOW
    LDR   R0,R6,#0
    BRnzp END_POP

UNDERFLOW
    LEA   R0,UNDERFLOW_ERROR
    PUTS
END_POP
    LD R7,BACKUP_R7_3400

RET
;----------------
;STACK_POP DATA
;----------------
BACKUP_R7_3400 .BLKW #1
UNDERFLOW_ERROR .STRINGZ "Error:Underflow!\n"


.end