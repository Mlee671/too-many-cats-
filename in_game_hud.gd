extends CanvasLayer
@onready var first_hp_bar: TextureProgressBar = $Control/first_hp_bar
@onready var second_hp_bar: TextureProgressBar = $Control/second_hp_bar
@onready var first_char: TextureRect = $Control/first_char
@onready var second_char: TextureRect = $Control/second_char
@onready var third_char: TextureRect = $Control/third_char
@onready var third_hp_bar: TextureProgressBar = $Control/third_hp_bar

var dead = false
var hp_bars = []
var icons_array = []
var visibility = [0,0,0]




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#updates the current top left hud continuously
func _process(_delta: float) -> void:

	var size = hp_bars.size()

	first_hp_bar.value = hp_bars[0]
	first_char.texture = icons_array[0]
	if size >= 2:
		second_hp_bar.value = hp_bars[1]
		second_char.texture = icons_array[1]
	if size == 3:
		third_hp_bar.value = hp_bars[2]
		third_char.texture = icons_array[2]
		
	

func add_hp_bar(starting_hp : float):
	hp_bars.append(starting_hp)	
	
#sets amount of hp remaining for the character currently in use
func set_main_hp_bar(max_hp: float, current_hp: float) -> void:
	
	hp_bars[0] = current_hp/max_hp *100
	
	
func switch_hp_bars() -> void:
	#left shifts the hp array
	var hold
	hold = hp_bars[0]
	hp_bars.pop_front()
	hp_bars.append(hold)
	
#adds icons to the array. 
func add_icon(icon: CompressedTexture2D):
	icons_array.append(icon)
	
func switch_icon()-> void:
	#left shifts the icons array
	var hold
	hold = icons_array[0]
	icons_array.pop_front()
	icons_array.append(hold)

#removes the character icon and hp bar
func remove_char(position:int):
	icons_array.remove_at(position)
	hp_bars.remove_at(position)
	
	#removes the hp bars with no character associated to them anymore
	third_char.texture = null
	third_hp_bar.value = 0
	
	if hp_bars.size() == 1:
		second_char.texture = null
		second_hp_bar.value = 0
		
func kill_first_char():
	if self.hp_bars.size() == 1:
		self.hide()
		self.PROCESS_MODE_DISABLED
		emit_signal("all_char_dead")
		var scene : PackedScene = load("res://main_menu/main_menu.tscn")
		print("all characters dead")
		
		
		$"../../fade_transition".show()
		$"../../fade_transition/AnimationPlayer".play("fade_in")
		await get_tree().create_timer(1.2).timeout
		await get_tree().process_frame
		get_tree().change_scene_to_packed(scene)
		return

	Input.action_press("character_change")
	Input.action_release("character_change")
	#timeout needed because otherwise it runs the remove_char before the switch 
	await get_tree().create_timer(0.2).timeout
	self.remove_char(hp_bars.size()-1)
