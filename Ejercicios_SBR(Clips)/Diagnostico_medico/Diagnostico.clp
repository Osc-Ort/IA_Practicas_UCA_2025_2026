; Base de hechos iniciales
(deffacts datos-iniciales 
    (fiebre alta)
    (color garganta rojo)
    (color organismo oscuro)
    (morfologia organismo coccus)
    (planodivision unico)
)

; R1: SI inflamación(garganta) y presencia(estreptococo) y fiebre(alta) ENTONCES Infección(garganta)
(defrule R1
    (inflamacion garganta)
    (presencia estreptococo)
    (fiebre alta)
    =>
    (assert (infeccion garganta))
)

; R2:  SI color(garganta,rojo) ENTONCES inflamación(garganta)
(defrule R2
    (color garganta rojo)
    =>
    (assert (inflamacion garganta))
) 

; R3: SI morfología(organismo, coccus) y crecimiento(organismo, en_cadena) ENTONCES presencia(estreptococo)
(defrule R3
    (morfologia organismo coccus)
    (crecimiento organismo en_cadena)
    =>
    (assert (presencia estreptococo))
)

; R4: SI morfología(organismo, coccus) y crecimiento(organismo, en_racimo) ENTONCES presencia(estafilococo) 
(defrule R4
    (morfologia organismo coccus)
    (crecimiento organismo en_racimo)
    =>
    (assert (presencia estafilococo))
)

; R5: SI color(organismo, oscuro) y planodivisión(único) ENTONCES crecimiento(organismo, en_cadena)
(defrule R5
    (color organismo oscuro)
    (planodivision unico)
    => 
    (assert (crecimiento organismo en_cadena))
)


; R6: SI morfología(organismo, coccus) y plano de división(múltiple) ENTONCES crecimiento(organismo, en_racimo) 
(defrule R6
    (morfologia organismo coccus)
    (planodivision multiple)
    =>
    (assert (crecimiento organismo en_racimo))
)

