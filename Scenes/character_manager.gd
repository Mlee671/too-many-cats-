extends Node
class_name character_manager

# the scene name of each character
enum characters {blue_knight, yellow_knight}

const NAME_OF_NODE = "character_slot"

var path := "res://entity/character_scenes/"

# all loaded character nodes gets added to this array
var character_nodes := []

var character_index : int = 0

# the current character node


func _ready() -> void:
	# loads all character nodes and adds them into an array
	for c in characters:
		character_nodes.append(load(path + c + ".tscn").instantiate())
	pass
	
func switch_next():
	call_deferred("_do_switch", "")
	
func switch_to(target_character: String):
	call_deferred("_do_switch", target_character)
	pass
	
func _do_switch(target_character: String):
	var old_node = get_parent().get_node(NAME_OF_NODE)
	var new_node
	if target_character != "":
		new_node = character_nodes[characters.get(target_character)]
	else:
		new_node = get_next()
	var parent = old_node.get_parent()
	new_node.name = "character_slot"
	
	# transfer the current pos
	new_node.global_position = old_node.global_position
	
	parent.add_child(new_node)
	parent.move_child(new_node, old_node.get_index())
	parent.remove_child(old_node)
	
	new_node.name = NAME_OF_NODE
	
# returns the node of the next character
func get_next():
	character_index += 1
	if character_index == characters.size():
		character_index = 0

	return	character_nodes[character_index]
	
