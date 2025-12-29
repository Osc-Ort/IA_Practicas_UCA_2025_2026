# Plantilla para los estados
from dataclasses import dataclass


@dataclass
class tEstado:
    def __init__(self):
        pass

    def __repr__(self) -> str:
        return ""

    def crearHash(self) -> str:
        return ""


operadores = {}


def estadoInicial() -> tEstado:  # type: ignore
    pass


def estadoObjetivo() -> tEstado:  # type: ignore
    pass


def aplicaOperador(op: int, estado: tEstado) -> tEstado:  # type: ignore
    pass


def esValido(op: int, estado: tEstado) -> bool:  # type: ignore
    pass


def testObjetivo(estado: tEstado) -> bool:  # type: ignore
    pass


def coste(operador: int, estado: tEstado) -> int:  # type: ignore
    pass


def calcularHeuristica(estado: tEstado) -> int:  # type: ignore
    pass
