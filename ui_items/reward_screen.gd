extends CanvasLayer
# the scene name of each character
enum characters {blue_knight, yellow_knight, red_knight,pink_knight}

@onready var new_char_button: TextureButton = $Control/TextureRect/new_char_button
@onready var replacing_char: CanvasLayer = $"../replacing_char"

var path := "res://entities/player/character_scenes/"
var menu_path := "res://ui_assets/character_menu_sprite/"



var chars_remaining = []
var current_char 

var party_full = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in characters:
		chars_remaining.append(c)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#opens the reward screen and picks a random character that hasnt been picked yet
	if Input.is_action_just_pressed("debug_open_reward_screen"):
		
		self.show()
		#checks if user party is full to open replacing screen
		if get_parent().character_nodes.size() == 3:
			party_full = true
		else:
			party_full = false
		#decides what character is offered that hasnt already been offered
		if chars_remaining.size() !=0:
			current_char = pick_random_char()
			var char_menu : CompressedTexture2D = load(menu_path + current_char + "_menu.png")
			new_char_button.texture_normal = char_menu
		else:
			#replace image with x if no characters left.
			var x : CompressedTexture2D = load("res://ui_assets/x_button.png")
			new_char_button.texture_normal = x
			new_char_button.disabled = true
			


func _on_new_char_button_pressed() -> void:
	
	if party_full:
		replacing_char.show()
		
	self.hide()
	chars_remaining.erase(current_char)

func get_selected_rand_char() ->String:
	return current_char
	
func pick_random_char() -> String:
	current_char = chars_remaining.pick_random()
	chars_remaining.erase(current_char)
	return current_char
	
