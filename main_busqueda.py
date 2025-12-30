from time import time

from Ejercicios_busqueda_Python.BusquedaHeuristica import AEstrella, Greedy
from Ejercicios_busqueda_Python.BusquedaNoInformada import BFS, DFS, DFSL, DFSLI


def main():
    for func in [Greedy, AEstrella]:
        ini = time()
        costeCamino, generados, visitados, MaximaL = func()
        fin = time()
        print(
            f"Para busqueda de tipo {func.__name__}, con un tiempo de {fin - ini}, los resultados han sido:"
        )
        print(
            f"El coste del camino a sido {costeCamino}, generando {generados} nodos, visitando {visitados} nodos y siendo la maxima longitud de abiertos {MaximaL}"
        )


if __name__ == "__main__":
    main()
