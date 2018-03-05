;=================================================
; Name: Lee, Thomas
; Email: tlee066@ucr.edu
; 
; Assignment name: Assignment 5
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

;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
MENU_LOOP			;everything will come back to this loop, prompting the menu subroutine
    LD R0,SUB_MENU		;go to menu subroutine
    JSRR R0
				;keeping return value in r1 for reset
    ADD R3,R1,#0		;put into r3 for manipulation to check number
    ADD R3,R3,#-1
    BRz ALL_BUSY_SUB		;if subtracting 1 makes it zero, the return value was 1.
				;go to all machines busy subroutine

    ADD R3,R1,#0		;if subtracting 2 makes it zero... etc etc
    ADD R3,R3,#-2
    BRz ALL_FREE_SUB
    
    ADD R3,R1,#0
    ADD R3,R3,#-3
    BRz NUM_BUSY_SUB
    
    ADD R3,R1,#0
    ADD R3,R3,#-4
    BRz NUM_FREE_SUB
    
    ADD R3,R1,#0
    ADD R3,R3,#-5
    BRz MACHINE_STATUS_SUB
  
    ADD R3,R1,#0
    ADD R3,R3,#-6
    BRz FIRST_FREE_SUB
    
    ADD R3,R1,#0
    ADD R3,R3,#-7
    BRz GOODBYE
    
    BRnzp MENU_LOOP		;any other number will put it back to menu loop

    

ALL_BUSY_SUB
    LD R0,SUB_ALL_MACHINES_BUSY
    JSRR R0
    ADD R2,R2,#0		;check return value
    BRz NOT_ALL_BUSY		;if zero, then send to print ALLNOTBUSY string
    LEA R0,ALLBUSY		;else print ALLBUSY string
    PUTS
    BRnzp MENU_LOOP

NOT_ALL_BUSY
    LEA R0,ALLNOTBUSY		;print ALLNOTBUSY string
    PUTS
    BRnzp MENU_LOOP


ALL_FREE_SUB
    LD R0,SUB_ALL_MACHINES_FREE
    JSRR R0
    ADD R2,R2,#0		;check return value as above, just opposite
    BRz NOT_ALL_FREE		;if zero, send to print NOTFREE string
    LEA R0,FREE			;else print FREE string
    PUTS
    BRnzp MENU_LOOP

NOT_ALL_FREE
    LEA R0,NOTFREE		;print NOTFREE string
    PUTS
    BRnzp MENU_LOOP


NUM_BUSY_SUB
    LD R0,SUB_NUM_BUSY_MACHINES
    JSRR R0
    LEA R0,BUSYMACHINE1		;print first portion of message
    PUTS
    LD R0,SUB_PRINT_NUM		
    JSRR R0			;prints number of machines

    LEA R0,BUSYMACHINE2		;print second portion of message
    PUTS
    
    BRnzp MENU_LOOP

NUM_FREE_SUB
    LD R0,SUB_NUM_FREE_MACHINES
    JSRR R0
    LEA R0,FREEMACHINE1		;as above, print first portion
    PUTS
   
    LD R0,SUB_PRINT_NUM
    JSRR R0			;print number of machines

    LEA R0,FREEMACHINE2		;print second portion of message
    PUTS
    BRnzp MENU_LOOP

MACHINE_STATUS_SUB
    LD R0,SUB_GET_INPUT
    JSRR R0
    LD R0,SUB_MACHINE_STATUS
    JSRR R0
    LEA R0,STATUS1
    PUTS
    ST R2,STATUS
    ADD R2,R1,#0
    LD R0,SUB_PRINT_NUM
    JSRR R0
    LD R2,STATUS
    BRp STATUS_FREE
    LEA R0,STATUS2
    PUTS
    BRnzp MENU_LOOP

STATUS_FREE
    LEA R0,STATUS3
    PUTS
    BRnzp MENU_LOOP

FIRST_FREE_SUB
    LD R0,SUB_FIRST_FREE
    JSRR R0
    ADD R0,R2,#-16
    BRz NONE_FREE
    LEA R0,FIRSTFREE
    PUTS
    LD R0,SUB_PRINT_NUM
    JSRR R0
    LEA R0,FIRSTFREE2
    PUTS
    BRnzp MENU_LOOP

NONE_FREE
    LEA R0,FIRSTFREE3
    PUTS
    BRnzp MENU_LOOP

