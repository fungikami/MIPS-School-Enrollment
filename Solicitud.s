# Solicitud.s
#
# Estructura de datos que implementa el TAD
# Solicutud.
# 
# estudiante: Estudiante que hace la solicitud.
# materia:    Materia que solicita.
# operacion:  Operacion que se desea realizar.
#
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

        .text

# Función crear
# Crea una solicitud con los parámetros dados.
# Entrada:   $a0: estudiante.
#            $a1: materia.
# Salida:    $v0: Estudiante (negativo si no se pudo crear).
#          ($v0): estudiante.
#         4($v0): materia.
#
# Planificación de registros:
# $t0: estudiante.
Solicitud_crear:
    # Prólogo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    # Guarda el carné.
    move $t0, $a0

    # Asigna memoria para el Estudiante.
    li $a0, 8
    li $v0, 9
    syscall

    bltz $v0, Solicitud_crear_fin

    # Inicializa la solicitud.
    sw $t0    ($v0)
    sw $a1,  4($v0)
    
Solicitud_crear_fin:
    # Epílogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra