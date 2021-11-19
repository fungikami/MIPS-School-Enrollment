# Materia.s
#
# Estructura de datos que implementa el TAD
# Materia.
# 
# código:      String con el código de la materia.
# nombre:      String con el nombre de la materia.
# créditos:    Entero con los créditos que vale la materia.
# cupos:       Entero con el los cupos restantes de la materia.
# minCreditos: Entero con el mínimo de creditos aprobados
#              necesarios para inscribir la materia.
# estudiantes: Lista de Pares <Estudiante, Operacion> que 
#              solicitaron inscripción a la materia.
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

        .text

# Función crear
# Crea un Materia con los parámetros dados.
# Entrada:   $a0: código
#            $a1: nombre.
#            $a2: creditos.
#            $a3: cupos.
#         4($fp): minCreditos.
#         8($fp): estudiantes.
# Salida:    $v0: Materia (negativo si no se pudo crear).
#          ($v0): código.
#         4($v0): nombre.
#         8($v0): creditos.
#        12($v0): cupos.
#        16($v0): minCreditos.
#        20($v0): estudiantes.
#
# Planificación de registros:
# $t0: carné del estudiante.
Estudiante_crear:
    # Prólogo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    # Guarda el valor de $a0 temporalmente.
    move $t0, $a0

    # Asigna memoria para el Materia.
    li $a0, 24
    li $v0, 9
    syscall

    bltz $v0, Materia_crear_fin

    # Inicializa la Materia.
    sw $t0    ($v0)
    sw $a1,  4($v0)
    sw $a2,  8($v0)
    sw $a3, 12($v0)
    # Ver como cargar otros dos
    sw $a0, 16($v0)
    sw $a1, 20($v0)

Materia_crear_fin:
    # Epílogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra