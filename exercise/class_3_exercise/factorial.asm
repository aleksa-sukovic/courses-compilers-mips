.text

main:
	la $a0, inputmsg
	li $v0, 4
	syscall          # input message
	
	li $v0, 5 
	syscall          # number in $v0
	
	move $a0, $v0    # number as argument
	jal fact         # calculating factorial
	
	move $a0, $v0    # result in $a0
	li $v0, 1
	syscall          # printing result
	
	li $v0, 10
	syscall          # end of program

fact:
	sub $sp, $sp, 8            # reserving 8 bytes of stack space, 4 bytes per register
	sw $a0, 0($sp)             # saving argument
	sw $ra, 4($sp)		   # saving return address
	
	beqz $a0, base_case	   # recursion base case if argument is 0
		sub $a0, $a0, 1    # n = n - 1
		jal fact
	
		lw $a0, 0($sp)     # $a0 = saved n (saved argument)
		mulo $v0, $v0, $a0 # result = fact(n-1)*n
		b end
	
	base_case:
		li $v0, 1       # result is 1
		b end
	
	end:
		lw $ra, 4($sp)  # restoring return address
		add $sp, $sp, 8 # restoring stack pointer
		jr $ra

.data
	inputmsg: .asciiz "Enter a number whose factorial you want to calculate: "