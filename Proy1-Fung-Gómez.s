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

    # 

fin:
    # Abortar si no se pudo abrir el archivo