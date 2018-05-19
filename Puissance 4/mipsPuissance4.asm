.data
SAUT_LIGNE: .asciiz "\n"
NB_COLONNE: .half 7
NB_LIGNE: .half 6
NB_CASE: .half 42
CASE_VIDE: .asciiz  "[ ]"
CASE_ROUGE: .asciiz  "[+]"
CASE_JAUNE: .asciiz "[*]"
GRILLE: .space 84 			#NB_CASE*2
NB_JETONS_COLONNE: .space 14		#NB_COLONNE*2
NB_COUP_JOUE: .half 0
NUMEROTATION: .asciiz " 0  1  2  3  4  5  6"
MSG_JAUNE: .asciiz "C'est au tour du joueur JAUNE de jouer"
MSG_ROUGE: .asciiz "C'est au tour du joueur ROUGE de jouer"
ERREUR: .asciiz "ERREUR "
STOP: .half 0
MSG_STOP: .asciiz "Pour arreter de jouer, entrer -1"
WIN_JAUNE: .asciiz "Le joueur JAUNE a gagné"
WIN_ROUGE: .asciiz "Le joueur ROUGE a gagné"
FIN_PARTIE: .asciiz "FIN de la PARTIE"
MATCH_NUL: .asciiz "MATCH NUL"
T_SAUT: .word ETQVIDE, ETQROUGE, ETQJAUNE

.text 
.globl main
main:
	jal jouerPartiePuissance4
	ori $v0, $zero, 10
	syscall
		
afficherCase: 				#ENTREE $a0 (UTILISE $t0, $t1)
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
SWITCH: sll $a0, $a0, 2
	la $t0 T_SAUT
	addu $t1, $a0, $t0   		#$t1 <= &T_SAUT[K]
	lw $t1, 0($t1)      
	jr $t1
ETQVIDE:
	la $a0 CASE_VIDE		#AFFICHE CHAR_VIDE
	j SUITE0
ETQROUGE:
	la $a0 CASE_ROUGE		#AFFICHE CHAR_ROUGE
	j SUITE0
ETQJAUNE:
	la $a0 CASE_JAUNE		#AFFICHE CHAR_JAUNE
	j SUITE0
SUITE0:ori $v0 , $zero, 4		#OPTION AFFICHAGE CHAR
	syscall
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra

afficherGrille: 			#PAS D'ENTREE (UTILISE $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7)
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
	la $t2 GRILLE
	la $t3 NB_LIGNE 		#INT J
	lh $t3, 0($t3)
	addi $t3, $t3, -1
	la $t4 NB_COLONNE
	lh $t4, 0($t4)
	ori $t6, $zero, -1
POUR_0:	slt $t7, $t6, $t3		#POUR J ALLANT DE NB_COLONNE-1 à 0
	beq $t7, $zero, SUITE_0		
	ori $t5, $zero, 0 		#INT I
POUR_1:	slt $t7, $t5, $t4		#POUR I ALLANT DE 0 à NB_LIGNE-1
	beq $t7, $zero SUITE_1		
	lh $a0, 0($t2)
	jal afficherCase
	addiu $t2, $t2, 2
	addi $t5, $t5, 1
	j POUR_1 
SUITE_1:addi $t3, $t3, -1
	la $a0 SAUT_LIGNE		#SAUT_LIGNE
	ori $v0, $zero, 4
	syscall
	j POUR_0

SUITE_0:lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
	
demanderCouleurDeLaCaseXY:		#ENTREE $a0, $a1 (UTILISE $t0, $t1) #SORTIE $v0
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
	la $t0 NB_COLONNE		#CALCUL DE POSITION
	lh $t0, 0($t0)			#
	la $t1 NB_LIGNE			#
	lh $t1, 0($t1)			#
	addi $t1, $t1, -1		#
	sub $a1, $t1, $a1		#
	mult $a1, $t0			#
	mflo $t0			#
	add $t0, $t0, $a0		#
	add $t0, $t0, $t0		#x2 HALF
	la $t1 GRILLE			#CHARGEMENT TABLEAU GRILLE
	addu $t0, $t0, $t1		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $v0, 0($t0)
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
	
nbDeJetonsColonne:			#ENTREE $a0 (UTILISE $t0) #SORTIE $v0
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
	add $a0, $a0, $a0		#x2 HALF
	la $t0 NB_JETONS_COLONNE	#CHARGEMENT TABLEAU NB_JETONS_COLONNE
	addu $t0, $t0, $a0		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $v0, 0($t0)
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra

