.data
	xinputmsg: .asciiz "Enter X:"
	ninputmsg: .asciiz "Enter N:"
	ainputmsg: .asciiz "Enter A:"

.text

main:
	# Reading N
	la $a0, ninputmsg
	li $v0, 4
	syscall # N input message
	li $v0, 5
	syscall
	move $t0, $v0 # N in $a0

	# Reading A
	la $a0, ainputmsg
	li $v0, 4
	syscall # A input message
	li $v0, 5
	syscall
	move $t1, $v0 # A in $a1

	# Reading X
	la $a0, xinputmsg
	li $v0, 4
	syscall # X input message
	li $v0, 5
	syscall
	move $t2, $v0 # X in $a2

	# Setting up parameters
	move $a0, $t0
	move $a1, $t1
	move $a2, $t2
	jal poly # calculating

	move $a0, $v0 # result in $a0
	li $v0, 1			
	syscall # printing result

	li $v0, 10
	syscall

poly:
	# n in $a0
	# a in $a1
	# x in $a2
	
	sub $sp, $sp, 4
	sw $ra, 0($sp) # saving return address to stack
	
	beq $a0, 0, base_case
		sub $a0, $a0, 1    # n = n - 1
		jal poly
	
		add $a1, $a1, 2    # sum = 3a + 2
		mulo $a3, $a3, $a2 # x^n = x^n * x
		
		move $t0, $a1      # $t0 = sum
		mulo $t0, $t0, $a3 # $t0 = sum * x^n
		
		add $v0, $v0, $t0
		b end
	
	base_case:
		mulo $a1, $a1, 3 # a = 3a
		move $v0, $a1    # sum = 3a
		li $a3, 1        # x^n = 1
	
	end:
		lw $ra, 0($sp)  # restoring return address
		add $sp, $sp, 4 # restoring stack pointer
		jr $ra
