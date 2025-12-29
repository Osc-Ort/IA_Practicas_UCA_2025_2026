; Definición de tipos de datos
(deftemplate aeronave
    (slot id_aeronave)
    (slot compannia)
    (slot id_aerodromo_orig)
    (slot id_aerodromo_dest)
    (slot velocidad)
    (slot peticion (allowed-values ninguna despegue aterrizaje emergencia rumbo))
    (slot estado (allowed-values enTierra ascenso crucero descenso) (default enTierra)))

(deftemplate aerodromo 
    (slot id_aerodromo)
    (slot ciudad)
    (slot radar (allowed-values ON OFF))
    (slot radio_visibilidad)
    (slot velocidad_viento))

(deftemplate piloto
    (slot id_aeronave)
    (slot id_vuelo)
    (slot estado (allowed-values OK SOS ejecutando stand-by)))

(deftemplate vuelo
    (slot id_vuelo)
    (slot id_aerodromo_orig)
    (slot id_aerodromo_dest)
    (slot distancia)
    (slot velocidad_despeque (default 240))
    (slot velocidad_ext (default 700)))

(deftemplate metereologia
    (slot id_aerodromo)
    (slot tiempo (allowed-values lluvia niebla nieve vientoHuracanado despejado))
    (slot restriccion (allowed-values si no)))

; Indicación enunciado: Evitar uso de if else

; Alerta Meteorologia: Se disparar´a si una aeronave se encuentra en petici´on de Despegue y la
; informaci´on de la meteorolog´ıa del aer´odromo de origen tiene el campo restriccion fijado en Si
; (independientemente de los valores de visibilidad o viento). Esta regla representa una cancelaci´on
; inmediata por seguridad. En este caso, la petici´on de la aeronave pasa a Ninguna, el estado
; del piloto pasa a Stand-by, y se debe imprimir el mensaje "Alerta: Despegue CANCELADO por
; condiciones clim´aticas adversas".

(defrule alertaMeteorologia
    (declare (salience 20))
    ?nave <- (aeronave (id_aeronave ?idnave) (peticion despegue) (id_aerodromo_orig ?idaer))
    (metereologia (id_aerodromo ?idaer) (restriccion si))
    ?pil <- (piloto (id_aeronave ?idnave))
    =>
    (modify ?nave (peticion ninguna))
    (modify ?pil (estado stand-by))
    (printout t "Alerta: Despegue CANCELADO por condiciones climáticas adversas" crlf))

; PilotoAsociado: Se realizar´a una comprobaci´on de seguridad cuando una aeronave que realiza
; comprobaci´on consiste en verificar que existe al menos un piloto asociado a esa aeronave que se
; encuentre en estado OK. Esta regla tendr´a prioridad sobre otras a excepci´on de la comprobaci´on de
; la meteorolog´ıa. En ese caso, se mostrando un mensaje que indique el ´exito de la comprobaci´on:
; COMPROBACION CORRECTA: La aeronave FX220 de la compa˜n´ıa IB tiene PILOTO asignado para poder realizar el vuelo desde el aer´odromo MAD con destino
; BCN para realizar un vuelo de los registrados en el aer´odromo de origen y la aeronave
; se encuentra en petici´on de Despegue

(defrule pilotoAsociado
    (declare (salience 10))
    ?nave <- (aeronave 
        (id_aeronave ?idNave) 
        (compannia ?compa) 
        (id_aerodromo_orig ?idAerOrig) 
        (id_aerodromo_dest ?idAerDest)
        (peticion despegue))
    (piloto (id_aeronave ?idNave) (estado OK))
    =>
    (printout t 
        "Comprobación correcta: La aeronave "
        ?idNave
        " de la compañia "
        ?compa
        " tiene PILOTO asignado para poder realizar el vuelo desde el aeródromo "
        ?idAerOrig
        " con destino "
        ?idAerDest
        " para realizar un vuelo de los registrados en el aerodromo de origen y la aeronave se encuentra en peticion de Despegue" 
        crlf))

