.text
	
	main:
		li $v0, 5
		syscall
		
		move $t0, $v0 # u $t0 ide N - broj elemenata niza
		li $t1, 0 # brojac
		
		la $t2, array # u $t2 pocetna adresa ( adresa prvog elementa, bloka )
	
	petlja_unos:
		bge $t1, $t0, kraj_petlje_unos
		
		li $v0, 5
		syscall
		
		sw $v0, 0($t2) # ucitani element u memoriju na adresu $t2
		
		add $t1, $t1, 1 # uvecavanje brojaca
		add $t2, $t2, 4 # uvecavanje adrese
		j petlja_unos
		
	kraj_petlje_unos:
		la $a0, array # adresa niza u $a0
		move $a1, $t0 # duzina niza u $a1
		jal maximum   # u $v0 je rezultat
		
		move $a0, $v0
		li $v0, 1
		syscall
		
		li $v0, 10
		syscall
		
maximum:
	lw $v0, 0($a0) # prvi element proglasen za najveci
	li $t0, 0      # brojac
	move $t1, $a0  # pocetna adresa niza
	
	petlja_max:
		bge $t0, $a1, kraj_petlja_max
		lw $t3, 0($t1)
		bge $t3, $v0, novi_max
		j next_petlja_max
		
		novi_max:
			move $v0, $t3 # u $v0 novi max element
		next_petlja_max:
			add $t0, $t0, 1 # uvecavanje brojaca
			add $t1, $t1, 4 # uvecavanje adrese
			j petlja_max	
	
	kraj_petlja_max:
		jr $ra
		
.data
	array: .space 120 # svaki element je 4 bajta, po uslovu zadatka niza ima maksimum 30 elemenata