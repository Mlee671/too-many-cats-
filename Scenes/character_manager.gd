extends Node
class_name character_manager

# the scene name of each character
enum characters {blue_knight, yellow_knight}

var path := "res://entity/character_scenes/"

# all loaded character nodes gets added to this array
var character_scenes := []

var character_index : int = 0

# the current character node


func _ready() -> void:
	# loads all character scenes and adds them into an array
	for c in characters:
		character_scenes.append(load(path + c + ".tscn"))
		pass
	pass
	
# returns the scene of the next character
func switch_next():
	character_index += 1
	if character_index == characters.size():
		character_index = 0

	return	character_scenes[character_index]
