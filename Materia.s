# Materia.s
#
# Estructura de datos que implementa el TAD
# Materia.
# 
# codigo:      String con el codigo de la materia.
# nombre:      String con el nombre de la materia.
# creditos:    Entero con los creditos que vale la materia.
# cupos:       Entero con el los cupos restantes de la materia.
# minCreditos: Entero con el minimo de creditos aprobados
#              necesarios para inscribir la materia.
# estudiantes: Lista de Pares <Estudiante, Operacion> que 
#              solicitaron inscripcion a la materia.
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 25-nov-2021

        .data

        .text

# Funcion crear
# Crea un Materia con los parametros dados.
# Entrada:   $a0: codigo
#            $a1: nombre.
#            $a2: creditos.
#            $a3: cupos.
#         4($fp): minCreditos.
#         8($fp): estudiantes.
# Salida:    $v0: Materia (negativo si no se pudo crear).
#          ($v0): codigo.
#         4($v0): nombre.
#         8($v0): creditos.
#        12($v0): cupos.
#        16($v0): minCreditos.
#        20($v0): estudiantes.
#
# Planificacion de registros:
# $t0: carne del estudiante.
Materia_crear:
    # Prologo
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
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

# Funcion aumentarCupo
# Suma uno al numero de cupos de la materia.
# Entrada:   $a0: Materia.
#
# Planificacion de registros:
# $t0: Cupos de la materia.
Materia_aumentarCupo:
    # Prologo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    # Carga los cupos de la materia.
    lw   $t0, 12($a0)
    addi $t0, $t0,    1
    sw   $t0, 12($a0)

    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra


# Funcion disminuirCupo
# Resta uno al numero de cupos de la materia.
# Entrada:   $a0: Materia.
#
# Planificacion de registros:
# $t0: Cupos de la materia.
Materia_disminuirCupo:
    # Prologo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    # Carga los cupos de la materia.
    lw   $t0, 12($a0)
    addi $t0, $t0,    -1
    sw   $t0, 12($a0)

    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

# Funcion agregarEstudiante
# Agrega un estudiante a la lista de estudiantes de la materia.
# Entrada:   $a0: Materia.
#            $a1: Estudiante.
#            $a2: Operacion.
# 
# Planificacion de registros:
# $t0: Cupos de la materia.
Materia_agregarEstudiante:
    # Prologo
    sw   $fp, ($sp)
    move $fp, $sp
    addi $sp, $sp, -4