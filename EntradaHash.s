# EntradaHash
#
# Estructura de datos que implementa una 
# entrada de la tabla de Hash.
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

        .text

# Función crear
# Crea una entrada de hash con la clave y el nodo dado.
# Entrada:   $a0: clave de la entrada de hash.
#            $a1: valor de la entrada de hash.
# Salida:    $v0: Entrada de Hash (negativo si no se pudo crear).
#          ($v0): Clave 
#         4($v0): Nodo
# 
# Planificación de registros:
# $s0: Clave de la entrada.
# $s1: Dirección de la entrada de hash
EntradaHash_crear:
    # Prólogo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    sw   $s1, -8($sp)
    move $fp,    $sp
    addi $sp,    $sp, -12

    # Guarda la clave
    move $s0, $a0

    # Reserva memoria para la clave y el nodo.
    li $a0, 8
    li $v0, 9
    syscall

    bltz $v0, EntradaHash_crear_fin

    # Guarda la dirección reservada
    move $s1, $v0

    # Crear nodo
    move $a0, $a1
    jal Nodo_crear

    # Inicializar entrada de hash
    sw $s0,  ($s1)
    sw $v0, 4($s1)

EntradaHash_crear_fin:
    # Epílogo
    move $v0, $s1

    move $sp,    $fp
    lw   $fp,   ($sp)
    sw   $ra, -4($sp)
    sw   $s1, -8($sp)

    jr $ra
