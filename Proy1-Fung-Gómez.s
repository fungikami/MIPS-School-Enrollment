# Proyecto 1
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data

arcEst:	.asciiz "caso1-Estudiantes.txt"
arcMat:	.asciiz "caso1-Materias.txt"	
arcIns:	.asciiz "caso1-SolInscripcion.txt"
arcCor:	.asciiz "caso1-SolCorreccion.txt"
arcTen: .asciiz "caso1-InsTentativa.txt"
arcDef:	.asciiz "caso1-InsDefinitiva.txt"

        .text

# Planificación de registros

main:
    # Abrir archivo
    li $v0 13
    lw $a0 arcEst
    li $a1 0
    syscall # Retorna $v0 (file descriptor)

    # Verificar si el archivo existe
    bltz $v0, fin
    move $a0 $v0 # Guarda el file descriptor en $a0

    # Leer archivo ($v0=14) ($a0=$v0)
    # Verificar $v0 < 0 (too malo)

    # Crear <estructura Estudiantes>

    # Por cada línea:
        # Crear estudiante
        # 8 chars:
            # Guardar estudiante.carnet
        # do while != “”:
            # Guardar estudiante.nombre
        # 6 chars:
            # Guardar estudiante.indice
        # 3 chars:
            # Guardar estudiante.creditosAprov
        
    # <estructura Estudiantes>.append(estudiante)

    # ------------ MATERIAS ---------------

    # Abrir archivo
    li $v0 13
    lw $a0 arcInst
    li $a1 0
    syscall # Retorna $v0 (file descriptor)

    move $a0 $v0

    # Verificar $v0 < 0 (too malo)
    # Leer archivo ($v0=14) ($a0=$v0)
    # Verificar $v0 < 0 (too malo)




    # Por cada línea:
        # Crear materia
        # 7 chars:
            # Guardar materia.codigo
        # do while != “”:
            # Guardar materia.nombre
        # 1 chars:
            # Guardar materia.creditos
        # 3 chars:
            # Guardar materia.cupos
        # 3 chars:
            # Guardar materia.creditos
        
        # <estructura Materia>.append(materia)

    # ------------ SOLICITUDES ---------------

    # Abrir archivo
    li $v0 13
    lw $a0 arcSol
    li $a1 0
    syscall # Retorna $v0 (file descriptor)

    move $a0 $v0

    # Verificar $v0 < 0 (too malo)
    # Leer archivo ($v0=14) ($a0=$v0)
    # Verificar $v0 < 0 (too malo)

    # Por cada línea:
        # Crear solicitud
        # 8 chars:
            # Guardar solicitud.carnet
            # Hacer estudiante.numSolicitudes++
    # 7 chars:
            # Guardar solicitud.codigo
            # Hacer estudiante.creditosInscribiendo++

        # <estructura Solicitud>.append(solicitud)

    # Procesar vainas

    # Escribir archivo tentativo

    # Abrir solicitudes de corrección

    # Procesar vainas

    # Escribir archivo definitivo


fin:
    # Abortar si no se pudo abrir el archivo