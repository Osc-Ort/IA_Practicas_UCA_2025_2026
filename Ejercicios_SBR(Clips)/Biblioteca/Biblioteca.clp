; Plantillas para los datos
(deftemplate socio
    (slot idsocio)
    (multislot nombre)
    (slot movil)
    (slot poblacion)
    (slot sancion (allowed-values Si No) (default No))
)

(deftemplate libro
    (slot idlibro)
    (multislot titulo)
    (multislot autor)
    (slot editorial)
    (slot publicadoen)
)

(deftemplate hoy
    (slot dia)
    (slot mes)
    (slot anno)
)

(deftemplate solicitud
    (slot idlibro)
    (slot idsocio)
    (slot tipo (allowed-values Prestamo Devolucion))
)

(deftemplate prestamo
    (slot idlibro)
    (slot idsocio)
    (slot dia)
    (slot mes)
    (slot anno)
)

; Base de hechos iniciales
(deffacts hechos-iniciales
    (socio (idsocio 1) (nombre Maria Guzman) (movil 6767) (poblacion Cadiz))
    (socio (idsocio 2) (nombre Jose Gutierrez) (movil 1234) (poblacion Cadiz))
    (socio (idsocio 3) (nombre Agnes Belizon) (movil 4545) (poblacion Cadiz) (sancion Si))
    (libro (idlibro A1) (titulo AI A MODERN APPROACH) (autor Stuart Russell) (editorial Macgraw) (publicadoen 2011))
    (libro (idlibro A2) (titulo Expert Systems) (autor J Giarratano) (editorial Thomsom) (publicadoen 2000))
    (libro (idlibro C22) (titulo Inteligencia Artificial) (autor Elen Rich))
    (solicitud (idsocio 1) (idlibro A1) (tipo Prestamo))
    (solicitud (idsocio 3) (idlibro A2) (tipo Prestamo))
    (solicitud (idsocio 4) (idlibro C22) (tipo Prestamo))
    (prestamo (idlibro A2) (idsocio 2) (dia 3) (mes 1) (anno 2026))
    (solicitud (idsocio 2) (idlibro A2) (tipo Devolucion))
    (hoy (dia 5) (mes 2) (anno 2026))
)

; R1: Crea una regla para actualizar la fecha del día de hoy introduciendo el día, mes y año desde el teclado.
(defrule R1
    ?f <- (hoy)
    ?o <- (actualizar-fecha)
    =>
    (printout t "Introduce el dia actual: ")
    (bind ?d (read))
    (printout t "Introduce el mes actual: ")
    (bind ?m (read))
    (printout t "Introduce el anno actual: ")
    (bind ?an (read))

    (retract ?o)
    (modify ?f (dia ?d) (mes ?m) (anno ?an))
)

; R2: Crea una regla que muestre un mensaje en pantalla cuando una persona realiza una petición de préstamo, pero no es socio registrado en el sistema. 
(defrule R2
    ?s <- (solicitud (idsocio ?id) (tipo Prestamo))
    (not (socio (idsocio ?id)))
    =>
    (printout t "No existe socio con id " ?id " en el sistema." crlf)
    (retract ?s)
)

; R3: Cuando un socio no sancionado, que está recogido en el sistema, solicita un libro, con
; código válido, y que no está ya prestado, entonces se registrará el préstamo de este
; libro mediante un hecho de tipo préstamo con la fecha del día de hoy, se eliminará la
; solicitud porque ya ha sido realizada, y se mostrará un mensaje en pantalla avisando
; de que el préstamo se ha realizado correctamente. 
(defrule R3
    (socio (idsocio ?idS) (sancion No))
    (libro (idlibro ?idL))
    ?solic <- (solicitud (idsocio ?idS) (idlibro ?idL))
    (not (prestamo (idlibro ?idL)))
    (hoy (dia ?d) (mes ?m) (anno ?an))
    =>
    (assert (prestamo (idsocio ?idS) (idlibro ?idL) (dia ?d) (mes ?m) (anno ?an)))
    (retract ?solic)
    (printout t "Prestamo para el socio con id " ?idS " para el libro con id " ?idL " a sido completado correctamente." crlf)
)

; R4: Una solicitud de devolución conlleva que hay un préstamo en curso realizado por el
; mismo socio e implicará eliminar el préstamo del sistema así como la solicitud del
; sistema. 
(defrule R4
    ?solic <- (solicitud (idlibro ?idL) (idsocio ?idS) (tipo Devolucion))
    ?prest <- (prestamo (idlibro ?idL) (idsocio ?idS))
    =>
    (retract ?solic)
    (retract ?prest)
)