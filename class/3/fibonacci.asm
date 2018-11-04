.text

    main:
        li $v0, 5
        syscall  # n in $v0

    move $a0, $v0
    jal fibonacci # calculate result

    move $a0, $v0
    li $v0, 1
    syscall      # print result

    li $v0, 10
    syscall      # exit

fibonacci:
    sub $sp, $sp, 32
    sw $a0, 0($sp)
    sw $ra, 4($sp)

    ble $a0, 1, base_case
        sub $a0, $a0, 1 # n = n - 1
        jal fibonacci   # calculate fib(n-1)
        sw $v0, 8($sp)  # result fib(n-1) is preserved on stack

        lw $a0, 0($sp)  # preserved n value in $a0
        sub $a0, $a0, 2 # n = n - 2
        jal fibonacci   # calculate fib(n-2)

        lw $t0, 8($sp) # fib(n-1) 
        add $v0, $v0, $t0   # fib(n-1)+fib(n-2)
        b end

    end:
        lw $ra, 4($sp)   # restore $ra address
        add $sp, $sp, 32 # return stack pointer
        jr $ra
        
    base_case:
        li $v0, 1



.data
