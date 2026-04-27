extends Area2D
class_name Attack

var damage = 10
@onready var attackbox := $AttackRect

func _ready() -> void:
	toggle_disable(true)

func deal_damage() -> int:
	toggle_disable(true)
	return damage

func toggle_disable(state : bool):
	attackbox.call_deferred("set_disabled", state)
	
