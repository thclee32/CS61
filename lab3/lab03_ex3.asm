;=================================================
; Name: Lee, Thomas
; Email:  tlee066@ucr.edu
; 
; Lab: lab 3
; Lab section: xxx
; TA: Jason Goulding
; 
;=================================================

.orig x3000
  ;--------------
  ;Instructions
  ;--------------
  ;LDI R3, DEC_65_PTR
  ;LDI R4, HEX_41_PTR

  ;ADD R3, R3, #1 	;R3 <-- R3 + #1
  ;ADD R4, R4, #1	;R4 <-- R4 + #1

  ;STI R3, DEC_65_PTR
  ;STI R4, HEX_41_PTR

  LD R5, DEC_65_PTR	
  LD R6, HEX_41_PTR

  LDR R3, R5, #0	;R3 <-- R5 PTR
  LDR R4, R6, #0	;R4 <-- R6 PTR
  
  ADD R3, R3, #1
  ADD R4, R4, #1

  STR R3, R5, #0
  STR R4, R6, #0

HALT
;------------------
;Local Data
;------------------

  DEC_65_PTR	.FILL	x4000
  HEX_41_PTR	.FILL	x4001

    ;; Remote data
    .orig x4000
NEW_DEC_65	.FILL	#65
NEW_HEX_41	.FILL	x41

.end
