extends CanvasLayer
@onready var first_hp_bar: TextureProgressBar = $Control/first_hp_bar
@onready var second_hp_bar: TextureProgressBar = $Control/second_hp_bar

var hp_bars = [0,0,0]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	first_hp_bar.value = hp_bars[0]
	second_hp_bar.value = hp_bars[1]

#sets the hp bar for the character currently in use
func set_main_hp_bar(amount: float) -> void:
	hp_bars[0] = amount
	
	

	
		
