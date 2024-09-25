; PIN DEFINATIONS
		; LCD
		LCD_PORT	EQU		P1
		LCD_RS		EQU		P3.0
		LCD_ENABLE	EQU		P3.1

		;KEYPAD
		KEY_PORT	EQU		P2

		;BUZZER
		BUZZER		EQU		P3.7

		;LED SET
		ALRMSET		EQU		P3.6

; DATA DEFINATIONS
		MSCND		EQU		020H
		SCND		EQU		021H
		MINT		EQU		022H
		HOUR		EQU		023H
		KEYMEM		EQU		024H
		STOPW		EQU		025H
		REALMSCND	EQu		026H
		REALSCND	EQU		027H
		REALMINT	EQU		028H
		REALHOUR	EQU		029H
		ALRMMINT	EQU		02AH
		ALRMHOUR	EQU		02BH
		ISALRM		EQU		02CH
		ISSNZ		EQU		02DH
		MODE		EQU		02EH
		SOLUTION	EQU		02FH
		ACTUAL		EQU		030H
		RNG			EQU		031H
		BUFF		EQU		032H

; TEXT
		ORG		0000H
		LJMP	MAIN

		ORG		000BH
		LJMP	TIMER0ISR

		ORG		001BH
		LJMP	TIMER1ISR

		ORG		0030H
MAIN:
		SETB	BUZZER
		MOV		SP,			#55H		; MOVING SP TO SCRATCHPAD
		MOV		KEYMEM,		#' '
		MOV		MODE,		#01H
		MOV		ALRMHOUR,	#00H
		MOV		ALRMMINT,	#00H
		MOV		ISALRM,		#00H
		MOV		ISSNZ,		#00H

		LCALL	RESETSTOP

		LCALL	SETUPTIMERS
		LCALL	LCD_INIT
		LCALL	KEYPAD_INIT

		SETB	TR1
		MOV		RNG,		TL0
MAINLOOP:
		LCALL	KEYPAD_SCAN

		MOV		C,	ISALRM.0
		MOV		ALRMSET,	C

		; check if alarm time
		MOV		A,			ISALRM
		JZ		SKIP_ALRM

		MOV		A,			REALMINT
		XRL		A,			ALRMMINT
		JNZ		SKIP_ALRM

		MOV		A,			REALHOUR
		XRL		A,			ALRMHOUR
		JNZ		SKIP_ALRM

		MOV		MODE,		#04H

SKIP_ALRM:
		MOV		A,			KEYMEM
		XRL		A,			#'A'
		MOV		B,			A
		MOV		A,			MODE
		XRL		A,			#00H
		ORL		A,			B
		JZ		START_WATCH

		MOV		A,			KEYMEM
		XRL		A,			#'B'
		MOV		B,			A
		MOV		A,			MODE
		XRL		A,			#00H
		ORL		A,			B
		JZ		STOP_WATCH

		MOV		A,			KEYMEM
		XRL		A,			#'C'
		MOV		B,			A
		MOV		A,			MODE
		XRL		A,			#00H
		ORL		A,			B
		JZ		RESET_WATCH

		MOV		A,			KEYMEM
		XRL		A,			#'D'
		JZ		CHANGEMODE

		MOV		A,			KEYMEM
		XRL		A,			#'#'
		JZ		STOPMODE

		MOV		A,			KEYMEM
		XRL		A,			#'*'
		JZ		ALRM_MODE

		SJMP	DONE

START_WATCH:
		MOV		A,			STOPW
		JNZ		DONE
		SETB	TR0
		MOV		STOPW,		#01H
		SJMP	DONE

STOP_WATCH:
		MOV		A,			STOPW
		JZ		DONE
		CLR		TR0
		MOV		STOPW,		#00H
		SJMP	DONE

RESET_WATCH:
		LCALL	RESETSTOP
		SJMP	DONE

ALRM_MODE:
		LCALL	RESETSTOP
		MOV		MODE,		#03H
		LJMP	CHANGEMODE_DONE

