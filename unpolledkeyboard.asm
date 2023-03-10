.text
.globl main
main:
	li	a0, '?'
	jal putkey
	jal getkey
	jal putkey
	b	main

getkey:
#	lw	t0, KBSR
	#lw	a0, (t0)
#	beq	zero, a0, getkey

	lw	t0, KBDR
	lw	a0, (t0)

#for debug
	li	a7, 11
	ecall
nonewkey:	ret
	
putkey:
	lw	t0, DSR
	lw	t0, (t0)
	beq	zero, t0, putkey

	lw	t0, DDR
	sw	a0, (t0)

#for debug
	li	a7, 11
	ecall
	ret
	
.data
KBSR:	.word	0xffff0000
KBDR:	.word	0xffff0004
DSR:	.word	0xffff0008
DDR:	.word	0xffff000c
