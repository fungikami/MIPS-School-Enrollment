# TablaHash
#
# Estructura de datos que implementa una tabla de Hash.
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

        .text

# Función crear
# Crea una tabla de hash de tamanio    .
# Salida:    $v0: Tabla de hash (negativo si no se pudo crear).
#          ($v0): Número de elementos.
#         4($v0): Cabeza de la tabla de hash.
#
# Planificación de registros:
# $s0: Tamanio de la tabla de hash
#
TablaHash_crear:
    # Prólogo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    # Tamanio de la tabla de hash.
    li $s0, 20

    # Reservo memoria para el número de elem y tabla
    li $a0, 84  # 4 + 4*20
    li $v0, 9
    syscall

    bltz $v0, TablaHash_crear_fin 

    # Inicializo numero de elementos
    sw $zero, ($v0)
    la $s2,    $v0

TablaHash_crear_loop:
    beqz $s0, TablaHash_crear_fin

    # Inicializo la tabla de hash con zero o con listas (?)
    sw $zero, ($s2)

    addi $s2, $s2, 4
    addi $s0, $s0, -1

    b TablaHash_crear_loop

TablaHash_crear_fin:
    # Epílogo
    move $sp,    $fp
    lw   $fp,   ($sp)

    jr $ra

# Función de hash
#   .
# Entrada: $a0: Tabla de Hash.
#          $a1: Clave.
#
# Planificación de registros:
# 
TablaHash_funcion:
    # Prólogo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    # Calcula hash
    lw   $s0, ($a0)
	div  $a1,  $s0		# hi = modulo = clave % tamañoTabla
    mfhi $s1            # hi = modulo

    multi $v0, $s1, 4   # modulo * 4

    # Epílogo
    move $sp,    $fp
    lw   $fp,   ($sp)

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

    # Verifica si la clave ya existe (si $v0 = 0 ya existe)
    # jal TablaHash_existe
    # beqz $v0 TablaHash_insertar_fin

    # Funcion Hash
    jal TablaHash_funcion

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
    jal TablaHash_funcion

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
    jal TablaHash_funcion

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

    jal TablaHash_funcion

    # Buscar en tabla[hash] si la clave está en la lista

    # Epílogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)

    jr $ra