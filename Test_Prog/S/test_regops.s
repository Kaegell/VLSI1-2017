/*----------------------------------------------------------------
//           Mon premier programme                              //
//           Test branch good                                   //
----------------------------------------------------------------*/
	.text
	.globl	_start 
_start:               
	/* 0x00 Reset Interrupt vector address */
  mov R1, #4
  mov R2, #9
  add R4, R1, R2
  sub R4, R4, #3
	b	_good
	nop

_bad :
	nop
	nop
_good :
	nop
	nop
