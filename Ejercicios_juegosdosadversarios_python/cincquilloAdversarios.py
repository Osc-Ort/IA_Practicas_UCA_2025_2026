from __future__ import annotations

from collections import deque
from copy import deepcopy
from dataclasses import dataclass


@dataclass
class Nodo:
    orosMesa: deque[str]
    bastosMesa: deque[str]
    manoMax: set[str]
    manoMin: set[str]

    def __init__(self, cartasMesa: list[str], manoMax: list[str], manoMin: list[str]):
        self.orosMesa = deque()
        self.bastosMesa = deque()
        # Ordenacion para que se queden las cartas en orden
        # Ponemos key para el caso que O12 < O2, lo cual no nos sirve
        for carta in sorted(cartasMesa, key=lambda x: int(x[1:])):
            match carta[0]:
                case "O":
                    self.orosMesa.append(carta)
                case "B":
                    self.bastosMesa.append(carta)
        self.manoMax = set(manoMax)
        self.manoMin = set(manoMin)

    def __str__(self) -> str:
        return f"Oros en mesa:{list(self.orosMesa)}\nBastos en mesa:{list(self.bastosMesa)}\nManoMax:{self.manoMax}\nManoMin:{self.manoMin}\n"


@dataclass
class Jugada:
    carta: str

    def __str__(self):
        dicc: dict[str, str] = {"O": "oros", "B": "bastos"}
        return f"\n{self.carta[1]} de {dicc[self.carta[0]]}\n"


######
# Se crean todas las posibles jugadas para el for de rango (for jugada in jugadas)
jugadas: list[Jugada] = []
for i in "OB":
    for j in range(1, 13):
        jugadas.append(Jugada(i + str(j)))
######


""" Funciones complementarias
    * crearNodo
    * nodoInicial
    * opuesto
"""


def crearNodo(cartasMesa: list[str], manoMax: list[str], manoMin: list[str]) -> Nodo:
    return Nodo(cartasMesa, manoMax, manoMin)


def nodoInicial() -> Nodo:  # type: ignore
    pass


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
    match jugador:
        case 1:
            nuevo.manoMax.remove(jugada.carta)
        case -1:
            nuevo.manoMin.remove(jugada.carta)
    match jugada.carta[0]:
        case "O":
            if jugada.carta[1] < nuevo.orosMesa[0]:
                nuevo.orosMesa.appendleft(jugada.carta)
            else:
                nuevo.orosMesa.append(jugada.carta)
        case "B":
            if jugada.carta[1] < nuevo.bastosMesa[0]:
                nuevo.bastosMesa.appendleft(jugada.carta)
            else:
                nuevo.bastosMesa.append(jugada.carta)
    return nuevo


# Necesariamente en esta hay que ponerle jugador, no queda otra
def esValida(actual: Nodo, jugada: Jugada, jugador: int) -> bool:
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
    valida = False
    match jugador:
        case 1:
            valida = jugada.carta in actual.manoMax
        case -1:
            valida = jugada.carta in actual.manoMin
    if valida:
        val = int(jugada.carta[1:])
        match jugada.carta[0]:
            case "O":
                valida = val == int(actual.orosMesa[0][1:]) - 1 or val == int(
                    actual.orosMesa[-1][1:]
                )
            case "B":
                valida = val == int(actual.bastosMesa[0][1:]) - 1 or val == int(
                    actual.bastosMesa[-1][1:]
                )
    return valida


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
    return len(actual.manoMax) == 0 or len(actual.manoMin) == 0


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
    util = 0
    if nodo.manoMax:
        util += 100
    if nodo.manoMin:
        util -= 100
    return util


def heurisitca(nodo: Nodo) -> int:
    puntuacion_max = 24 - len(nodo.manoMax)
    puntuacion_min = 24 - len(nodo.manoMin)
    return puntuacion_max - puntuacion_min
