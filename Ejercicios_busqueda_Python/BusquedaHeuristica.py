from __future__ import annotations

import heapq
from dataclasses import dataclass, field

from OchoPiezas import (
    aplicaOperador,
    calcularHeuristica,
    coste,
    estadoInicial,
    esValido,
    operadores,
    tEstado,
    testObjetivo,
)


@dataclass(order=True)
class Nodo:
    heuristica: int
    estado: tEstado = field(compare=False)
    operador: int = field(compare=False)
    costeCamino: int = field(compare=False)
    profundidad: int = field(compare=False)
    padre: Nodo | None = field(compare=False)

    # Creacion del hash de si mismo
    def __hash__(self) -> int:
        return hash(self.estado.crearHash())


def NodoInicial(tipoHeurisitca: int = 0) -> Nodo:
    return Nodo(calcularHeuristica(estadoInicial()), estadoInicial(), 0, 0, 0, None)


def dispCamino(nodo: Nodo) -> None:
    lista = []
    aux = nodo

    print("Estado inicial: \n", estadoInicial().t, "\n")

    while aux.padre is not None:
        lista.append(aux)
        aux = aux.padre

    for nodo in lista[::-1]:
        if nodo.operador in operadores:
            print("Movimiento hacia: ", operadores[nodo.operador], "\n", nodo.estado.t)
            print()


def dispSolucion(nodo: Nodo):
    dispCamino(nodo)
    print("Profundidad: ", nodo.profundidad)
    print("Coste: ", nodo.costeCamino)


def expandir(nodo: Nodo, tipoHeurisitca: int = 0) -> list:
    sucesores = []

    for op in operadores.keys():
        if esValido(op, nodo.estado):
            sig = aplicaOperador(op, nodo.estado)
            suc = Nodo(
                calcularHeuristica(sig, tipoHeurisitca),
                sig,
                op,
                nodo.costeCamino + coste(op, nodo.estado),
                nodo.profundidad + 1,
                nodo,
            )
            sucesores.append(suc)

    return sucesores


# Por tema de graficas en apartados mas adelante, las busquedas de estos apartados si devolveran datos
# Se imprimira igualmente la solucion, pero devolveran
# costeCamino: Coste camino al destino
# generados: Nodos generados
# visitados: nodos visitados
# MaximaL: Maxima longitud de abiertos

# heurisistica por defecto piezas mal colocadas


# Greedy: Compara solo usando la heurisitca
def Greedy(tipoHeurisitca: int = 0, *, disp: bool = False) -> tuple[int, int, int, int]:
    objetivo = False

    raiz = NodoInicial(tipoHeurisitca)
    abiertos: list[Nodo] = []
    sucesores: list[Nodo] = []
    cerrados: dict[Nodo, int] = {}
    heapq.heappush(abiertos, raiz)

    generados = 1
    visitados = 0
    MaximaL = 0
    while not objetivo and abiertos:
        raiz = heapq.heappop(abiertos)
        visitados += 1
        objetivo = testObjetivo(raiz.estado)
        if not objetivo and (raiz not in cerrados or cerrados[raiz] > raiz.costeCamino):
            cerrados[raiz] = raiz.costeCamino
            sucesores = expandir(raiz, tipoHeurisitca)
            generados += len(sucesores)
            for nodo in sucesores:
                heapq.heappush(abiertos, nodo)
            MaximaL = max(MaximaL, len(abiertos))
    if disp:
        if objetivo:
            dispSolucion(raiz)
        elif not objetivo:
            print("No se ha encontrado solución")
    return raiz.costeCamino, generados, visitados, MaximaL


# AEstrella: Greedy + coste hasta el moemento
def AEstrella(
    tipoHeurisitca: int = 0, *, disp: bool = False
) -> tuple[int, int, int, int]:
    objetivo = False

    raiz = NodoInicial(tipoHeurisitca)
    abiertos: list[Nodo] = []
    sucesores: list[Nodo] = []
    cerrados: dict[Nodo, int] = {}
    heapq.heappush(abiertos, raiz)

    generados = 1
    visitados = 0
    MaximaL = 0
    while not objetivo and abiertos:
        raiz = heapq.heappop(abiertos)
        visitados += 1
        objetivo = testObjetivo(raiz.estado)
        if not objetivo and (raiz not in cerrados or cerrados[raiz] > raiz.costeCamino):
            cerrados[raiz] = raiz.costeCamino
            sucesores = expandir(raiz, tipoHeurisitca)
            generados += len(sucesores)
            for nodo in sucesores:
                nodo.heuristica += nodo.costeCamino
                heapq.heappush(abiertos, nodo)
            MaximaL = max(MaximaL, len(abiertos))
    if disp:
        if objetivo:
            dispSolucion(raiz)
        elif not objetivo:
            print("No se ha encontrado solución")
    return raiz.costeCamino, generados, visitados, MaximaL
