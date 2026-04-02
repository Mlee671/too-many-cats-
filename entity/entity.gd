@abstract
class_name Entity
extends CharacterBody2D

# abstract - should be overridden
var speed: int
var acceleration: int

func _ready() -> void:
	pass

@abstract
func get_move_direction() -> Vector2

func move(delta: float) -> void:
	velocity = lerp(velocity, get_move_direction() * speed, acceleration * delta)
	move_and_slide()
	
