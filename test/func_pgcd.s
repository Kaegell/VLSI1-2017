/*----------------------------------------------------------------
//           Mon premier programme                              //
----------------------------------------------------------------*/
	.text
	.globl	_start 
_start:               
	/* 0x00 Reset Interrupt vector address */
	MOV		r0, #4
	MOV		r1, #2
	BL		pgcd
	B		_good
	
	/* 0x04 Undefined Instruction Interrupt vector address */
	b		_bad

_bad :
	add		r0, r0, r0

_good :
	add		r1, r1, r1

pgcd :
	/*returns if r0 == r1*/
	SUBS	r2, r0, r1
	BXEQ	lr
	SUBLT	r1, r1, r0
	SUBGT	r0, r0, r1
	B pgcd
	
