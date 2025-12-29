; Definicion del tipo valvula
(deftemplate valvula
    (slot nombre)
    (slot T1)
    (slot T2)
    (slot presion (default 0))
    (slot estado (allowed-values abierta cerrada) (default cerrada)))

; Hechos iniciales

(deffacts hechos-iniciales
    (valvula (nombre Entrada) (T1 101) (T2 35) (presion 1))
    (valvula (nombre Salida) (T1 101) (T2 155) (presion 5))
    (valvula (nombre Pasillo1) (T1 99) (T2 37) (estado cerrada)))

; R1: Si una v´alvula est´a abierta con un valor de presi´on 5, entonces la v´alvula se cierra y se baja la
; presi´on a 0.
(defrule R1
    ?v <- (valvula (presion 5) (estado abierta))
    =>
    (modify ?v (presion 0) (estado cerrada)))

; R2: Si una v´alvula cerrada tiene un valor de presi´on menor de 10 y una temperatura T1 mayor de 35
; grados entonces esta v´alvula deber´a abrirse y aumentar la presi´on en funci´on de la temperatura
; T1.
; ⇒ Para aumentar la presi´on crea una funci´on que reciba como argumentos la presi´on y la
; temperatura 1 de la v´alvula: mientras T1 sea mayor de 35 grados aumenta la presi´on en una
; unidad, y decrementa la temperatura en 5 grados.
(deffunction aumentarPresion (?p ?t)
    (while (> ?t 35) do
        (bind ?p (+ ?p 1))
        (bind ?t (- ?t 5))
    )
    (create$ ?p ?t))

(defrule R2
    ?v <- (valvula (T1 ?t1&:(> ?t1 35)) (presion ?p&:(< ?p 10)) (estado cerrada))
    =>
    (bind ?res (aumentarPresion ?p ?t1))
    (modify ?v (T1 (nth$ 2 ?res)) (presion (nth$ 1 ?res)) (estado abierta)))

; R3: Si dos v´alvulas distintas, v1 y v2, tienen la misma temperatura T2, y la temperatura T1 de la
; v´alvula v2, es menor que T2, entonces se decrementa la temperatura T2 de la v´alvula v2 y se
; abren ambas v´alvulas.
; ⇒ Para decrementar la temperatura crea una funci´on que reciba como argumentos las dos
; temperaturas, T1 y T2, si la temperatura T2 es mayor que la temperatura T1 entonces T2=
; T2-T1
(deffunction disminuirTemperatura (?t1 ?t2)
    (if (>= ?t1 ?t2) then
        ?t2
    else
        (- ?t2 ?t1)))

(defrule R3
    ?v1 <- (valvula (nombre ?n) (T2 ?t2))
    ?v2 <- (valvula (nombre ~?n) (T1 ?t1&:(< ?t1 ?t2)) (T2 ?t2))
    =>
    (modify ?v1 (estado abierta))
    (modify ?v2 (estado abierta) (T2 (disminuirTemperatura ?t1 ?t2))))