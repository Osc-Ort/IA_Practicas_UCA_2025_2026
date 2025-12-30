from __future__ import annotations

from copy import deepcopy
from dataclasses import dataclass

import numpy as np


@dataclass
class Nodo:
    tablero: np.ndarray
    vacias: int
    N: int

    def __init__(self, tablero: np.ndarray):
        self.tablero = tablero
        self.N = self.tablero.shape[0]
        self.vacias = len(np.where(tablero == 0)[0])

    def __str__(self) -> str:
        # Función para representar el nodo en forma de cadena (se llama a esta función al hacer print).
        # Se utiliza el diccionario para utilizar la visualización a través de simbolos

        visual = {1: "X", -1: "O", 0: " "}
        string = f"{' ----+----+----'}\n|"
        for i in range(self.tablero.shape[0]):
            for j in range(self.tablero.shape[1]):
                if self.tablero[i, j] == 0:
                    string += "    |"
                else:
                    string += f" {visual[self.tablero[i, j]]} |"
            if i == 2 and j == 2:
                string += "\n ----+----+----\n"
            else:
                string += "\n ----+----+----\n|"
        return f"{string}"


@dataclass
class Jugada:
    x: int
    y: int

    def __str__(self):
        return f"\nFila: ({self.x}, Col: {self.y})"


######
# Se crean todas las posibles jugadas para el for de rango (for jugada in jugadas)
jugadas: list[Jugada] = []
for i in range(0, 3):
    for j in range(0, 3):
        jugadas.append(Jugada(i, j))
######


""" Funciones complementarias
    * crearNodo
    * nodoInicial
    * opuesto
"""


def crearNodo(tablero):
    return Nodo(tablero)


def nodoInicial():
    tablero_inicial = np.zeros((3, 3))
    return Nodo(tablero_inicial)


def opuesto(jugador):
    return jugador * -1


""" Funciones Búsqueda MiniMax
    * aplicaJugada
    * esValida
    * terminal
    * utilidad
"""


def aplicaJugada(actual: Nodo, jugada: Jugada, jugador: int) -> Nodo:
    """Realiza una copia del nodo recibido como parámetro y aplica la jugada indicada,
    modificando para ello los atributos necesarios. Para esto, se tiene en cuenta qué
    jugador realiza la jugada.

    Args:
        actual (Nodo)
        jugada (Jugada)
        jugador (int)

    Raises:
        NotImplementedError: Mientras que no termine de implementar esta función,
        puede mantener esta excepción. Quítela cuando implemente la función

    Returns:
        Nodo: Contiene la información del nuevo estado del juego.
    """
    nuevo = deepcopy(actual)
    nuevo.tablero[jugada.x, jugada.y] = jugador
    nuevo.vacias -= 1
    return nuevo


def esValida(actual: Nodo, jugada: Jugada) -> bool:
    """Comprueba si dada una Jugada, es posible aplicarla o no. Evite la instrucción 'jugada in jugadas'
    para la comprobación ya que no tiene por qué estar incluida una lista de posibles jugadas. Por tanto,
    use las operaciones lógicas para verificar la validez de la jugada.

    Args:
        actual (Nodo)
        jugada (Jugada)

    Raises:
        NotImplementedError: Mientras que no termine de implementar esta función,
        puede mantener esta excepción. Quítela cuando implemente la función

    Returns:
        bool: Devuelve True en caso de que pueda realizarse la Jugada, False en caso contrario
    """
    return (
        actual.vacias > 0
        and 0 <= jugada.x < actual.N
        and 0 <= jugada.y < actual.N
        and actual.tablero[jugada.x, jugada.y] == 0
    )


def terminal(actual: Nodo) -> bool:
    """Comprueba si el juego se ha acabado, ya sea porque alguno de los jugadores ha ganado o bien porque no
    sea posible realizar ningún movimiento más.

    Args:
        actual (Nodo)

    Raises:
        NotImplementedError: Mientras que no termine de implementar esta función,
        puede mantener esta excepción. Quítela cuando implemente la función

    Returns:
        bool: Devuelve True en caso de Terminal, False en caso contrario
    """
    if actual.vacias == 0:
        return True
    tablero = actual.tablero.flatten()
    termin = False
    # Filas y columnas
    i = 0
    while i < actual.N and not termin:
        termin = (
            termin
            or tablero[i * actual.N]
            == tablero[i * actual.N + 1]
            == tablero[i * actual.N + 2]
            != 0
        )
        termin = termin or tablero[i] == tablero[i + 3] == tablero[i + 6] != 0
        i += 1

    # Diagonales
    termin = (
        termin
        or tablero[0] == tablero[4] == tablero[8] != 0
        or tablero[2] == tablero[4] == tablero[6] != 0
    )

    return termin


def utilidad(nodo: Nodo) -> int:
    """La función de utilidad, también llamada objetivo, asigna un valor numérico al nodo recibido como parámetro.
    Por ejemplo, en un juego de 'Suma cero', se puede establecer que devuelve -100, 0, 100 en función de qué jugador gana o bien si hay un empate.

    Args:
        nodo (Nodo)

    Raises:
        NotImplementedError: Mientras que no termine de implementar esta función,
        puede mantener esta excepción. Quítela cuando implemente la función.

    Returns:
        int: Valor de utilidad
    """
    tablero = nodo.tablero.flatten()
    utilidad = 0
    # Filas y columnas
    i = 0
    while i < nodo.N and utilidad == 0:
        if (
            tablero[i * nodo.N]
            == tablero[i * nodo.N + 1]
            == tablero[i * nodo.N + 2]
            != 0
        ):
            utilidad = tablero[i * nodo.N] * 100
        if tablero[i] == tablero[i + 3] == tablero[i + 6] != 0:
            utilidad = tablero[i] * 100
        i += 1
    if utilidad == 0:
        if tablero[0] == tablero[4] == tablero[8] != 0:
            utilidad = tablero[0] * 100
        elif tablero[2] == tablero[4] == tablero[6] != 0:
            utilidad = tablero[2] * 100
    return utilidad


def heurisitca(nodo: Nodo) -> int:
    tablero = nodo.tablero.flatten()
    cnt = 0

    def comprobacion(lista: list[int]) -> int:
        res = 0
        if not lista.count(0) == len(lista) and ((-1 in lista) ^ (1 in lista)):
            if 1 in lista:
                res = 1
            else:
                res = -1
        return res

    for i in range(nodo.N):
        col = [tablero[i * nodo.N], tablero[i * nodo.N + 1], tablero[i * nodo.N + 2]]
        fil = [tablero[i], tablero[i + nodo.N], tablero[i + nodo.N * 2]]
        cnt += comprobacion(col) + comprobacion(fil)

    dig1 = [tablero[0], tablero[4], tablero[8]]
    dig2 = [tablero[2], tablero[4], tablero[6]]
    cnt += comprobacion(dig1) + comprobacion(dig2)
    return cnt
