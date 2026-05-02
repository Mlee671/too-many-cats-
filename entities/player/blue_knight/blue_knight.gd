extends main_character
class_name blue_knight

@onready var nav_agent := $NavigationAgent2D



func character_ability():
	super()
	print(stats.ability_dur/2.0)
	await get_tree().create_timer(stats.ability_dur/2.0).timeout
	nav_agent.target_position = get_global_mouse_position()
	# go to final calculated path node
	global_position = nav_agent.get_final_position()
