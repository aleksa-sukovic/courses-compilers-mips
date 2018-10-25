.text

# Suma prvih n brojeva, n ucitati sa ulaza

main:
	# poruka
	la $a0, poruka
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	move $t2, $v0 # broj n
	
	li $t0, 0 # brojac
	li $t1, 0 # suma
	
petlja:
	bgt $t0, $t2, kraj
	add $t1, $t1, $t0
	addi $t0, $t0, 1
	j petlja
kraj:
	# stampa sume
	move $a0, $t1
	li $v0, 1
	syscall
	
	# kraj programa
	li $v0, 10
	syscall
	

.data
	poruka: .asciiz "Unesi broj N:"
