.data

.text

main:
    add $15, $0, $0 # i = 0
    add $16, $0, $0 # br = 0

    loop:
        slt $8, $15, $5 # $18 = 1 if $15 < $5 || $18 = 0
        beq $8, $0, loop_end
        muli $8, $15, 4 # temp = 4 * i -> current element offset
        add $8, $8, $4  # address of current element
        lw $9, 0($8) # current element in $9

        slt $8, $9, 10 # a[i] < 10
        bne $8, $0, next

    loop_end:
