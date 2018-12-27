	.include "address_map_arm.s"
	.include "defines.s"
/*
 * This program demonstrates the use of interrupts using the KEY and timer ports. It
 * 	1. displays a sweeping red light on LEDR, which moves left and right
 * 	2. stops/starts the sweeping motion if KEY3 is pressed
 * Both the timer and KEYs are handled via interrupts
*/
			.text
			.global	_start
_start:
			/* Set up stack pointers for IRQ and SVC processor modes */
			MOV		R1, #INT_DISABLE | IRQ_MODE
			MSR		CPSR_c, R1					// change to IRQ mode
			LDR		SP, =0xFFFFFFFC	// set IRQ stack to top of A9 on-chip memory
			/* Change to SVC (supervisor) mode with interrupts disabled */
			MOV		R1, #INT_DISABLE | SVC_MODE
			MSR		CPSR, R1						// change to supervisor mode
			LDR		SP, =0x3FFFFFFC			// set SVC stack to top of DDR3 memory

			BL			CONFIG_GIC				// configure the ARM generic interrupt controller
			BL			CONFIG_PRIV_TIMER		// configure the MPCore private timer
			BL			CONFIG_KEYS				// configure the pushbutton KEYs

			/* enable ARM processor interrupts */
			MOV		R1, #INT_ENABLE | SVC_MODE
			MSR		CPSR_c, R1

			LDR		R6, =0xFF200000 		// red LED base address
MAIN:
			LDR		R4, LEDR_PATTERN		// LEDR pattern; modified by timer ISR
			STR 		R4, [R6] 				// write to red LEDs
			B 			MAIN

/* Configure the MPCore private timer to create interrupts every 1/10 second */
CONFIG_PRIV_TIMER:
			LDR		R0, =0xFFFEC600 		// Timer base address
			LDR		R1, =12500000				// Load timer
			STR		R1, [R0]
			MOV		R1, #7							// set bit int, auto, enable
			STR		R1, [R0, #0x8]
			MOV 		PC, LR 					// return

/* Configure the KEYS to generate an interrupt */
CONFIG_KEYS:
			LDR 		R0, =0xFF200050 		// KEYs base address
			MOV		R1, #0xF
			STR		R1, [R0, #0x8]
			MOV 		PC, LR 					// return

			.global	LEDR_DIRECTION
LEDR_DIRECTION:
			.word 	0							// 0 means left, 1 means right

			.global	LEDR_PATTERN
LEDR_PATTERN:
			.word 	0x1
