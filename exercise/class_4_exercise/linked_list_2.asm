.data

.text

main:
    xor $a0, $a0, $a0
    li $a1, 12
    jal add_start
    
    move $a0, $v0
    li $a1, 41
    jal add_start
    
    move $a0, $v0
    li $a1, 15
    jal add_start
    
    move $a0, $v0
    li $a1, 15
    jal delete_r
    
    move $a0, $v0
    jal print_r

    li $v0, 10
    syscall

delete_r:
    # $a0 = list head
    # $a1 = node value to delete
    # $v0 = new list head
    sub $sp, $sp, 8
    sw $ra, 0($sp)  # saving return address to stack
    sw $a0, 4($sp)  # saving list head to stack
    beqz $a0, delete_r_base_case
        lw $t0, 0($a0)
        beq $t0, $a1, delete_r_element_found
            lw $a0, 4($a0)
            jal delete_r
            # address of new list head in $v0
            lw $t0, 4($sp) # old list head
            sw $v0, 4($t0) # old.next = new head
            move $v0, $t0
            j delete_r_end
        delete_r_element_found:
            lw $v0, 4($a0) # current_head = current_head.next
            j delete_r_end

    delete_r_base_case:
        li $v0, 0

    delete_r_end:
        lw $ra, 0($sp)
        add $sp, $sp, 8
        jr $ra

delete:
    # $a0 = list head
    # $a1 = node value to delete
    # $v0 = new list head
    li $t0, 0     # previous
    move $t1, $a0 # current 

    delete_loop:
        beqz $t1, delete_loop_end
            lw $t2, 0($t1) # current value in $t2
            beq $t2, $a1, delete_loop_element_found
                move $t0, $t1  # prev = current
                lw $t1, 4($t1) # current = next
                j delete_loop
            delete_loop_element_found:
                beqz $t0, delete_loop_special_case
                    lw $t3, 4($t1) # address of next element
                    sw $t3, 4($t0) # prev.next = curr.next
                    j delete_loop_end
                delete_loop_special_case:
                    # deleting list head
                    lw $t1, 4($t1)
                    move $v0, $t1
                    j delete_end
    delete_loop_end:
        move $v0, $a0
        j delete_end
    
    delete_end:
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

