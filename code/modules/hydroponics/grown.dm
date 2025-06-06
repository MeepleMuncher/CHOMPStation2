//Grown foods.
/obj/item/reagent_containers/food/snacks/grown

	name = "fruit"
	icon = 'icons/obj/hydroponics_products.dmi'
	icon_state = "blank"
	desc = "Nutritious! Probably."
	flags = NOCONDUCT
	slot_flags = SLOT_HOLSTER
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

	var/plantname
	var/datum/seed/seed
	var/potency = -1


/obj/item/reagent_containers/food/snacks/grown/Initialize(mapload, var/planttype)
	. = ..()

	if(!dried_type)
		dried_type = type

	pixel_x = rand(-5.0, 5)
	pixel_y = rand(-5.0, 5)

	if(planttype)
		plantname = planttype

	if(!plantname)
		log_debug("Plantname not provided and and [src] requires it at [x],[y],[z]")
		return INITIALIZE_HINT_QDEL

	seed = SSplants.seeds[plantname]

	if(!seed)
		log_debug("Plant name '[plantname]' does not exist and [src] requires it at [x],[y],[z]")
		return INITIALIZE_HINT_QDEL

	name = "[seed.seed_name]"
	trash = seed.get_trash_type()

	update_icon()

	potency = seed.get_trait(TRAIT_POTENCY)

	if(seed.chems)
		for(var/rid in seed.chems)
			var/list/reagent_data = seed.chems[rid]
			if(reagent_data && reagent_data.len)
				var/rtotal = reagent_data[1]
				var/list/data = list()
				if(reagent_data.len > 1 && potency > 0)
					rtotal += round(potency/reagent_data[2])
				if(rid == REAGENT_ID_NUTRIMENT)
					data[seed.seed_name] = max(1,rtotal)

				reagents.add_reagent(rid,max(1,rtotal),data)
		update_desc()
		if(reagents.total_volume > 0)
			bitesize = 1+round(reagents.total_volume / 2, 1)
		if(seed.get_trait(TRAIT_STINGS))
			force = 1

/obj/item/reagent_containers/food/snacks/grown/proc/update_desc()
	if(!seed)
		return

	if(SSplants.product_descs["[seed.uid]"])
		desc = SSplants.product_descs["[seed.uid]"]
	else
		var/list/descriptors = list()
		if(reagents.has_reagent(REAGENT_ID_SUGAR) || reagents.has_reagent(REAGENT_ID_CHERRYJELLY) || reagents.has_reagent(REAGENT_ID_HONEY) || reagents.has_reagent(REAGENT_ID_BERRYJUICE))
			descriptors |= "sweet"
		if(reagents.has_reagent(REAGENT_ID_ANTITOXIN))
			descriptors |= "astringent"
		if(reagents.has_reagent(REAGENT_ID_FROSTOIL))
			descriptors |= "numbing"
		if(reagents.has_reagent(REAGENT_ID_NUTRIMENT))
			descriptors |= "nutritious"
		if(reagents.has_reagent(REAGENT_ID_CONDENSEDCAPSAICIN) || reagents.has_reagent(REAGENT_ID_CAPSAICIN))
			descriptors |= "spicy"
		if(reagents.has_reagent(REAGENT_ID_COCO))
			descriptors |= "bitter"
		if(reagents.has_reagent(REAGENT_ID_ORANGEJUICE) || reagents.has_reagent(REAGENT_ID_LEMONJUICE) || reagents.has_reagent(REAGENT_ID_LIMEJUICE))
			descriptors |= "sweet-sour"
		if(reagents.has_reagent(REAGENT_ID_RADIUM) || reagents.has_reagent(REAGENT_ID_URANIUM))
			descriptors |= "radioactive"
		if(reagents.has_reagent(REAGENT_ID_AMATOXIN) || reagents.has_reagent(REAGENT_ID_TOXIN))
			descriptors |= "poisonous"
		if(reagents.has_reagent(REAGENT_ID_PSILOCYBIN) || reagents.has_reagent(REAGENT_ID_BLISS) || reagents.has_reagent(REAGENT_ID_EARTHSBLOOD))
			descriptors |= "hallucinogenic"
		if(reagents.has_reagent(REAGENT_ID_BICARIDINE) || reagents.has_reagent(REAGENT_ID_EARTHSBLOOD))
			descriptors |= "medicinal"
		if(reagents.has_reagent(REAGENT_ID_GOLD) || reagents.has_reagent(REAGENT_ID_EARTHSBLOOD))
			descriptors |= "shiny"
		if(reagents.has_reagent(REAGENT_ID_LUBE))
			descriptors |= "slippery"
		if(reagents.has_reagent(REAGENT_ID_PACID) || reagents.has_reagent(REAGENT_ID_SACID))
			descriptors |= "acidic"
		if(seed.get_trait(TRAIT_JUICY))
			descriptors |= "juicy"
		if(seed.get_trait(TRAIT_STINGS))
			descriptors |= "stinging"
		if(seed.get_trait(TRAIT_TELEPORTING))
			descriptors |= "glowing"
		if(seed.get_trait(TRAIT_EXPLOSIVE))
			descriptors |= "bulbous"

		var/descriptor_num = rand(2,4)
		var/descriptor_count = descriptor_num
		desc = "A"
		while(descriptors.len && descriptor_num > 0)
			var/chosen = pick(descriptors)
			descriptors -= chosen
			desc += "[(descriptor_count>1 && descriptor_count!=descriptor_num) ? "," : "" ] [chosen]"
			descriptor_num--
		if(seed.seed_noun == "spores")
			desc += " mushroom"
		else
			desc += " fruit"
		SSplants.product_descs["[seed.uid]"] = desc
	desc += ". Delicious! Probably."

