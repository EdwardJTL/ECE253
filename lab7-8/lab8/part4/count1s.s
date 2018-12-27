/* Program that counts consecutive 1's */
		.text
		.global	_start
_start:
		LDR	R12, =TEST_NUM	//load the data word into R7
		MOV	R5, #0			//R5 will hold the result
		MOV R6, #0
		MOV R7, #0
		LDR R8, =0x55555555
		LDR R9, =0xAAAAAAAA
MAIN:	LDR R1, [R12]	//Load word into R12
		CMP R1, #0
		BEQ END
		BL ONES	//Calls ONES subroutine
		CMP R5, R0	//Compare R5 with output R0 from the ONES
		MOVLT R5, R0	//Update R5 if R5<R0
		BL ZERO	//Calls ZERO Subroutine
		CMP R6, R0	//Compare R5 with output R0 from ZEROS
		MOVLT R6, R0	//Update R5 if R5<R0
		BL ALTERNATE	//Calls ALTERNATE Subroutine
		CMP R7, R0	//Compare R5 with output R0 from ALTERNATE
		MOVLT R7, R0	//Update R5 if R5<R0
		ADD R12, #4
		B MAIN
ONES:	MOV R0, #0	//reset R0 counter
LOOP: CMP R1, #0
		BEQ L_END	//stop if R1 is all zero
		LSR R2, R1, #1		//perform SHIFT, followed by AND
		AND	R1, R2, R1
		ADD	R0, #1			//count the string lengths so far
		B	LOOP
L_END:	MOV PC, LR	//end subroutine
ZERO:	LDR R1, [R12]
		MVN R1, R1	//bitwise NOT R1
		MOV R0, #0	//Reset R0 counter
		B LOOP	//goes into comparison loop
ALTERNATE: LDR R1, [R12]
		MOV R3, R1	//load the word into R3
		PUSH {R4,R10}	//push R4, R10 into the stack so they can be used in sub
		MOV R10, R1	//load the word into R10
		MOV R4, #0	//reset counter 1 R4
		MOV R0, #0	//reset counter 2 R0
		EOR R1, R1, R8	//bitwise XOR with 0101
		EOR R10, R10, R9	//bitwise XOR with 1010
AL_1: CMP R1, #0	//perform loop checks on R1
		BEQ AL_2	//go to second loop once this check is complete
		LSR R2, R1, #1
		AND R1, R2, R1
		ADD R0, #1	//increment R0 counter
		B AL_1	//loop
AL_2:	CMP R10, #0	//perform loop checks on R10
		BEQ AL_END	//finish subroutine
		LSR R2, R10, #1
		AND R10, R2, R10
		ADD R4, #1	//increment counter R4
		B AL_2	//loop
AL_END: CMP R0, R4	//compare two scores R0 and R4
		MOVLT R0, R4	//move R4 into R0 if R4>R0
		POP {R4, R10}	//restore registers from stack
		MOV PC, LR	//end subroutine
END:	B	END

TEST_NUM:	.word	0x103fe00f
		.word 0x8df0437b
		.word 0x714cb1b6
		.word 0x62ebdc64
		.word 0x1ad344f6
		.word 0x7518cec0
		.word 0x5a7fe872
		.word 0x523e22c3
		.word 0x2bd3a7e6
		.word 0x9ca39f7e
			.end
