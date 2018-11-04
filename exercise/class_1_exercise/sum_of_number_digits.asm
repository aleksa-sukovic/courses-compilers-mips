# Load a number and print a sum of its digits

.data
	message: .asciiz "Enter number n: "
	result:  .asciiz "Sum of its digit is: "
	
.text

main:
	# print message
	li $v0, 4
	la $a0, message
	syscall
	
	# load number
	li $v0, 5
	syscall
	move $t0, $v0 # n is in $t0
	
	# prepare arguments for sub-programm call
	move $a0, $t0
	jal digit_sum
	
	# result of digit_sum is in $v1
	
	# print message
	li $v0, 4
	la $a0, result
	syscall
	
	# print result
	li $v0, 1
	move $a0, $v1
	syscall
	
	# end
	li $v0, 10
	syscall

digit_sum:
	# initialize variables
	move $t1, $a0 # n 
	li $t2, 0     # sum
	j sum_loop
	
sum_loop:
	beqz $t1, sum_loop_end # check if n is 0
	rem $t3, $t1, 10       # last digit in $t3
	add $t2, $t2, $t3      # sum += digit
	div $t1, $t1, 10       # n = n / 10
	b sum_loop
	
sum_loop_end:
	move $v1, $t2
	jr $ra
