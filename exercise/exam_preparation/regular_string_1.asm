.text

main:
    la $a0, string_space
    li $a1, 1000
    li $v0, 8
    syscall

    li $v0, 4
    la $a0, string_space
    syscall

    jal regular_str

    move $a0, $v0
    li $v0, 1
    syscall

    li $v0, 10
    syscall

regular_str:
    sub $sp, $sp, 4
    sw $ra, 0($sp)

    la $a0, string_space
    li $a1, 97
    jal count_letter

    move $s0, $v0 # repetition count for a
    move $a0, $v1 # address of first non a character
    li $a1, 98
    jal count_letter

    move $s1, $v0 # repetition count for b
    move $a0, $v1 # address of first non b character
    li $a1, 99
    jal count_letter

    move $s2, $v0 # repetition count for c

    # $s0 -> a^3n
    # $s1 -> b^2n
    # $s2 -> c^3n

    bne $s0, $s2, not_regular
        div $t2, $s0, 3 # $t2 = n
        mulo $t2, $t2, 2 # $t2 = 2n
        bne $t2, $s1, not_regular
            li $v0, 1
            j end

    not_regular:
        li $v0, 0
        j end
    
    end:
        lw $ra, 0($sp)
        add $sp, $sp, 4
        jr $ra

count_letter:
    # $a0 -> string address
    # $a1 -> character
    # $v0 -> repetition count
    # $v1 -> address of next character
    move $t0, $a0 # current character address
    li $t1, 0     # repetition count
    count_loop:
        lb $t2, 0($t0) # current character val
        beqz $t2, count_loop_end     # end of string
        bne $t2, $a1, count_loop_end # character != provided character
            add $t1, $t1, 1 # repetition count
            add $t0, $t0, 1 # next character address
            j count_loop
    count_loop_end:
        move $v0, $t1
        move $v1, $t0
        jr $ra


.data
    string_space: .space 1000