CHANGEMODE:
		LCALL	RESETSTOP
		MOV		A,		MODE
		JZ		GO_TO_CLOCK

		XRL		A,		#01H
		JZ		GO_TO_EDIT

GO_TO_CLOCK:
		MOV		MODE,		#01H
		SJMP	CHANGEMODE_DONE

GO_TO_EDIT:
		MOV		MODE,		#02H

CHANGEMODE_DONE:
		MOV		A,		#01H
		LCALL	LCD_COMMAND
		LCALL	DELAY
		SJMP	DONE

STOPMODE:
		MOV		MODE,	#00H
		MOV		A,		#01H
		LCALL	LCD_COMMAND
		LCALL	DELAY
		SJMP	DONE

DONE:
		MOV		A,			MODE
		XRL		A,			#00H
		JZ		STOPWATCH

		MOV		A,			MODE
		XRL		A,			#01H
		JZ		CLOCK

		MOV		A,			MODE
		XRL		A,			#02H
		JZ		EDITTIME

		MOV		A,			MODE
		XRL		A,			#03H
		JZ		ALRMMODE

		MOV		A,			MODE
		XRL		A,			#04H
		JZ		ALRMRESOLVE

		LJMP	MAINLOOP

STOPWATCH:
		LCALL	DISPLAY_STOPWATCH
		LJMP	MAINLOOP

CLOCK:
		LCALL	DISPLAY_CLOCK
		LJMP	MAINLOOP

EDITTIME:
		CLR		TR1
		LCALL	DISPLAY_EDITTIME
		LCALL	KEY_TAKE_TIME
		LCALL	SETUPTIMERS
		MOV		MODE,	#01H
		MOV		A,		#01H
		LCALL	LCD_COMMAND
		LCALL	DELAY
		SETB	TR1
		LJMP	MAINLOOP

ALRMMODE:
		LCALL	DISPLAY_ALRMTIME
		LCALL	KEY_TAKE_ALRM
		MOV		MODE,	#01H
		MOV		A,		#01H
		LCALL	LCD_COMMAND
		LCALL	DELAY
		LJMP	MAINLOOP

ALRMRESOLVE:
		CLR		BUZZER
		LCALL	DISPLAY_ALRMRESOLVE
		LCALL	KEY_TAKE_SOL

		MOV		A,		#01H
		LCALL	LCD_COMMAND
		LCALL 	DELAY

		LCALL	DISPLAY_SNOOZE
		LCALL	KEY_TAKE_SNOOZE

		SETB	BUZZER
		MOV		MODE,	#01H
		MOV		A,		#01H
		LCALL	LCD_COMMAND
		LCALL 	DELAY
		LCALL 	MAINLOOP

DISPLAY_SNOOZE:
		MOV		A,			#80H
		LCALL	LCD_DISPLAY

		MOV		DPTR,		#STEXT
		LCALL	COPYBUFFER
		LCALL	LCD_DISPLAYS

		RET

DISPLAY_ALRMRESOLVE:
		MOV		A,			#80H
		LCALL	LCD_COMMAND

		MOV		DPTR,		#EQN
		LCALL	COPYBUFFER
		LCALL	LCD_DISPLAYS

		MOV		A,			#0C0H
		LCALL	LCD_COMMAND

		LCALL	GENRAND

		MOV		A,			RNG
		SWAP	A
		ANL		A,			#0FH
		LCALL	NUM2ASCII
		LCALL	LCD_DISPLAYS

		MOV		A,			#'+'
		LCALL	LCD_DISPLAY

		MOV		A,			RNG
		ANL		A,			#0FH
		LCALL	NUM2ASCII
		LCALL	LCD_DISPLAYS

		MOV		A,			#'='
		LCALL	LCD_DISPLAY

		; CALCULATE ACTUAL SOLUTION
		MOV		A,			RNG
		ANL		A,			#0FH
		MOV		B,			A

		MOV		A,			RNG
		SWAP	A
		ANL		A,			#0FH
		ADD		A,			B
		MOV		ACTUAL,		A

		RET

