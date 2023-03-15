.globl isr, counter, countReset

isr:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw t0, 8(sp)
	

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
	
	lw ra, 12(sp)
	addi sp, sp, 16
	ret

handler:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw a7, 24(sp)
	sw s0, 20(sp)
	sw s1, 16(sp)
	sw s2, 12(sp)
	sw s3, 8(sp)
	
	
	
	csrrs s1, uepc, zero
	addi s1, s1, 4
	csrrw zero, uepc, s1
	
	jal readChar
	mv s0, a0
	
	la a0, pressed
	jal printString
	mv a0, s0
	jal printChar
	li a0, '\n'
	jal printChar
	
	la s2, count
	lw s3, 0(s2)
	addi s3, s3, 1
	la s2, count
	sw s3, 0(s2)
	
	mv a0, s0
	
	
	lw ra, 28(sp)
	lw a7, 24(sp)
	lw s0, 20(sp)
	lw s1, 16(sp)
	lw s2, 12(sp)
	lw s3, 8(sp)
	addi sp, sp, 32
	uret

counter:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw t1, 8(sp)
	sw t2, 4(sp)
	
	la t1, count
	lw t2, 0(t1)
	
	addi t2, t2, 1
	mv a0, t2
	
	lw ra, 12(sp)
	lw t1, 8(sp)
	lw t2, 4(sp)
	addi sp, sp, 16
	ret
	
countReset:

	addi sp, sp, -16
	sw ra, 12(sp)
	sw t1, 8(sp)
	sw t2, 4(sp)
	
	la t1, count
	li t2, 0
	sw t2, 0(t1)
	
	lw ra, 12(sp)
	lw t1, 8(sp)
	lw t2, 4(sp)
	addi sp, sp, 16
	ret
	




.data

msg: .string "\nInitializing Interrupts\n"
pressed: .string "\nkey pressed is: "
RCR: .word 0xffff0000
DDR:	.word	0xffff000c
count: .word 0


