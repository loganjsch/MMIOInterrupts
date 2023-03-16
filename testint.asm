.text
.globl main

main: 
	jal isr
	li a0, '*'
	
body:
	mv s1, a0
	#li s0, 5
	
	#la s2, count
	#lw s3, 0(s2)

	
	#beq s3, s0, end_body
	
	jal printChar
	b body
	
#end_body:
#	Ela s4, count
#	li s5, 0
#	sw s5, 0(s4)
#	b main
