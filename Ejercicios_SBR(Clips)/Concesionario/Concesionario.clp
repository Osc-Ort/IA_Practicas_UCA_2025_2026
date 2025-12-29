(deftemplate Modelo 
    (slot Modelo) 
    (slot precio) 
    (slot maletero (allowed-values pequenno mediano grande)) 
    (slot caballos) 
    (slot ABS) 
    (slot consumo))

(deftemplate Formulario
    (slot precio (default 13000)) 
    (slot maletero (default grande)) 
    (slot caballos (default 80)) 
    (slot ABS (default si)) 
    (slot consumo (default 8.0)))

(deffacts Coches_Iniciales
    (Modelo 
        (Modelo Modelo1) 
        (precio 12000) 
        (maletero pequenno) 
        (caballos 65) 
        (ABS no) 
        (consumo 4.7))
    (Modelo
        (Modelo Modelo2)
        (precio 12500)
        (maletero pequenno)
        (caballos 80)
        (ABS si)
        (consumo 4.9))
    (Modelo
        (Modelo Modelo3)
        (precio 13000)
        (maletero mediano)
        (caballos 100)
        (ABS si)
        (consumo 7.8))
    (Modelo
        (Modelo Modelo4)
        (precio 14000)
        (maletero grande)
        (caballos 125)
        (ABS si)
        (consumo 6.0))
    (Modelo
        (Modelo Modelo5)
        (precio 15000)
        (maletero pequenno)
        (caballos 147)
        (ABS si)
        (consumo 8.5)))

(defrule entrada_formulario
    ?f <- (Formulario (precio ?p) (maletero ?m) (caballos ?cab) (ABS ?bs) (consumo ?con))
    (Modelo 
        (Modelo ?md) 
        (precio ?pC&:(<= ?pC ?p))
        (maletero ?m)
        (caballos ?cabC&:(>= ?cabC ?cab))
        (ABS ?bs)
        (consumo ?conC&:(<= ?conC ?con)))
    =>
    (printout t "Recomendación en base de sus intereses del modelo " ?md "." crlf)
    (retract ?f))