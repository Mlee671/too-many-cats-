extends Area2D
class_name Projectile

@onready var lifespan := $Timer

var velocity := Vector2.ZERO
var damage := 10
var knockback := 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifespan.start(10)

# queue free resolves after damage is returned
func deal_damage() -> int:
	queue_free()
	return damage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += velocity * delta

# terrain collision logic
func _on_body_entered(body: Node2D) -> void:
	if body is not Enemy and body is not main_character:
		queue_free()
	else:
		body.take_damage(damage, self, knockback)
		queue_free()

func _on_end_lifespan() -> void:
	queue_free()

func set_velocity(new_velocity: Vector2):
	velocity = new_velocity
	#start animation, effect, etc. if required