ajouterJeton:				#ENTREE $a0 (UTILISE $t0, $t1, $t2, $t3)
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
	la $t1 NB_COLONNE		#CALCUL DE POSITION
	lh $t1, 0($t1)
	ori $t3, $a0, 0			#STOCKAGE DE $a0
	jal nbDeJetonsColonne
	la $t0 NB_LIGNE
	lh $t0, 0($t0)
	addi $t0, $t0, -1
	sub $v0, $t0, $v0
	mult $v0, $t1
	mflo $t1
	add $t1, $t1, $t3
	add $t1, $t1, $t1		#x2 HALF
	la $t2 GRILLE			#CHARGEMENT TABLEAU GRILLE
	addu $t1, $t1, $t2		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	la $t0 NB_COUP_JOUE
	lh $t0, 0($t0)
	andi $t0, $t0, 1	
	beq $t0, $zero, ELSE_0
	ori $t2, $zero, 1
	j SUITE_2
ELSE_0:	ori $t2, $zero, 2
SUITE_2:sh $t2, 0($t1)			#AJOUTE LE JETON
	add $t3, $t3, $t3		#x2 HALF
	la $t0 NB_JETONS_COLONNE	#CHARGEMENT TABLEAU NB_JETONS_COLONNE
	addu $t0, $t0, $t3		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t1, 0($t0)
	addi $t1, $t1, 1
	sh $t1, 0($t0)			#NB_JETON_COLONNE[choixJoueur]++
	la $t0 NB_COUP_JOUE
	lh $t1, 0($t0)
	addi $t1, $t1, 1
	sh $t1, 0($t0)			#NB_COUP_JOUE++
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
	
estCoupInvalide:			#ENTREE $a0 (UTILISE $t0, $t1) #SORTIE $v0
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
	move $t1, $a0			#STOCKAGE DE $a0
	jal nbDeJetonsColonne
	la $t0 NB_LIGNE
	lh $t0, 0($t0)
	beq $v0, $t0, ELSE_1		#IF(nbDeJetonsColonne($a0) == NB_LIGNE OU $a0 <0 OU $a0 > NB_COLONNE-1)
	ori $t0, $zero, -1
	slt $t0, $t0, $t1
	beq $t0, $zero, ELSE_1
	la $t0 NB_COLONNE
	lh $t0, 0($t0)
	slt $t0, $t1, $t0
	beq $t0, $zero, ELSE_1
	ori $v0, $zero, 1
	j SUITE_3
ELSE_1:	ori $v0, $zero, 0

SUITE_3:lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp) 
	addiu $sp, $sp, 8
	jr $ra

jouerCoupPuissance4:			#PAS D'ENTREE (UTILISE $t0, $t1, $t2, $t3, $t4) #SORTIE $v0
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
	jal afficherGrille
	la $a0 NUMEROTATION		#AFFICHE NUMEROTATION
	ori $v0, $zero, 4
	syscall
	la $a0 SAUT_LIGNE		#SAUT_LIGNE
	syscall
	la $t0 NB_COUP_JOUE
	lh $t0, 0($t0)
	andi $t0, $t0, 1
	ori $t1, $zero, 0			#VARIABLE DU LOOP (BOOLEAN)
	beq $t0, $zero, ELSE_2
	la $a0 MSG_ROUGE
	syscall
	la $a0 SAUT_LIGNE
	syscall
LOOP_0:	bne $t1, $zero, SUITE_4		#TANT QUE LE JOUEUR JOUE MAL SON COUP
	ori $v0, $zero, 5			#scanf(choixJoueur)
	syscall
	ori $t0, $zero, -1
	bne $v0, $t0 SUITE_5
	la $t0 STOP			#SI choixJoueur == -1 
	ori $t2, $zero, 1
	sh $t2, 0($t0)
	ori $v0, $zero, 0
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_5:move $t3, $v0			#STOCKAGE DE $v0 (choixJoueur)
	move $a0, $v0			#SI BOOLEAN == 0
	jal estCoupInvalide
	move $t1, $v0
	bne $t1, $zero, SUITE_4
	la $a0 ERREUR			#PRINT ERREUR ROUGE
	ori $v0, $zero, 4
	syscall
	la $a0 MSG_ROUGE
	syscall
	la $a0 SAUT_LIGNE
	syscall
	j LOOP_0
ELSE_2:	la $a0 MSG_JAUNE
	syscall
	la $a0 SAUT_LIGNE
	syscall
