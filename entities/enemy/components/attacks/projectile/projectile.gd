extends Area2D
class_name Projectile

@onready var lifespan := $Timer

var velocity := Vector2.ZERO
var damage := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifespan.start(10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if body is not main_character:
		queue_free()
	else:
		queue_free()
		body.take_damage(damage)


func _on_end_lifespan() -> void:
	queue_free()


func set_velocity(new_velocity: Vector2):
	velocity = new_velocity
	#start animation, effect, etc. if required
