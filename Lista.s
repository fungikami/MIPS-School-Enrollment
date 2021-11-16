# Lista
#
# Estructura de datos que implementa una lista doblemente enlazada.
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

        .text

# Función crear
# Crea una lista doblemente enlazada.
# Entrada: .
# Salida:  Dirección de la lista enlazada creada.
#
# Planificación de registros:
# 
Lista_crear:
    # Prólogo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    sw   $s0, -8($sp)
    move $fp,    $sp
    addi $sp,    $sp, -12

    # Asigna memoria para la lista
    li $a0, 8
    li $v0, 9
    syscall

    # Si no me dieron memoria
    bltz $v0, Lista_crear_salir

    # Memoria asignada en t0
    move $s0, $v0

    # Crear centinela de la lista
    move $a0, $zero
    jal Nodo_crear

    # Inicializa la lista
    sw   $v0, ($s0)
    li 4($s0), 0

    move $v0, $s0
    
Lista_crear_salir:
    # Epílogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)
    lw   $s0, -8($sp)

    # Retorna la dirección del nodo
    jr $ra


# Función insertar
# Crea una lista enlazada.
# Entrada: .
# Salida:  Dirección de la lista enlazada creada.
#
# Planificación de registros:
# $s0 Dirección de la lista
# $s1 Valor del nodo
Lista_insertar:
    # Prólogo
    sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    move $fp,     $sp
    addi $sp,     $sp, -16

    # Guardar los argumentos
    move $s0, $a0

    # Crear nodo
    move $a0, $a1
    jal Nodo_crear

    # Actualizar cabeza y nodo
    



Lista_insertar_salir:
    # Epílogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)

    # Retorna la dirección del nodo
    jr $ra

# Función crear
# Crea una lista enlazada.
# Entrada: .
# Salida:  Dirección de la lista enlazada creada.
#
# Planificación de registros:
# 
Lista_eliminar:

