extends Node

signal death

var max_health: int
var health_points: int

func set_health(max_hp: int):
	## Initial setup of health, setting max hp and current health to max.
	max_health = max_hp
	health_points = max_hp

func _on_heal(healing_amount: int) -> void:
	health_points = min(health_points + healing_amount, max_health)

func _on_damaged(damage_amount: int) -> void:
	health_points -= damage_amount
	if health_points <= 0:
		emit_signal("death")
