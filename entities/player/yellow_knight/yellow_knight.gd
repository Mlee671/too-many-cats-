extends main_character
class_name YellowKnight

@onready var attack_box := $AttackBox
@onready var animplayer := $AttackBox/PlaceholderPlayer

func _ready() -> void:
	attack_box.monitorable = false
	pass # Replace with function body.

func fire_gun(target: Vector2) -> void:
	animplayer.play("attackbox")
	
func character_ability() -> void:
	pass
