# Proyecto 1
# Implementacion de un sistema de asignacion de cupos
# para dar soporte al proceso de inscripcion y correccion 
# de materias de una institucion.
#
# Autores: Ka Fung & Christopher Gomez
# Fecha: 25-nov-2021

        .data
arcEst:         .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-Estudiantes.txt"
arcMat:         .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-Materias.txt"
arcIns:         .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-SolInscripcion.txt"
arcCor:         .asciiz "/home/fung/Downloads/Orga/proyecto1/ejemplo-SolCorreccion.txt"
arcTen:         .asciiz "/home/fung/Downloads/Orga/proyecto1/AA-InsTentativa.txt"
arcDef:         .asciiz "/home/fung/Downloads/Orga/proyecto1/AA-InsDefinitiva.txt"

buffer:         .space 2097152 
bufferTamanio:  .word  2097152

tablaTamanio:   .word 100
tablaHashEst:   .word 0
tablaHashMat:   .word 0
listaSolIns:    .word 0
listaSolCor:    .word 0
listaMat:       .word 0
listaPriorIns:  .word 0

ident:          .asciiz "   "  
espC:           .asciiz " \""
cEsp:           .asciiz "\" "
newl:           .asciiz "\n"
parentIzq:      .asciiz "("
parentDer:      .asciiz ")"

error1:         .asciiz "Ha ocurrido un error."
errorArc:       .asciiz "Ha ocurrido un error al abrir el archivo"
errorMat:       .asciiz "Materia de la solicitud no se encontro"
errorEst:       .asciiz "Estudiante de la solicitud no se encontro"

        .text
        .globl main
