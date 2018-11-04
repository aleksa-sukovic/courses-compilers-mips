# Print sum of first n numbers. Load n from standard input

.data
	question: .asciiz "Enter number n:"
	result: .asciiz "Result is: "
	
.text

main:
	# printing message
	li $v0, 4
	la $a0, question
	syscall
	
	# reading n
	li $v0, 5
	syscall
	move $t0, $v0 # n is placed in $t0
	
	# initializing variables
	li $t1, 0 # sum
	li $t2, 0 # counter
	j loop

loop:
	bgt $t2, $t0, end_loop # check if counter is bigger than n
	add $t1, $t1, $t2      # sum = sum + counter
	addi $t2, $t2, 1       # counter += 1
	b loop
	
end_loop:
	# result message
	li $v0, 4
	la $a0, result
	syscall
	
	# print sum
	li $v0, 1
	move $a0, $t1
	syscall
	
	# end
	li $v0, 10
	syscall
	