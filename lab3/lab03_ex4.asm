;=================================================
; Name: Lee, Thomas
; Email:  tlee066@ucr.edu
; 
; Lab: lab 3
; Lab section: xx
; TA: Jason Goulding
; 
;=================================================
.orig x3000
  ;-------------
  ;Instructions
  ;-------------

  LD R0, DEC_0
  LD R1, DEC_1
  
  DO_WHILE_LOOP
    Trap x21
    ADD R0, R0, #1
    ADD R1, R1, #-1
    BRp DO_WHILE_LOOP
  END_DO_WHILE_LOOP
    
    HALT



  ;-----------
  ;Local Data
  ;-----------
    DEC_0	.FILL	x61
    DEC_1	.FILL	x1A

.end

