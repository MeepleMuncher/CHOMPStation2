////////////////////////////
//		Artificer
////////////////////////////

/mob/living/simple_mob/construct/artificer
	name = "Artificer"
	real_name = "Artificer"
	construct_type = "artificer"
	desc = "A bulbous construct dedicated to building and maintaining temples to their otherworldly lords."
	//icon = 'icons/mob/mob.dmi'	//CHOMPEdit
	icon_state = "artificer"
	icon_living = "artificer"
	maxHealth = 100	//CHOMPEdit - Adjusting values since they have AI now
	health = 100	//CHOMPEdit
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	melee_damage_lower = 15 //It's not the strongest of the bunch, but that doesn't mean it can't hurt you.
	melee_damage_upper = 20
	organ_names = /decl/mob_organ_names/artificer
	attacktext = list("rammed")
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/aoe_turf/conjure/construct/lesser,
							/spell/aoe_turf/conjure/wall,
							/spell/aoe_turf/conjure/floor,
							/spell/aoe_turf/conjure/soulstone,
							/spell/aoe_turf/conjure/pylon,
							/spell/aoe_turf/conjure/door,
							/spell/aoe_turf/conjure/grille,
							/spell/targeted/occult_repair_aura,
							/spell/targeted/construct_advanced/mend_acolyte
							)

/decl/mob_organ_names/artificer
	hit_zones = list("body", "carapace", "right manipulator", "left manipulator", "upper left appendage", "upper right appendage", "eye")
