;=================================================
; Name: Lee, Thomas
; Email: tlee066@ucr.edu    
; 
; Lab: lab 4
; Lab section: xx   
; TA: Jason Goulding
; 
;=================================================
;Instructions
;-----------------------------
.orig x3000

LD R2,ARRAY_PTR     ;load R2 with first array pointer


DO_WHILE_LOOP
    GETC 
    STR R0,R2,#0        ;store input into array pointer

    ADD R2,R2,#1        ;increment array pointer by 1

    NOT R3,R0       	;if(R0 == newline)
    ADD R3,R3,#1
    ADD R3,R3,#10
BRnp DO_WHILE_LOOP  	;if not newline, go back to DO_WHILE_LOOP


LD R2,ARRAY_PTR        	;load r0 with first array pointer
LD R3,#0


PRINT_LOOP
    LDR R0,R2,#0	;array content into r0
    OUT        	 	;output R0
    ADD R1,R0,#0   	;increment by 1 into R1	


    LD R0,NEWLINE
    OUT
    ADD R2,R2,#1

    NOT R3,R1		;if (R1==newline)
    ADD R3,R3,#1
    ADD R3,R3,#10
    BRnp PRINT_LOOP
END_PRINT_LOOP

HALT



;----------------------------
;Local data
;----------------------------
NEWLINE .FILL x0A
ARRAY_PTR .FILL x4000

.end