/obj/item/reagent_containers/food/snacks/grown/update_icon()
	if(!seed || !SSplants || !SSplants.plant_icon_cache)
		return
	cut_overlays()
	var/image/plant_icon
	var/icon_key = "fruit-[seed.get_trait(TRAIT_PRODUCT_ICON)]-[seed.get_trait(TRAIT_PRODUCT_COLOUR)]-[seed.get_trait(TRAIT_PLANT_COLOUR)]"
	if(SSplants.plant_icon_cache[icon_key])
		plant_icon = SSplants.plant_icon_cache[icon_key]
	else
		plant_icon = image('icons/obj/hydroponics_products.dmi',"blank")
		var/image/fruit_base = image('icons/obj/hydroponics_products.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]-product")
		fruit_base.color = "[seed.get_trait(TRAIT_PRODUCT_COLOUR)]"
		plant_icon.add_overlay(fruit_base)
		if("[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf" in cached_icon_states('icons/obj/hydroponics_products.dmi'))
			var/image/fruit_leaves = image('icons/obj/hydroponics_products.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf")
			fruit_leaves.color = "[seed.get_trait(TRAIT_PLANT_COLOUR)]"
			plant_icon.add_overlay(fruit_leaves)
		SSplants.plant_icon_cache[icon_key] = plant_icon
	add_overlay(plant_icon)

/obj/item/reagent_containers/food/snacks/grown/Crossed(var/mob/living/M)
	if(M.is_incorporeal())
		return
	if(seed && seed.get_trait(TRAIT_JUICY) == 2)
		if(istype(M))

			if(M.buckled)
				return

			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.shoes && H.shoes.item_flags & NOSLIP)
					return

			M.stop_pulling()
			to_chat(M, span_notice("You slipped on the [name]!"))
			playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
			M.Stun(8)
			M.Weaken(5)
			seed.thrown_at(src,M)
			qdel(src)
			return

/obj/item/reagent_containers/food/snacks/grown/throw_impact(atom/hit_atom)
	if(seed) seed.thrown_at(src,hit_atom)
	..()

/obj/item/reagent_containers/food/snacks/grown/attackby(var/obj/item/W, var/mob/living/user)

	if(seed)
		if(seed.get_trait(TRAIT_PRODUCES_POWER) && istype(W, /obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/C = W
			if(C.use(5))
				//TODO: generalize this.
				to_chat(user, span_notice("You add some cable to the [src.name] and slide it inside the battery casing."))
				var/obj/item/cell/potato/pocell = new /obj/item/cell/potato(get_turf(user))
				if(src.loc == user && ishuman(user))
					user.put_in_hands(pocell)
				pocell.maxcharge = src.potency * 200
				pocell.charge = pocell.maxcharge
				qdel(src)
				return

		if(W.sharp)

			if(seed.kitchen_tag == PLANT_PUMPKIN) // Ugggh these checks are awful.
				user.show_message(span_notice("You carve a face into [src]!"), 1)
				new /obj/item/clothing/head/pumpkinhead (user.loc)
				qdel(src)
				return

			if(seed.chems)

				if(W.sharp && W.edge && !isnull(seed.chems[REAGENT_ID_WOODPULP]))
					user.show_message(span_notice("You make planks out of \the [src]!"), 1)
					playsound(src, 'sound/effects/woodcutting.ogg', 50, 1)
					var/flesh_colour = seed.get_trait(TRAIT_FLESH_COLOUR)
					if(!flesh_colour) flesh_colour = seed.get_trait(TRAIT_PRODUCT_COLOUR)
					for(var/i=0,i<2,i++)
						var/obj/item/stack/material/wood/NG = new (user.loc)
						if(flesh_colour) NG.color = flesh_colour
						for (var/obj/item/stack/material/wood/G in user.loc)
							if(G == NG)
								continue
							if(G.get_amount() >= G.max_amount)
								continue
							G.attackby(NG, user)
						to_chat(user, span_filter_notice("You add the newly-formed wood to the stack. It now contains [NG.get_amount()] planks."))
					qdel(src)
					return

				if(seed.kitchen_tag == PLANT_SUNFLOWERS)
					new /obj/item/reagent_containers/food/snacks/rawsunflower(get_turf(src))
					to_chat(user, span_notice("You remove the seeds from the flower, slightly damaging them."))
					qdel(src)
					return

				if(seed.kitchen_tag == PLANT_POTATO || !isnull(seed.chems[REAGENT_ID_POTATOJUICE]))
					to_chat(user, span_filter_notice("You slice \the [src] into sticks."))
					new /obj/item/reagent_containers/food/snacks/rawsticks(get_turf(src))
					qdel(src)
					return

				if(!isnull(seed.chems[REAGENT_ID_CARROTJUICE]))
					to_chat(user, span_filter_notice("You slice \the [src] into sticks."))
					new /obj/item/reagent_containers/food/snacks/carrotfries(get_turf(src))
					qdel(src)
					return

				if(!isnull(seed.chems[REAGENT_ID_PINEAPPLEJUICE]))
					to_chat(user, span_filter_notice("You slice \the [src] into rings."))
					new /obj/item/reagent_containers/food/snacks/pineapple_ring(get_turf(src))
					qdel(src)
					return

				if(!isnull(seed.chems[REAGENT_ID_SOYMILK]))
					to_chat(user, span_filter_notice("You roughly chop up \the [src]."))
					new /obj/item/reagent_containers/food/snacks/soydope(get_turf(src))
					qdel(src)
					return

				if(seed.get_trait(TRAIT_FLESH_COLOUR))
					to_chat(user, span_filter_notice("You slice up \the [src]."))
					var/slices = rand(3,5)
					var/reagents_to_transfer = round(reagents.total_volume/slices)
					for(var/i=1; i<=slices; i++)
						var/obj/item/reagent_containers/food/snacks/fruit_slice/F = new(get_turf(src),seed)
						if(reagents_to_transfer)
							reagents.trans_to_obj(F,reagents_to_transfer)
					qdel(src)
					return

	. = ..()

/obj/item/reagent_containers/food/snacks/grown/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()

	if(seed && seed.get_trait(TRAIT_STINGS))
		if(!reagents || reagents.total_volume <= 0)
			return
		reagents.remove_any(rand(1,3))
		seed.thrown_at(src, target)
		sleep(-1)
		if(!src)
			return
		if(prob(35))
			if(user)
				to_chat(user, span_danger("\The [src] has fallen to bits."))
				user.drop_from_inventory(src)
			qdel(src)

/obj/item/reagent_containers/food/snacks/grown/attack_self(mob/user as mob)

	if(!seed)
		return

	if(istype(user.loc,/turf/space))
		return

	if(user.a_intent == I_HURT)
		user.visible_message(span_danger("\The [user] squashes \the [src]!"))
		seed.thrown_at(src,user)
		sleep(-1)
		if(src) qdel(src)
		return

	if(seed.kitchen_tag == PLANT_GRASS)
		user.show_message(span_notice("You make a grass tile out of \the [src]!"), 1)
		var/flesh_colour = seed.get_trait(TRAIT_FLESH_COLOUR)
		if(!flesh_colour) flesh_colour = seed.get_trait(TRAIT_PRODUCT_COLOUR)
		for(var/i=0,i<2,i++)
			var/obj/item/stack/tile/grass/G = new (user.loc)
			if(flesh_colour) G.color = flesh_colour
			for (var/obj/item/stack/tile/grass/NG in user.loc)
				if(G == NG)
					continue
				if(NG.get_amount() >= NG.max_amount)
					continue
				NG.attackby(G, user)
			to_chat(user, "You add the newly-formed grass to the stack. It now contains [G.get_amount()] tiles.")
		qdel(src)
		return

	if(seed.kitchen_tag == PLANT_CARPET)
		user.show_message(span_notice("You shape some carpet squares out of \the [src] fibers!"), 1)
		for(var/i=0,i<2,i++)
			var/obj/item/stack/tile/carpet/G = new (user.loc)
			for (var/obj/item/stack/tile/carpet/NG in user.loc)
				if(G == NG)
					continue
				if(NG.get_amount() >= NG.max_amount)
					continue
				NG.attackby(G, user)
			to_chat(user, span_filter_notice("You add the newly-formed carpet to the stack. It now contains [G.get_amount()] tiles."))
		qdel(src)
		return

	if(seed.get_trait(TRAIT_SPREAD) > 0)
		to_chat(user, span_notice("You plant the [src.name]."))
		new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(get_turf(user),src.seed)
		GLOB.seed_planted_shift_roundstat++
		qdel(src)
		return

	/*
	if(seed.kitchen_tag)
		switch(seed.kitchen_tag)
			if(PLANT_SHAND)
				var/obj/item/stack/medical/bruise_pack/tajaran/poultice = new /obj/item/stack/medical/bruise_pack/tajaran(user.loc)
				poultice.heal_brute = potency
				to_chat(user, span_notice("You mash the leaves into a poultice."))
				qdel(src)
				return
			if(PLANT_MTEAR)
				var/obj/item/stack/medical/ointment/tajaran/poultice = new /obj/item/stack/medical/ointment/tajaran(user.loc)
				poultice.heal_burn = potency
				to_chat(user, span_notice("You mash the petals into a poultice."))
				qdel(src)
				return
	*/

/obj/item/reagent_containers/food/snacks/grown/pickup(mob/user)
	..()
	if(!seed)
		return
	if(seed.get_trait(TRAIT_STINGS))
		var/mob/living/carbon/human/H = user
		if(istype(H) && H.gloves)
			return
		if(!reagents || reagents.total_volume <= 0)
			return
		reagents.remove_any(rand(1,3)) //Todo, make it actually remove the reagents the seed uses.
		var/affected = pick(BP_R_HAND,BP_L_HAND)
		seed.do_thorns(H,src,affected)
		seed.do_sting(H,src,affected)

// Predefined types for placing on the map.

/obj/item/reagent_containers/food/snacks/grown/mushroom/libertycap
	plantname = PLANT_LIBERTYCAP

/obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris
	plantname = PLANT_AMBROSIA

/obj/item/reagent_containers/food/snacks/fruit_slice
	name = "fruit slice"
	desc = "A slice of some tasty fruit."
	icon = 'icons/obj/hydroponics_misc.dmi'
	icon_state = ""

var/list/fruit_icon_cache = list()

/obj/item/reagent_containers/food/snacks/fruit_slice/Initialize(mapload, var/datum/seed/S)
	. = ..()
	// Need to go through and make a general image caching controller. Todo.
	if(!istype(S))
		return INITIALIZE_HINT_QDEL

	name = "[S.seed_name] slice"
	desc = "A slice of \a [S.seed_name]. Tasty, probably."
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

	var/rind_colour = S.get_trait(TRAIT_PRODUCT_COLOUR)
	var/flesh_colour = S.get_trait(TRAIT_FLESH_COLOUR)
	if(!flesh_colour) flesh_colour = rind_colour
	if(!fruit_icon_cache["rind-[rind_colour]"])
		var/image/I = image(icon,"fruit_rind")
		I.color = rind_colour
		fruit_icon_cache["rind-[rind_colour]"] = I
	add_overlay(fruit_icon_cache["rind-[rind_colour]"])
	if(!fruit_icon_cache["slice-[rind_colour]"])
		var/image/I = image(icon,"fruit_slice")
		I.color = flesh_colour
		fruit_icon_cache["slice-[rind_colour]"] = I
	add_overlay(fruit_icon_cache["slice-[rind_colour]"])
