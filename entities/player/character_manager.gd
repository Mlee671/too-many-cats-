extends Node
class_name character_manager

signal swapping_character

# the scene name of each character
enum characters {blue_knight, yellow_knight}

const NAME_OF_NODE := "character_slot"

var path := "res://entities/player/character_scenes/"

# all loaded character nodes gets added to this array
var character_nodes := []

var character_index : int = 0

func _ready() -> void:
	# loads all character nodes and adds them into an array
	for c in characters:
		var char_instance : main_character = load(path + c + ".tscn").instantiate()
		character_nodes.append(char_instance)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("character_change"):
		swapping_character.emit()
		switch_next()

func _do_switch(target_character: String = "") -> void:
	var old_node: main_character = get_parent().get_node(NAME_OF_NODE)
	var new_node: main_character
	if target_character != "":
		new_node = character_nodes[characters.get(target_character)]
	else:
		new_node = get_next()
	
	# transfer the current pos
	new_node.global_position = old_node.global_position
	
	var parent = old_node.get_parent()
	# move receiver of the swapping signal (preventing state carryover, ideally)
	if swapping_character.is_connected(old_node._on_swapping_character):
		swapping_character.disconnect(old_node._on_swapping_character)
	swapping_character.connect(new_node._on_swapping_character)
	
	# replace instances - swap characters
	parent.add_child(new_node)
	parent.move_child(new_node, old_node.get_index())
	parent.remove_child(old_node)
	new_node.name = NAME_OF_NODE
	
	# maintain speed - should not exceed character's maximum
	var direction := old_node.velocity.normalized()
	var speed: float = min(old_node.velocity.length(), new_node.stats.speed)
	new_node.velocity = direction * speed

func switch_next() -> void:
	call_deferred("_do_switch")
	
func switch_to(target_character: String) -> void:
	call_deferred("_do_switch", target_character)
	
## Returns Node of next character in the `character_nodes` array.
func get_next() -> main_character:
	character_index = (character_index + 1) % characters.size()
	return character_nodes[character_index]
	
