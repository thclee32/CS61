;=================================================
; Name: Lee, Thomas
; Email: tlee066@ucr.edu
; 
; Lab: lab 7
; Lab section: xx
; TA: Jason Goulding
;=================================================
.orig x3000

;--------------
;Instructions
;--------------

  LD R1, Subroutine_1_3200
  JSRR R1

  ADD R5,R5,#1

  LD R1, Subroutine_2_3400
  JSRR R1

HALT
;--------------
;Local Data
;--------------
Subroutine_1_3200 .FILL x3200
Subroutine_2_3400 .FILL x3400

;--------------
;Subroutine 1
;--------------
.orig x3200
ST R7, Backup_R7_3200

PROMPT
  LD R0, introMessage  ;Output Intro Message
  PUTS

LD R4, CHAR_COUNTER
AND R3,R3,#0	;flag for pos or neg
AND R5,R5,#0

INPUT
    GETC
    ADD R1,R0,#0
    LD R6, NEWLINE
    ADD R1,R1,R6
    BRnp OUTPUT
 
CHECK
    ADD R1,R0,#0
    LD R2,MINUS_48
    ADD R1,R1,R2
    BRn LESSTHAN_48
    ADD R1,R0,#0
    LD R2,MINUS_57
    ADD R1,R1,R2
    BRp GREATERTHAN_57

    ADD R1,R4,#0
    ADD R1,R1,#-6
    BRz FIRST_CHAR	;Checks first character

    ADD R5,R5,R5	;Mulitply R5 by 10
    ADD R6,R5,R5
    ADD R6,R6,R6
    ADD R5,R5,R6
    
    LD R2, MINUS_48
    ADD R0,R0,R2
    ADD R5,R5,R0
    ADD R4,R4,#-1
    BRp INPUT
    BRz CHECK_SIGN

OUTPUT
    OUT
    BRnzp CHECK

LESSTHAN_48
    LD R2,POS
    ADD R1,R0,#0
    ADD R1,R1,R2
    BRz IF_POS
    LD R2,NEG
    ADD R1,R0,#0
    ADD R1,R1,R2
    BRz IF_NEG
    LD R2,NEWLINE
    ADD R1,R0,#0
    ADD R1,R1,R2
    BRz IF_NEWLINE

GREATERTHAN_57
    ADD R1,R0,#0
    BRnp ERROR

FIRST_CHAR
    LD R2, MINUS_48
    ADD R0,R0,R2
    ADD R5,R0,R5
    ADD R4,R4,#-2
    BRnzp INPUT

IF_POS
    ADD R1,R4,#0
    ADD R1,R1,#-6
    BRnp ERROR
    ADD R3,R3,#0
    BRnzp INPUT

IF_NEG
    ADD R1,R4,#0
    ADD R1,R1,#-6
    BRnp ERROR
    ADD R3,R3,#1
    BRnzp INPUT

IF_NEWLINE
    ADD R1,R4,#0
    ADD R1,R1,#-6
    BRz ERROR
    ADD R1,R4,#0
    ADD R1,R1,#-5
    BRnp CHECK_SIGN
    ADD R1,R3,#0
    ADD R1,R1,#-1
    BRz ERROR
    BRnp CHECK_SIGN

NEGATIVE
    NOT R5,R5
    ADD R5,R5,#1
    BRnzp END

ERROR
    LD R0,NEWLINE
    OUT
    LD R0, errorMessage  ;Output Error Message
    PUTS
    LD R0,NEWLINE
    OUT
    BRnzp PROMPT

CHECK_SIGN
    ADD R1,R3,#0
    ADD R1,R1,#-1
    BRz NEGATIVE

END
    LD R0, NEWLINE_CHAR
    OUT

LD R7, Backup_R7_3200

RET
;------------------
;Subroutine 1 Data
;------------------
Backup_R7_3200 .BLKW #1
POS .FILL #-43
NEG .FILL #-45
NEWLINE_CHAR .FILL #10
NEWLINE .FILL #-10
MINUS_48 .FILL #-48
MINUS_57 .FILL #-57
CHAR_COUNTER .FILL #6
introMessage .FILL x6000
errorMessage .FILL x6100

;------------------
;Subroutine 2
;------------------
.orig x3400
ST R5, Backup_R5_3400
ST R7, Backup_R7_3400

LD R3, COUNTER
AND R1,R1,#0
ADD R6,R5,#0

TEN_THOUSANDS
    LD R2, MINUS_10k
    ADD R5,R5,R2
    BRzp COUNT1
    LD R0, ASCII
    ADD R0,R0,R3
    OUT
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
    OUT
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
    OUT
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
    OUT
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
    BRnzp SR2_END

SR2_END
    LD R0, NEWLINE_CHAR2
    OUT

LD R5, Backup_R5_3400
LD R7, Backup_R7_3400

RET
;------------------
;Subroutine 2 Data
;------------------
Backup_R1_3400 .BLKW #1
Backup_R5_3400 .BLKW #1
Backup_R7_3400 .BLKW #1
ASCII .FILL #48
MINUS_10k .FILL #-10000
MINUS_1k .FILL  #-1000
MINUS_100 .FILL #-100
MINUS_10 .FILL #-10
MINUS_CHAR .FILL #45
COUNTER .FILL #0
NEWLINE_CHAR2 .FILL #10

;------------
;Remote data
;------------
.ORIG x6000
;---------------
;messages
;---------------
intro .STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
;---------------
;error_messages
;---------------
.ORIG x6100	
error_mes .STRINGZ	"ERROR INVALID INPUT\n"
;---------------
;END of PROGRAM
;---------------
.END