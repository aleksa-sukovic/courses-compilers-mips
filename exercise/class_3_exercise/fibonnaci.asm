.text

main:
	la $a0, inputmsg
	li $v0 4
	syscall # print input message
	
	li $v0, 5
	syscall
	move $s0, $v0 # $s0 contains n
	
	# Calculating n-th Fibonacci number
	move $a0, $s0 # n as argument in $a0
	jal fib
	move $t0, $v0 # result in $t0
	
	li $v0, 1
	move $a0, $s0
	syscall
	la $a0, outputmsg
	li $v0, 4
	syscall # output message
	
	move $a0, $t0
	li $v0, 1
	syscall # printing result
	
	li $v0, 10
	syscall # exiting program

fib:
	sub $sp, $sp, 32 # reserving space for 4 registers
	sw $a0, 0($sp)   # n on stack
	sw $ra, 4($sp)   # resturn address on stack
	
	ble $a0, 2, base_case
		lw $a0, 0($sp)    # n in $a0
		sub $a0, $a0, 1   # n = n - 1
		jal fib
		sw $v0, 8($sp)    # saving fib(n-1) on stack
		
		lw $a0, 0($sp)    # n in $a0
		sub $a0, $a0, 2   # n = n - 2
		jal fib           # fib(n-2) in $v0
		
		lw $t0, 8($sp)    # fib(n-1) in $t0
		add $v0, $v0, $t0 # $t0 = fib(n-1) + fib(n-2)
		b end
	
	base_case:
		li $v0, 1
		b end
	
	end:
		lw $ra, 4($sp)   # restoring return address
		add $sp, $sp, 32 # restoring stack space
		jr $ra

.data
	inputmsg: .asciiz "Enter a number: "
	outputmsg: .asciiz "th Fibonacci number is: "