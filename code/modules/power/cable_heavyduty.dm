/obj/item/stack/cable_coil/heavyduty
	name = "heavy-duty power cable"
	desc = "A tough, heavy-duty coil of power cable."
	icon = 'icons/obj/power.dmi'
	icon_state = "wire"
	item_state = "wire"
	color = null

/obj/structure/cable/heavyduty
	icon = 'icons/obj/power_cond_heavy.dmi'
	name = "large power cable"
	desc = "This cable is tough. It cannot be cut with simple hand tools."
	layer = 2.39 //Just below pipes, which are at 2.4

/obj/structure/cable/heavyduty/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(!T.is_plating())
		return

	if(W.iswirecutter())
		to_chat(usr, "<span class='notice'>These cables are too tough to be cut with those [W.name].</span>")
		return
	else if(W.iscoil())
		to_chat(usr, "<span class='notice'>You will need heavier cables to connect to these.</span>")
		return
	else
		..()

/obj/structure/cable/heavyduty/cableColor(var/colorC)
	return
