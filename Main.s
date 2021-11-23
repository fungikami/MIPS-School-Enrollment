# Proyecto 1
# 
# Autores: Ka Fung & Christopher Gemez
# Fecha: 25-nov-2021

        .data

arcEst:         .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-Estudiantes.txt"
arcMat:         .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-Materias.txt"
arcIns:         .asciiz "ejemplo-SolInscripcion.txt"
arcCor:         .asciiz "ejemplo-SolCorreccion.txt"
arcTen:         .asciiz "ejemplo-InsTentativa.txt"
arcDef:         .asciiz "ejemplo-InsDefinitiva.txt"

tamanioTablaHash:   .word 100

buscarEst:      .asciiz "15-47895" # Indice de 4.2827

buffer:         .space 1048576 # 1Mb
bufferNull:     .ascii "\0"
error1:         .asciiz "Ha ocurrido un error."
newl:           .asciiz "\n"

tablaHashEst:   .word 0
tablaHashMat:   .word 0

        .text
main:

    # ------------ ESTUDIANTES ---------------

    # Planificacion de registros:
    # $s0: Archivo (identificador)
    # $s1: Direccion del buffer
    # $s2: TablaHash Estudiantes
    # $s3: Direccion carnet
    # $s4: Direccion nombre
    # $s5: Direccion indice
    # $s6: Direccion credito

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

    la $s2, tablaHashEst
    sw $v0, ($s2)

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
    
    # Planificacion de registros:
    # $s0: Archivo (identificador)
    # $s1: Direccion del buffer
    # $s2: TablaHash Materias
    # $s3: Direccion codigo
    # $s4: Direccion nombre 
    # $s5: Direccion credito
    # $s6: Direccion cupos
    # $s7: Direccion min creditos

    # Abrir archivo
    li $v0, 13
    la $a0, arcMat
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

    # <TablaHash Materias>.crear()
    lw  $a0, tamanioTablaHash
    jal TablaHash_crear

    la $s2, tablaHashMat
    sw $v0, ($s2)

    move $s2, $v0

    # Direccion de los datos
    la $s1, buffer

    for_leer_materias:
        # Guarda codigo
        move $a0, $s1
        li   $a1, 7
        li   $a2, 1
        jal guardar_dato

        blez $v0, fin_leer_materias
        move $s3, $v0

        add $v1, $v1, 1 # Saltar comilla

        # Guarda nombre de la materia
        move $a0, $v1
        li   $a1, 30
        li   $a2, 1
        jal guardar_dato

        blez $v0, fin_leer_materias
        move $s4, $v0

        add $v1, $v1, 1 # Saltar comilla
        
        # Guardar credito
        move $a0, $v1
        li   $a1, 1
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_materias
        move $s5, $v0

        # Guardar numero de cupos
        move $a0, $v1
        li   $a1, 3
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_materias
        move $s6, $v0

        # Guardar min creditos
        move $a0, $v1
        li   $a1, 3
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_materias
        move $s6, $v0

        move $s1, $v1
        add $s1, $s1, 1 # Salta \n

        # Crear Materia
        move $a0,  $s3
        move $a1,  $s4
        move $a2,  $s5
        move $a3,  $s6
        sw   $s7, ($sp)
        add  $sp,  $sp, -4

        jal Materia_crear

        lw   $s7, ($sp)
        add  $sp,  $sp, 4

        move $a0,  $s2  # Tabla
        lw   $a1, ($v0) # Clave
        move $a2,  $v0  # Valor
        
        # Guardar la materia en la tabla
        jal TablaHash_insertar

        # Si no se logro insertar
        bltz $v0, fin_leer_materias
        
        lb $t2, ($s1)

        bnez $t2, for_leer_estudiantes      # Nulo
        bne  $t2, 10, fin_leer_materias     # Salto de linea
        bne  $t2, 11, fin_leer_materias     # Tab vertical
        bne  $t2, 32, fin_leer_materias     # Espacio en blanco
              
    fin_leer_materias:
        

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

.include "Par.s"
.include "Lista.s"
.include "Estudiante.s"
.include "Materia.s"
.include "TablaHash.s"
.include "Utilidades.s"