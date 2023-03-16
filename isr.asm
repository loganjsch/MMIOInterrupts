.globl isr, count

isr:
	addi sp, sp, -32
	sw ra, 28(sp)
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
	
	lw ra, 28(sp)
	lw t0, 24(sp)
	lw t1, 20(sp)
	lw t2, 16(sp)
	lw t3, 12(sp)
	lw t4, 8(sp)
	lw t5, 4(sp)
	
	addi sp, sp, 32
	ret

handler:
	addi sp, sp, -64
	sw ra, 60(sp)
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
	
	
	
	#csrrs s1, uepc, zero
	#addi s1, s1, 4
	#csrrw zero, uepc, s1
	
	jal readChar
	mv s0, a0
	
	la a0, pressed
	jal printString
	
	mv a0, s0
	jal printChar
	
	li a0, '\n'
	jal printChar
	
	if:
		li t5, 4
		la s2, count
		lw s3, 0(s2)
		#addi s3, s3, 1
		#la s2, count
		#sw s3, 0(s2)
		
		blt s3, t5, end_if
		
		la t6, main
		csrrw zero, 65, t6
		la t5, count
		li t6, 0
		sw t6, 0(t5)
		uret
		
	end_if:
	
	addi s3, s3, 1
	la s2, count
	sw s3, 0(s2)
	
	mv a0, s0
	
	
	lw ra, 60(sp)
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
	uret

	




.data

msg: .string "\nIn\n"
pressed: .string "\nkey: "
RCR: .word 0xffff0000
DDR:	.word	0xffff000c
count: .word 0

# "\nInitializing Interrupts\n"
# "\nkey pressed is: "