LOOP_1:	bne $t1, $zero, SUITE_4		#TANT QUE LE JOUEUR JOUE MAL SON COUP
	ori $v0, $zero, 5			#scanf(choixJoueur)
	syscall
	ori $t0, $zero, -1
	bne $v0, $t0 SUITE_7
	la $t0 STOP			#SI choixJoueur == -1 
	ori $t2, $zero, 1
	sh $t2, 0($t0)
	ori $v0, $zero, 0
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_7:move $t3, $v0			#STOCKAGE DE $v0 (choixJoueur)
	move $a0, $v0			#SI BOOLEAN == 0
	jal estCoupInvalide
	move $t1, $v0
	bne $t1, $zero, SUITE_4
	la $a0 ERREUR			#PRINT ERREUR JAUNE
	ori $v0, $zero, 4
	syscall
	la $a0 MSG_JAUNE
	syscall
	la $a0 SAUT_LIGNE
	syscall
	j LOOP_1
SUITE_4:move $a0, $t3			#JOUER LE COUP
	move $t4, $t3
	jal ajouterJeton
	move $v0, $t4
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra

estCoupGagnantDiag:			#ENTREE $a0 (UTILISE $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8) #SORTIE $v0
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
	la $t7 GRILLE			
	move $t2, $a0			#STOCKAGE de $a0 -- $t2 contient choixJoueur
	jal nbDeJetonsColonne
	addi $v0, $v0, -1		#$v0 contient la coordonnée y du jeton
	move $t3, $v0			#$t3 contient hauteur
	move $a0, $t2
	move $a1, $t3
	jal demanderCouleurDeLaCaseXY
	move $t4, $v0			#$t4 contient couleur
	la $t0 NB_COLONNE
	lh $t0, 0($t0)
	la $t1 NB_LIGNE
	lh $t1, 0($t1)
	addi $t6, $t1, -3		#$t6 REGISTRE AJUSTABLE  #MODIFIER ??
	slt $t5, $t3, $t6		#$t5 REGISTRE TEST
	beq $t5, $zero, SUITE_8		#SI HAUTEUR < NB_LIGNE-3 EST FAUX
	ori $t6, $zero, 2						#MODIFIER ??
	slt $t5, $t6, $t2
	beq $t5, $zero SUITE_8		#SI 2 < choixJoueur est faux
	#///#
	addi $t8, $t1, -1		#$t8 contient NB_LIGNE-1
	addi $a1, $t3, 1		#$a1 contient hauteur +1
	sub $a1, $t8, $a1		#$a1 contient NB_LIGNE - hauteur - 2
	mult $a1, $t0
	mflo $t6			#$t6 contient NB_COLONNE(NB_LIGNE - hauteur - 2)
	addi $a0, $t2, -1		#$a0 contient choixJoueur - 1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU ($t7 contient la GRILLE)
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_8		#SI  Grille[choixJoueur - 1][hauteur + 1] != couleur 
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, 2
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_8
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, 3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -3
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_8
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_8:addi $t6, $t1, -2		#$t6 REGISTRE AJUSTABLE  #MODIFIER ??
	slt $t5, $t3, $t6		#$t5 REGISTRE TEST
	beq $t5, $zero, SUITE_9
	ori $t6, $zero, 1						#MODIFIER ??
	slt $t5, $t6, $t2
	beq $t5, $zero SUITE_9
	ori $t6, $zero, 0						#MODIFIER ??
	slt $t5, $t6, $t3
	beq $t5, $zero SUITE_9
	addi $t6, $t0, -1					#MODIFIER ??
	slt $t5, $t2, $t6		
	beq $t5, $zero, SUITE_9
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, 1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_9
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, 2
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_9
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_9
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_9:addi $t6, $t1, -1		#$t6 REGISTRE AJUSTABLE  #MODIFIER ??
	slt $t5, $t3, $t6		#$t5 REGISTRE TEST
	beq $t5, $zero, SUITE_10
	ori $t6, $zero, 0						#MODIFIER ??
	slt $t5, $t6, $t2
	beq $t5, $zero SUITE_10
	ori $t6, $zero, 1						#MODIFIER ??
	slt $t5, $t6, $t3
	beq $t5, $zero SUITE_10
	addi $t6, $t0, -2					#MODIFIER ??
	slt $t5, $t2, $t6		
	beq $t5, $zero, SUITE_10
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, 1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_10
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_10
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -2
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_10
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_10:
	ori $t6, $zero, 2						#MODIFIER ??
	slt $t5, $t6, $t3
	beq $t5, $zero SUITE_11
	addi $t6, $t0, -3					#MODIFIER ??
	slt $t5, $t2, $t6		
	beq $t5, $zero, SUITE_11
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_11
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -2
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_11
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 3
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_11
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_11:
	addi $t6, $t1, -3		#$t6 REGISTRE AJUSTABLE  #MODIFIER ??
	slt $t5, $t3, $t6		#$t5 REGISTRE TEST
	beq $t5, $zero, SUITE_12
	addi $t6, $t0, -3					#MODIFIER ??
	slt $t5, $t2, $t6		
	beq $t5, $zero, SUITE_12
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, 1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_12
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, 2
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_12
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, 3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 3
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_12
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_12:
	addi $t6, $t1, -2		#$t6 REGISTRE AJUSTABLE  #MODIFIER ??
	slt $t5, $t3, $t6		#$t5 REGISTRE TEST
	beq $t5, $zero, SUITE_13
	addi $t6, $t0, -2					#MODIFIER ??
	slt $t5, $t2, $t6		
	beq $t5, $zero, SUITE_13
	ori $t6, $zero, 0						#MODIFIER ??
	slt $t5, $t6, $t3
	beq $t5, $zero SUITE_13
	ori $t6, $zero, 0						#MODIFIER ??
	slt $t5, $t6, $t2
	beq $t5, $zero SUITE_13
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, 1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_13
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, 2
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_13
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_13
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_13:
	addi $t6, $t1, -1		#$t6 REGISTRE AJUSTABLE  #MODIFIER ??
	slt $t5, $t3, $t6		#$t5 REGISTRE TEST
	beq $t5, $zero, SUITE_14
	addi $t6, $t0, -1					#MODIFIER ??
	slt $t5, $t2, $t6		
	beq $t5, $zero, SUITE_14
	ori $t6, $zero, 1						#MODIFIER ??
	slt $t5, $t6, $t3
	beq $t5, $zero SUITE_14
	ori $t6, $zero, 1						#MODIFIER ??
	slt $t5, $t6, $t2
	beq $t5, $zero SUITE_14
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, 1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_14
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_14
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -2
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_14
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_14:
	ori $t6, $zero, 2						#MODIFIER ??
	slt $t5, $t6, $t3
	beq $t5, $zero SUITE_15
	ori $t6, $zero, 2						#MODIFIER ??
	slt $t5, $t6, $t2
	beq $t5, $zero SUITE_15
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_15
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -2
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_15
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -3
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_15
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_15:
	ori $v0, $zero, 0
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra

