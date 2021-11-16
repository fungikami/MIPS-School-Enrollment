# ListaEnlazada
#
# Estructura de datos que implementa una lista enlazada.
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

        .text

ListaEnlazada_crear:
    # Prologo
	sw $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    # Asigna memoria para la lista
    li $a0, 12
    li $v0, 9
    syscall

    # Inicializa la lista
    sw $zero,  ($v0)
    sw $zero, 4($v0)
    sw $zero, 8($v0)

    # Epílogo
    move $sp,  $fp
    lw $fp,   ($sp)

    # Retorna la dirección del nodo
    jr $ra