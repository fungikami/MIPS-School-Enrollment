# Proyecto 1
# 
# Autores: Ka Fung & Christopher Gemez
# Fecha: 25-nov-2021

        .data

arcEst:     .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-Estudiantes.txt"
arcMat:     .asciiz "/home/chus/Downloads/Orga/proyecto1/ejemplo-Materias.txt"
arcIns:     .asciiz "ejemplo-SolInscripcion.txt"
arcCor:     .asciiz "ejemplo-SolCorreccion.txt"
arcTen:     .asciiz "ejemplo-InsTentativa.txt"
arcDef:     .asciiz "ejemplo-InsDefinitiva.txt"

tamanioTablaHash:   .word 100

buscarEst: .asciiz "15-47895" # Indice de 4.2827

buffer:     .space 1048576 # 1Mb
bufferNull: .ascii "\0"
error1:     .asciiz "Ha ocurrido un error."
newl:       .asciiz "\n"

        .text
main:

    # Planificacion de registros:
    # $s0: Archivo (identificador)
    # $s1: Direccion del buffer
    # $s2: TablaHash Estudiantes
    # $s3: Direccion carnet
    # $s4: Direccion nombre
    # $s5: Direccion indice
    # $s6: Direccion credito

    # ------------ ESTUDIANTES ---------------

    # Abrir archivo
    li $v0, 13
    la $a0, arcEst
    li $a1, 0 # 0 para leer
    syscall

    bltz $v0, error
    move $a0, $v0

    # Leer archivo ($v0=14) ($a0=$v0)
    li $v0, 14
    la $a1, buffer
    li $a2, 1024
    syscall

    bltz $v0, error

    # Cerrar el archivo
    li $v0, 16
    syscall

    # <TablaHash Estudiantes>.crear()
    lw  $a0, tamanioTablaHash
    jal TablaHash_crear

    move $s2, $v0

    # Direccion de los datos
    la $s1, buffer

    for_leer_estudiantes:

        # Guarda el carnet
        move $a0, $s1
        li   $a1, 8
        li   $a2, 1
        jal guardar_dato

        blez $v0, fin_leer_estudiantes
        move $s3, $v0

        add $v1, $v1, 1 # Saltar comilla

        # Guarda el nombre
        move $a0, $v1
        li   $a1, 20
        li   $a2, 1
        jal guardar_dato

        blez $v0, fin_leer_estudiantes
        move $s4, $v0

        add $v1, $v1, 1 # Saltar comilla

        # Guardar el indice
        move $a0, $v1
        li   $a1, 6
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_estudiantes
        move $s5, $v0

        # Guardar creditos aprobados
        move $a0, $v1
        li   $a1, 3
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_estudiantes
        move $s6, $v0

        move $s1, $v1
        add $s1, $s1, 1 # Salta \n


        # # Reservar la memoria para el carnet
        # li $v0, 9
        # li $a0, 9
        # syscall


        # bltz $v0, error
        # move $t1, $v0

        # # Guarda el carnet
        # for_carnet:
        #     lb $t2, ($s1)
            
        #     # Si es una comilla, termina el carnet
        #     beq $t2, 34 for_carnet_fin
        #     beqz $t2, fin_leer_estudiantes # Si es un null terminator termina de leer
            
        #     sb $t2, ($v0)

        #     add $v0, $v0, 1
        #     add $s1, $s1, 1

        #     b for_carnet
        
        # for_carnet_fin:
        #     sb $zero, ($v0)
        #     add $s1, $s1, 1 # Saltar comilla
        
        # # Reservar la memoria para el nombre
        # li $v0, 9
        # li $a0, 21
        # syscall
        
        # bltz $v0, error
        # move $t3, $v0
        
        # # Guarda el nombre
        # for_nombre:
        #     lb $t2, ($s1)

        #     # Si es una comilla, termina el nombre
        #     beq $t2, 34 for_nombre_fin

        #     sb $t2, ($v0)
            
        #     add $v0, $v0, 1
        #     add $s1, $s1, 1

        #     b for_nombre

        # for_nombre_fin:
        #     sb $zero, ($v0)
        #     add $s1, $s1, 1 # Saltar comilla

        # # Reservar la memoria para el indice
        # li $v0, 9
        # li $a0, 7
        # syscall

        # bltz $v0, error
        # move $t4, $v0

        # # Guarda el indice
        # li $t6, 6
        # for_indice:
        #     lb $t2, ($s1)
        #     sb $t2, ($v0)

        #     add $v0, $v0,  1
        #     add $s1, $s1,  1
        #     add $t6, $t6, -1

        #     bnez $t6, for_indice

        # for_indice_fin:
        #     sb $zero, ($v0)

        # # Reservar la memoria para los creditos
        # li $v0, 9
        # li $a0, 4
        # syscall

        # bltz $v0, error
        # move $t5, $v0

        # # Guarda los creditos
        # li $t6, 3
        # for_creditos:
        #     lb $t2, ($s1)
        #     sb $t2, ($v0)

        #     add $v0, $v0,  1
        #     add $s1, $s1,  1
        #     add $t6, $t6, -1

        #     bnez $t6, for_creditos

        # for_creditos_fin:
        #     sb $zero, ($v0)
        
        # add $s1, $s1, 1 # Salta \n


        # li $v0, 4
        # move $a0, $t1
        # syscall

        # li $v0, 4
        # la $a0, newl
        # syscall

        # li $v0, 4
        # move $a0, $t3
        # syscall

        # li $v0, 4
        # la $a0, newl
        # syscall

        # li $v0, 4
        # move $a0, $t4
        # syscall

        # li $v0, 4
        # la $a0, newl
        # syscall

        # li $v0, 4
        # move $a0, $t5
        # syscall

        # li $v0, 4
        # la $a0, newl
        # syscall
        

        # Crear Estudiante
        move $a0, $s3
        move $s7, $s3  # Borrar
        
        move $a1, $s4
        move $a2, $s5
        move $a3, $s6
        jal Estudiante_crear

        move $a0,  $s2  # Tabla
        lw   $a1, ($v0) # Clave
        move $a2,  $v0  # Valor
        
        # Guardar el estudiante en la tabla
        jal TablaHash_insertar

        # Si no se logro insertar
        bltz $v0, fin_leer_estudiantes 
        
        lb $t2, ($s1)

        bnez $t2, for_leer_estudiantes      # Nulo
        bne  $t2, 10, for_leer_estudiantes  # Salto de linea
        bne  $t2, 11, for_leer_estudiantes  # Tab vertical
        bne  $t2, 32, for_leer_estudiantes  # Espacio en blanco

    fin_leer_estudiantes:
        move $a0, $s2
        la $a1, buscarEst
        jal TablaHash_obtenerValor
        
        lw $a0, 8($v0)
        li $v0, 4
        syscall

    # ------------ MATERIAS ---------------

    # Por cada linea:
        # syscall 9 (24 bytes) [verificar]
        # Crear materia
        # 7 chars:
            # Guardar cedigo
        # do while != “”:
            # Guardar nombre
        # 1 chars:
            # Guardar creditos
        # 3 chars:
            # Guardar cupos
        # 3 chars:
            # Guardar minimoCreditos
        # Crear Materia(cedigo, nombre, creditos, cupos, minimoCreditos, <Lista Estudiantes>.crear())
        # <TablaHash Materias>.insertar(cedigo, Materia)

    # # Abrir archivo
    # li $v0, 13
    # la $a0, arcMat
    # li $a1, 0 # 0 para leer
    # syscall

    # bltz $v0, error
    # move $a0, $v0

    # # Leer archivo ($v0=14) ($a0=$v0)
    # li $v0, 14
    # la $a1, buffer
    # li $a2, 1024
    # syscall

    # bltz $v0, error

    # # Cerrar el archivo
    # li $v0, 16
    # syscall

    # # <TablaHash Materias>.crear()
    # li $t7, 101
    # move $a0, $t7
    # jal TablaHash_crear

    # move $t7, $v0

    # la $s1, buffer

    # for_leer_materias:
    #     # Reservar la memoria para el codigo
    #     li $v0, 9
    #     li $a0, 8
    #     syscall

    #     bltz $v0, error
    #     move $t1, $v0

    #     # Guarda el codigo
    #     for_codigo:
    #         lb $t2, ($s1)
            
    #         # Si es una comilla, termina el codigo
    #         beq $t2, 34 for_codigo_fin
    #         beqz $t2, fin_leer_materias # Si es un null terminator termina de leer
            
    #         sb $t2, ($v0)

    #         add $v0, $v0, 1
    #         add $s1, $s1, 1

    #         b for_codigo
        
    #     for_codigo_fin:
    #         sb $zero, ($v0)
    #         add $s1, $s1, 1 # Saltar comilla
        
    #     # Reservar la memoria para el nombre
    #     li $v0, 9
    #     li $a0, 31
    #     syscall

    #     bltz $v0, error
    #     move $t3, $v0
        
    #     # Guarda el nombre
    #     for_nombre_mat:
    #         lb $t2, ($s1)

    #         # Si es una comilla, termina el nombre
    #         beq $t2, 34 for_nombre_mat_fin

    #         sb $t2, ($v0)
            
    #         add $v0, $v0, 1
    #         add $s1, $s1, 1

    #         b for_nombre_mat

    #     for_nombre_mat_fin:
    #         sb $zero, ($v0)
    #         add $s1, $s1, 1 # Saltar comilla


    #     # Reservar la memoria para el credito
    #     li $v0, 9
    #     li $a0, 2
    #     syscall

    #     bltz $v0, error
    #     move $t4, $v0
        
    #     # Guarda el credito
    #     lb $t2, ($s1)
    #     sb $t2, ($v0)

    #     add $v0, $v0,  1
    #     add $s1, $s1,  1
    #     sb $zero, ($v0)

    #     # Reservar la memoria para el #cupos
    #     li $v0, 9
    #     li $a0, 4
    #     syscall

    #     li $t6, 3
    #     for_cupo:
    #         lb $t2, ($s1)
    #         sb $t2, ($v0)

    #         add $v0, $v0,  1
    #         add $s1, $s1,  1
    #         add $t6, $t6, -1

    #         bnez $t6, for_cupo

    #     for_cupo_fin:
    #         sb $zero, ($v0)

    #     # Reservar la memoria para los min. creditos
    #     li $v0, 9
    #     li $a0, 4
    #     syscall

    #     bltz $v0, error
    #     move $t5, $v0

    #     # Guarda los creditos
    #     li $t6, 3
    #     for_min_creditos:
    #         lb $t2, ($s1)
    #         sb $t2, ($v0)

    #         add $v0, $v0,  1
    #         add $s1, $s1,  1
    #         add $t6, $t6, -1

    #         bnez $t6, for_min_creditos

    #     for_min_creditos_fin:
    #         sb $zero, ($v0)
        
    #     add $s1, $s1, 1 # Salta \n

    #     lb $t2, ($s1)

        # Crear Materia
        # move $a0, $t1

        # move $s7, $t1 # Borrar

        # move $a1, $t3
        # move $a2, $t4
        # move $a3, $t5
        # jal Materia_crear

        # move $a0,  $t7  # Tabla
        # lw   $a1, ($v0) # Clave
        # move $a2,  $v0  # Valor
        
        # # Guardar la materia en la tabla
        # jal TablaHash_insertar

        # Si no se logro insertar
        #bltz $v0, fin_leer_materias 
        
        # bnez $t2, for_leer_estudiantes     # Nulo
        # bne $t2, 10, for_leer_estudiantes  # Salto de linea
        # bne $t2, 11, for_leer_estudiantes  # Tab vertical
        # bne $t2, 32, for_leer_estudiantes  # Espacio en blanco

    # fin_leer_materias:
        # move $a0, $t7
        # move $a1, $s7
        # jal TablaHash_obtenerValor
        
        # lw $a0, 4($v0)    
        # li $v0, 4
        # syscall

    # ------------ SOLICITUDES ---------------

    # Abrir archivo

    # Verificar $v0
    # Leer archivo ($v0=14) ($a0=$v0)
    # Verificar $v0

    # <Lista Solicitudes>.crear()

    # Por cada linea:
        # syscall 9 (9 bytes) [verificar]
        # Crear solicitud
        # 8 chars:
            # Guardar carnet
            #  Estudiante = <TablaHash Estudiante>.buscar[carnet]
    # 7 chars:
            # Guardar codigo
            # Materia = <TablaHash Materias>.buscar([cedigo])
    # Crear Solicitud(Estudiante, Materia, ‘S’)
    # <Lista Solicitudes>.insertar(Solicitud)

    # ---------------- INSCRIPCIeN ------------------

    # for solicitud in <Lista Solicitudes>
    #     solicitud.Materia.Estudiantes.insertar(Pair<solicitud.Estudiante, Op.>)
    #     solicitud.Materia.cupo--

    # ------------- ARCHIVO TENTATIVO --------------------
    # for Materia in <TablaHash Materias>
    # 	print Materia
    #	for Estudiante in Materia.Estudiantes
    #		print Estudiante.primero


    # -------- SOLICITUDES CORRECCIeN---------------
    # Abrir archivo

    # Verificar $v0
    # Leer archivo ($v0=14) ($a0=$v0)
    # Verificar $v0

    # <Lista Solicitudes>.crear()

    # Por cada linea:
        # syscall 9 (9 bytes) [verificar]
        # Crear solicitud
        # 8 chars:
            # Guardar carnet
            #  Estudiante = <TablaHash Estudiante>.buscar[carnet]
    # 7 chars:
            # Guardar codigo
            # Materia = <TablaHash Materias>.buscar([cedigo])
    # 1 char:
        # Guardar operacien
    # Crear Solicitud(Estudiante, Materia, op)
    # <Lista Solicitudes>.insertar(Solicitud)


    # ---------------- CORRECCIeN ------------------
    # <ColaDePrioridad(min) Inscribir>.crear()

    # for solicitud in <Lista Solicitudes>
    #     Si solicitud.op == ‘E’
    #	for par in solicitud.Materias.Estudiantes
    #		Si par.primero == solicitud.Estudiante
    #			par.segundo = ‘E’
    #			break
    # 	Materia.cupos++
    #
    #     Si solicitud.op == ‘I’
    #	prioridad = solicitud.Estudiante.creditosAprob
    #	<ColaDePrioridad Inscribir>.encolar(Pair<solicitud, prioridad>)

    #    while !<ColaDePrioridad Inscribir>.estaVacia()
    #	solicitud = <ColaDePrioridad Inscribir>.pop()
    #	
    #	if solicitud.Materia.cupos > 0
    #		solicitud.Materia.Estudiantes.insertar(Pair<Estudiante, Op.>)
    #		solicitud.Materia.cupos--

    # check every subject have more than -1 kupos

    # ------------- ARCHIVO DEFINITIVO --------------------
    # for Materia in <TablaHash Materias>
    # 	print Materia
    #	for Estudiante in Materia.Estudiantes
    #		print Estudiante.first (print Estudiante.second)
        

    j fin

error:

    li $v0, 4
    la $a0, error1
    syscall

fin:

    li $v0, 10               
    syscall

.include "Estudiante.s"
.include "TablaHash.s"
.include "Lista.s"
.include "Utilidades.s"