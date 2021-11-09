# Proyecto 1
# 
# Autores: Ka Fung & Christopher Gómez
# Fecha: 25-nov-2021

        .data
hola: .asciiz "Hello World \n"

# TODO

        .text

# Planificación de registros
li $v0, 4				
la $a0, hola
syscall
