# Par.s
#
# Estructura de datos que implementa un Par.
# 
# primero: primer elemento del par
# segundo: segundo elemento del par
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

        .text

# Función crear
# Crea un par con los elementos dados.
# Entrada:   $a0: primer elemento del par.
#            $a1: segundo elemento del par.
# Salida:    $v0: Par (negativo si no se pudo crear).
#          ($v0): primero 
#         4($v0): segundo
# 
# Planificación de registros:
# $t0: primero
Par_crear:
    # Prólogo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    # Guarda el valor de $a0 temporalmente.
    move $t0, $a0

    # Asigna memoria para el par.
    li $a0, 8
    li $v0, 9
    syscall

    bltz $v0, Par_crear_fin

    # Inicializa el par
    sw $t0,  ($v0)
    sw $a1, 4($v0)
    
Par_crear_fin:
    # Epílogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra