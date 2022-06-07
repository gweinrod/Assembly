;*******************************************************************************
;   CS 107: Computer Architecture and Organization
;
;   lab03
;
;   Filename: led.asm
;   Author: Gregory Weinrod
;   Description: This program translates states 0-7 to corresponding bit
;   patterns to the LEDS on the board.
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
		GLOBAL		LEDCon
		GLOBAL		LEDFlash
		EXTERN		state

	
;*******************************************************************************
; Main program code
;*******************************************************************************
LED_PROG CODE				; let linker place main program

;*******************************************************************************
; Configure the outputs so we can light LEDs
;*******************************************************************************
LEDCon:
	clrf	TRISD			; all zero for all output
	clrf	PORTD			; turn off LEDS
	return 
 
;*******************************************************************************
; Code for executing an LED Flash
;*******************************************************************************
LEDFlash:
	incf	STKPTR, F, ACCESS	; data will be on the stack
	movf	state, W, ACCESS
	movwf	TOSL, ACCESS
	call	PATToLED		; don't trim the stack yet
	call	LEDOut			; since we put our return there
	decf	STKPTR, F, ACCESS
	return
 

;*******************************************************************************
; Given a bit pattern, output to LEDs
;*******************************************************************************	
LEDOut:
	decf	STKPTR, F, ACCESS
	movff	TOSH, PORTD
	incf	STKPTR, F, ACCESS
	return

;*******************************************************************************
; Check given state
;*******************************************************************************
PATToLED:
	decf	STKPTR, F, ACCESS	; look at our argument
PATToLED0:
	movlw	H'00'
	cpfseq	TOSL, ACCESS
	goto	PATToLED1
	goto	PAT0			; translate state 0
PATToLED1:
	movlw	H'01'
	cpfseq	TOSL, ACCESS
	goto	PATToLED2		; and so forth
	goto	PAT1			
PATToLED2:
	movlw	H'02'
	cpfseq	TOSL, ACCESS
	goto	PATToLED3
	goto	PAT2	
PATToLED3:
	movlw	H'03'
	cpfseq	TOSL, ACCESS
	goto	PATToLED4
	goto	PAT3	
PATToLED4:
	movlw	H'04'
	cpfseq	TOSL, ACCESS
	goto	PATToLED5
	goto	PAT4	
PATToLED5:
	movlw	H'05'
	cpfseq	TOSL, ACCESS
	goto	PATToLED6
	goto	PAT5	
PATToLED6:
	movlw	H'06'
	cpfseq	TOSL, ACCESS
	goto	PATToLED7
	goto	PAT6	
PATToLED7:
	movlw	H'07'
	cpfseq	TOSL, ACCESS
	goto	WTF
	goto	PAT7
	
;*******************************************************************************
; Return binary LED output
;*******************************************************************************    
PAT0:	movlw	H'01'
	goto	PATRETURN
PAT1:	movlw	H'02'
	goto	PATRETURN
PAT2:	movlw	H'04'
	goto	PATRETURN
PAT3:	movlw	H'08'
	goto	PATRETURN
PAT4:	movlw	H'10'
	goto	PATRETURN
PAT5:	movlw	H'20'
	goto	PATRETURN
PAT6:	movlw	H'40'
	goto	PATRETURN
PAT7:	movlw	H'80'
	goto	PATRETURN
PATRETURN:
	movwf	TOSH, ACCESS
	incf	STKPTR, F, ACCESS
	return

WTF:	goto	$		;should never get here
		END