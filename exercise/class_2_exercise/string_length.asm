# Ucitati string i odstampati njegovu duzinu

.data
	string_space: .space 1000 # reserves 1000 successive bytes

.text

main:
	la $a0, string_space # address of space 
	li $a1, 1000	     # length of buffer
	li $v0, 8	     
	syscall	             # reading string
	
	la $a0, string_space # address of string space as first argument
	jal string_length    # calculating string length
	
	move $a0, $v0 # string length in $a0
	li $v0, 1
	syscall       # printing string lenght
	
	li $v0, 10
	syscall       # exiting
	
string_length:
	li $v0, 0     # length in $v0
	move $v1, $a0 # address of first character in $v1
	
	length_loop:
		lb $t1, 0($v1) 			# in $t1 byte at address $v0
		beq $t1, 10, length_loop_end    # stop counting when \n (ascii 10) is found
		add $v1, $v1, 1			# increment $v0 address by 1 byte
		add $v0, $v0, 1			# increment length by 1
		b length_loop
		
	length_loop_end:
		# string length is in $v0, however we can avoid using counter located in $v0 by using the following
		# calculating length as difference between first and last string addres ( counter $v0 is not neccesary )
		# la $v0, string_space
		# sub $v0, $v1, $v0
	
		jr $ra # result is in $v0
		