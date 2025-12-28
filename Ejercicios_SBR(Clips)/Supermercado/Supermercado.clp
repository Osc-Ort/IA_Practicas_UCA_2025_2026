; Plantillas para los datos
(deftemplate producto
    (slot id_producto)
    (slot nombre)
    (slot pasillo (range 1 12))
    (slot stock)
    (slot precio)
)

(deftemplate pedido
    (slot id_cliente)
    (slot id_producto)
    (slot unidades)
)

(deftemplate carro
    (slot id_cliente)
    (slot num_productos)
    (slot importe)
    (slot pasillo_act)
)

; Asignar un carro: cuando un cliente nuevo se registra en el sistema introduce su
; identificador (se realizará con instrucciones del tipo: (assert (nuevo_cliente id_cliente))
;  y automáticamente se le asigna un carro que saldrá del pasillo 1, y la factura y número
; de productos comprados estará a 0. 
(defrule Asignar_carro
    ?c <- (nuevo_cliente ?id)
    =>
    (assert (carro (id_cliente ?id) (num_productos 0) (importe 0) (pasillo_act 1)))
    (retract ?c)
)

; Mover carro: se mueve el carro a un pasillo contiguo en orden ascendente, es decir, si
; el pasillo actual del carro es el 3, esta regla mueve el carro al pasillo 4. Cuando se
; encuentre en el pasillo 12, entonces pasará al pasillo 1. 
(deffunction mover_carro (?c)
    (bind )
    (modify ?c (pasillo_act (if (= ?c 12) then 1 else ())))
)