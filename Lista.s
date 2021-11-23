# Lista.s
#
# Estructura de datos que implementa una lista doblemente enlazada
# con centinela.
# 
# cabeza: nodo centinela
# tamanio: numero de elementos de la lista
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 25-nov-2021

        .data

        .text

# Funcion crear
# Crea una lista circular doblemente enlazada vacia.
# Salida:    $v0: lista (negativo si no se pudo crear).
#          ($v0): centinela
#         4($v0): tamanio
#
# Planificacion de registros:
# $t0: dir. de la lista a retornar
Lista_crear:
    # Prologo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -12

    # Asigna memoria para la lista
    li $a0, 8
    li $v0, 9
    syscall

    # Si no me dieron memoria
    bltz $v0, Lista_crear_fin

    # Memoria asignada en $t0
    move $t0, $v0

    # Reserva memoria para la centinela de la lista
    li $a0, 12
    li $v0, 9
    syscall

    # Si hubo error en la creacion del centinela
    bltz $v0, Lista_crear_fin

    # La centinela se apunta a si misma
    sw $v0,  ($v0)
    sw $v0, 8($v0)

    # Inicializa la lista
    sw $v0,    ($t0) # nodo cabeza
    sw $zero, 4($t0) # tamanio 0

    # Retorna la direccion de la lista
    move $v0, $t0
    
Lista_crear_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

# Funcion insertar
# Inserta un elemento con el valor dado en la lista.
# Entrada: $a0: lista.
#          $a1: valor del elemento a insertar.
# Salida: 
#
# Planificacion de registros:
# $t0: centinela de la lista
# $t1: centinela.anterior
# $t2: tamanio de la lista
# $t3: lista
Lista_insertar:
    # Prologo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    # Guardar la lista en $t3
    move $t3, $a0

    # Reserva memoria para crear el nodo
    li $a0, 12
    li $v0, 9
    syscall

    # Si hubo error en la creacion del nodo
    bltz $v0, Lista_insertar_fin

    # Inicializa el valor del nodo
    sw $a1, 4($v0)

    # Actualiza cabeza y nodo x creado
    lw $t0,  ($t3)
    lw $t1,  ($t0)
    sw $t1,  ($v0) # x.anterior = centinela.anterior
    sw $t0, 8($v0) # x.siguiente = centinela
    sw $v0, 8($t1) # centinela.anterior.siguiente = x
    sw $v0,  ($t0) # centinela.anterior = x

    # Actualiza tamanio de la lista
    lw   $t2, 4($t3)
    addi $t2,   $t2, 1
    sw   $t2, 4($t3)

Lista_insertar_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,   ($sp)

    jr $ra

# Funcion insertarOrdenado
# Inserta un elemento con el valor dado en la lista, manteniendo
# un orden indicado por la función.
# 
# Entrada: $a0: Lista
#          $a1: valor del elemento a insertar.
#          $a2: función de comparación.
#               (a, b -> bool: 0 si a a<b, 1 de otra forma)
# Salida: Ñ
#
# Planificacion de registros:
# $s0: centinela de la lista
# $s1: nodoAInsertar
# $s2: Lista
# $s3: nodoActual
# $s4: valor del nodo a insertar
# $s5: función de comparación
# $t0: tamanio de la lista
# $t1: nodoActual.siguiente
# $t2: nodoActual.anterior
Lista_insertarOrdenado:
    # Prologo
    sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -14($sp)
    sw   $s3, -16($sp)
    sw   $s4, -20($sp)
    sw   $s5, -20($sp)
    move $fp,    $sp
    addi $sp,    $sp, -28

    # Si la lista esta vacia se usa el procedimiento insertar
    lw   $t0, 4($a0)
    bnez $t0, Lista_insertarOrdenado_no_vacia

Lista_insertarOrdenado_usar_insertar:
    jal Lista_insertar
    b Lista_insertarOrdenado_fin

Lista_insertarOrdenado_no_vacia:
    # Guardar los argumentos
    move $s2, $a0
    move $s4, $a1
    move $s5, $a2

    # Reserva memoria para crear el nodo
    li $a0, 12
    li $v0, 9
    syscall

    # Si hubo error en la creacion del nodo
    bltz $v0, Lista_insertarOrdenado_fin

    # Guarda el nodo e inicializa su valor
    move $s1,   $v0
    sw   $a1, 4($s1)

    # Busca donde insertar el nodo
    lw $s0,  ($s2)  # Centinela de la lista
    lw $s3, 8($s0)  # Primer nodo de la lista

    Lista_insertarOrdenado_loop:
        # while Nodo != centinela
        beq $s0, $s3, Lista_insertarOrdenado_ultimo

        # Compara nodoAInsertar < nodoActual
        move $a0,   $s4 
        lw   $a1, 4($s3) 
        jalr $s5

        # Si nodoAInsertar < nodoActual
        beqz $v0, Lista_insertarOrdenado_loop_siguiente

        # Si nodoAInsertar >= nodoActual
        lw $t1, 8($s3) # nodoActual.siguiente

        sw $s1,  ($t1) # nodoActual.siguiente.anterior = nodoAInsertar
        sw $t1, 8($s1) # nodoAInsertar.siguiente = nodoActual.siguiente
        sw $s3,  ($s1) # nodoAInsertar.anterior = nodoActual
        lw $s1, 8($s3) # nodoActual.siguiente = nodoAInsertar

        # Actualiza tamanio de la lista
        lw   $t0, 4($s2)
        addi $t0,   $t0, 1
        sw   $t0, 4($s2)
        b    Lista_insertarOrdenado_fin

    Lista_insertarOrdenado_loop_siguiente:
        # Actualizamos al Nodo.siguiente
        lw $s3, 8($s3)
        b  Lista_insertarOrdenado_loop

Lista_insertarOrdenado_ultimo:
    move $a0, $s2
    move $a1, $s4
    b Lista_insertarOrdenado_usar_insertar

Lista_insertarOrdenado_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -14($sp)
    lw   $s3, -16($sp)
    lw   $s4, -20($sp)
    lw   $s5, -20($sp)

    jr $ra

# Funcion eliminar
# Elimina el nodo x dado de la lista.
# Entrada: $a0: lista.
#          $a1: nodo x a eliminar.
# Salida:  $v0: [0 si se pudo eliminar | 1 de otra manera]
# 
# Planificacion de registros:
# $t0: centinela de la lista
# $t1: x.anterior
# $t2: x.siguiente
# $t3: tamanio de la lista
Lista_eliminar:
    # Prologo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    # Cargar tamanio de la lista
    lw   $t3, 4($a0)

    li $v0, 0
    # Si la lista esta vacia
    beqz $t3, Lista_eliminar_fin
    
    # Cargar centinela
    lw $t0, ($a0)

    # Cargar x.anterior y x.siguiente, respectivamente
    lw $t1,  ($a1)
    lw $t2, 8($a1)

    # Rearreglar apuntadores
    sw $t2, 8($t1) # x.anterior.siguiente = x.siguiente
    sw $t1,  ($t2) # x.siguiente.anterior = x.anterior

    # Actualizar tamanio
    addi $t3,   $t3, -1
    sw   $t3, 4($a0)

    # Retorna 1    
    li $v0, 1

Lista_eliminar_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra

# Funcion eliminarPrimero
# Elimina el primer nodo de la lista.
# Entrada: $a0: lista.
# Salida:  $v0: [0 si se pudo eliminar | 1 de otra manera]
Lista_eliminarPrimero:
    # Prologo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    move $fp,    $sp
    addi $sp,    $sp, -8

    # Cargar centinela.siguiente
    lw $a1,  ($a0)
    lw $a1, 8($a1)

    jal Lista_eliminar

    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)

    jr $ra

# Funcion eliminarUltimo
# Elimina el ultimo nodo de la lista.
# Entrada: $a0: lista.
# Salida:  $v0: [0 si se pudo eliminar | 1 de otra manera]
Lista_eliminarUltimo:
    # Prologo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    move $fp,    $sp
    addi $sp,    $sp, -8

    # Cargar centinela.anterior
    lw $a1, ($a0)
    lw $a1, ($a1)

    jal Lista_eliminar

    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)

    jr $ra

# Funcion primero.
# Obtiene el contenido del primer elemento de la lista.
# Entrada: $a0: lista.
# Salida:  $v0: valor del primer elemento de la lista.
# 
# Planificacion de registros:
# $t0: tamanio de la lista
Lista_primero:
    # Prologo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    li $v0, -1
    # Si la lista esta vacia
    lw $t0, 4($a0)
    beqz $t0, Lista_primero_fin
    
    # Cargar centinela.siguiente
    lw $a0, ($a0)
    lw $v0, 8($a0)

    lw $v0, 4($v0)

Lista_primero_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra

# Funcion ultimo.
# Obtiene el contenido del ultimo elemento de la lista.
# Entrada: $a0: lista.
# Salida:  $v0: valor del primer elemento de la lista.
# 
# Planificacion de registros:
# $t0: tamanio de la lista
Lista_ultimo:
    # Prologo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    li $v0, -1
    # Si la lista esta vacia
    lw $t0, 4($a0)
    beqz $t0, Lista_primero_fin
    
    # Cargar centinela.anterior
    lw $a0, ($a0)
    lw $v0, ($a0)

    lw $v0, 4($v0)

Lista_ultimo_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra
