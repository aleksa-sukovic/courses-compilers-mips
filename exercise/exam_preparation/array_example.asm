.text

main:
    li $v0, 5
    syscall

    move $s0, $v0 # n in $s0
    move $a0, $s0
    jal load_array
    move $s1, $v0 # address of array

    move $a0, $s1 # address as first argument
    move $a1, $s0 # n as second argument
    jal print_array

    li $v0, 10
    syscall

print_array:    
    # $a0 -> array address
    # $a1 -> array length
    li $t0, 0 # counter
    move $t1, $a0 # current element
    print_array_loop:
        bge $t0, $a1, print_array_loop_end
            lw $a0, 0($t1)
            li $v0, 1
            syscall
            add $t1, $t1, 4
            add $t0, $t0, 1
            j print_array_loop

    print_array_loop_end:
        jr $ra

load_array:
    # $a0 -> array length
    move $s1, $a0 # saving array length

    mulo $a0, $a0, 4 
    li $v0, 9
    syscall # allocation n * 4 bytes for array  
    move $t0, $v0 # address of first element

    move $t1, $t0 # current element
    li $t2, 0 # counter
    load_array_loop:
        bge $t2, $s1, load_array_loop_end # counter >= length
            li $v0, 5
            syscall
            sw $v0, 0($t1)
            add $t1, $t1, 4
            add $t2, $t2, 1
            j load_array_loop

    load_array_loop_end:
        move $v0, $t0
        jr $ra

.data
