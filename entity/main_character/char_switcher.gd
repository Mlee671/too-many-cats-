extends Node
class_name Char_switcher

var char_array : Array = []
var current_char : int = 0

var speed : int
var accel : int

var evade : float
var evade_dur : float
var evade_cd : float

var fire_cd : float

func _ready() -> void:
	_load_selection()
	_load_stats()
	
func _load_selection():
	char_array = []
	for child in get_children():
		char_array.append(child)
	current_char = 0
	
func change_char() -> Texture2D:
	current_char += 1
	if current_char >= char_array.size():
		current_char = 0
	_load_stats()
	return char_array[current_char].BASE_SPRITE

func _load_stats():
	var temp = char_array[current_char]
	speed = temp.SPEED
	accel = temp.ACCEL_SMOOTH
	evade = temp.EVADE_MOVEMENT_SCALING
	evade_dur = temp.EVADE_DURATION
	evade_cd = temp.EVADE_COOLDOWN
	fire_cd = temp.FIRE_COOLDOWN

func get_sprite(type : String) -> Texture2D:
	if type == "dodge":
		return char_array[current_char].DODGE_SPRITE
	else:
		return char_array[current_char].BASE_SPRITE
