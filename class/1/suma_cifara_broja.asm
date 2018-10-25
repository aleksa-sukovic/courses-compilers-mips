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

	# $a0-$a3 se tradicionalno koriste za proslijedjivanje argumenata pod programu
	# rezultat pod programa se tradicionalno vraca u registrima $v0 i $v1
	move $a0, $v0
	jal zbir_cifara
	
	# rezultat je u $v0
	move $a0, $v0
	li $v0, 1
	syscall
	
	# kraj programa
	li $v0, 10
	syscall
.data
	poruka: .asciiz "Unesite broj: "