DISPLAY_ALRMTIME:
		MOV		A,			#0CH
		LCALL	LCD_COMMAND

		MOV		A,			#80H
		LCALL	LCD_COMMAND

		MOV		DPTR,		#ATIME
		LCALL	COPYBUFFER
		LCALL	LCD_DISPLAYS

		MOV		A,			#0C0H
		LCALL	LCD_COMMAND

		MOV		DPTR,		#AHOLDER
		LCALL	COPYBUFFER
		LCALL	LCD_DISPLAYS

		RET

DISPLAY_EDITTIME:
		MOV		A,			#0CH
		LCALL	LCD_COMMAND

		MOV		A,			#80H
		LCALL	LCD_COMMAND

		MOV		DPTR,		#ETIME
		LCALL	COPYBUFFER
		LCALL	LCD_DISPLAYS

		MOV		A,			#0C0H
		LCALL	LCD_COMMAND

		MOV		DPTR,		#PHOLDER
		LCALL	COPYBUFFER
		LCALL	LCD_DISPLAYS

		RET

DISPLAY_CLOCK:
		MOV		A,			#0CH
		LCALL	LCD_COMMAND

		MOV		A,			#80H
		LCALL	LCD_COMMAND

		MOV		DPTR,		#CLK
		LCALL	COPYBUFFER
		LCALL	LCD_DISPLAYS

		MOV		A,			#' '
		LCALL	LCD_DISPLAY

		MOV		A,			KEYMEM
		LCALL	LCD_DISPLAY

		MOV		A,			#8FH
		LCALL	LCD_COMMAND

		MOV		A,			ISALRM
		JZ		SKIP_ALRM_PRINT

		MOV		A,			#10101000B
		LCALL	LCD_DISPLAY
SKIP_ALRM_PRINT:

		MOV		A,			#0C0H
		LCALL	LCD_COMMAND

		MOV		A,			REALHOUR
		LCALL	NUM2ASCII
		LCALL	LCD_DISPLAYS

		MOV		A,			#':'
		LCALL	LCD_DISPLAY

		MOV		A,			REALMINT
		LCALL	NUM2ASCII
		LCALL	LCD_DISPLAYS

		MOV		A,			#':'
		LCALL	LCD_DISPLAY

		MOV		A,			REALSCND
		LCALL	NUM2ASCII
		LCALL	LCD_DISPLAYS

		LCALL	DELAY

		RET

DISPLAY_STOPWATCH:
		MOV		A,			#0CH
		LCALL	LCD_COMMAND

		MOV		A,			#80H
		LCALL	LCD_COMMAND

		MOV		DPTR,		#MSG
		LCALL	COPYBUFFER
		LCALL	LCD_DISPLAYS

		MOV		A,			#' '
		LCALL	LCD_DISPLAY

		MOV		A,			KEYMEM
		LCALL	LCD_DISPLAY

		MOV		A,			#0C0H
		LCALL	LCD_COMMAND

		MOV		A,			HOUR
		LCALL	NUM2ASCII
		LCALL	LCD_DISPLAYS

		MOV		A,			#':'
		LCALL	LCD_DISPLAY

		MOV		A,			MINT
		LCALL	NUM2ASCII
		LCALL	LCD_DISPLAYS

		MOV		A,			#':'
		LCALL	LCD_DISPLAY

		MOV		A,			SCND
		LCALL	NUM2ASCII
		LCALL	LCD_DISPLAYS

		MOV		A,			#'.'
		LCALL	LCD_DISPLAY

		MOV		A,			MSCND
		LCALL	NUM2ASCII
		LCALL	LCD_DISPLAYS
		RET

RESETSTOP:
		CLR		TR0
		MOV		MSCND,		#00H
		MOV		SCND,		#00H
		MOV		MINT,		#00H
		MOV		HOUR,		#00H
		MOV		STOPW,		#00H
		RET

;---------- Utilities -----------;
GENRAND:
		MOV		A,		RNG
		JNZ		GENRANDB
		CPL		A
		MOV		RNG,	A
