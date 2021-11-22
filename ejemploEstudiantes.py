import namegenerator
from random import randint

with open('estudiantesRandom.txt', 'w') as fi:
    for i in range(250):
        # Genera carnet aleatorio
        fi.write(f'{randint(10, 21)}')
        fi.write('-')
        fi.write(f'{randint(10000, 20000)}')

        # Genera nombre aleatorio
        fi.write('"')
        fi.write(namegenerator.gen().split("-")[1])
        fi.write('"')

        # Genera indice aleatorio
        fi.write(f'{randint(1, 5)}')
        fi.write('.')
        fi.write(f'{randint(1000, 9999)}')

        # Genera número de creditos aleatorio
        fi.write(f'{randint(0, 9)}')
        fi.write(f'{randint(0, 9)}')
        fi.write(f'{randint(0, 9)}')
        fi.write('\n')