.text

main:
    li $v0, 5
    syscall

    move $a0, $v0
    jal eaven_digits

    move $a0, $v0
    li $v0, 1
    syscall

    li $v0, 10
    syscall

eaven_digits:
    sub $sp, $sp, 32
    sw $a0, 0($sp)
    sw $ra, 4($sp)

    beqz $a0, base_case
        li $t0, 10
        div $a0, $t0 # HI -> ostatak pri dijeljenju, LO -> kolicnik

        mfhi $t1 # remainder in $t1
        mflo $t2 # kolicnik

        sw $t1, 8($sp) # remainder is preserved on steckk

        move $a0, $t2 # kolicnik as argument
        jal eaven_digits # result in $v0

        lw $t1, 8($sp)
        rem $t3, $t1, 2 # remainder from $t1 / 2
        beqz $t3, eaven
        j end

        eaven:
            add $v0, $v0, 1
            j end

    base_case:
        li $v0, 0

    end:
        lw $ra, 4($sp)
        add $sp, $sp, 32
        jr $ra


.data
