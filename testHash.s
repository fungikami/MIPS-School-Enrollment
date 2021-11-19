        .data

clave:  .asciiz "18-10894"

        .text

# Para 37 buckets (sin mod sucesivamente)
# a        -> 144 (20)  
# b        ->  28 ( 7)
# c        ->  60 (15)
# aa       -> 112 (28)
# ab       -> 144 (20) !!!
# ba       ->  72 (18)
# bb       -> 104 (26)
# 18-10892 ->  64 (16)
# 18-10492 ->  12 ( 3)
# 18-10888 ->   0 ( 0)
# 19-10244 -> 144 (20) !!
# 19-10245 ->  28 ( 7) !!
# 19-10246 ->  60 (15) !!

main:

    li $a0, 37
    la $a1, clave

TablaHash_hash_loop:
    lb $t1, ($a1)

    beqz $t1, TablaHash_hash_loop_fin

    # acc = (acc << 4) + (clave[i])
    sll $t0, $t0, 4   
    add $t0, $t0, $t1 
    
    # g = acc & 0xF0000000
    andi $t2, $t0, 0xF000
    
    # if (g != 0) acc ^= g >>> 24;
    beqz $t2, saltar
    srl $t3, $t2, 24
    xor $t0, $t0, $t3
    
saltar:

    addi $a1, $a1, 1
    b TablaHash_hash_loop

TablaHash_hash_loop_fin:
    # Calcula hash
    abs $t0, $t0      # |acc|
    rem $t0, $t0, $a0 # hi = modulo = acc % numBuckets

    li $v0, 1
    move $a0, $t0
    syscall

    # https://cseweb.ucsd.edu/~kube/cls/100/Lectures/lec16/lec16-16.html#pgfId-977548