GENRANDB:
		ANL		A,		#10111000B
		MOV		C,		P
		MOV		A,		RNG
		RLC		A
		MOV		RNG,	A
		RET

COPYBUFFER:
		PUSH	00H
		PUSH	01H
		PUSH	07H

		MOV		R0,			#00H
		MOV		R1,			#BUFF
COPYBUFFER_LOOP:
		MOV		A,			R0
		MOVC	A,			@A+DPTR
		MOV		@R1,		A
		JZ		COPYBUFFER_DONE
		INC		R0
		INC		R1
		SJMP	COPYBUFFER_LOOP
COPYBUFFER_DONE:
		POP		07H
		POP		01H
		POP		00H
		RET

NUM2ASCII:
		PUSH	00H

		MOV		R0,			#BUFF
		MOV		B,			#10
		DIV		AB
		
		ADD		A,			#30H
		MOV		@R0,		A
		INC		R0
		MOV		A,			B

		ADD		A,			#30H
		MOV		@R0,		A
		INC		R0

		MOV		@R0,		#00H		; NULL BYTE

		POP		00H
		RET

;---------- LCD Code -----------;
LCD_INIT:
		MOV		LCD_PORT,	#00H
		CLR		LCD_PORT
		CLR		LCD_ENABLE
		CLR		LCD_RS

		MOV		A,			#38H
		LCALL	LCD_COMMAND

		MOV		A,			#0CH
		LCALL	LCD_COMMAND

		MOV		A,			#06H
		LCALL	LCD_COMMAND

		MOV		A,			#01H
		LCALL	LCD_COMMAND	

		MOV		A,			#80H
		LCALL	LCD_COMMAND

		RET

LCD_DISPLAYS:
		PUSH	00H
		MOV		R0,			#BUFF
LCD_DISPLAYS_LOOP:
		MOV		A,			@R0
		JZ		LCD_DISPLAYS_DONE
		LCALL	LCD_DISPLAY
		INC		R0
		SJMP	LCD_DISPLAYS_LOOP
LCD_DISPLAYS_DONE:
		POP		00H
		RET

LCD_DISPLAY:
		LCALL	LCD_WAIT

		SETB	LCD_RS
		
		MOV		LCD_PORT,	A
		SETB	LCD_ENABLE
		NOP
		CLR		LCD_ENABLE
		NOP

		RET

LCD_COMMAND:
		LCALL	LCD_WAIT

		CLR		LCD_RS
		
		MOV		LCD_PORT,	A
		SETB	LCD_ENABLE
		NOP
		CLR		LCD_ENABLE
		NOP

		RET

LCD_WAIT:
		PUSH	07H
		MOV		R7,		#0FFH
		LCALL	SIMPLE_DELAY
		MOV		R7,		#0FFH
		LCALL	SIMPLE_DELAY
		POP		07H
		RET

;---------- DELAYS ---------;

SIMPLE_DELAY:
		DJNZ	R7,		SIMPLE_DELAY
		RET


DELAY:
	PUSH	03H
	PUSH	07H
	MOV		R3,			#255D
AGAIN:
	MOV		R7,			#255D
	ACALL	SIMPLE_DELAY
	DJNZ		R3,			AGAIN
	
	POP		07H
	POP		03H
	RET

; ------KEYPAD---------
KEYPAD_INIT:
	MOV		KEY_PORT,	#0FFH
	RET

KEYPAD_IDX:
	PUSH	00H
	MOV		R0,		A

	MOV		A,		R0
	XRL		A,		#00001110B
	JZ		KEYPAD_IDX_ZERO
	
	MOV		A,		R0
	XRL		A,		#00001101B
	JZ		KEYPAD_IDX_ONE
	
	MOV		A,		R0
	XRL		A,		#00001011B
	JZ		KEYPAD_IDX_TWO
	
	MOV		A,		R0
	XRL		A,		#00000111B
	JZ		KEYPAD_IDX_THREE

	MOV		A,		#04H
	SJMP	KEYPAD_IDX_DONE

