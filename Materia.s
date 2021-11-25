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
    la   $a2, comparador_carnet
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
# $t0: Lista de estudiantes de Materia
# $t1: Centinela de la Lista.
# $t2: Nodo de la Lista.
# $t3: Valor del nodo (Par).
# $t4: Estudiante del Par.
# $t5: Auxiliar.
Materia_eliminarEstudiante:
    # Prólogo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    lw $t0, 20($a0)  # Lista estudiantes de Materia
    lw $t1,   ($t0)  # Centinela de la lista
    lw $t2,  8($t1)  # Primer nodo de la lista

    for_est_mat:
        # while Nodo != centinela
        beq $t1, $t2, for_est_mat_fin

        lw $t3, 4($t2)      # Valor del nodo (Par)
        lw $t4,  ($t3)      # Estudiante del par

        # Si par.Estudiante == solicitud.Estudiante
        # modificamos la operacion a 'E'
        beq $t4, $a1, eliminar_operacion

        # Actualizamos al Nodo.siguiente
        lw $t2, 8($t2)
        b for_est_mat

        eliminar_operacion:
            li $t5, 69
            sb $t5, 4($t3)

    for_est_mat_fin:
        # Disminuye por uno el número de cupos.
        lw   $t5, 12($a0)
        addi $t5,    $t5, -1
        sw   $t5, 12($a0)

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
# $t0: Materia.
# $t1: Archivo
# $t2: Centinela de la lista
# $t3: Nodo de la lista
# $t4: Valor del nodo (Par)
# $t5: Estudiante
# $t6: Caracter del nombre del Estudiante
# $t7:
Materia_imprimirEstudiantes:
    # Prólogo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    move $t0, $a0   # Lista estudiantes
    move $t1, $a1   # Archivo

    lw $t2,  ($t0)  # Centinela de la lista
    lw $t3, 8($t2)  # Primer nodo de la lista

    for_imprimir_est:
        # while Nodo != centinela
        beq $t2, $t3, Materia_imprimirEstudiantes_fin

        lw $t4, 4($t3)  # Valor del nodo (Par)
        lw $t5,  ($t4)  # Estudiante

        # Imprime '   '
        li   $v0, 15       
        move $a0, $t1
        la   $a1, ident
        li   $a2, 3
        syscall

        # Imprime Estudiante.carnet
        li   $v0, 15       
        move $a0, $t1
        lw   $a1, ($t5)
        li   $a2, 8
        syscall

        #Imprime ' "'
        li   $v0, 15       
        move $a0, $t1
        la   $a1, espC
        li   $a2, 2
        syscall

        #Imprime Estudiante.nombre
        lw $t6, 4($t5)
        for_letra_est:
            lb   $a1, ($t6)
            beqz $a1, for_letra_est_fin

            li   $v0, 15       
            move $a0, $t1
            move $a1, $t6
            li   $a2, 1
            syscall

            add $t6, $t6, 1
            b for_letra_est

        for_letra_est_fin:

        # Imprime '" '
        li   $v0, 15       
        move $a0, $t1
        la   $a1, cEsp
        li   $a2, 2
        syscall

        # Imprimir operacion si es necesario
        lw $t7, 4($t4)
        li $t8, 83      # 'S'
        beq $t7, $t8, for_imprimir_est_sig

        # Imprime '('
        li   $v0, 15       
        move $a0, $t1
        la   $a1, parentIzq
        li   $a2, 1
        syscall

        # # Imprime operacion
        # li   $v0, 15       
        # move $a0, $t1
        # la $a1, 4($t4)
        # li   $a2, 8
        # syscall

        # # Imprime ')'
        # li   $v0, 15       
        # move $a0, $t1
        # la   $a1, parentDer
        # li   $a2, 2
        # syscall

    for_imprimir_est_sig:
        # Imprime '\n'
        li   $v0, 15       
        move $a0, $t1
        la   $a1, newl
        li   $a2, 1     
        syscall

        # Actualizamos al Nodo.siguiente
        lw $t3, 8($t3) 
        
        b for_imprimir_est

Materia_imprimirEstudiantes_fin:
    # Epílogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra