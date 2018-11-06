.data
	xinputmsg: .asciiz "Enter X:"
	ninputmsg: .asciiz "Enter N:"
	ainputmsg: .asciiz "Enter A:"

.text

main:
	# Reading N
	la $a0, yinputmsg
	li $v0, 4
	syscall # N input message
	li $v0, 5
	syscall
	move $a0, $v0 # N in $a0

	# Reading A
	la $a0, xinputmsg
	li $v0, 4
	syscall # A input message
	li $v0, 5
	syscall
	move $a1, $v0 # A in $a1

	# Reading X
	la $a0, xinputmsg
	li $v0, 4
	syscall # X input message
	li $v0, 5
	syscall
	move $a2, $v2 # X in $a2

	jal poly

	move $a0, $v0 # result in $a0
	li $v0, 1			
	syscall # printing result

	li $v0, 10
	syscall

poly:
	li $v0, 321
	jr $ra