KEYPAD_IDX_ZERO:
	MOV		A,		#00H
	SJMP	KEYPAD_IDX_DONE

KEYPAD_IDX_ONE:
	MOV		A,		#01H
	SJMP	KEYPAD_IDX_DONE

KEYPAD_IDX_TWO:
	MOV		A,		#02H
	SJMP	KEYPAD_IDX_DONE

KEYPAD_IDX_THREE:
	MOV		A,		#03H

KEYPAD_IDX_DONE:	
	POP		00H
	RET

KEYPAD_SCAN:
	PUSH	00H
	PUSH	01H
	PUSH	07H

	MOV		KEY_PORT,	#0F0H
	MOV		A,			KEY_PORT
	ANL		A,			#0F0H
	SWAP	A
	LCALL	KEYPAD_IDX
	MOV		R0,			A

	XRL		A,			#04H
	JZ		KEY_SCAN_DONT
	
	MOV		KEY_PORT,	#00FH
	MOV		A,			KEY_PORT
	ANL		A,			#00FH
	LCALL	KEYPAD_IDX
	MOV		R1,			A

	XRL		A,			#04H
	JZ		KEY_SCAN_DONT
	
	MOV		A,			R0
	RL		A
	RL		A
	ADD		A,			R1
	MOV		DPTR,		#KEYPADBUF
	
	MOVC	A,			@A+DPTR
	MOV		KEYMEM,		A
	SJMP	KEY_SCAN_DONE

KEY_SCAN_DONT:
	MOV		KEYMEM,		#' '

KEY_SCAN_DONE:
	POP		07H
	POP		01H
	POP		00H
	RET

KEY_TAKE_SNOOZE:
	MOV		A,			#0EH
KEY_SNZ:
	MOV		A,			#0C0H
	LCALL	LCD_COMMAND

	MOV		A,			#'?'
	LCALL	LCD_DISPLAY

	MOV		A,			#0C0H
	LCALL	LCD_COMMAND

	LCALL	KEY_TAKE_ONE_DIGIT
	MOV		B,	A
	CLR		C
	SUBB	A,	#02D
	LCALL	DELAY
	JNC		KEY_SNZ

	MOV		A,		B
	JZ		ALRM_STOP

	MOV		ISSNZ,	#01H
	MOV		A,		ALRMMINT
	ADD		A,		#05D
	MOV		ALRMMINT,	A
	RET

ALRM_STOP:
	MOV		ISSNZ,	#00H
	MOV		ISALRM,	#00H
	RET

KEY_TAKE_SOL:
	MOV		A,			#0EH
	LCALL	LCD_COMMAND
KEY_SOLVE:
	MOV		A,			#0C6H
	LCALL	LCD_COMMAND

	MOV		A,			#'?'
	LCALL	LCD_DISPLAY
	LCALL	LCD_DISPLAY

	MOV		A,			#0C6H
	LCALL	LCD_COMMAND

	MOV		A,			#SOLUTION
	LCALL	KEY_TAKE_ONE_NUMBER

	MOV		A,			SOLUTION
	XRL		A,			ACTUAL

	LCALL	DELAY

	JNZ		KEY_SOLVE

	RET

KEY_TAKE_ALRM:
	MOV		A,			#0EH
	LCALL	LCD_COMMAND

KEY_ALRMHOUR:
	MOV		A,			#0C0H
	LCALL	LCD_COMMAND

	MOV		A,			#'-'
	LCALL	LCD_DISPLAY
	LCALL	LCD_DISPLAY

	MOV		A,			#0C0H
	LCALL	LCD_COMMAND

	MOV		A,	#ALRMHOUR
	LCALL	KEY_TAKE_ONE_NUMBER

	MOV		A,	ALRMHOUR
	CLR		C
	SUBB	A,	#25D

	LCALL	DELAY

	JNC		KEY_ALRMHOUR

	MOV		A,	#':'
	LCALL	LCD_DISPLAY

