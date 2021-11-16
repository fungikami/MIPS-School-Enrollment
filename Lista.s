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
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    # Asigna memoria para la lista
    li $a0, 8
    li $v0, 9
    syscall

    # Si no me dieron memoria
    bltz $v0, Lista_crear_salir

    # Crear centinela de la lista
    move $a0, $zero
    jal Nodo_crear
    move $t0, $v0

    # Inicializa la lista
    sw   $t0, ($v0)
    li 4($v0), 0

Lista_crear_salir:
    # Epílogo
    move $sp,  $fp
    lw   $fp, ($sp)

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

