# Funcion: 
# Entrada: $a0: Buffer.
#          $a1: Tamanio del dato.
#          $a2: Booleano
#               0: itera hasta el tamanio del dato
#               1: itera hasta una comilla
# Salida:  $v0: Dir. del dato
#          $v1: Dir. del buffer actualizado      
# Planificacion de registros:
# $t0: buffer
# $t1: tamanio de memoria a reservar
# $t2: dir. del dato
# $t3: caracter actual
guardar_dato:
    # Prologo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    move $t0, $a0

    # Reserva memoria
    li  $v0, 9
    add $a0, $a1, 1 
    syscall

    bltz $v0, guardar_dato_fin
    move $t2, $v0

    # Si se debe iterar hasta el tamanio del dato
    beqz $a2, guardar_hasta_tamanio

    # Si se debe iterar hasta comilla
    guardar_hasta_comilla:
        lb $t3, ($t0)

        # Si es una comilla o nulo, se termina 
        beq  $t3, 34, guardar_dato_fin
        beqz $t3, guardar_dato_fin

        sb $t3, ($t2)

        add $t0, $t0, 1
        add $t2, $t2, 1

        b guardar_hasta_comilla

    guardar_hasta_tamanio:
        lb $t3, ($t0)
        sb $t3, ($t2)

        add $t0, $t0,  1
        add $t2, $t2,  1
        add $a1, $a1, -1

        bnez $a1, guardar_hasta_tamanio

guardar_dato_fin:
    sb $zero, ($t2)

    # Retorna dato y buffer
    move $v1, $t0

    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

