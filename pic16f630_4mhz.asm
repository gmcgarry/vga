;	VGA Monitor Tester v.2.0
;	(c) 2001-03 Yuri Lysenkov aka YUSoft
;	http://www.hardw.net/russian/vga-test.php
;
;	based on the Eric Schlaepfer's MDA/CGA Tester
;	http://www.sonic.net/~schlae/pic.html

;	Ceramic resonator 4MHz, Tcycle=1mkS

;	(VGA: Video mode 640x480  HSync=-31,4KHz 1/HSync=32cycles
;				  VSync=-60Hz 1/VSync=16667cycles

	; 640x480 (clock 25.175MHz)

	; H: scanline 31.777us (31.468MHz)
	; H: data 25.42us
	; H: back porch 1.906us
	; H: pulse 3.813us
	; H: front porch 0.635us

	; V: frame 16.68ms (60Hz)	[525 lines]
	; V: data 15.253ms		[480 lines + 8 lines top/bottom border]
	; V: front porch 0.317ms	[2 lines]
	; V: pulse 0.063ms		[2 lines]
	; V: back porch 1.0486ms	[25 lines]

	; Frame:
	; 25 back porch 
	; 8 border scan
	; 176 blank
	; 105 text
	; 199 blank
	; 8 border scan
	; 2 front porch
	; 2 sync pulse
	
	
	PROCESSOR   P16F630

include "p16f630.inc"

config FOSC = INTRCIO   ; Oscillator Selection bits (internal RC oscillator)
config WDTE = OFF       ; Watchdog Timer (WDT disabled)
config PWRTE = OFF      ; Power-up Timer Enable bit (Power-up Timer is disabled)
config MCLRE = ON	; RA3/MCLR pin function select (RA3/MCLR pin function is digital I/O, MCLR internally tied to VDD)
config BOREN = OFF	; Brown-out Detect Enable bit (BOD disabled)
config CP = OFF         ; Code Protection bit (Code protection disabled)
config CPD = OFF        ; Data Code Protection bit (Data memory code protection is disabled)

; Pin Assignments
; LED = RA5
; BTN1 = RA4
; BTN2 = RA3
; RC1 = VSYNC
; RC2 = RGB
; RC0 = HSYNC
   
RGB EQU 2
VSYNC EQU 1
HSYNC EQU 0

TopCount	EQU	 0x20
BotCount	EQU	 0x21
LCount0	EQU	 0x22
LCount1	EQU	 0x23
LCount2	EQU	 0x24
LCount3	EQU	 0x25
LCount4	EQU	 0x26
LCount5	EQU	 0x27
LCount6	EQU	 0x28

blank	macro
	bcf     PORTC, RGB
	endm

point	macro
	bsf     PORTC, RGB
	endm

HSync	macro
	bcf     PORTC, HSYNC  ; horiz sync
	nop
	bsf     PORTC, HSYNC  ; horiz sync
	endm

	ORG	0x000
Reset:
	goto    Start
	
Start:
	; oscillator calibration
	BANKSEL	OSCCAL		; select bank 1
	call	0x3FF
	movwf	OSCCAL

	BANKSEL PORTC 		; select bank 0
	clrf    PORTC
	BANKSEL TRISC		; select bank 1
	clrf   	TRISC		; outputs
	BANKSEL PORTC		; select bank 0
	bsf     PORTC, VSYNC 	; vert sync

LoopV:				; 1 for the GOTO at the bottom
	bcf     PORTC, VSYNC 	; 2
	blank			; 3
	call    Delay10mkS     	; 4-13
	call    Delay10mkS     	; 14-23
	nop			; 24
	nop			; 25
	nop			; 26
	HSync                   ; 27-29
	nop			; 30
	nop			; 31
	nop			; 32

	blank			; 1
	nop			; 2
	nop			; 3
	call    Delay10mkS     	; 4-13
	nop			; 14
	nop			; 15
	movlw   209		; 16
	movwf   TopCount	; 17
	movwf   BotCount	; 18
	movlw   15		; 19
	movwf   LCount0		; 20
	movwf   LCount1		; 21
	movwf   LCount2		; 22
	movwf   LCount3		; 23
	movwf   LCount4		; 24
	movwf   LCount5		; 25
	movwf   LCount6		; 26
	HSync                   ; 27-29
	nop			; 30
	nop			; 31
	bsf     PORTC, VSYNC	; 32
				
BlankLoopTop:                   ; now, the blank area at the top (209 lines)
	blank      		; 1
	nop                     ; 2
	nop			; 3
	call    Delay10mkS     	; 4-13
	call    Delay10mkS     	; 14-23
	
	nop			; 24
	nop			; 25
	nop			; 26

	HSync                   ; 27-29

	decfsz  TopCount      	; 30
	goto    BlankLoopTop  	; 31
	nop			; 32

	#include "pic16_4mhz.inc"	; 7*15	    (105 lines)
			      
BlankLoopBot:                   ;now, the blank area at the bottom (209 lines)
	blank      	      	; 1
	nop                   	; 2
	nop		      	; 3
	call    Delay10mkS    	; 4-13
	call    Delay10mkS    	; 14-23
	
	nop			; 24
	nop			; 25
	nop			; 26

	HSync		      	; 27-29

	decfsz  BotCount      	; 30
	goto    BlankLoopBot  	; 31

	goto    LoopV	; 32/33

Delay10mkS:
	nop
	nop
	nop
	nop
	nop
	nop
	return

	END
