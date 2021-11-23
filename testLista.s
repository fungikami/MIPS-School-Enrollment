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
    la $a2, comparar_numeros
    jal Lista_insertarOrdenado

    move $a0, $s0
    li   $a1, 1
    la $a2, comparar_numeros
    jal  Lista_insertarOrdenado
    
    move $a0, $s0
    li  $a1, 3
    la $a2, comparar_numeros
    jal Lista_insertarOrdenado

    move $a0, $s0
    li  $a1, 2
    la $a2, comparar_numeros
    jal Lista_insertarOrdenado

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

main_fin:
    li $v0, 10
    syscall

.include "Lista.s"

# $a0: Int, $a1: Int, retorna 0 si $a0 < $a1, 1 otherwise
comparar_numeros:
    # Prologo
    sw   $fp,    ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    move $v0, $zero
    blt $a0, $a1 comp_fin
    li  $v0, 1

comp_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra