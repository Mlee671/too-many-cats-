extends CanvasLayer
@onready var first_hp_bar: TextureProgressBar = $Control/first_hp_bar
@onready var second_hp_bar: TextureProgressBar = $Control/second_hp_bar
@onready var first_char: TextureRect = $Control/first_char
@onready var second_char: TextureRect = $Control/second_char


var hp_bars = [0,0]
var icons_array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	first_hp_bar.value = hp_bars[0]
	second_hp_bar.value = hp_bars[1]
	first_char.texture = icons_array[0]
	second_char.texture = icons_array[1]
	

#sets amount of hp remaining for the character currently in use
func set_main_hp_bar(amount: float) -> void:
	hp_bars[0] = amount
	
	
func switch_hp_bars() -> void:
	#left shifts the hp array
	var hold
	hold = hp_bars[0]
	hp_bars.pop_front()
	hp_bars.append(hold)
	
func add_icon(icon: CompressedTexture2D):
	icons_array.append(icon)
	
	
	
