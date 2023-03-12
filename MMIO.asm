.globl printInt, printString, printChar, readChar, readInt, exitProgram, readString

printInt:
		addi a0, a0, 48   # Convert the integer value to its corresponding ASCII code
		lw	t0, DDR        # Load the DDR memory-mapped register into t0
		sb	a0, (t0)       # Store the ASCII code in the DDR register
		li a7, 11         # Service number to print character
		ecall             # Print the character
		ret               # Return from the function
printString:
		
		mv	t0, a0 # Save the starting address of the string to t0

	print_loop:
		
		lb a1, (t0) # Load the current character into a1
		beqz a1, return_print # If the current character is the null terminator, return
		lw t1, DDR  # Otherwise, print the character to the display and increment the string pointer,Load address of the display
		sb a1, (t1)
		li a7, 11		# service number to print char
		ecall
		
		addi t0, t0, 1

		# Repeat the loop for the next character
		j print_loop # Repeat the loop for the next character

	return_print:
		ret
		
	
printChar:
		lw	t0, DDR
		sb	a0, (t0)
		li a7, 11		# service number to print char
		ecall
		ret
		
readChar:
		lw	t0, KBSR
		lw	a0, (t0)
		beq	zero, a0, readChar
		
		lw	t0, KBDR
		lw	a0, (t0)
		
		
		ret
		
readString:

	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
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
		lw ra, 12(sp)
		lw s0, 8(sp)
		addi sp, sp, 16
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
