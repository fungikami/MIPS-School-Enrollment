# Estudiante.s
#
# Estructura de datos que implementa el TAD
# Estudiante.
# 
# carnet:   String con el carnet del estudiante.
# nombre:   String con el nombre del estudiante.
# indice:   String con el indice del estudiante.
# creditos: Entero con la cantidad de creditos
#           aprobados.
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 25-nov-2021

        .data

        .text

# Funcion crear
# Crea un Estudiante con los parametros dados.
# Entrada:   $a0: carne
#            $a1: nombre.
#            $a2: indice.
#            $a3: creditos.
# Salida:    $v0: Estudiante (negativo si no se pudo crear).
#          ($v0): carne. 
#         4($v0): nombre.
#         8($v0): indice.
#        12($v0): creditos.
#
# Planificacion de registros:
# $t0: carne del estudiante.
Estudiante_crear:
    # Prologo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    # Guarda el valor de $a0 temporalmente.
    move $t0, $a0

    # Asigna memoria para el Estudiante.
    li $a0, 16
    li $v0, 9
    syscall

    bltz $v0, Estudiante_crear_fin

    # Inicializa el Estudiante.
    sw $t0    ($v0)
    sw $a1,  4($v0)
    sw $a2,  8($v0)
    sw $a3, 12($v0)
    
Estudiante_crear_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra