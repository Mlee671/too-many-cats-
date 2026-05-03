extends main_character
class_name RedKnight

const GRENADE := preload("res://entities/player/attacks/explosive/explosive.tscn")
const GRENADE_OFFSET := 15

func character_ability():
	#super()
	Sfx_Manager.play_sound_effect_from_dictionary("throw")
	var proj = GRENADE.instantiate()
	var direction = get_local_mouse_position().normalized()
	
	proj.global_position = $AttackMarker.global_position + (GRENADE_OFFSET * direction)
	proj.set_direction(direction)
	
	get_parent().add_child(proj)
