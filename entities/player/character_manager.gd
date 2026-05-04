extends Node2D
class_name character_manager

#signal swapping_character
@onready var character_hud: CanvasLayer = $character_hud
@onready var reward_screen: CanvasLayer = $reward_screen
@onready var replacing_char: CanvasLayer = $replacing_char
const DODGING_ENUM_INDEX = 2

signal healing_pressed_signal

# the scene name of each character
enum characters {blue_knight, yellow_knight, red_knight,pink_knight}

var path := "res://entities/player/character_scenes/"
var icon_path := "res://entities/player/character_icons/"
var menu_icon_path := "res://ui_assets/character_menu_sprite/"
var game_over = false
var swap_lock := false

#needed to fix a bug 
var repeat = 1
# all loaded character nodes gets added to this array
var character_nodes := []

var character_index : int = 0

func _ready() -> void:
	# loads 1 character at random and adds it into array
	var c= reward_screen.pick_random_char()
	load_char(c)
	
func spawn_character(pos : Vector2):
	var character = character_nodes[0]
	character.global_position = pos
	add_child(character)
	move_child(character, 0)
	character.show()



func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("character_change") and game_over == false and not swap_lock:
		#break out if there are no characters to switch
		if character_nodes.size() ==1:
			return
		swap_lock = true
		if get_child(0).state.player_state != DODGING_ENUM_INDEX:
			get_child(0).swap_character()
			$swap_timer.start(get_child(0).stats.swap_dur)
		

func _do_switch(target_character: String = "") -> void:
	
	if character_nodes.size() == 1:
		return
		
	var old_node: main_character = get_child(0)
	var new_node: main_character
	if target_character != "":
		new_node = character_nodes[characters.get(target_character)]
	else:
		new_node = get_next()
	
	new_node.show()
	# transfer the current pos
	new_node.global_position = old_node.global_position
	
	#debug
	# print(character_nodes)
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
	character_hud.switch_cd_bars()

func switch_next() -> void:
	call_deferred("_do_switch")
	
func switch_to(target_character: String) -> void:
	call_deferred("_do_switch", target_character)
	
## Returns Node of next character in the `character_nodes` array.
func get_next() -> main_character:
	#var next_character
	
	#while !next_character:
		#character_index = (character_index + 1) % character_nodes.size()
		#if character_nodes[character_index].is_alive:
			#next_character = character_nodes[character_index]
	#return next_character
	var hold
	hold = character_nodes[0]
	character_nodes.pop_front()
	character_nodes.append(hold)
	return character_nodes[0]
	


#adds character to party when selected in rewards
func _on_new_char_button_pressed() -> void:
	
	#only adds here if < 3 party members, 
	if character_nodes.size() == 3:
		#update the icons that will be shown in the replacement screen
		replacing_char.update_slot_icons(character_nodes)
		return
		
	await reward_screen._on_new_char_button_pressed()
	var c = reward_screen.get_selected_rand_char()
	if character_nodes.size()<3:
		SFX_Manager.play_sound_effect_from_dictionary("sci_fi_select_big")
	load_char(c)



func _on_character_hud_character_removed() -> void:
	for c in character_nodes:
		if c.is_alive == false:
			character_nodes.erase(c)
			
#takes a string and then finds the corresponding scene to load including hud stuff
func load_char(c : String):
	var char_instance : main_character = load(path + c + ".tscn").instantiate()
	var char_icon : CompressedTexture2D = load(icon_path + c + "_icon.png")
	add_child(char_instance)
	character_hud.add_icon(char_icon)
	character_hud.add_hp_bar(char_instance.get_node("Stats").hp)
	character_nodes.append(char_instance)
	character_hud.add_cd_bar(char_instance.get_node("Stats").ability_cd)
	remove_child(char_instance)

func _on_rep_first_slot_pressed() -> void:
	SFX_Manager.play_sound_effect_from_dictionary("sci_fi_select_big")
	#swap characters so that the first char doesnt stay on screen
	Input.action_press("character_change")
	Input.action_release("character_change")
	#timeout needed because otherwise it runs the remove_char before the switch 
	await _do_switch()
	
	character_hud.kill_indexed_character(character_nodes.size()-1)
	character_nodes.remove_at(character_nodes.size()-1)
	var c = reward_screen.get_selected_rand_char()
	load_char(c)
	character_hud.fix_cd_index_replacement()
	character_hud.align_max_cd()
	replacing_char.hide()
	


func _on_rep_second_slot_pressed() -> void:
	SFX_Manager.play_sound_effect_from_dictionary("sci_fi_select_big")
	character_hud.kill_indexed_character(1)
	character_nodes.remove_at(1)
	var c = reward_screen.get_selected_rand_char()
	load_char(c)
	character_hud.fix_cd_index_replacement()
	character_hud.align_max_cd()
	replacing_char.hide()


func _on_rep_third_slot_pressed() -> void:
	SFX_Manager.play_sound_effect_from_dictionary("sci_fi_select_big")
	character_hud.kill_indexed_character(2)
	character_nodes.remove_at(2)
	var c = reward_screen.get_selected_rand_char()
	load_char(c)
	character_hud.fix_cd_index_replacement()
	character_hud.align_max_cd()
	replacing_char.hide()


func _on_heal_button_pressed() -> void:
	SFX_Manager.play_sound_effect_from_dictionary("gem_collect")
	var count = 0
	
	for j in range(character_nodes.size()):
		_do_switch()
	for i in character_nodes:
		
		i.heal_to_full()
		character_hud.set_selected_hp_bar(i.stats.max_hp, count)
		count +=1
	reward_screen.hide()


func _on_swap_timer_timeout() -> void:
	swap_lock = false
	switch_next()
	get_child(0).state.enable_switch()
