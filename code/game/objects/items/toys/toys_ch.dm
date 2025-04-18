/obj/item/toy/figure/bounty_hunter
	name = "Space bounty hunter action figure"
	desc = "A \"Space Life\" brand bounty hunter action figure."
	icon = 'icons/obj/toy_ch.dmi'
	icon_state = "hunter"
	toysay = "The last greytide is in captivity. The station is at peace."

/obj/item/toy/sif
	name = "Sif planet model"
	desc = "A \"Space Life\" brand planet model of Sif, it's oddly cold to the touch."
	icon = 'icons/obj/toy_ch.dmi'
	icon_state = "sif"

/obj/item/toy/figure/station
	name = "NLS Southern Cross action figure"
	desc = "A \"Space Life\" brand figure of the NLS Southern Cross, the station you work in."
	icon = 'icons/obj/toy_ch.dmi'
	icon_state = "station"
	toysay = "Attention! Alert level elevated to blue."

/obj/item/toy/plushie/green_fox
	name = "green fox plushie"
	icon = 'icons/obj/toy_ch.dmi'
	icon_state = "greenfox"
	pokephrase = "Weh!"

/obj/item/toy/plushie/dragon
	name = "dragon plushie"
	desc = "A soft plushie in the shape of a dragon. How ferocious!"
	icon = 'icons/obj/toy_ch.dmi'
	icon_state = "reddragon"
	var/cooldown = FALSE

/obj/item/toy/plushie/dragon/Initialize(mapload)
	. = ..()
	if (pokephrase != "Rawr~!")
		pokephrase = pick("ROAR!", "RAWR!", "GAWR!", "GRR!", "GROAR!", "GRAH!", "Weh!", "Merp!")

/obj/item/toy/plushie/dragon/attack_self(mob/user)
	if(!cooldown)
		switch(pokephrase)
			if("Weh!")
				playsound(user, 'sound/voice/weh.ogg', 20, 0)
			if("Merp!")
				playsound(user, 'sound/voice/merp.ogg', 20, 0)
			else
				playsound(user, 'sound/voice/roarbark.ogg', 20, 0)
		cooldown = TRUE
		addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 5 SECONDS, TIMER_DELETE_ME)
	return ..()

/obj/item/toy/plushie/dragon/green
	name = "green dragon plushie"
	icon_state = "greendragon"

/obj/item/toy/plushie/dragon/purple
	name = "purple dragon plushie"
	icon_state = "purpledragon"

/obj/item/toy/plushie/dragon/white_east
	name = "white eastern dragon plushie"
	icon_state = "whiteeasterndragon"

/obj/item/toy/plushie/dragon/red_east
	name = "red eastern dragon plushie"
	icon_state = "redeasterndragon"

/obj/item/toy/plushie/dragon/green_east
	name = "green eastern dragon plushie"
	icon_state = "greeneasterndragon"

/obj/item/toy/plushie/dragon/gold_east
	name = "golden eastern dragon plushie"
	desc = "A soft plushie of a shiny golden dragon. Made of Real* gold!"
	icon_state = "goldeasterndragon"
	pokephrase = "Rawr~!"

/obj/item/toy/plushie/teppi
	name = "teppi plushie"
	desc = "A soft, fluffy plushie made out of real teppi fur!"
	icon = 'icons/obj/toy_ch.dmi'
	icon_state = "teppi"
	pokephrase = "Gyooooooooh!"

/obj/item/toy/plushie/teppi/alt
	name = "teppi plush"
	desc = "No teppi were harmed in the creation of this plushie."
	icon_state = "teppialt"

/obj/item/toy/plushie/teppi/attack_self(mob/user as mob)
	if(user.a_intent == I_HURT || user.a_intent == I_GRAB)
		playsound(user, 'sound/voice/teppi/roar.ogg', 10, 0)
	else
		var/teppi_noise = pick(
			'sound/voice/teppi/whine1.ogg',
			'sound/voice/teppi/whine2.ogg')
		playsound(user, teppi_noise, 10, 0)
		src.visible_message(span_notice("Gyooooooooh!"))
	return ..()

/*
 * Hand buzzer
 */
/obj/item/clothing/gloves/ring/buzzer/toy
	name = "steel ring"
	desc = "Torus shaped finger decoration. It has a small piece of metal on the palm-side."
	icon_state = "seal-signet"
	drop_sound = 'sound/items/drop/ring.ogg'

/obj/item/clothing/gloves/ring/buzzer/toy/Touch(var/atom/A, var/proximity)
	if(proximity && istype(usr, /mob/living/carbon/human))

		return zap(usr, A, proximity)
	return 0

/obj/item/clothing/gloves/ring/buzzer/toy/zap(var/mob/living/carbon/human/user, var/atom/movable/target, var/proximity)
	. = FALSE
	if(user.a_intent == I_HELP && battery.percent() >= 50)
		if(isliving(target))
			var/mob/living/L = target

			to_chat(L, span_warning("You feel a powerful shock!"))
			if(!.)
				playsound(L, 'sound/effects/sparks7.ogg', 40, 1)
				L.electrocute_act(battery.percent() * 0, src)
			return .

	return 0

/obj/item/toy/plushie/customizable
	name = "customizable plushie"
	desc = "You should not be seeing this."
	icon = 'modular_chomp/icons/obj/customizable_plushie.dmi'
	icon_state = "durg_primary"

	var/base = "" // The prefix for the icon state
	var/image/primary = null // The primary part of the plushie
	var/image/secondary = null // The secondary part of the plushie
	var/primary_color = COLOR_WHITE
	var/secondary_color = COLOR_WHITE
	var/list/used_markings = list()

/obj/item/toy/plushie/customizable/Initialize(mapload)
	. = ..()
	icon_state = "[base]_primary"
	primary = image(icon_state = "[base]_primary")
	secondary = image(icon_state = "[base]_secondary")
	primary.color = primary_color
	secondary.color = secondary_color
	update_icon()

/obj/item/toy/plushie/customizable/update_icon()
	cut_overlays()
	add_overlay(used_markings)

/obj/item/toy/plushie/customizable/verb/Customize()

	var/list/pickable_additions = list()
	for(var/I in icon_states(icon))
		if(findtext(I, base) != 0)
			var/image/added_image = image(icon_state = I)
			pickable_additions += added_image
	used_markings = pickable_additions // Placeholder until I manage to find out how to tgui...

	update_icon()

/obj/item/toy/plushie/customizable/dragon
	name = "custom dragon plushie"
	desc = "A customizable plushie, featuring the appearance of a dragon. How cute!"
	base = "durg"
	used_markings = list("durg_w_classic_1", "durg_w_classic_2", "durg_w_classic_misc", "durg_h_classic_1", "durg_h_classic_2") // Placeholder...
