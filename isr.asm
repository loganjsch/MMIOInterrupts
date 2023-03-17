# Nichoals Zarate
# Logan Schwarz
.globl isr, count

isr:
	addi sp, sp, -32	# initialize the stack 
	sw ra, 28(sp)		# store saved values 
	sw t0, 24(sp)
	sw t1, 20(sp)
	sw t2, 16(sp)
	sw t3, 12(sp)
	sw t4, 8(sp)
	sw t5, 4(sp)
	

	la t0, handler
	csrrw zero, utvec, t0 #Set the handler’s address.
	
	li t1, 0x100
	csrrs t2, uie, t1 #Enable receiving device interrupts
	
	csrrsi zero, ustatus, 1 # Global interrupt enable
	
	lw t3, RCR
	lw t4, 0(t3)
	li t5, 0x2
	or t4, t4, t5 # enable sending
	lw t3, RCR
	sw t4, 0(t3)
	
	
	la a0, msg
	jal printString
	
	lw ra, 28(sp)	# reload all registers
	lw t0, 24(sp)
	lw t1, 20(sp)
	lw t2, 16(sp)
	lw t3, 12(sp)
	lw t4, 8(sp)
	lw t5, 4(sp)
	
	addi sp, sp, 32	# close stack counter
	ret

handler:
	addi sp, sp, -64	# intiialzie stack 
	sw ra, 60(sp)		# save all registers for return from stack 
	sw a7, 56(sp)	
	sw s0, 52(sp)
	sw s1, 48(sp)
	sw s2, 44(sp)
	sw s3, 40(sp)
	sw t0, 36(sp)
	sw t1, 32(sp)
	sw t2, 28(sp)
	sw t3, 24(sp)
	sw t4, 20(sp)
	sw t5, 16(sp)
	sw t6, 12(sp)
	

	jal readChar	# read char 
	mv s0, a0
	
	la a0, pressed	# jump pressed
	jal printString	# print tring 
	
	mv a0, s0
	jal printChar	# print char 
	
	li a0, '\n'
	jal printChar
	
	if:			# block for counter
		li t5, 4
		la s2, count
		lw s3, 0(s2)	# s3 is value of counter
		
		blt s3, t5, end_if	# check if counter has gone through 5 iterations
		
		la t6, main		# load main address to uret
		csrrw zero, 65, t6	# hacking uret to return to main 
		la t5, count		
		li t6, 0
		sw t6, 0(t5)
		uret
		
	end_if:
	
	addi s3, s3, 1		# increment counter
	la s2, count
	sw s3, 0(s2)
	
	mv a0, s0		
	
	lw ra, 60(sp)		# reload all the saved registers 
	lw a7, 56(sp)
	lw s0, 52(sp)
	lw s1, 48(sp)
	lw s2, 44(sp)
	lw s3, 40(sp)
	lw t0, 36(sp)
	lw t1, 32(sp)
	lw t2, 28(sp)
	lw t3, 24(sp)
	lw t4, 20(sp)
	lw t5, 16(sp)
	lw t6, 12(sp)
	addi sp, sp, 64
	uret			# return 

.data

msg: .string "\nInitializing Interrupts\n"
pressed: .string "\nKey Pressed is: "
RCR: .word 0xffff0000
DDR:	.word	0xffff000c
count: .word 0


