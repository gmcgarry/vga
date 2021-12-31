	; STC15W408AS @ 25.175MHz, Tcycle = 40ns

	; 640x480 (clock 25.175MHz)
	; pixel is ~40ns

	; SETB: 3 Tcycles = 2 pixel clocks
	; CLR: 3 Tcycles
	; SJMP: 3 Tcycles
	; LCALL: 4 Tcycles
	; RET: 4 Tcyccles
	; NOP: 1 Tcycles
	; DJNZ: 5 Tcycles (direct)

	; H: scanline 31.777us (31.468kHz)
	; H: data 25.42us
	; H: back porch 1.906us
	; H: pulse 3.813us
	; H: front porch 0.635us

	; V: frame 16.68ms (60Hz)	[525 lines]
	; V: data 15.253ms		[480 lines]
	; V: front porch 0.35ms		[11 lines]
	; V: pulse 0.063ms		[2 lines]
	; V: back porch 0.985ms		[31 lines]

	; Line:
	; total: 800 Tcycles
	; data: 640 Tcycles
	; fp: 16 Tcycles
	; pulse: 96 Tcycles
	; bp: 48 Tcycles
	
	P1M0	EQU	0x92
	P1M1	EQU	0x91

	LEDPIN	EQU	P1.0
	BUTTON	EQU	P3.2
	HSYNC	EQU	P1.1
	VSYNC	EQU	P1.2
	RGB	EQU	P1.3

	TopCount EQU	0x20
	BotCount EQU	0x21
	LCount0 EQU	0x22

	.org	0x0000
	SJMP	main

main:
	MOV	SP,#3Fh

	MOV	P1M0,#0xff	; push-pull
	MOV	P1M1,#0x00

	SETB	VSYNC		; 0-2
	NOP			; 3

LoopV:				; 0-4 in loop

	; ------------------------------------------------------------
	; 640 - 4 Tcycles = 8 + 4*157
	CLR	VSYNC 		; (3) 0-2
	CLR	RGB		; (3) 3-5
	MOV	R0,#157		; (2) 6-7
	DJNZ	R0,$		; (4)

	LCALL	FrontPorch	; (16)
	LCALL	HSync		; (96)
	LCALL	BackPorch	; (39)

	NOP			; (1)	; to make 9 cycles
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	CPL	LEDPIN		; (3)
	; ------------------------------------------------------------

	; ------------------------------------------------------------
	; 640 Tcycles = 8 + 4*155 + 12
	CLR	VSYNC 		; (3) 0-2
	NOP
	NOP
	NOP
	MOV	R0,#155		; (2) 6-7
	DJNZ	R0,$		; (4)

	NOP
	NOP
	NOP
	MOV	TopCount,#246	; (3)
	MOV	BotCount,#247	; (3)
	MOV	LCount0,#5	; (3)

	LCALL	FrontPorch	; (16)
	LCALL	HSync		; (96)
	LCALL	BackPorch	; (39)

	NOP			; (1)	; to make 9 cycles
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	SETB	VSYNC		; (3)
	; ------------------------------------------------------------

BlankLoopTop:			; now, the blank area at the top (209 lines)

	; ------------------------------------------------------------
	; 640 Tcycles = 8 + 4*158
	CLR	RGB 		; (3) 0-2
	NOP
	NOP
	NOP
	MOV	R0,#158		; (2)
	DJNZ	R0,$		; (4)

	LCALL	FrontPorch	; (16)
	LCALL	HSync		; (96)
	LCALL	BackPorch	; (39)

	NOP			; to make 9 cycles
	NOP
	NOP
	NOP
	DJNZ	TopCount,BlankLoopTop	  	; (5)
	; ------------------------------------------------------------

	.include "text_25mhz.inc"	; 6x5		(30 lines)
	
BlankLoopBot:			; now, the blank area at the bottom (209 lines)

	; ------------------------------------------------------------
	; 640 Tcycles = 8 + 4*158
	CLR	RGB		; (3)
	NOP
	NOP
	NOP
	MOV	R0,#158		; (2)
	DJNZ	R0,$		; (4)

	LCALL	FrontPorch	; (16)
	LCALL	HSync		; (96)
	LCALL	BackPorch	; (39)

	NOP			; to make 9 cycles
	NOP
	NOP
	NOP
	DJNZ	BotCount,BlankLoopBot	  	; (5)

	LJMP	LoopV		; (4) - compensated at top of loop
	; ------------------------------------------------------------


; XXXGJM: fp & bp are tweaked for specific display

; 16 Tcycles
FrontPorch:			; (4)
	NOP			; (1)
	CLR	RGB		; (3)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	RET			; (4)

; 39 Tcycles = 4 + 2 + 4*7 + 1 + 4
BackPorch:			; (4) 
	MOV	R0,#4		; (2)
	DJNZ	R0,$		; (4)
	NOP			; (1)
	NOP			; (1)
	RET			; (4)

; 36 cycles
BackPorch72:			; (4)
	MOV	R0,#3		; (2)
	DJNZ	R0,$		; (4)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	RET			; (4)

; 96 Tcycles = 7 + 2 + 20*4 + 7
HSync:				; (4)
	CLR	HSYNC		; (3)
	MOV	R0,#20		; (2)
	DJNZ	R0,$		; (4)
	SETB	HSYNC		; (3)
	RET			; (4)
	
	.end