GOODBYE
    LEA R0,Goodbye
    PUTS


HALT
;---------------	
;Data
;---------------
;Add address for subroutines
SUB_MENU .FILL x3200
SUB_ALL_MACHINES_BUSY .FILL x3400
SUB_ALL_MACHINES_FREE .FILL x3600
SUB_NUM_BUSY_MACHINES .FILL x3800
SUB_NUM_FREE_MACHINES .FILL x4000
SUB_MACHINE_STATUS .FILL x4200
SUB_FIRST_FREE .FILL x4400
SUB_GET_INPUT .FILL x4600
SUB_PRINT_NUM .FILL x4800


;Other data 
ASCII .FILL #48
NEWLINE_3000 .FILL #10
STATUS .FILL #0


;Strings for options
Goodbye .Stringz "Goodbye!\n"
ALLNOTBUSY .Stringz "Not all machines are busy\n"
ALLBUSY .Stringz "All machines are busy\n"
FREE .STRINGZ "All machines are free\n"
NOTFREE .STRINGZ "Not all machines are free\n"
BUSYMACHINE1 .STRINGZ "There are "
BUSYMACHINE2 .STRINGZ " busy machines\n"
FREEMACHINE1 .STRINGZ "There are "
FREEMACHINE2 .STRINGZ " free machines\n"
STATUS1 .STRINGZ "Machine "
STATUS2  .STRINGZ " is busy\n"
STATUS3 .STRINGZ " is free\n"
FIRSTFREE .STRINGZ "The first available machine is number "
FIRSTFREE2 .STRINGZ "\n"
FIRSTFREE3 .STRINGZ "No machines are free\n"


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, allowed the
;                          user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7
; no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
.orig x3200
;HINT back up 
ST R7,R7_BACKUP_3200

MENU_INTRO
    LD R0,Menu_string_addr	;print intro message
    PUTS

    GETC			;get input
    OUT				;echo
    ADD R1,R0,#0		;put input into r1
    AND R0,R0,#0		;clear r0 for newline
    ADD R0,R0,#10
    OUT
    ADD R0,R1,#0		;print newline
				;user input can only be 1 through 7
    LD R2,NEG48_3200		;load r2 with -48
    ADD R1,R1,R2		;subtract 48 from input
    ADD R1,R1,#-1		
    BRn MENU_ERROR		;lowest number should be 0. if any lower, then error
    ADD R1,R0,#0
    LD R2,NEG55_3200		;load r2 with -55
    ADD R1,R1,R2		;subtract 55 from input
    BRp MENU_ERROR		;highest number should be 0. if any higher, then error
    ADD R1,R0,#0		;passed tests, so clear r1 and store return value in r1
    LD R2,NEG48_3200
    ADD R1,R1,R2		
    BRnzp MENU_END		;send to end of this subroutine

MENU_ERROR
    LEA R0,Error_message_1	;load and print error message
    PUTS
    BRnzp MENU_INTRO		;send back to intro message for new input

MENU_END
    AND R0,R0,#0
    AND R2,R2,#0
    ;HINT Restore
    LD R7,R7_BACKUP_3200

RET
;--------------------------------
;Data for subroutine MENU
;--------------------------------
Error_message_1 .STRINGZ "INVALID INPUT\n"
Menu_string_addr .FILL x6000
NEWLINE_3200 .FILL #10
R7_BACKUP_3200 .BLKW #1
NEG48_3200 .FILL #-48
NEG55_3200 .FILL #-55



;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy,    0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------
.orig x3400
;HINT back up 
ST R7,R7_BACKUP_3400

    LD R6,BUSYNESS_ADDR_ALL_MACHINES_BUSY	;load vector address to r6
    LDR R1,R6,#0				;put into r1
    LD R3,CNT_3400				;load counter of 16 into r3
    AND R2,R2,#0				;return value r2 set to 0 as default

CHECK_ALL_BUSY_LOOP
    ADD R1,R1,#0
    BRn RETURN_ALL_BUSY		;if negative, means this bit is free so return 0
    ADD R1,R1,R1		;if not, then shift left
    ADD R3,R3,#-1		;decrement counter
    BRp CHECK_ALL_BUSY_LOOP	;if positive means more to check, send to loop
    ADD R2,R2,#1		;if all checked and none free, then set return to 1

