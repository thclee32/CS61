;=================================================
; Name: Lee, Thomas
; Email: tlee066@ucr.edu
; 
; Assignment name: Assignment 4
; Lab section: xxx
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team.
;
;=================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------

;-------------------------------
;INSERT CODE STARTING FROM HERE 
;--------------------------------
;Example of how to Output Intro Message
;LD R0, introMessage  ;Output Intro Message
;PUTS

;Example of how to Output Error Message
;LD R0, errorMessage  ;Output Error Message
;PUTS

START 			;very beginning with intro message and all

;PROGRAM PREPARATION
AND R5,R5,#0		;CLEAR R5 to hold number
AND R4,R4,#0		;clear r4 to hold sign bit
AND R3,R3,#0		;clear r3 for symbol bit
LD R6,COUNTER


;INTRO MESSAGE
LD R0, introMessage
PUTS

;START OF PROGRAM	beginning of the inputs
LOOP
    GETC		;input char to R0, send it to output_char
    ADD R1,R0,#0
    LD R7,NEGNEWLINE
    ADD R1,R1,R7
    BRnp OUTPUT_CHAR

OUTPUT_CHAR		;echo char in R0
    OUT		
    BRnzp INPUT_CHAR	;send to input_char

INPUT_CHAR		;sends inputted number to r5
			;less than 48

    ADD R1,R0,#0	;copy char to R1
    LD R7,NEG48		;load -48 to check value
    ADD R1,R1,R7	;put char - 48 into r1
    BRn OTHER_CHAR	;if result is negative, then inputted char is less than 48 (zero)

			;greater than 57

    ADD R1,R0,#0	;copy char into R1
    LD R7,NEG57		;load -57 to check value
    ADD R1,R1,R7	;put char - 57 into r1
    BRp INVALID_CHAR	;if result is positive, then inputted char is greater than 57 (9)

;at this point char is between 48 and 57

			;if first char is a number

    ADD R1,R6,#0	;copy counter to r1
    ADD R1,R1,#-6	;subtracr 6 from counter. if zero, then only 1 char been input so far
    BRz FIRST_CHAR
			;if not first char

    ;LD R7,DEC_0
    ADD R5,R5,R5	;to multiply r5 by 10. r5 = 2x
    ADD R2,R5,R5	;r2 = 4x
    ADD R2,R2,R2	;r2 = 8x
    ADD R5,R5,R2	;r5 = 8x + 2x

			;add input to r5

    LD R7,NEG48		;load -48 to convert to decimal
    ADD R0,R0,R7	;convert to decimal
    ADD R5,R5,R0	; x10 + number (from specs)
    
    ADD R6,R6,#-1	;decrement counter
    BRp LOOP		;if not zero, go back for more inputs
    BRz CHECK_NEG	;if zero, then we have max inputs and go to check if we need to
			;do two's complement




FIRST_CHAR
    LD R7,NEG48
    ADD R0,R0,R7	;convert to dec
    ADD R5,R0,R5	;put into r5
    ADD R6,R6,#-2	;decrement by 1, and then another because of lack of sign bit
    BRnzp LOOP		;get next input


OTHER_CHAR
			;check if positive symbol
    LD R7,PLUS		;load (reverse) plus ascii to check
    ADD R1,R0,#0	;copy char into r1
    ADD R1,R1,R7	;add to see if same
    BRz PLUS_CHAR	;if zero, then it is a plus symbol. send to PLUS_CHAR

			;check if minus symbol
    LD R7,MINUS		;load (reverse) minus ascii to check
    ADD R1,R0,#0	;copy char into r1
    ADD R1,R1,R7	;add to see if same
    BRz MINUS_CHAR	;if zero, then it is a minus symbol. send to MINUS_CHAR
    
			;check if newline symbol
    LD R7,NEGNEWLINE	;load (reverse) newline ascii to check 
    ADD R1,R0,#0	;copy char into r1
    ADD R1,R1,R7	;add to see if same
    BRz NEWLINE_INPUT	;if zero, then it is a newline. send to NEWLINE_INPUT


INVALID_CHAR
			;this is an error becuase it should never be greater than 57
    ADD R1,R0,#0
    ADD R1,R1,#-10
    BRnp NEWLINE_ERROR

NEWLINE_ERROR	;output a newline before the error message
    LD R0,NEWLINE
    OUT
    BRnzp ERROR_MESSAGE	

ERROR_MESSAGE
    LD R0,errorMessage	;print error message 
    PUTS
    BRnzp START 	;start over

PLUS_CHAR
			;check if first char
    ADD R1,R6,#0	;copy counter to r1
    ADD R1,R1,#-6	;subtract 6 from counter
    BRnp INVALID_CHAR	;if not zero, then it's not the first char. send to error
    
			;if zero, then continue: this is the first char
    ADD R4,R4,#0	;set R4 to 0
    ADD R3,R3,#1	;flag for sign bit = 1
    ADD R6,R6,#-1	;decrement counter
    BRnzp LOOP		;send to get next input

MINUS_CHAR 
			;check if first char
    ADD R1,R6,#0	;copy counter to r1
    ADD R1,R1,#-6	;subtract 6 from counter
    BRnp INVALID_CHAR	;if not zero, then it's not the first char. send to error
	
			;if zero, then continue: this is the first char
    ADD R4,R4,#1	;sign bit = 1 means number is negative
    ADD R3,R3,#1	;flag for sign bit = 1
    ADD R6,R6,#-1	;decrement counter
    BRnzp LOOP		;send to get next input

NEWLINE_INPUT
			;check if it's the first char
    ADD R1,R6,#0	;copy counter to r1
    ADD R1,R1,#-6	;subtract 6 from counter
    BRz INVALID_CHAR
    
			;check second char
    ADD R1,R6,#0	;copy counter to r1
    ADD R1,R1,#-5	;subtract 5 from counter
    BRnp CHECK_NEG	;if not zero, then all good, go to check_neg

			;check symbol bit
    ADD R1,R3,#0
    ADD R1,R1,#-1	;subtract 1
    BRz INVALID_CHAR	;if value is 0, symbol was 1 and 1st char is a sign followed by newline

    BRnp CHECK_NEG	;if symbol bit is 0 then continue

TWO_COMPLEMENT
    NOT R5,R5
    ADD R5,R5,#1
    BRnzp END

CHECK_NEG
    ADD R1,R4,#0	;copy sign bit to r1
    ADD R1,R1,#-1	;-1 from sign bit
    BRz TWO_COMPLEMENT	;if value is 0, then sign bit was 1 and number is negative.

END
    LD R0,NEWLINE 
    OUT


HALT
;---------------	
;Data
;---------------
DEC_0 .FILL #0
DEC_10 .FILL #9
COUNTER .FILL #6
NEG48 .FILL #-48
NEG57 .FILL #-57
PLUS .FILL #-43
MINUS .FILL #-45
NEWLINE .FILL #10
NEGNEWLINE .FILL #-10

introMessage .FILL x6000
errorMessage .FILL x6100

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
;-------------------
;PURPOSE of PROGRAM
;-------------------
