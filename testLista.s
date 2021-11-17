.data

newl:   .asciiz "\n"
ult:    .asciiz "Ultimo de la lista: "
prim:   .asciiz "Primero de la lista: "

.text

main:

    # Crear lista
    jal  Lista_crear
    bltz $v0, main_fin # verifica que fino
    move $s0, $v0      # $s0 = Lista

    # Insertar en orden [4, 1, 3, 2]
    move $a0, $s0
    li  $a1, 4
    jal Lista_insertar

    move $a0, $s0
    li   $a1, 1
    jal  Lista_insertar
    
    move $a0, $s0
    li  $a1, 3
    jal Lista_insertar

    move $a0, $s0
    li  $a1, 2
    jal Lista_insertar

    # -----------------------------------

    # Imprimir ultimo
    move $a0, $s0
    jal  Lista_ultimo
    move $t0, $v0

    li $v0, 4
    la $a0, ult
    syscall

    li $v0, 4
    la $a0, newl
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, newl
    syscall

    # Imprimir primero
    move $a0, $s0
    jal  Lista_primero
    move $t0, $v0

    li $v0, 4
    la $a0, prim
    syscall

    li $v0, 4
    la $a0, newl
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, newl
    syscall

    # ---------------------------
    # Sacar primero
    move $a0, $s0
    jal Lista_eliminarPrimero

     # Imprimir primero
    move $a0, $s0
    jal  Lista_primero
    move $t0, $v0

    li $v0, 4
    la $a0, prim
    syscall

    li $v0, 4
    la $a0, newl
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, newl
    syscall

    # ---------------------------
    # Sacar ultimo
    move $a0, $s0
    jal Lista_eliminarUltimo

    # Imprimir ultimo
    move $a0, $s0
    jal  Lista_ultimo
    move $t0, $v0

    li $v0, 4
    la $a0, ult
    syscall

    li $v0, 4
    la $a0, newl
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, newl
    syscall

main_fin:
    li $v0, 10
    syscall

.include "Lista.s"