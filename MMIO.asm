.globl printInt, printString, printChar, readChar, readInt, exitProgram, readString

printInt:
		addi a0, a0, 48   # Convert the integer value to its corresponding ASCII code
		lw	t0, DDR        # Load the DDR memory-mapped register into t0
		sb	a0, (t0)       # Store the ASCII code in the DDR register
		li a7, 11         # Service number to print character
		ecall             # Print the character
		ret               # Return from the function
printString:

		
	addi sp, sp, -16 # save ra to stack
	sw ra, 12(sp)
	
	mv t0, a0 # save adress to t0
	li t4, '\0'
	
	here_2:
		lb t1, 0(t0) # load one byte away from the adress
		mv a0, t1
		beq t4, a0, endhere_2 # if char is equal to '\0' then branch
		jal printChar
		addi t0, t0, 1 # increment adress
	
		b here_2

	endhere_2:
		
		lw ra, 12(sp) # restore ra
		addi sp, sp, 16 # pop stack
		ret
		
	
printChar:

		addi sp, sp, -16 # save ra to stack
		sw ra, 12(sp)
		
		lw	t1, DDR # get DDR value
		sw	a0, 0(t1) # write char to display
		
		
		lw ra, 12(sp) # restore ra 

		addi sp, sp, 16 # pop stack
		ret
		
readChar:

		addi sp, sp, -16 # save ra to stack
		sw ra, 12(sp)

		
		lw t0, KBSR # get KBSR address
		lw	a0, (t0) # get value at KSBR

		beq zero, a0, readChar # see if zero or not
		
		lw t0, KBDR # get KBDR address
		
		lw a0, (t0) # get the char
		
		lw ra, 12(sp) # restore ra

		addi sp, sp, 16 # pop stack
		
		ret
		
readString:

	addi sp, sp, -16 # save ra on the stack
	sw ra, 12(sp)
	
	#mv s0, a0
	li t3, 10 
	li t4, '\0'
	
	here:
		
		jal readChar
		beq t3, a0, endhere # branch if there is an enter key
		mv t1, a0 
		sb t1, 0(t0) # store byte zero away from t0
		addi t0, t0, 1 #increment address
		b here

	endhere:
		mv t1, t4 # move null to t1
		sb t1, 0(t0) # put in the null char 
		lw ra, 12(sp) # restore ra
		addi sp, sp, 16 # pop stack
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

exitProgram:

		li a7, 10		# loads service number for exiting 
		ecall			# exits program
		ret
		
		
.data

KBSR:	.word	0xffff0000
KBDR:	.word	0xffff0004
DSR:	.word	0xffff0008
DDR:	.word	0xffff000c