; PeticionDespegue: Esta es una comprobaci´on preliminar antes de la autorizaci´on final de despegue. Se realizar´a cuando una aeronave se encuentra en tierra y ha realizado una petici´on de
; Despegue, el piloto ha dado su visto bueno (estado OK), existe un vuelo con el origen y destino
; especificados en la aeronave y, adem´as, se cumplen las siguientes condiciones del aer´odromo de
; origen: el radar funciona ON, el radio de visibilidad es mayor de 5kms y la velocidad del viento
; es menor de 75km/h. Adicionalmente, se debe verificar que el hecho de Meteorologia para el
; aer´odromo de destino no tiene una restricci´on activa (campo restriccion en No). Si todas estas
; condiciones se cumplen (adem´as, no debe existir una petici´on autorizada previa), se debe generar
; un hecho de Peticion Autorizada para la aeronave, indicando que las condiciones iniciales son
; aptas, e imprimir el resultado de la verificaci´on.
(defrule peticionDespegue
    ?nave <- (aeronave 
            (id_aeronave ?idNave) 
            (id_aerodromo_orig ?idAerOrig) 
            (id_aerodromo_dest ?idAerDest)
            (peticion despegue)
            (estado enTierra))
    (piloto (id_aeronave ?idNave) (estado OK))
    (vuelo (id_aerodromo_orig ?idAerOrig) (id_aerodromo_dest ?idAerDest))
    (aerodromo 
        (id_aerodromo ?idAerOrig) 
        (radar ON) 
        (radio_visibilidad ?rad&:(> ?rad 5)) 
        (velocidad_viento ?vel&:(< ?vel 75)))
    (metereologia (id_aerodromo ?idAerDest) (restriccion no))
    (not (peticionAutorizada ?idNave))
    =>
    (assert (peticionAutorizada ?idNave))
    (printout t "Peticion de despegue para la aeronave " ?idNave " concebida." crlf))

; Despegar: se realizar´a esta acci´on cuando una aeronave que se encuentra en tierra y tenga una
; petici´on autorizada por parte de los controladores a´ereos. Adem´as, el piloto de la misma ha dado
; su visto bueno (estado OK). La autorizaci´on de despegue implica que el piloto pasa al estado de
; Ejecutando (esta acci´on) y la aeronave al estado Ascenso. La velocidad actual debe tomar el valor
; de la velocidad de despegue establecida para este vuelo. Se actualiza la petici´on de la aeronave a
; Ninguna. Finalmente, la petici´on de Despegue queda sin efecto.
(defrule despegar 
    ?pet <- (peticionAutorizada ?idNave)
    ?nave <- (aeronave (id_aeronave ?idNave) (id_aerodromo_orig ?idAerOrig) (id_aerodromo_dest ?idAerDest))
    ?pil <- (piloto (id_aeronave ?idNave) (estado OK))
    (vuelo (id_aerodromo_orig ?idAerOrig) (id_aerodromo_dest ?idAerDest) (velocidad_despeque ?velDesp))
    =>
    (printout t "Despegando nave " ?idNave "." crlf)
    (modify ?nave (peticion ninguna) (velocidad ?velDesp) (estado ascenso))
    (modify ?pil (estado ejecutando))
    (retract ?pet))

; Crucero: La velocidad de crucero se alcanza despu´es de que el piloto ha realizado una maniobra
; de despegue, la aeronave se encuentra en el estado Ascenso y pasa a Crucero, donde, a partir
; de la velocidad inicial se alcanza la altura y velocidad de crucero establecidas para este vuelo,
; esta velocidad se actualizar´a en esta regla. En este momento se informa a los pasajeros de que el
; despegue ha sido correcto y se estima el tiempo de vuelo, que se calcula con la distancia al destino
; y la velocidad de crucero alcanzada. (Se ha de crear una funci´on que devuelva esta estimaci´on).
; El estado del piloto pasar´a a stand-by.

; Crear dos funciones en CLIPS para calcular el tiempo para llegar al destino, seg´un la velocidad de
; crucero y la distancia en kms. Una funci´on ha de devolver el n´umero de horas y la otra los minutos.
; Por ejemplo una aeronave que va a velocidad de crucero 800 km/h tardar´a en recorrer 880 kms 1 hora
; y 6 minutos. (Puedes usar las funciones div y mod si las necesitas)
(deffunction tiempoEnMinutos (?d ?v)
    (/ (* ?d 60) ?v))

(deffunction tiempoHoras (?d ?v) 
    (div (tiempoEnMinutos ?d ?v) 60))

(deffunction tiempoMinutos (?d ?v)
    (mod (tiempoEnMinutos ?d ?v) 60))

(defrule crucero
    ?nave <- (aeronave (id_aeronave ?idNave) (id_aerodromo_orig ?idAerOrig) (id_aerodromo_dest ?idAerDest) (estado ascenso))
    (vuelo (id_aerodromo_orig ?idAerOrig) (id_aerodromo_dest ?idAerDest) (velocidad_ext ?velExt) (distancia ?dist))
    ?pil <- (piloto (id_aeronave ?idNave) (estado OK))
    =>
    (modify ?nave (velocidad ?velExt) (estado crucero))
    (modify ?pil (estado stand-by))
    (printout t "Se informa a los pasajeros que el despeque a sido un existo, el tiempo de vuelo estimado es de "
        (tiempoHoras ?dist ?velExt) " horas y " (tiempoMinutos ?dist ?velExt) " minutos. Esperemos que pasen un buen viaje." crlf))