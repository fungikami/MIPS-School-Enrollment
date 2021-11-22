# Proyecto 1
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

arcEst:	.asciiz "/home/chus/Documents/Orga/proyecto1/ejemplo-Estudiantes.txt"
arcMat:	.asciiz "ejemplo-Materias.txt"
arcIns:	.asciiz "ejemplo-SolInscripcion.txt"
arcCor:	.asciiz "ejemplo-SolCorreccion.txt"
arcTen: .asciiz "ejemplo-InsTentativa.txt"
arcDef:	.asciiz "ejemplo-InsDefinitiva.txt"

buffer: .space 1024
error1: .asciiz "No se pudo abrir el archivo"

        .text
main:
# ------------ ESTUDIANTES ---------------

# Abrir archivo

# Verificar v0 
# Leer archivo ($v0=14) ($a0=$v0)
# Verificar v0 

# <TablaHash Estudiantes>.crear()

# Por cada línea:
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

# Por cada línea:
    # syscall 9 (24 bytes) [verificar]
    # Crear materia
    # 7 chars:
        # Guardar código
    # do while != “”:
        # Guardar nombre
    # 1 chars:
        # Guardar créditos
    # 3 chars:
        # Guardar cupos
    # 3 chars:
        # Guardar minimoCréditos
    # Crear Materia(código, nombre, créditos, cupos, minimoCreditos, <Lista Estudiantes>.crear())
    # <TablaHash Materias>.insertar(código, Materia)


# ------------ SOLICITUDES ---------------

# Abrir archivo

# Verificar $v0
# Leer archivo ($v0=14) ($a0=$v0)
# Verificar $v0

# <Lista Solicitudes>.crear()

# Por cada línea:
    # syscall 9 (9 bytes) [verificar]
    # Crear solicitud
    # 8 chars:
        # Guardar carnet
        #  Estudiante = <TablaHash Estudiante>.buscar[carnet]
   # 7 chars:
        # Guardar codigo
        # Materia = <TablaHash Materias>.buscar([código])
   # Crear Solicitud(Estudiante, Materia, ‘S’)
   # <Lista Solicitudes>.insertar(Solicitud)

# ---------------- INSCRIPCIÓN ------------------

# for solicitud in <Lista Solicitudes>
#     solicitud.Materia.Estudiantes.insertar(Pair<solicitud.Estudiante, Op.>)
#     solicitud.Materia.cupo--

# ------------- ARCHIVO TENTATIVO --------------------
# for Materia in <TablaHash Materias>
# 	print Materia
#	for Estudiante in Materia.Estudiantes
#		print Estudiante.primero


# -------- SOLICITUDES CORRECCIÓN---------------
# Abrir archivo

# Verificar $v0
# Leer archivo ($v0=14) ($a0=$v0)
# Verificar $v0

# <Lista Solicitudes>.crear()

# Por cada línea:
    # syscall 9 (9 bytes) [verificar]
    # Crear solicitud
    # 8 chars:
        # Guardar carnet
        #  Estudiante = <TablaHash Estudiante>.buscar[carnet]
   # 7 chars:
        # Guardar codigo
        # Materia = <TablaHash Materias>.buscar([código])
   # 1 char:
       # Guardar operación
   # Crear Solicitud(Estudiante, Materia, op)
   # <Lista Solicitudes>.insertar(Solicitud)


# ---------------- CORRECCIÓN ------------------
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
#	prioridad = solicitud.Estudiante.créditosAprob
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
	li $v0 4        
    la $a0 error1
    syscall

fin:
    li $v0 10               
    syscall