;=================================================
; Name: Lee, Thomas
; Email: tlee066@ucr.edu
; 
; Assignment name: Assignment 2
; Lab section: xx
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team.
;
;=================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------

;----------------------------------------------
;outputs prompt
;----------------------------------------------	
LEA R0, intro			; 
PUTS				; Invokes BIOS routine to output string


;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
GETC				;receives first number and outputs
OUT
ADD R1,R0,#0			;stores first number in R1
LEA R0, NEWLINE
PUTS


GETC				;receives second number and outputs
OUT
ADD R2,R0,#0			;stores second number in R2
LEA R0,NEWLINE
PUTS


ADD R0,R1,#0			;stores first number in R0 for output
OUT
LEA R0,SUBTRACT			;stores "-" character in R0 for output
PUTS
ADD R0,R2,#0			;stores second number in R0 for output
OUT
LEA R0,EQUALS			;stores "=" character in R0 for output
PUTS

;Convert ascii into binary
ADD R1,R1,#-12
ADD R1,R1,#-12
ADD R1,R1,#-12
ADD R1,R1,#-12


ADD R2,R2,#-12
ADD R2,R2,#-12
ADD R2,R2,#-12
ADD R2,R2,#-12

NOT R3,R2
ADD R3,R3,#1

;Perform subtraction operation, branch into positive or negative results
ADD R4,R1,R3
ADD R4,R4,#0
BRn negative
ADD R4,R4,#0
BRzp positive

;positive or negative conversion, then output
negative
    NOT R4,R4
    ADD R4,R4,#1
    ADD R4,R4,#12
    ADD R4,R4,#12
    ADD R4,R4,#12
    ADD R4,R4,#12
    LEA R0,NEGATIVE
    PUTS
    ADD R0,R4,#0
    OUT
 
BRp end

positive
    ADD R4,R4,#12
    ADD R4,R4,#12
    ADD R4,R4,#12
    ADD R4,R4,#12
    ADD R0,R4,#0
    OUT
    
end

LEA R0,NEWLINE			;end program with newline
PUTS



HALT				; Stop execution of program
;------	
;Data
;------
; String to explain what to input 
intro .STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 
NEWLINE .STRINGZ "\n"	; String that holds the newline character
NEGATIVE .STRINGZ "-"
SUBTRACT .STRINGZ " - "
EQUALS .STRINGZ " = "

DEC_POS .FILL #48	;for converting between ascii and decimal,
DEC_NEG .FILL #-48	;but it says it overflows a 5-bit variable.

;---------------	
;END of PROGRAM
;---------------	
.END

