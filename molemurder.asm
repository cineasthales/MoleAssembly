###### MOLE MURDER ######
# Isabelle Azevedo
# Thales Castro 

# Configurações
# 4px 4px
# 512x512

####################################################################

.data
	colororange_mole: .word 0x00ff6600 # cor laranja da toupeira
	colororange: .word 0x00ff8000 # cor laranja do grid
	colorwhite: .word 0x00ffffff # cor branca
	colorgrey: .word 0x0028282a # cor cinza
	colorblack: .word 0x00000000 # cor preta
	bomba: .asciiz "BOOM! Vidas restantes: "
	fimdejogo: .asciiz "Fim de jogo! Pontuação: "
	jogarnovamente: .asciiz "Jogar novamente?"
	vitoriamsg: .asciiz "Vitória nesta rodada! Vidas restantes: "
	iniciomsg: .asciiz "MOLE MURDER.\nTente adivinhar onde estão as toupeiras digitando os números das posições.\nMas cuidado com a bomba!\nVamos começar?"

.text

####################################### Main

main:
	# carrega cores
	lw $t1, colororange
	lw $t2, colorwhite
	lw $t3, colororange_mole
	lw $t4, colorgrey
	lw $t9, colorblack
	 
	lui $s0, 0x1001 # endereço de memória inicial
	addi $s1, $s0, 168 # início da coluna 1 (42*4)
	addi $s2, $s1, 168 # início da coluna 2 (42*4)
	addi $s3, $s0, 21504 # início da linha 1 (128*42*4)
	addi $s4, $s3, 21504 # início da linha 2 (128*42*4)

	li $t5, 0 # contador das colunas
	li $t6, 128 # limite de repetições do preenchimento do grid
	li $t7, 0 # contador das linhas
	
	li $v0, 55 # mensagem de início do jogo
	la $a0, iniciomsg
	li $a1, 1
	syscall
	
# cria linhas 
loop_l: 	
	sw $t1, 0($s3) # pinta linha 1
	sw $t1, 0($s4) # pinta linha 2
	addi $s3, $s3, 4 # próximo endereço
	addi $s4, $s4, 4 # próximo endereço
	addi $t5, $t5, 1 # contador ++
	beq $t5, $t6, loop_c # se acabaram as linhas, vai para colunas
	nop
	j loop_l
	nop

# cria colunas	
loop_c:
	sw $t1, 0($s1) # pinta coluna 1
	sw $t1, 0($s2) # pinta coluna 2
	addi $s1, $s1, 512 # próximo endereço (128*4)
	addi $s2, $s2, 512 # próximo endereço (128*4)
	addi $t7, $t7, 1 # contador ++
	beq $t7, $t6, preInicio # se acabaram as colunas, prepara o início do jogo
	nop
	j loop_c
	nop
 	
# inicia jogo
preInicio: 
	li $t6, 3 # vidas
		
sorteia:
	li $v0, 42 # sorteio da posição da bomba
	li $a1, 8 # limite máximo do sorteio (faixa: 0 a 8)
	syscall
	
	addi $a0, $a0, 1 # posição ++ (faixa: 1 a 9)
	
	move $t8, $a0 
	
	li $s5, 0 # contador de acertos da rodada (máximo 5)

start:
	beq $s5, 5, vitoria # se achou cinco toupeiras, ganhou a rodada 
	nop 
	
	li $v0, 5 # lê número inteiro do terminal
	syscall
	
	beq $v0, $t8, boom # se achou bomba, perde 1 vida
	nop	
	
	# preenche o quadro correspondente à opção digitada
	
	beq $v0, 1, baixoesq
	nop
	
	beq $v0, 2, baixomeio
	nop
	
	beq $v0, 3, baixodir
	nop
	
	beq $v0, 4, meioesq
	nop
	
	beq $v0, 5, meiomeio
	nop
	
	beq $v0, 6, meiodir
	nop
  
  	beq $v0, 7, cimaesq
	nop
	
	beq $v0, 8, cimameio
	nop
	
	beq $v0, 9, cimadir
	nop
      
# quadros

baixoesq:
	li $a0, 53324
	jal geraMarmota
	nop
	
	addi $t0, $t0, 1 # pontuação ++
	addi $s5, $s5, 1 # contador de toupeiras encontradas ++
	
	j start
	nop

baixomeio:
	li $a0, 53492
	jal geraMarmota
	nop
	
	addi $t0, $t0, 1 # pontuação ++
	addi $s5, $s5, 1 # contador de toupeiras encontradas ++
	
	j start
	nop
	
baixodir:
	li $a0, 53660
	jal geraMarmota
	nop
	
	addi $t0, $t0, 1 # pontuação ++
	addi $s5, $s5, 1 # contador de toupeiras encontradas ++
	
	j start
	nop
	
meioesq:
	li $a0, 30796
	jal geraMarmota
	nop
	
	addi $t0, $t0, 1 # pontuação ++
	addi $s5, $s5, 1 # contador de toupeiras encontradas ++
	
	j start
	nop
	
meiomeio:
	li $a0, 30964
	jal geraMarmota
	nop
	
	addi $t0, $t0, 1 # pontuação ++
	addi $s5, $s5, 1 # contador de toupeiras encontradas ++
	
	j start
	nop
		
meiodir:
	li $a0, 31132
	jal geraMarmota
	nop
	
	addi $t0, $t0, 1 # pontuação ++
	addi $s5, $s5, 1 # contador de toupeiras encontradas ++
	
	j start
	nop
	
cimaesq:
	li $a0, 9292
	jal geraMarmota
	nop
	
	addi $t0, $t0, 1 # pontuação ++
	addi $s5, $s5, 1 # contador de toupeiras encontradas ++
	
	j start
	nop
	
cimameio:
	li $a0, 9460
	jal geraMarmota
	nop
	
	addi $t0, $t0, 1 # pontuação ++
	addi $s5, $s5, 1 # contador de toupeiras encontradas ++
	
	j start
	nop
	
cimadir:
	li $a0, 9628
	jal geraMarmota
	nop
	
	addi $t0, $t0, 1 # pontuação ++
	addi $s5, $s5, 1 # contador de toupeiras encontradas ++
	
	j start
	nop

# vitoria / derrota

vitoria: 
	 li $v0, 56 # mensagem de vitória da rodada
	 la $a0, vitoriamsg 
	 move $a1, $t6
	 syscall
	 
	 j apagar
	 nop
	
boom:
	subi $t6, $t6, 1 # perde uma vida
	
	li $v0, 56  # mensagem da bomba
	la $a0, bomba
	move $a1, $t6
	syscall
	
	beq $t6, $zero, gameover # se vidas = 0, game over
	nop
	
	j apagar
	nop

gameover:
	li $v0, 56 # mensagem de game over com pontuação
	la $a0, fimdejogo
	move $a1, $t0
	syscall
	
	li $v0, 50 # mensagem de opção de jogar novamente
	la $a0, jogarnovamente
	syscall
	
	li $t0, 0 # zera pontuação
	
	beq $a0, $zero, apagar # se jogador quer recomeçar, apaga o grid
	nop

	li $v0, 10 # fim do programa
	syscall

apagar:
	# todas os quadros são preenchidos de preto
	move $t1, $t9
	move $t2, $t9
	move $t3, $t9
	move $t4, $t9
	
	li $a0, 9292
	jal geraMarmota
	nop
	
	li $a0, 9460
	jal geraMarmota
	nop
	
	li $a0, 9628
	jal geraMarmota
	nop
	
	li $a0, 30796
	jal geraMarmota
	nop
	
	li $a0, 30964
	jal geraMarmota
	nop
	
	li $a0, 31132
	jal geraMarmota
	nop
	
	li $a0, 53324
	jal geraMarmota
	nop
	
	li $a0, 53492
	jal geraMarmota
	nop
	
	li $a0, 53660
	jal geraMarmota
	nop
	
	# recarregamento das cores
	lw $t1, colororange
	lw $t2, colorwhite
	lw $t3, colororange_mole
	lw $t4, colorgrey
	
	bne $t6, $zero, sorteia # se vidas não é zero, sorteia novas posições
	nop
	
	j preInicio
	nop

####################################### Subrotina geraMarmota

