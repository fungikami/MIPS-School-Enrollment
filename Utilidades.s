# Funcion: 
# Entrada: $a0: Buffer.
#          $a1: Tamanio del dato.
#          $a2: Booleano
#               1: itera hasta una comilla
#               2: itera hasta el tamanio del dato
# Salida:  $v0: Dir. del dato
#          $v1: Dir. del buffer actualizado      
# Planificacion de registros:
# $t0: 
# $t1: 
# $t2: 
guardar_dato:
    # Prologo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4

    # Reserva memoria 

guardar_dato_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

