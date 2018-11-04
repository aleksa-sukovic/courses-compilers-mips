.text

main:
    li $v0, 5
    syscall

    move $a0, $v0
    jal fact    # result in $v0

    move $a0, $v0
    li $v0 1
    syscall    # printing result

    li $v0, 10
    syscall    # ending program

fact:
    # Reserve stack space
    sub $sp, $sp, 8     # we save 2 registers, $a0 and $ra, register is 4 bytes
    sw $a0, 0($sp) # $a0 on stack top 
    sw $ra, 4($sp) # $ra 4 bytes below stack top

    ble $a0, 1, base_case
        add $a0, $a0, -1   # n - 1 in $a0
        jal fact           # calculate for n - 1

        lw $a0, 0($sp)     # in $a0 preserved value
        mulo $v0, $v0, $a0 # $v0 = fact(n-1) * n
        b end

    base_case:
        li $v0, 1

    end:
        lw $ra, 4($sp)  # return the preserved address
        add $sp, $sp, 8 # move the stack pointer
        jr $ra

.data
