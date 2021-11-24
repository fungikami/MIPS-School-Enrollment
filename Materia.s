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

    # Inicializa la Materia.
    sw $s0    ($s1) # codigo
    sw $a1,  4($s1) # nombre
    sw $a2,  8($s1) # creditos
    sw $a3, 12($s1) # cupos

    lw $a0,  4($fp)
    sw $a0, 16($s1) # minCreditos
    sw $v0, 20($s1) # Lista de estudiantes 
    
    move $v0, $s1
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
    bltz $v0, Materia_agregarEstudiante_fin
    move $a1, $v0

    # Agrega el Par a la lista de estudiantes.
    move $a0,    $s0
    lw   $a0, 20($a0)
    la   $a2, comparador_pares
    jal Lista_insertarOrdenado

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

Materia_eliminarEstudiante_fin:
    # Epílogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra


# Función imprimirMateria
# Marca un estudiante de la lista de estudiantes de la materia 
# como eliminado.
# Entrada:   $a0: Materia.
#            $a1: Archivo.
# 
# Planificación de registros:
# $s0: Materia.
# $s1: Archivo
# $s2: Caracter actual del nombre de materia
Materia_imprimirMateria:
    # Prólogo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    sw   $s0, -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -16($sp)
    move $fp,    $sp
    addi $sp,    $sp, -20

    move $s0, $a0
    move $s1, $a1 

    # Imprime Materia.codigo
    li   $v0, 15       
    move $a0, $s1
    lw   $a1, ($s0)
    li   $a2, 7
    syscall
    
    # Imprime ' "'
    li   $v0, 15       
    move $a0, $s1
    la   $a1, espC
    li   $a2, 2
    syscall
    
    # Imprime Materia.nombre
    lw $s2, 4($s0)
    for_letra:
        lb   $a1, ($s2)
        beqz $a1, for_letra_fin

        li   $v0, 15       
        move $a0, $s1
        move $a1, $s2
        li   $a2, 1
        syscall

        add $s2, $s2, 1
        b for_letra

    for_letra_fin:

    # Imprime '" '
    li   $v0, 15       
    move $a0, $s1
    la   $a1, cEsp
    li   $a2, 2
    syscall

    # Imprime Materia.cupos
    lw   $a0, 12($s0)
    li   $a1, 3

    jal itoa
    move $a1, $v0
    move $a2, $v1

    move $a0, $s1
    li   $v0, 15 
    syscall

    # Imprime '\n'
    li   $v0, 15       
    move $a0, $s1
    la   $a1, newl
    li   $a2, 1     
    syscall

    # Imprime estudiantes
    lw   $a0, 20($s0)
    move $a1, $s1
    jal Materia_imprimirEstudiantes

    # Imprime '\n'
    li   $v0, 15       
    move $a0, $s1
    la   $a1, newl
    li   $a2, 1     
    syscall

Materia_imprimirMateria_fin:
    # Epílogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra, -4($sp)
    lw   $s0, -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -16($sp)

    jr $ra

# Función imprimirEstudiantes
# Marca un estudiante de la lista de estudiantes de la materia 
# como eliminado.
# Entrada:   $a0: Lista de Estudiantes.
#            $a1: Archivo.
# 
# Planificación de registros:
# $s0: Materia.
# $s1: Archivo
# $s2: Centinela de la lista
# $s3: Nodo de la lista
# $s4: Valor del nodo (Par)
# $s5: Estudiante
Materia_imprimirEstudiantes:
    # Prólogo
    sw   $fp,   ($sp)
    sw   $s0, -4($sp)
    sw   $s1, -8($sp)
    sw   $s2, -12($sp)
    sw   $s3, -16($sp)
    sw   $s4, -20($sp)
    sw   $s5, -24($sp)
    sw   $s6, -28($sp)
    move $fp,    $sp
    addi $sp,    $sp, -32

    move $s0, $a0   # Lista estudiantes
    move $s1, $a1   # Archivo

    lw $s2,  ($s0)  # Centinela de la lista
    lw $s3, 8($s2)  # Primer nodo de la lista

    for_imprimir_est:
        # while Nodo != centinela
        beq $s2, $s3, Materia_imprimirEstudiantes_fin

        lw $s4, 4($s3)  # Valor del nodo (Par)
        lw $s5,  ($s4)  # Estudiante

        # Imprime '   '
        li   $v0, 15       
        move $a0, $s1
        la   $a1, ident
        li   $a2, 3
        syscall

        # Imprime Estudiante.carnet
        li   $v0, 15       
        move $a0, $s1
        lw   $a1, ($s5)
        li   $a2, 8
        syscall

        #Imprime ' "'
        li   $v0, 15       
        move $a0, $s1
        la   $a1, espC
        li   $a2, 2
        syscall

        #Imprime Estudiante.nombre
        lw $s6, 4($s5)
        for_letra_est:
            lb   $a1, ($s6)
            beqz $a1, for_letra_est_fin

            li   $v0, 15       
            move $a0, $s1
            move $a1, $s6
            li   $a2, 1
            syscall

            add $s6, $s6, 1
            b for_letra_est

        for_letra_est_fin:

        # Imprime '" '
        li   $v0, 15       
        move $a0, $s1
        la   $a1, cEsp
        li   $a2, 2
        syscall

        # Imprimir operacion si es necesario
        # lw $s7, 4($s4)
        # beq 'S', $s7, for_imprimir_est_sig

        # # Imprime '('
        # li   $v0, 15       
        # move $a0, $s1
        # li   $a1, '('
        # li   $a2, 2
        # syscall

    for_imprimir_est_sig:
        # Imprime '\n'
        li   $v0, 15       
        move $a0, $s1
        la   $a1, newl
        li   $a2, 1     
        syscall

        # Actualizamos al Nodo.siguiente
        lw $s3, 8($s3) 
        
        b for_imprimir_est

Materia_imprimirEstudiantes_fin:
    # Epílogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $s0, -4($sp)
    lw   $s1, -8($sp)
    lw   $s2, -12($sp)
    lw   $s3, -16($sp)
    lw   $s4, -20($sp)
    lw   $s5, -24($sp)
    lw   $s6, -28($sp)

    jr $ra