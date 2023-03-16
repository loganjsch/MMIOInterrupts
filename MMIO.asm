.globl printInt, printString, printChar, readChar, readInt, exitProgram, readString

printInt:
		addi a0, a0, 48   # Convert the integer value to its corresponding ASCII code
		lw	t0, DDR        # Load the DDR memory-mapped register into t0
		sb	a0, (t0)       # Store the ASCII code in the DDR register
		li a7, 11         # Service number to print character
		ecall             # Print the character
		ret               # Return from the function
printString:

		
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw t1, 4(sp)
	sw t4, 0(sp)
	
	mv s0, a0
	li t4, '\0'
	
	here_2:
		lb t1, 0(s0)
		mv a0, t1
		beq t4, a0, endhere_2
		jal printChar
		addi s0, s0, 1
	
		b here_2

	endhere_2:
		
		lw ra, 12(sp)
		lw s0, 8(sp)
		lw t1, 4(sp)
		lw t4, 0(sp)
		addi sp, sp, 16
		ret
		
		

	
printChar:

		addi sp, sp, -16
		sw ra, 12(sp)
		sw t0, 8(sp)
		sw t1, 4(sp)
		
		#lw t1, DSR
		#lw t0, 0(t1)
		#andi t0, t0, 1
		#beq t0, zero, printChar
		
		lw	t1, DDR
		sw	a0, 0(t1)
		
		
		lw ra, 12(sp)
		lw t0, 8(sp)
		lw t1, 4(sp)
		addi sp, sp, 16
		ret
		
readChar:

		addi sp, sp, -16
		sw ra, 12(sp)
		sw t0, 8(sp)
		sw t1, 4(sp)
		
		lw t0, KBSR
		lw	a0, (t0)
		#lw t1, 0(t0)
		#andi t1, t1, 1
		beq zero, a0, readChar
		
		lw t0, KBDR
		
		lw a0, (t0)
		
		lw ra, 12(sp)
		lw t0, 8(sp)
		lw t1, 4(sp)
		addi sp, sp, 16
		
		ret
		
readString:

	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw a7, 20(sp)
	sw t1, 16(sp)
	sw t4, 12(sp)
	mv s0, a0
	li t3, 10
	li t4, '\0'
	
	here:
		
		jal readChar
		beq t3, a0, endhere
		mv t1, a0
		sb t1, 0(s0)
		addi s0, s0, 1
	
		b here

	endhere:
		mv t1, t4
		sb t1, 0(s0)
		
		lw ra, 28(sp)
		lw s0, 24(sp)
		lw a7, 20(sp)
		lw t1, 16(sp)
		lw t4, 12(sp)
		addi sp, sp, 32
		ret

			
readInt:
		lw	t0, KBSR   # Load the KBSR to t0
		lw	a0, (t0)   # Load the value of KBSR into a0
		beq	zero, a0, readInt   # If KBSR is zero, continue to loop

		lw	t0, KBDR   # Load the KBDR memory-mapped register into t0
		lw	a0, (t0)   # Load the value of KBDR into a0

		# Check if the input is a valid integer character
		addi t1, a0, -48   # Subtract the ASCII code for '0'
		blt t1, zero, readInt   # If a0 is less than 48, continue to loop
		li t2, 9
		bgt t1, t2, readInt   # If a0 is greater than 57 ('9' in ASCII), continue to loop

		# Convert the ASCII character code to an integer value
		addi a0, a0, -48   # Subtract the ASCII code for '0'

		ret   # Return from the function with the integer value in a0
		#li a7, 5 		# service number to read int to a0
		#ecall			# get user input 
		#ret
exitProgram:

		li a7, 10		# loads service number for exiting 
		ecall			# exits program
		ret
		
		
.data

KBSR:	.word	0xffff0000
KBDR:	.word	0xffff0004
DSR:	.word	0xffff0008
DDR:	.word	0xffff000c
