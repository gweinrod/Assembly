;*******************************************************************************
;   CS 107: Computer Architecture and Organization
;
;   lab03
;
;   Filename: control.asm
;   Author: Gregory Weinrod
;   Description: This program processes state changes by using a table of
;   compares to determine the current state and advance it depending upon
;   our current direction.
;
;*******************************************************************************
#include "p18F8722.inc"

;*******************************************************************************
; Variables
;*******************************************************************************
VARS            UDATA       ; "Normal" variables

;*******************************************************************************
; Universal Definitions
;*******************************************************************************		
		GLOBAL		    XSTATE
		EXTERN		    state
		EXTERN		    direction
	    
;*******************************************************************************
; Main program code
;*******************************************************************************
STATE_PROG CODE                      ; let linker place main program

;*******************************************************************************
; Advance state 0->7 or 7->0
;*******************************************************************************
XSTATE:
	movlw	H'00'		    ; check direction
	cpfseq	direction
	GOTO	STATE_RL0	    ; right to left
	GOTO	STATE_LR0	    ; left to right
	
STATE_RL0:			    ; check state
	movlw	H'00'		    ; to increment accordingly
	cpfseq	state		    ; when moving R to L
	GOTO	STATE_RL1
	GOTO	XSTATE_1
STATE_RL1:
	movlw	H'01'
	cpfseq	state
	GOTO	STATE_RL2
	GOTO	XSTATE_2
STATE_RL2:
	movlw	H'02'
	cpfseq	state
	GOTO	STATE_RL3
	GOTO	XSTATE_3
STATE_RL3:
	movlw	H'03'
	cpfseq	state
	GOTO	STATE_RL4
	GOTO	XSTATE_4
STATE_RL4:
	movlw	H'04'
	cpfseq	state
	GOTO	STATE_RL5
	GOTO	XSTATE_5
STATE_RL5:
	movlw	H'05'
	cpfseq	state
	GOTO	STATE_RL6
	GOTO	XSTATE_6
STATE_RL6:
	movlw	H'06'
	cpfseq	state
	GOTO	STATE_RL7
	GOTO	XSTATE_7
STATE_RL7:
	movlw	H'07'
	cpfseq	state
	GOTO	WTF
	GOTO	XSTATE_0
	
STATE_LR0:			    ; check state
	movlw	H'00'		    ; and increment accordingly
	cpfseq	state		    ; when moving L to R
	GOTO	STATE_LR1
	GOTO	XSTATE_7
STATE_LR1:
	movlw	H'01'
	cpfseq	state
	GOTO	STATE_LR2
	GOTO	XSTATE_0
STATE_LR2:
	movlw	H'02'
	cpfseq	state
	GOTO	STATE_LR3
	GOTO	XSTATE_1
STATE_LR3:
	movlw	H'03'
	cpfseq	state
	GOTO	STATE_LR4
	GOTO	XSTATE_2
STATE_LR4:
	movlw	H'04'
	cpfseq	state
	GOTO	STATE_LR5
	GOTO	XSTATE_3
STATE_LR5:
	movlw	H'05'
	cpfseq	state
	GOTO	STATE_LR6
	GOTO	XSTATE_4
STATE_LR6:
	movlw	H'06'
	cpfseq	state
	GOTO	STATE_LR7
	GOTO	XSTATE_5
STATE_LR7:
	movlw	H'07'
	cpfseq	state
	GOTO	WTF
	GOTO	XSTATE_6	

XSTATE_0:			    ; change state
	movlw	H'00'		    ; accordingly
	movwf	state
	RETURN			    
XSTATE_1:
	movlw	H'01'
	movwf	state
	RETURN
XSTATE_2:
	movlw	H'02'
	movwf	state
	RETURN
XSTATE_3:
	movlw	H'03'
	movwf	state
	RETURN
XSTATE_4:
	movlw	H'04'
	movwf	state
	RETURN
XSTATE_5:
	movlw	H'05'
	movwf	state
	RETURN
XSTATE_6:
	movlw	H'06'
	movwf	state
	RETURN
XSTATE_7:
	movlw	H'07'
	movwf	state
	RETURN
	
WTF:	GOTO $			    ; should never reach here
	
		END