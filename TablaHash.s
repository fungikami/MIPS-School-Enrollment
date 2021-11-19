# TablaHash
#
# Estructura de datos que implementa una tabla de Hash.
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

        .text

# Función crear
# Crea una tabla de hash de tamaño    .
# Entrada:   $a0: Tamaño de la tabla.
# Salida:    $v0: Tabla de hash (negativo si no se pudo crear).
#          ($v0): Número de elementos.
#         4($v0): Número de buckets
#         8($v0): Cabeza de la tabla de hash.
#
# Planificación de registros:
# $s0: Tamaño de la tabla de hash
# $s1: Dirección de retorno
# $s2: Dirección de una lista de la tabla
TablaHash_crear:
    # Prólogo
    sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($s0)
    sw   $s1, -12($s0)
    sw   $s2, -16($s0)
    move $fp,     $sp
    addi $sp,     $sp, -20

    # Tamaño de la tabla de hash.
    move $s0, $a0

    # Reservo memoria para el numElem, numBuckets, cabeza de tabla
    li $a0, 12 
    li $v0, 9
    syscall

    bltz $v0, TablaHash_crear_fin 

    # Dirección de retorno
    move $s1, $v0

    # Inicializo numero de elementos
    sw $zero,  ($v0)
    sw $s0,   4($v0)
    
    # Reservo memoria para la tabla
    sll $a0, $s0, 2
    li  $v0,  9
    syscall

    bltz $v0, TablaHash_crear_fin 

    # Guardo dirección de la tabla en el retorno
    sw   $v0, 8($s1)
    move $s2, $v0

TablaHash_crear_loop:
    beqz $s0, TablaHash_crear_fin

    # Inicializo la tabla de hash con listas vacías
    jal Lista_crear

    # Verificar si no se creó la lista
    bltz $v0, TablaHash_crear_fin  

    # Guardo dirección de la lista en la tabla
    sw $v0, ($s2)

    addi $s2, $s2, 4
    addi $s0, $s0, -1

    b TablaHash_crear_loop

TablaHash_crear_fin:
    # Epílogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)

    jr $ra

# Función de hash
#   .
# Entrada: $a0: Tabla de Hash.
#          $a1: Clave (String).
#          
# Planificación de registros:
# $t0: acc
# $t1: Clave[i]
# $t2: Numero de buckets
TablaHash_hash:
    # Prólogo
    sw   $fp,    ($sp)
    move $fp,     $sp
    addi $sp,  $sp, -4

    # acc
    li $t0, $zero    

TablaHash_hash_loop:
    lb $t1, ($a1)

    beqz $t1, TablaHash_hash_loop_fin

    # acc += 31*acc + clave[i] 
    mult $t0, $t0, 31
    add  $t0, $t0, $t1

    addi $a1, $a1, 1

    b TablaHash_hash_loop

TablaHash_hash_loop_fin:
    # Calcula hash
    lw  $t2, 4($a0)         # numBuckets
    rem $t0,   $t0, $t2		# hi = modulo = acc % numBuckets

    multi $v0, $t0, 4       # modulo * 4

    # Epílogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra
    

# Función insertar
# Inserta un elemento con la clave y el valor dado en la tabla.
# Entrada: $a0: Tabla de Hash.
#          $a1: Clave del elemento a insertar.
#          $sp: Valor del elemento a insertar.
#
# Planificación de registros:
# 
TablaHash_insertar:
    # Prólogo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    move $fp,    $sp
    addi $sp,    $sp, -8

    # Funcion Hash
    jal TablaHash_hash

    # Guardar dir de la tabla
    move $s0, $a0

    # Insertar
    # $a0 = 4(dirTabla) + $v0
    # $a1 = $sp
    jal Lista_insertar

    # Verificar si se logró agregar (???)

    # Aumentar el número de elementos
    sw   $s1, ($s0)            
    addi $s1,  $s1, 1
    lw   $s1, ($s0) 

TablaHash_insertar_fin:
    # Epílogo
    move $v0,    $s0

    move $sp,    $fp
    lw   $fp,   ($sp)
    sw   $ra, -4($sp)

    jr $ra


# Función eliminar
# Elimina un elemento de la tabla dado la clave.
# Entrada: $a0: tabla.
#          $a1: clave a eliminar.
# Salida:  
# 
# Planificación de registros:
#
#
TablaHash_eliminar:
    # Prólogo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    move $fp,    $sp
    addi $sp,    $sp, -8

    # Funcion Hash
    jal TablaHash_hash

    # x = Buscar en la lista tabla[hash]

    # Verificamos si se encuentra

    # Eliminar x
    # $a0 = 4(dirTabla) + $v0
    # $a1 = x
    jal Lista_insertar
    
TablaHash_eliminar_fin:
    # Epílogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)

    jr $ra

# Función buscar
# Busca un elemento de la tabla dado la clave.
# Entrada: $a0: tabla.
#          $a1: clave a buscar.
# Salida:  
# 
# Planificación de registros:
# 
TablaHash_buscar:
    # Prólogo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    move $fp,    $sp
    addi $sp,    $sp, -8

    # Funcion Hash
    jal TablaHash_hash

    # Buscar en la lista tabla[hash]

TablaHash_buscar_fin:
    # Epílogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)

    jr $ra


# Función existe
# Verifica si una clave existe en la tabla.
# Entrada: $a0: tabla.
#          $a1: clave a verificar si existe.
# Salida:  
# 
# Planificación de registros:
# 
TablaHash_existe:
    # Prólogo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    move $fp,    $sp
    addi $sp,    $sp, -8

    jal TablaHash_hash

    # Buscar en tabla[hash] si la clave está en la lista

    # Epílogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)

    jr $ra