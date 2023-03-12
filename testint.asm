.text
.globl main
main:
	li a0, '*'
	jal printChar
	b main
