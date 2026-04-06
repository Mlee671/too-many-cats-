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
	# loads all character nodes and adds them into an array
	for c in characters:
		character_scenes.append(load(path + c + ".tscn").instantiate())
	pass
	
func switch():
	call_deferred("_do_switch_next")
	
func _do_switch_next():
	var old_node = get_parent().get_node("character_slot")
	var new_node = switch_next()
	var parent = old_node.get_parent()
	
	new_node.global_position = old_node.global_position
	
	parent.add_child(new_node)
	parent.move_child(new_node, old_node.get_index())
	parent.remove_child(old_node)
	
	new_node.name = "character_slot"
	

	
# returns the scene of the next character
func switch_next():
	character_index += 1
	if character_index == characters.size():
		character_index = 0

	return	character_scenes[character_index]
