# Proyecto 1
# 
# Autores: Ka Fung & Christopher Gemez
# Fecha: 25-nov-2021

        .data
# chus/Documents 
# fung/Downloads
arcEst:         .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-Estudiantes.txt"
arcMat:         .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-Materias.txt"
arcIns:         .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-SolInscripcion.txt"
arcCor:         .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-SolCorreccion.txt"
arcTen:         .asciiz "/home/fung/Downloads/Orga/proyecto1/AA-InsTentativa.txt"
arcDef:         .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-InsDefinitiva.txt"

tamanioTablaHash:   .word 100

buscarEst:      .asciiz "15-20076" # Indice de 4.2827
buscarMat:      .asciiz "CI-1804"

buffer:         .space 524288 # 1Mb = 10485976
buffer2:        .space 524288 # 1Mb
buffer3:        .space 524288
bufferTamanio:  .word  524288

error1:         .asciiz "Ha ocurrido un error."
errorMat:       .asciiz "Materia de la solicitud no se encontro"
errorEst:       .asciiz "Estudiante de la solicitud no se encontro"

ident:          .asciiz "   "  
espC:           .asciiz " \""
cEsp:           .asciiz "\" "
newl:           .asciiz "\n"

tablaHashEst:   .word 0
tablaHashMat:   .word 0
listaSolIns:    .word 0
listaSolCor:    .word 0
listaMat:       .word 0
listaInsCor:    .word 0

        .text
