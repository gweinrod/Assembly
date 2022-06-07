;*******************************************************************************
;   CS 107: Computer Architecture and Organization
;
;   lab03
;
;   Filename: main.asm
;   Author: Gregory Weinrod
;   Description: This program implements lab03 as described on the course
;   web site.  LEDs are scrolled from side to side on the demo baord.  
;   Button S2, right, changes scroll direction.  Button S1, left, controls 
;   the scroll speed by implementing a count of .5 second delays, 
;   from .5 to 2 seconds.
;
;*******************************************************************************
; The configuration bits are set here and these dictate the initial hardware
; setup. This is provided by the "Config Bits Source" tool in MPLAB X.

#include "p18F8722.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Two-Speed Start-up disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = OFF           ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  BORV = 3              ; Brown-out Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3L
  CONFIG  MODE = MC             ; Processor Data Memory Mode Select bits (Microcontroller mode)
  CONFIG  ADDRBW = ADDR20BIT    ; Address Bus Width Select bits (20-bit Address Bus)
  CONFIG  DATABW = DATA16BIT    ; Data Bus Width Select bit (16-bit External Bus mode)
  CONFIG  WAIT = OFF            ; External Bus Data Wait Enable bit (Wait selections are unavailable for table reads and table writes)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (ECCP2 input/output is multiplexed with RC1)
  CONFIG  ECCPMX = PORTE        ; ECCP MUX bit (ECCP1/3 (P1B/P1C/P3B/P3C) are multiplexed onto RE6, RE5, RE4 and RE3 respectively)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = OFF           ; MCLR Pin Enable bit (RG5 input pin enabled; MCLR disabled)

; CONFIG4L
  CONFIG  STVREN = OFF          ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
  CONFIG  LVP = ON              ; Single-Supply ICSP Enable bit (Single-Supply ICSP enabled)
  CONFIG  BBSIZ = BB2K          ; Boot Block Size Select bits (1K word (2 Kbytes) Boot Block size)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit Block 0 (Block 0 (000800, 001000 or 002000-003FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit Block 1 (Block 1 (004000-007FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit Block 2 (Block 2 (008000-00BFFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit Block 3 (Block 3 (00C000-00FFFFh) not code-protected)
  CONFIG  CP4 = OFF             ; Code Protection bit Block 4 (Block 4 (010000-013FFFh) not code-protected)
  CONFIG  CP5 = OFF             ; Code Protection bit Block 5 (Block 5 (014000-017FFFh) not code-protected)
  CONFIG  CP6 = OFF             ; Code Protection bit Block 6 (Block 6 (01BFFF-018000h) not code-protected)
  CONFIG  CP7 = OFF             ; Code Protection bit Block 7 (Block 7 (01C000-01FFFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot Block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit Block 0 (Block 0 (000800, 001000 or 002000-003FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit Block 1 (Block 1 (004000-007FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit Block 2 (Block 2 (008000-00BFFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit Block 3 (Block 3 (00C000-00FFFFh) not write-protected)
  CONFIG  WRT4 = OFF            ; Write Protection bit Block 4 (Block 4 (010000-013FFFh) not write-protected)
  CONFIG  WRT5 = OFF            ; Write Protection bit Block 5 (Block 5 (014000-017FFFh) not write-protected)
  CONFIG  WRT6 = OFF            ; Write Protection bit Block 6 (Block 6 (01BFFF-018000h) not write-protected)
  CONFIG  WRT7 = OFF            ; Write Protection bit Block 7 (Block 7 (01C000-01FFFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot Block (000000-007FFF, 000FFF or 001FFFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit Block 0 (Block 0 (000800, 001000 or 002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit Block 1 (Block 1 (004000-007FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit Block 2 (Block 2 (008000-00BFFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit Block 3 (Block 3 (00C000-00FFFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR4 = OFF           ; Table Read Protection bit Block 4 (Block 4 (010000-013FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR5 = OFF           ; Table Read Protection bit Block 5 (Block 5 (014000-017FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR6 = OFF           ; Table Read Protection bit Block 6 (Block 6 (018000-01BFFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR7 = OFF           ; Table Read Protection bit Block 7 (Block 7 (01C000-01FFFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot Block (000000-007FFF, 000FFF or 001FFFh) not protected from table reads executed in other blocks)



;*******************************************************************************
; Reset Vector
;
;   When the power turns on this is the first place the processor goes. We just
;   jump to the beginning of the program.
;*******************************************************************************
RES_VECT    CODE    H'0000'     ; processor reset vector
            goto    START       ; go to beginning of program

;*******************************************************************************
; High Priority Interrupt Vector
;*******************************************************************************
INT_VECT_HIGH	CODE    H'0008' ; processor interrupt vector
            nop			; Don't do anything. We should never get here.

;*******************************************************************************
; Low Priority Interrupt Vector
;*******************************************************************************
INT_VECT_LOW	CODE    H'0018' ; processor interrupt vector
            nop			; Don't do anything. We should never get here.

;*******************************************************************************
; Variables
;*******************************************************************************
VARS            UDATA       ; "Normal" variables
state		res 1	    ; state of LEDs <0,7>
direction	res 1	    ; direction of LED movement <0,1> 0 = l->r
speed		res 1	    ; amount of delay <0,3> 0 = .5, 1 = 1, 2 = 1.5, 3 = 2

;*******************************************************************************
; Universal Definitions
;*******************************************************************************		
		GLOBAL		state
		GLOBAL		speed
		GLOBAL		direction
		EXTERN		LEDCon
		EXTERN		LEDFlash
		EXTERN		DELAYInit
		EXTERN		DELAY
		EXTERN		XSTATE
	
;*******************************************************************************
; Main program code
;*******************************************************************************
MAIN_PROG CODE                      ; let linker place main program

START:	movlw	H'FF'		    ; all inputs
	movwf	ADCON1, ACCESS	    
	movlw	H'07'		    ; initialization
	movwf	state, ACCESS
	clrf	direction	    ; clear direction
	clrf	speed		    ; clear speed
	CALL	LEDCon		    ; configure leds
LOOP:
	CALL	LEDFlash	    ; flash an led
	CALL	XSTATE		    ; change state
	CALL	DELAY		    ; delay
	GOTO	LOOP		    ; repeat
		
		END