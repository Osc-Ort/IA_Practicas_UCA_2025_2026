from tictactoeAlum import (
    Jugada,
    Nodo,
    aplicaJugada,
    esValida,
    heurisitca,
    jugadas,
    terminal,
    utilidad,
)

LIMITE = 3


def PSEUDOminimax(nodo: Nodo) -> Nodo:
    # El agente inteligente (que se corresponde con MAX) hace el movimiento... ¿más beneficioso para MAX?
    mejorJugada: Jugada = Jugada(-1, -1)
    puntos = -2
    for jugada in jugadas:
        if esValida(nodo, jugada):
            intento = aplicaJugada(nodo, jugada, 1)
            util = utilidad(intento)
            if util > puntos:
                puntos = util
                mejorJugada = jugada
    nodo = aplicaJugada(nodo, mejorJugada, 1)
    return nodo


def jugadaAdversario(nodo: Nodo) -> Nodo:
    # El usuario (que se corresponde con MIN) hace el movimiento si es válido.
    valida = False
    jugada = None
    while not valida:
        fila = int(input("Fila: "))
        col = int(input("Col: "))
        jugada = Jugada(fila, col)
        valida = esValida(nodo, jugada)
        if not valida:
            print("\n Intenta otra posicion del tablero \n")
    nodo = aplicaJugada(nodo, jugada, -1)
    return nodo


def minimax(nodo: Nodo) -> Nodo:
    jugador = 1
    mejorJugada = jugadas[0]
    max_t = float("-inf")
    for jugada in jugadas:
        if esValida(nodo, jugada):
            intento = aplicaJugada(nodo, jugada, jugador)
            max_actual = valorMin(intento)
            if max_actual > max_t:
                max_t = max_actual
                mejorJugada = jugada
    nodo = aplicaJugada(nodo, mejorJugada, jugador)
    return nodo


def valorMin(nodo) -> int:
    valor_min = 10**100
    jugador = -1
    if terminal(nodo):
        valor_min = utilidad(nodo)
    else:
        for jugada in jugadas:
            if esValida(nodo, jugada):
                valor_min = min(
                    valor_min, valorMax(aplicaJugada(nodo, jugada, jugador))
                )
    return valor_min


def valorMax(nodo) -> int:
    valor_max = -(10**100)
    jugador = 1
    if terminal(nodo):
        valor_max = utilidad(nodo)
    else:
        for jugada in jugadas:
            if esValida(nodo, jugada):
                valor_max = max(
                    valor_max, valorMin(aplicaJugada(nodo, jugada, jugador))
                )
    return valor_max


def poda_ab(nodo: Nodo) -> Nodo:
    jugador = 1
    mejorJugada = -1
    valor_max = -(10**100)
    alfa = -(10**100)
    beta = 10**100
    prof = 0
    for jugada in jugadas:
        if esValida(nodo, jugada):
            intento = aplicaJugada(nodo, jugada, jugador)
            valor_max = max(valor_max, valorMin_ab(intento, prof + 1, alfa, beta))
            if valor_max > alfa:
                alfa = valor_max
                mejorJugada = jugada
    if mejorJugada != -1:
        nodo = aplicaJugada(nodo, mejorJugada, jugador)
    return nodo


def valorMin_ab(nodo: Nodo, prof: int, alfa: int, beta: int) -> int:
    jugador = -1
    if terminal(nodo):
        valor_min = utilidad(nodo)
    else:
        if prof == LIMITE:
            valor_min = heurisitca(nodo)
        else:
            i = 0
            while i < len(jugadas) and alfa < beta:
                jugada = jugadas[i]
                if esValida(nodo, jugada):
                    intento = aplicaJugada(nodo, jugada, jugador)
                    beta = min(beta, valorMax_ab(intento, prof + 1, alfa, beta))
                i += 1
            valor_min = beta
    return valor_min


def valorMax_ab(nodo: Nodo, prof: int, alfa: int, beta: int) -> int:
    jugador = 1
    if terminal(nodo):
        valor_max = utilidad(nodo)
    else:
        if prof == LIMITE:
            valor_max = heurisitca(nodo)
        else:
            i = 0
            while i < len(jugadas) and alfa < beta:
                jugada = jugadas[i]
                if esValida(nodo, jugada):
                    intento = aplicaJugada(nodo, jugada, jugador)
                    alfa = max(alfa, valorMin_ab(intento, prof + 1, alfa, beta))
                i += 1
            valor_max = alfa
    return valor_max
