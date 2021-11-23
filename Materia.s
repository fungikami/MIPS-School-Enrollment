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
#            $a2: credito
#            $a3: cupos.
#         4($fp): minCreditos.
# Salida:    $v0: Materia (negativo si no se pudo crear).
#          ($v0): codigo.
#         4($v0): nombre.
#         8($v0): creditos.
#        12($v0): cupos.
#        16($v0): minCreditos.
#        20($v0): estudiantes.
#
# Planificacion de registros:
# $s0: carne del estudiante.
# $s1: Direccion de la materia
Materia_crear:
    # Prologo
	sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
	move $fp,     $sp
	addi $sp,     $sp, -16

    # Guarda el valor de $a0
    move $s0, $a0

    # Asigna memoria para la Materia.
    li $a0, 24
    li $v0, 9
    syscall

    bltz $v0, Materia_crear_fin
    move $s1, $v0
    
    # Crea la lista vacía de estudiantes
    jal Lista_crear
    bltz $v0, Materia_crear_fin
    move $s1, $v0

    # Inicializa la Materia.
    sw $s0    ($s1) # codigo
    sw $a1,  4($s1) # nombre
    sw $a2,  8($s1) # creditos
    sw $a3, 12($s1) # cupos

    lw $a0,  4($fp)
    sw $a0, 16($s1) # minCreditos
    sw $v0, 20($s1) # Lista de estudiantes 

Materia_crear_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)

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
#            $a2: ASCII caracter con la operación.
# 
# Planificación de registros:
# $s0: Materia.
# $t0: #Cupos de la materia
Materia_agregarEstudiante:
    # Prólogo
    sw   $fp,   ($sp)
    move $fp,    $sp
    sw   $ra, -4($sp)
    sw   $s0, -8($sp)
    addi $sp,    $sp, -12

    # Guarda la materia
    move $s0, $a0

    # Crea el Par(Estudiante, Op.)
    move $a0, $a1 # Estudiante
    move $a1, $a2 # Op.
    jal  Par_crear

    # Verifica la creación del Par.
    bgtz $v0, Materia_agregarEstudiante_fin
    move $a1, $v0

    # Agrega el Par a la lista de estudiantes.
    move $a0,    $s0
    lw   $a0, 20($a0)
    jal Lista_insertar

    # Disminuye por uno el número de cupos.
    lw   $t0, 12($s0)
    addi $t0,    $t0, -1
    sw   $t0, 12($s0)

Materia_agregarEstudiante_fin:
    # Epílogo
    move $sp,  $fp
    lw   $fp, ($sp)
    lw   $ra, -4($sp)
    lw   $s0, -8($sp)

    jr $ra

# Función eliminarEstudiante
# Marca un estudiante de la lista de estudiantes de la materia 
# como eliminado.
# Entrada:   $a0: Materia.
#            $a1: Estudiante.
# 
# Planificación de registros:
# $s0: Materia.
Materia_eliminarEstudiante:
    # Prólogo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    # for par in Materia.estudiantes
    #   if par.primero = Estudiante
    #       par.segundo = 'E'

    # Aumenta por uno el número de cupos.
    lw   $t0, 12($s0)
    addi $t0,    $t0, -1
    sw   $t0, 12($s0)