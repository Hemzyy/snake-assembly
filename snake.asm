#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas obligatoire de comprendre ce qu'elles font.

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4

PSLoop:
bge $s1 $s0 endPSLoop
  lw $a0 colors + green
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
and $t0 0x1
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 115
beq $t0 $t1 GIhaut
li $t1 122
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
li $a0 200
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur

scoreMsg: .asciiz "\n\n\n\nTon score est : "
scoreMsg0: .asciiz "\nBranche ton clavier pour voir ?"
scoreMsg1: .asciiz "\njoue stp"
scoreMsg2: .asciiz "\nFais un effort, par pitié"
scoreMsg3: .asciiz "\nwaaa!! Tu es presque pas loin d'être mauvais"
scoreMsg4: .asciiz "\nTu es presque bon"
scoreMsg5: .asciiz "\nTema la taille du snake"
scoreMsg6: .asciiz "\nTricheur."

.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire de demi-tour
#                 en un unique tour de jeu. Cela s'apparente à du cannibalisme
#                 et à été proscrit par la loi dans les sociétés reptiliennes.
################################################################################

majDirection:

#la fonction prends le registre $a0 comme parametre qui contient 0, 1, 2, 3 ou 4
#ommence par mettre la derniere valeur de snakeDir dans le registre temporaire $t7

lw $t7 snakeDir
li $t5 4            #charge le nombre 4 dans le resgistre temporaire $t5
beq $a0 $t7 cont    #compare l'input avec le nombre 4 (erreur), si c'est le cas, saute vers la fonction cont
beq $a0 $t5 cont    #puis compare le meme input avec snakDir pour test si ils sont egaux et sauter vers cont si c'est le cas
                   
beq $t7 0 comp1     #si le input est egale à 0 executer comp1 
beq $t7 1 comp2     #si le input est egale à 1 executer comp2
beq $t7 2 comp3     #si le input est egale à 2 executer comp3 
beq $t7 3 comp4     #si le input est egale à 3 executer comp4 

comp1:
    li $t6 2            #charge 2 dans le registre temporaire $t6
    beq $a0 $t6 cont    #teste si $a0 n'est pas l'opposé de la derniere direction snakeDir, si oui saute vers cont
    sw $a0 snakeDir     #sinon on actualise snakeDir on stockant la valeur de $a0 dans snakeDir
    j cont

comp2:
    li $t6 3            #charge 3 dans le registre temporaire $t6
    beq $a0 $t6 cont    #teste si $a0 n'est pas l'opposé de la derniere direction snakeDir, si oui saute vers cont
    sw $a0 snakeDir     #sinon on actualise snakeDir on stockant la valeur de $a0 dans snakeDir
    j cont

comp3:
    li $t6 0            #charge 0 dans le registre temporaire $t6
    beq $a0 $t6 cont    #teste si $a0 n'est pas l'opposé de la derniere direction snakeDir, si oui saute vers cont
    sw $a0 snakeDir     #sinon on actualise snakeDir on stockant la valeur de $a0 dans snakeDir
    j cont

comp4:
    li $t6 1            #charge 1 dans le registre temporaire $t6
    beq $a0 $t6 cont    #teste si $a0 n'est pas l'opposé de la derniere direction snakeDir, si oui saute vers cont
    sw $a0 snakeDir     #sinon on actualise snakeDir on stockant la valeur de $a0 dans snakeDir
    j cont

cont:
jr $ra                  #sort de la fonction majDirection

############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:
subu $sp $sp 4
sw $ra 0($sp)
lw $t1 tailleSnake
subu $t1 $t1 1

moveLoop:
    beqz $t1 endMoveLoop
    mulu $t9 $t1 4
    sub $t8 $t9 4

    lw $t2 snakePosX($t8)
    lw $t3 snakePosY($t8)

    
    sw $t2 snakePosX($t9)
    sw $t3 snakePosY($t9)
    subu $t1 $t1 1
    j moveLoop


endMoveLoop:

