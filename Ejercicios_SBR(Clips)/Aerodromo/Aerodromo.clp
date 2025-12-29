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