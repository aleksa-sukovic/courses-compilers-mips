# Unosi se broj n, stampati sumu cifara toga broja

.text
	
zbir_cifara:
	# broj je u $a0
	
	move $t0, $a0 # broj koji obradjujemo
	li $t1, 0     # suma cifara
	
petlja:
	beq $t0, 0, kraj_petlje
	rem $t2, $t0, 10  # ostatak u $t2
	add $t1, $t1, $t2
	div $t0, $t0, 10 
	j petlja
	
kraj_petlje:
	move $v0, $t1
	jr $ra

main:
	# stampa poruke
	la $a0, poruka
	li $v0, 4
	syscall
	
	# ucitavanje broja
	li $v0, 5
	syscall
	
	move $s0, $v0 # koliko ima brojeva na ulazu
	li $s1, 0     # suma
	li $s2, 0     # brojac
	
petlja_unos:
	bge $s2, $s0, kraj_petlja_unos
	
	li $v0, 5
	syscall
	
	move $a0, $v0
	jal zbir_cifara # u $0 je suma cifara trenutnog broja
	
	add $s1, $s1, $v0 # dodavanje na sumu
	add $s2, $s2, 1 # broja ++
	j petlja_unos
	
	
kraj_petlja_unos:
	# stampa sume
	move $a0, $s1
	li $v0, 1
	syscall
	
	# kraj programa
	li $v0, 10
	syscall

.data
	poruka: .asciiz "Unesite broj: "