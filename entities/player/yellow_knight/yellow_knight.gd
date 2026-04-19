extends main_character
class_name YellowKnight

@onready var attack_box := $AttackBox
@onready var animplayer := $AttackBox/PlaceholderPlayer



func _ready() -> void:
	attack_box.monitoring = false
	pass # Replace with function body.

func fire_gun(target: Vector2) -> void:
	attack_cooldown = true
	attack_timer.start(stats.fire_cd)
	animplayer.play("attackbox")
	
func character_ability() -> void:
	pass
