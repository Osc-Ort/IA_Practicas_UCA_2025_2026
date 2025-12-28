; Base de hechos iniciales corregida
(deffacts hechos-iniciales
    (color Mimi rosa)
    (vuela Mimi)
    (pone-huevos Mimi)
    (patas-largas Mimi)
    (rayas-negras Fido)
    (color Fido amarillo)
    (carnivoro Fido)
)

; R1: Si vuela y pone huevos entonces es un ave
(defrule R1
    (vuela ?v)
    (pone-huevos ?v)
    =>
    (assert (es-ave ?v))
)

; R2: Si un ave tiene patas largas y color rosa entonces es un flamenco 
(defrule R2
    (es-ave ?v)
    (patas-largas ?v)
    (color ?v rosa)
    =>
    (assert (es-flamenco ?v))
)

; R3: Si es carnívoro y tiene color amarillo entonces es un tigre 
(defrule R3
    (carnivoro ?v)
    (color ?v amarillo)
    => 
    (assert (es-tigre ?v))
)