KEY_ALRMMINT:
	MOV		A,			#0C3H
	LCALL	LCD_COMMAND

	MOV		A,			#'-'
	LCALL	LCD_DISPLAY
	LCALL	LCD_DISPLAY

	MOV		A,			#0C3H
	LCALL	LCD_COMMAND

	MOV		A,	#ALRMMINT
	LCALL	KEY_TAKE_ONE_NUMBER

	MOV		A,	ALRMMINT
	CLR		C
	SUBB	A,	#61D

	LCALL	DELAY

	JNC		KEY_ALRMMINT

KEY_ALRMSET:
	MOV		A,			#0C6H
	LCALL	LCD_COMMAND

	MOV		A,			#'?'
	LCALL	LCD_DISPLAY

	MOV		A,			#0C6H
	LCALL	LCD_COMMAND

	LCALL	KEY_TAKE_ONE_DIGIT
	MOV		B,	A
	CLR		C
	SUBB	A,	#02D
	LCALL	DELAY
	JNC		KEY_ALRMSET

	MOV		ISALRM,		B

	RET

KEY_TAKE_TIME:
	MOV		A,			#0EH
	LCALL	LCD_COMMAND

KEY_REALHOUR:
	MOV		A,			#0C0H
	LCALL	LCD_COMMAND

	MOV		A,			#'-'
	LCALL	LCD_DISPLAY
	LCALL	LCD_DISPLAY

	MOV		A,			#0C0H
	LCALL	LCD_COMMAND

	MOV		A,	#REALHOUR
	LCALL	KEY_TAKE_ONE_NUMBER

	MOV		A,	REALHOUR
	CLR		C
	SUBB	A,	#25D

	LCALL	DELAY

	JNC		KEY_REALHOUR

	MOV		A,	#':'
	LCALL	LCD_DISPLAY

KEY_REALMINT:
	MOV		A,			#0C3H
	LCALL	LCD_COMMAND

	MOV		A,			#'-'
	LCALL	LCD_DISPLAY
	LCALL	LCD_DISPLAY

	MOV		A,			#0C3H
	LCALL	LCD_COMMAND

	MOV		A,	#REALMINT
	LCALL	KEY_TAKE_ONE_NUMBER

	MOV		A,	REALMINT
	CLR		C
	SUBB	A,	#61D

	LCALL	DELAY

	JNC		KEY_REALMINT

	MOV		A,	#':'
	LCALL	LCD_DISPLAY

KEY_REALSCND:
	MOV		A,			#0C6H
	LCALL	LCD_COMMAND

	MOV		A,			#'-'
	LCALL	LCD_DISPLAY
	LCALL	LCD_DISPLAY

	MOV		A,			#0C6H
	LCALL	LCD_COMMAND

	MOV		A,	#REALSCND
	LCALL	KEY_TAKE_ONE_NUMBER

	MOV		A,	REALSCND
	CLR		C
	SUBB	A,	#61D

	LCALL	DELAY

	JNC		KEY_REALSCND

	RET

KEY_TAKE_ONE_NUMBER:
	PUSH	00H
	PUSH	01H
	MOV		R0,		A

	LCALL	KEY_TAKE_ONE_DIGIT
	MOV		B,		#10D
	MUL		AB
	MOV		R1,		A
	LCALL	KEY_TAKE_ONE_DIGIT
	ADD		A,		R1
	
	MOV		@R0,	A

	POP		01H
	POP		00H
	RET

KEY_TAKE_ONE_DIGIT:
	PUSH	07H
	PUSH	02H
	PUSH	01H
	
KEY_NO_INPUT_DEBOUNCE:
	LCALL	KEYPAD_SCAN
	MOV		A,	KEYMEM
	XRL		A,	#' '
	JZ		KEY_NO_INPUT_DEBOUNCE
	LCALL	KEYPAD_SCAN
	MOV		A,	KEYMEM
	LCALL	DELAY
	LCALL	KEYPAD_SCAN
	XRL		A,	KEYMEM
	JNZ		KEY_NO_INPUT_DEBOUNCE

	MOV		B,	KEYMEM
	MOV		R2,	#10H
	MOV		R1,	#'0'
