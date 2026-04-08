extends Node

signal death

@export var max_health: int
var current_health: int

func set_health(amount: int):
	max_health = amount
	current_health = amount

# Can be removed when debug key is no longer needed
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_kill_enemy"):
		death.emit()

func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		death.emit()

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