RETURN_ALL_BUSY
    AND R0,R0,#0
    AND R1,R1,#0
    AND R3,R3,#0
    AND R6,R6,#0		;clear all used registers


;HINT Restore
LD R7,R7_BACKUP_3400

RET

;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_BUSY .Fill xD000
R7_BACKUP_3400 .BLKW 1
CNT_3400 .FILL #16


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free,    0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------
.orig x3600			;basically the same as all_machines_busy but opposite
;HINT back up 
    ST R7,R7_BACKUP_3600
    LD R6,BUSYNESS_ADDR_ALL_MACHINES_FREE	;load busyness vector into r6
    LDR R1,R6,#0		;put address into r1
    LD R3,CNT_3600		;load r3 with 16
    AND R2,R2,#0 		;set default return to 0

CHECK_ALL_FREE_LOOP
    ADD R1,R1,#0
    BRzp RETURN_ALL_FREE	;if not neg, then means bit is busy so return 0
    ADD R1,R1,R1		;shift left
    ADD R3,R3,#-1		;decrement counter
    BRp CHECK_ALL_FREE_LOOP	;if positive more to check, send to loop
    ADD R2,R2,#1		;if all checked and none busy, set return to 1

RETURN_ALL_FREE
    AND R0,R0,#0
    AND R1,R1,#0
    AND R3,R3,#0
    AND R6,R6,#0		;clear all used registers

;HINT Restore
    LD R7,R7_BACKUP_3600

RET

;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xD000
R7_BACKUP_3600 .BLKW #1
CNT_3600 .FILL #16

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R2): The number of machines that are busy
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------
.orig x3800
;HINT back up 
    ST R7,R7_BACKUP_3800
    LD R6,BUSYNESS_ADDR_NUM_BUSY_MACHINES	;load busyness vector and put into r1
    LDR R1,R6,#0		
    LD R3,CNT_3800		;load r3 with coutner of 16
    AND R2,R2,#0		;clear return value, default 0 busy

CHECK_BUSY
    ADD R1,R1,#0
    BRzp INCREASE_NUM_BUSY

SHIFT_BUSY_LEFT
    ADD R1,R1,R1		;shift left
    ADD R3,R3,#-1		;decrement counter
    BRp CHECK_BUSY		;if more left to check, go back to loop
    BRnzp RETURN_NUM_BUSY	;send to end if no more

INCREASE_NUM_BUSY
    ADD R2,R2,#1		;increment return value by 1
    BRnzp SHIFT_BUSY_LEFT	;send to shift vector left

RETURN_NUM_BUSY
    AND R0,R0,#0
    AND R1,R1,#0
    AND R3,R3,#0
    AND R6,R6,#0		;clear all used registers
;HINT Restore
    LD R7,R7_BACKUP_3800

RET

;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xD000
R7_BACKUP_3800 .BLKW #1
CNT_3800 .FILL #16

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R2): The number of machines that are free 
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------
.orig x4000
;HINT back up
    ST R7,R7_BACKUP_4000
    LD R6,BUSYNESS_ADDR_NUM_FREE_MACHINES	;load vector address into r6 and put into r1
    LDR R1,R6,#0		
    LD R3,CNT_4000		;load r3 with counter of 16
    AND R2,R2,#0		;set return to 0 default

CHECK_FREE
    ADD R1,R1,#0		
    BRn INCREASE_NUM_FREE	

SHIFT_FREE_LEFT
    ADD R1,R1,R1		;shift left
    ADD R3,R3,#-1		;decrement counter
    BRp CHECK_FREE		;send back to loop if more to check
    BRnzp RETURN_NUM_FREE	;if no more to check, send to return


INCREASE_NUM_FREE
    ADD R2,R2,#1		;
    BRnzp SHIFT_FREE_LEFT

RETURN_NUM_FREE
    AND R0,R0,#0
    AND R1,R1,#0
    AND R3,R3,#0
    AND R6,R6,#0		;clear all used registers
;HINT Restore
    LD R7,R7_BACKUP_4000

