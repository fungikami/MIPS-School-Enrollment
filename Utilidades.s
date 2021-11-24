# Utilidades.s
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 25-nov-2021

# Funcion: Reserva memoria y guarda un dato dado
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
	move $fp,  $sp
	addi $sp,  $sp, -4

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
        beq  $t3, 34, guardar_dato_exitoso
        beqz $t3, guardar_dato_error

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

guardar_dato_exitoso:
    sb $zero, ($t2)

    # Retorna dato y buffer
    move $v1, $t0

    b guardar_dato_fin

guardar_dato_error:
    li $v0, -1
    
guardar_dato_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

# Funcion comṕarador
# Compara dos strings 
# Entrada: $a0: String a comparar
#          $a1: String a comparar
# Salida:  $v0: 0 si a<b, 
#               1 de otra forma   
# Planificacion de registros:
comparador:
    # Prologo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    move $v0, $zero
    comparador_loop:
        lb $t0, ($a0)
        lb $t1, ($a1)

        # Si a < b, finaliza 
        blt $t0, $t1, comparador_fin

        addi $a0, $a0, 1
        addi $a1, $a1, 1

        # Si a == b, revisar el siguiente
        beq $t0, $t1, comparador_loop

        # Si a > b, retorna -1
        li $v0, -1

comparador_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra

# Funcion limpiarBuffer
# Limpia el buffer (redactar)
# Entrada: $a0: Dir. del buffer a limpiar
#          $a1: Tamaniop del buffer a comparar (multiplo de 4)
# Salida:  $v0: Dir. del buffer
# Planificacion de registros:
limpiarBuffer:
    # Prologo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    srl  $a1, $a1, 2 # Divide entre 4 el tamanio del buffer
    move $v0, $a0
    limpiarBuffer_ciclo:
        beqz $a1, limpiarBuffer_fin

        sw $zero, ($a0)
        
        add $a0, $a0,  4
        add $a1, $a1, -1
        b limpiarBuffer_ciclo

limpiarBuffer_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra