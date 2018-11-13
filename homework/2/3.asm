.text

main:
    la $a0, string_space
    li $a1, 1000
    li $v0, 8
    syscall # loading string 

    jal string_length
    move $s0, $v0 # string length in $s0

    # FREQUENCY
    # la $a0, string_space
    # jal frequency
    # move $s1, $v0 # result in $s1

    # la $a0, frequency_output_msg
    # li $v0, 4
    # syscall # Frequency output message
    # move $a0, $s1
    # li $v0, 11
    # syscall    # printing character

    la $a0, string_space
    jal brojRotacija

    li $v0, 10
    syscall

brojRotacija:
    move $s0, $a0   # original string in $s0
    sub $sp, $sp, 4 
    sw $ra, 0($sp)   # saving return address to stack

    jal copyStr
    move $s1, $v0    # copied string in $s1

    move $a0, $s1
    jal rotate_str

    move $a0, $s1
    li $v0, 4
    syscall

    lw $ra, 0($sp)
    add $sp, $sp, 4

rotate_str:
    

copyStr:
    sub $sp, $sp, 4
    sw $ra, 0($sp)  # saving return address to stack
    
    # Calculating original string length
    jal  string_length
    move $t1, $v0     # length of original string in $t1
    add  $t1, $t1, 1   # 1 more byte for string terminator
    
    # Setting up local variables
    move $t0, $a0   # addres of original string in $t0
    li   $t3, 0       # loop counter

    # Alocating space for copy array
    move $a0, $t1
    li $v0, 9
    syscall           # allocating space for new string
    move $t2, $v0     # address of copy string in $t2

    # Copying elements
    move $t5, $t2     # address of current character in copy string
    copy_loop:
        beq $t3, $t1, copy_loop_end
            lb $t4, 0($t0)  # loading next character
            sb $t4, 0($t5)  # storing next character into copy string
            add $t0, $t0, 1 # advancing to next character in original string
            add $t5, $t5, 1 # advancing to next character in copy string
            add $t3, $t3, 1 # advancing counter
            j copy_loop
    copy_loop_end:
        lw $ra, 0($sp)
        add $sp, $sp, 4
        move $v0, $t2
        jr $ra

frequency:
    move $s0, $a0       # string in $s0
    la $s1, count_space # counting array (n-th element is repetition count for n-th alphabet letter)
    
    # Initializing count array to all 0
    move $t0, $s1 # current address
    li $t1, 0     # counter
    initialization_loop:
        bge $t1, 26, count_frequencies
            li $t2, 0
            sw $t2, 0($t0)  # storing 0 as current element
            add $t0, $t0, 4 # advancing to next element
            add $t1, $t1, 1 # counter += 1
        j initialization_loop
    
    count_frequencies:
        move $t0, $s0                           # current character address in $t0
        count_frequency_loop:
            lb $t1, 0($t0)                      # load ascii code for current character
            beqz $t1, count_frequency_loop_end # end of string
                sub $t1, $t1, 97               # index in alphabet of current character
                mul $t1, $t1, 4                # index in count array of current character
                add $t1, $t1, $s1              # address in count array of current character

                lw $t2, 0($t1)                  # number of repetition of current character in $t2
                add $t2, $t2, 1                 # incrementing number of repetitions
                sw $t2, 0($t1)                  # storing number of repetitions

                add $t0, $t0, 1                  # advancing counter to next character
                j count_frequency_loop
        
        count_frequency_loop_end:
            la $t0, count_space # address of current element
            li $t1, 0           # counter
            li $v0, 0           # index of maximum character 
            lw $t2, 0($t0)      # number of repetitions for current maximum
            max_loop:
                beq $t1, 26, max_loop_end
                    lw $t3, 0($t0) # number of repetitions for current character
                    
                    bgt $t3, $t2, new_max # current number of repetitions > max number of repetitions
                    b advance_loop

                new_max:
                    move $v0, $t1  # index of new maximum in $v0
                    move $t2, $t3 # number of repetitions of new maximum in $t2

                advance_loop:
                    add $t0, $t0, 4 # address of next element
                    add $t1, $t1, 1 # counter += 1
                    j max_loop
            max_loop_end:
                add $v0, $v0, 97 # ascii value of character
                jr $ra

string_length:
    # string address in $a0
    move $t0, $a0
    xor $v0, $v0, $v0

    length_loop:
        lb $t1, 0($t0)
        beqz $t1, length_loop_end
            add $v0, $v0, 1
            add $t0, $t0, 1
            j length_loop
    length_loop_end:
    	sub $v0, $v0, 1
        jr $ra

.data
    count_space: .space 104
    string_space: .space 1000
    frequency_output_msg: .asciiz "Karakter sa najvecim brojem ponavljanja je: "