lw $t7 snakeDir         #stock snakeDir dans le registre temporaire $t7
beq $t7 0 up            #on test si $t7 est égale à une des valeurs et on saute vers la fonctions aproprié
beq $t7 1 right
beq $t7 2 down
beq $t7 3 left

up:                     #dans le cas ou $t7 = 0 (haut)
    lw $a0 snakePosX    #stock la position X de la tete du serpent dans $a0
    addi $a0 $a0 1      #ajoute 1 a cette coordonnée
    sw $a0 snakePosX    #remet la nouvelle valeur de $a0 dans snakeDir
    j testIfAteCandy    #test si le serpent mange un bonbon a ce nouveau eplacement
    jr $ra              

right:                  #dans le cas ou $t7 = 1 (droite)
    lw $a0 snakePosY    #stock la position Y de la tete du serpent dans $a0
    addi $a0 $a0 1      #ajoute 1 a cette coordonnée
    sw $a0 snakePosY    #remet la nouvelle valeur de $a0 dans snakeDir
    j testIfAteCandy    #test si le serpent mange un bonbon a ce nouveau eplacement
    jr $ra

down:                   #dans le cas ou $t7 = 2 (bas)
    lw $a0 snakePosX    #stock la position X de la tete du serpent dans $a0
    subi $a0 $a0 1      #soustrait 1 de cette coordonnée
    sw $a0 snakePosX    #remet la nouvelle valeur de $a0 dans snakeDir
    j testIfAteCandy    #test si le serpent mange un bonbon a ce nouveau eplacement
    jr $ra

left:                   #dans le cas ou $t7 = 3 (gauche)
    lw $a0 snakePosY    #stock la position Y de la tete du serpent dans $a0
    subi $a0 $a0 1      #soustrait 1 de cette coordonnée
    sw $a0 snakePosY    #remet la nouvelle valeur de $a0 dans snakeDir
    j testIfAteCandy    #test si le serpent mange un bonbon a ce nouveau eplacement
    jr $ra
    
    
testIfAteCandy:
    lw $t1 candy        #stock la coordonné X et Y du bonbon dans les registre $t1 et $t2 respectivement
    lw $t2 candy + 4
    lw $t3 snakePosX    #stock la coordonné X et Y de la tete du serpent dans les registre $t3 et $t4 respectivement
    lw $t4 snakePosY
    
    beq $t1 $t3 Et      #test si les coordonées X du bonbon et du serpent sont egaux, si oui on test avec les coodonnées Y dans la fonction "Et"
    jr $ra              #sinon on sort de la fonction

Et:
    beq $t2 $t4 eat     #test si les coordonées X du bonbon et du serpent sont egaux, si oui, saute vers la fonction eat
    jr $ra              #sinon on sort de la fonction
        
eat:
    
    #ajoute +1 au score quand le serpent mange un bonbon
    lw $t0 scoreJeu
    addi $t0 $t0 1
    sw $t0 scoreJeu

    #donne des nouvelles coordonnées pour le nouveau bonbon et les stock dans candy et candy+4
    jal newRandomObjectPosition
    sw $v0 candy
    sw $v1 candy + 4

    lw $t4 numObstacles
    mul $t5 $t4 4
    addu $t4 $t4 1
    sw $t4 numObstacles

    jal newRandomObjectPosition
    sw $v0 obstaclesPosX($t5)
    sw $v1 obstaclesPosY($t5)

    lw $t4 tailleSnake
    mul $t5 $t4 4
    lw $t6 lastSnakePiece
    lw $t7 lastSnakePiece + 4
    sw $t6 snakePosX($t5)
    sw $t7 snakePosY($t5)
    addi $t4 $t4 1
    sw $t4 tailleSnake





    #jr $ra
lw $ra 0($sp)
addu $sp $sp 4   
jr $ra

############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################

conditionFinJeu:

lw $t1 snakePosX        #test si la position X du serpent est entre 0 est 15(la bordure de la grille
blt $t1 0 endGame       #si snakePosX inferieur à 0 saute vers endGame
bgt $t1 15 endGame      #si snakePosX superieur à 15 saute vers Endgame


