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

LEA    R0,prompt1
PUTS
GETC
OUT
LEA    R0,newline
PUTS
LD    R1,ADDR_SUB_STACK_PUSH
JSRR  R1
LEA    R0,prompt2
PUTS
GETC
OUT
LEA    R0,newline
PUTS
LD    R1,ADDR_SUB_STACK_PUSH
JSRR  R1
LEA    R0,prompt3
PUTS
GETC
OUT
LEA    R0,newline
PUTS
LD    R1,ADDR_SUB_RPN_MULTIPLY
JSRR  R1
LEA   R0,result1
PUTS
ADD   R2,R4,#0
LD    R1,ADDR_SUB_PRINT_DECIMAL
JSRR  R1

HALT
;---------------
;Local Data
;---------------
ADDR_SUB_STACK_PUSH .FILL x3200
ADDR_SUB_STACK_POP .FILL x3400
ADDR_SUB_RPN_MULTIPLY .FILL x3600
ADDR_SUB_PRINT_DECIMAL .FILL x4800
BASE .FILL xA000
MAX .FILL xA005
TOS .FILL xA000
prompt1 .STRINGZ "Enter a single-digit number: "
prompt2 .STRINGZ "Enter another single-digit number: "
prompt3 .STRINGZ "Enter an operand (+,-,*,/): "
result1 .STRINGZ "The result is "
newline .STRINGZ "\n"

;-----------------
;SUB_STACK_PUSH
;-----------------
.orig x3200
    ST    R7,BACKUP_R7_3200

    ADD   R2,R5,#0
    NOT   R3,R6
    ADD   R3,R3,#1
    ADD   R3,R3,R2
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
    ADD   R6,R6,#-1
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

;------------------
;SUB_RPN_MULTIPLY
;------------------
.orig x3600
    ST    R7,BACKUP_R7_3600

    ST    R6,STORE_TOS
    LD    R1,PTR_POP
    JSRR  R1
    LD    R7,STORE_TOS
    ADD   R7,R7,#-1
    
    AND   R2,R2,#0
    ADD   R6,R6,#0
    BRz   POST_MULTIPLY

MULTIPLY
    ADD   R2,R2,R2
    ADD   R0,R0,#-1
    BRp   MULTIPLY

POST_MULTIPLY
    LD    R6,STORE_TOS
    LD    R1,PTR_POP
    JSRR  R1
    LD    R7,STORE_TOS
    ADD   R7,R7,#-1
    ST    R7,STORE_TOS

    LD    R1,PTR_PUSH
    ADD   R0,R2,#0
    LD    R6,STORE_TOS
    JSRR  R1
    
RET
;---------------------
;STACK_RPN_MULT Data
;---------------------
BACKUP_R7_3600 .BLKW #1
PTR_PUSH .FILL x3200
PTR_POP .FILL x3400
STORE_TOS .BLKW #1

.orig xA000
    STACK .BLKW #5

;---------------------
;SUB_PRINT_DECIMAL
;---------------------
.orig x4800
ST R7, Backup_R7_4800
LD R3,COUNTER
ADD R5,R2,#0
ADD R6,R5,#0 ;continuous backup for original input

TEN_THOUSANDS
    LD R2, MINUS_10k
    ADD R5,R5,R2
    BRzp COUNT1
    LD R0, ASCII
    ADD R0,R0,R3
    ADD R3,R3,#0
    BRz IF_ZERO_1
    OUT
  IF_ZERO_1
    ADD R5,R6,#0
    LD R3, COUNTER
    BRnzp THOUSANDS
  COUNT1
    ADD R6,R5,#0
    ADD R3,R3,#1
    BRnzp TEN_THOUSANDS

THOUSANDS
    LD R2, MINUS_1k
    ADD R5,R5,R2
    BRzp COUNT2
    LD R0, ASCII
    ADD R0,R0,R3
    ADD R3,R3,#0
    BRz IF_ZERO_2
    OUT
  IF_ZERO_2
    ADD R5,R6,#0
    LD R3, COUNTER
    BRnzp HUNDREDS
  COUNT2
    ADD R6,R5,#0
    ADD R3,R3,#1
    BRnzp THOUSANDS

HUNDREDS
    LD R2, MINUS_100
    ADD R5,R5,R2
    BRzp COUNT3
    LD R0, ASCII
    ADD R0,R0,R3
    ADD R3,R3,#0
    BRz IF_ZERO_3
    OUT
  IF_ZERO_3
    ADD R5,R6,#0
    LD R3, COUNTER
    BRnzp TENS
  COUNT3
    ADD R6,R5,#0
    ADD R3,R3,#1
    BRnzp HUNDREDS

TENS
    LD R2, MINUS_10
    ADD R5,R5,R2
    BRzp COUNT4
    LD R0, ASCII
    ADD R0,R0,R3
    ADD R3,R3,#0
    BRz IF_ZERO_4
    OUT
  IF_ZERO_4
    ADD R5,R6,#0
    LD R3, COUNTER
    BRnzp ONES
  COUNT4
    ADD R6,R5,#0
    ADD R3,R3,#1
    BRnzp TENS

ONES
    LD R0, ASCII
    ADD R0,R0,R5
    OUT
    BRnzp RETURN_PRINT_NUM

RETURN_PRINT_NUM
    AND R0,R0,#0
    AND R2,R2,#0
    AND R3,R3,#0
    AND R5,R5,#0
    AND R6,R6,#0
    LD R7, Backup_R7_4800

RET
;--------------------------------
;Data for subroutine print number
;--------------------------------
Backup_R7_4800 .BLKW #1
ASCII .FILL #48
MINUS_10k .FILL #-10000
MINUS_1k .FILL  #-1000
MINUS_100 .FILL #-100
MINUS_10 .FILL #-10
COUNTER .FILL #0

.end