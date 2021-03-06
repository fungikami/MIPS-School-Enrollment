# TablaHash
#
# Estructura de datos que implementa una tabla de Hash con 
# claves representadas como cadenas de caracteres y valores
# de tipo generico. Solamente soporta la operacion de agregar.
# De tamaño estatico.
# 
# numElems: Numero de elementos en la tabla de Hash
# numBuckets: Numero de buckets
# tabla: Cabeza del arreglo que contiene la tabla de Hash.
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 25-nov-2021

        .data

        .text

# Funcion crear.
# Crea una tabla de hash dado el tamanio.
# Entrada:   $a0: Tamanio de la tabla.
# Salida:    $v0: Tabla de hash (negativo si no se pudo crear).
#          ($v0): numero de elementos.
#         4($v0): numero de buckets.
#         8($v0): tabla.
#
# Planificacion de registros:
# $s0: Tamanio de la tabla de hash
# $s1: Direccion de retorno
# $s2: Direccion de una lista de la tabla
TablaHash_crear:
    # Prologo
    sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -16($sp)
    move $fp,     $sp
    addi $sp,     $sp, -20

    # Tamanio de la tabla de hash.
    move $s0, $a0

    # Reservo memoria para el numElem, numBuckets, cabeza de tabla
    li $a0, 12 
    li $v0, 9
    syscall

    bltz $v0, TablaHash_crear_fin 

    # Direccion de retorno
    move $s1, $v0

    # Inicializo numero de elementos
    sw $zero,  ($v0)
    sw $s0,   4($v0)
    
    # Reservo memoria para la tabla
    sll $a0, $s0, 2
    li  $v0,  9
    syscall

    bltz $v0, TablaHash_crear_fin 

    # Guardo direccion de la tabla en el retorno
    sw   $v0, 8($s1)
    move $s2,   $v0

    TablaHash_crear_loop:
        beqz $s0, TablaHash_crear_fin

        # Inicializo la tabla de hash con listas vacias
        jal Lista_crear

        # Verificar si no se creo la lista
        bltz $v0, TablaHash_crear_fin  

        # Guardo direccion de la lista en la tabla
        sw $v0, ($s2)

        addi $s2, $s2, 4
        addi $s0, $s0, -1

        b TablaHash_crear_loop

TablaHash_crear_fin:
    # Epilogo
    move $v0, $s1
    
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -16($sp)

    jr $ra

# Funcion de hash
# Implementacion de la funcion de hash para String
# basada en la funcion de hash de Java.
# Fuente:
# https://cseweb.ucsd.edu/~kube/cls/100/Lectures/lec16/lec16-15.html
# Entrada: $a0: TablaHash.
#          $a1: Clave (String).
#          
# Planificacion de registros:
# $t0: acc.
# $t1: Clave[i].
# $t2: Numero de buckets.
TablaHash_hash:
    # Prologo
    sw   $fp,    ($sp)
    move $fp,     $sp
    addi $sp,     $sp, -4

    # acc
    move $t0, $zero    

    TablaHash_hash_loop:
        lb $t1, ($a1)

        beqz $t1, TablaHash_hash_loop_fin

        mul $t0, $t0, 31       # acc *= 31
        add $t0, $t0, $t1      # acc += clave[i] 

        addi $a1, $a1, 1

        b TablaHash_hash_loop

    TablaHash_hash_loop_fin:
        # Calcula hash
        mul  $t0,   $t0, 31    # acc *= 31
        abs  $t0,   $t0        # acc = |acc|
        lw   $t2, 4($a0)       # numBuckets
        div  $t0,   $t2		   # acc %= numBuckets
        mfhi $t0

        # Retorna acc * 4
        mul $v0, $t0, 4        # acc *= 4

        # Epilogo
        move $sp,  $fp
        lw   $fp, ($sp)

        jr $ra
    

