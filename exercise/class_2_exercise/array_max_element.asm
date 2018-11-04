# Load integer number N representing the length of array. Then load the individual elements of array.
# Find the biggest element of that array and print it.

.data
	array: .space 120 # reserves 120 continuous bytes, this will allow array which has at most 30 elements (each element is 4 bytes)
	array_length_message: .asciiz "Enter the array length:"
	array_length_error: .asciiz "Array length must be in rage [1,30]"
	output_message: .asciiz "\nMaximum of this array is:"
	
.text

main:
	# loading array length
	la $a0, array_length_message
	li $v0, 4
	syscall                          # printing array length input message
	
	li $v0 5
	syscall
	move $s0, $v0                    # array length is in $s0
	
	sgt $t8, $v0, 30
	beq $t8, 1, invalid_array_length # if array length is out of bounds
	
	move $a0, $s0
	jal fill_array                   # filling array with input values, array length in $a0
	
	move $a0, $s0
	jal print_array			 # printing array for testing
	
	move $a0, $s0
	jal max_array			# finding out maximum number of array
	move $t1, $v0			# result in $t1
	
	la $a0, output_message          # printing output message
	li $v0, 4
	syscall
	
	move $a0, $t1
	li $v0, 1
	syscall 			# printing result
	
	li $v0, 10
	syscall                         # exit
	
	invalid_array_length:
		la $a0, array_length_error
		li $v0, 4
		syscall
		
		li $v0, 10
		syscall

fill_array:
	li $t0, 0 			     # counter in $t0
	la $t1, array			     # in $t1 address of array space
	
	fill_loop:
		beq $t0, $a0, end_fill_loop  # branch if $t0 == $a0 (array length)
		
		li $v0, 5
		syscall
		sw $v0, 0($t1)	             # new element in $t1 address
		
		add $t1, $t1, 4		     # incrementing $t1 address 4 bytes (each element is 4 bytes)
		add $t0, $t0, 1		     # counter += 1
		b fill_loop
	
	end_fill_loop:
		jr $ra
		
print_array:
	la $t1, array                        # first element of array
	li $t0, 0                            # counter
	move $t3, $a0			     # array length in $t3
	
	print_loop:
		beq $t0, $t3, end_print_loop # if counter == array length branch to end
		
		li $v0, 1
		lw $a0, 0($t1)		     # loading element from address $t1 into $a0
		syscall                      # printing next element
		
		
		li $v0, 11		     # system call to print character
		li $a0, 32		     # ascii code for ' '
		syscall			     # printing space
		
		add $t1, $t1, 4              # incrementing $t1 4 bytes
		add $t0, $t0, 1  	     # incrementing counter by 1
		b print_loop
	
	end_print_loop:
		jr $ra

max_array:
	move $t0, $a0 		# array length in $t0
	la $t1, array		# current element (address of first element in $t1)
	lw $v0, 0($t1)		# maximum (first element is declared as maximum)
	li $t2, 0		# counter
	
	max_loop:
		beq $t2, $t0, end_max_loop # counter has reached the end of array
		lw $t3, 0($t1)             # current element in $t3
		
		sgt $t8, $t3, $v0          # current element is > than maximum
		beq $t8, 1, new_max        # we found new maximum
		b finish_iteration	   # increment counters
		
		new_max:
			move $v0, $t3     # maximum = current element
		
		finish_iteration:
			add $t1, $t1, 4   # address of next element
			add $t2, $t2, 1   # counter += 1
			b max_loop
	
	end_max_loop:
		jr $ra