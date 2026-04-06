extends Node2D

@onready var cm:=$character_manager


func switch():
	call_deferred("_do_switch_next")

# gets the the current character node, create by instantiating the returned from switch_next
func _do_switch_next():
	var old_node = get_node("character_slot")
	var new_node = cm.switch_next().instantiate()
	var parent = old_node.get_parent()
	
	new_node.global_position = old_node.global_position
	
	parent.add_child(new_node)
	parent.move_child(new_node, old_node.get_index())
	parent.remove_child(old_node)
	
	new_node.name = "character_slot"
	old_node.queue_free()
	
