; Base de hechos iniciales
(deffacts hechos-iniciales
    (valvula-gas abierta)
    (suministro-electrico cortado)
    (presion normal)
)

; R1: Si el quemador no funciona Entonces la calefacción no calienta
(defrule R1
    (quemador no-funciona)
    =>
    (assert (calefacción no-calienta))
)

; R2: Si no llega gas al quemador Entonces el quemador no funciona 
(defrule R2
    (llega-gas no)
    =>
    (assert (quemador no-funciona))
)

; R3: Si la válvula de gas está cerrada Entonces no llega gas al quemador 
(defrule R3
    (valvula-gas cerrada)
    => 
    (assert (llega-gas no))
)

; R4: Si el termostato está averiado Entonces el quemador no funciona
(defrule R4
    (termostato averiado)
    =>
    (assert (quemador no-funciona))
)

; R5: Si el suministro eléctrico está cortado Entonces el termostato está averiado 
(defrule R5
    (suministro-electrico cortado)
    =>
    (assert (termostato averiado))
)

; R6: Si el suministro eléctrico está cortado Entonces la bomba de agua no funciona 
(defrule R6
    (suministro-electrico cortado)
    =>
    (assert (bomba-agua no-funciona))
)

; R7: Si la bomba de agua no funciona Entonces la calefacción no calienta 
(defrule R7
    (bomba-agua no-funciona)
    =>
    (assert (calefacción no-calienta))
)

; R8: Si hay presión baja en el circuito Entonces la bomba de agua no funciona 
(defrule R8
    (presion baja)
    =>
    (assert (bomba-agua no-funciona))
)