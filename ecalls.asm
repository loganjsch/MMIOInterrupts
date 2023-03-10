.globl printInt, printString, printChar, readChar, readInt, exitProgram, readString

printInt:
		li a7, 1 		# service number to print int
		ecall			# get user input 
		ret
printString:
		li a7, 4		# sets service number to print string
		ecall
		ret
printChar:
		li a7, 11		# service number to print char
		ecall
		ret
readChar:
		li a7, 12 		# load user char y/n
		ecall
		ret
		
readString:
		li a1, 255
		li a7, 8
		ecall
		ret
			
readInt:
		li a7, 5 		# service number to read int to a0
		ecall			# get user input 
		ret
exitProgram:
		li a7, 10		# loads service number for exiting 
		ecall			# exits program
		ret
		
		
.data
svra: .word -1