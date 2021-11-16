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
    move $fp,    $sp
    addi $sp,    $sp, -8

    # Asigna memoria para la lista
    li $a0, 8
    li $v0, 9
    syscall

    # Si no me dieron memoria
    bltz $v0, Lista_crear_salir

    # Memoria asignada en t0
    move $t0, $v0

    # Crear centinela de la lista
    move $a0, $zero
    jal Nodo_crear
    move $t1, $v0

    # Inicializa la lista
    sw   $t1, ($t0)
    li 4($t0), 0

    move $v0, $t0
    
Lista_crear_salir:
    # Epílogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)

    # Retorna la dirección del nodo
    jr $ra


# Función insertar
# Crea una lista enlazada.
# Entrada: .
# Salida:  Dirección de la lista enlazada creada.
#
# Planificación de registros:
# 
Lista_insertar:
    

Lista_insertar_salir:
    # Epílogo
    move $sp,  $fp
    lw   $fp, ($sp)

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

