.data
	input_message: .asciiz "Enter a number:"
	output_message: .asciiz "Sum of n number digits is: "
	
.text

main:
	# Printing message
	li $v0, 4
	la $a0, input_message
	syscall
	
	# Reading number
	li $v0, 5
	syscall
	move $s0, $v0 # saving n to $s0
	
	# Initializing counter
	li $s1, 0 # counter
	li $s2, 0 # sum
	j loop
	
loop:
	beq $s1, $s0, end_loop
	
	# Reading next number
	li $v0, 5
	syscall
	move $a0, $v0 # next number is in $a0
	
	jal digit_sum     # calculating number digit sum
	add $s2, $s2, $v0 # sum = sum + {digit_sum result}
	
	addi $s1, $s1, 1
	j loop
	
end_loop:
	# output message
	li $v0, 4
	la $a0, output_message
	syscall
	
	# sum output
	li $v0, 1
	move $a0, $s2
	syscall
	
	# end
	li $v0, 10
	syscall
	
digit_sum:
	# number is in $a0 
	li $s3 0      # sum
	j digit_loop

digit_loop:
	beq $a0, 0, digit_loop_end
	
	rem $s4, $a0, 10  # last digit in $s4
	add $s3, $s3, $s4 # sum = sum + last_digit
	div $a0, $a0, 10  # num = num / 10
	
	j digit_loop
	
digit_loop_end:
	move $v0, $s3
	jr $ra