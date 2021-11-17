.data

newl:   .asciiz "\n"
msg:    .asciiz "Primero de la lista: "

.text

main:

    jal Lista_crear # Sv0 = Lista

    bltz $v0, main_fin

    li  $a0, 1
    jal Lista_insertar

    li  $a0, 4
    jal Lista_insertar
    
    li  $a0, 3
    jal Lista_insertar
    
    li  $a0, 2
    jal Lista_insertar

    jal Lista_primero

    li $v0, 4
    la $a0, msg
    syscall

    li $v0, 4
    la $a0, newl
    syscall

    li $v0, 1
    li $a0, 5
    syscall

main_fin:
    li $v0, 10
    syscall

.include "Lista.s"