# Funcion insertar.
# Inserta un elemento con la clave y el valor dado en la tabla.
# Entrada: $a0: TablaHash.
#          $a1: Clave del elemento a insertar.
#          $a2: Valor del elemento a insertar.
# Salida:  $v0: [1 si se pudo eliminar | negativo de otra manera]
#
# Planificacion de registros:
# $s0: TablaHash.
# $s1: Clave.
# $s2: entrada de hash.
# $t0: Numero de elementos de la tabla.
TablaHash_insertar:
    # Prologo
    sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -16($sp)
    move $fp,     $sp
    addi $sp,     $sp, -20

    # Guarda TablaHash
    move $s0, $a0

    # Reserva memoria para crear entrada de hash
    li $a0, 8
    li $v0, 9
    syscall

    bltz $v0, TablaHash_insertar_fin

    # Inicializa entrada de hash
    sw $a1,  ($v0)  # Clave
    sw $a2, 4($v0)  # Valor

    # Guarda entrada de hash
    move $s2, $v0

    # Calcula la funcion de hash
    move $a0, $s0
    jal  TablaHash_hash

    # Busca la lista a insertar
    lw  $a0, 8($s0)
    add $a0,   $a0, $v0
    lw  $a0,  ($a0)

    # Inserta en la lista
    move $a1, $s2
    jal Lista_insertar

    # Aumenta el numero de elementos de la tabla
    sw   $t0, ($s0)            
    addi $t0,  $t0, 1
    lw   $t0, ($s0) 

    # Si se logro insertar, retorna 1
    li $v0, 1

TablaHash_insertar_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -16($sp)

    jr $ra


# Funcion obtenerValor.
# Obtiene el valor de un elemento de la tabla dado la clave.
# Entrada: $a0: TablaHash.
#          $a1: clave a obtener valor.
# Salida:  $v0: valor de entrada de hash.
#          [0 si no encontro el valor].
# Planificacion de registros:
# $s0: TablaHash.
# $s1: Clave a buscar.
# $s2: nodo de Lista.
# $s3: centinela de Lista.
# $t0: Lista.
# $t1: valor de Nodo.
TablaHash_obtenerValor:
    # Prologo
    sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -16($sp)
    sw   $s3, -20($sp)
    move $fp,     $sp
    addi $sp,     $sp, -24
    
    move $s0, $a0
    move $s1, $a1

    # Calcula la funcion de hash
    jal TablaHash_hash
    
    # Busca la lista a obtener valor
    lw  $t0, 8($s0)   
    add $t0,   $t0, $v0    
    lw  $t0,  ($t0)  

    lw $s3,  ($t0)      # Centinela de la lista
    lw $s2, 8($s3)      # Primer nodo de la lista

    TablaHash_obtenerValor_loop:
        # Mientras Nodo != centinela
        beq $s2, $s3, TablaHash_obtenerValor_loop_fin

        lw   $t1, 4($s2)  # Valor del nodo
        lw   $a0,  ($t1)  # Clave del nodo
        move $a1,   $s1   # Clave proporcionada a la funcion

        # Mientras Nodo.clave != clave
        jal TablaHash_compararStrings
        beqz $v0, TablaHash_obtenerValor_loop_fin
        
        # Actualizamos al Nodo.siguiente
        lw $s2, 8($s2) 
        
        b TablaHash_obtenerValor_loop

TablaHash_obtenerValor_loop_fin:
    lw $t1, 4($s2) # Valor del nodo

    # Si no encontro el valor retorna 0
    beqz $t1, TablaHash_obtenerValor_fin 

    # Retorna valor de la entrada de hash
    lw $v0, 4($t1)

TablaHash_obtenerValor_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -16($sp)
    lw   $s3, -20($sp)

    jr $ra

# Funcion compararStrings.
# Evalua la igualdad de dos strings dadas.
# Entrada: $a0: clave de un nodo.
#          $a1: clave a comparar.
# Salida:  $v0: 0 si son iguales.
#              -1 si no son iguales.
# 
# Planificacion de registros:
# $t0: caracter actual 
# $t1: caracter actual a comparar
TablaHash_compararStrings:
    # Prologo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    move $v0, $zero

    TablaHash_compararStrings_loop:
        lb $t0, ($a0)
        lb $t1, ($a1)

        bne  $t0, $t1, TablaHash_compararStrings_retornar_falso
        beqz $t1, TablaHash_compararStrings_fin

        add $a0, $a0, 1
        add $a1, $a1, 1

        j TablaHash_compararStrings_loop

TablaHash_compararStrings_retornar_falso:
    add $v0, $v0, -1

TablaHash_compararStrings_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,   ($sp)

    jr $ra