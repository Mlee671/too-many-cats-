extends Node2D
class_name Slash

@onready var lifespan := $Timer
@onready var hitbox := $AttackArea

var damage := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifespan.start(0.5)


func _on_end_lifespan() -> void:
	queue_free()


func _on_hit_player(body: Node2D) -> void:
	if body is not main_character:
		queue_free() # what did i hit?
	else:
		body.take_damage(damage)
		hitbox.queue_free()
