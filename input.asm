;*******************************************************************************
;   CS 107: Computer Architecture and Organization
;
;   lab03
;
;   Filename: input.asm
;   Author: Gregory Weinrod
;   Description: This program processes input provided by a user and the
;   S1 or S2 buttons on the demo board.
;
;*******************************************************************************
#include "p18F8722.inc"

;*******************************************************************************
; Variables
;*******************************************************************************
VARS            UDATA       ; "Normal" variables
i		res 1	    ; counting variable for 10 ms delay
j		res 1	    ; another

;*******************************************************************************
; Universal Definitions
;*******************************************************************************		
		GLOBAL		PRESS_L
		GLOBAL		PRESS_R
		EXTERN		direction
		EXTERN		speed
		EXTERN		DELAY_COUNT
	    
;*******************************************************************************
; Main program code
;*******************************************************************************
INPUT_PROG CODE                      ; let linker place main program

;*******************************************************************************
; Simple 10 ms delay loop and wait-for-release to verify user input.
;   left button, S2
;*******************************************************************************
PRESS_L:movlw	H'1C'	    ; 1		    1		1
	movwf	i	    ; 1		    1		1
WAIT_L0:movlw	H'1C'	    ; 1		    i		i
	movwf	j	    ; 1		    i		i
WAIT_L1:decf	j	    ; 1		    ij		ij
	bnz	WAIT_L1	    ; 2 on jump	    ij		2ij - i
	decf	i	    ; 1		    i		i
	bnz	WAIT_L0	    ; 2 on jump	    i		2i - 1
			    ; total 3ij + 4i + 1 = 2500 (10 ms) i, j = 28d
	BTFSS	PORTB, RB0  ; poll again
	GOTO	WAIT_USER_L ; still pressed, accept as input
	RETURN		    ; wasn't still pressed after 10ms so go back
WAIT_USER_L:
	BTFSS	PORTB, RB0  ; we're gonna wait for a button release
	GOTO	PRESSED_L
	GOTO	WAIT_USER_L
	
;*******************************************************************************
; Simple 10 ms delay loop and wait-for-release to verify user input.
;   right button, S2
;*******************************************************************************
PRESS_R:movlw	H'1C'	    ; 1		    1		1
	movwf	i	    ; 1		    1		1
WAIT_R0:movlw	H'1C'	    ; 1		    i		i
	movwf	j	    ; 1		    i		i
WAIT_R1:decf	j	    ; 1		    ij		ij
	bnz	WAIT_R1	    ; 2 on jump	    ij		2ij - i
	decf	i	    ; 1		    i		i
	bnz	WAIT_R0	    ; 2 on jump	    i		2i - 1
			    ; total 3ij + 4i + 1 = 2500 (10 ms) i, j = 28d
	BTFSS	PORTA, RA5  ; poll again
	GOTO	WAIT_USER_R ; still pressed, accept as input
	RETURN		    ; wasn't still pressed after 10ms so go back
WAIT_USER_R:
	BTFSC	PORTA, RA5  ; we're gonna wait for a button release
	GOTO	PRESSED_R
	GOTO	WAIT_USER_R

;*******************************************************************************
; S2, right button, changes direction
;*******************************************************************************
PRESSED_R:
	movlw   H'00'
	cpfseq  direction, ACCESS
	GOTO    X_DIR_LR
	GOTO    X_DIR_RL
    
X_DIR_LR:
	clrf    direction, ACCESS
	GOTO	HANDLED
    
X_DIR_RL:
	movlw   H'01'
	movwf   direction, ACCESS
	GOTO	HANDLED

;*******************************************************************************
; S1, left button, changes count of .5 second delays
;*******************************************************************************
PRESSED_L:
	GOTO C_speed_0
C_speed_0:
	movlw   H'00'
	cpfseq  speed, ACCESS		; check our current delay
	goto    C_speed_1
	goto    X_speed_1
C_speed_1:
	movlw   H'01'
	cpfseq  speed, ACCESS
	goto    C_speed_2
	goto    X_speed_2
C_speed_2:
	movlw   H'02'
	cpfseq  speed, ACCESS
	goto    C_speed_3
	goto    X_speed_3
C_speed_3:
	movlw   H'03'
	cpfseq  speed, ACCESS
	goto    WTF
	goto    X_speed_0
	
X_speed_0:				; and set it accordingly
	movlw	H'00'
	movwf	speed, ACCESS
	GOTO	HANDLED
X_speed_1:
	movlw	H'01'
	movwf	speed, ACCESS
	GOTO	HANDLED
X_speed_2:
	movlw	H'02'
	movwf	speed, ACCESS
	GOTO	HANDLED
X_speed_3:
	movlw	H'03'
	movwf	speed, ACCESS
	GOTO	HANDLED
	
;*******************************************************************************
; Input  handled, do not allow further until after current .5s delay window
;*******************************************************************************	
HANDLED:
	btfsc	INTCON, TMR0IF, ACCESS	; check for overflow
	GOTO	DELAY_COUNT		; overflowed, count down our delays
	GOTO	HANDLED
	
WTF:	GOTO    $			; should never get here
    
		END