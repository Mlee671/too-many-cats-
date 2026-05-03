extends Projectile

@onready var raycast := $RayCast2D

func set_velocity(new_velocity: Vector2):
	velocity = new_velocity
	

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	raycast.target_position = global_position + velocity.normalized() * (velocity.length() * delta)

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer: # hitting wall
		var norm : Vector2 = raycast.get_collision_normal()
		velocity = velocity.bounce(norm)
		#global_position += norm * 0.5