estCoupGagnantHori:			#ENTREE $a0 (UTILISE $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8) #SORTIE $v0
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
	la $t7 GRILLE
	move $t2, $a0			#STOCKAGE de $a0 -- $t2 contient choixJoueur
	jal nbDeJetonsColonne
	addi $v0, $v0, -1
	move $t3, $v0			#$t3 contient hauteur
	move $a0, $t2
	move $a1, $t3
	jal demanderCouleurDeLaCaseXY
	move $t4, $v0			#$t4 contient couleur
	la $t0 NB_COLONNE
	lh $t0, 0($t0)
	la $t1 NB_LIGNE
	lh $t1, 0($t1)
	ori $t6, $zero, 2						#MODIFIER ??
	slt $t5, $t6, $t2
	beq $t5, $zero SUITE_16
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_16
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_16
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -3
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_16
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_16:
	ori $t6, $zero, 1						#MODIFIER ??
	slt $t5, $t6, $t2
	beq $t5, $zero SUITE_17
	addi $t6, $t0, -1					#MODIFIER ??
	slt $t5, $t2, $t6		
	beq $t5, $zero, SUITE_17
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_17
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_17
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_17
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_17:
	ori $t6, $zero, 0						#MODIFIER ??
	slt $t5, $t6, $t2
	beq $t5, $zero SUITE_18
	addi $t6, $t0, -2					#MODIFIER ??
	slt $t5, $t2, $t6		
	beq $t5, $zero, SUITE_18
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, -1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_18
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_18
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_18
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_18:
	addi $t6, $t0, -3					#MODIFIER ??
	slt $t5, $t2, $t6		
	beq $t5, $zero, SUITE_19
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 1
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_19
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 2
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_19
	#///#
	addi $t8, $t1, -1
	move $a1, $t3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	addi $a0, $t2, 3
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_19
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_19:
	ori $v0, $zero, 0
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra

