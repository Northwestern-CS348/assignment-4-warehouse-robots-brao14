(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (ships ?s ?o) (available ?l) (packing-location ?l) (not (complete ?s)))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
    :parameters (?r - robot ?l1 - location ?l2 - location)
    :precondition (and (connected ?l1 ?l2) (at ?r ?l1) (no-robot ?l2))
    :effect (and (at ?r ?l2) (no-robot ?l1)  (not(at ?r ?l1)) (not (no-robot ?l2)))
   )
   
   (:action robotMoveWithPallette
     :parameters (?r - robot ?l1 - location ?l2 - location ?p - pallette)
     :precondition (and (at ?r ?l1) (at ?p ?l1) (connected ?l1 ?l2) (no-pallette ?l2) (no-robot ?l2))
     :effect (and (no-robot ?l1) (no-pallette ?l1) (at ?r ?l2) (at ?p ?l2) (has ?r ?p) (not (no-robot ?l2)) (not (at ?p ?l1)) (not (at ?r ?l1)) (not (no-pallette ?l2)))
   )
   
   (:action moveItemFromPallette
    :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
    :precondition (and (packing-at ?s ?l) (at ?p ?l) (started ?s) (contains ?p ?si) (orders ?o ?si) (ships ?s ?o) (not (complete ?s)))
    :effect (and (includes ?s ?si) (not (contains ?p ?si)))
   )
   
   (:action completeShipment
    :parameters (?l - location ?s - shipment ?o - order)
    :precondition (and (started ?s) (packing-at ?s ?l) (ships ?s ?o) (not (complete ?s)))
    :effect (and (complete ?s) (available ?l))
   )

)
