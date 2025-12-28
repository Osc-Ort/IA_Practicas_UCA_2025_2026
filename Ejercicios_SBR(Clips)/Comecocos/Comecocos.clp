; Plantillas para los datos
(deftemplate comecocos
    (slot posX (default 1))
    (slot posY (default 1))
    (slot contador (default 0))
    (slot vidas (default 3))
)

(deftemplate fantasma
    (slot color)
    (slot posX)
    (slot posY)
)

(deftemplate fruta
    (slot nombre)
    (slot posX)
    (slot posY)
)

; COMER: Esta regla controla si el comecocos se encuentra en la misma posición que una
; fruta. Si es así, permite comérsela, incrementando el contador de frutas que se ha comido el
; comecocos en 1, y eliminando dicha fruta del juego. 
(defrule COMER
    ?c <- (comecocos (posX ?x) (posY ?y) (contador ?con))
    ?f <- (fruta (posX ?x) (posY ?y))
    =>
    (modify ?c (contador (+ ?con 1)))
    (retract ?f)
)

; MORIR: Esta regla controla si el comecocos se encuentra en la misma posición que un
; fantasma. En este caso, se decrementa en 1 el número de vidas del comecocos. La posición del
; comecocos debe actualizarse, y colocar al comecocos en la casilla de salida 1,1. 
(defrule MORIR
    ?c <- (comecocos (posX ?x) (posY ?y) (vidas ?v))
    (fantasma (posX ?x) (posY ?y))
    =>
    (modify ?c (posX 1) (posY 1) (vidas (- ?v 1)))
)

; Param: {comecocos} ?c
; Elimina al comecocos para que no pueda moverse luego de terminar partida
(deffunction TERMINAR_PARTIDA (?c)
    (retract ?c)
    (printout t "Partida terminada." crlf)
)

; GANAR: Esta regla controla cuando acaba de forma victoriosa el juego, porque el comecocos
; se ha comido 10 ó más frutas, y avisa al usuario de que ha ganado. 
(defrule GANAR
    ?c <- (comecocos (contador ?con&:(>= ?con 10)))
    =>
    (TERMINAR_PARTIDA ?c)
    (printout t "Has GANADO." crlf)
)

; GAMEOVER: Esta regla controla cuando acaba perdiendo el comecocos, porque ha
; consumido todas sus vidas, y avisa al usuario de que ha perdido. 
(defrule GAMEOVER
    ?c <- (comecocos (vidas ?v&:(<= ?v 0)))
    =>
    (TERMINAR_PARTIDA ?c)
    (printout t "Has PERDIDO" crlf)
)

;  IZQUIERDA, DERECHA, ARRIBA, ABAJO: El desplazamiento de Pacman puede ser simulado
; con los cuatro posibles movimientos adyacentes a una posición en la que se encuentre, es
; decir, Derecha, Izquierda, Arriba o Abajo, siempre que respeten los límites del tablero Pacman
; podrá actualizar su posición en la dirección indicada.
; Los límites del tablero MaxFils, MaxCols pueden definirse mediante sendas variables globales. 

(defglobal
    ?*MaxFils* = 100
    ?*MaxCols* = 100
)

(defrule IZQ
    ?d <- (IZQUIERDA)
    ?c <- (comecocos (posX ?x))
    =>
    ; No compruebo anteriormente la condicion debido a que siempre hay que eliminar la direccion, da igual si esta en el limite o no
    (modify ?c (posX (if (= ?x 1) then ?x else (- ?x 1))))
    (retract ?d)
)

(defrule DER
    ?d <- (DERECHA)
    ?c <- (comecocos (posX ?x))
    =>
    ; No compruebo anteriormente la condicion debido a que siempre hay que eliminar la direccion, da igual si esta en el limite o no
    (modify ?c (posX (if (= ?x ?*MaxCols*) then ?x else (+ ?x 1))))
    (retract ?d)
)

(defrule ABJ
    ?d <- (ABAJO)
    ?c <- (comecocos (posY ?y))
    =>
    ; No compruebo anteriormente la condicion debido a que siempre hay que eliminar la direccion, da igual si esta en el limite o no
    (modify ?c (posY (if (= ?y 1) then ?y else (- ?y 1))))
    (retract ?d)
)

(defrule ARR
    ?d <- (ARRIBA)
    ?c <- (comecocos (posY ?y))
    =>
    ; No compruebo anteriormente la condicion debido a que siempre hay que eliminar la direccion, da igual si esta en el limite o no
    (modify ?c (posY (if (= ?y ?*MaxFils*) then ?y else (+ ?y 1))))
    (retract ?d)
)