estCoupGagnantVert:			#ENTREE $a0 (UTILISE $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8) #SORTIE $v0
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
	la $t7 GRILLE
	move $t2, $a0			#STOCKAGE de $a0 -- $t2 contient choixJoueur
	jal nbDeJetonsColonne
	addi $v0, $v0, -1
	move $t3, $v0			#$t3 contient hauteur
	move $a0, $t2
	move $a1, $t3
	jal demanderCouleurDeLaCaseXY
	move $t4, $v0			#$t4 contient couleur
	la $t0 NB_COLONNE
	lh $t0, 0($t0)
	la $t1 NB_LIGNE
	lh $t1, 0($t1)
	ori $t6, $zero, 2						#MODIFIER ??
	slt $t5, $t6, $t3
	beq $t5, $zero SUITE_20
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -1
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_20
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -2
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_20
	#///#
	addi $t8, $t1, -1
	addi $a1, $t3, -3
	sub $a1, $t8, $a1
	mult $a1, $t0
	mflo $t6
	add $t6, $t6, $a0
	add $t6, $t6, $t6		#x2 HALF
	addu $t6, $t6, $t7		#PLACEMENT DE LA POSITION PAR RAPPORT AU TABLEAU
	lh $t6, 0($t6)
	#///#
	bne $t6, $t4 SUITE_20
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_20:
	ori $v0, $zero, 0
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
	
estCoupGagnant: 			#ENTREE $a0 (UTILISE $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9) #SORTIE $v0
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
	move $t9, $a0			#$t9 contient le choix du joueur
	jal estCoupGagnantDiag
	beq $v0, $zero, SUITE_21
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_21:
	move $a0, $t9
	jal estCoupGagnantHori
	beq $v0, $zero, SUITE_22
	ori $v0, $zero, 1
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_22:
	move $a0, $t9
	jal estCoupGagnantVert
	beq $v0, $zero, SUITE_23
	ori $v0, $zero, 1
	
	lw $ra, 0($sp)			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_23:
	ori $v0, $zero, 0
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
	
jouerPartiePuissance4:			#PAS D'ENTREE (UTILISE $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9) #SORTIE $v0
	addiu $sp, $sp, -8 		#PROLOGUE
	sw $fp, 4($sp)
	addiu $fp, $sp, 8
	sw $ra, 0($sp)
	
	la $a0 MSG_STOP			
	ori $v0, $zero, 4
	syscall
	la $a0 SAUT_LIGNE
	syscall
LOOP_2:	la $t0 NB_COUP_JOUE		
	lh $t0, 0($t0)
	la $t1 NB_CASE
	lh $t1 0($t1)
	slt $t2, $t0, $t1
	beq $t2, $zero, SUITE_24
	la $t0 STOP			#STOP
	lh $t0, 0($t0)
	beq $t0, $zero SUITE_25
	ori $v0, $zero, 0
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_25:
	jal jouerCoupPuissance4		#estCoupGagnant(jouerCoupPuissance4) == 1 && stop == 0
	la $t0 STOP			#
	lh $t0, 0($t0)			#
	ori $t1, $zero, 1		#
	beq $t0, $t1, SUITE_26		#DETECTE SI STOP == 1
	move $a0, $v0			#
	jal estCoupGagnant		#
	beq $v0, $zero, SUITE_26	#DETECTE SI QUELQU'UN GAGNE
	jal afficherGrille
	la $t0 NB_COUP_JOUE		#DETECTE A QUI APPARTIENT LE TOUR
	lh $t0, 0($t0)
	andi $t0, $t0, 1	
	beq $t0, $zero, ELSE_3
	la $a0 WIN_JAUNE		#JAUNE GAGNE
	ori $v0, $zero, 4
	syscall
	la $a0 SAUT_LIGNE
	syscall
	j SUITE_27
ELSE_3:	la $a0 WIN_ROUGE		#ROUGE GAGNE
	ori $v0, $zero, 4
	syscall
	la $a0 SAUT_LIGNE
	syscall
SUITE_27:
	la $a0 FIN_PARTIE
	syscall
	la $a0 SAUT_LIGNE
	syscall
	ori $v0, $zero, 0
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
SUITE_26:
	j LOOP_2
SUITE_24:
	jal afficherGrille		#MATCH NUL
	ori $v0, $zero, 4
	la $a0 MATCH_NUL
	syscall
	la $a0 SAUT_LIGNE
	syscall
	la $a0 FIN_PARTIE
	syscall
	la $a0 SAUT_LIGNE
	syscall
	ori $v0, $zero, 0
	
	lw $ra, 0($sp) 			#EPILOGUE
	lw $fp, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
	