KEY_CHECK_NUMBER:
	MOV		A,	B
	XRL		A,	R1
	JZ		KEY_IS_NUMBER
	INC		R1
	DJNZ	R2,	KEY_CHECK_NUMBER
KEY_NOT_NUMBER:
	SJMP	KEY_NO_INPUT_DEBOUNCE
KEY_IS_NUMBER:
	MOV		A,	B
	LCALL	LCD_DISPLAY
	XRL		A,		#'0'
	
	POP		01H
	POP		02H
	POP		07H
	RET
	

; --------TIMERS----------
SETUPTIMERS:
	MOV		TMOD,		#11H
	MOV		TH0,		#0DBH
	MOV		TL0,		#0F0H
	MOV		TH1,		#0DBH
	MOV		TL1,		#0F0H
	MOV		IE,			#10001010B
	RET

TIMER0ISR:
	CLR		TR0
	PUSH	0D0H
	PUSH	0E0H
	PUSH	0F0H

	INC		MSCND

	; SECOND CALCULATION
	MOV		A,			MSCND
	MOV		B,			#100D
	DIV		AB
	MOV		MSCND,		B
	ADD		A,			SCND
	MOV		SCND,		A

	; MINUTE CALCULATION
	MOV		B,			#60D
	DIV		AB
	MOV		SCND,		B
	ADD		A,			MINT
	MOV		MINT,		A

	; HOUR CALCULATION
	MOV		B,			#60D
	DIV		AB
	MOV		MINT,		B
	ADD		A,			HOUR
	MOV		HOUR,		A

	MOV		TH0,		#0DCH
	MOV		TL0,		#000H
	MOV		A,			STOPW
	JZ		TIMER0_SKIP_START
	SETB	TR0
TIMER0_SKIP_START:
	POP		0F0H
	POP		0E0H
	POP		0D0H
	RETI

TIMER1ISR:
	CLR		TR1
	PUSH	0D0H
	PUSH	0E0H
	PUSH	0F0H

	INC		REALMSCND
	; Update real time
	; SECOND CALCULATION
	MOV		A,			REALMSCND
	MOV		B,			#100D
	DIV		AB
	MOV		REALMSCND,		B
	ADD		A,			REALSCND
	MOV		REALSCND,		A

	; MINUTE CALCULATION
	MOV		B,			#60D
	DIV		AB
	MOV		REALSCND,		B
	ADD		A,			REALMINT
	MOV		REALMINT,		A

	; HOUR CALCULATION
	MOV		B,			#60D
	DIV		AB
	MOV		REALMINT,		B
	ADD		A,			REALHOUR
	MOV		REALHOUR,		A
	MOV		TH1,		#0DCH
	MOV		TL1,		#000H

	MOV		A,			MODE
	XRL		A,			#04H
	JNZ		TIMER1ISR_DONE

	MOV		A,			ISSNZ
	JNZ		TIMER1CONT

	MOV		A,			REALSCND
	MOV		C,			P
	MOV		BUZZER,		C
	SJMP	TIMER1ISR_DONE

TIMER1CONT:
	CLR		BUZZER

TIMER1ISR_DONE:
	POP		0F0H
	POP		0E0H
	POP		0D0H
	SETB	TR1
	RETI

; DATA
MSG:		DB	"STOPWATCH", 0
CLK:		DB	"CLOCK", 0
ETIME:		DB	"EDIT TIME", 0
ATIME:		DB	"ALRM HH:MM (0/1)", 0
EQN:		DB	"SOLVE", 0
PHOLDER:	DB	"--:--:--", 0
AHOLDER:	DB	"--:-- ?", 0
STEXT:		DB	"STP(0) / SNZ(1)", 0
KEYPADBUF:
		DB	"123A"
		DB	"456B"
		DB	"789C"
		DB	"*0#D"
END