extends Node2D
class_name character_manager

signal swapping_character
@onready var character_hud: CanvasLayer = $character_hud


# the scene name of each character
enum characters {blue_knight, yellow_knight}

var path := "res://entities/player/character_scenes/"
var icon_path := "res://entities/player/character_icons/"

# all loaded character nodes gets added to this array
var character_nodes := []

var character_index : int = 0

func _ready() -> void:
	# loads all character nodes and icons then adds them into an array
	for c in characters:
		var char_instance : main_character = load(path + c + ".tscn").instantiate()
		var char_icon : CompressedTexture2D = load(icon_path + c + "_icon.png")
		character_hud.add_icon(char_icon)
		character_hud.add_hp_bar(char_instance.get_node("Stats").hp)
		character_nodes.append(char_instance)

func spawn_character(pos : Vector2):
	var character = character_nodes[0]
	add_child(character)
	move_child(character, 0)
	character.global_position = pos


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("character_change"):
		get_child(0).swap_character()
		switch_next()

func _do_switch(target_character: String = "") -> void:
	var old_node: main_character = get_child(0)
	var new_node: main_character
	if target_character != "":
		new_node = character_nodes[characters.get(target_character)]
	else:
		new_node = get_next()
	
	# transfer the current pos
	new_node.global_position = old_node.global_position
	
	# replace instances - swap characters
	add_child(new_node)
	move_child(new_node, 0)
	remove_child(old_node)
	
	# maintain speed - should not exceed character's maximum
	var direction := old_node.velocity.normalized()
	var speed: float = min(old_node.velocity.length(), new_node.stats.speed)
	new_node.velocity = direction * speed
	
	#switches the character hp bars and icons to the next in line
	character_hud.switch_hp_bars()
	character_hud.switch_icon()
	

func switch_next() -> void:
	call_deferred("_do_switch")
	
func switch_to(target_character: String) -> void:
	call_deferred("_do_switch", target_character)
	
## Returns Node of next character in the `character_nodes` array.
func get_next() -> main_character:
	var next_character
	while !next_character:
		character_index = (character_index + 1) % characters.size()
		if character_nodes[character_index].is_alive:
			next_character = character_nodes[character_index]
	return next_character
	
