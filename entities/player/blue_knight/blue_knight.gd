extends main_character
class_name blue_knight

@onready var nav_agent := $NavigationAgent2D



func character_ability():
	nav_agent.target_position = get_global_mouse_position()
	# go to final calculated path node
	global_position = nav_agent.get_final_position()
