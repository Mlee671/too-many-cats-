class_name Entity
extends CharacterBody2D
## General superclass Entity for players, enemies, and similar.

# Required to overwrite/initialise:
# speed: int variable, top speed of entity
# acceleration: int variable, smoothness of movement
# get_move_direction: func returning Vector2, entity movement direction

# Other stuff to setup
# char_animation (AnimatedSprite2D): should have animations named "idle" and "moving"

# should be set in subclass
var speed: int
var acceleration: int

@onready var animation := $flippable/char_animation

func _ready() -> void:
	animation.play("idle")

# cannot be abstract, annoyingly enough.
## Should bind variabled `speed` and `acceleration`.
func get_move_direction() -> Vector2:
	push_error("get_move_direction must be overwritten in subclass.")
	return Vector2.ZERO

func move(delta: float) -> void:
	var vector_move = get_move_direction()
	# if not moving, idle animation
	if vector_move == Vector2.ZERO:
		animation.play("idle")
	else:
		animation.play("moving")
	
	# apply speed and move
	velocity = lerp(velocity, vector_move * speed, acceleration * delta)
	move_and_slide()
	
