.data
	array: .space 120 # max of 30 elements in array (4 bytes per element)
	ninputmsg: .asciiz "Unesite broj n: "
	minoutputmsg: .asciiz "Minimum unijetog niza je: "
	findoutputmsg: .asciiz "Indeks poslednjeg pojavljivanja broja 10 je: "
.text

main:
	# Reading N
	la $a0, ninputmsg
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s0, $v0 # n in $s0
	
	# Load array
	la $a0, array # address in $a0
	move $a1, $s0 # length in $a1
	jal loadArray 
	
	# Print array
	la $a0, array
	move $a1, $s0
	jal printArray # printing array
	
	# Find minimum
	la $a0, array
	move $a1, $s0
	jal findMin 
	move $s1, $v0 # minimum in $s1
	
	la $a0, minoutputmsg
	li $v0, 4
	syscall # printing output message for 'findMin' function
	move $a0, $s1
	li $v0, 1
	syscall       # printing minimum
	li $a0, 10
	li $v0, 11
	syscall # printing new line
	
 	# Find element
 	la $a0, array
 	move $a1, $s0
 	li $a2, 10
 	jal findElem
 	move $s2, $v0 # position in $s2
 	
 	la $a0, findoutputmsg
 	li $v0, 4
 	syscall
 	move $a0, $s2
 	li $v0, 1
 	syscall # printing position
 	
	
	# End program
	li $v0, 10
	syscall

findElem:
	move $t0, $a0 # address of first element in $t0
	move $t1, $a1 # length of array in $t1
	move $t2, $a2 # x in $t2
	
	sub $sp, $sp, 8 # reserving space for one register on stack
	sw $ra, 0($sp)  # saving return address on stack
	sw $a1, 4($sp)  # saving array length on stack
	
	beq $t1, 0, element_not_found
		
		move $t3, $t1     # current length of array
		sub $t3, $t3, 1   # length = length  - 1
		mulo $t3, $t3, 4  # calculating element offset
		add $t0, $t0, $t3 # $t0 = address of next element
	
		lw $t4, 0($t0)              # next element in $t4
		beq $t4, $a2, element_found # found the element
		
		sub $a1, $a1, 1   # decrementing array length
		jal findElem
		b end
		
	element_found:
		lw $v0, 4($sp)
		sub $v0, $v0, 1
		b end
		
	element_not_found:
		li $v0, -1
		b end
		
	end:
		lw $ra, 0($sp)
		add $sp, $sp, 8
		jr $ra


findMin:
	move $t0, $a0 # address of first element in $t0
	move $t1, $a1 # length of array in $t1
	li $t2, 1     # counter in $t2
	lw $t3, 0($t0)# minimum is first element
	
	find_min_loop:
		beq $t2, $t1, end_find_min_loop
		
		lw $t4, 0($t0) # next element in $t4
		blt $t4, $t3, new_min # current element is < current minimum
		b advance_loop
		
		new_min:
			move $t3, $t4
		
		advance_loop:
			add $t0, $t0, 4 # advancing to next element
			add $t2, $t2, 1 # counter += 1
			b find_min_loop
		
	end_find_min_loop:
		move $v0, $t3
		jr $ra
			
printArray:
	move $t0, $a0 # address of first element in $t0
	move $t1, $a1 # length of array in $t1
	li $t2, 0      # counter
	
	print_loop:
		beq $t2, $t1, end_print_loop
		
		lw $a0, 0($t0)
		li $v0, 1
		syscall # printing next element
		
		li $a0, 32 
		li $v0, 11 # system call for printing character
		syscall    # printing space
		
		add $t0, $t0, 4 # advancing to next element
		add $t2, $t2, 1 # counter += 1
		b print_loop
		
	end_print_loop:
		li $a0, 10
		li $v0, 11
		syscall # printing new line
		
		jr $ra
	
loadArray:
	move $t0, $a0 # address of first element in $t0
	move $t1, $a1 # length of array in $t1
	li $t2, 0     # counter = 0
	
	load_loop:
		beq $t2, $t1, end_load_loop
	
		li $v0, 5
		syscall
		sw $v0, 0($t0)  # saving array element
		
		add $t0, $t0, 4 # advancing pointer
		add $t2, $t2, 1 # counter += 1
		b load_loop
	
	end_load_loop:
		jr $ra