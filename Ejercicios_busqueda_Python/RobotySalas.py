# Formalización problema robot y las 12 salas
# Tablero de forma
# A B C
# D E F
# G H I
# J K L <- dest
# Funciona sorprendentemente, AEstrella encuentra camino optimo
from copy import deepcopy
from dataclasses import dataclass


@dataclass
class tEstado:
    puertas: dict[tuple[str, str], int]
    posAct: str

    # Lista de tuplas de ini,fin, coste que son las puertas
    def __init__(self, puertas: list[tuple[str, str, int]]):
        self.puertas = {}
        for ini, fin, coste in puertas:
            self.puertas[(ini, fin)] = self.puertas[(fin, ini)] = coste
        self.posAct = "A"

    # Se podría currar más una el repr, pero mucho trabajo
    def __repr__(self) -> str:
        return f"{self.puertas}\nPosicion en letra: {self.posAct}."

    def crearHash(self) -> str:
        return f"{self.puertas},{self.posAct}"


operadores: dict[int, str] = {0: "ABJ", 1: "DER"}


# Le he pedido que me haga esto gemini que chico rollo (hacer el diccionario)
def estadoInicial() -> tEstado:
    return tEstado(
        [
            # --- LÍNEAS FINAS (Valor 1) ---
            ("A", "B", 1),
            ("B", "C", 1),
            ("A", "D", 1),
            ("B", "E", 1),
            ("C", "F", 1),
            ("E", "F", 1),
            ("E", "H", 1),
            ("G", "H", 1),
            ("H", "I", 1),
            ("J", "K", 1),
            # --- LÍNEAS DOBLES (Valor 2) ---
            ("D", "E", 2),  # Vertical entre D y E
            ("D", "G", 2),  # Horizontal entre D y G
            ("F", "I", 2),  # Horizontal entre F e I
            # --- LÍNEAS TRIPLES (Valor 3) ---
            ("G", "J", 3),  # Horizontal entre G y J
            ("H", "K", 3),  # Horizontal entre H y K
            ("I", "L", 3),  # Horizontal entre I y L
            ("K", "L", 3),  # Vertical entre K y L
        ]
    )


def estadoObjetivo() -> tEstado:
    obj = tEstado([])
    obj.posAct = "L"
    return obj


def aplicaOperador(op: int, estado: tEstado) -> tEstado:
    nuevo = deepcopy(estado)
    match operadores[op]:
        case "ABJ":
            nuevo.posAct = chr(ord(estado.posAct) + 3)
        case "DER":
            nuevo.posAct = chr(ord(estado.posAct) + 1)
    return nuevo


def esValido(op: int, estado: tEstado) -> bool:
    valido = False
    match operadores[op]:
        case "ABJ":
            valido = estado.posAct not in "JK"
        case "DER":
            valido = estado.posAct not in "CFI"
    return valido


def testObjetivo(estado: tEstado) -> bool:
    return estado.posAct == "L"


def coste(op: int, estado: tEstado) -> int:
    coste = 0
    match operadores[op]:
        case "ABJ":
            coste = estado.puertas[(estado.posAct, chr(ord(estado.posAct) + 3))]
        case "DER":
            coste = estado.puertas[(estado.posAct, chr(ord(estado.posAct) + 1))]
    return coste


# No muy buena debido a que el coste no es uniforme
def calcularHeuristica(estado: tEstado) -> int:
    difVer = (ord("L") - ord(estado.posAct)) // 3
    difHor = (ord("L") - ord(estado.posAct)) % 3
    return difVer + difHor
