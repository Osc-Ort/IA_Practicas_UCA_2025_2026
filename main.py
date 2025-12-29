from Ejercicios_busqueda_Python.BusquedaHeuristica import Greedy
from Ejercicios_busqueda_Python.BusquedaNoInformada import BFS, DFS, DFSL, DFSLI


def main():
    costeCamino, generados, visitados, MaximaL = Greedy(1)
    print(
        f"El coste del camino a sido {costeCamino}, generando {generados} nodos, visitando {visitados} nodos y siendo la maxima longitud de abiertos {MaximaL}"
    )


if __name__ == "__main__":
    main()
