;=================================================
; Name: Lee, Thomas
; Email:  tlee066@ucr.edu
; 
; Lab: lab 5
; Lab section: xx
; TA: Jason Goulding
; 5;=================================================
;Instructions
;----------------------------
.orig x3000

LD R3,ARRAY_PTR		;loads first array address into r2
LD R1,NUMBER_ZERO	;loads 0 into r0
LD R4,POPULATE_CNT	;counter starting at 10

POPULATE_LOOP		;populate array 
    STR R1,R3,#0	;stores r0 into r2
    ADD R1,R1,#1	;increment number to be put in
    ADD R3,R3,#1
    ADD R4,R4,#-1	;increment array address
    BRp POPULATE_LOOP	;go back if counter hasn't reached zero
    
LD R3,ARRAY_PTR

LDR R2,R3,#6



PRINT_NEWLINE		;print newline at end
    LEA R0,NEWLINE
    PUTS

HALT
;-------------------
;Local data
;-------------------
NUMBER_ZERO .FILL #0
NEWLINE .STRINGZ "\n"
POPULATE_CNT .FILL #10
ARRAY_PTR .FILL x4000

;------------------
;Remote data
;-----------------
.orig x4000
ARRAY .BLKW #10

.end