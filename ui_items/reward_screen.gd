extends CanvasLayer
# the scene name of each character
enum characters {blue_knight, yellow_knight, red_knight,pink_knight}

@onready var new_char_button: TextureButton = $Control/TextureRect/new_char_button

var path := "res://entities/player/character_scenes/"
var menu_path := "res://ui_assets/character_menu_sprite/"



var chars_remaining = []
var current_char 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in characters:
		chars_remaining.append(c)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#opens the reward screen and picks a random character that hasnt been picked yet
	if Input.is_action_just_pressed("debug_open_reward_screen"):
		self.show()
		current_char = pick_random_char()
		var char_menu : CompressedTexture2D = load(menu_path + current_char + "_menu.png")
		new_char_button.texture_normal = char_menu


func _on_new_char_button_pressed() -> main_character:
	var char_instance : main_character = load(path + current_char + ".tscn").instantiate()
	self.hide()
	chars_remaining.erase(current_char)
	return char_instance

func pick_random_char() -> String:
	current_char = chars_remaining.pick_random()
	chars_remaining.erase(current_char)
	return current_char
	
