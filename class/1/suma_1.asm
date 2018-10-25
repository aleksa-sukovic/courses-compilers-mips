# Napisati program ciji su ulazni podaci a i b (a<=b) , a rezultat je: 
# y=a+2(a+1)+4(a+2)+8(a+3)+...+2^(b+2)*b
# ukupno clanova: b - a + 1

.text

	la $a0, por1,
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	
	move $t0, $v0 # broj a u $t0
	
	la $a0, por2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t1, $v0 # broj b je u $t1
	sub $t2, $t1, $t0 # u $t2 je b-a
	li $t3, 0 # brojac
	li $t4, 1 # stepen 2
	li $t6, 0 # suma
	
petlja:
	bgt $t3, $t2, kraj
	add $t5, $t0, $t3 # vrijednost u zagradi (a+brojac)
	mulo $t5, $t5, $t4
	add $t6, $t6, $t5 # sumiranje
	
	add $t3, $t3, 1 # brojac++
	mulo $t4, $t4, 2 # stepen*2
	j petlja
kraj:	
	move $a0, $t6
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall

.data
	por1: .asciiz "Unesi a:"
	por2: .asciiz "Unesi b:"