# Utilidades.s
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 25-nov-2021


# Funcion: Abre y lee un archivo
# Entrada: $a0: Archivo.
#          $a1: Buffer.
#          $a2: Tamanio Buffer
# Salida:  $v0: negativo si no logro leer archivo     
# Planificacion de registros:
# $t0: buffer
# $t1: archivo
leer_archivo: 
    # Prologo
	sw   $fp,   ($sp)
    sw   $ra, -4($sp)
	move $fp,    $sp
	addi $sp,    $sp, -8

    move $t0, $a0   # Archivo
    move $t1, $a1   # Buffer
    move $t2, $a2   # Tamanio Buffer

    # Limpiar Buffer
    # move $a0, $t1
    # move $a1, $t2
    # jal limpiarBuffer

    # Abrir archivo para leer
    li $v0, 13
    move $a0, $t0
    li $a1, 0
    syscall

    bltz $v0, leer_archivo_fin
    move $a0, $v0

    # Leer archivo
    li $v0, 14
    move $a1, $t1
    move $a2, $t2
    syscall

    bltz $v0, leer_archivo_fin

    # Cerrar el archivo
    li $v0, 16
    syscall

leer_archivo_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)

    jr $ra


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
    # lb $t3, ($t0)
    # sb $t3, ($t2)
    # add $t0, $t0, 1
    # add $t2, $t2, 1
    guardar_hasta_comilla:
        lb $t3, ($t0)

        # Si es una comilla o nulo, se termina 
        beq  $t3, 34, guardar_dato_exitoso
        beqz $t3, guardar_dato_error

        sb $t3, ($t2)

        add $t0, $t0, 1
        add $t2, $t2, 1

        b guardar_hasta_comilla
    
    # guardar_hasta_comilla_fin:
    #     lb $t3, ($t0)
    #     sb $t3, ($t2)
    #     add $t0, $t0, 1
    #     add $t2, $t2, 1
    #     b guardar_dato_exitoso

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

# Funcion comparador
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
        li $v0, 1

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

# Funcion atoi
# Entrada: $a0: ASCII
#          $a1: # Caracteres a convertir
# Salida:  $v0: Entero
atoi:
    # Prologo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    move $v0, $zero
    move $t0, $a0
    
    atoi_loop:
        lb $t1, ($t0)

        add  $t0, $t0,  1
        add  $a1, $a1, -1
        
        blt  $t1, 48, atoi_loop # Caracter es < '0'
        bgt  $t1, 57, atoi_loop # Caracter es > '9'

        # Se multiplica $v0*10
        sll $t2, $v0, 3   # $t2 = 8  * $v0
        sll $v0, $v0, 1   # $v0 = 2  * $v0
        add $v0, $v0, $t2 # $v0 = 10 * $v0

        # Se suma el dígito
        add $t1, $t1, -48
        add $v0, $v0, $t1
        bnez $a1, atoi_loop
atoi_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra

# Funcion itoa
# Entrada: $a0: Entero
#          $a1: # Caracteres a convertir
# Salida:  $v0: ASCII null-terminated
# Planificación de registros:
# $t0: Caracter a agregar
# $t3: Dir. del buffer a retornar
# $t4: Copia del entero
# $t5: Dir. del buffer (para iterar)
# $t6: 10
itoa:
    # Prologo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    move $t4, $a0

    # Reserva memoria
    li  $v0, 9
    add $a0, $a1, 2
    syscall

    bltz $v0, itoa_fin
    move $t3, $v0
    move $t5, $t3

    bnez $t4, itoa_distinto_de_cero  # Si el entero es distinto de cero
    li   $t0,     '0'
    sb   $t0,    ($t3)
    sb   $zero, 1($t3)
    move $v0,     $t5
    b itoa_fin
    
itoa_distinto_de_cero:
    bgtz $t4, itoa_escribir_pos

    # Si es negativo, se agrega el signo y se convierte el entero a positivo
    li  $t0,  '-'
    sb  $t0, ($t3)
    add $t5,  $t3, 1
    abs $t4,  $t4, 1

itoa_escribir_pos:
    add $t5,    $t5, $a1
    sb  $zero, ($t5) # Guarda nulo al final de la string
    add $t5,    $t5, -1
    li  $t6,    10

itoa_loop:
    # Se itera hasta que el entero = 0
    div  $t4, $t6
    mflo $t4       # $t4 = $a0 / 10
    mfhi $t0       # $t0 = $a0 mod 10  

    add $t4, $t4, 48
    sb  $t4, ($t5) # Guarda el caracter en el buffer
    add $t5,  $t5
itoa_continuar:
    move $a0, $s0  
    jal itoa_recurse

itoa_escribir:
    add  $t1, $a1, $v0
    addi $v0, $v0, 1    
    addi $t2, $s1, 0x30 # convert to ASCII
    sb   $t2, 0($t1)    # store in the buffer
    sb   $zero, 1($t1)
  
itoa_fin:
    lw   $a1, 8($fp)
    lw   $a0, 4($fp)
    lw   $ra, -4($fp)
    lw   $s0, -8($fp)
    lw   $s1, -12($fp)
    lw   $fp, 8($sp)    
    addi $sp, $sp, 24
    jr $ra

itoa_loop:
    div $a0, 10
    mflo $t0           
    mfhi $t1 

itoa_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)

    jr $ra