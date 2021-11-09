# Proyecto 1
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data
hola: .asciiz "Hello World \n"

# TODO

        .text

# Planificación de registros

# Crea la estructura de datos de materia
li $t0 1 # Carga mi nota en CI3815
addi $t0 $t1 $t2 # Suma las notas

sw $t0 P
li $v0, 4				
la $a0, hola
syscall