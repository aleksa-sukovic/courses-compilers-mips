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
		sub $t1, $t0, 2	     # pokazivac na poslednji karakter
		la $t0, string_space # pokazivac na prvi karakter
		
	petlja_palindrom:
		bgt $t0, $t1, jeste_palindrom
	
		lb $t2, 0($t0) # karakter lijevo
		lb $t3, 0($t1) # karakter desno
		bne $t2, $t3, nije_palindrom
		add $t0, $t0, 1
		sub $t1, $t1, 1
		j petlja_palindrom
		
	jeste_palindrom:
		li $a0, 1
		li $v0, 1
		syscall
		j kraj
		
	nije_palindrom:
		li $a0, 0
		li $v0, 1
		syscall
		
	kraj:
		li $v0, 10
		syscall

.data
	string_space: .space 1000 # rezervise blok duzine 1000 bajtova
