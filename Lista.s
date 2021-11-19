# Lista.s
#
# Estructura de datos que implementa una lista doblemente enlazada
# con centinela.
# 
# cabeza: nodo centinela
# tamaño: número de elementos de la lista
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

        .text

# Función crear
# Crea una lista circular doblemente enlazada vacía.
# Salida:    $v0: lista (negativo si no se pudo crear).
#          ($v0): cabeza
#         4($v0): tamaño
#
# Planificación de registros:
# $s0: dir. de la lista a retornar
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
    bltz $v0, Lista_crear_fin

    # Memoria asignada en $s0
    move $s0, $v0

    # Crear centinela de la lista
    move $a0, $zero
    jal  Nodo_crear

    # Si hubo error en la creación del nodo
    bltz $v0, Lista_crear_fin

    # La centinela se apunta a si misma
    sw $v0,  ($v0)
    sw $v0, 8($v0)

    # Inicializa la lista
    sw $v0,    ($s0) # nodo cabeza
    sw $zero, 4($s0) # tamaño 0

    # Retorna la dirección de la lista
    move $v0, $s0
    
Lista_crear_fin:
    # Epílogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)
    lw   $s0, -8($sp)

    jr $ra


# Función insertar
# Inserta un elemento con el valor dado en la lista.
# Entrada: $a0: lista.
#          $a1: valor del elemento a insertar.
#
# Planificación de registros:
# $s0: lista
# $t0: centinela de la lista
# $t1: centinela.anterior
# $t2: tamaño de la lista
Lista_insertar:
    # Prólogo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    sw   $s0, -8($sp)
    move $fp,    $sp
    addi $sp,    $sp, -12

    # Guardar la lista en $s0
    move $s0, $a0

    # Crear nodo x a insertar
    move $a0, $a1
    jal Nodo_crear

    # Si hubo error en la creación del nodo
    bltz $v0, Lista_crear_fin

    # Actualizar cabeza y x
    lw $t0,  ($s0)
    lw $t1,  ($t0)
    sw $t1,  ($v0) # x.anterior = centinela.anterior
    sw $t0, 8($v0) # x.siguiente = centinela
    sw $v0, 8($t1) # centinela.anterior.siguiente = x
    sw $v0,  ($t0) # centinela.anterior = x

    # Actualizar tamaño
    lw   $t2, 4($s0)
    addi $t2,   $t2, 1
    sw   $t2, 4($s0)

Lista_insertar_fin:
    # Epílogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)
    lw   $s0, -8($sp)

    jr $ra

# Función eliminar
# Elimina el nodo x dado de la lista.
# Entrada: $a0: lista.
#          $a1: nodo x a eliminar.
# Salida:  $v0: [0 si se pudo eliminar | 1 de otra manera]
# 
# Planificación de registros:
# $t0: centinela de la lista
# $t1: x.anterior
# $t2: x.siguiente
# $t3: tamaño de la lista
Lista_eliminar:
    # Prólogo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    # Cargar tamaño de la lista
    lw   $t3, 4($a0)

    li $v0, 0
    # Si la lista está vacía
    beqz $t3, Lista_eliminar_fin
    
    # Cargar centinela
    lw $t0, ($a0)

    # Cargar x.anterior y x.siguiente, respectivamente
    lw $t1,  ($a1)
    lw $t2, 8($a1)

    # Rearreglar apuntadores
    sw $t2, 8($t1) # x.anterior.siguiente = x.siguiente
    sw $t1,  ($t2) # x.siguiente.anterior = x.anterior

    # Actualizar tamaño
    addi $t3,   $t3, -1
    sw   $t3, 4($a0)

    # Retorna 1    
    li $v0, 1

Lista_eliminar_fin:
    # Epílogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra

# Función eliminarPrimero
# Elimina el primer nodo de la lista.
# Entrada: $a0: lista.
# Salida:  $v0: [0 si se pudo eliminar | 1 de otra manera]
Lista_eliminarPrimero:
    # Prólogo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    move $fp,    $sp
    addi $sp,    $sp, -8

    # Cargar centinela.siguiente
    lw $a1,  ($a0)
    lw $a1, 8($a1)

    jal Lista_eliminar

    # Epílogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)

    jr $ra

# Función eliminarUltimo
# Elimina el ultimo nodo de la lista.
# Entrada: $a0: lista.
# Salida:  $v0: [0 si se pudo eliminar | 1 de otra manera]
Lista_eliminarUltimo:
    # Prólogo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    move $fp,    $sp
    addi $sp,    $sp, -8

    # Cargar centinela.anterior
    lw $a1, ($a0)
    lw $a1, ($a1)

    jal Lista_eliminar

    # Epílogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)

    jr $ra

# Función primero.
# Obtiene el contenido del primer elemento de la lista.
# Entrada: $a0: lista.
# Salida:  $v0: valor del primer elemento de la lista.
# 
# Planificación de registros:
# $t0: tamaño de la lista
Lista_primero:
    # Prólogo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    li $v0, -1
    # Si la lista está vacía
    lw $t0, 4($a0)
    beqz $t0, Lista_primero_fin
    
    # Cargar centinela.siguiente
    lw $a0, ($a0)
    lw $v0, 8($a0)

    lw $v0, 4($v0)

Lista_primero_fin:
    # Epílogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra

# Función ultimo.
# Obtiene el contenido del último elemento de la lista.
# Entrada: $a0: lista.
# Salida:  $v0: valor del primer elemento de la lista.
# 
# Planificación de registros:
# $t0: tamaño de la lista
Lista_ultimo:
    # Prólogo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    li $v0, -1
    # Si la lista está vacía
    lw $t0, 4($a0)
    beqz $t0, Lista_primero_fin
    
    # Cargar centinela.anterior
    lw $a0, ($a0)
    lw $v0, ($a0)

    lw $v0, 4($v0)

Lista_ultimo_fin:
    # Epílogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra

.include "Nodo.s"