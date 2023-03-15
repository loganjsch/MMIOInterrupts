.text
.globl main

main: 
	jal isr
	li a0, '*'
	
body:
	mv s1, a0
	li s0, 5
	jal counter
	
	li a7, 1
	ecall
	
	bgt a0, s0, end_body
	mv a0, s1
	jal printChar
	b body
end_body:
	jal countReset
	b main
