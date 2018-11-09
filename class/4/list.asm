.text

main:
    li $a0, 0 # address of list head when list is empty

    # Inserting elements into list
    li $a1, 10
    jal insert_begin  
    li $a1, 5
    jal insert_begin
    li $a1, 53
    jal insert_begin 
    li $a1, 15
    jal insert_end

    # Printing list
    jal print_list

    # Exiting
    li $v0, 10
    syscall

insert_end:
    move $s0, $a0 # preserving list head

    li $a0, 8
    li $v0, 9
    syscall # alocating memory for new node

    sw $a1, 0($v0) # storing value for new node
    sw $0, 4($v0) # storing 0 as address of next element for new node

    move $t0, $s0
    beqz $s0, empty_list
        insert_end_loop:
            beqz $t0, add_element
                move $t1, $t0
                lw $t0, 4($t0)
                j insert_end_loop

            add_element:
                sw $v0, 4($t1)
                move $a0, $s0
                j end_insert_end
    empty_list:
        move $a0, $v0
    
    end_insert_end:
        jr $ra

insert_begin:
    # $a0 is address of first node
    # $a1 is value we are inserting
    move $s0, $a0

    li $a0, 8 # number of bytes to dynamically allocate
    li $v0, 9 # system call for dynamic memory allocation
    syscall   # in $v0 address of allocated memory

    sw $a1, 0($v0) # value at addres found in $v0 in first 4 bytes
    sw $s0, 4($v0) # address of old head in next 4 bytes
    
    move $a0, $v0 # new list head in $a0

    jr $ra

print_list:
    move $t0, $a0 # address of list head in $a0
    move $s0, $a0 # saving list head (we are using register $a0 for system calls)

    print_loop:
        beqz $t0, print_loop_end
        
        lw $a0, 0($t0)
        li $v0, 1
        syscall # printing value from current node

        la $a0, whitespace
        li $v0, 4
        syscall # printing whitespace (' ')

        lw $t0, 4($t0) # advancing to next node
        j print_loop

    print_loop_end:
        move $a0, $s0 # returning list head into $a0
        jr $ra
.data
    whitespace: .asciiz " "