main:

    # ------------ ESTUDIANTES ---------------

    # Planificacsion de registros: 
    # $s0: Direccion del buffer
    # $s1: TablaHash Estudiantes
    # $s2: Direccion carnet
    # $s3: Direccion nombre
    # $s4: Direccion indice
    # $s5: Direccion credito

    # Abrir y leer el archivo
    la $a0, arcEst
    la $a1, buffer
    lw $a2, bufferTamanio
    jal leer_archivo
    bltz $v0, error

    # <TablaHash Estudiantes>.crear()
    lw  $a0, tamanioTablaHash
    jal TablaHash_crear

    # Guardar TablaHash Estudiante
    sw $v0, tablaHashEst

    # Direccion de los datos
    la $s0, buffer

    for_leer_estudiantes:
        # Guardar el carnet
        move $a0, $s0
        li   $a1, 8
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_estudiantes
        move $s2, $v0

        add $v1, $v1, 1 # Saltar comilla

        # Guardar el nombre
        move $a0, $v1
        li   $a1, 20
        li   $a2, 1
        jal guardar_dato

        blez $v0, fin_leer_estudiantes
        move $s3, $v0

        add $v1, $v1, 1 # Saltar comilla

        # Guardar el indice
        move $a0, $v1
        li   $a1, 6
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_estudiantes
        move $s4, $v0

        # Guardar creditos aprobados
        move $a0, $v1
        li   $a1, 3
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_estudiantes
        move $s5, $v0

        move $s0, $v1
        add  $s0, $s0, 1 # Salta \n

        # Crear Estudiante
        move $a0, $s2
        move $a1, $s3
        move $a2, $s4
        move $a3, $s5
        jal Estudiante_crear

        lw   $a0, tablaHashEst  # Tabla
        lw   $a1, ($v0)         # Clave
        move $a2,  $v0          # Valor
        
        # Guardar el estudiante en la tabla
        jal TablaHash_insertar

        # Si no se logro insertar
        bltz $v0, fin_leer_estudiantes 
        
        # Iterar siguiente linea
        lb   $t2, ($s0)
        bnez $t2, for_leer_estudiantes      # Nulo
        bne  $t2, 10, for_leer_estudiantes  # Salto de linea
        bne  $t2, 11, for_leer_estudiantes  # Tab vertical
        bne  $t2, 32, for_leer_estudiantes  # Espacio en blanco

    fin_leer_estudiantes:  
    # ------------ MATERIAS ---------------
    
    # Planificacion de registros:
    # $s0: Direccion del buffer
    # $s1: TablaHash Materias
    # $s2: Direccion codigo
    # $s3: Direccion nombre 
    # $s4: Direccion credito
    # $s5: Direccion cupos
    # $s6: Direccion min creditos

    # Abrir y leer el archivo
    la $a0, arcMat
    la $a1, buffer2
    lw $a2, bufferTamanio
    jal leer_archivo
    bltz $v0, error

    # <TablaHash Materias>.crear()
    lw  $a0, tamanioTablaHash
    jal TablaHash_crear

    # Guardar TablaHash Materia
    sw $v0, tablaHashMat

    # Lista codigos de materias
    jal  Lista_crear
    sw   $v0, listaMat

    # Direccion de los datos
    la $s0, buffer2

    for_leer_materias:
        # Guardar codigo
        move $a0, $s0
        li   $a1, 7
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_materias
        move $s2, $v0

        add $v1, $v1, 1 # Saltar comilla

        # Guardar nombre de la materia
        move $a0, $v1
        li   $a1, 30
        li   $a2, 1
        jal guardar_dato

        blez $v0, fin_leer_materias
        move $s3, $v0

        add $v1, $v1, 1 # Saltar comilla
        
        # Guardar credito
        move $a0, $v1
        li   $a1, 1
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_materias
        move $s4, $v0

        # Guardar numero de cupos
        move $a0, $v1
        li   $a1, 3
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_materias

        move $a0, $v0
        li   $a1, 3
        jal  atoi

        move $s5, $v0

        # Guardar min creditos
        move $a0, $v1
        li   $a1, 3
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_materias
        move $s6, $v0

        move $s0, $v1
        add $s0, $s0, 1 # Salta \n

        # Crear Materia
        move $a0,  $s2
        move $a1,  $s3
        move $a2,  $s4
        move $a3,  $s5
        sw   $s6, ($sp)
        add  $sp,  $sp, -4

        jal Materia_crear
        add  $sp,  $sp, 4

        lw   $a0, tablaHashMat # Tabla
        lw   $a1, ($v0)        # Clave
        move $a2,  $v0         # Valor
        
        # Guardar la materia en la tabla
        jal TablaHash_insertar

        # Si no se logro insertar
        bltz $v0, fin_leer_materias

        # Insertar en Lista de codigos de Materias
        lw $a0, listaMat
        move $a1, $s2
        la   $a2, comparador
        jal Lista_insertarOrdenado
        
        # Iterar siguiente linea
        lb   $t2, ($s0)
        bnez $t2, for_leer_materias         # Nulo
        bne  $t2, 10, fin_leer_materias     # Salto de linea
        bne  $t2, 11, fin_leer_materias     # Tab vertical
        bne  $t2, 32, fin_leer_materias     # Espacio en blanco
              
    fin_leer_materias:
    # ------------ SOLICITUDES ---------------

    # Planificacion de registros:
    # $s0: 
    # $s1: Direccion del buffer
    # $s2: TablaHash Materias
    # $s3: Estudiante
    # $s4: Materia
    
    # Abrir y leer el archivo
    la $a0, arcIns
    la $a1, buffer3
    lw $a2, bufferTamanio
    jal leer_archivo
    bltz $v0, error

    # <Lista Solicitudes>.crear()
    jal Lista_crear

    # Guardar la lista
    sw $v0, listaSolIns

    # Direccion de los datos
    la $s1, buffer3

    for_leer_solicitud:
        # Guardar carnet
        move $a0, $s1
        li   $a1, 8
        li   $a2, 0
        jal guardar_dato

        # Verificar si se guardo carnet
        blez $v0, fin_leer_solicitud
        move $s3, $v0

        # Guardar codigo
        move $a0, $v1
        li   $a1, 7
        li   $a2, 0
        jal guardar_dato

        # Verificar si se guardo codigo
        blez $v0, fin_leer_solicitud
        move $s4, $v0

        move $s1, $v1
        add  $s1, $s1, 1 # Salta \n
        
        # Buscar carnet en la TablaHash
        lw   $a0, tablaHashEst
        move $a1, $s3
        jal TablaHash_obtenerValor

        # Si no se encontro carnet en la TablaHash
        beqz $v0, errorEstudiante
        move $s3, $v0

        # Buscar codigo en la TablaHash
        lw   $a0, tablaHashMat
        move $a1, $s4
        jal TablaHash_obtenerValor

        # Si no se encontro codigo en la TablaHash
        beqz $v0, errorMateria
        move $s4, $v0

        # Crear Solicitud(Estudiante, Materia, ‘S’)
        move $a0, $s3
        move $a1, $s4
        li   $a2, 83

        jal Solicitud_crear # Se crea bien la sol. (verificado)

        # Insertar solicitud en listaSol
        lw   $a0, listaSolIns
        move $a1, $v0
        jal Lista_insertar

        # Si no se logro insertar
        bltz $v0, fin_leer_solicitud

        # Iterar siguiente linea
        lb   $t2, ($s1)
        bnez $t2, for_leer_solicitud         # Nulo
        bne  $t2, 10, fin_leer_solicitud     # Salto de linea
        bne  $t2, 11, fin_leer_solicitud     # Tab vertical
        bne  $t2, 32, fin_leer_solicitud     # Espacio en blanco

    fin_leer_solicitud:
    # ---------------- INSCRIPCION ------------------
    # Planificacion de registros:
    # $s0: Lista de Solicitud de inscripcion
    # $s1: Centinela de Lista
    # $s2: Nodo de Lista
    # $s3: valor del nodo (Solicitud)

    lw $s0, listaSolIns
    lw $s1,  ($s0)  # Centinela de la lista
    lw $s2, 8($s1)  # Primer nodo de la lista

    for_solicitud:
        # while Nodo != centinela
        beq $s2, $s1, for_solicitud_end

        lw $s3, 4($s2)  # Valor del nodo (Solicitud)

        # Insertar Estudiante en la lista de Materia
        lw $a0, 4($s3)  # Materia 
        lw $a1,  ($s3)  # Estudiante
        lw $a2, 8($s3)  # operacion
        jal Materia_agregarEstudiante

        # Actualizamos al Nodo.siguiente
        lw $s2, 8($s2) 
        b for_solicitud

    for_solicitud_end:
    # ------------- ARCHIVO TENTATIVO --------------------

    # Planificacion de registros:
    # $s0: Archivo (descriptor)
    # $s1: Lista de codigos
    # $s2: Centinela de la lista
    # $s3: Nodo de la lista 
    # $s4: Materia actual

    # for Materia in <TablaHash Materias>
    # 	print Materia
    #	for Estudiante in Materia.Estudiantes
    #		print Estudiante.primero

    # Abrir archivo para escribir
    li $v0, 13
    la $a0, arcTen
    li $a1, 1 
    syscall
    move $s0, $v0

    lw $s1, listaMat
	lw $s2,  ($s1)  # Centinela de la lista
    lw $s3, 8($s2)  # Primer nodo de la lista

    for_imprimir_mat:
        # while Nodo != centinela
        beq $s2, $s3, for_imprimir_mat_fin

        lw $a1, 4($s3)  # Codigo de la materia

        # Buscar Materia en la TablaHash 
        lw $a0, tablaHashMat
        jal TablaHash_obtenerValor # $v0: Materia
        move $s4, $v0

        move $a0, $s4
        move $a1, $s0
        jal Materia_imprimirMateria

        # Actualizamos al Nodo.siguiente
        lw $s3, 8($s3) 
        
        b for_imprimir_mat

    for_imprimir_mat_fin:
    # Cerrar archivo
    li   $v0, 16       
    move $a0, $s0      
    syscall 


    # -------- SOLICITUDES CORRECCION---------------
    # Planificacion de registros:
    # $s0: 
    # $s1: Direccion del buffer
    # $s2: TablaHash Materias
    # $s3: Estudiante
    # $s4: Materia
    # $s5: operacion
    
    # Abre y lee un archivo
    la $a0, arcCor
    la $a1, buffer3
    lw $a2, bufferTamanio
    jal leer_archivo
    bltz $v0, error

    # <Lista Solicitudes>.crear()
    jal Lista_crear

    # Guardar la lista
    sw $v0, listaSolCor

    # Direccion de los datos
    la $s1, buffer3

    for_leer_sol_cor:
        # Guardar carnet
        move $a0, $s1
        li   $a1, 8
        li   $a2, 0
        jal guardar_dato

        # Verificar si se guardo carnet
        blez $v0, fin_leer_sol_cor
        move $s3, $v0

        # Guardar codigo
        move $a0, $v1
        li   $a1, 7
        li   $a2, 0
        jal guardar_dato

        # Verificar si se guardo codigo
        blez $v0, fin_leer_sol_cor
        move $s4, $v0

        # Guardar operacion
        move $a0, $v1
        li   $a1, 1
        li   $a2, 0
        jal guardar_dato

        # Verificar si se guardo operacion
        blez $v0, fin_leer_sol_cor
        move $s5, $v0

        move $s1, $v1
        add  $s1, $s1, 1 # Salta \n
        
        # Buscar carnet en la TablaHash
        lw   $a0, tablaHashEst
        move $a1, $s3
        jal TablaHash_obtenerValor

        # Si no se encontro carnet en la TablaHash
        beqz $v0, errorEstudiante
        move $s3, $v0

        # Buscar codigo en la TablaHash
        lw   $a0, tablaHashMat
        move $a1, $s4
        jal TablaHash_obtenerValor

        # Si no se encontro codigo en la TablaHash
        beqz $v0, errorMateria
        move $s4, $v0

        # Crear Solicitud(Estudiante, Materia, op)
        move $a0, $s3
        move $a1, $s4
        move $a2, $s5

        jal Solicitud_crear 

        # Insertar solicitud en listaSol
        lw   $a0, listaSolCor
        move $a1, $v0
        jal Lista_insertar

        # Si no se logro insertar
        bltz $v0, fin_leer_sol_cor

        # Iterar siguiente linea
        lb   $t2, ($s1)
        bnez $t2, fin_leer_sol_cor         # Nulo
        bne  $t2, 10, fin_leer_sol_cor     # Salto de linea
        bne  $t2, 11, fin_leer_sol_cor     # Tab vertical
        bne  $t2, 32, fin_leer_sol_cor     # Espacio en blanco

    fin_leer_sol_cor:
    # ---------------- CORRECCION ------------------
    # Planificacion de registros:
    # $s0: Lista de Solicitud de correccion
    # $s1: Centinela de Lista
    # $s2: Nodo de Lista
    # $s3: valor del nodo (Solicitud)
    # $s4: operacion de la Solicitud
    # $s5: Lista de Estudiantes de la Materia
    # $s6: Centinela de Lista de Estudiantes
    # $s7: Nodo de Lista de Estudiantes
    # $t0: Valor del nodo (Par)
    # $t1: Estudiante del par
    # $t2: Estudiante de la solicitud

    # # Lista inscripciones en correccion
    # jal Lista_crear
    # sw $v0, listaInsCor

    # lw $s0, listaSolCor
    # lw $s1,  ($s0)  # Centinela de la lista
    # lw $s2, 8($s1)  # Primer nodo de la lista

    # for_solicitud_cor:
    #     # while Nodo != centinela
    #     beq $s2, $s1, for_solicitud_end

    #     lw $s3, 4($s2)  # Valor del nodo (Solicitud)
    #     lw $s4, 8($s3)  # operacion de Solicitud

    #     # Si operacion == 'I'
    #     beq $s4, 73, solicitud_inscribir

    #     # Si operacion == 'E'
    #     beq $s4, 69, solicitud_eliminar

    #     solicitud_eliminar:
    #         # Buscar materia en la TablaHash
    #         lw $a0, tablaHashMat
    #         lw $a1, 4($s3)              # Materia de la solicitud
    #         lw $a1, ($a1)               # Codigo de la materia
    #         jal TablaHash_obtenerValor  # $v0: Materia

    #         lw $s5, 20($v0) # Lista estudiantes de Materia
    #         lw $s6,  ($s5)  # Centinela de la lista
    #         lw $s7, 8($s6)  # Primer nodo de la lista

    #         for_est_mat:
    #             # while Nodo != centinela
    #             beq $s6, $s7, for_imprimir_mat_fin

    #             lw $t0, 4($s7)      # Valor del nodo (Par)

    #             # Si par.primero == solicitud.Estudiante
    #             # modificamos la operacion a 'E'
    #             lw $t1, ($t0)       # Estudiante del par
    #             lw $t2, ($s3)       # Estudiante de la solicitud
    #             beq $t1, $t2, modificar_operacion

    #             # Actualizamos al Nodo.siguiente
    #             lw $s7, 8($s7)
    #             b for_est_mat

    #             modificar_operacion:
    #                 sb 69, 8($s3)

    #         for_est_fin:
    #             b for_solicitud_sig

    #     solicitud_inscribir:


    #     for_solicitud_sig:
    #         # Actualizamos al Nodo.siguiente
    #         lw $s2, 8($s2) 
    #         b for_solicitud_cor


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
    b fin

errorEstudiante:
    li $v0, 4
    la $a0, errorEst
    syscall
    b fin

errorMateria:
    li $v0, 4
    la $a0, errorMat
    syscall

fin:
    li $v0, 10               
    syscall

.include "Par.s"
.include "Lista.s"
.include "Estudiante.s"
.include "Materia.s"
.include "Solicitud.s"
.include "TablaHash.s"
.include "Utilidades.s"
