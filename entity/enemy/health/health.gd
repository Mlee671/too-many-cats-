extends Node

signal death

@export var max_health: int
var current_health := max_health

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_kill_enemy"):
		death.emit()

func _on_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		death.emit()

func _on_heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
