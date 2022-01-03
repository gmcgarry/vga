;	Crystal 20MHz, Tcycle=200nS

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

    ; Line:
    ; total: 159 Tcycles
    ; data: 127 Tcycles
    ; fp: 3 Tcycles
    ; pulse:  19 Tcycles
    ; bp: 10 Tcycles
    
    ; Frame:
    ; 25 back porch 
    ; 8 border scan
    ; 176 blank
    ; 90 text
    ; 199 blank
    ; 8 border scan
    ; 2 front porch
    ; 2 sync pulse
    
    
    PROCESSOR   P16F630

include "p16f630.inc"

config FOSC = HS	; Oscillator Selection bits (internal RC oscillator)
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
   
RGB		EQU 2
VSYNC		EQU 1
HSYNC		EQU 0

TopCount	EQU	 0x20
BotCount	EQU	 0x21
LCount0		EQU	 0x22

blank	macro
	bcf     PORTC, RGB
	endm
point	macro
	bsf     PORTC, RGB
	endm

HSync	macro
	bcf     PORTC, HSYNC	; 1
	call	Delay1uS	; 2-6
	call	Delay1uS	; 7-11
	call	Delay1uS	; 12-16
	nop			; 17
	nop			; 18
	bsf     PORTC, HSYNC	; 19
	endm

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
	call    Delay10mkS     	; 4-53
	call    Delay10mkS     	; 54-103
	call	Delay1uS	; 104-108
	call	Delay1uS	; 109-113
	call	Delay1uS	; 114-118
	call	Delay1uS	; 119-123
	nop			; 124
	nop			; 125
	nop			; 126
	nop			; 127
	blank			; 128	    ; front porch
	nop			; 129
	nop			; 130
	HSync                   ; 131-149
	call	BackPorch
	
	blank			; 1
	nop			; 2
	nop			; 3
	call    Delay10mkS     	; 4-53
	call    Delay10mkS     	; 54-103
	call	Delay1uS	; 104-108
	call	Delay1uS	; 109-113
	nop			; 114
	nop			; 115
	movlw   225		; 116
	movwf   TopCount	; 117
	movlw	225		; 118
	movwf   BotCount	; 119
	movlw   5		; 120
	movwf   LCount0		; 121
	call	Delay1uS	; 122-125
	nop			; 126
	nop			; 127

	blank			; 128	    ; front porch
	nop			; 129
	HSync                   ; 131-149
	call	Delay1uS	; 150-154   ; back porch
	nop			; 155
	nop			; 156
	nop			; 157
	nop			; 158
	bsf     PORTC, VSYNC	; 159
				
BlankLoopTop:                   ; now, the blank area at the top (209 lines)
	blank      		; 1
	nop                     ; 2
	nop			; 3
	call    Delay10mkS     	; 4-53
	call    Delay10mkS     	; 54-103
	call	Delay1uS	; 104-108
	call	Delay1uS	; 109-113
	call	Delay1uS	; 114-118
	call	Delay1uS	; 119-123
	nop			; 124
	nop			; 125
	nop			; 126
	nop			; 127
	blank			; 128	    ; front porch
	nop			; 129
	nop			; 130
	HSync                   ; 131-149
	call	Delay1uS	; 150-154   ; back porch
	nop			; 155
	nop			; 156
	decfsz  TopCount      	; 157
	goto    BlankLoopTop  	; 158,159
	nop			; 159

	#include "pic16_20mhz.inc"	; 6x5	    (30 lines)
	
BlankLoopBot:                   ;now, the blank area at the bottom (209 lines)
	blank      	      	; 1
	nop                   	; 2
	nop		      	; 3
	
	call    Delay10mkS     	; 4-53
	call    Delay10mkS     	; 54-103
	call	Delay1uS	; 104-108
	call	Delay1uS	; 109-113
	call	Delay1uS	; 114-118
	call	Delay1uS	; 119-123
	nop			; 124
	nop			; 125
	nop			; 126
	nop			; 127
	blank			; 128	    ; front porch
	nop			; 129
	nop			; 130
	HSync                   ; 131-149
	call	Delay1uS	; 150-154   ; back porch
	nop			; 155
	nop			; 156
	decfsz  BotCount      	; 157
	goto    BlankLoopBot  	; 158,159
	goto    LoopV		; 159,160

BackPorch:			; 1,2
	nop			; 3
	nop			; 4
	nop			; 5
	nop			; 6
	nop			; 7
	nop			; 7
	return			; 9,10
	
Delay1uS:			; 1,2
	nop			; 3
	return			; 4,5
	
Delay10mkS:			; 1,2
	nop			; 3
	call	Delay1uS
	call	Delay1uS
	call	Delay1uS
	call	Delay1uS
	call	Delay1uS
	call	Delay1uS
	call	Delay1uS
	call	Delay1uS
	call	Delay1uS
	return			; 4,5
	
	END
