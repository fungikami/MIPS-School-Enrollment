# Solicitud.s
#
# Estructura de datos que implementa el TAD
# Solicitud.
# 
# estudiante: Estudiante que hace la solicitud.
# materia:    Materia que solicita.
# operacion:  Operacion que se desea realizar.
#
# Autores: Ka Fung 18-10492 & Christopher Gomez 18-10892
# Fecha: 25-nov-2021

        .data

        .text

# Funcion crear.
# Crea una solicitud con los parametros dados.
# Entrada:   $a0: Estudiante.
#            $a1: Materia.
#            $a2: operacion.
# Salida:    $v0: Solicitud (negativo si no se pudo crear).
#          ($v0): Estudiante.
#         4($v0): Materia.
#         8($v0): operacion.
#
# Planificacion de registros:
# $t0: Estudiante.
Solicitud_crear:
    # Prologo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    # Guarda el Estudiante.
    move $t0, $a0

    # Asigna memoria para la Solicitud.
    li $a0, 9
    li $v0, 9
    syscall

    bltz $v0, Solicitud_crear_fin

    # Inicializa la solicitud.
    sw $t0   ($v0)
    sw $a1, 4($v0)
    sb $a2, 8($v0)

Solicitud_crear_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra