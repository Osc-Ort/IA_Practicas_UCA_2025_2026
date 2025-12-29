(deffacts Hechos_iniciales_Mapa
    (ubicacion A norte D)
    (ubicacion A oeste B)
    (ubicacion B norte E)
    (ubicacion B oeste C)
    (ubicacion E norte F)
    (ubicacion D norte G)
    (ubicacion D oeste E)
    (ubicacion E norte H)
    (ubicacion E oeste F)
    (ubicacion F norte I)
    (ubicacion G oeste H)
    (ubicacion H oeste I))

(defrule Sur_De
    (ubicacion ?i norte ?f)
    =>
    (assert (ubicacion ?f sur ?i)))

(defrule Este_De
    (ubicacion ?i oeste ?f)
    =>
    (assert (ubicacion ?f este ?i)))

(defrule Doble_dir
    (ubicacion ?i ?d ?k)
    (ubicacion ?k ?d ?j)
    =>
    (assert (ubicacion ?i ?d ?j)))

(defrule Noroeste
    (ubicacion ?i oeste ?m)
    (ubicacion ?m norte ?f)
    =>
    (assert (ubicacion ?i noroeste ?f)))

(defrule Noreste
    (ubicacion ?i este ?m)
    (ubicacion ?m norte ?f)
    =>
    (assert (ubicacion ?i noreste ?f)))

(defrule Suroeste
    (ubicacion ?i oeste ?m)
    (ubicacion ?m sur ?f)
    =>
    (assert (ubicacion ?i suroeste ?f)))

(defrule Sureste
    (ubicacion ?i este ?m)
    (ubicacion ?m sur ?f)
    =>
    (assert (ubicacion ?i sureste ?f)))

(defrule inicio
    ?f1 <-(situacion ?x ?y)
    (ubicacion ?x ?u ?y)
    =>
    (println ?x " esta al " ?u " de " ?y)
    (retract ?f1))
