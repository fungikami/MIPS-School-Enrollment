# Nodo.s
#
# Estructura de datos que implementa un elemento
# de la lista.
# 
# anterior:  nodo anterior.
# valor:     valor del nodo
# siguiente: nodo siguiente.
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 25-nov-2021

        .data

        .text

# Funcion crear
# Crea un nodo con el valor dado.
# Entrada:   $a0: valor del nodo.
# Salida:    $v0: Nodo (negativo si no se pudo crear).
#          ($v0): anterior 
#         4($v0): valor
#         8($v0): siguiente
# 
# Planificacion de registros:
# $t0: Valor del nodo.
Nodo_crear:
    # Prologo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    # Guarda el valor de $a0 temporalmente.
    move $t0, $a0

    # Asigna memoria para el nodo.
    li $a0, 12
    li $v0, 9
    syscall

    bltz $v0, Nodo_crear_fin

    # Inicializa el nodo
    sw $zero,  ($v0)
    sw $t0,   4($v0)
    sw $zero, 8($v0)
    
Nodo_crear_fin:
    # Epilogo
    move $sp, $fp
    lw   $fp, ($sp)

    jr $ra