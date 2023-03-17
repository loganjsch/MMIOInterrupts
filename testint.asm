# Nicholas Zarate
# Logan Schwarz
.text
.globl main

main: 
	jal isr		
	li a0, '*'
	
body:		
	mv s1, a0

	jal printChar
	b body
