.data

newl:   .asciiz "\n"
ult:    .asciiz "Ultimo de la lista: "
prim:   .asciiz "Primero de la lista: "

.text

main:
    li $a0, -5122
    li $a1, 4
    jal itoa
    move $a0, $v0

    li $v0, 4
    syscall

    li $v0, 4
    la $a0, newl
    syscall

main_fin:
    li $v0, 10
    syscall

.include "Utilidades.s"