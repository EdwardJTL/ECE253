/* Program that counts consecutive 1's */
		.text
		.global	_start
_start:
		LDR	R4, =TEST_NUM	//load the data word into R1
		MOV	R5, #0			//R5 will hold the result
MAIN:	LDR R1, [R4]
		ADD R4, #4
		CMP R1, #0
		BEQ END
		BL ONES
		CMP R5, R0
		MOVLT R5, R0
		B MAIN
ONES:	MOV R0, #0
LOOP: CMP R1, #0
		BEQ L_END
		LSR R2, R1, #1		//perform SHIFT, followed by AND
		AND	R1, R2, R1
		Add	R0, #1			//count the string lengths so far
		B	LOOP
L_END:	MOV PC, LR
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