lw $t2 snakePosY        #idem pour la position Y du serpent
blt $t2 0 endGame       
bgt $t2 15 endGame      

li $t8 0                #on vas  utliser $t8 comme conteur 
lw $a2 numObstacles     #stock la valeur de numObstacles dans le registre $a2

# parcourir chaque case du tableau des obstacles pour vérifier les coordonnées(X&Y) != tete (snakePosX&Y)

beq $a2 $zero cont2     #au debut du jeu, numObstacle=0 donc on continue sans verifier 
la $s1 obstaclesPosX    #stock l'adresse de la position X de l'obstacle dans le registre $s1
la $s2 obstaclesPosY    #stock l'adresse de la position X de l'obstacle dans le registre $s2
lw $s3 ($s1)			#stock la valeur de la position X de l'obstacle dans le registre $s3
lw $s4 ($s2)			##stock la valeur de la position X de l'obstacle dans le registre $s4


checkForObstacle:               #verifie si la tete du serpent a les memes coordoonées qu'un obstacle
    bne $t1 $s3 nextObstacle	#si les positions X du serpent et de l'obstacle ne sont pas egaux saute direct a nextObstacle
    bne $t2 $s4 nextObstacle	#si les positions Y du serpent et de l'obstacle ne sont pas egaux saute direct a nextObstacle
    j endGame                   #sinon endGame

nextObstacle:
    addi $s1 $s1 4      #on passe a la case suivante du tableau d'obstacles en rajoutant
    addi $s2 $s2 4      # 4 à $s1 et $s2 (les adresses de la case précédente)
    lw $s3 ($s1)        #stock les é nouvelles adresse dans $s3
    lw $s4 ($s2)        #et dans $s4
    addi $t8 $t8 1      #ajoute +1 au counteur
    bne $t8 $a2 checkForObstacle    #test si conteur = numObstacle (la fin du tableau d'obstacles) sinon on test avec l'obstacle suivant
    
li $t8 0                #conteur
lw $a2 tailleSnake
beq $a2 $zero cont2
la $s1 snakePosX + 4
la $s2 snakePosY + 4
lw $s3 ($s1)			
lw $s4 ($s2)	


checkForPieceOfSnake:
    bne $t1 $s3 nextPieceOfSnake	
    bne $t2 $s4 nextPieceOfSnake	
    j endGame

nextPieceOfSnake:
    addi $s1 $s1 4
    addi $s2 $s2 4
    lw $s3 ($s1)
    lw $s4 ($s2)
    addi $t8 $t8 1
    bne $t8 $a2 checkForPieceOfSnake	

cont2:
    li $v0 0
    jr $ra

endGame:
    li $v0 1
    jr $ra


############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation !»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:

la $a0 scoreMsg     #affiche le message de fin de jeu
li $v0 4
syscall

lw $a0 scoreJeu     #affiche le score a la fin du jeu
li $v0 1
syscall

#le message de fin de jeu change en fonction du score
beq $a0 0 printMsg0
ble $a0 5 printMsg1
ble $a0 10 printMsg2
ble $a0 20 printMsg3
ble $a0 35 printMsg4
ble $a0 999 printMsg5
bgt $a0 999 printMsg6

printMsg0:
    la $a0 scoreMsg0
    jal printMsg
    jr $ra

printMsg1:
    la $a0 scoreMsg1
    jal printMsg
    jr $ra
    
printMsg2:
    la $a0 scoreMsg2
    jal printMsg
    jr $ra

printMsg3:
    la $a0 scoreMsg3
    jal printMsg
    jr $ra

printMsg4:
    la $a0 scoreMsg4
    jal printMsg
    jr $ra

printMsg5:
    la $a0 scoreMsg5
    jal printMsg
    jr $ra

printMsg6:
    la $a0 scoreMsg6
    jal printMsg
    jr $ra

printMsg:
    li $v0 4
    syscall
# Fin.

jr $ra
