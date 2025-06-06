/datum/robot_sprite/dogborg/explorer
	module_type = "Exploration"
	sprite_icon = 'icons/mob/robot/widerobot/widerobot_exp.dmi'
	sprite_hud_icon_state = "platform"

/datum/robot_sprite/dogborg/explorer/vale2
	name = "Explorationhound V2"
	sprite_icon_state = "exploration-v2"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/explorer/vale
	name = "Explorationhound V2 - Pink"
	sprite_icon_state = "exploration"
	has_eye_light_sprites = TRUE

/datum/robot_sprite/dogborg/tall/explorer/dullahan
	module_type = "Exploration"
	sprite_icon = 'icons/mob/robot/dullahan/v1/dullahan_explorer.dmi'

/datum/robot_sprite/dogborg/tall/explorer/dullahan/explorer
	name = "Dullahan"
	sprite_icon_state = "dullahanexplo"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")
	sprite_decals = list("breastplate","loincloth","eyecover")
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/tall/explorer/bulwark
	name = "Bulwark"
	sprite_icon = 'icons/mob/robot/tallrobot/tallrobots.dmi'
	sprite_icon_state = "bulwark"
	has_eye_light_sprites = FALSE
	rest_sprite_options = list("Default")
	icon_x = 32
	pixel_x = 0

/datum/robot_sprite/dogborg/explorer/smolraptor
	sprite_icon = 'icons/mob/robot/smallraptors/smolraptor_ninja.dmi'
	name = "Small Raptor"
	sprite_icon_state = "smolraptor"
	has_eye_light_sprites = TRUE
	has_vore_belly_sprites = TRUE
	has_dead_sprite_overlay = FALSE
	rest_sprite_options = list("Default", "Sit", "Bellyup")

/* placeholder
/datum/robot_sprite/dogborg/tall/explorer
	module_type = "Exploration"
	sprite_icon = 'icons/mob/robot/tallrobot/tallrobots.dmi'
	pixel_x = 0

/datum/robot_sprite/dogborg/raptor/explorer
	module_type = "Exploration"
	sprite_icon = 'icons/mob/robot/raptor.dmi'

/datum/robot_sprite/dogborg/raptor/explorer/raptor
	name = "Raptor"
	sprite_icon_state = "chraptor"
	has_custom_equipment_sprites = TRUE
	rest_sprite_options = list("Default", "Bellyup")

/datum/robot_sprite/dogborg/tall/explorer/meka
	name = "MEKA"
	sprite_icon_state = "mmekaunity"
	has_eye_light_sprites = TRUE
	has_custom_open_sprites = TRUE
	has_vore_belly_sprites = TRUE
	rest_sprite_options = list("Default", "Sit")
*/
