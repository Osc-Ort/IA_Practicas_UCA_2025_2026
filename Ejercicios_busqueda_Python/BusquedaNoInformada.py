from __future__ import annotations

from collections import deque
from dataclasses import dataclass

from .OchoPiezas import (
    aplicaOperador,
    coste,
    estadoInicial,
    esValido,
    operadores,
    tEstado,
    testObjetivo,
)


@dataclass
class Nodo:
    estado: tEstado
    operador: int
    costeCamino: int
    profundidad: int
    padre: Nodo | None

    # Creacion del hash de si mismo
    def __hash__(self) -> int:
        return hash(self.estado.crearHash())

    def __eq__(self, otro) -> bool:
        if not isinstance(otro, Nodo):
            return False
        return self.estado.crearHash() == otro.estado.crearHash()


def NodoInicial() -> Nodo:
    return Nodo(estadoInicial(), 0, 0, 0, None)


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


def expandir(nodo: Nodo) -> list:
    sucesores = []

    for op in operadores.keys():
        if esValido(op, nodo.estado):
            suc = Nodo(
                aplicaOperador(op, nodo.estado),
                op,
                nodo.costeCamino + coste(op, nodo.estado),
                nodo.profundidad + 1,
                nodo,
            )
            sucesores.append(suc)

    return sucesores


# Exploracion en anchura con control de estados repetidos y optimizacion de inserción
def BFS() -> None:
    objetivo = False

    raiz = NodoInicial()
    abiertos: deque[Nodo] = deque()
    sucesores: list[Nodo] = []
    cerrados: set[Nodo] = set()
    abiertos.append(raiz)

    while not objetivo and abiertos:
        raiz = abiertos.popleft()
        objetivo = testObjetivo(raiz.estado)
        if not objetivo and raiz not in cerrados:
            cerrados.add(raiz)
            sucesores = expandir(raiz)
            abiertos.extend(sucesores)
    if objetivo:
        dispSolucion(raiz)
    elif not objetivo:
        print("No se ha encontrado solución")


# Exploracion en profundidad con control de estados repetidos y optimizacion de insercion
def DFS() -> None:
    objetivo = False

    raiz = NodoInicial()
    abiertos: deque[Nodo] = deque()
    sucesores: list[Nodo] = []
    cerrados: set[Nodo] = set()
    abiertos.append(raiz)

    while not objetivo and abiertos:
        raiz = abiertos.popleft()
        objetivo = testObjetivo(raiz.estado)
        if not objetivo and raiz not in cerrados:
            cerrados.add(raiz)
            sucesores = expandir(raiz)
            abiertos.extendleft(reversed(sucesores))
    if objetivo:
        dispSolucion(raiz)
    elif not objetivo:
        print("No se ha encontrado solución")


# Búsqueda en profundidad con limite, se cambia a diccionario cerrados por si otra rama mas corta existe
def DFSL(limiteMax: int = 10) -> None:
    objetivo = False

    raiz = NodoInicial()
    abiertos: deque[Nodo] = deque()
    sucesores: list[Nodo] = []
    cerrados: dict[Nodo, int] = {}
    abiertos.append(raiz)

    while not objetivo and abiertos:
        raiz = abiertos.popleft()
        objetivo = testObjetivo(raiz.estado)
        if (
            not objetivo
            and (raiz not in cerrados or cerrados[raiz] > raiz.costeCamino)
            and raiz.costeCamino < limiteMax
        ):
            cerrados[raiz] = raiz.costeCamino
            sucesores = expandir(raiz)
            abiertos.extendleft(reversed(sucesores))
    if objetivo:
        dispSolucion(raiz)
    elif not objetivo:
        print("No se ha encontrado solución")


# Busqueda en profundidad con limite iterativo
def DFSLI() -> None:
    objetivo = False

    raiz = NodoInicial()
    abiertos: deque[Nodo] = deque()
    sucesores: list[Nodo] = []
    cerrados: dict[Nodo, int] = {}
    abiertos.append(raiz)

    limiteMax = 0

    while not objetivo and limiteMax < 10**6:
        while not objetivo and abiertos:
            raiz = abiertos.popleft()
            if raiz.profundidad == limiteMax:
                objetivo = testObjetivo(raiz.estado)
            elif raiz not in cerrados or cerrados[raiz] > raiz.costeCamino:
                cerrados[raiz] = raiz.costeCamino
                sucesores = expandir(raiz)
                abiertos.extendleft(reversed(sucesores))
        if not objetivo:
            cerrados.clear()
            abiertos.append(NodoInicial())
            limiteMax += 1
    if objetivo:
        dispSolucion(raiz)
    elif not objetivo:
        print("No se ha encontrado solución")