geraMarmota:

	lui $s1, 0x1001
	add $s1, $s1, $a0 #calcula o endereço do primeiro pixel para formar o desenho da toupeira
	li $t5, 0
	li $t7, 0
	    			#funções auxs servem para garantir a segunda repetição de uma linha 
	op: 			#função para criar as duas primeiras linhas da imagem (funções ops geram duas linhas para a criação da imagem da touperia)
	sw $t4, 0($s1)    	#armazena a cor cinza na memória
	addi $s1, $s1, 4	
	        
	addi $t5, $t5, 1	#soma 1 ao contador 
	bne $t5, 8, op		#repete 8 vezes o armazenamento da cor cinza
	nop
	      
	addi $t7, $t7, 1  	#serve para garantir a repetição da impressão na linha (2 vezes no máximo)
	bne $t7, 2, aux
	nop
	
	li $t7, 0				
	addi $s1, $s1, 464             # pula da segunda para a terceira linha (linha 19 - linha 20) 
	
	op1:
	     sw $t4, 0($s1)    		#armazena a cor cinza na memória
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#armazena a cor cinza na memória
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#armazena a cor cinza na memória
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#armazena a cor cinza na memória
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira 
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1) 		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     
	     addi $t7, $t7, 1  
	     bne $t7, 2, aux1
	     nop
	     
	li $t7, 0
	addi $s1, $s1, 440   		#linha 21- 22  
	     
	op2: sw $t4, 0($s1)   		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1) 		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     
	     
	     addi $t7, $t7, 1  
	     bne $t7, 2, aux2
	     nop
	     
	li $t7, 0
	addi $s1, $s1, 408     		#linha23 - linha 24
	
	op3: sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 12
	     sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4
	      sw $t3, 0($s1)    	#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	      sw $t3, 0($s1)    	#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4	   
	     sw $t9, 0($s1)    		#cor preto 
	     addi $s1, $s1, 4
	     sw $t9, 0($s1)    		#cor preto
	     addi $s1, $s1, 4
	
             addi $t7, $t7, 1  
	     bne $t7, 2, aux3
	     nop
		
	li $t7, 0
	addi $s1, $s1, 392     		#linha25 - linha 26
	
	op4: sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4 
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4 
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4 
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t3, 0($s1) 		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4   
	    	
	     addi $t7, $t7, 1  
	     bne $t7, 2, aux4
	     nop
	     
	li $t7, 0
	addi $s1, $s1, 392   		#linha 27 - linha 28
	
	op5: sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4 
	     sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4 
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	      sw $t3, 0($s1)    	#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4 
	     
	      
	
	
	     addi $t7, $t7, 1  
	     bne $t7, 2, aux5
	     nop
	     
	     
	li $t7, 0
	addi $s1, $s1, 400   		#linha 29 - linha 30
	
	op6: sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4 
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	      sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4 
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4         
	
	
	     addi $t7, $t7, 1  
	     bne $t7, 2, aux6
	     nop
	     
	     
	li $t7, 0
	addi $s1, $s1, 400  		#linha 31 - linha 32
	
	op7: sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)   		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     
	     
	     addi $t7, $t7, 1  
	     bne $t7, 2, aux7
	     nop
	     
	li $t7, 0
	addi $s1, $s1, 408  		#linha 33 - linha 34
	
	op8: sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	      sw $t3, 0($s1)    	#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4 
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     
	     
	     addi $t7, $t7, 1  
	     bne $t7, 2, aux8
	     nop
	     
	li $t7, 0
	addi $s1, $s1, 400  		#linha 35 - linha 36
	
	op9:  sw $t4, 0($s1)    	#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     
	
	     addi $t7, $t7, 1  
	     bne $t7, 2, aux9
	     nop
	     
	li $t7, 0
	addi $s1, $s1, 400  		#linha 37 - linha 38
	
	op10: sw $t4, 0($s1)    	#cor cinza 
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira 
	     addi $s1, $s1, 4
	      sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza 
	     addi $s1, $s1, 4   	      
		
	     addi $t7, $t7, 1  
	     bne $t7, 2, aux10
	     nop
	     
	li $t7, 0
	addi $s1, $s1, 408  		#linha 39 - linha 40
	
	op11: sw $t4, 0($s1)    	#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4 
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t3, 0($s1)    		#cor laranja da toupeira
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco 
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t2, 0($s1)		#cor branco
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4 
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1) 		#cor cinza
	     addi $s1, $s1, 4 
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4 
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4
	     sw $t4, 0($s1)    		#cor cinza
	     addi $s1, $s1, 4    	    
		
	     addi $t7, $t7, 1  
	     bne $t7, 2, aux11
	     nop
	
	j fim
	nop
	
	aux11: addi $s1, $s1, 416 	#linha 40 - linha 41
	       j op11
	       nop
	
	aux10: addi $s1, $s1, 408  	#linha 38 - linha 39
	       j op10
	       nop
	
	aux9: addi $s1, $s1, 400  	#linha 36 - linha 37
	      j op9
	      nop
	
	aux8: addi $s1, $s1, 408   	#linha 34 - linha 35
	      j op8
	      nop
	
	aux7: addi $s1, $s1, 400 	#linha 32 - linha 33
	      j op7
	      nop
	
	aux6: addi $s1, $s1, 392    	#linha 30 - linha 31 
	      j op6
	      nop
	
	aux5: addi $s1, $s1, 392 	#linha 28 - linha 29
	      j op5
	      nop	
	
	aux4: addi $s1, $s1, 392 	#linha 26 - linha 27
	      j op4
	      nop
	  
	aux3: addi $s1, $s1, 392        #linha 24 - linha 25
	      j op3
	      nop
	
	aux2: addi $s1, $s1, 432  	#linha 22 - linha 23
	      j op2
	      nop
	
	aux1: addi $s1, $s1, 448  	#linha 20 - linha 21
	      j op1
	      nop
	
	aux: addi $s1, $s1, 480  	#linha 19 - linha 20
	     li $t5, 0
	     j op
	     nop
	
	fim:     
	     jr $ra
	     nop
