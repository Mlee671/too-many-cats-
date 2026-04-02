class_name Entity
extends CharacterBody2D
## General superclass Entity for players, enemies, and similar.

# Notes for Subclassing:
#
# Required to overwrite/initialise:
# speed: int variable, top speed of entity
# acceleration: int variable, smoothness of movement
# get_move_direction: func returning Vector2, entity movement direction
# health.set_health(value): setter for health value and max-hp
#
# Other stuff to setup
# char_animation (AnimatedSprite2D): should have following animations:
#   - "idle"
#   - "moving"
#   - "death" (idk if ideal for one-shot)

signal heal
signal damaged

@onready var animation := $flippable/char_animation

@onready var health := $HealthComponent

# should be set in subclass
var speed: int
var acceleration: int
var can_move := true

func _ready() -> void:
	animation.play("idle")

# cannot be abstract, annoyingly enough.
func get_move_direction() -> Vector2:
	push_error("get_move_direction must be overwritten in subclass.")
	return Vector2.ZERO

func move(delta: float) -> void:
	if can_move:
		var vector_move = get_move_direction()
		# if not moving, idle animation
		if vector_move == Vector2.ZERO:
			animation.play("idle")
		else:
			animation.play("moving")
		
		# apply speed and move
		velocity = lerp(velocity, vector_move * speed, acceleration * delta)
		move_and_slide()

## Base Entity on_death function, play death animation and delete self.
func _on_death() -> void:
	can_move = false
	animation.play("death")
	await animation.animation_finished
	queue_free()
