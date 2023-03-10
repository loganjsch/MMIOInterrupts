.globl printInt, printString, printChar, readChar, readInt, exitProgram, readString

printInt:
		addi a0, a0, 48   # Convert the integer value to its corresponding ASCII code
		lw	t0, DDR        # Load the DDR memory-mapped register into t0
		sb	a0, (t0)       # Store the ASCII code in the DDR register
		li a7, 11         # Service number to print character
		ecall             # Print the character
		ret               # Return from the function
printString:
		# Save the starting address of the string to t0
		mv	t0, a0

	print_loop:
		# Load the current character into a1
		lb	a1, (t0)

		# If the current character is the null terminator, return
		beqz a1, return_print

		# Otherwise, print the character to the display and increment the string pointer
		lw	t1, DDR  # Load address of the display
		sb	a1, (t1)
		li a7, 11		# service number to print char
		ecall
		
		addi t0, t0, 1

		# Repeat the loop for the next character
		j print_loop

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
		
		# li a7, 12 		# load user char y/n
		# ecall
		ret
		
readString:
		# Load address of the input buffer into a0
		mv a0, t0

		# Set buffer size to 80
		li t1, 80
		li t4, 10

	read_loop:
		# Check if buffer size has been exceeded
		beqz t1, return_read

		# Read a character from the keyboard
		lw t2, KBSR
		lw t3, (t2)
		beqz t3, read_loop
		lw t2, KBDR
		lb a1, (t2)

		# Check for end of string (newline or null terminator)
		beqz a1, return_read
		beq a1, t4, return_read

		# Otherwise, store the character in the buffer and increment the pointer
		sb a1, (a0)
		addi a0, a0, 1
		addi t1, t1, -1

		# Repeat the loop for the next character
		j read_loop

	return_read:
		# Null-terminate the string and return its starting address
		sb zero, (a0)
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
svra:   .word -1
KBSR:	.word	0xffff0000
KBDR:	.word	0xffff0004
DSR:	.word	0xffff0008
DDR:	.word	0xffff000c