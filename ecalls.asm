.globl printint, printstring, printchar, readchar, readint, exit0, readstring

printint:
		li a7, 1 		# service number to print int
		ecall			# get user input 
		ret
printstring:
		li a7, 4		# sets service number to print string
		ecall
		ret
printchar:
		li a7, 11		# service number to print char
		ecall
		ret
readchar:
		li a7, 12 		# load user char y/n
		ecall
		ret
		
readstring:

	sw ra, svra, t6
	mv t0, s3
	li t3, 10
	li t4, '\0'
	
	here:
		
		jal readchar
		beq t3, a0, endhere
		mv t1, a0
		sb t1, 0(t0)
		addi t0, t0, 1
	
		b here

	endhere:
		mv t1, t4
		sb t1, 0(t0)
		lw ra, svra
		ret
			
readint:
		li a7, 5 		# service number to read int to a0
		ecall			# get user input 
		ret
exit0:
		li a7, 10		# loads service number for exiting 
		ecall			# exits program
		ret
		
		
.data
svra: .word -1
