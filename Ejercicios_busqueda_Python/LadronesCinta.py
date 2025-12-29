# Formalización del problema de los ladrones y la cinta automática
from collections import deque
from copy import deepcopy
from dataclasses import dataclass


@dataclass
class tEstado:
    cinta: deque[int]
    N: int
    din_ladrones: int
    din_policia: int

    def __init__(self, cinta: list[int], dinLad: int = 0, dinPol: int = 0):
        self.cinta = deque(cinta)
        self.N = len(cinta)
        self.din_ladrones, self.din_policia = dinLad, dinPol

    def __repr__(self) -> str:
        return f"{[el for el in self.cinta]}\nDinero ladrones: {self.din_ladrones}\nDinero policia: {self.din_policia}\n"

    def crearHash(self) -> str:
        return f"{self.cinta}{self.din_ladrones}{self.din_policia}"


operadores = {0: "IZQ", 1: "DER"}


def estadoInicial() -> tEstado:
    return tEstado([4, 3, 2, 5, 7, 1, 8, 6])


def estadoObjetivo() -> tEstado:
    return tEstado([])


def aplicaOperador(op: int, estado: tEstado) -> tEstado:
    nuevo = deepcopy(estado)
    match operadores[op]:
        case "IZQ":
            nuevo.din_ladrones += nuevo.cinta.popleft()
        case "DER":
            nuevo.din_ladrones += nuevo.cinta.pop()
    if nuevo.cinta:
        nuevo.din_policia += nuevo.cinta.pop()
    return nuevo


def esValido(op: int, estado: tEstado) -> bool:
    return len(estado.cinta) != 0


def testObjetivo(estado: tEstado) -> bool:
    return estado.cinta == estadoObjetivo().cinta


def coste(operador: int, estado: tEstado) -> int:
    return 1


def calcularHeuristica(estado: tEstado) -> int:
    return estado.din_policia - estado.din_ladrones
