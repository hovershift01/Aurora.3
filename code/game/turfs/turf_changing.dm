/turf
	var/tmp/changing_turf

/turf/proc/ReplaceWithLattice()
	src.ChangeTurf(get_base_turf_by_area(src))
	spawn()
		new /obj/structure/lattice( locate(src.x, src.y, src.z) )

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		qdel(L)
// Called after turf replaces old one
/turf/proc/post_change()
	levelupdate()
	var/turf/simulated/open/T = GetAbove(src)
	if(istype(T))
		T.update_icon()

//Creates a new turf
/turf/proc/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0)
	if (!N)
		return

	// This makes sure that turfs are not changed to space when one side is part of a zone
	if(N == /turf/space)
		var/turf/below = GetBelow(src)
		if(istype(below) && !istype(below,/turf/space))
			N = below.density ? /turf/simulated/floor/airless : /turf/simulated/open

	var/obj/fire/old_fire = fire
	var/old_baseturf = baseturf

//	log_debug("Replacing [src.type] with [N]")

	changing_turf = TRUE

	if(connections) 
		connections.erase_all()

	cut_overlays()
	underlays.Cut()
	
	// So we call destroy.
	qdel(src)

	var/turf/simulated/W = new N( locate(src.x, src.y, src.z) )

	if(ispath(N, /turf/simulated))
		if(old_fire)
			fire = old_fire
		if (istype(W,/turf/simulated/floor))
			W.RemoveLattice()
	else if(old_fire)
		old_fire.RemoveFire()

	if(tell_universe)
		universe.OnTurfChange(W)

	SSair.mark_for_update(src) //handle the addition of the new turf.

	W.baseturf = old_baseturf

	W.post_change()
	
	. = W

	queue_smooth(src)
	queue_smooth_neighbors(src)

/turf/proc/transport_properties_from(turf/other)
	if(!istype(other, src.type))
		return 0

	src.set_dir(other.dir)
	src.icon_state = other.icon_state
	src.icon = other.icon
	src.overlays = other.overlays.Copy()
	src.underlays = other.underlays.Copy()
	return 1

//I would name this copy_from() but we remove the other turf from their air zone for some reason
/turf/simulated/transport_properties_from(turf/simulated/other)
	if(!..())
		return 0

	if(other.zone)
		if(!src.air)
			src.make_air()
		src.air.copy_from(other.zone.air)
		other.zone.remove(other)
	return 1
