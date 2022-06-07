;*******************************************************************************
;   CS 107: Computer Architecture and Organization
;
;   lab03
;
;   Filename: delay.asm
;   Author: Gregory Weinrod
;   Description: This program processes and manipulates delay times between LED
;   flashes while polling for user input from the two buttons on our board.
;
;*******************************************************************************
#include "p18F8722.inc"

;*******************************************************************************
; Variables
;*******************************************************************************
VARS            UDATA       ; "Normal" variables
dCount		res		1	 ; iterator for delay count

;*******************************************************************************
; Universal Definitions
;*******************************************************************************		
		GLOBAL		DELAY
		GLOBAL		DELAYInit
		GLOBAL		DELAY_COUNT
		EXTERN		speed
		EXTERN		PRESS_R
		EXTERN		PRESS_L

;*******************************************************************************
; Main program code
;*******************************************************************************
DELAY_PROG CODE				; let linker place main program
	
DELAY:
	movf	speed, W, ACCESS
	movwf	dCount, ACCESS
	incf	dCount, F, ACCESS
	GOTO	DELAY_COUNT
	
;*******************************************************************************
; Counts .5 second delays
;*******************************************************************************	
DELAY_COUNT:	
	decf	dCount, F, ACCESS
	bnn	DELAY_COUNTED
	RETURN
DELAY_COUNTED:	
	CALL	DELAYInit
	GOTO	ADELAY
	
;*******************************************************************************
; Delays for .5 seconds
;*******************************************************************************	
ADELAY:	
	btfsc	INTCON, TMR0IF, ACCESS	; check for overflow
	GOTO	DELAY_COUNT		; overflowed, count down our delays
	btfss	PORTA, RA5		; check right button
	GOTO	PRESS_R
	btfss	PORTB, RB0		; check left button
	GOTO	PRESS_L
	GOTO	ADELAY			; loop until overflow

;*******************************************************************************
; Configure our .5 second delay
;*******************************************************************************
DELAYInit:
	movlw	B'00000000'		; timer off, 16 bit, internal clock
					; prescaler assigned to 1:2
	movwf	T0CON, ACCESS
	bcf	INTCON, TMR0IF, ACCESS	; set overflow flag off
	movlw	H'0B'			; high byte to 11 decimal
	movwf	TMR0H
	movlw	H'DC'			; low byte to 220 decimal
	movwf	TMR0L
	bsf	T0CON, TMR0ON, ACCESS	; turn on timer
	return
;*******************************************************************************
; Delay figures
;	let prescaler = 1/2
;	let delay = 500,000 microseconds
;	let frequency = 4 MHz
;	let cycles = 4
;	let TMR0H = 11 decimal
;	let TMR0L = 220 decimal	
;	
;
;*******************************************************************************	
	
			
WTF:	goto $				;should never get here
		END