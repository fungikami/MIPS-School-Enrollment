# Proyecto 1
# 
# Autores: Ka Fung & Christopher Gemez
# Fecha: 25-nov-2021

        .data

arcEst:	.asciiz "/home/chus/Documents/Orga/proyecto1/ejemplo-Estudiantes.txt"
arcMat:	.asciiz "ejemplo-Materias.txt"
arcIns:	.asciiz "ejemplo-SolInscripcion.txt"
arcCor:	.asciiz "ejemplo-SolCorreccion.txt"
arcTen: .asciiz "ejemplo-InsTentativa.txt"
arcDef:	.asciiz "ejemplo-InsDefinitiva.txt"

buffer: .space 1024
bufferNull: "\0"
error1: .asciiz "Ha ocurrido un error."
newl:   .asciiz "\n"

        .text
main:

# Planificacion de registros:
# $s0: Archivo (identificador)
# 
# $t0: Direccion del buffer
# $t1: Direccion carnet
# $t2: Caracter actual
# $t3: Direccion del nombre
# $t4: Direccion del indice
# $t5: Direccion del credito
# $t6: Contador

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
li $t7, 100
move $a0, $t7
jal TablaHash_crear

la $t0, buffer
for_linea:

    # Reservar la memoria para el carnet
    li $v0, 9
    li $a0, 9
    syscall

    bltz $v0, error
    move $t1, $v0

    # Guarda el carnet
    for_carnet:
        lb $t2, ($t0)
        
        # Si es una comilla, termina el carnet
        beq $t2, 34 for_carnet_fin
        
        sb $t2, ($v0)

        add $v0, $v0, 1
        add $t0, $t0, 1

        b for_carnet
    
    for_carnet_fin:
        sb $zero, ($v0)
        add $t0, $t0, 1 # Saltar comilla
    
    # Reservar la memoria para el nombre
    li $v0, 9
    li $a0, 21
    syscall

    bltz $v0, error
    move $t3, $v0
    
    # Guarda el nombre
    for_nombre:
        lb $t2, ($t0)

        # Si es una comilla, termina el nombre
        beq $t2, 34 for_nombre_fin

        sb $t2, ($v0)
        
        add $v0, $v0, 1
        add $t0, $t0, 1

        b for_nombre

    for_nombre_fin:
        sb $zero, ($v0)
        add $t0, $t0, 1 # Saltar comilla

    # Reservar la memoria para el indice
    li $v0, 9
    li $a0, 7
    syscall

    bltz $v0, error
    move $t4, $v0

    # Guarda el indice
    li $t6, 6
    for_indice:
        lb $t2, ($t0)
        sb $t2, ($v0)

        add $v0, $v0,  1
        add $t0, $t0,  1
        add $t6, $t6, -1

        bnez $t6, for_indice

    for_indice_fin:
        sb $zero, ($v0)

    # Reservar la memoria para los creditos
    li $v0, 9
    li $a0, 4
    syscall

    bltz $v0, error
    move $t5, $v0

    # Guarda los creditos
    li $t6, 3
    for_creditos:
        lb $t2, ($t0)
        sb $t2, ($v0)

        add $v0, $v0,  1
        add $t0, $t0,  1
        add $t6, $t6, -1

        bnez $t6, for_creditos

    for_creditos_fin:
        sb $zero, ($v0)
    
    add $t0, $t0, 1 # Salta \n

    li $v0, 4
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, newl
    syscall

    li $v0, 4
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, newl
    syscall

    li $v0, 4
    move $a0, $t4
    syscall

    li $v0, 4
    la $a0, newl
    syscall

    li $v0, 4
    move $a0, $t5
    syscall

    li $v0, 4
    la $a0, newl
    syscall
    
    lb $t2, ($t0)

    # Crear Estudiante
    move $a0, $t1
    move $a1, $t3
    move $a2, $t4
    move $a3, $t5
    jal Estudiante_crear

    # Tabla
    lw   $a1, ($v0) # Clave
    move $a2,  $v0  # Valor
    
    # Guardar el estudiante en la tabla
    jal TablaHash_insertar
    
    bnez $t2, for_linea

# Por cada linea:
    # syscall 9 (16 bytes) [verificar]
    # 8 chars:
        # Guardar carnet
    # do while != “”:
        # Guardar nombre
    # 6 chars:
        # Guardar indice
    # 3 chars:
        # Guardar creditosAprob
    # Crear estudiante(carnet, nombre, indice, creditos Aprob)
    # <TablaHash Estudiantes>.insertar(carnet, Estudiante)
	
# ------------ MATERIAS ---------------

# Abrir archivo

# Verificar v0
# Leer archivo ($v0=14) ($a0=$v0)
# Verificar v0 

# <TablaHash Materias>.crear()

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


fin:

    li $v0, 10               
    syscall

.include "Estudiante.s"
.include "TablaHash.s"
.include "Lista.s"