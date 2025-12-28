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
(defrule asignar_carro
    ?c <- (nuevo_cliente ?id)
    =>
    (assert (carro (id_cliente ?id) (num_productos 0) (importe 0) (pasillo_act 1)))
    (retract ?c)
)

; Mover carro: se mueve el carro a un pasillo contiguo en orden ascendente, es decir, si
; el pasillo actual del carro es el 3, esta regla mueve el carro al pasillo 4. Cuando se
; encuentre en el pasillo 12, entonces pasará al pasillo 1. 
(deffunction siguiente_pasillo (?p)
    (if (= ?p 12) then 1 else (+ ?p 1))
)

(defrule mover_carro
    ?c <- (carro (id_cliente ?id) (pasillo_act ?p))
    (pedido (id_cliente ?id))
    =>
    (modify ?c (pasillo_act (siguiente_pasillo ?p)))
)

; Comprar: se puede comprar un producto pedido cuando el carro se encuentre en el mismo pasillo
; que este producto y exista stock suficiente. El pedido realizado se borra, y se calcula el precio que
; se ha de añadir a la factura del carro. La cantidad en stock en el producto también debe
; actualizarse. La compra deberá tener prioridad sobre el desplazamiento del carro por el
; supermercado. 
(deffunction calcular_pago (?p ?c)
    (* ?p ?c)
)

(defrule comprar 
    ; Menos preferencia que existencias insuficientes para que elimine el pedido antes de llegar a este (declaración adelante)
    (declare (salience 10))
    ?ped <- (pedido (id_cliente ?idC) (id_producto ?idP) (unidades ?un))
    ?pro <- (producto (id_producto ?idP) (stock ?st) (precio ?pre))
    ?car <- (carro (id_cliente ?idC) (num_productos ?numPC) (importe ?actImp))
    =>
    (modify ?pro (stock (- ?st ?un)))
    (modify ?car (num_productos (+ ?numPC ?un)) (importe (+ ?actImp (calcular_pago ?pre ?un))))
    (retract ?ped)
)

; Existencias Insuficientes: Cuando no hay stock suficiente para realizar la compra, se
; avisa al cliente con un mensaje en pantalla y se elimina este pedido. 

(defrule existencias_inexistentes
    ; Mayor preferencia que comprar para quitar en casos de stock insuficiente
    (declare (salience 20))
    ?ped <- (pedido (id_producto ?idP) (unidades ?un))
    (producto (id_producto ?idP) (nombre ?nom) (stock ?st&:(< ?st ?un)))
    =>
    (printout t "No existe stock suficiente del articulo " ?nom ", eliminado el pedido." crlf)
    (retract ?ped)
)

(deffacts productos
    (producto (id_producto 1) (nombre leche)(pasillo 3) (stock 45) (precio 1))
    (producto (id_producto 2) (nombre galletas) (pasillo 4)(stock 10) (precio 2.20))
    (producto (id_producto 3) (nombre cafe) (pasillo 5) (stock 2) (precio 2.6))
    (producto (id_producto 4) (nombre arroz) (pasillo 12) (stock 30) (precio 1.98))
)