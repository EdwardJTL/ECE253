	.text
	.global _start
_start:
	LDR R8, =0xFF200000	// LEDR port address
	LDR R9, =0xFF200050	// KEY port address
	LDR R4, =0xFFFEC600	// base address of timer

	MOV R1, #1		// initial on values
	MOV R2, #0		// direction values (0/1)
MAIN:	STR R1, [R8]		// write to LED and turn on LEDR0
	LDR R6, [R9]		// read key values
	CMP R6, #8		// check if KEY3 is pressed (1000)
	BLEQ	KEYPRESS	// routine to stop LEDRs
	
	CMP R1, #512		// see if LEDR9 is up (0b10 0000 0000)
	MOVEQ R2, #1		// change direction variable (right)
	
	CMP R1, #1		// if LEDR0 is up (0b1)
	MOVEQ R2, #0		// chagne direction variable (left)

	CMP R2, #0
	LSLEQ R1, #1		// sweep left if 0
	LSRNE R1, #1		// sweep right if 1

	BL DELAY		// use clock to slow down
	B MAIN			// loop main program

	// we need two routines to take care of press key
WAIT:	BL DELAY
	LDR R6, [R9]		// Read Key status
	CMP R6, #8		// is key3 pressed
	BNE WAIT		// if key 3 is not pressed, keep waiting
	MOV R3, #0		// if pressed, set R3 to 0
	B KEYPRESS
// routine to make delay
DELAY:	LDR R0,=12500000	// how many clock cycles before the delay finishes
	STR R0, [R4]		// put this in the timer base address (start value)
	MOV R0, #0b011		// no prescale, no interrupt, autoreload, start
	STR R0, [R4, #8]	// put this in control register
LOOP:	LDR R0, [R4, #0xC]	// fetch interrrupt status
	CMP R0, #0		// is counter done? (0 is not done)
	BEQ LOOP		// loop until counter reports done
	STR R0, [R4, #0xC]	// reset interrupt status to 0
	MOV PC, LR		// finish counting, exit DELAY subroutine

KEYPRESS:
	LDR R6, [R9]		// read from KEYs
	CMP R6, #0		// Keys not pressed?
	BNE KEYPRESS		// if key is pressed, loop until its not
	CMP R3, #8		// the previously registered state of key press (key3 down)
	BEQ WAITT		// if the key was pressed, go into wait
	BNE DISPLAY		// if the previous state was not pressed, go back to main
