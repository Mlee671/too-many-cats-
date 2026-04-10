extends CanvasLayer

@onready var character_hp_bar: TextureProgressBar = $Control/character_hp_bar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_slot_taken_damage(amount: Variant) -> void:
	character_hp_bar.value -= amount
