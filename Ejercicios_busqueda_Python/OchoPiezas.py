# Formalización del puzzle de ocho piezas
from dataclasses import dataclass

import numpy as np


@dataclass
class tEstado:
    t: np.ndarray
    N: int
    fila: int
    columna: int

    def __init__(self, tablero: np.ndarray):
        self.t = tablero
        self.N = tablero.shape[0]
        self.fila, self.columna = np.where(tablero == 0)  # type: ignore

    def __repr__(self) -> str:
        return f"{self.t}\nFila hueco: {self.fila}\nColumna hueco: {self.columna}\n"

    def crearHash(self) -> str:
        return f"{self.t.tobytes()}{self.fila}{self.columna}"


operadores = {8: "ARRIBA", 2: "ABAJO", 4: "IZQDA", 6: "DRCHA"}


def estadoInicial() -> tEstado:
    # return tEstado(np.array([[0, 2, 3], [1, 4, 5], [8, 7, 6]]))
    return tEstado(
        np.array([[0, 2, 3], [1, 4, 5], [8, 7, 6]])
    )  # Pruebe esta combinación tras haber comprobado la anterior


def estadoObjetivo() -> tEstado:
    # return tEstado(np.array([[1, 2, 3], [0, 4, 5], [8, 7, 6]]))
    return tEstado(
        np.array([[1, 3, 0], [8, 2, 4], [7, 6, 5]])
    )  # Pruebe esta combinación tras haber comprobado la anterior


def aplicaOperador(op: int, estado: tEstado) -> tEstado:
    nuevo = tEstado(estado.t.copy())
    x, y = nuevo.fila, nuevo.columna
    match operadores[op]:
        case "ABAJO":
            ant = nuevo.t[x + 1, y]
            nuevo.t[x, y] = ant
            nuevo.t[x + 1, y] = 0
            x += 1
        case "ARRIBA":
            ant = nuevo.t[x - 1, y]
            nuevo.t[x, y] = ant
            nuevo.t[x - 1, y] = 0
            x -= 1
        case "DRCHA":
            ant = nuevo.t[x, y + 1]
            nuevo.t[x, y] = ant
            nuevo.t[x, y + 1] = 0
            y += 1
        case "IZQDA":
            ant = nuevo.t[x, y - 1]
            nuevo.t[x, y] = ant
            nuevo.t[x, y - 1] = 0
            y -= 1
    nuevo.fila, nuevo.columna = x, y
    return nuevo


def esValido(op: int, estado: tEstado) -> bool:
    valido = False
    match operadores[op]:
        case "ABAJO":
            valido = estado.fila < estado.N - 1
        case "ARRIBA":
            valido = estado.fila > 0
        case "DRCHA":
            valido = estado.columna < estado.N - 1
        case "IZQDA":
            valido = estado.columna > 0
    return valido


def testObjetivo(estado: tEstado) -> bool:
    return (estado.t == estadoObjetivo().t).all()


def coste(operador: int, estado: tEstado) -> int:
    return 1
