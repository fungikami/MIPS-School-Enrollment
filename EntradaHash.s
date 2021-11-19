# EntradaHash
#
# Estructura de datos que implementa una 
# entrada de la tabla de Hash.
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 25-nov-2021

        .data

        .text

# Funcion crear
# Crea una entrada de hash con la clave y el nodo dado.
# Entrada:   $a0: Clave de la entrada de hash.
#            $a1: Valor de la entrada de hash.
# Salida:    $v0: Entrada de Hash (negativo si no se pudo crear).
#          ($v0): Clave 
#         4($v0): Valor
# 
# Planificacion de registros:
# $t0: Clave de la entrada.
EntradaHash_crear:
    # Prologo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    # Guarda la clave
    move $t0, $a0

    # Reserva memoria para la clave y el valor.
    li $a0, 8
    li $v0, 9
    syscall

    bltz $v0, EntradaHash_crear_fin

    # Inicializar entrada de hash
    sw $t0,  ($v0)
    sw $a1, 4($v0)

EntradaHash_crear_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,   ($sp)

    jr $ra
