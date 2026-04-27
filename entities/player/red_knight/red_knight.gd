extends main_character
class_name RedKnight

const grenade := preload("res://entities/player/attacks/explosive/explosive.tscn")

func character_ability():
	var proj = grenade.instantiate()
	var direction = get_local_mouse_position().normalized()
	
	proj.global_position = global_position
	proj.set_direction(direction)
	
	get_parent().add_child(proj)