main:
    # ---------- ESTUDIANTES ----------
    # Cargar datos de los estudiantes.
    #
    # Planificacion de registros: 
    # $s0: Direccion del buffer.
    # $s1: TablaHash Estudiantes.
    # $s2: Direccion carnet.
    # $s3: Direccion nombre.
    # $s4: Direccion indice.
    # $s5: Direccion credito.

    # Abrir y leer el archivo
    la $a0, arcEst
    la $a1, buffer
    lw $a2, bufferTamanio
    jal leer_archivo
    bltz $v0, errorArchivo

    # Crear TablaHash Estudiantes
    lw  $a0, tablaTamanio
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

        add $v1, $v1, 1     # Saltar comilla

        # Guardar el nombre
        move $a0, $v1
        li   $a1, 20
        li   $a2, 1
        jal guardar_dato

        blez $v0, fin_leer_estudiantes
        move $s3, $v0

        add $v1, $v1, 1     # Saltar comilla

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
        
        move $a0, $v0
        li   $a1, 3
        jal  atoi

        move $s5, $v0

        move $s0, $v1
        add  $s0, $s0, 1    # Salta \n

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
        lb   $t0, ($s0)
        bnez $t0, for_leer_estudiantes  # Nulo

    fin_leer_estudiantes:  
    # ---------- MATERIAS ----------
    # Cargar los datos de las materias.
    #
    # Planificacion de registros:
    # $s0: Direccion del buffer.
    # $s1: TablaHash Materias.
    # $s2: Direccion codigo.
    # $s3: Direccion nombre.
    # $s4: Direccion credito.
    # $s5: Direccion cupos.
    # $s6: Direccion min creditos.

    # Abrir y leer el archivo
    la $a0, arcMat
    la $a1, buffer
    lw $a2, bufferTamanio
    jal leer_archivo
    bltz $v0, errorArchivo

    # Crear TablaHash Materias
    lw  $a0, tablaTamanio
    jal TablaHash_crear

    # Guardar TablaHash Materia
    sw $v0, tablaHashMat

    # Lista codigos de materias
    jal  Lista_crear
    sw   $v0, listaMat

    # Direccion de los datos
    la $s0, buffer

    for_leer_materias:
        # Guardar codigo
        move $a0, $s0
        li   $a1, 7
        li   $a2, 0
        jal guardar_dato

        blez $v0, fin_leer_materias
        move $s2, $v0

        add $v1, $v1, 1     # Saltar comilla

        # Guardar nombre de la materia
        move $a0, $v1
        li   $a1, 30
        li   $a2, 1
        jal guardar_dato

        blez $v0, fin_leer_materias
        move $s3, $v0

        add $v1, $v1, 1     # Saltar comilla
        
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
        add $s0, $s0, 1     # Salta \n

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
        lb   $t0, ($s0)
        bnez $t0, for_leer_materias # Nulo
              
    fin_leer_materias:
    # --------- SOLICITUDES INSCRIPCION ---------
    # Cargar las solicitudes de inscripcion.
    #
    # Planificacion de registros:
    # $s0: Direccion del buffer.
    # $s2: TablaHash Materias.
    # $s1: Estudiante.
    # $s2: Materia.
    
    # Abrir y leer el archivo
    la $a0, arcIns
    la $a1, buffer
    lw $a2, bufferTamanio
    jal leer_archivo
    bltz $v0, errorArchivo

    # Crear Lista Solicitudes
    jal Lista_crear

    # Guardar la lista
    sw $v0, listaSolIns

    # Direccion de los datos
    la $s0, buffer

    for_leer_solicitud:
        # Guardar carnet
        move $a0, $s0
        li   $a1, 8
        li   $a2, 0
        jal guardar_dato

        # Verificar si se guardo carnet
        blez $v0, fin_leer_solicitud
        move $s1, $v0

        # Guardar codigo
        move $a0, $v1
        li   $a1, 7
        li   $a2, 0
        jal guardar_dato

        # Verificar si se guardo codigo
        blez $v0, fin_leer_solicitud
        move $s2, $v0

        move $s0, $v1
        add  $s0, $s0, 1    # Salta \n
        
        # Buscar carnet en la TablaHash
        lw   $a0, tablaHashEst
        move $a1, $s1
        jal TablaHash_obtenerValor

        # Si no se encontro carnet en la TablaHash
        beqz $v0, errorEstudiante
        move $s1, $v0

        # Buscar codigo en la TablaHash
        lw   $a0, tablaHashMat
        move $a1, $s2
        jal TablaHash_obtenerValor

        # Si no se encontro codigo en la TablaHash
        beqz $v0, errorMateria
        move $s2, $v0

        # Crear Solicitud(Estudiante, Materia, ‘S’)
        move $a0, $s1
        move $a1, $s2
        li   $a2, 'S'

        jal Solicitud_crear 

        # Insertar solicitud en listaSolIns
        lw   $a0, listaSolIns
        move $a1, $v0
        jal Lista_insertar

        # Si no se logro insertar
        bltz $v0, fin_leer_solicitud

        # Iterar siguiente linea
        lb   $t0, ($s0)
        bnez $t0, for_leer_solicitud    # Nulo

    fin_leer_solicitud:
    # ---------- INSCRIPCION ----------
    # Procesa las solicitudes de inscripcion.
    # Se aceptan todas las solicitudes.
    #
    # Planificacion de registros:
    # $s0: Lista de Solicitud de inscripcion.
    # $s1: Centinela de Lista.
    # $s2: Nodo de Lista.
    # $s3: valor del nodo (Solicitud).

    lw $s0, listaSolIns
    lw $s1,  ($s0)      # Centinela de la lista
    lw $s2, 8($s1)      # Primer nodo de la lista

    for_solicitud:
        # Mientras Nodo != centinela
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
    # ------------ ARCHIVO TENTATIVO ------------
    # Imprime las solicitudes de inscripcion en el  
    # archivo tentativo.
    #
    # Planificacion de registros:
    # $s0: Archivo (descriptor).
    # $s1: Lista de codigos.
    # $s2: Centinela de la lista.
    # $s3: Nodo de la lista.
    # $s4: Materia actual.

    # Abrir archivo para escribir
    li $v0, 13
    la $a0, arcTen
    li $a1, 1 
    syscall
    move $s0, $v0

    lw $s1, listaMat
	lw $s2,  ($s1)      # Centinela de la lista
    lw $s3, 8($s2)      # Primer nodo de la lista

    for_imprimir_mat:
        # Mientras Nodo != centinela
        beq $s2, $s3, for_imprimir_mat_fin

        lw $a1, 4($s3)  # Codigo de la materia

        # Buscar Materia en la TablaHash 
        lw $a0, tablaHashMat
        jal TablaHash_obtenerValor
        move $s4, $v0

        # Imprimir Materia y Estudiantes
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

    # --------- SOLICITUDES CORRECCION ---------
    # Cargar las solicitudes de correccion.
    #
    # Planificacion de registros:
    # $s0: Direccion del buffer.
    # $s1: Estudiante.
    # $s2: Materia.
    # $s3: operacion.
    
    # Abre y lee un archivo
    la $a0, arcCor
    la $a1, buffer
    lw $a2, bufferTamanio
    jal leer_archivo
    bltz $v0, errorArchivo

    # Crear Lista Solicitudes
    jal Lista_crear

    # Guardar la lista
    sw $v0, listaSolCor

    # Direccion de los datos
    la $s0, buffer

    for_leer_sol_cor:
        # Guardar carnet
        move $a0, $s0
        li   $a1, 8
        li   $a2, 0
        jal guardar_dato

        # Verificar si se guardo carnet
        blez $v0, fin_leer_sol_cor
        move $s1, $v0

        # Guardar codigo
        move $a0, $v1
        li   $a1, 7
        li   $a2, 0
        jal guardar_dato

        # Verificar si se guardo codigo
        blez $v0, fin_leer_sol_cor
        move $s2, $v0

        # Guardar operacion
        move $a0, $v1
        li   $a1, 1
        li   $a2, 0
        jal guardar_dato

        # Verificar si se guardo operacion
        blez $v0, fin_leer_sol_cor
        move $s3, $v0

        move $s0, $v1
        add  $s0, $s0, 1    # Salta \n
        
        # Buscar carnet en la TablaHash
        lw   $a0, tablaHashEst
        move $a1, $s1
        jal TablaHash_obtenerValor

        # Si no se encontro carnet en la TablaHash
        beqz $v0, errorEstudiante
        move $s1, $v0

        # Buscar codigo en la TablaHash
        lw   $a0, tablaHashMat
        move $a1, $s2
        jal  TablaHash_obtenerValor

        # Si no se encontro codigo en la TablaHash
        beqz $v0, errorMateria
        move $s2, $v0

        # Crear Solicitud(Estudiante, Materia, op)
        move $a0,  $s1
        move $a1,  $s2
        lb   $a2, ($s3)
        jal Solicitud_crear

        # Insertar solicitud en listaSol
        lw   $a0, listaSolCor
        move $a1, $v0
        jal Lista_insertar

        # Si no se logro insertar
        bltz $v0, fin_leer_sol_cor
        
        # Iterar siguiente linea
        lb   $t0, ($s0)
        bnez $t0, for_leer_sol_cor # Nulo

    fin_leer_sol_cor:
    # ------------ CORRECCION ------------
    # Planificacion de registros:
    # $s0: Lista de Solicitud de correccion
    # $s1: Centinela de Lista
    # $s2: Nodo de Lista
    # $s3: valor del nodo (Solicitud)
    # $s4: operacion de la Solicitud
    # $s5: Auxiliar

    # Lista de prioridad inscripciones en correccion
    jal Lista_crear
    sw $v0, listaPriorIns

    lw $s0, listaSolCor
    lw $s1,  ($s0)      # Centinela de la lista
    lw $s2, 8($s1)      # Primer nodo de la lista

    for_solicitud_cor:
        # Mientras Nodo != centinela
        beq $s2, $s1, for_solicitud_cor_fin

        lw $s3, 4($s2)  # Valor del nodo (Solicitud)
        lb $s4, 8($s3)  # operacion de Solicitud

        # Si operacion == 'I'
        li  $s5, 'I'
        beq $s4, $s5, solicitud_inscribir

        # Si la operación no es 'I', es 'E'
        # Cambiar la operacion de la inscripcion
        solicitud_eliminar:
            lw $a0, 4($s3)   # Materia
            lw $a1,  ($s3)   # Estudiante
            jal Materia_eliminarEstudiante

            b for_solicitud_sig

        # Insertar Estudiante en la Lista de Prioridad de Inscripciones
        solicitud_inscribir:
            lw   $a0, listaPriorIns
            move $a1, $s3
            la   $a2, comparador_solicitud
            jal Lista_insertarOrdenado

        for_solicitud_sig:
            # Actualizamos al Nodo.siguiente
            lw $s2, 8($s2) 
            b for_solicitud_cor

    for_solicitud_cor_fin:
        # Elimina estudiantes si las materias
        # tienen cupos negativos.
        #
        # Planificacion de registros:
        # $s0: Lista de materias.
        # $s1: Centinela de Lista.
        # $s2: Nodo actual de Lista.
        # $s3: Estudiante no eliminado con mas creditos.
        # $s4: Materia.
        # $s5: Lista Estudiantes.
        # $s6: Centinela de Lista Estudiantes.
        # $s7: Nodo de actual Lista Estudiantes.
        # $t0: Cupos de Materia.
        # $t1: Codigo de la materia.
        
        # Verifica que todas las materias tengan cupos positivos
        lw $s0, listaMat
        lw $s1,  ($s0)          # Centinela de la lista
        lw $s2, 8($s1)          # Primer nodo de la lista

        for_materia:
            beq $s2, $s1, for_materia_fin

            lw $t1,  4($s2)     # Valor del nodo (Codigo)

            # Buscar codigo en la TablaHash
            lw   $a0, tablaHashMat
            move $a1, $t1
            jal  TablaHash_obtenerValor

            move $s4, $v0
            lw   $t0, 12($s4)   # Cupos

            # Actualizamos al Nodo.siguiente
            lw $s2, 8($s2) 

            bgez $t0, for_materia

            # Eliminar estudiantes
            for_cupos_neg:
                lw $s5, 20($s4)     # Lista Estudiantes
                lw $s6,  ($s5)      # Centinela de la lista
                lw $s7, 8($s6)      # Nodo de la lista
                
                # Se crea estudiante Dummy con -1
                # para hallar el estudiante con mas creditos
                la $a0, newl
                la $a1, newl
                la $a2, newl
                li $a3, -1
                jal Estudiante_crear
                move $s3, $v0
                
                for_estudiante:
                    beq $s7, $s6, for_estudiante_fin

                    lw $t0, 4($s7)  # Valor del nodo (Par)
                    lw $t2, ($t0)   # Estudiante
                    lw $t3, 4($t0)  # Operacion

                    # Actualizamos al Nodo.siguiente
                    lw $s7, 8($s7) 

                    # Si la operacion == 'E'
                    li $t4, 'E'
                    beq $t4, $t3, for_estudiante

                    lw $t5, 12($s3) # Creditos aprobados max actual
                    lw $t6, 12($t2) # Creditos aprobados actual est

                    # Si creditosAprobMax > creditosAprobEst
                    bgt $t5, $t6, for_estudiante

                    # En cambio, actualizar max
                    move $s3, $t2
                    b for_estudiante
                    
                for_estudiante_fin:
                    # Se elimina el estudiante con mas creditoAprob de la materia
                    move $a0, $s4
                    move $a1, $s3
                    jal Materia_eliminarEstudiante
                    
                    lw $t0, 12($s4) # Cupos de la Materia
                    bnez $t0, for_cupos_neg

            b for_materia

        for_materia_fin:
        # Inscribe las solicitudes de inscripcion de 
        # las correcciones si quedan cupos.
        #
        # Planificacion de registros:
        # $s0: Lista de inscripciones de correccion.
        # $s1: Centinela de Lista.
        # $s2: Nodo de Lista.
        # $s3: valor del nodo (Solicitud).
        # $s4: Materia de la Solicitud.
        # $s5: Cupos de Materia.

        # Procesar inscripciones de correccion
        lw $s0, listaPriorIns
        lw $s1,  ($s0)          # Centinela de la lista
        lw $s2, 8($s1)          # Primer nodo de la lista

        # Mientras haya solicitudes de inscripcion
        for_inscripcion_cor:  
            beq $s2, $s1, for_inscripcion_cor_fin

            lw $s3,  4($s2)     # Valor del nodo (Solicitud)
            lw $s4,  4($s3)     # Materia
            lw $s5, 12($s4)     # Cupos

            # Actualizamos al Nodo.siguiente
            lw $s2, 8($s2) 

            # Si no quedan cupos en la Materia, siguiente solicitud
            blez $s5, for_inscripcion_cor

            # Insertar Estudiante en la lista de Materia
            lw $a0, 4($s3)      # Materia 
            lw $a1,  ($s3)      # Estudiante
            lw $a2, 8($s3)      # operacion
            jal Materia_agregarEstudiante

            b for_inscripcion_cor

    for_inscripcion_cor_fin:
    # ---------- ARCHIVO DEFINITIVO ----------
    # Imprime las solicitudes de inscripcion en  
    # el archivo tentativo.
    #
    # Planificacion de registros:
    # $s0: Archivo (descriptor).
    # $s1: Lista de codigos.
    # $s2: Centinela de la lista.
    # $s3: Nodo de la lista.
    # $s4: Materia actual.

    # Abrir archivo para escribir
    li $v0, 13
    la $a0, arcDef
    li $a1, 1 
    syscall
    move $s0, $v0

    lw $s1, listaMat
	lw $s2,  ($s1)      # Centinela de la lista
    lw $s3, 8($s2)      # Primer nodo de la lista

    for_imprimir_mat_def:
        # Mientras Nodo != centinela
        beq $s2, $s3, for_imprimir_mat_def_fin

        lw $a1, 4($s3)  # Codigo de la materia

        # Buscar Materia en la TablaHash 
        lw $a0, tablaHashMat
        jal TablaHash_obtenerValor 
        move $s4, $v0

        # Imprimir Materia y Estudiantes
        move $a0, $s4
        move $a1, $s0
        jal Materia_imprimirMateria

        # Actualizamos al Nodo.siguiente
        lw $s3, 8($s3) 
        
        b for_imprimir_mat_def

    for_imprimir_mat_def_fin:
        # Cerrar archivo
        li   $v0, 16       
        move $a0, $s0      
        syscall 

    # Termina ejecucion  del programa    
    b fin

error:
    li $v0, 4
    la $a0, error1
    syscall
    b fin

errorArchivo:
    li $v0, 4
    la $a0, errorArc
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
