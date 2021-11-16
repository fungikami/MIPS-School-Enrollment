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
    li $a0, 12
    li $v0, 9
    syscall

    # Si no me dieron memoria
    bltz $v0, Lista_crear_salir

    # Inicializa la lista
    sw $zero,  ($v0)
    sw $zero, 4($v0)
    sw $zero, 8($v0)

Lista_crear_salir:
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

