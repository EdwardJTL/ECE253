	/* Program that sorts a list of 'words' */
	.text
	.global _start
_start:
	/* Use R4 to hold the number of elements */
	/* Use R5 to hold "swapped" variable */
	/* Use R6 as for loop counter */
	/* Use R7 to hold number of address shifts */
	LDR	R4, =List	/* load num elements */
	MOV	R5, #0	/* initialize swapped variable */
LOOP_W:	MOV	R5, #0		/* reset swapped variable at the start of while loop */
	MOV	R6, #1		/* initialize counter variable */
	MOV R7, #4	/* initialize shift value */
LOOP_F:	
	ADD	R0, R4, R7	/* set R0 to the address of the element, shift address at R4 by value in R7 */
	B	SWAP		/* call swap subroutine */
RETURN:	CMP	R0, #1		/* check if return value from subroutine SWAP is 1 (it is unlikely that the input argument R0 was */
	MOVEQ	R5, #1		/* if return value is 1, set swapped (R5) to 1 */
	ADD	R6, R6, #1	/* add one to counter (R6) */
	Add R7, R7, #4	/* add 4 to shift */
	LDR R1, [R4]
	SUB	R1, R1, #1	/* store num-1 into R1 */
	SUB	R1, R1, R6	/* num-1-counter */
	CMP R1, #0		/* check if nunm-1-counter == 0 */
	BNE	LOOP_F		/* if num-1 != counter, keep in for loop */
	CMP	R5, #1		/* see if swapped happened (ie. R5 == 0) */
	BEQ	LOOP_W		/* if swapped, keep in while loop */
END:	B END
SWAP:	PUSH	{R10}	/* clears R10 for use */
	LDR	R1, [R0]	/* load the ith element into R1 */
	LDR	R2, [R0, #4]	/* load the i+1th element into R2 */
	CMP	R1, R2	/* compare ith and i+1th, flag is LS if higher */
	STRLS	R2, [R0]	/* load the i+1th element into the address of ith element */
	LDR R10, [R0]	/* load the new(?) ith element into R10 */
	SUB R10, R10, R1	/* find difference between the new and old value of the ith element*/
	CMP	R10, #0	/* compare the previously fetched value of ith element with the newly fetched value */
	STRNE	R1, [R0, #4]	/* if ith element changed, load ith old value into i+1th address */
	CMP	R10, #0	/* compare the previously fetched value of ith element with the newly fetched value */
	MOVNE	R0, #1		/* if ith element changed, set return value to 1 */
	POP	{R10}		/* retrievew register value from stack */
	B RETURN		/* return to main program */
	
List:	.word 10, 1400, 45, 23, 5, 3, 8, 17, 4, 20, 33


