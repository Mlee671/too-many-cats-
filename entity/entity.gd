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

func move(direction: Vector2, delta: float) -> void:
	velocity = lerp(velocity, direction * speed, acceleration * delta)
	move_and_slide()

func _physics_process(delta: float) -> void:
	move(get_move_direction(), delta)
	
