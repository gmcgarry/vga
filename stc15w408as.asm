	; STC15W408AS, overclocked @ 38MHz, Tcycle = 26ns

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
	; total: 1208 Tcycles
	; data: 960 Tcycles
	; fp: 28 Tcycles
	; pulse: 145 Tcycles
	; bp: 75 Tcycles
	
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
	; 960 Tcycles
	CLR	VSYNC 		; (3) 0-2
	CLR	RGB		; (3) 3-5
	; 950 = 2 + 4*237
	MOV	R0,#237		; (2) 6-7
	DJNZ	R0,$		; (4)

	LCALL	FrontPorch	; (28)
	LCALL	HSync		; (145)
	LCALL	BackPorch	; (66)

	NOP			; (1)	; to make 9 cycles
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	NOP			; (1)
	CPL	LEDPIN		; (3)
	; ------------------------------------------------------------

	; ------------------------------------------------------------
	; 960 Tcycles
	CLR	VSYNC 		; (3) 0-2
	CLR	RGB		; (3) 3-5
	; 942 = 2 + 4*235 + 3
	MOV	R0,#234		; (2) 6-7
	DJNZ	R0,$		; (4)

	NOP
	NOP
	NOP
	MOV	TopCount,#246	; (3)
	MOV	BotCount,#247	; (3)
	MOV	LCount0,#5	; (3)

	LCALL	FrontPorch	; (28)
	LCALL	HSync		; (145)
	LCALL	BackPorch	; (66)

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
	; 960 Tcycles
	CLR	RGB 		; (3) 0-2
	; 952 = 2 + 4*238
	MOV	R0,#238		; (2) 3-4
	DJNZ	R0,$		; (4)

	LCALL	FrontPorch	; (28)
	LCALL	HSync		; (145)
	LCALL	BackPorch	; (66)

	NOP			; to make 9 cycles
	NOP
	NOP
	NOP
	DJNZ	TopCount,BlankLoopTop	  	; (5)
	; ------------------------------------------------------------

	.include "stc15_38mhz.inc"	; 6x5		(30 lines)
	
BlankLoopBot:			; now, the blank area at the bottom (209 lines)

	; ------------------------------------------------------------
	; 960 Tcycles
	CLR	RGB		; (3) 0-2
	; 952 = 2 + 4*2
	MOV	R0,#238		; (2) 3-4
	DJNZ	R0,$		; (4)

	LCALL	FrontPorch	; (28)
	LCALL	HSync		; (145)
	LCALL	BackPorch	; (66)

	NOP			; to make 9 cycles
	NOP
	NOP
	NOP
	DJNZ	BotCount,BlankLoopBot	  	; (5)

	LJMP	LoopV		; (4)
	; ------------------------------------------------------------


; XXXGJM: fp & bp are tweaked for specific display

; 28 Tcycles
; = 7+4+2 + 4*3 + 3
FrontPorch:			; (4) 0-3
	CLR	RGB		; (3) 4-6
	MOV	R0,#9		; (2) 7-8
	DJNZ	R0,$		; (4) 9-20
	NOP			; (1) 21
	NOP			; (1) 22
	RET			; (4) 24-27

; 75 Tcycles (less 9 cycles for external loops)
; = 8 + 4+4+2 + 4*14 + 0
BackPorch:			; (4) 0-3
	MOV	R0,#8		; (2) 4-5
	DJNZ	R0,$		; (4) 6-61
	NOP			; (1) 58
	RET			; (4) 62-65

; 75 cycles (less 12 cycles for external loops)
; = 11 + 4+4+2 + 4*14 + 1
BackPorch72:			; (4) 0-3
	MOV	R0,#8		; (2) 4-5
	DJNZ	R0,$		; (4) 6-57
	RET			; (4) 59-62

; 145 Tcycles
; = 7+7+2 + 4*32 + 1
HSync:				; (4) 0-3
	CLR	HSYNC		; (3) 4-6
	MOV	R0,#32		; (2) 7-8
	DJNZ	R0,$		; (4) 9-136
	SETB	HSYNC		; (3) 138-140
	RET			; (4) 141-144
	
	.end
