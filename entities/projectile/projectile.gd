extends Area2D
class_name Projectile

@onready var lifespan := $Timer

# should be changed in instantiating
var velocity := Vector2.ZERO
var damage := 10
var knockback := 10

func _ready() -> void:
	lifespan.start(10)
	# subclass should have setters here


func _physics_process(delta: float) -> void:
	global_position += velocity * delta

# collision logic
func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer: # hitting wall
		queue_free()

func _on_end_lifespan() -> void:
	queue_free()

func set_velocity(new_velocity: Vector2):
	velocity = new_velocity
	#start animation, effect, etc. if required

func set_damage(new_damage: int):
	damage = new_damage
