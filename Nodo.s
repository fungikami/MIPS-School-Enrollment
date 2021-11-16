# Nodo
#
# Estructura de datos que implementa un elemento
# de la lista.
# 
# anterior:  Dirección del nodo anterior.
# valor:     Valor del nodo.
# siguiente: Dirección del nodo siguiente.
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

        .text

# Función crear
# Crea un nodo con el valor dado.
# Entrada: Valor del nodo.
# Salida:  Dirección del nodo creado.
#
# Planificación de registros:
# $t0: Valor del nodo.
Nodo_crear:
    # Prólogo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    # Guarda el valor en la dirección de memoria del nodo.
    move $t0, $a0

    # Asigna memoria para el nodo.
    li $a0, 12
    li $v0, 9
    syscall

    bltz $v0, salir

    # Inicializa el nodo
    sw $zero,  ($v0)
    sw $t0,   4($v0)
    sw $zero, 8($v0)

    # Epílogo
<<<<<<< HEAD
    move $sp, $fp
=======
    move $sp,  $fp
>>>>>>> f022f1e18742a44526ab4cb570ee81ad3fb18270
    lw   $fp, ($sp)

    # Retorna la dirección del nodo
    jr $ra