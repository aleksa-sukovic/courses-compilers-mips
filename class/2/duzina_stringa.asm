.text

main:
	# Ucitavanje stringa
	la $a0, string_space
	li $a1, 1000         # duzina buffer-a
	li $v0, 8
	syscall
	
	# petlja za duzinu stringa
	la $t0, string_space
	
	petlja_duzina:
		lb $t1, 0($t0) # ucitaj bajt sa adrese $t0 + 0
		beq $t1, 0, kraj_petlje_duzina
		add $t0, $t0, 1
		j petlja_duzina
		
	kraj_petlje_duzina:
		sub $t0, $t0, 1      # \n ulazi u sadrzaj string
		la $t2, string_space # u $t2 pocetna adresa, u $t0 krajnja
		sub $t1, $t0, $t2    # u $t1 je duzina
		
		move $a0, $t1
		li $v0, 1
		syscall
		
		li $v0, 10
		syscall

.data
	string_space: .space 1000 # rezervise blok duzine 1000 bajtova