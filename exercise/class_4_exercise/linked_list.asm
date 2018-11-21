.data

.text

main:
    xor $a0, $a0, $a0
    li $a1, 12
    jal add_end
    
    move $a0, $v0
    li $a1, 41
    jal add_end
    
    move $a0, $v0
    li $a1, 15
    jal add_end
    
    move $a0, $v0
    jal print_r

    li $v0, 10
    syscall

add_end:
    # $a0 = list head
    # $a1 = new node value
    # $v0 = list head
    move $t0, $a0 # saving list head
    
    # allocating space for new node
    li $a0, 8
    li $v0, 9
    syscall 
    sw $a1, 0($v0) # storing node value
    sw $0, 4($v0)  # storing 0 as address of next element
    
    move $t1, $v0  # new node in $t0
    move $t2, $t0  # current node address in $t0
    
    beqz $t2, add_end_list_empty # special case, list is empty
        add_end_loop:
            lw $t3, 4($t2)
            beqz $t3, add_end_loop_end
            move $t2, $t3
            j add_end_loop
            
        add_end_loop_end:
            # add new node to end
            sw $t1, 4($t2)
            move $v0, $t0
            j end
            
    add_end_list_empty:
        move $v0, $t1
        j end
       
    end:
    	jr $ra

add_start:
    # $a0 = list head
    # $a1 = new node value
    # $v0 = new list head after insertion
    move $t0, $a0 # saving list head

    li $a0, 8 # 8 bytes to allocate (4 for value, 4 for address of next node)
    li $v0, 9
    syscall # alocating memory for new node (address in $v0)

    sw $a1, 0($v0) # value in allocated space
    sw $t0, 4($v0) # address of next element

    jr $ra # address of new head is in $v0

print_r:
    # list head in $a0
    sub $sp, $sp, 8 # reserving stack space to save current head and return address
    sw $a0, 0($sp)  # saving head to stack
    sw $ra, 4($sp) # saving return address

    beqz $a0, base_case
        move $t0, $a0 # save list head in temporary register

        lw $a0, 0($t0)
        li $v0, 1
        syscall # printing element

        li $a0, 32 
		li $v0, 11 # system call for printing character
		syscall    # printing space

        lw $a0, 4($t0) # address of next node
        jal print_r    # print rest of the list

    base_case:
        lw $a0, 0($sp)  # restoring list head
        lw $ra, 4($sp)  # restoring return address
        add $sp, $sp, 8 # restoring stack pointer
        jr $ra

print:
    # list head in $a0
    move $s0, $a0 # saving list head
    move $t0, $a0 # helper node

    print_loop:
        beqz $t0, print_loop_end

        lw $a0, 0($t0)
        li $v0, 1
        syscall # printing next element

        li $a0, 32 
		li $v0, 11 # system call for printing character
		syscall    # printing space

        lw $t0, 4($t0) # advancing to next element
        j print_loop

    print_loop_end:
    	move $a0, $s0
        jr $ra

