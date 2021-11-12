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

# Planificación de registros

main:
# ------------ ESTUDIANTES ---------------

    # Abrir (para leer) archivo
    li $v0 13
    la $a0 arcEst
    li $a1 0
    syscall # Retorna $v0

    bltz $v0 error
    j fin
    
    # Leer archivo 
    move $a0 $v0
    li $v0 14
    la $a1 buffer   
    li $a2 1024     
    syscall

    # Verificar $v0 < 0 (too malo)
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

        # syscall 9 (52 bytes) [verificar]
        # sw $[carnet] ($v0)
        # sw $[nombre] 9($v0)
        # sw $[índice] 30($v0)
        # sw $[credAprov] 38($v0)
        # sw $zero 42($v0)
        # sw $zero 46($v0)
        # sw $zero 54($v0)
        


        # <dict de Estudiantes>.hash(estudiante)

    # ------------ MATERIAS ---------------

    # Abrir archivo
    # li $v0 13
    # lw $a0 arcInst
    # li $a1 0
    # syscall # Retorna $v0 (file descriptor)

    # move $a0 $v0

    # Verificar $v0 < 0 (too malo)
    # Leer archivo ($v0=14) ($a0=$v0)
    # Verificar $v0 < 0 (too malo)

    # Por cada línea:
        # Crear materia
        # 7 chars:
            # Guardar materia.código
        # do while != “”:
            # Guardar materia.nombre
        # 1 chars:
            # Guardar materia.créditos
        # 3 chars:
            # Guardar materia.cupos
        # 3 chars:
            # Guardar materia.miniCréditos


        # syscall 9 (51 bytes) [verificar]
        # sw $[código] ($v0)
        # sw $[nombre] 8($v0)
        # sw $[créditos] 39($v0)
        # sw $[cupos] 43($v0)
        # sw $[miniCréditos] 47($v0)
        # sw $[cabezaLista] 51($v0)
        
        # <dict de Materias>.hash(materia)

    # ------------ SOLICITUDES ---------------

    # Abrir archivo
    # li $v0 13
    # lw $a0 arcSol
    # li $a1 0
    # syscall # Retorna $v0 (file descriptor)

    # move $a0 $v0

    # Verificar $v0 < 0 (too malo)
    # Leer archivo ($v0=14) ($a0=$v0)
    # Verificar $v0 < 0 (too malo)

    # Por cada línea:
        # Crear solicitud
        # 8 chars:
            # Guardar solicitud.carnet
            # Hacer estudiante.numSolicitudes++
            # estudiantes[“18-10892”].numSolicitudes += 1

    # 7 chars:
            # Guardar solicitud.codigo
            # Hacer estudiante.creditosInscribiendo++

        # <estructura Solicitud>.append(solicitud)

        # syscall 9 (19 bytes) [verificar]
        # sw $[carnet] ($v0)
        # sw $[código] 9($v0)
        # sw $[corrección] 17($v0)
        # sw $[operación] 18($v0)

    # Procesar vainas

    # for estudiante in <dict Estudiantes>
    #     $t0 = calcularCreditoSocial(estudiante)
    #     <PriorityQueue>.append(estudiante, $t0)

    # Se va haciendo pop y actualizando las materias

    # Escribir archivo tentativo

    # Abrir solicitudes de corrección

    # Procesar vainas

    # Escribir archivo definitivo 

error:
	li $v0 4        
    la $a0 error1
    syscall

fin:
    li $v0 10               
    syscall
