.text
rpoll:	lw   t1, RCR # get RCR addr
	lw   t0, (t1)# get RCR value
	andi t0, t0, 1
	beq  t0, zero, rpoll
	lw   t1, RDR # get RDR addr
	lbu  a0, (t1) # read char
tpoll:	lw   t1, TCR
	lw   t0, (t1)
	andi t0, t0, 1
	beq  t0, zero, tpoll
	lw   t1, TDR
	sw   a0, (t1) # write char
	addi a0, a0, 1 # update char to next char in alphabet.
	sw   a0, (t1) # write updated char without checking status

	#did write updated char get displayed?
	b rpoll  # again!
	
.data
RCR:	.word 0xffff0000
RDR:	.word 0xffff0004
TCR:	.word 0xffff0008
TDR:	.word 0xffff000c