;--------------------------------
;Data for subroutine NUM_FREE_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xD000
R7_BACKUP_4000 .BLKW #1
CNT_4000 .FILL #16

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS
; Input (R1): Which machine to check
; Postcondition: The subroutine has returned a value indicating whether the machine indicated
;                          by (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------
.orig x4200
;HINT back up 	
    ST R7,R7_BACKUP_4200
    ADD R6,R1,#0		;put number of machine to check into r6
    LD R4,CNT_4200		;r4 <-- 15
    NOT R6,R6			;perform twos complement conversion to negative
    ADD R6,R6,#1		
    ADD R4,R4,R6		;r4 contains number of left shifts
    LD R6,BUSYNESS_ADDR_MACHINE_STATUS
    LDR R2,R6,#0

    ADD R4,R4,#0		;check to see if r4 is already zero
    BRz STATUS_CHECK		;if already zero, no need to shift left, skip next loop

STATUS_LOOP
    ADD R2,R2,R2		;shift left
    ADD R4,R4,#-1		;decrement left shift counter
    BRp STATUS_LOOP

STATUS_CHECK
    ADD R2,R2,#0
    BRzp IF_BUSY		;if zero or pos then machine is busy, send to if_busy
    AND R2,R2,#0		
    ADD R2,R2,#1
    BRnzp RETURN_STATUS		;if not, set return value to 1 and be done

IF_BUSY
    AND R2,R2,#0		;set return value to 0


RETURN_STATUS
    AND R3,R3,#0
    AND R4,R4,#0
    AND R6,R6,#0		;clear all used registers
;HINT Restore
    LD R7,R7_BACKUP_4200

RET

;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
BUSYNESS_ADDR_MACHINE_STATUS.Fill xD000
R7_BACKUP_4200 .BLKW #1
CNT_4200 .FILL #15

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE
; Inputs: None
; Postcondition: 
; The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------
.orig x4400
;HINT back up 
    ST R7,R7_BACKUP_4400
    LD R6,BUSYNESS_ADDR_FIRST_FREE	;load address into r6 and put into r1
    LDR R1,R6,#0			
    AND R2,R2,#0			;starting at 0 this will count until 16
					;and also serve as return value already correctly
					;incremented per each loop
    AND R3,R3,#0
    ADD R3,R3,#15			;starting at 15 this is the left shift counter
					;will count from 15 down to 0

LEFT_SHIFT_LOOP
    ADD R3,R3,#0
    BRz FIRST_CHECK		;if already left shifted, then go to next step
    ADD R1,R1,R1		;left shift
    ADD R3,R3,#-1		;decrement left shift counter
    BRp LEFT_SHIFT_LOOP		;if positive, keep left shifting

FIRST_CHECK
    ADD R1,R1,#0		;if negative, then it is the first free
    BRn RETURN_FIRST_FREE
    ADD R2,R2,#1		;increment r2 if not free
    AND R3,R3,#0		
    ADD R3,R3,#15
    NOT R7,R2
    ADD R7,R7,#1
    ADD R3,R3,R7
    ADD R7,R2,#-16
    BRz RETURN_FIRST_FREE
    LDR R1,R6,#0		;reload vector to left shift from beginning
    BRnzp LEFT_SHIFT_LOOP
    

RETURN_FIRST_FREE
;HINT Restore
    LD R7,R7_BACKUP_4400

RET
;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
BUSYNESS_ADDR_FIRST_FREE .Fill xD000
R7_BACKUP_4400 .BLKW #1


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: Get input
; Inputs: None
; Postcondition: 
; The subroutine get up to a 5 digit input from the user within the range [-32768,32767]
; Return Value (R1): The value of the contructed input
; NOTE: This subroutine should be the same as the one that you did in assignment 5
;	to get input from the user, except the prompt is different.
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.orig x4600
ST R7, R7_BACKUP_4600

OUTPUT_PROMPT
    LEA R0,prompt ;output prompt message
    PUTS
    LD R4,CNT_4600		;load r4 with 6
    AND R3,R3,#0
    AND R5,R5,#0
    AND R7,R7,#0		;set all flags to 0

INPUT_CHAR
    GETC
    ADD R1,R0,#0		;put input_char into r1
    ;LD R6,NEGNEWLINE_4600	;check if input is newline
    ;ADD R1,R1,R6		
    BRnzp ECHO

CHECK_CHAR
    ADD R1,R0,#0		;load inputted char into r1
    LD R2,NEG48_4600		;load ASCII value (-48) into r2
    ADD R1,R1,R2		;subtract -48 from input
    BRn OTHER_CHAR		;if negative, then might be + - or newline 
    ADD R1,R0,#0		;reset input char into r1
    LD R2,NEG57_4600		;subtract 57
    ADD R1,R1,R2		
    BRp INVALID_CHAR		;if still pos, then error.

    ADD R1,R4,#0		;copy counter into r1
    ADD R1,R1,#-6		;if -6 makes it 0, then it is the first char
    BRz FIRST_CHAR
    
    ADD R5,R5,R5
    ADD R6,R5,R5
    ADD R6,R6,R6
    ADD R5,R5,R6		;multiply by 10
    
    LD R2,NEG48_4600		;
    ADD R0,R0,R2
    ADD R5,R5,R0		;add input to r5
    ADD R4,R4,#-1		;decrement counter
    BRp INPUT_CHAR		;go to input char if more can be taken
    BRz CHECK_NEG		;if not, check negative

ECHO
    OUT
    BRnzp CHECK_CHAR

OTHER_CHAR
    LD R2,NEGPLUS		;load negative ascii of + to check 
    ADD R1,R0,#0		;reload inputted char into r1
    ADD R1,R1,R2		;subtract -43 from input
    BRz PLUS_CHAR
    LD R2,NEGNEG		;load negative ascii of - to check just as above
    ADD R1,R0,#0
    ADD R1,R1,R2
    BRz MINUS_CHAR		;if minus char, send to minus_char
    LD R2,NEGNEWLINE_4600	;load negative ascii of newline to check just as above
    ADD R1,R0,#0
    ADD R1,R1,R2
    BRz NEWLINE_INPUT		;if newline, send to newline_input

FIRST_CHAR
    LD R2,NEG48_4600
    ADD R0,R0,R2		;subtract 48 from input
    ADD R5,R0,R5		;put into r5
    ADD R4,R4,#-2		;decrement by 2 for no sign bit
    BRnzp INPUT_CHAR

PLUS_CHAR
    ADD R1,R4,#0
    ADD R1,R1,#-6
    BRnp INVALID_CHAR		;if not first char then error
    ADD R3,R3,#0
    ADD R7,R7,#0
    ADD R4,R4,#-1
    BRnzp INPUT_CHAR


MINUS_CHAR
    ADD R1,R4,#0
    ADD R1,R1,#-6
    BRnp INVALID_CHAR		;if not first char then error
    ADD R3,R3,#1
    ADD R7,R7,#1
    ADD R4,R4,#-1
    BRnzp INPUT_CHAR

NEWLINE_INPUT
    ADD R1,R4,#0
    ADD R1,R1,#-6		
    BRz INVALID_CHAR		;if first char then error
    ADD R1,R4,#0
    ADD R1,R1,#-5
    BRnp CHECK_NEG
    ADD R1,R7,#0
    ADD R1,R1,#-1
    BRz INVALID_CHAR
    BRnp CHECK_NEG

TWO_COMPLEMENT
    NOT R5,R5
    ADD R5,R5,#1
    BRnzp RETURN_INPUT

INVALID_CHAR
    LD R0,NEWLINE_4600
    OUT
    LEA R0, Error_message_2
    PUTS
    BRnzp OUTPUT_PROMPT		;output error message and send to prompt

CHECK_NEG
    ADD R1,R3,#0
    ADD R1,R1,#-1
    BRz TWO_COMPLEMENT

RETURN_INPUT
    ADD R1,R5,#0
    ADD R1,R1,#0		;see if its less than 0
    BRn INVALID_CHAR	
    ADD R2,R1,#-15		;see if its more than 15
    BRp INVALID_CHAR
    ADD R1,R5,#0
    LD R0,NEWLINE_4600
    OUT
    AND R0,R0,#0
    AND R2,R2,#0
    AND R3,R3,#0
    AND R4,R4,#0
    AND R5,R5,#0		;clear all used registers
    LD R7,R7_BACKUP_4600

RET
    
;--------------------------------
;Data for subroutine Get input
;--------------------------------
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_message_2 .STRINGZ "ERROR INVALID INPUT\n"
R7_BACKUP_4600 .BLKW #1
NEGNEWLINE_4600 .FILL #-10
NEGPLUS .FILL #-43
NEGNEG .FILL #-45
NEWLINE_4600 .FILL #10
NEG48_4600 .FILL #-48
NEG57_4600 .FILL #-57
CNT_4600 .FILL #6
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: print number
; Inputs: 
; Postcondition: 
; The subroutine prints the number that is in 
; Return Value : 
; NOTE: This subroutine should print the number to the user WITHOUT 
;		leading 0's and DOES NOT output the '+' for positive numbers.
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.orig x4800
    ST R7,R7_BACKUP_4800

    ADD R5,R2,#0		;puts number in r5
    AND R2,R2,#0		;clear r2
    ADD R6,R5,#0		;extra copy to manipulate

TENK
    LD R2,NEGTENK
    ADD R5,R5,R2		;subtract 10,000 from number
    BRzp CHECK_1
    LD R0,ASCII_4800
    ADD R0,R0,R4		;add 48 to r4
    ADD R4,R4,#0
    BRz ZERO_1			;if counter is zero, send to zero_1
    OUT 			;if successful, print now

ZERO_1
    ADD R5,R6,#0		;reload number to r5
    LD R4,CNT_4800		;reset counter to 0
    BRnzp ONEK			;continue 

CHECK_1
    ADD R6,R5,#0		;put new number into r6
    ADD R4,R4,#1		;increment counter
    BRnzp TENK			;send back to tenk

ONEK
    LD R2,NEGONEK		
    ADD R5,R5,R2		;subtract 1,000 from number
    BRzp CHECK_2
    LD R0,ASCII_4800
    ADD R0,R0,R4		;add 48 to r4
    ADD R4,R4,#0
    BRz ZERO_2			;if counter is zero, send to zero_2
    OUT				;if successful, print now

ZERO_2
    ADD R5,R6,#0		;reload number to r5
    LD R4,CNT_4800		;reset counter to 0
    BRnzp ONEHUNDRED		;continue

CHECK_2
    ADD R6,R5,#0		;put new number into r6
    ADD R4,R4,#1		;increment counter
    BRnzp ONEK			;send back to onek

ONEHUNDRED
    LD R2,NEGHUNDRED		
    ADD R5,R5,R2		;subtract 100 
    BRzp CHECK_3
    LD R0,ASCII_4800		;add 48
    ADD R0,R0,R4
    ADD R4,R4,#0		
    BRz ZERO_3			;if counter is zero, send to zero_3
    OUT				;if successful, print now

ZERO_3
    ADD R5,R6,#0		;reload number to r5
    LD R4,CNT_4800		;reset counter to 0
    BRnzp TEN			;send to ten

CHECK_3
    ADD R6,R5,#0		;put new number into r6
    ADD R4,R4,#1		;increment counter
    BRnzp ONEHUNDRED		;send back to onehundred

TEN
    LD R2,NEGTEN
    ADD R5,R5,R2		;subtract 10
    BRzp CHECK_4
    LD R0,ASCII_4800		;add 48
    ADD R0,R0,R4
    ADD R4,R4,#0
    BRz ZERO_4			;if counter is zero, send to zero_4
    OUT				;if successful, print now

ZERO_4
    ADD R5,R6,#0		;reload number to r5
    LD R4,CNT_4800		;reset counter to 0
    BRnzp ONE			;send to one

CHECK_4
    ADD R6,R5,#0		;put new number into r6
    ADD R4,R4,#1		;increment counter
    BRnzp TEN			;send back to ten

ONE
    LD R0,ASCII_4800		;last case, add 48 and print.
    ADD R0,R0,R5
    OUT
    BRnzp RETURN_NUM		;finish subroutine

RETURN_NUM
    AND R0,R0,#0
    AND R2,R2,#0
    AND R4,R4,#0
    AND R5,R5,#0
    AND R6,R6,#0		;clear all used registers


LD R7,R7_BACKUP_4800



RET
;--------------------------------
;Data for subroutine print number
;--------------------------------
R7_BACKUP_4800 .BLKW #1
CNT_4800 .FILL #0
ASCII_4800 .FILL #48

NEGTENK .FILL #-10000
NEGONEK .FILL #-1000
NEGHUNDRED .FILL #-100
NEGTEN .FILL #-10
NEGONE .FILL #-1



.ORIG x6000
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xD000			; Remote data
BUSYNESS .FILL xFFFF		; <----!!!VALUE FOR BUSYNESS VECTOR!!!

;---------------	
;END of PROGRAM
;---------------	
.END
